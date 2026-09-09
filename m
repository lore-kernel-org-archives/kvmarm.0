Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9453649BD81
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 22:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788993515; cv=none; b=iwpaVqLN2UilI+QMGqF8lT5dsaCeZwGFJw3tKKlBU04cK69H1Mr/aOofBC8NQve/ITj3cVW+XOx6tjlVW09QzN9D3w9ML7SvucDRjmWbQoa/YmmCHOKXR/sZFXWDq2sal3Mh9qu2BF1eFBx7KhjXpb3S6h4Vhr7jZHy3OZH7aw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788993515; c=relaxed/simple;
	bh=Xm5jnUsJZTLv4tuxcXr6PNnpqyZ2gStADAMIR/Sfjp8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=moYy5rFxiAkLYgnHNsu7T78MgjicwP7AL0KAOBZulg016XsxoRbGNn8f5kEfibhtybam7TPJeQ0PAKtzaGz8CLS51zPmfPeiki39Kkngy+wbYnCmVPn72x48aLivusYxLxOXAOstGMXKSv104sR0iSZ2tuZ7TZpenr88Zbj2X+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vi9OMXzD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vi9OMXzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386071F00893;
	Wed,  9 Sep 2026 22:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788993491;
	bh=kBe8T9HaCDUOxGzJjjMGhfl0eQ9mig9b/qGpsg9+MYI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Vi9OMXzDMaOo1loS5mmWr8zRyfHM8al5fiADB5CyAhrvQqYkJ5oI8yCgFQUNtVlEm
	 rNB42ETwiYrjNHTnsjuCqiJbwhu6EwCDJxOjQHxexFxIgMHG/HD4JOdz/4deeXmErC
	 Y1QAhEAmvVQCkarZIJTrSj2xpS1Cgvd1jB17+6I6FJMxe+h6JCJ1DibtJWNd2kyg42
	 ABlTOapIdAN8uZQb9tRNXpJgYI36CT1k/n/dntx6b/5RGIl32P2g94oQcE1DWtOS9D
	 HAMmDvTCmKIbaGYs/rwKKrkdtMjGCR82zq/ZSkAMC50/sGe4NA+De28NWM1fGbtTkU
	 Qr9+cuGF9pDiA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 2/3] arm64: sysreg: Add TCR_EL2 to sysreg
 infrastructure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei-Lin Chang" <weilin.chang@arm.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260909222015.3046432-3-weilin.chang@arm.com>
References: <20260909222015.3046432-1-weilin.chang@arm.com>
 <20260909222015.3046432-3-weilin.chang@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 22:38:10 +0000
Message-Id: <20260909223811.386071F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Declarative update to TCR_EL2 regenerates the TCR_EL2_RES1 aggre=
gate mask which is consumed by C initialization, requiring confirmation of =
robustness to future value changes.
--

commit 522a184d95be9c0f88cc6fb418668546ef83e3e4
Author: Wei-Lin Chang <weilin.chang@arm.com>

    arm64: sysreg: Add TCR_EL2 to sysreg infrastructure
   =20
    Convert TCR_EL2 to the sysreg infrastructure with data extracted from
    Registers.json of the BSD licenced AARCHMRS
    (AARCHMRS_OPENSOURCE_A_profile_FAT-2026-06).

> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 94bf065c8ac71..8d89f34580bac 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
[ ... ]
> +Sysreg	TCR_EL2		3	4	2	0	2
[ ... ]
> +Field	33	MTX
> +Field	32	DS
> +Res1	31
> +Field	30	TCMA
> +Field	29	TBID
> +Field	28	HWU62
> +Field	27	HWU61
> +Field	26	HWU60
> +Field	25	HWU59
> +Field	24	HPD
> +Res1	23
> +Field	22	HD

[Severity: Medium]
This isn't a bug, but this declarative update regenerates the TCR_EL2_RES1
aggregate mask. Are the C initialization consumers of this mask robust to i=
ts
value silently changing if a future .sysreg patch adds or removes a Res1 bi=
t?

For example, the generated mask is OR'd into the initial EL2 register value:

arch/arm64/kvm/arm.c:cpu_prepare_hyp_mode() {
    ...
    tcr |=3D TCR_EL2_RES1 | FIELD_PREP(TCR_EL2_PS_MASK, ips);
    ...
}

It is also used to initialize the guest emulation reset state in:

arch/arm64/kvm/sys_regs.c:sys_reg_descs[] =3D {
    ...
    EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
    ...
}

Because the generator's contract is to reflect global architectural truth, a
future edit that reclassifies a bit as Res1 will silently change the value =
of
TCR_EL2_RES1 without triggering a compiler or CI warning. Could you confirm
that these consumers do not rely on the previous static semantic value of t=
he
mask?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909222015.3046=
432-1-weilin.chang@arm.com?part=3D2
