From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v4 3/3] arm64: kvm: inject SError with user space
 specified syndrome
Date: Tue, 4 Jul 2017 18:50:00 +0800
Message-ID: <2de1a880-cc38-40d3-e60e-754d34d58565@huawei.com>
References: <1498481199-24118-1-git-send-email-gengdongjiu@huawei.com>
 <20170703083903.GE4066@cbox>
 <429e4a67-3795-1449-f0b1-12df3012629a@huawei.com> <595B6A8A.1050809@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <595B6A8A.1050809@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>, Christoffer Dall <cdall@linaro.org>
Cc: corbet@lwn.net, wuquanming@huawei.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, rkrcmar@redhat.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, linux@armlinux.org.uk, Gaozhihui <zhihui.gao@huawei.com>, huangshaoyu@huawei.com, linux-arm-kernel@lists.infradead.org, huhuajun@huawei.com, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,
  Thanks for the review. I will read your comments carefully and then reply to you.


On 2017/7/4 18:14, James Morse wrote:
> Hi gengdongjiu,
> 
> Can you give us a specific example of an error you are trying to handle?
> How would a non-KVM user space process handle the error?
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
> 
> When you're using ACPI firmware-first, SError/SEI is just a notification, the
> important data is in the CPER records, which Qemu can't access, (and should be
> processed by Linux APEI code).
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
> 
> Qemu should react to a signal like BUS_MCEERR_A{R,O} from memory_failure(). This
> mechanism serves all user space processes, not just kvm users. This is where the
> user-space virtual address should come from. Qemu/kvmtool have to generate the
> guest IPA once they discover the affected memory was presented to the guest
> through KVM.
> 
> 
> Your KVM-specific mechanism exposes too much raw information (raw ESR values to
> user space), and only serves applications using KVM.
> 
> If there is another type of CPER record where we should notify userspace, please
> do it from mm/memory-failure.c, drivers/acpi/apei/ghes.c or
> drivers/firmware/efi/cper.c. These should consider all user-space applications,
> not just users of KVM, and not just on arm64.
> 
> 
>>   c). Qemu gets the syndrome_info delivered by KVM, it refers to this syndrome value(but can be different from it) to specify the virtual SError interrupt's syndrome through setting VESR_EL2.
> 
> 'but can be different from it' is because a classification step is required, the
> operating system should do this. We should only signal Qemu/kvmtool for errors
> that can actually be handled. Some APEI notifications may be for corrected
> errors, (I would hope these always come through a polled GHES), Linux shouldn't
> interrupt user space for a corrected error.
> 
> For memory errors we already have BUS_MCEERR_AR - action-required, and
> BUS_MCEERR_AO - action-optional.
> 
> For a TLB error, (Table 250 of UEFI 2.6), what is Qemu expected to do? Linux has
> to classify the error and handle it as far as possible. In most cases the error
> is either handled (no notification required), or fatal. Memory errors are the
> only example I've found so far where an application can do additional work to
> handle the error.
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
