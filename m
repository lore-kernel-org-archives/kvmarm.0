From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 6/7] KVM: arm64: allow get exception information from
 userspace
Date: Fri, 06 Oct 2017 18:31:10 +0100
Message-ID: <59D7BDDE.5070505@arm.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com> <1503916701-13516-7-git-send-email-gengdongjiu@huawei.com> <59B17438.5070501@arm.com> <2a42d1ea-3456-2873-c9ea-d8a027b59789@huawei.com> <59BA7D72.4090403@arm.com> <92f2fecc-9833-15e4-30cc-b4dd5ba93cb7@huawei.com> <59C53FA7.2080803@arm.com> <8be64586-3722-cd96-80fd-6e815d2e911d@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <8be64586-3722-cd96-80fd-6e815d2e911d@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: Achin.Gupta@arm.com, peter.maydell@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, mst@redhat.com, john.garry@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 27/09/17 12:07, gengdongjiu wrote:
> On 2017/9/23 0:51, James Morse wrote:
>> If this wasn't a firmware-first notification, then you're right KVM hands the
>> guest an asynchronous external abort. This could be considered a bug in KVM. (we
>> can discuss with Marc and Christoffer what it should do), but:
>>
>> I'm not sure what scenario you could see this in: surely all your
>> CPU:external-aborts are taken to EL3 by SCR_EL3.EA and become firmware-first
>> notifications. So they should always be claimed by APEI.

> Yes, if it is firmware-first we should not exist such issue.

[...]

>> What you may be seeing is some awkwardness with the change in the SError ESR
>> with v8.2. Previously the VSE mechanism injected an impdef SError, (but they
>> were all impdef so it didn't matter).
>> With VSESR_EL2 KVM has to specify one, and all-zeros is a bad choice as this
>> means 'classified as a RAS error ... unknown!'.

>> I have a patch in the upcoming SError/RAS series that changes KVMs virtual-abort
>> code to specify an impdef ESR for this path.

https://www.spinics.net/lists/arm-kernel/msg609589.html


> Before I remember Marc and you suggest me specify the an impdef ESR (set the vsesr_el2) in
> the userspace,

If Qemu/kvmtool wants to emulate a machine that notifies the guest about
firmware-first RAS Errors using SError/SEI, it needs to decide when to send
these SError and what ESR to specify.


> now do you want to specify an impdef ESR in KVM instead of usrspace?

No, that patch is just trying to fixup the existing cases where KVM already
injects an SError. I'm just trying to keep the behaviour the-same:

Before the RAS Extensions the guest would always get an impdef SError ESR.
After the RAS Extensions KVM has to pick an ESR, as otherwise the guest gets the
hardware-reset value of VSESR_EL2. On the FVP this is all-zeros, which is a RAS
encoding. That patch changes it to still be an impdef SError ESR.


> if setting the vsesr_el2 in the KVM, whether user-space need to specify?

I think we need a KVM CAP API to do this. With that patch it can be wired into
pend_guest_serror(), which takes the ESR to make pending if the CPU supports it.

It's not clear to me whether its useful for user-space to make an SError pending
even if it can't set the ESR....

[...]

>> Because the SEI notification depends on v8.2 I'd like to get the SError/RAS
>> series posted (currently re-testing), then I'll pick up enough of the patches
>> you've posted for a consolidated version of the series, and we can take the
>> discussion from there.

> James, it is great, we can make a consolidated version of the series.

We need to get some of the wider issues fixed first, the big-ugly one is
memory_failure_queue() not being NMI safe. (this isn't a problem for SEA as this
would only become re-entrant if the kernel text was corrupt). It is a problem
for SEI and SDEI.


>> I'd still like to know what your firmware does if the normal-world believes its
>> masked physical-SError and you want to hand it an SEI notification.

Aha, thanks for this:

> firstly the physical-SError that happened in the EL2/EL1/EL1 can not be masked if SCR_EL3.EA is set.

Masked for the CPU because the CPU can deliver the SError to EL3.

What about software? Code at EL1 and EL2 each have a PSTATE.A bit they may have
set. HCR_EL2.VSE respects EL1's PSTATE.A ... the question is does your firmware
respect the PSTATE.A value of the exception level that SError are routed to?


> when trap to EL3, firmware will record the error to APEI CPER from reading ERR* RAS registers.
> 
> (1) if HCR_EL2.TEA is set to 1, exception come from EL0, El1. firmware knows this

HCR_EL2.TEA covers synchronous-external-aborts. For SError you need to check
HCR_EL2.AMO. Some crazy hypervisor may set one and not the other.


> SError come from guest OS, copy the elr_el3 to elr_el2, copy ESR_El3 to
> ESR_EL2.

The EC value in the ELR describes current/lower exception level, you need to
re-encode this for EL2 if the exception came from EL2.


>     if the SError exception come from guest EL0 or EL1, set ELR_EL3 with VBAR_EL2 + 0x580(one EL2 SEI entry point),
> 
>     execute "ERET", then jump to EL2 hypervisor.
>
> (2)if the SError exception come EL2 hypervisor, copy the elr_el3 to elr_el2, copy ESR_El3 to ESR_EL,
> set ELR_EL3 with VBAR_EL2+0x380(one EL2 SEI entry point),
> 
>    execute "ERET", then jump to EL2 hypervisor.

This SError came from EL2. You _must_ check SPSR_EL3.A is clear before returning
to the EL2 SError vector.

EL2 believes it has masked SError, it does this because it can't handle one
right now. If your firmware jumps in anyway - its game over.

We mask SError in entry.S when we take an exception and when we return from an
exception. This is so that we can read/write the ELR/SPSR without them changing
under our feet. If your firmware overwrites these values - we've lost them, and
can never return to the context we interrupted.


> (2) if HCR_EL2.TEA

It's an SError, these are routed by HCR_EL2.AMO.


> is set to 0, SError come from host EL1 ,EL0, copy ELR_EL3 to ELR_EL1,ESR_EL3 to ESR_EL1

Again, the EC needs re-encoding.


>     if the SError come from host EL0, set ELR_EL3 with VBAR_EL1+0x580
>     if the SError come from host EL1, set ELR_EL3 with VBAR_EL1+0x380
> 
>   execute "ERET", then jump to host EL1.

What if the SError came from EL2 and HCR_EL2.AMO is clear. This means SError are
routed to EL1, and are implicitly masked when executing at EL2.

This is the same SError-is-masked issue as above.

What does your firmware do when physical SError is masked and you want to hand
it an SEI notification?


You need to route your fake-SError based on HCR_EL2.AMO and your
fake-External-Abort based on HCR_EL2.TEA.

You also need a triage step at EL3 before you try and notify the normal world.
If you take an uncontainable error to EL3 there is very little point telling the
OS - its probably already on fire. In this case firmware needs to reboot the
machine, and generate a summary of the error for the BERT.


Thanks,

James
