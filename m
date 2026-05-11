Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D1B3FBEBB;
	Mon, 11 May 2026 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778509072; cv=none; b=I8wLJDuegZ65e/FJpmJD4KnDdqj0lsA9eXQzgiEbpBvrO5VeBCYaYp01YCDqK0IL5NrFP8jBDGcZDKS2UoaVZG48cCZOiEki3SEriK0fzNQy2bcNAgbmX5DRU7cyVPyj8fsioe+SrVDftwwriwf6xY4oFTtzQ35Y+e2TgLOFVZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778509072; c=relaxed/simple;
	bh=PoPH1hLv2jxdj4u9FglKmzcibTYxjvZi2FCP3Jj0JyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c/CWAKwKgeoW5Jl2BCGi0qPkn1fehlEfaurXCu0s2by202jhL+KI8GKTEZ9MYc6wjcjr26WRBbTzQ5mQ4rJCyC+g1Pro/YEBeI+l3ivNskVCcDTgT/e6PspvIBZ0/CtfTwkX9aQqMdN+A357iEAn1w3CXv2qbcxt26CHrqrQu3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LgCm463B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LgCm463B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A694C2BCB0;
	Mon, 11 May 2026 14:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778509071;
	bh=PoPH1hLv2jxdj4u9FglKmzcibTYxjvZi2FCP3Jj0JyI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LgCm463B1qty6DCjJAOJs85JT4vLLtvrDpRPW1sSuWDjZEyg7Ri9VM8Jk01nX7fhD
	 Usx66rHpvka2awfNbISJaY1bU8ynX6Q4kApa2H6SEkAzi7B23Gjb/rI2td98JaTdWj
	 9DFjwzCt4RrO+Uwd7dk5Z5jZSbvfJsRhn0kxCguNimqnHtyTkXoje7a08zQ39Oa4qA
	 vEoDOOGgOwd9WE3Xq3tWF6KNWlXNDpXBYJjFsIyXWan2CqpubqvUtkDu+7pv9PyMZR
	 5xC7MnuTldIsP0F91VO/XyyZrSDjhX8jbzQueQsk+JiEAk7Xz9fbP3mDYLLWOAE43s
	 n7Au8uXjO0ruw==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 3F5471AC58A9; Mon, 11 May 2026 15:17:49 +0100 (BST)
Date: Mon, 11 May 2026 23:17:49 +0900
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 15/30] KVM: arm64: Support SME control registers
Message-ID: <agHlDeXRNjutoTV7@sirena.co.uk>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-15-43f7683a0fb7@kernel.org>
 <af4bWxiOogfPz_dp@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="n8F9ND23WpqrUELD"
Content-Disposition: inline
In-Reply-To: <af4bWxiOogfPz_dp@J2N7QTR9R3>
X-Cookie: Truckers welcome.


--n8F9ND23WpqrUELD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 08, 2026 at 06:20:27PM +0100, Mark Rutland wrote:

> > +static bool access_smcr_el2(struct kvm_vcpu *vcpu,
> > +			    struct sys_reg_params *p,
> > +			    const struct sys_reg_desc *r)
> > +{

> > +	vq =3D SYS_FIELD_GET(SMCR_ELx, LEN, smcr) + 1;
> > +	vq =3D min(vq, vcpu_sme_max_vq(vcpu));
> > +	smcr &=3D ~SMCR_ELx_LEN_MASK;
> > +	smcr |=3D SYS_FIELD_PREP(SMCR_ELx, LEN, vq - 1);

> I'm not sure this sanitization is correct or necessary, and the same
> concern applies to ZCR_ELx.LEN.

> AFAICT, none of the values for the SMCR_ELx.LEN and ZCR_ELx.LEN fields
> are reserved or unallocated. Thus all the bits of those fields should be
> stateful, and a read should observe the last value written, regardless
> of the effective value of the field.

=2E..

> Either what we're doing is wrong, or the architcture requires a
> clarification to say that values corresponding to unimplmented vector
> lengths are reserved.

> If those bit are always stateful, the the logic to sanitize the LEN
> field shouldn't live here, and that will need to happen when consuming
> the effective value.

Your understanding of how these fields work matches mine, and writing
unimplemented values is part of the documented procedure for enumerating
the set of supported vector lengths.

As you note this is duplicated from the handling of ZCR_ELx, it's not
clear to me why the code does this but I figured there must be some good
reason for doing things this way that I just wasn't seeing and that it
was safer to fit in with the existing code.  The handling for vector
lengths in general and especially with NV was quite unclear,
particularly prior to your fixes in 59419f10045b (KVM: arm64: Eagerly
switch ZCR_EL{1,2}).

The changelog for b3d29a823099 ("KVM: arm64: nv: Handle ZCR_EL2 traps")
which introduced this for ZCR_ELx has a mention of mapping the requested
VL but it's not entirely clear to me what it means by that.  It does
mean that we can just load guest ZCR_EL2 and get the correct behaviour
for guest EL1 and EL0 when loading the guest state so perhaps that might
be all there is to it.

My expectation would have been to restrict the guest EL1/0 VL when we
load state into the registers as you allude to, something more like the
below (off the top of my head and completely untested, I'll pull this
into a proper patch later):

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/i=
nclude/hyp/switch.h
index 98b2976837b1..ddf8c2246139 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -501,11 +501,11 @@ static inline void fpsimd_lazy_switch_to_guest(struct=
 kvm_vcpu *vcpu)
 		return;
=20
 	if (vcpu_has_sve(vcpu)) {
+		zcr_el2 =3D vcpu_sve_max_vq(vcpu) - 1;
+
 		/* A guest hypervisor may restrict the effective max VL. */
-		if (is_nested_ctxt(vcpu))
-			zcr_el2 =3D __vcpu_sys_reg(vcpu, ZCR_EL2);
-		else
-			zcr_el2 =3D vcpu_sve_max_vq(vcpu) - 1;
+		if (is_nested_ctxt(vcpu) && !is_hyp_ctxt(vcpu))
+			zcr_el2 =3D min(zcr_el2, __vcpu_sys_reg(vcpu, ZCR_EL2));
=20
 		write_sysreg_el2(zcr_el2, SYS_ZCR);
=20
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 148fc3400ea8..b48f41acff82 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2874,9 +2874,7 @@ static bool access_zcr_el2(struct kvm_vcpu *vcpu,
 		return true;
 	}
=20
-	vq =3D SYS_FIELD_GET(ZCR_ELx, LEN, p->regval) + 1;
-	vq =3D min(vq, vcpu_sve_max_vq(vcpu));
-	__vcpu_assign_sys_reg(vcpu, ZCR_EL2, vq - 1);
+	__vcpu_assign_sys_reg(vcpu, ZCR_EL2, p->regval);
 	return true;
 }
=20

--n8F9ND23WpqrUELD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoB5QwACgkQJNaLcl1U
h9C9fQf9EqPdViWDz4IqJr6p68k3C3Z9Tjk45s2BXBpgqwuYzVNxhjJ2wpZtNfoV
wRug/tY+UgfK/E8k3S+qgR6o9mni0kBYMtlZ/7C3i7OcmzX/5UouYWRwsDSC351L
ajfvCDNbXL83nGeIqewq5MZ9RomdG/iGuyZg32KDA1UpdqUgCasVQbCzcfJ79SVW
5t5e6jJPONe7OpWNCrfkNmuo1Fxp4klcuEes5RLuo9d/BL6vgaeyhPth4c1LRgSJ
oOZ2M2oEoUFrypqwaRBh9bZFuLGl/eYoa6fPVPAHDQs/jEkHRDyhq4S3HcmJjAsz
Z+OUomQf7zJidan7Czxc4ASuGKSu6Q==
=zHz8
-----END PGP SIGNATURE-----

--n8F9ND23WpqrUELD--
