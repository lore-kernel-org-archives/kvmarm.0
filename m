From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 07/14] KVM: arm64/sve: Make register ioctl access
 errors more consistent
Date: Thu, 25 Apr 2019 14:04:27 +0100
Message-ID: <20190425130424.GA3567@e103592.cambridge.arm.com>
References: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
 <1555603631-8107-8-git-send-email-Dave.Martin@arm.com>
 <877ebiw9lm.fsf@zen.linaroharston>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <877ebiw9lm.fsf@zen.linaroharston>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 25, 2019 at 01:30:29PM +0100, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > Currently, the way error codes are generated when processing the
> > SVE register access ioctls in a bit haphazard.
> >
> > This patch refactors the code so that the behaviour is more
> > consistent: now, -EINVAL should be returned only for unrecognised
> > register IDs or when some other runtime error occurs.  -ENOENT is
> > returned for register IDs that are recognised, but whose
> > corresponding register (or slice) does not exist for the vcpu.
> >
> > To this end, in {get,set}_sve_reg() we now delegate the
> > vcpu_has_sve() check down into {get,set}_sve_vls() and
> > sve_reg_to_region().  The KVM_REG_ARM64_SVE_VLS special case is
> > picked off first, then sve_reg_to_region() plays the role of
> > exhaustively validating or rejecting the register ID and (where
> > accepted) computing the applicable register region as before.
> >
> > sve_reg_to_region() is rearranged so that -ENOENT or -EPERM is not
> > returned prematurely, before checking whether reg->id is in a
> > recognised range.
> >
> > -EPERM is now only returned when an attempt is made to access an
> > actually existing register slice on an unfinalized vcpu.
> >
> > Fixes: e1c9c98345b3 ("KVM: arm64/sve: Add SVE support to register acces=
s ioctl interface")
> > Fixes: 9033bba4b535 ("KVM: arm64/sve: Add pseudo-register for the guest=
's vector lengths")
> > Suggested-by: Andrew Jones <drjones@redhat.com>
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Reviewed-by: Andrew Jones <drjones@redhat.com>

[...]

> > @@ -335,25 +344,30 @@ static int sve_reg_to_region(struct sve_state_reg=
_region *region,
> >  	/* Verify that we match the UAPI header: */
> >  	BUILD_BUG_ON(SVE_NUM_SLICES !=3D KVM_ARM64_SVE_MAX_SLICES);
> >
> > -	if ((reg->id & SVE_REG_SLICE_MASK) > 0)
> > -		return -ENOENT;
> > -
> > -	vq =3D sve_vq_from_vl(vcpu->arch.sve_max_vl);
> > -
> >  	reg_num =3D (reg->id & SVE_REG_ID_MASK) >> SVE_REG_ID_SHIFT;
> >
> >  	if (reg->id >=3D zreg_id_min && reg->id <=3D zreg_id_max) {
> > +		if (!vcpu_has_sve(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
> > +			return -ENOENT;
> > +
> > +		vq =3D sve_vq_from_vl(vcpu->arch.sve_max_vl);
> > +
> >  		reqoffset =3D SVE_SIG_ZREG_OFFSET(vq, reg_num) -
> >  				SVE_SIG_REGS_OFFSET;
> >  		reqlen =3D KVM_SVE_ZREG_SIZE;
> >  		maxlen =3D SVE_SIG_ZREG_SIZE(vq);
> >  	} else if (reg->id >=3D preg_id_min && reg->id <=3D preg_id_max) {
> > +		if (!vcpu_has_sve(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
> > +			return -ENOENT;
> > +
> > +		vq =3D sve_vq_from_vl(vcpu->arch.sve_max_vl);
> > +
> =

> I suppose you could argue for a:
> =

> 	if (reg->id >=3D zreg_id_min && reg->id <=3D preg_id_max) {
> 		if (!vcpu_has_sve(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
> 			return -ENOENT;
> =

> 		vq =3D sve_vq_from_vl(vcpu->arch.sve_max_vl);
> =

>                 if (reg->id <=3D zreg_id_max) {
> 			reqoffset =3D SVE_SIG_ZREG_OFFSET(vq, reg_num) -
> 				SVE_SIG_REGS_OFFSET;
> 			reqlen =3D KVM_SVE_ZREG_SIZE;
> 			maxlen =3D SVE_SIG_ZREG_SIZE(vq);
>                 } else {
> 			reqoffset =3D SVE_SIG_PREG_OFFSET(vq, reg_num) -
> 				SVE_SIG_REGS_OFFSET;
> 			reqlen =3D KVM_SVE_PREG_SIZE;
> 			maxlen =3D SVE_SIG_PREG_SIZE(vq);
> 		}
> 	} else {
> 		return -EINVAL;
> 	}
> =

> but only for minimal DRY reasons.

Agreed, but that bakes in another assumption: that the ZREG and PREG ID
ranges are contiguous.

I preferred to keep the number of assumptions down.

Althoug the resulting code wasn't ideal, the actual amount of
duplication that I ended up with here seemed low enough as to be
acceptable (though opinions can differ on that).

[...]

Cheers
---Dave
