Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C130501295;
	Tue, 13 Oct 2026 13:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897313; cv=none; b=aHZm2VJtweZHXkDYP96QDsjK/CfDb8RkNbNpLM6STUYducap7eCQgYx0wnNaqFDMD/ifkGvV8CZwaBMPqa9231pitsEK75h6E4CnKfouQcmffwlqwz1P92UctXMxyWYTUqnJfmCyAKsDwCDWCugO/2hoxLjSC/riv7QNyFUvkrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897313; c=relaxed/simple;
	bh=Z+vMVIXE9PODI5Wjf5ENx6vbXQiccUCZkPzQaPzj5pI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ecbnpS39vZhmZTnK218KO97Io6VjDxPCoOIyDncbPPkxEMXrkCS9X8Gc0LaD8IgkJAwinCtocAHefGyE7ZW2mlnTb9u/C9CykTjVXJ4hC1ntWfhYzH5BJsAU7DUjYk9JS99zCwieV0EthYS/4vZpCBZXvomfsvKwFbXSe2qiO8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KpzAElXV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KpzAElXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA311F00893;
	Tue, 13 Oct 2026 13:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791897311;
	bh=L2lzIxBqaIeKi35f2v1IsK/Ll38K3FBX56QBG+TlL6c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KpzAElXVs/a80GANpGx4NmrwLsXtScp1Lcos1ADoaJsLsie7O7T9OZU2unl3E14TK
	 vGSnhhypHQtHPXtvBIkd7C0lxLBogySnmjDHsXsFFu653cTXYCj5yZeAZuVRDLJZkR
	 hZ6PBVWxn3pF/EjMNsYuIzgELNdXz8fLKjsN2WSeE0sIY64CUl/TRSlYfzOaqSRGPG
	 V0jH7yaKwpt4uHkFfgKt45uAtsBMkh9GZVQppTlnd6ZBnyXPoLgQMOts7Rj/Ja18B8
	 psjbP2cdoesppZFvRFUoxOIwK76PQwAuQRDYr3Q+MidCo/H0RiKWjTLhQu2M9iMKuO
	 eILcRRgRiwPtw==
Message-ID: <sashiko-outbox-169787@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] arm64: sysreg: Mark fields the architecture dropped
 as RES0
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261013130247.4135515-4-fuad.tabba@linux.dev>
References: <20261013130247.4135515-1-fuad.tabba@linux.dev>
 <20261013130247.4135515-4-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 13:15:11 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] arm64/sysreg: Semantic drift in auto-generated SCTLR_EL1_RES0 ma=
sk consumed by KVM
--

commit 60f264776efd2948b9996828935b2e973ae9b2bd
Author: Fuad Tabba <fuad.tabba@linux.dev>

arm64: sysreg: Mark fields the architecture dropped as RES0

Commit d65bf6e317e7 turned the TME fields of SCTLR_EL1 into RES0, but left
their copies in SCTLRMASK_EL1. PMICFILTR_EL0.T and BRBFCR_EL1.LASTFAILED
have gone from the architecture as well, so mark them all as RES0 to match
the spec.

> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 341db8e9b6c37..99af1c39478be 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg

[ ... ]

> @@ -2663,11 +2662,7 @@ Field	57	EPAN
>  Field	56	EnALS
>  Field	55	EnAS0
>  Field	54	EnASR
> -Field	53	TME
> -Field	52	TME0
> -Field	51	TMT
> -Field	50	TMT0
> -Res0	49:47
> +Res0	53:47

[Severity: Medium]
This change reclassifies bits 53:50 of SCTLR_EL1 (TME, TME0, TMT, TMT0) from
Field to Res0. This silently regenerates the aggregate mask SCTLR_EL1_RES0 =
to
include these bits.

This macro is actively consumed by KVM during C initialization via
FORCE_RES0(SCTLR_EL1_RES0) in sctlr_el1_feat_map() in arch/arm64/kvm/config=
.c:

arch/arm64/kvm/config.c:sctlr_el1_feat_map() {
    ...
    FORCE_RES0(SCTLR_EL1_RES0),
    ...
}

Could this cause a regression in KVM guest feature configuration for SCTLR_=
EL1
by forcing the removed TME bits to 0? Is KVM's initialization logic robust =
to
SCTLR_EL1_RES0 expanding to cover bits 53:50, and is forcing these bits to 0
for guests intended?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013130247.4135=
515-1-fuad.tabba@linux.dev?part=3D3
