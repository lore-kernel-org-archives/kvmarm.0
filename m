From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v7 23/27] KVM: arm64/sve: Add pseudo-register for the
 guest's vector lengths
Date: Fri, 5 Apr 2019 17:41:31 +0200
Message-ID: <20190405154131.ecbq33b3o7pvfmrw@kamzik.brq.redhat.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-24-git-send-email-Dave.Martin@arm.com>
 <20190404203109.lrt5czzlqpritecd@kamzik.brq.redhat.com>
 <20190405093610.GN3567@e103592.cambridge.arm.com>
 <20190405102204.m4depbrkn5f3btnz@kamzik.brq.redhat.com>
 <20190405140640.GC3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190405140640.GC3567@e103592.cambridge.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 05, 2019 at 03:06:40PM +0100, Dave Martin wrote:
> On Fri, Apr 05, 2019 at 12:22:04PM +0200, Andrew Jones wrote:
> > On Fri, Apr 05, 2019 at 10:36:10AM +0100, Dave Martin wrote:
> > > On Thu, Apr 04, 2019 at 10:31:09PM +0200, Andrew Jones wrote:
> > > > On Fri, Mar 29, 2019 at 01:00:48PM +0000, Dave Martin wrote:
> > > > > This patch adds a new pseudo-register KVM_REG_ARM64_SVE_VLS to
> > > > > allow userspace to set and query the set of vector lengths visible
> > > > > to the guest.
> > > > > 
> > > > > In the future, multiple register slices per SVE register may be
> > > > > visible through the ioctl interface.  Once the set of slices has
> > > > > been determined we would not be able to allow the vector length set
> > > > > to be changed any more, in order to avoid userspace seeing
> > > > > inconsistent sets of registers.  For this reason, this patch adds
> > > > > support for explicit finalization of the SVE configuration via the
> > > > > KVM_ARM_VCPU_FINALIZE ioctl.
> > > > > 
> > > > > Finalization is the proper place to allocate the SVE register state
> > > > > storage in vcpu->arch.sve_state, so this patch adds that as
> > > > > appropriate.  The data is freed via kvm_arch_vcpu_uninit(), which
> > > > > was previously a no-op on arm64.
> > > > > 
> > > > > To simplify the logic for determining what vector lengths can be
> > > > > supported, some code is added to KVM init to work this out, in the
> > > > > kvm_arm_init_arch_resources() hook.
> > > > > 
> > > > > The KVM_REG_ARM64_SVE_VLS pseudo-register is not exposed yet.
> > > > > Subsequent patches will allow SVE to be turned on for guest vcpus,
> > > > > making it visible.
> > > > > 
> > > > > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > > > > Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> > > > > Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> > > 
> > > [...]
> > > 
> > > > > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > > 
> > > [...]
> > > 
> > > > > +/*
> > > > > + * Finalize vcpu's maximum SVE vector length, allocating
> > > > > + * vcpu->arch.sve_state as necessary.
> > > > > + */
> > > > > +static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +	void *buf;
> > > > > +	unsigned int vl;
> > > > > +
> > > > > +	vl = vcpu->arch.sve_max_vl;
> > > > > +
> > > > > +	/*
> > > > > +	 * Resposibility for these properties is shared between
> > > > > +	 * kvm_arm_init_arch_resources(), kvm_vcpu_enable_sve() and
> > > > > +	 * set_sve_vls().  Double-check here just to be sure:
> > > > > +	 */
> > > > > +	if (WARN_ON(!sve_vl_valid(vl) || vl > sve_max_virtualisable_vl ||
> > > > > +		    vl > SVE_VL_ARCH_MAX))
> > > > > +		return -EIO;
> > > > > +
> > > > > +	buf = kzalloc(SVE_SIG_REGS_SIZE(sve_vq_from_vl(vl)), GFP_KERNEL);
> > > > > +	if (!buf)
> > > > > +		return -ENOMEM;
> > > > > +
> > > > > +	vcpu->arch.sve_state = buf;
> > > > > +	vcpu->arch.flags |= KVM_ARM64_VCPU_SVE_FINALIZED;
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > > +int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int what)
> > > > > +{
> > > > > +	switch (what) {
> > > > > +	case KVM_ARM_VCPU_SVE:
> > > > > +		if (!vcpu_has_sve(vcpu))
> > > > > +			return -EINVAL;
> > > > > +
> > > > > +		if (kvm_arm_vcpu_sve_finalized(vcpu))
> > > > > +			return -EPERM;
> > > > > +
> > > > > +		return kvm_vcpu_finalize_sve(vcpu);
> > > > 
> > > > In the next patch I see that we already have KVM_ARM64_GUEST_HAS_SVE
> > > > set in vcpu->arch.flags at this point. So if this kvm_vcpu_finalize_sve()
> > > > call fails, shouldn't we unset KVM_ARM64_GUEST_HAS_SVE and anything
> > > > else used to indicate the vcpu has sve?
> > > 
> > > If this fails, either userspace did the wrong thing, or there was some
> > > fatal error (like the ENOMEM case).  Either way, the vcpu is not runnable
> > > and userspace is expected to bail out.
> > > 
> > > Further, KVM_ARM_VCPU_INIT fixes the set of features requested by
> > > userspace: we shouldn't change the set of features under userspace's
> > > feet and try to limp on somehow.  We have no means for userspace to find
> > > out that some features went away in the meantime...
> > > 
> > > So, what would you be trying to achieve with this change?
> > 
> > Being able to do additional vcpu ioctls with only partially initialized
> > sve (sve_state is still null, but we otherwise believe the vcpu has sve).
> > That sounds risky. Although I see we only set KVM_ARM64_VCPU_SVE_FINALIZED
> > when everything, like the memory allocation, succeeds, so we're probably
> > fine. Indeed having KVM_ARM64_GUEST_HAS_SVE and not KVM_ARM64_VCPU_SVE_FINALIZED
> > is likely the safest vcpu state for a vcpu that failed to finalize sve.
> 
> This was my rationale: every non-trivial operation that is affected by
> SVE operation checks for kvm_arm_vcpu_sve_finalized(): accessing
> KVM_REG_ARM64_SVE_VLS should be the only exception.
> 
> Of course, people might forget that in new code, but I think all the
> major ABI code paths that are likely to exist for SVE are already there
> now.
> 
> Does this sound OK, or do you still have concerns?
> 
> Clearing KVM_ARM64_GUEST_HAS_SVE could be done on finalization failure;
> it just feels a bit weird.

Let's leave it. It's safe now, and there's always risk new code could
screw something up, no matter which way we go now, so let's pick the
simpler way.

Thanks,
drew
