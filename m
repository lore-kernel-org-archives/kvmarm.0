Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA00737CD4E
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 22:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682431; cv=none; b=LXqRkPT3ADYyJmjfQrUoT6ytfOy4PxRh0AsXOJhGGNElqVe91sNQrXgKzbVky7F/eqri+pTKnhbkUHCM082/HJUw8VG6rKRtY2cIoUg/G5g8EQnNlbbqvaaxCQIIh4iGGk7mCbn/ifdrpXL4Hb8L5WlBMe8SSZcTOXfyu7Ydk6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682431; c=relaxed/simple;
	bh=alYx0GsjlT/8VLkBk0Pz2t7vbSEu3B1sIMj0quOdqZU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aG3bXa2sg4XlFvaeUJ8ub3yEVGb1GbhT1XLOgvOoO6WY+1NlMwlktOjw3NO7j+uhXaJAowayQJoWT2iYoUHdStWX7wssBNc/35D4TJaN73jYc8CppRLKiIZ++BsT4BNtsodbx7yw0dixGDZmNTUbT96DffFkHnyKDPrHxfG1obA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XSS7wqEj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XSS7wqEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9911F000FF;
	Thu, 17 Sep 2026 22:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789682429;
	bh=jhMTApUKUomrN/8X6sf2avUcI3w0tlEfnrWPywlVccg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XSS7wqEjr8WJ7A08yXhZrJK5RcsRUmnqJBOk/A3xOOJ6PdwCpe0ts8NbMpJZWNlA8
	 SpZ1pryA8j67T7Y+Aed3q5pY95/2vHA4drmGXRWo3sQYJhcFO2+ZbKN87puFPudF/b
	 AkPctzGECqtM5FunUWDBfaiIzpsRiasgYx8dhnF7kh/93deAIbEeb581VqFAn6z6ql
	 idncNhGWC287GYRV2RDX8lIl/v4NFXkEVnJ61nBLGD7V3dokLti261RIyGXPOHm5EW
	 pgZWqK4l/CBEyunBmjGT4btu4Ewyil0ENhlSbaW2EHU+1vJEJXTF9FeK5bD4bzhbe9
	 apnJYT+PPA4vA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/4] KVM: arm64: Convert TCR_EL2 to config-driven
 sanitisation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei-Lin Chang" <weilin.chang@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260917214215.74135-5-weilin.chang@arm.com>
References: <20260917214215.74135-1-weilin.chang@arm.com>
 <20260917214215.74135-5-weilin.chang@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 22:00:28 +0000
Message-Id: <20260917220029.4D9911F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kvm: arm64: static TCR_EL2 mask based on FEAT_E2H0 breaks dynamic =
E2H layouts
--

commit 18ffaaa0986bf7864d7ed4beba6765c60e2a26c1
Author: Wei-Lin Chang <weilin.chang@arm.com>

KVM: arm64: Convert TCR_EL2 to config-driven sanitisation
   =20
This commit converts the translation control register TCR_EL2 to use the
config-driven sanitisation framework. It extracts feature dependencies
from the BSD-licensed AARCHMRS Registers.json, applying some manual
deviations for dependencies like TCR_EL2.TCMA and FEAT_ASID16.

> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 1053676551aff..080b3510b7831 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
[ ... ]
> @@ -1611,6 +1718,12 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, en=
um vcpu_sysreg reg)
>  	case SCTLR2_EL2:
>  		resx =3D compute_reg_resx_bits(kvm, &sctlr2_desc, 0, 0);
>  		break;
> +	case TCR_EL2:
> +		if (kvm_has_feat(kvm, FEAT_E2H0))
> +			resx =3D compute_reg_resx_bits(kvm, &tcr_el2_desc, 0, 0);
> +		else
> +			resx =3D compute_reg_resx_bits(kvm, &vhe_tcr_el2_desc, 0, 0);
> +		break;

[Severity: High]
Does this static choice in get_reg_fixed_bits() break dynamic E2H layouts f=
or
nested guests? When FEAT_E2H0 is present on the host, this restricts the sy=
sreg
mask to the E2H=3D0 layout for all TCR_EL2 accesses, ignoring that guests c=
an
still dynamically enter E2H=3D1 mode.

If a nested hypervisor runs on a host with FEAT_E2H0, sets HCR_EL2.E2H =3D =
1,
and writes to TCR_EL2 expecting the VHE layout, KVM will intercept the writ=
e.
When passed to kvm_vcpu_apply_reg_masks(), the VHE-specific bits (e.g., EPD=
1,
T1SZ, TG1, IPS) will be cleared because they overlap with RES0 bits in the
static nVHE mask. Could this corrupt translation table configurations and
cause translation aborts?

>  	case TCR2_EL2:
>  		resx =3D compute_reg_resx_bits(kvm, &tcr2_el2_desc, 0, 0);
>  		break;

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 7f13f0077c9f4..3e01123d00ca0 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
[ ... ]
> @@ -1957,6 +1957,10 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
>  	resx =3D get_reg_fixed_bits(kvm, HFGITR2_EL2);
>  	set_sysreg_masks(kvm, HFGITR2_EL2, resx);
> =20
> +	/* TCR_EL2 */
> +	resx =3D get_reg_fixed_bits(kvm, TCR_EL2);
> +	set_sysreg_masks(kvm, TCR_EL2, resx);

[Severity: High]
Does this application in kvm_init_nv_sysregs() cause valid guest writes to =
be
clobbered?

Since the wrongly computed static mask is applied to the VM's sysreg_masks
array here, it looks like it will break nested virtualization for any nested
guest running in VHE mode.

> +
>  	/* TCR2_EL2 */
>  	resx =3D get_reg_fixed_bits(kvm, TCR2_EL2);
>  	set_sysreg_masks(kvm, TCR2_EL2, resx);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917214215.7413=
5-1-weilin.chang@arm.com?part=3D4
