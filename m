From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v4 3/3] arm64: kvm: inject SError with user space
 specified syndrome
Date: Wed, 5 Jul 2017 16:14:01 +0800
Message-ID: <b2b80fd0-4a8f-d605-590e-17785eee2e8b@huawei.com>
References: <1498481199-24118-1-git-send-email-gengdongjiu@huawei.com>
 <20170703083903.GE4066@cbox>
 <429e4a67-3795-1449-f0b1-12df3012629a@huawei.com> <595B6A8A.1050809@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <595B6A8A.1050809@arm.com>
Sender: linux-doc-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>, Christoffer Dall <cdall@linaro.org>
Cc: corbet@lwn.net, wuquanming@huawei.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, rkrcmar@redhat.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, linux@armlinux.org.uk, Gaozhihui <zhihui.gao@huawei.com>, huangshaoyu@huawei.com, linux-arm-kernel@lists.infradead.org, huhuajun@huawei.com, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,


On 2017/7/4 18:14, James Morse wrote:
> Hi gengdongjiu,
> 
> Can you give us a specific example of an error you are trying to handle?
For example:
guest OS user space accesses device type memory, but happen SError. because the
SError is asynchronous faults, it does not take immediately. when guest OS call "SVC" to enter guest os
kernel space, the ESB instruction(Error Synchronization Barrier) will defter this SError. so the SError happen immediately.


> How would a non-KVM user space process handle the error?
it is indeed, non-KVM user space can not get the notification from hypervisor or host kernel. thanks for the pointing out
do you mean still Signal SIGBUS from memory_failure?


> 
> KVM-users should be regular user space processes, we should not have a KVM-way
> and everyone-else-way of handling errors.
> 
> 
> On 04/07/17 05:46, gengdongjiu wrote:
>> On 2017/7/3 16:39, Christoffer Dall wrote:
>>> On Mon, Jun 26, 2017 at 08:46:39PM +0800, Dongjiu Geng wrote:
>>>> when SError happen, kvm notifies user space to record the CPER,
>>>> user space specifies and passes the contents of ESR_EL1 on taking
>>>> a virtual SError interrupt to KVM, KVM enables virtual system
>>>> error or asynchronous abort with this specifies syndrome. This
>>>> patch modify the world-switch to restore VSESR_EL2, VSESR_EL2
>>>> saves the virtual SError syndrome, it becomes the ESR_EL1 value when
>>>> HCR_EL2.VSE injects an SError. This register is added by the
>>>> RAS Extensions.
>>>
>>> This commit message is confusing and doesn't help me understand the
>>> patch.
>> (1) what is the rationale for the guest OS SError interrupt(SEI) handling in the RAS solution?
> 
>>   a). In the firmware-first RAS solution, when guest OS happen a SError interrupt (SEI), it will firstly trap to EL3(SCR_EL3.EA = 1);
>>   b). The firmware logs, triages, and delegates the error exception to the hypervisor. As the error came from guest OS  EL1, firmware
>>       does by faking an SError interrupt exception entry to EL2.
>>   c). Control transfers to the hypervisor's delegated error recovery agent.Because HCR_EL2.AMO is set to 1, the hypervisor can use a
>>       Virtual SError interrupt to delegate an asynchronous abort to EL1, by setting HCR_EL2.VSE to 1 and using VESR_EL2 to pass syndrome.
> 
> So (a): a physical-CPU hardware error occurs, and then (c) we tell Qemu/kvmtool
> via a KVM-specific API.
> 
> Don't do this, it doesn't work for non-KVM users. You are exposing host-specific
> implementation details to user space. What if I discover the same error via a
> Polling GHES, or one of the IRQ flavours?
James, you mainly concern the way that "tell Qemu/kvmtool via a KVM-specific API", right?
so how about still delivered SIGBUS same as the SEA(Synchronous External Abort)?

by the way, what is your meaning of below words?
 >"What if I discover the same error via a Polling GHES, or one of the IRQ flavours?"


> 
> User space should not have to know, or care, how linux is notified about APEI
> RAS errors.
> 
> 
>> (2) what is this patch mainly do?
>>   As mentioned above, the hypervisor needs to enable virtual SError and pass the virtual syndrome to the guest OS.
>>
>>   a). when Control transfers to the hypervisor from firmware by faking an SError interrupt, the hypervisor delivered the syndrome_info(esr_el2) and
>>       host VA address( Qemu translate this VA address to the virtual machine physical address(IPA)) using below new added "serror_intr" struct.
>>   		/* KVM_EXIT_SERROR_INTR */
>>  		struct {
>> 			__u32 syndrome_info;
>> 			__u64 address;
>> 		} serror_intr;
> 
> This is for a guest exit to host user-space. Here you are telling Qemu that a
> physical CPU hardware error occurred. Qemu/kvmtool should not be expected to
> parse the ESR, this is the job of the operating system.
  it does not want Qemu/kvmtool to parse the ESR.
  Qemu/kvmtool can refer to the ESR to specify the vsesr's value, only for reference.

  As mentioned above, firmware does by faking an SError interrupt exception entry to EL2.
  so the esr_El2 may contain some useful information, Qemu can refer to this value to set the vsesr_el2(esr_el1).

  when qemu specified the vsesr value, do you mean not refer to the esr_el2 value?
  if so, what is the suggested value for the vsesr_el2 value?

> 
> When you're using ACPI firmware-first, SError/SEI is just a notification, the
> important data is in the CPER records, which Qemu can't access, (and should be
> processed by Linux APEI code).
 Yes, I agree with you.

> 
> 
> It looks like you've calculated an address from FAR_EL2/HPFAR_EL2. For an
> SError, these are meaningless.
> 
> (These registers hold real values for Synchronous External Abort, but for
>  firmware-first we should prefer the CPER records.)
> 
> 
>>   b). Qemu gets the address(host VA) delivered by KVM, translate this host VA address to virtual machine physical address(IPA), and runtime record this virtual
>>      machine physical address(IPA) to the guest OS's APEI table.
> 
> I agree with this step, but you're acting on the wrong data. (You're converting
> fault_ipa -> virtual address -> fault_ipa, something isn't right ...)
  consider again, using the fault_ipa indeed has problem. because SEI is asynchronous faults. the IPA which is recorded in the register may not the real error address.
  thanks for the pointing out.
> 
> Qemu should react to a signal like BUS_MCEERR_A{R,O} from memory_failure(). This
> mechanism serves all user space processes, not just kvm users. This is where the
> user-space virtual address should come from. Qemu/kvmtool have to generate the
> guest IPA once they discover the affected memory was presented to the guest
> through KVM.
so do you suggest to use SIGBUS to notify Qemu/kvmtool both for the SEA/SEI?
if so, how the Qemu know the error is SEA or SEI. the siginfo_t for the SIGBUS only
include the si_code(BUS_MCEERR_A{R,O}) and si_address(host VA).


> 
> 
> Your KVM-specific mechanism exposes too much raw information (raw ESR values to
> user space), and only serves applications using KVM.
thanks for the pointing out.

> 
> If there is another type of CPER record where we should notify userspace, please
> do it from mm/memory-failure.c, drivers/acpi/apei/ghes.c or
> drivers/firmware/efi/cper.c. These should consider all user-space applications,
> not just users of KVM, and not just on arm64.

here I have a question, in the "drivers/acpi/apei/ghes.c" code, it only handle the memory section of CPER.
if the section type of CPER is processor, it will not notify user-space. so only let userspace handle the memory section is reasonable?

As shown blow, only when the section is memory section, it will call ghes_handle_memory_failure.

 450 static void ghes_do_proc(struct ghes *ghes,
 451              const struct acpi_hest_generic_status *estatus)
 452 {
 453     int sev, sec_sev;
 454     struct acpi_hest_generic_data *gdata;
 455     uuid_le sec_type;
 456     uuid_le *fru_id = &NULL_UUID_LE;
 457     char *fru_text = "";
 458
 459     sev = ghes_severity(estatus->error_severity);
 460     apei_estatus_for_each_section(estatus, gdata) {
 461         sec_sev = ghes_severity(gdata->error_severity);
 462         sec_type = *(uuid_le *)gdata->section_type;
 463
 464         if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
 465             fru_id = (uuid_le *)gdata->fru_id;
 466         if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
 467             fru_text = gdata->fru_text;
 468
 469         if (!uuid_le_cmp(sec_type,
 470                  CPER_SEC_PLATFORM_MEM)) {
 471             struct cper_sec_mem_err *mem_err;
 472
 473             mem_err = acpi_hest_generic_data_payload(gdata);
 474             ghes_edac_report_mem_error(ghes, sev, mem_err);
 475
 476             arch_apei_report_mem_error(sev, mem_err);
 477             ghes_handle_memory_failure(gdata, sev);
 478         }

> 
> 
>>   c). Qemu gets the syndrome_info delivered by KVM, it refers to this syndrome value(but can be different from it) to specify the virtual SError interrupt's syndrome through setting VESR_EL2.
> 
> 'but can be different from it' is because a classification step is required, the
> operating system should do this. We should only signal Qemu/kvmtool for errors
> that can actually be handled. Some APEI notifications may be for corrected
> errors, (I would hope these always come through a polled GHES), Linux shouldn't
> interrupt user space for a corrected error.
  classification step is need, for the error that Qemu/kvmtool can actually handled, what is vsesr_el2's value if qemu specify it?
  If qemu sets arbitrary value for vsesr, it may affect guest os error recovery. so here I let Qemu refer to the esr_el2's value.

 here I show a example in the   "RAS_Extension_PRD03-PRDC-010953-33-0", in this example, it even Sets up SPSR_EL1, ELR_EL1 and ESR_EL1 with copies of SPSR_EL2, ELR_EL2 and
 ESR_EL2.

Variant: asynchronous External Abort with delegated exception handling
The example above requires the hypervisor to know that it can delegate the error exception to the OS using a
virtual error interrupt. In this example:
 The error exception is taken asynchronously.
 Before the load instruction completes, the software executes an SVC instruction.
 The OS uses the ESB instruction at the SVC exception entry point. This barriers the error as described
above.
 The firmware logs, triages, and delegates the error exception to the hypervisor. As the error came
from EL1, it does by faking an SError interrupt exception entry to EL2.
 Control transfers to the hypervisor’s delegated error recovery agent. It repeats the process of triaging
the error.
 The hypervisor, however, delegates the error exception to the OS using the delegated exception
handler model.
— If it were to try a virtual SError interrupt, then this would be masked on return to EL1.
 The delegated exception handler model is described in [5], but, briefly, the hypervisor:
— Stashes the original SPSR_EL2, ELR_EL2 and ESR_EL2 in a local record.
— Stashes the current SPSR_EL1, ELR_EL1 and ESR_EL1 in a local record.
 These registers may contain live data.
— Sets up SPSR_EL1, ELR_EL1 and ESR_EL1 with copies of SPSR_EL2, ELR_EL2 and
ESR_EL2.
 That is, the syndrome for the error.
— Sets SPSR_EL2 and ELR_EL2 to point to the OS delegated error recovery agent entry point,
and executes an ERET instruction.
 Control returns to the OS. It triages the error and discovers that the error was taken from an ESB
instruction at an exception entry point and so it might be able to recover from the error.
 The OS returns from its delegated error recovery agent by executing a Hypervisor call, asking the
hypervisor to schedule a virtual SError interrupt. The hypervisor:
— Restores the original SPSR_EL2, ELR_EL2 and ESR_EL2 from its local record.
— Sets HCR_EL2.VSE to 1.
— Returns back to the OS at the point the error exception was taken from (in this case, the ESB).
 The virtual SError interrupt is processed as described above.
 The error has been logged, triaged, and contained to the EL0 application.


> 
> For memory errors we already have BUS_MCEERR_AR - action-required, and
> BUS_MCEERR_AO - action-optional.
> 
> For a TLB error, (Table 250 of UEFI 2.6), what is Qemu expected to do? Linux has
> to classify the error and handle it as far as possible. In most cases the error
> is either handled (no notification required), or fatal. Memory errors are the
> only example I've found so far where an application can do additional work to
> handle the error.
  James, only memory errors needs application to do additional work. UEFI spec mentioned that?

> 
> Can you give us a specific example of an error you are trying to handle?
> How would a non-KVM user space process handle the error?
> 
> 
> 
> Thanks,
> 
> James
> 
> 
> .
> 

