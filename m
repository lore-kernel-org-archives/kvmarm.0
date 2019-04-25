Return-Path: <SRS0=pAxc=S3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7279CC282E1
	for <kvmarm@archiver.kernel.org>; Thu, 25 Apr 2019 13:04:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6CF5020678
	for <kvmarm@archiver.kernel.org>; Thu, 25 Apr 2019 13:04:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CF5020678
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8989B4A417;
	Thu, 25 Apr 2019 09:04:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w+kibEgoSwdu; Thu, 25 Apr 2019 09:04:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F4854A44D;
	Thu, 25 Apr 2019 09:04:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAC6E4A417
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:04:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CyTmsnf9WQJJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Apr 2019 09:04:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A5A04A32E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:04:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB2BDA78;
 Thu, 25 Apr 2019 06:04:31 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C547E3F5C1;
 Thu, 25 Apr 2019 06:04:29 -0700 (PDT)
Date: Thu, 25 Apr 2019 14:04:27 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 07/14] KVM: arm64/sve: Make register ioctl access
 errors more consistent
Message-ID: <20190425130424.GA3567@e103592.cambridge.arm.com>
References: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
 <1555603631-8107-8-git-send-email-Dave.Martin@arm.com>
 <877ebiw9lm.fsf@zen.linaroharston>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <877ebiw9lm.fsf@zen.linaroharston>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>,
 Christoffer Dall <cdall@kernel.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190425130427.Hwa8DKTYDI_L9MIIF1s5NZg03PWzizGHBt_Mo_WeSLA@z>

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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
