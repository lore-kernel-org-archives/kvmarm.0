From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v6 6/7] KVM: arm64: allow get exception information from
 userspace
Date: Wed, 27 Sep 2017 19:07:33 +0800
Message-ID: <8be64586-3722-cd96-80fd-6e815d2e911d@huawei.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
 <1503916701-13516-7-git-send-email-gengdongjiu@huawei.com>
 <59B17438.5070501@arm.com> <2a42d1ea-3456-2873-c9ea-d8a027b59789@huawei.com>
 <59BA7D72.4090403@arm.com> <92f2fecc-9833-15e4-30cc-b4dd5ba93cb7@huawei.com>
 <59C53FA7.2080803@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <59C53FA7.2080803@arm.com>
Sender: linux-acpi-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: Achin.Gupta@arm.com, peter.maydell@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vge
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,
   Sorry for my late response, thank you very much for comments.

On 2017/9/23 0:51, James Morse wrote:
[.....]
>>
>> CC Achin
>>
>> I have some personal opinion, if you think it is not right, hope you can point out.
>>
>> Synchronous External Abort and SError Interrupt are hardware exception(hardware concept),
>> which is independent of software notification,
>> in armv8 without RAS, the two concepts already exist. In the APEI spec, in order to
>> better describe the two exceptions, so use SEA and SEI notification to stand
> for them.
> 
>> SEA notification stands for Synchronous External Abort, so may be it is not only a
>> notification, it also stands for a hardware error type.
>> SEI notification stands for SError Interrupt, so may be it is not only a notification,
>> it also stands for a hardware error type.
> 
>> In the OS, it has different handling flow to the two exception(two notification):
>> when the guest OS running, if the hardware generates a Synchronous External Abort, we
>> told the guest OS this error is SError Interrupt instead of Synchronous
> External Abort.
> 
> This should only happen when APEI doesn't claim the external-abort as a RAS
> notification. If there were CPER records to process then the error is handled by
> the host, and we can return to the guest.

consider again. I think you should be right.
In the firmware-first solution, firmware will shield all kinds of errors and record them to the CPER buffer.


> 
> If this wasn't a firmware-first notification, then you're right KVM hands the
> guest an asynchronous external abort. This could be considered a bug in KVM. (we
> can discuss with Marc and Christoffer what it should do), but:
> 
> I'm not sure what scenario you could see this in: surely all your
> CPU:external-aborts are taken to EL3 by SCR_EL3.EA and become firmware-first
> notifications. So they should always be claimed by APEI.

Yes, if it is firmware-first we should not exist such issue.

> 
> 
>> guest OS uses SEI notification handling flow to deal with it, I am not sure whether it
>> will have problem, because the true hardware exception is Synchronous External
>> Abort, but software treats it as SError interrupt to handle.
> 
> Once you're into a guest the original 'true hardware exception' shouldn't
> matter. In this scenario KVM has handed the guest an SError, our question is 'is
> it an SEI notification?':
> 
> For firmware first the guest OS should poke around in the CPER buffers, find
> nothing to do, and return to the arch code for (future) kernel-first.
> For kernel first the guest OS should trawl through the v8.2 ERR registers, find
> nothing to do, and continue to the default case:
> 
> By default, we should panic on SError, unless its classified as a non-fatal RAS
> error. (I'm tempted to pr_warn_once() if we get RAS notifications but there is
> no work to do).

understand, thanks.

> 
> 
> What you may be seeing is some awkwardness with the change in the SError ESR
> with v8.2. Previously the VSE mechanism injected an impdef SError, (but they
> were all impdef so it didn't matter).
> With VSESR_EL2 KVM has to specify one, and all-zeros is a bad choice as this
> means 'classified as a RAS error ... unknown!'.
> 
> I have a patch in the upcoming SError/RAS series that changes KVMs virtual-abort
> code to specify an impdef ESR for this path.
Before I remember Marc and you suggest me specify the an impdef ESR (set the vsesr_el2) in
the userspace,
now do you want to specify an impdef ESR in KVM instead of usrspace?
if setting the vsesr_el2 in the KVM, whether user-space need to specify?
May be we can combine the patches that specify an impdef ESR(set vsesr_el2) patch to one.

> 
> 
>> In the mainline code, it does not have SEI notification support, the reason I 
>> think it is because of the error address record by firmware is not accurate
>> (SError Interrupt is asynchronous exception).
> 
> Yes, while we don't expect a FAR with an SError, but we do expect a valid
> representation of the RAS error in either the CPER records or the v8.2. ERR
> registers (or both). If we have neither of those, its not a RAS error and we
> should panic.
> 
> 
>> so if treat a hardware Synchronous External Abort as SError interrupt(SEI). 
>> The default OS behavior for SEI is PANIC, that is to say, when hardware triggers
>> a Synchronous External Abort(SEA), if guest treat it as SError interrupt(SEI),
>> the OS will be panic. in fact, it can be recoverable instead of Panic.
> 
> If its a RAS error APEI (or in the future, the kernel-first handler), should
> claim the error, so the guest never sees it. If you are hitting this behaviour
> in KVM, then it wasn't a RAS error.
> 
> 
>> I ever added a patch to support the SEI notification, but not sure whether
>> it is can be accepted by open source, until now, not receive response.
> 
> The patch you posted during the merge window made no sense on its own, so must
> replace $one_of the other patches in your v5 (or was it v6)... I'll get to it...
yes, thanks.
Because SEI notification support does not depend on the RAS virtualization, I break them out of this
series.
they are here(Today Tyler have some comments, I will update it)

https://patchwork.kernel.org/patch/9950953/
https://patchwork.kernel.org/patch/9952493/

> 
> Because the SEI notification depends on v8.2 I'd like to get the SError/RAS
> series posted (currently re-testing), then I'll pick up enough of the patches
> you've posted for a consolidated version of the series, and we can take the
> discussion from there.
James, it is great, we can make a consolidated version of the series.

> 
> I'd still like to know what your firmware does if the normal-world believes its
> masked physical-SError and you want to hand it an SEI notification.
firstly the physical-SError that happened in the EL2/EL1/EL1 can not be masked if SCR_EL3.EA is set.

when trap to EL3, firmware will record the error to APEI CPER from reading ERR* RAS registers.

(1) if HCR_EL2.TEA is set to 1, exception come from EL0, El1. firmware knows this SError come from guest OS, copy the elr_el3 to elr_el2, copy ESR_El3 to ESR_EL2.
    if the SError exception come from guest EL0 or EL1, set ELR_EL3 with VBAR_EL2 + 0x580(one EL2 SEI entry point),

    execute "ERET", then jump to EL2 hypervisor.

(2)if the SError exception come EL2 hypervisor, copy the elr_el3 to elr_el2, copy ESR_El3 to ESR_EL, set ELR_EL3 with VBAR_EL2+0x380(one EL2 SEI entry point),

   execute "ERET", then jump to EL2 hypervisor.


(2) if HCR_EL2.TEA is set to 0, SError come from host EL1 ,EL0, copy ELR_EL3 to ELR_EL1,ESR_EL3 to ESR_EL1
    if the SError come from host EL0, set ELR_EL3 with VBAR_EL1+0x580
    if the SError come from host EL1, set ELR_EL3 with VBAR_EL1+0x380

  execute "ERET", then jump to host EL1.


> 
> Thanks,
> 
> James
> 
> .
> 

