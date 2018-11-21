From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH v2 16/23] KVM: arm64: Enumerate SVE register indices
 for KVM_GET_REG_LIST
Date: Wed, 21 Nov 2018 16:32:03 +0000
Message-ID: <20181121163201.GC3505@e103592.cambridge.arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-17-git-send-email-Dave.Martin@arm.com>
 <87k1l6ifa8.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 695294A2BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Nov 2018 11:32:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rTraANM-jqt2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Nov 2018 11:32:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D76524A1F2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Nov 2018 11:32:08 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <87k1l6ifa8.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 21, 2018 at 04:09:03PM +0000, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > This patch includes the SVE register IDs in the list returned by
> > KVM_GET_REG_LIST, as appropriate.
> >
> > On a non-SVE-enabled vcpu, no extra IDs are added.
> >
> > On an SVE-enabled vcpu, the appropriate number of slice IDs are
> > enumerated for each SVE register, depending on the maximum vector
> > length for the vcpu.
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >
> > Changes since RFCv1:
> >
> >  * Simplify enumerate_sve_regs() based on Andrew Jones' approach.
> >
> >  * Reg copying loops are inverted for brevity, since the order we
> >    spit out the regs in doesn't really matter.
> >
> > (I tried to keep part of my approach to avoid the duplicate logic
> > between num_sve_regs() and copy_sve_reg_indices(), but although
> > it works in principle, gcc fails to fully collapse the num_regs()
> > case... so I gave up.  The two functions need to be manually kept
> > consistent, but hopefully that's fairly straightforward.)
> > ---
> >  arch/arm64/kvm/guest.c | 45 ++++++++++++++++++++++++++++++++++++++++++=
+++
> >  1 file changed, 45 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index 320db0f..89eab68 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -323,6 +323,46 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, co=
nst struct kvm_one_reg *reg)
> >  	return copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)) ? -EFAULT : 0;
> >  }
> >
> > +static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
> > +{
> > +	const unsigned int slices =3D DIV_ROUND_UP(
> > +		vcpu->arch.sve_max_vl,
> > +		KVM_REG_SIZE(KVM_REG_ARM64_SVE_ZREG(0, 0)));
> =

> Having seen this formulation come up several times now I wonder if there
> should be a kernel private define, KVM_SVE_ZREG/PREG_SIZE to avoid this
> clumsiness.

I agree it's a bit awkward.  Previous I spelled this "0x100", which
was terse but more sensitive to typos and other screwups that Io
liked.

> You could still use the KVM_REG_SIZE to extract it as I guess this is to
> make changes simpler if/when the SVE reg size gets bumped up.

That might be more challenging to determine at compile time.

I'm not sure how good GCC is at doing const-propagation between related
(but different) expressions, so I preferred to go for something that
is clearly compiletime constant rather than extracting it from the
register ID that came from userspace.

So, I'd prefer not to use KVM_REG_SIZE() for this, but I'm happy to add
a private #define to hide this cumbersome construct.  That would
certainly make the code more readable.

(Of course, the actual runtime cost is trivial either way, but I felt
it was easier to reason about correctness if this is really a constant.)


Sound OK?

 > =

> > +
> > +	if (!vcpu_has_sve(vcpu))
> > +		return 0;
> > +
> > +	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */);
> > +}
> > +
> > +static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu, u64 __use=
r **uind)
> > +{
> > +	const unsigned int slices =3D DIV_ROUND_UP(
> > +		vcpu->arch.sve_max_vl,
> > +		KVM_REG_SIZE(KVM_REG_ARM64_SVE_ZREG(0, 0)));
> > +	unsigned int i, n;
> > +
> > +	if (!vcpu_has_sve(vcpu))
> > +		return 0;
> > +
> > +	for (i =3D 0; i < slices; i++) {
> > +		for (n =3D 0; n < SVE_NUM_ZREGS; n++) {
> > +			if (put_user(KVM_REG_ARM64_SVE_ZREG(n, i), (*uind)++))
> > +				return -EFAULT;
> > +		}
> > +
> > +		for (n =3D 0; n < SVE_NUM_PREGS; n++) {
> > +			if (put_user(KVM_REG_ARM64_SVE_PREG(n, i), (*uind)++))
> > +				return -EFAULT;
> > +		}
> > +
> > +		if (put_user(KVM_REG_ARM64_SVE_FFR(i), (*uind)++))
> > +			return -EFAULT;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  /**
> >   * kvm_arm_num_regs - how many registers do we present via KVM_GET_ONE=
_REG
> >   *
> > @@ -333,6 +373,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcp=
u)
> >  	unsigned long res =3D 0;
> >
> >  	res +=3D num_core_regs();
> > +	res +=3D num_sve_regs(vcpu);
> >  	res +=3D kvm_arm_num_sys_reg_descs(vcpu);
> >  	res +=3D kvm_arm_get_fw_num_regs(vcpu);
> >  	res +=3D NUM_TIMER_REGS;
> > @@ -357,6 +398,10 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu=
, u64 __user *uindices)
> >  		uindices++;
> >  	}
> >
> > +	ret =3D copy_sve_reg_indices(vcpu, &uindices);
> > +	if (ret)
> > +		return ret;
> > +
> >  	ret =3D kvm_arm_copy_fw_reg_indices(vcpu, uindices);
> >  	if (ret)
> >  		return ret;
> =

> Otherwise:
> =

> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>

Thanks
---Dave
