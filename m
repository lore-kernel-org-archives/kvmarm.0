From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 11/11] KVM: arm64: Allow user-space to claim guest
 SMC-CC ranges for SDEI
Date: Tue, 19 Sep 2017 16:37:52 +0100
Message-ID: <59C139D0.3040507@arm.com>
References: <20170808164616.25949-1-james.morse@arm.com> <20170808164616.25949-12-james.morse@arm.com> <20170917144342.GC99021@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170917144342.GC99021@lvm>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoffer Dall <cdall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 17/09/17 15:43, Christoffer Dall wrote:
> On Tue, Aug 08, 2017 at 05:46:16PM +0100, James Morse wrote:
>> Instead of supporting SDEI in KVM, and providing a new API to
>> control and configure the in-kernel support, allow user-space to
>> request particular SMC-CC ranges from guest HVC calls to be handled
>> by user-space.
>>
>> This requires two KVM capabilities, KVM_CAP_ARM_SDEI_1_0 advertises
>> that KVM knows how match SDEI SMC-CC calls from a guest. To pass these
>> calls to user-space requires this cap to be enabled using
>> KVM_CAP_ENABLE_CAP_VM.
>>
>> Calls are passed with exit_reason = KVM_EXIT_HYPERCALL, the kvm_run
>> structure has copies of the first 6 registers and the guest pstate.


>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index e63a35fafef0..740288d6e894 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -1012,7 +1012,7 @@ documentation when it pops into existence).
>>  4.37 KVM_ENABLE_CAP
>>  
>>  Capability: KVM_CAP_ENABLE_CAP, KVM_CAP_ENABLE_CAP_VM
>> -Architectures: x86 (only KVM_CAP_ENABLE_CAP_VM),
>> +Architectures: x86, arm, arm64 (only KVM_CAP_ENABLE_CAP_VM),
>>  	       mips (only KVM_CAP_ENABLE_CAP), ppc, s390
>>  Type: vcpu ioctl, vm ioctl (with KVM_CAP_ENABLE_CAP_VM)
>>  Parameters: struct kvm_enable_cap (in)
>> @@ -3540,10 +3540,16 @@ pending operations.
>>  			__u32 pad;
>>  		} hypercall;
>>  
>> -Unused.  This was once used for 'hypercall to userspace'.  To implement
>> -such functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s390).
>> +This was once used for 'hypercall to userspace'.  To implement such
>> +functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s390).

> I suggest you add 'for x86' to these two sentences, otherwise the
> following paragraph seems contradicting.

Does the second sentence apply to just x86? 'KVM_EXIT_MMIO (all except s390)'

I've change this to:
> This was once used for 'hypercall to userspace' on x86. To implement such
> functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s390).


>>  Note KVM_EXIT_IO is significantly faster than KVM_EXIT_MMIO.
>>  
>> +On arm64 this is used to complete guest hypercalls (HVC) in user space.
>> +e.g. Configuring SDEI or communicating with an emulated TEE.
> 
> s/e.g./For example,/
> 
>> +The required HVC ranges must first be enabled by KVM_CAP_ENABLE_CAP_VM.
>> +The 'args' array contains a copy of r0-r5 and 'longmode' contains a copy
>> +of the CPSR/PSTATE.

> I'm not entirely sure what this means by just looking at this text.  Do
> you mean that some HVC (and SMC?) calls can still be handled by the
> kernel directly (PSCI), and some can be configured to be handled by the
> kernel?  Where does it specify how these 'ranges' are defined?

I'm looking at this as just ARM's SMC-CC services, (which looks like too narrow
a view). I had expected the kernel to know which ranges its willing to let
user-space drive, once they have a KVM_HVC_RANGE_ value userspace can try and
claim them.

This fits nicely with the kernel emulating PSCI by default, but looks wrong once
SMC and the immediates creep in too.


> What about the immediate field, could userspace not also need to know
> this?

Yes, I'd ignored that due to the narrow focus...


>>  		/* KVM_EXIT_TPR_ACCESS */
>>  		struct {
>>  			__u64 rip;
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 7733492d9a35..77b8436e745e 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -71,8 +71,14 @@ struct kvm_arch {
>>  
>>  	/* Interrupt controller */
>>  	struct vgic_dist	vgic;
>> +
>> +	/* SMC-CC/HVC ranges user space has requested */
>> +	u32	hvc_passthrough_ranges;
>>  };
>>  
>> +/* SMC-CC/HVC ranges that can be passed to user space */
>> +#define	KVM_HVC_RANGE_SDEI	1

> Oh, I see you want the kernel to know what constitutes a range for some
> functionality and set things up that way.

> What are your thoughts on letting userspace configure a range of from/to
> values in x0 for some value/range of the immediate field?

The only user we have today is PSCI. It we let userspace specify the x0 ranges
it may try and claim PSCI, or worse only part of the range the kernel uses for
its PSCI emulation. I'd like to avoid these corners.

The logic was the kernel has PSCI emulation so it already knows about particular
ranges, hence the grouping so that only whole ranges can be claimed...

.. but this doesn't fit with exposing the immediate values or SMC/HVC, both of
which have a bigger scope than SMC-CC.

Looking again at Marc's comments on this[0, 1], we could consider an 'all or
nothing' approach. If user-space wants the SDEI or any other range it has to
claim the lot, and emulate PSCI itself. This is more work for userspace in the
short term, but its less work for userspace and the kernel in the long run.

(I assume Qemu already has a PSCI implementation for its TCG mode..)


>> +
>>  #define KVM_NR_MEM_OBJS     40
>>  
>>  /*
>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>> index 17d8a1677a0b..22eadf2cd82f 100644
>> --- a/arch/arm64/kvm/handle_exit.c
>> +++ b/arch/arm64/kvm/handle_exit.c
>> @@ -21,6 +21,7 @@
>>  
>>  #include <linux/kvm.h>
>>  #include <linux/kvm_host.h>
>> +#include <linux/sdei.h>
>>  
>>  #include <asm/esr.h>
>>  #include <asm/kvm_asm.h>
>> @@ -34,15 +35,40 @@
>>  
>>  typedef int (*exit_handle_fn)(struct kvm_vcpu *, struct kvm_run *);
>>  
>> +#define HVC_PASSTHROUGH(kvm, range) (kvm->arch.hvc_passthrough_ranges & range)

> I think this should have parenthesis around (range) ?
>
> Are we not going to support this for SMC passthrough?  (for nested virt
> for example).

Ah, I hadn't thought about that, (and I don't know much about how it works).
I assume user-space needs to know which of SMC/HVC the guest made, to route to
the appropriate guest{n}-hypervisor, and these probably need enabling
independently as SMC isn't guaranteed to be trappable, (how can KVM know if
HCR_EL2.TSC is secretly ignored?).


(/me looks at the condition code ESR_EL2.ISS bits for SMC trapped from aarch32)

... I'm not going to get this done this week, and as it no longer has any ties
to SDEI I'll drop this patch from the series and post it independently.


Thanks,

James


[0] https://lkml.org/lkml/2017/3/22/196
[1] https://patchwork.kernel.org/patch/9886029/
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
