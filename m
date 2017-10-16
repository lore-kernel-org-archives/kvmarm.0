From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 15/20] KVM: arm64: Set an impdef ESR for Virtual-SError
 using VSESR_EL2.
Date: Mon, 16 Oct 2017 18:09:53 +0100
Message-ID: <59E4E7E1.5020209@arm.com>
References: <0184EA26B2509940AA629AE1405DD7F2016959EE@DGGEMA503-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F021E49D1F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 13:10:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q5oAW6hmAXMB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Oct 2017 13:10:38 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2896C40795
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 13:10:37 -0400 (EDT)
In-Reply-To: <0184EA26B2509940AA629AE1405DD7F2016959EE@DGGEMA503-MBX.china.huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: "Jonathan.Zhang@cavium.com" <Jonathan.Zhang@cavium.com>, Wuquanming <wuquanming@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "wangxiongfeng (C)" <wangxiongfeng2@huawei.com>, Huangshaoyu <huangshaoyu@huawei.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 15/10/17 17:09, gengdongjiu wrote:
>> On 13/10/17 10:25, gengdongjiu wrote:
>>> In my first version patch [2], It sets the virtual ESR in the KVM, but
>>> Marc and other people disagree that[3][4],and propose to set its value
>>> and injection by userspace(when RAS is enabled).
>>
>> Not quite: for RAS errors.
>> When we want to hand a RAS error to a guest, Qemu should be driving that.
>>
>> What about impdef SError? Qemu should be able to drive that with the same API.
>>
>> What about this nasty corner where KVM already injects an impdef SError directly? This patch keeps that working.
>>
>>
>> I'd love to get rid of KVMs internal use of kvm_inject_vabt(). But what do we replace it with? It needs to be a guest exit type that existing
>> software can't ignore...
>>
>> (The best I can suggest is: Once we have a mechanism to inject SError into a guest from Qemu, KVM could make an impdef SError pending,
>> then give Qemu the opportunity to kill the guest, or set a different ESR. Existing software can ignore the exit, and take the existing
>> behaviour.)

> In fact I have below method for that, what do you think about that?
> 
> 1.  If there is no RAS, old method, directly inject virtual SError, not need to specify
> ESR, as shown in the [1]
> 2.  If there is RAS, KVM set "the kvm_run" guest exit type value to let user space handle
> the SError abort

Nope. There should not be a RAS-specific kvm exit type. What information do you
need to convey that doesn't apply to another user-space process?

Qemu/kvmtool will always need to generate a new RAS error from the user-space
signals they get as a result of the host handling the error. This way KVMs
user-space isn't a special case, and the user-space code is portable across
architectures.

This does mean the host kernel has to be able to handle any and all RAS errors
before they could possibly be presented to a guest. Today we only handle memory
errors. Any other error types will need adding in a way that works on all
architectures.

Again, you're passing RAS SErrors out to user-space. The SError may have nothing
to do with the guest. The host has to handle any and all RAS errors.


The only case where the guest is involved is if if the guest treads in some
poisoned memory. (You know this:)
The host has to do its RAS work first, to check this wasn't an error in the
hosts page tables and that the host really can keep running.
memory_failure() will cause the faulty memory to be unmapped from stage 2 and
signal Qemu/kvmtool.
If the guest touches the faulty memory (even from a different CPU/vcpu),
Qemu/kvmtool will get a signal.

Qemu/kvmtool should take these signals and generate any applicable RAS error
from these.

We have to use these signals so that KVM's user-space is the same as all other
user-space.


>    A. If ESR_EL2 is IMPLEMENTATION or uncategorized, return " ESR_ELx_ISV " to let user
> space specify an implementation-defined value, as shown [2]

I agree impdef SError are a different case. It doesn't look like you are passing
the impdef ESR to user-space, which I think is correct.

Passing uncategorized errors like this isn't correct, these are still RAS
errors. '2.4.3 ESB and other physical errors' in [0] says its
implementation-defined whether these Uncategorized RAS errors are uncontainable,
we should assume they weren't contained, and panic(). (If the CPU wants us to do
a better job, it needs to give us some information).

I don't think there is any point generating a fake ESR.
I need to think about using KVM_EXIT_EXCEPTION, but the exit code should mean
'run this again and I'll give it an SError'.  This lets Qemu/kvmtool set its own
impdef SError or emulate a machine that doesn't generate SError.

I think this needs more discussion, do we want to let Qemu/kvmtool reset an
affected vcpu so that its effectively running in firmware and can be brought
back online again?


> If ESR_EL2 is categorized and error not propagated,  the error come from guest user
> space, return " (ESR_ELx_AET_UCU | ESR_ELx_FSC_SERROR " to let user space
> specify a recoverable ESR.

No, these are RAS errors, they should be handled by the kernel, not passed to
user-space, and not both.

If user-space needs to know, it will be informed via the usual way we tell
user-space about this stuff.


>      Here one side calling memory failure, another side let user pace inject SError.
> Because usually SEI notification does not deliver SIGBUS signal to user space, so
> here inject virtual SEI to ensure that. As shown [3]

For a RAS error we process the CPER records, and if they describe a memory error
we send signals to user-space.

Is there another type of RAS error we need to support for the guest? We must
support this on the host first.


>    C. If ESR_EL2 is categorized and error not propagated,  the error come from guest kernel,
>  return "-1" to terminate guest. As shown [4]


>    D. Otherwise, Panic host OS. As shown [5]

I don't think KVM should go calling panic(), this needs to be wrapped up the
arch's RAS code.


> static int kvm_handle_guest_sei(struct kvm_vcpu *vcpu, struct kvm_run *run)
> {
>        unsigned int esr = kvm_vcpu_get_hsr(vcpu);
>        bool impdef_syndrome =  esr & ESR_ELx_ISV;      /* aka IDS */
>        unsigned int aet = esr & ESR_ELx_AET;
> 
>       if (!cpus_have_const_cap(ARM64_HAS_RAS_EXTN))                      [1]
>                kvm_inject_vabt(vcpu);
>                return 1;
>        }
> 
>        kvm_run->exit_reason = KVM_EXIT_EXCEPTION;
> 	   kvm_run->ex.exception = KVM_EXCEPTION_SERROR;
> 
> 	   If (impdef_syndrome || ((esr & ESR_ELx_FSC) != ESR_ELx_FSC_SERROR) {
> 			kvm_run->ex.error_code = ESR_ELx_ISV;
> 		}
> 
>        switch (aet) {
>        case ESR_ELx_AET_CE:    /* corrected error */                            [2]
>        case ESR_ELx_AET_UEO:   /* restartable error, not yet consumed */
> 			   kvm_run->ex.error_code = (ESR_ELx_AET_UC | ESR_ELx_FSC_SERROR );   
>                break;      /* continue processing the guest exit */
> 
> 
>        case ESR_ELx_AET_UEU:  /* The error has not been propagated */            [3]
> 	   case ESR_ELx_AET_UER:
>        /*
>         * Only handle the guest user mode SEI if the error has not been propagated
>         */
>        if ((!vcpu_mode_priv(vcpu)) && !handle_guest_sei(kvm_vcpu_get_hsr(vcpu)))
> 			kvm_run->ex.error_code = (ESR_ELx_AET_UCU | ESR_ELx_FSC_SERROR );

Why should KVM care whether it was guest EL0 or guest EL1? Something is designed
wrong if you need to behave differently here.

(as far as I can see KVMs existing use of this vcpu_mode_priv() helper is to
emulate bits of the architecture that behave/undef differently at different
exception levels)


>       		break;
>        else
> 			return -1;                                                    [4]
>        /* If SError handling is failed, continue run */
>        default:                                                           [5]
>                /*
>                 * Until now, the CPU supports RAS and SEI is fatal, or user space
>                 * does not support to handle the SError.
>                 */
>                panic("This Asynchronous SError interrupt is dangerous, panic");
>        }
> 
> 	   return 0;
> }
> 
>>
>>> So I think we no need to submit another patch, it will be duplicated,
>>> and waste our review time. thank you very much. I will combine that.
>>
>> I agree we're posting competing series, there was some off-list co-ordination on this with Xie XiuQi and Xiongfeng Wang in ~may, it looks
>> like you weren't involved at that point.
>   
> Thanks very much for your agreement, I will add you to the off-list.

There are two sets of off-list co-ordination? That explains something...


>> In your last series touching all this:
>> https://lkml.org/lkml/2017/8/31/698
>>
>> You had Xie XiuQi's RAS-cpufeature patch in isolation, without the SError rework underneath it. Applied like this SError is still always masked
>> in the kernel, so any system without firmware-first will silently consume and discard an uncontained-RAS-error using the esb() in
>> __switch_to(). We can't do this, hence the first half of this series.
> 
> 
> Yes, seems I lost your SError rework series patches. When my patch update and modification
> almost done, hope we can combine to one series. thanks

I'd like to try and get this series merged as it is, then we can work on the KVM
and APEI bits as separate series on top. (otherwise we still depend on getting
this merged so we can have code that depends on ARM64_HAS_RAS_EXTENSIONS).


For KVM its:
* Allowing guests to inject SError.
* Allow Qemu/kvmtool to do something if the guest trips a non-RAS SError.
* Expose enough information to allow user-space to promote SIGBUS_MCEERR_AR to
  external-abort.
* (Handle SError during world-switch)

For APEI its:
* Allow multiple sources of NMI
* Abstract the estatus cache to use for SEI/SDEI
* Increase the priority of memory_failure_queue()s work,
* Provide a way to block ret_to-user to memory_failure work is done.

(These last two are the problem Xie XiuQi found).


Thanks,

James

[0]
https://static.docs.arm.com/ddi0587/a/RAS%20Extension-release%20candidate_march_29.pdf
