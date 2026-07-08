Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EA739A805
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 22:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783551597; cv=none; b=fqEaQ7SHYRZUWIQRCAyuo37BHUKAiTawrdMKctdWxrmGqnxL22pX06pAHT4BSFGbSex29koyB4dyjkmfTcbp0btjl3x2zCK139mTDkwXWpVOq7hajS+ysJfBOF6emHwWwG1nkofsxcEhaPaMfDBhl9uOJJ+uhUQf680EWwuDoKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783551597; c=relaxed/simple;
	bh=xSNOQY5AnLt/G82ebXpu+p3kkRrAFpHfPqjyMkCGiPc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ks8wKmuZGwIMOmIu/qd97Mg1zrRKAQMMDm2x70n8OQ3N0D5jWhkZcyWeUa41v45V7ygRyeFjNiuzWppx2gNl59JHxgwb+t250emLIhFPjLXmWBI3mmFgLLetin6M3rZQjy/Ac5nEZqlPL84sihMrXpFWNgt1sdYfARURrB81G9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VQyrpZzj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VQyrpZzj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B4C1F000E9;
	Wed,  8 Jul 2026 22:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783551594;
	bh=HHTeZqxpmq1fLIU9mhkm4lC01BObvoXrAQEey7noNP8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VQyrpZzjHhTO1JxmwBAxb1zvJJfpBdxZZVd1wKFFzb0J95lJ9mGdJ+ONcy1gapiNc
	 wTp4zxYPL+eyWkp6XNOo14SPPgQdnvi/Ox/sKYnoymypu4pVuT1Dpm74vE27Kl6PEn
	 IBc1yZXyHo2xqpsVcK1as7xWkCjlveEPOSUsMYeeTVGrRwfAX2WqtjU5+iPOVwSO4o
	 ZFTFawUYDAFfMNvEoE5YxGrmwBvtO3KsgfokKd7CLYidnAm8+x0ymLVztKQI45zREe
	 jk7/BjgCUs9sWQhwdMkZiGK/KF6mE/k5FMSbOUi7QWdQTG0GKUrgVWgz8/NPW0wAzH
	 QMpFxrRySrcMA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6 v2 6/6] arm64: Revamp HCR_EL2.E2H RES1 detection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260708225124.4130846-7-coltonlewis@google.com>
References: <20260708225124.4130846-1-coltonlewis@google.com>
 <20260708225124.4130846-7-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 22:59:53 +0000
Message-Id: <20260708225954.43B4C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing immediate Context Synchronization Event (ISB) after writes=
 to control-plane system registers.
--

--- Patch [6]: [PATCH 6.6 v2 6/6] arm64: Revamp HCR_EL2.E2H RES1 detection =
---
commit 75069b0b3126a153b742f982dd5dff757dc34d3e
Author: Marc Zyngier <maz@kernel.org>

arm64: Revamp HCR_EL2.E2H RES1 detection

This patch replaces the RAO/WI test for VHE-only CPUs with a sequence
utilizing VHE register remapping. This allows Neoverse V2 NV guests to
reliably detect they are in a VHE-only configuration despite the absence
of FEAT_FGT.

Link: https://lore.kernel.org/r/15A85F2B-1A0C-4FA7-9FE4-EEC2203CC09E@global=
.cadence.com

> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/=
el2_setup.h
> index 76b0d50d286d5..4c7467b382b60 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h

[ ... ]

> @@ -24,22 +24,48 @@
>  	 * ID_AA64MMFR4_EL1.E2H0 < 0. On such CPUs HCR_EL2.E2H is RES1, but it
>  	 * can reset into an UNKNOWN state and might not read as 1 until it has
>  	 * been initialized explicitly.
> -	 *
> -	 * Fruity CPUs seem to have HCR_EL2.E2H set to RAO/WI, but
> -	 * don't advertise it (they predate this relaxation).
> -	 *
>  	 * Initalize HCR_EL2.E2H so that later code can rely upon HCR_EL2.E2H
>  	 * indicating whether the CPU is running in E2H mode.
>  	 */
>  	mrs_s	x1, SYS_ID_AA64MMFR4_EL1
>  	sbfx	x1, x1, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
>  	cmp	x1, #0
> -	b.ge	.LnVHE_\@
> +	b.lt	.LnE2H0_\@

[ ... ]

> +.LnE2H0_\@:
>  	orr	x0, x0, #HCR_E2H
> -.LnVHE_\@:
>  	msr	hcr_el2, x0
>  	isb
> +.LnVHE_\@:
>  .endm

[Severity: High]
This isn't a bug introduced by this patch, but while reviewing this file
I noticed there might be missing Context Synchronization Events (ISB)
after writes to control-plane system registers.

In the __init_el2_timers macro:

	msr	cnthctl_el2, x0
	msr	cntvoff_el2, xzr		// Clear virtual offset

Does the write to cnthctl_el2 require an isb instruction immediately after =
it,
before executing the write to cntvoff_el2?

Similarly, in the __init_el2_fgt macro, there are multiple writes executed
without synchronization:

	msr_s	SYS_HFGRTR_EL2, x0
	msr_s	SYS_HFGWTR_EL2, x0
	msr_s	SYS_HFGITR_EL2, xzr

	mrs	x1, id_aa64pfr0_el1		// AMU traps UNDEF without AMU

Could executing subsequent instructions without an isb cause the CPU to
operate under a stale configuration here?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708225124.4130=
846-1-coltonlewis@google.com?part=3D6
