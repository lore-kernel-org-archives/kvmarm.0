Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE98A202963
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 23:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783551690; cv=none; b=BwWKleExjOc7vra4pt7hVA/3YhPvIkjQU9jtO45cW1sLZ/cA3/UGq9SxAXBAmKBo1rXLI7Z7hPPmHVf+uCHmA8K9KnDHzbJL+JM6fPj5vs4RHtFAm7QZMDrckltEn6JRUZDocK+Ts67e1nIG3qkSgfJtYYxqCu2NP9Ue5JQ8W60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783551690; c=relaxed/simple;
	bh=YaTHeUi6y9HZs5PjoeJxv1Xl4tlnEAnR1zU2A+KFtjU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DaD/7v7Jx2XUKCDvzElEkGFB+SmcoD4FtkZ89etSdr+WZgiQWYN01lrI1h+462mmUOT1pF1LJ4qUXj0okzZ98LPDxniXYNMgAPp3AUvxcTpags/jXaFeSYxVttcTJqj/ofLZ42bvBbMbrHgqE8x2YdwlboWmkJH1G/E4G5c9JnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F9pzwUxA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9pzwUxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DCA1F000E9;
	Wed,  8 Jul 2026 23:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783551689;
	bh=D6Reedv3tSB1zu6Or1SK+NSXfpuTsYNaeId17fYqaKs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F9pzwUxAKKf35BRM4IVLUXzzxh+NQkakNwQQk452A/YJzI5d3UOEZI4pacLu5X6OZ
	 BPsVnS1VGS1ywFAxfJWkvZLf4Pntw2OfsBbBxyh6zsVloexhbv35inS6q9JM6ejv42
	 6EVhjRKFptWye5Mw34M+PkMaTdEyi1mj99X6DWh4/FhkjykBXtHJbtSROPSWNzjrhM
	 Dew681+HWP2wuPfq6bj2fkPTO52c2/kxIzq9IgwUmDJCGOGIocDHUq2M3TL/ofrui4
	 ffyetD8p/EKWVKw09IvIKOd8rUVqrag4fHd+XlPncdndzVUj8andffoMBIHppKqN6p
	 Ya/cLggOWmBVg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6 v2 3/6] arm64: Fix early handling of FEAT_E2H0 not
 being implemented
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260708225124.4130846-4-coltonlewis@google.com>
References: <20260708225124.4130846-1-coltonlewis@google.com>
 <20260708225124.4130846-4-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 23:01:28 +0000
Message-Id: <20260708230129.13DCA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Writes to control-plane system registers are not immediately follo=
wed by an `isb()`.
--

--- Patch [3]: [PATCH 6.6 v2 3/6] arm64: Fix early handling of FEAT_E2H0 no=
t being implemented ---
commit 2b993fe86ae9a0ae8ce53be35446a4e7f0a66876
Author: Marc Zyngier <maz@kernel.org>

arm64: Fix early handling of FEAT_E2H0 not being implemented

Commit 3944382fa6f2 introduced checks for FEAT_E2H0 that were incorrect and
executed too late. This commit fixes the check for ID_AA64MMFR4_EL1.E2H0
and sets the HCR_EL2.E2H bit early to allow proper initialization for hVHE
mode as a nested guest.

Link: https://lore.kernel.org/r/20240321115414.3169115-1-maz@kernel.org

> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index e32c8dd0b17a7..e0e710b36da37 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
[ ... ]
> @@ -588,22 +603,10 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
> =20
>  	mov_q	x1, INIT_SCTLR_EL1_MMU_OFF
> =20
[ ... ]
>  	mrs	x0, hcr_el2
>  	and	x0, x0, #HCR_E2H
>  	cbz	x0, 2f
> -1:
> +
>  	/* Set a sane SCTLR_EL1, the VHE way */
>  	pre_disable_mmu_workaround
>  	msr_s	SYS_SCTLR_EL12, x1

[Severity: High]
This isn't a bug introduced by this patch, but shouldn't writes to
control-plane system registers be immediately followed by an isb()
instruction?

Looking at init_el2() in arch/arm64/kernel/head.S, as well as __init_el2_hc=
rx()
and __init_el2_timers() in arch/arm64/include/asm/el2_setup.h, there are
several locations where registers like SYS_SCTLR_EL12, SYS_HCRX_EL2, and
cnthctl_el2 are written without an immediate context synchronization event.

For example, right after the code shown in the diff above, SYS_SCTLR_EL12
is updated:

	msr_s	SYS_SCTLR_EL12, x1
	mov	x2, #BOOT_CPU_FLAG_E2H
	b	3f

Could executing the subsequent branch or ALU instructions under an
architecturally undefined pipeline state cause unpredictable behavior or
unexpected traps during early boot?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708225124.4130=
846-1-coltonlewis@google.com?part=3D3
