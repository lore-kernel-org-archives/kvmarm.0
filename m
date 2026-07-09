Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D488B2D877B
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 22:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783637179; cv=none; b=OHrsu0tR0A+4Qy/AOltUwgpena0qnLv50ITLq6027Y/WBsIQlbipsgWXU6U+skuKr6hQOKPHAfJQ8N9F5tEurKbXino5CO09T2XBZHPOff4Dln6gJ6CutXjGFZKqGpVXJOqfPnZ1bVd17/EGno6IO6ZtqX7To/EmNGtQbZlhQu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783637179; c=relaxed/simple;
	bh=AQQuNUafpb4UG9pRXj5Q4qk9Kw3lU1w9dx1WXjOG25c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=G+vpWtKu5rsMpsdtX0tHO12LXRBnj32YKhZYwLXkNggEyoZ3HRpge/NJdWY59Bjr1etbawUojGiiWWNMkvYtcx/zHHYaGlS1usls+wueGD8Ni7CQ05WgCRXiq36VDSyo6tpDKPUhXCyiQTPMAOBvMagF9jKjVOi9VpOnsI9O4s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VBZgoerL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VBZgoerL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761791F000E9;
	Thu,  9 Jul 2026 22:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783637177;
	bh=WCMCARNoTvnHTWk3GmE47UDmP8Hz1lv6GeLOZkP2O7M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VBZgoerLACpx8OeUvdL77Xxjax99iyBjaK3qAMUg1MM49F77x+gBXqpee7PiRbjUm
	 k1TPUfqLEkphpXLaq3zTVmFdWo9yj3mrv8IwjgbMJr/CrxcCgjpklxndbQ3jAeGG2p
	 jb4y0fIJLLe9p/iMrgQB/3xBFQYYP7Da4V1xdb18BgmcozJycou8lim0euxW1A/y4m
	 SN648oaIe7NOt2F7utigAiF7GEHfHo+eBka85I9yeI8ZiFzXjJljNuhEJp3wFCxoyz
	 qwqqeIq9Wy93IIAmVMxReg8/2nVK/zVYliB9fex8iBnscsAkPoXr43QZVpqV4HUBLv
	 wcVQ6bm4P3AIA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6 v3 3/6] arm64: Fix early handling of FEAT_E2H0 not
 being implemented
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260709223604.12934-4-coltonlewis@google.com>
References: <20260709223604.12934-1-coltonlewis@google.com>
 <20260709223604.12934-4-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 09 Jul 2026 22:46:17 +0000
Message-Id: <20260709224617.761791F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but writes to contro=
l-plane system registers (such as `SYS_SCTLR_EL12`, `sctlr_el1`, `cnthctl_e=
l2`, `cntvoff_el2`, `SYS_HCRX_EL2`, and fine-grained trap registers like `S=
YS_HDFGRTR_EL2`) are not immediately followed by an `isb()` instruction. Th=
is violates architectural context synchronization rules which mandate that =
every control-plane sysreg write must be followed by an `isb()` as the very=
 next instruction.
--

--- Patch [3]: [PATCH 6.6 v3 3/6] arm64: Fix early handling of FEAT_E2H0 no=
t being implemented ---
commit 7771c286d908263811f7e18fed1ebdcc2d0d16e0
Author: Marc Zyngier <maz@kernel.org>

arm64: Fix early handling of FEAT_E2H0 not being implemented

This commit fixes a bug where the check for ID_AA64MMFR4_EL1.E2H0
was incorrect and happened too late in the initialization sequence.
It updates the check and publishes the HCR_EL2.E2H bit earlier to
ensure hVHE mode boots successfully as a nested guest.

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
> -	/*
> -	 * Compliant CPUs advertise their VHE-onlyness with
> -	 * ID_AA64MMFR4_EL1.E2H0 < 0. HCR_EL2.E2H can be
> -	 * RES1 in that case.
> -	 *
> -	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1, but
> -	 * don't advertise it (they predate this relaxation).
> -	 */
> -	mrs_s	x0, SYS_ID_AA64MMFR4_EL1
> -	ubfx	x0, x0, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
> -	tbnz	x0, #(ID_AA64MMFR4_EL1_E2H0_SHIFT + ID_AA64MMFR4_EL1_E2H0_WIDTH - =
1), 1f
> -
>  	mrs	x0, hcr_el2
>  	and	x0, x0, #HCR_E2H
>  	cbz	x0, 2f
> -1:
> +
>  	/* Set a sane SCTLR_EL1, the VHE way */
>  	pre_disable_mmu_workaround
>  	msr_s	SYS_SCTLR_EL12, x1

[Severity: High]
This isn't a bug introduced by this patch, but do the writes to control-pla=
ne
system registers here and in nearby setup functions need to be immediately
followed by an isb() instruction?

Looking at init_el2() in arch/arm64/kernel/head.S, the write to
SYS_SCTLR_EL12 is immediately followed by a mov instruction instead of
an isb():

        msr_s   SYS_SCTLR_EL12, x1
        mov     x2, #BOOT_CPU_FLAG_E2H

Operating with a stale pipeline configuration after control-plane sysreg wr=
ites
can cause unexpected CPU traps, undefined behavior, or boot failures.

The same pattern appears in init_el2() where sctlr_el1 is written:

2:
        pre_disable_mmu_workaround
        msr     sctlr_el1, x1
        mov     x2, xzr

This also seems to occur in arch/arm64/include/asm/el2_setup.h:

- __init_el2_timers() writes cnthctl_el2 and cntvoff_el2 without an
  intervening isb().
- __init_el2_hcrx() writes to SYS_HCRX_EL2.
- __init_el2_fgt() writes to fine-grained trap registers like
  SYS_HDFGRTR_EL2.

Could these missing synchronization barriers cause boot failures on
microarchitectures that require strict enforcement?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260709223604.1293=
4-1-coltonlewis@google.com?part=3D3
