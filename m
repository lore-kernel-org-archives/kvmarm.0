From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v6 0/7] Add RAS virtualization support for SEA/SEI
 notification type in KVM
Date: Mon, 4 Sep 2017 19:10:27 +0800
Message-ID: <61d15c7d-803b-15b2-78e1-637fdb9396d6@huawei.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
 <59A84ACB.7030808@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <59A84ACB.7030808@arm.com>
Sender: kvm-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, mst@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi James

On 2017/9/1 1:43, James Morse wrote:
> Hi Dongjiu Geng,
> 
> On 28/08/17 11:38, Dongjiu Geng wrote:
>> In the firmware-first RAS solution, corrupt data is detected in a
>> memory location when guest OS application software executing at EL0
>> or guest OS kernel El1 software are reading from the memory. The
>> memory node records errors in an error record accessible using
>> system registers.
>>
>> Because SCR_EL3.EA is 1, then CPU will trap to El3 firmware, EL3
>> firmware records the error to APEI table through reading system
>> register.
> 
> Strictly speaking these are CPER records in a memory region pointed to by the
> HEST->GHES ACPI table.
yes, Here I mean EL3 firmware reads the RAS Error record register ERXxxx_EL1, such as
ERXADDR_EL1/ERXMISC0_EL1, to get the detailed error info, then record them to
HEST->GHES ACPI table in a memory region.

> 
> 
>> Because the error was taken from a lower Exception level, if the
>> exception is SEA/SEI and HCR_EL2.TEA/HCR_EL2.AMO is 1, firmware
>> sets ESR_EL2/FAR_EL2 to fake a exception trap to EL2, then
>> transfers to hypervisor.
> 
> What happens if you took an SError from EL2 and EL2 has PSTATE.A set masking
> SError? (this is very common today: all kernel code runs like this).
Firstly, the guest OS usually runs in the El1 or El0, not El2.
if El2 happens an SError, it will trap to EL3 firmware even though the PSTATE.A is set.
Because the PSTATE.A can not mask it if the SError is trapped to EL3.

> 
> What happens if the hypervisor then executes an ESB with PSTATE.A set? It
> expects to see any pending SError deferred and its syndrome written to DISR_EL1,
> but this register is RAZ/WI when you set SCR_EL3.EA. '4.4.2' of [0]
>From my understand, if the SCR_EL3.EA is set, the Abort can not mask, it always happen and
take to EL3, DISR_El1 can not record the syndrome. DISR_El1 is only recorded when
the External Abort is masked, but when SCR_EL3.EA is set, the pstate.A can not mask the Error.


> 
> 
>> For the synchronous external abort(SEA), Hypervisor calls the
>> ghes_handle_memory_failure() to deal with this error,
>> ghes_handle_memory_failure() function reads the APEI table and 
>> callls memory_failure() to decide whether it needs to deliver
>> SIGBUS signal to user space, the advantage of using SIGBUS signal
>> to notify user space is that it can be compatible with Non-Kvm users.
>>
>> For the SError Interrupt(SEI),KVM firstly classified the error.
> 
> KVM can't parse the CPER records, nor does it know where to look to find them.
> KVM should call out to the APEI code so the host kernel can handle the error.
KVM does not parse the CPER records, I mean KVM classified the error according to the esr_el2.AET.

As shown below:

AET, bits [12:10], when categorized
Asynchronous Error Type. Describes the state of the PE after taking the SError interrupt exception.
Software might use the information in the syndrome registers to determine what recovery might be
possible. See Architecturally consumed errors. The possible values of this field are:
0b000 Uncontainable error (UC).
0b001 Unrecoverable error (UEU).
0b010 Restartable error (UEO).
0b011 Recoverable error (UER).
0b110 Corrected error (CE).

I pasted the code here:
+static int kvm_handle_guest_sei(struct kvm_vcpu *vcpu)
+{
+	unsigned int esr = kvm_vcpu_get_hsr(vcpu);
+	bool impdef_syndrome =  esr & ESR_ELx_ISV;	/* aka IDS */
+	unsigned int aet = esr & ESR_ELx_AET;
+
+	/*
+	 * In below three conditions, it will directly inject the virtual SError.
+	 * 1. Not support RAS extension; the Syndrome is IMPLEMENTATION DEFINED;
+	 * AET is RES0 if 'the value returned in the DFSC field is not
+	 * [ESR_ELx_FSC_SERROR]'
+	 */
+	if (!cpus_have_const_cap(ARM64_HAS_RAS_EXTN) || impdef_syndrome ||
+			((esr & ESR_ELx_FSC) != ESR_ELx_FSC_SERROR)) {
+		kvm_inject_vabt(vcpu);
+		return 1;
+	}
+
+	switch (aet) {
+	case ESR_ELx_AET_CE:	/* corrected error */
+	case ESR_ELx_AET_UEO:	/* restartable error, not yet consumed */
+		return 0;	/* continue processing the guest exit */
+	case ESR_ELx_AET_UEU:  /* The error has not been propagated */
+	/*
+	 * Only handle the guest user mode SEI if the error has not been propagated
+	 */
+	if ((!vcpu_mode_priv(vcpu)) && !handle_guest_sei(kvm_vcpu_get_hsr(vcpu)))
+		return 1;
+
+	/* If SError handling is failed, continue run */
+	default:
+		/*
+		 * Until now, the CPU supports RAS and SEI is fatal, or user space
+		 * does not support to handle the SError.
+		 */
+		panic("This Asynchronous SError interrupt is dangerous, panic");
+	}
+}
+

I have called the kernel code to handle the SError.

+/*
+ * Handle SError interrupt that occur in guest OS.
+ *
+ * The return value will be zero if the SEI was successfully handled
+ * and non-zero if handling is failed.
+ */
+int handle_guest_sei(unsigned int esr)
+{
+	int ret = 0;
+
+	struct siginfo info;
+
+	pr_alert("Asynchronous SError interrupt detected on CPU: %d, esr: %x\n",
+		smp_processor_id(), esr);
+
+	info.si_signo = SIGBUS;
+	info.si_errno = 0;
+	info.si_code  = BUS_MCEERR_AR;
+	/*
+	 * Because the address is not accurate for Asynchronous Aborts, so set
+	 * NULL for the fault address
+	 */
+	info.si_addr = NULL;
+
+	ret = force_sig_info(SIGBUS, &info, current);
+	if (ret < 0)
+		pr_info("Handle guest SEI: Error sending signal to %s:%d: %d\n",
+			current->comm, current->pid, ret);
+	else
+		ret = 0;
+
+	 return ret;
+}
+

> 
> User-space may be signalled by the memory_failure() helper, and user-space may
> choose to notify the guest about the memory-failure, but this would be a new error.
For the SError, it is asynchronous abort. so it is not better to call memory_failure() helper, because the error
address is not accurate. memory_failure() will offline or poison the address, but the address is not accurate. so it is
dangerous

> 
> 
>> Not call memory_failure() to handle it. Because the error address recorded
>> by APEI is not accurated, so can not identify the address to hwpoison
>> memory.
> 
> This looks like a firmware bug, what address do you get in your CPER records? It
> should be a physical address.
No, not firmware bug. At least in the armv8.0 CPU and huawei's armv8.2 CPU, the architecture
decided it is not accurate, this abort is asynchronous not synchronous.


> 
> To report a memory-error you must have an address.
maybe we can not get the accurate error address, can you get it in your armv8 platform?

> 
> If the error wasn't detected as a synchronous access then delivering a
> synchronous-external-abort is inappropriate (I think we both agree on this), and
> SError-interrupt doesn't have a way of specifying an address ... but the CPER
> records do.
In our platform, the physical address in CPER records also does not accurate for SEI. do you have accurate error physical address
for the SEI?


> 
> For firmware-first your SError-interrupt is just a notification, its the CPER
> records the OS uses to handle the error.
I can call APEI kernel driver to parse the severity except doing recovery for the address.
May be it is not better handle the physical address that recorded in the CPER, because the error address is not accurate


> 
> 
>> If the SError error comes from guest user mode and is not propagated,
>> then signal user space to handle it, otherwise, directly injects virtual
>> SError, or panic if the error is fatal.
> 
> What do you mean by propagated?
That is, the error was detected but not consumed

> 
> I don't think we should ever hand RAS notifications to user-space, the host
> kernel should handle them, then describe the symptom (e.g. this region of your
> va space is gone) to user-space.
For guest OS user space SError, if it is not propagated. let guest OS handles, for example,killing
this APP is better, which can avoid terminate the whole guest OS.
if only host kernel handle them, it can not kill guest os APP.

> 
> 
>> when user space handles the error,
>> it will specify syndrome for the injected virtual SError. This syndrome value
>> is set to the VSESR_EL2. VSESR_EL2 is a new ARMv8.2 RAS extensions register
>> which provides the syndrome value reported to software on taking a virtual
>> SError interrupt exception.
> 
> 
> Thanks,
> 
> James
> 
> [0]
> https://static.docs.arm.com/ddi0587/a/RAS%20Extension-release%20candidate_march_29.pdf
> 
> 
> .
> 
