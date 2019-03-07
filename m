From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 22/26] KVM: arm64/sve: Add pseudo-register for the
 guest's vector lengths
Date: Thu, 7 Mar 2019 15:30:45 +0000
Message-ID: <20190307153042.GL3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-23-git-send-email-Dave.Martin@arm.com>
 <34b7691f-7acb-c9aa-6e53-2857e429f148@arm.com>
 <20190226121347.GT3567@e103592.cambridge.arm.com>
 <a8082d89-84bd-06fa-5781-96e11376bb66@arm.com>
 <20190301145503.GI3567@e103592.cambridge.arm.com>
 <5a3fda6d-5da8-8aa9-9b0e-36d6bcd7441b@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E865D4A4B0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 10:30:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XZcluNHk95Gq for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Mar 2019 10:30:50 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E08F4A4AB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 10:30:50 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <5a3fda6d-5da8-8aa9-9b0e-36d6bcd7441b@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 07, 2019 at 01:47:09PM +0000, Marc Zyngier wrote:
> Hi Dave,
> 
> On 01/03/2019 14:55, Dave Martin wrote:
> > [FYI Peter, your views on the proposal outlined torward the end of the
> > mail would be appreciated.]
> > 
> > On Fri, Mar 01, 2019 at 01:28:19PM +0000, Julien Thierry wrote:
> 
> [...]
> 
> >> I might be over-thinking it, but if there is a way to move that
> >> finalization call I'd prefer that.
> > 
> > I know what you mean, but there's not really another clear place to put
> > it either, right now.  Making finalization a side-effect of only KVM_RUN
> > and KVM_GET_REG_LIST would mean that if userspace is squirting in the
> > state of a migrated vcpu, a dummy KVM_GET_REG_LIST call would need to be
> > inserted between setting KVM_REG_ARM64_SVE_VLS and setting the other SVE
> > regs.
> > 
> > One thing we could to is get rid of the implicit finalization behaviour
> > completely, and require an explicit ioctl KVM_ARM_VCPU_FINALIZE to do
> 
> +1. In the past, implicit finalization has been a major pain, and the
> "implicit GICv2 configuration" has been an absolute disaster.
> 
> > this.  This makes a clear barrier between reg writes that manipulate the
> > "physical" configuration of the vcpu, and reg reads/writes that merely
> > manipulate the vcpu's runtime state.  Say:
> > 
> > 	KVM_ARM_VCPU_INIT(features[] = KVM_ARM_VCPU_SVE) -> ok
> > 	KVM_RUN -> -EPERM (too early)
> > 	KVM_GET_REG_LIST -> -EPERM (too early)
> > 	...
> > 	KVM_SET_ONE_REG(KVM_REG_ARM64_SVE_VLS) -> ok
> > 	KVM_SET_ONE_REG(KVM_REG_ARM64_SVE_ZREG(0, 0)) -> -EPERM (too early)
> > 	...
> > 	KVM_RUN -> -EPERM (too early)
> > 	...
> > 	KVM_ARM_VCPU_FINALIZE -> ok
> > 	KVM_ARM_VCPU_FINALIZE -> -EPERM (too late)
> > 	...
> > 	KVM_REG_REG_LIST -> ok
> > 	KVM_SET_ONE_REG(KVM_REG_ARM64_SVE_VLS) -> -EPERM (too late)
> > 	KVM_SET_ONE_REG(KVM_REG_ARM64_SVE_ZREG(0, 0)) -> ok
> > 	KVM_RUN -> ok
> > 	KVM_ARM_VCPU_FINALIZE -> -EPERM (too late)
> > 
> > This would change all existing kvm_arm_vcpu_finalize() calls to
> > 
> > 	if (!kvm_arm_vcpu_finalized())
> > 		return -EPERM;
> > 
> > (or similar).
> 
> I find this rather compelling, assuming we can easily map features that
> are associated to finalization.

OK ... thanks for taking a look.

> > Without an affected vcpu feature enabled, for backwards compatibility
> > we would not require the KVM_ARM_VCPU_FINALIZE call (or perhaps even
> > forbid it, since userspace that wants to backwards compatible cannot
> > use the new ioctl anyway.  I'm in two minds about this.  Either way,
> > calling _FINALIZE on an old kvm is harmless, so long as userspace knows
> > to ignore this failure case.)
> > 
> > The backwards-compatible flow would be:
> > 
> > 	KVM_ARM_VCPU_INIT(features[] = 0) -> ok
> > 	...
> > 	KVM_ARM_VCPU_FINALIZE -> ok (or -EPERM)
> > 	...
> > 	KVM_RUN -> ok
> > 	KVM_ARM_VCPU_FINALIZE -> -EPERM (too late)
> > 
> > 
> > Thoughts?
> 
> This goes back to the above question: how do we ensure that userspace
> knows which features are subject to being finalized. As it is currently
> described, KVM_ARM_VCPU_FINALIZE isn't qualified by a feature set, nor
> can the kernel report what feature flags requires being finalized. It is
> also unclear to me whether all "finalizable" features would have the
> same init cycle.

So, it's not clear whether any other features will ever need
finalization, and even if they do there's a fair chance they won't be
interdependent with SVE in such a way as to require multiple
finalization steps.

For now, it's seems reasonable to make the finalization call a no-op
when no finalization is required.

Where finalization is required, KVM_ARM_VCPU_FINALIZE becomes mandatory,
but the requirement is a) strictly opt-in, and b) userspace will quickly
discover if it gets this wrong.

For this reason I'd rather not have any explicit reporting of whether
finalization is needed or not (or why): we just document and enforce at
run-time.

> So either we take the simplest approach and make KVM_ARM_VCPU_FINALIZE
> strictly SVE specific (renaming it in the process), or it takes some
> argument that allow specifying the feature set it applies to. Maybe we
> can get away with the kernel not reporting which features require to be
> finalized as long that it is clearly documented.

OK, what about:

 * Userspace treats KVM_ARM_VCPU_FINALIZE() -> EINVAL as no error
   (so that userspace can simply insert this into its init sequence,
   even on old kernels).

 * We add an argument, so that KVM_ARM_VCPU_FINALIZE(0) means
   "finalize default stuff, including SVE".  We can add explicit flags
   later if needed to finalize individual features separately.

   I don't know whether any features ever will have interdependent
   finalization requirements, but this should help get us off the
   hook if so.


Question:

 * KVM_REG_ARM64_SVE_VLS is a weird register because of its special
   sequencing requirements.

   The main reason for this is to make it easier to detect migration
   to a mismatched destination node.  But userspace needs some explicit
   code to make all this work anyway, so should we just have a couple
   of ioctls to get/set it instead?

   If there's no strong view either way, I'll leave it as-is, to
   minimise churn.

[...]

> Please do your best to have something as close as possible to the final
> version for -rc1. From that point on, I'd expect changes to be mostly
> cosmetic.

This ought to be feasible.  The changes being discussed so far are non-
invasive.

Cheers
---Dave
