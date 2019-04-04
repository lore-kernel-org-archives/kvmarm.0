From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 22/27] KVM: arm/arm64: Add KVM_ARM_VCPU_FINALIZE ioctl
Date: Thu, 4 Apr 2019 17:47:07 +0100
Message-ID: <20190404164707.GH3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-23-git-send-email-Dave.Martin@arm.com>
 <20190404150709.ihxlndxc6mvuwomp@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B9344A422
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 12:47:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LSnhi0xkUzGA for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Apr 2019 12:47:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEF0D4A331
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 12:47:12 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190404150709.ihxlndxc6mvuwomp@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 04, 2019 at 05:07:09PM +0200, Andrew Jones wrote:
> On Fri, Mar 29, 2019 at 01:00:47PM +0000, Dave Martin wrote:
> > Some aspects of vcpu configuration may be too complex to be
> > completed inside KVM_ARM_VCPU_INIT.  Thus, there may be a
> > requirement for userspace to do some additional configuration
> > before various other ioctls will work in a consistent way.
> > 
> > In particular this will be the case for SVE, where userspace will
> > need to negotiate the set of vector lengths to be made available to
> > the guest before the vcpu becomes fully usable.
> > 
> > In order to provide an explicit way for userspace to confirm that
> > it has finished setting up a particular vcpu feature, this patch
> > adds a new ioctl KVM_ARM_VCPU_FINALIZE.
> > 
> > When userspace has opted into a feature that requires finalization,
> > typically by means of a feature flag passed to KVM_ARM_VCPU_INIT, a
> > matching call to KVM_ARM_VCPU_FINALIZE is now required before
> > KVM_RUN or KVM_GET_REG_LIST is allowed.  Individual features may
> > impose additional restrictions where appropriate.
> > 
> > No existing vcpu features are affected by this, so current
> > userspace implementations will continue to work exactly as before,
> > with no need to issue KVM_ARM_VCPU_FINALIZE.
> > 
> > As implemented in this patch, KVM_ARM_VCPU_FINALIZE is currently a
> > placeholder: no finalizable features exist yet, so ioctl is not
> > required and will always yield EINVAL.  Subsequent patches will add
> > the finalization logic to make use of this ioctl for SVE.
> > 
> > No functional change for existing userspace.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> > Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> > 
> > ---
> > 
> > Changes since v5:
> > 
> >  * Commit message, including subject line, rewritten.
> > 
> >    This patch is a rework of "KVM: arm/arm64: Add hook to finalize the
> >    vcpu configuration".  The old subject line and commit message no
> >    longer accurately described what the patch does.  However, the code
> >    is an evolution of the previous patch rather than a wholesale
> >    rewrite.
> > 
> >  * Added an explicit KVM_ARM_VCPU_FINALIZE ioctl, rather than just
> >    providing internal hooks in the kernel to finalize the vcpu
> >    configuration implicitly.  This allows userspace to confirm exactly
> >    when it has finished configuring the vcpu and is ready to use it.
> > 
> >    This results in simpler (and hopefully more maintainable) ioctl
> >    ordering rules.
> > ---
> >  arch/arm/include/asm/kvm_host.h   |  4 ++++
> >  arch/arm64/include/asm/kvm_host.h |  4 ++++
> >  include/uapi/linux/kvm.h          |  3 +++
> >  virt/kvm/arm/arm.c                | 18 ++++++++++++++++++
> >  4 files changed, 29 insertions(+)
> > 
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > index a49ee01..e80cfc1 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -19,6 +19,7 @@
> >  #ifndef __ARM_KVM_HOST_H__
> >  #define __ARM_KVM_HOST_H__
> >  
> > +#include <linux/errno.h>
> >  #include <linux/types.h>
> >  #include <linux/kvm_types.h>
> >  #include <asm/cputype.h>
> > @@ -411,4 +412,7 @@ static inline int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
> >  	return 0;
> >  }
> >  
> > +#define kvm_arm_vcpu_finalize(vcpu, what) (-EINVAL)
> > +#define kvm_arm_vcpu_is_finalized(vcpu) true
> > +
> 
> We usually use inline functions for the stubs.

I guess we could.

The vcpu_has_sve() circular include problem applies here too if we put
the actual function bodies here, which is why I ended up with this.  Now
that the bodies (for arm64) are out of line, it actually doesn't matter.

> >  #endif /* __ARM_KVM_HOST_H__ */
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 3e89509..98658f7 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -23,6 +23,7 @@
> >  #define __ARM64_KVM_HOST_H__
> >  
> >  #include <linux/bitmap.h>
> > +#include <linux/errno.h>
> >  #include <linux/types.h>
> >  #include <linux/jump_label.h>
> >  #include <linux/kvm_types.h>
> > @@ -625,4 +626,7 @@ void kvm_arch_free_vm(struct kvm *kvm);
> >  
> >  int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
> >  
> > +#define kvm_arm_vcpu_finalize(vcpu, what) (-EINVAL)
> > +#define kvm_arm_vcpu_is_finalized(vcpu) true
> 
> Same as above.

Ditto

> > +
> >  #endif /* __ARM64_KVM_HOST_H__ */
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index dc77a5a..c3b8e7a 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1441,6 +1441,9 @@ struct kvm_enc_region {
> >  /* Available with KVM_CAP_HYPERV_CPUID */
> >  #define KVM_GET_SUPPORTED_HV_CPUID _IOWR(KVMIO, 0xc1, struct kvm_cpuid2)
> >  
> > +/* Available with KVM_CAP_ARM_SVE */
> > +#define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
> > +
> >  /* Secure Encrypted Virtualization command */
> >  enum sev_cmd_id {
> >  	/* Guest initialization commands */
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index c69e137..9edbf0f 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -545,6 +545,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
> >  	if (likely(vcpu->arch.has_run_once))
> >  		return 0;
> >  
> > +	if (!kvm_arm_vcpu_is_finalized(vcpu))
> > +		return -EPERM;
> > +
> >  	vcpu->arch.has_run_once = true;
> >  
> >  	if (likely(irqchip_in_kernel(kvm))) {
> > @@ -1116,6 +1119,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> >  		if (unlikely(!kvm_vcpu_initialized(vcpu)))
> >  			break;
> >  
> > +		r = -EPERM;
> > +		if (!kvm_arm_vcpu_is_finalized(vcpu))
> > +			break;
> > +
> 
> What's the rationale for using EPERM? The finalized concept is very
> similar to the initialized one. So why not also use ENOEXEC for it too?

Hmm, I guess we could equally return ENOEXEC.  Initially this felt like
a more distinctive case.

Assuming Marc is happy to take an ABI fix into kvmarm/next, I'm can
change them.  We're not absolutely committed until this hits mainline...

> >  		r = -EFAULT;
> >  		if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
> >  			break;
> > @@ -1169,6 +1176,17 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> >  
> >  		return kvm_arm_vcpu_set_events(vcpu, &events);
> >  	}
> > +	case KVM_ARM_VCPU_FINALIZE: {
> > +		int what;
> > +
> > +		if (!kvm_vcpu_initialized(vcpu))
> > +			return -ENOEXEC;
> > +
> > +		if (get_user(what, (const int __user *)argp))
> > +			return -EFAULT;
> > +
> > +		return kvm_arm_vcpu_finalize(vcpu, what);
> 
> Almost all the cases use the 'r = ...; break;' type of pattern, leaving
> it to the 'return r' at the end of the function. I guess that's in case
> at some point more stuff is added after the switch. The only cases that
> don't do that are the most recent ones KVM_GET/SET_VCPU_EVENTS, which
> should probably be changed to fit the pattern too, rather than this
> new ioctl following there pattern.

I have no strong opinion on this: it's basically a question of style.
I followed KVM_GET/SET_VCPU_EVENTS, but you're right, the
r = ...; break; style is used for the others.

If there's an intention of putting stuff at the end of the function,
it will make a difference.  But this seems unlikely to happen: this
function is really just a dispatcher.

I'm happy to change it (and the others) if there are strong views.

Cheers
---Dave
