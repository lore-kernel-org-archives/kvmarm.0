From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v6 22/27] KVM: arm/arm64: Add KVM_ARM_VCPU_FINALIZE ioctl
Date: Wed, 27 Mar 2019 17:42:24 +0000
Message-ID: <20190327174223.GY3567@e103592.cambridge.arm.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
 <1553017938-710-23-git-send-email-Dave.Martin@arm.com>
 <e49ba75d-518d-22bb-6ed9-be986064efcc@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBCC84A3B2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Mar 2019 13:42:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N2LyR3dj0rsr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Mar 2019 13:42:29 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40F014A420
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Mar 2019 13:42:29 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <e49ba75d-518d-22bb-6ed9-be986064efcc@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 27, 2019 at 02:07:56PM +0000, Julien Thierry wrote:
> Hi Dave,
> 
> On 19/03/2019 17:52, Dave Martin wrote:
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
> I had a bit of hesitation for having a per feature ioctl call but in the
> end this seems a simple enough to keep existing guest (not doing the
> ioctl call) working and checking that the necessary features have been
> finalized is also pretty straight forward.

The main reason for this is to keep things extensible.

We could end up with one feature that has to be finalized before a
second feature can be configured -- with a single "finalize everything"
call we wouldn't be able to cope with that.

Creating a vcpu is a relatively rare, expensive event, so adding a few
extra ioctls to that is probably not the end of the world.  _Most_
features won't need finalization at all.

> Reviewed-by: Julien Thierry <julien.thierry@arm.com>

Thanks
---Dave
