Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96ADE33A708
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240945; cv=none; b=d3KxVyDHHC6itU3JUtnDg8mQFZ7/7tNruLvxhjRQ7SxPC+5jIPGl8hpehP7c5badcwcrhHeOe2tmM5i8EkRzHWFFSTLH3Rr+pRe0bL+dC8qZ1licWhDVOWKnIrcnjs28OUEr0KjX84f73cgYgjhe87yTXo/1cHrwOx1tkIHq96I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240945; c=relaxed/simple;
	bh=351in8L8uOjVVsiLrPdMiKJxFX/wH3aNmARtUyt8RDg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Wnv7j1Ka37b2ysed1U45bGeS3q+smU3rPvsRe7H7VO+iKWK/VvkMlro/N3m0LHbACwnMLbZPQzCZlhkZ+pEQRO9mgdkXkXLbjg2PhAKuWu5z9LpWCKEsZplRgAGY025lihAfHyyMIfhqQYUdwo4J2SD79z/e9pUEJWgMD8xAzdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L1VCg5Sj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L1VCg5Sj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214991F000E9;
	Tue, 23 Jun 2026 18:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240944;
	bh=S7rFYUsjFSb6HeHzdbEHphybCEnwwfY7lpOV7GTDwzw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L1VCg5SjrzYipwZ7RYJWahh6REzsiJOzHFPoWXMEQtUj9ZCh4+oMx+KuvqJw8go/w
	 LUeQqfzt7j/cpfRCtPWJeQI1vjd/QN3d280n0sCXxd9fMIOfmm52a5SoSKTAMSYNn+
	 SzUBH3jGijXc0E4G1G8wxLMrutJSh7WT+tvvJ8Ghf+doxqp60y+ND8IEOB5Uqem1gL
	 NK33+YdpPh7fR2gyLDpKwdblFjqsIXHV/3ogTm3YBWtRNnaolo8vfeYS77sS5/G3tN
	 XYAXyzeMTv5I9XRStKM5/EhgDpdbxbYF8xpWfaQxpffB6uBvqMShOiTnRTbmu3cnPW
	 7hlmQR2nLFaOw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 12/22] KVM: arm64: Create helper for stage-1 descriptor
 updates
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20260623184201.1518871-13-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-13-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 18:55:43 +0000
Message-Id: <20260623185544.214991F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Unused variable `new_desc` left behind after refactoring.
--

commit a77df785da34afbda05fb0cd124ac7baeff877cd
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: Create helper for stage-1 descriptor updates

This commit prepares for FEAT_HAFT support by creating a descriptor update
helper to be used for both leaf and table descriptors.

> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 816d23e7752df..0218176107b52 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c

[ ... ]

> @@ -617,25 +641,9 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_=
walk_info *wi,
> =20
>  	compute_s1_permissions(vcpu, wi, wr);
> =20
> -	if (wi->ha)
> -		new_desc |=3D PTE_AF;
> -
> -	if (new_desc !=3D ws.desc) {
> -		if (wi->s2 && !ws.s2_trans.writable) {
> -			fail_s1_walk(wr, ESR_ELx_FSC_PERM_L(ws.level), true);
> -			return -EPERM;
> -		}
> -
> -		ret =3D kvm_swap_s1_desc(vcpu, ws.desc_pa, ws.desc, new_desc, wi);
> -		if (ret =3D=3D -EAGAIN)
> -			return ret;
> -		if (ret) {
> -			fail_s1_walk(wr, ESR_ELx_FSC_SEA_TTW(ws.level), false);
> -			return ret;
> -		}
> -
> -		ws.desc =3D new_desc;
> -	}
> +	ret =3D handle_desc_update(vcpu, wi, &ws, wr, access);
> +	if (ret)
> +		return ret;

[Severity: Low]
Does this leave new_desc unused in walk_s1?

Looking at walk_s1, it appears new_desc is still declared at the top of the=
=20
function and assigned later on, but is no longer read after this change:

walk_s1() {
        u64 va_top, va_bottom, baddr, new_desc, va;
        ...
        new_desc =3D ws.desc;
        ...
}

Will leaving the declaration and assignment trigger an unused-but-set-varia=
ble
compiler warning?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623184201.1518=
871-1-oupton@kernel.org?part=3D12
