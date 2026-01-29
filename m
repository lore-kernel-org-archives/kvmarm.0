Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE634314A8E
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 18:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769710318; cv=pass; b=ihMfWZZZVCK0bB75SJAt2wFSFELfvkxJNaeS/dOwjFPCkmv27EtMU02qqDxY2lhtjNMjIo78AYUCEnomD2z8JieFRqsUygHXy/chQVU6hzSitlUWio0tvgoXdWZvvP9sFRuYG7o790N917xd85KnfiWbSL41XSjU3R16ka99ais=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769710318; c=relaxed/simple;
	bh=M/HTTNEk3HJAJvMAG53DlqOlG2dQLxQZC7cUa1DucD8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m83xRb7SDHo7D4qzn3DuxXF/CAOU7OIF52Pbzg/hmWoJDfPhZ0SOTE4aod9dL4j8NnsNzxxxY6KgE3JuyKuM0FD5dhD01Y0/zGHaoI5UP5B8z38qLoE0vSV5Ga3asGqCyY8wQXdwYIHs8S6ttukthBJwCQjQbZtbxW/J/hrvRH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MnvUSNy8; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MnvUSNy8"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5033b0b6eabso3491cf.1
        for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 10:11:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769710316; cv=none;
        d=google.com; s=arc-20240605;
        b=QzpOtuAW4y8gHtI++l/Rd8oD2uw8hOD/w7/EhvOulrwO4igQQdqG/9eqMfq7TAv+a5
         H/S5k13wm8viE9j5RuabdrSoTgVbwgIR2QS6ICngqAbYPMery+LqERdYb1G+mzyf7LAj
         //7Lv9BGeohzZIHy2Nv3JsZ2VU9/Wmr7BzYube4UnL8v3vG1bAYyJphCbuCzDhQqo/c7
         qz/rI3b/gmlhuTFeforTqRL8aWWWVOFlgLFZxiItlGU4KSIT9swNs/2Sru+5/zE3RB3z
         EZt42s+v6RU8R0gms5Jv+1UtitqzcROnGb4DlLIi+7tQiP3J0HUGDGZEzJ4gVE1nB5OK
         yV8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=eXMpYReA76VSnWBdSDCeKOepff/FefCdjy4bJ9ZDLq8=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=g2w4WxWemOroVtVfIpj6uYREzSex6L0Ii7W9ZUqzFyD0+CfwczgAYDiwkCiclOCymL
         eNoNJBiyn8m0YXhrZtJyRMhDTlHSMJ4+6Qj1qlRevYN91mj55UgshXg/uitXl6KivPO/
         0d01bZzF9BRQZZ7ObwHuOVCGADLlZZ/nnViQp2L1KsmlPJYI7b8BmnWkBUaKDV/KO8qP
         f2ZaXuAoEE1UbJnwSgUgp5wfZ+TG2VRN6k9xxRD9bVhRbbqgZ9QZAWPmDHLmNMFHFjI0
         QIrqnTBZPWjm25GpA+PeOaHaT4sDpV9hDwiOM8AFuafVxBUQKd8tA2jHHn01Ip2wDY6e
         C/og==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769710316; x=1770315116; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eXMpYReA76VSnWBdSDCeKOepff/FefCdjy4bJ9ZDLq8=;
        b=MnvUSNy8ob3DWgS9aoxWsLQO3ySr4Uc5Od1m7tXvOyEeHyvdO+CD+ylDnRqCjM34We
         uC43T89b0p5eCsqqFqiQz/OfLOuare4iMYpJFvIvE7Jiskwr6BYur5851BXIZvWCC/DA
         Da6JCQtwL0bI0/mJSsNF0R5O5pWW5UHSsa4LeIhCendQr3OpZymI6mH/m/Ef0SEvKDHh
         mDNJlBJqmXHQ0uq3ohrZUDPfAU8tdondxNRIf9flOxn+og1DZOOV+JuwCO3rWoiQsLMQ
         YYdTvjTThG2OCwOwpWVUQcaW5twPu4yBWWs5mnUOdF5ZvXQikglunwvPPBkUN7BuN81c
         n8Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769710316; x=1770315116;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eXMpYReA76VSnWBdSDCeKOepff/FefCdjy4bJ9ZDLq8=;
        b=qo4fZjcmg1x4XOowmk/2Gujk7uJtAfD/8oBrd7LI2NESMnzAuXeu7CepzqYJUPNtO5
         1SRC5os3gxROEmY+d4P1FAvTeDLvJtHRCI+Kmiz2K0qGNtlGurOKxJS2C+9/THDMHLPx
         ClX9HgcMaYa5vGCSLEOMwIUQ32nmFAmABgX8p4ocjp8DiMJQj08UkwvHOs0FVb/bg+Rv
         U0UEXLk2DmplD6B9Hy2W758qMNCAp6P0YdkXzxSjtrp4vModyQ1ahV4398fxLB9qMLV2
         +byi4fyNW+QiOU/tmQhVn61IyxDwxSfNmIhFuQdweMNrCvTvsnemHiKwoi3kVXC7eMZ+
         bmAw==
X-Gm-Message-State: AOJu0YwNpGEeDCfmIXJDn7OILQ98KO0wFYxN0qtDNfULMLOxwNRPjEpv
	uqtQQSnJaS2kwVVQ8A7GoGSckoNzvUMjPlhM4ze4OaToA5NcXpnFkTH4z9Zbk2L0rX2bX8ftqs2
	A9tV3GyJH4reNSDRCoz7geRJUk9s3foZqe48gQubI
X-Gm-Gg: AZuq6aLZKBgTEUy54cIf+2UwMMYRx+EuYaWNDVzIPREH++Un91x6yj+MvYWd/1tBQVF
	nXrrKrmUc5nNFgmjoiozSLFDtNhef+bbVUR3K8oNLveDfi8wEB/HrEg4EKW8GMYN825F9BRLRax
	MsAITbKcAGnPY9pVTHp2zS/3LsNpzkR+PGFeWiaOUy+iTrD3ey8biQY5PHre59CqOWebtDM2FaW
	6wNlWPPjqW6RD16bNIj1MCoqnX4x7+SFrMwBEBWSTo8EJLnGOV4D5dY0qOy0a4N/FluBkBj
X-Received: by 2002:a05:622a:cb:b0:502:f07e:854c with SMTP id
 d75a77b69052e-505d2963681mr233281cf.6.1769710313749; Thu, 29 Jan 2026
 10:11:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-20-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-20-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 18:11:16 +0000
X-Gm-Features: AZwV_QjF5yiUUIg5uEIM22NwSkF34FaWIG-B5xVFNjuS4Wq4b6ejFit-e1Zvicw
Message-ID: <CA+EHjTztDe27zT6yHFiN+_64Husvs36JBWXZyKQ2N3AjuW63gQ@mail.gmail.com>
Subject: Re: [PATCH 19/20] KVM: arm64: Add sanitisation to SCTLR_EL2
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Sanitise SCTLR_EL2 the usual way. The most important aspect of
> this is that we benefit from SCTLR_EL2.SPAN being RES1 when
> HCR_EL2.E2H==0.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

This would change slightly when you change patch 12, but it matches
the spec and those changes would be trivial to apply here.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad






> ---
>  arch/arm64/include/asm/kvm_host.h |  2 +-
>  arch/arm64/kvm/config.c           | 82 +++++++++++++++++++++++++++++++
>  arch/arm64/kvm/nested.c           |  4 ++
>  3 files changed, 87 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 9dca94e4361f0..c82b071ade2a5 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -495,7 +495,6 @@ enum vcpu_sysreg {
>         DBGVCR32_EL2,   /* Debug Vector Catch Register */
>
>         /* EL2 registers */
> -       SCTLR_EL2,      /* System Control Register (EL2) */
>         ACTLR_EL2,      /* Auxiliary Control Register (EL2) */
>         CPTR_EL2,       /* Architectural Feature Trap Register (EL2) */
>         HACR_EL2,       /* Hypervisor Auxiliary Control Register */
> @@ -526,6 +525,7 @@ enum vcpu_sysreg {
>
>         /* Anything from this can be RES0/RES1 sanitised */
>         MARKER(__SANITISED_REG_START__),
> +       SCTLR_EL2,      /* System Control Register (EL2) */
>         TCR2_EL2,       /* Extended Translation Control Register (EL2) */
>         SCTLR2_EL2,     /* System Control Register 2 (EL2) */
>         MDCR_EL2,       /* Monitor Debug Configuration Register (EL2) */
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index eebafb90bcf62..562513a4683e2 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1130,6 +1130,84 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
>  static const DECLARE_FEAT_MAP(sctlr_el1_desc, SCTLR_EL1,
>                               sctlr_el1_feat_map, FEAT_AA64EL1);
>
> +static const struct reg_bits_to_feat_map sctlr_el2_feat_map[] = {
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_CP15BEN,
> +                       RES0_WHEN_E2H1 | RES1_WHEN_E2H0 | REQUIRES_E2H1,
> +                       FEAT_AA32EL0),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_ITD   |
> +                       SCTLR_EL2_SED,
> +                       RES1_WHEN_E2H1 | RES0_WHEN_E2H0 | REQUIRES_E2H1,
> +                       FEAT_AA32EL0),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_BT0, REQUIRES_E2H1, FEAT_BTI),
> +       NEEDS_FEAT(SCTLR_EL2_BT, FEAT_BTI),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_CMOW, REQUIRES_E2H1, FEAT_CMOW),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_TSCXT,
> +                       RES0_WHEN_E2H0 | RES1_WHEN_E2H1 | REQUIRES_E2H1,
> +                       feat_csv2_2_csv2_1p2),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_EIS   |
> +                       SCTLR_EL2_EOS,
> +                       AS_RES1, FEAT_ExS),
> +       NEEDS_FEAT(SCTLR_EL2_EnFPM, FEAT_FPMR),
> +       NEEDS_FEAT(SCTLR_EL2_IESB, FEAT_IESB),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_EnALS, REQUIRES_E2H1, FEAT_LS64),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_EnAS0, REQUIRES_E2H1, FEAT_LS64_ACCDATA),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_EnASR, REQUIRES_E2H1, FEAT_LS64_V),
> +       NEEDS_FEAT(SCTLR_EL2_nAA, FEAT_LSE2),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_LSMAOE        |
> +                       SCTLR_EL2_nTLSMD,
> +                       AS_RES1 | REQUIRES_E2H1, FEAT_LSMAOC),
> +       NEEDS_FEAT(SCTLR_EL2_EE, FEAT_MixedEnd),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_E0E, REQUIRES_E2H1, feat_mixedendel0),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_MSCEn, REQUIRES_E2H1, FEAT_MOPS),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_ATA0  |
> +                       SCTLR_EL2_TCF0,
> +                       REQUIRES_E2H1, FEAT_MTE2),
> +       NEEDS_FEAT(SCTLR_EL2_ATA        |
> +                  SCTLR_EL2_TCF,
> +                  FEAT_MTE2),
> +       NEEDS_FEAT(SCTLR_EL2_ITFSB, feat_mte_async),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_TCSO0, REQUIRES_E2H1, FEAT_MTE_STORE_ONLY),
> +       NEEDS_FEAT(SCTLR_EL2_TCSO,
> +                  FEAT_MTE_STORE_ONLY),
> +       NEEDS_FEAT(SCTLR_EL2_NMI        |
> +                  SCTLR_EL2_SPINTMASK,
> +                  FEAT_NMI),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_SPAN, AS_RES1 | REQUIRES_E2H1, FEAT_PAN),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_EPAN, REQUIRES_E2H1, FEAT_PAN3),
> +       NEEDS_FEAT(SCTLR_EL2_EnDA       |
> +                  SCTLR_EL2_EnDB       |
> +                  SCTLR_EL2_EnIA       |
> +                  SCTLR_EL2_EnIB,
> +                  feat_pauth),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_EnTP2, REQUIRES_E2H1, FEAT_SME),
> +       NEEDS_FEAT(SCTLR_EL2_EnRCTX, FEAT_SPECRES),
> +       NEEDS_FEAT(SCTLR_EL2_DSSBS, FEAT_SSBS),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_TIDCP, REQUIRES_E2H1, FEAT_TIDCP1),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_TWEDEL        |
> +                       SCTLR_EL2_TWEDEn,
> +                       REQUIRES_E2H1, FEAT_TWED),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_nTWE  |
> +                       SCTLR_EL2_nTWI,
> +                       AS_RES1 | REQUIRES_E2H1, FEAT_AA64EL2),
> +       NEEDS_FEAT_FLAG(SCTLR_EL2_UCI   |
> +                       SCTLR_EL2_UCT   |
> +                       SCTLR_EL2_DZE   |
> +                       SCTLR_EL2_SA0,
> +                       REQUIRES_E2H1, FEAT_AA64EL2),
> +       NEEDS_FEAT(SCTLR_EL2_WXN        |
> +                  SCTLR_EL2_I          |
> +                  SCTLR_EL2_SA         |
> +                  SCTLR_EL2_C          |
> +                  SCTLR_EL2_A          |
> +                  SCTLR_EL2_M,
> +                  FEAT_AA64EL2),
> +       FORCE_RES0(SCTLR_EL2_RES0),
> +       FORCE_RES1(SCTLR_EL2_RES1),
> +};
> +
> +static const DECLARE_FEAT_MAP(sctlr_el2_desc, SCTLR_EL2,
> +                             sctlr_el2_feat_map, FEAT_AA64EL2);
> +
>  static const struct reg_bits_to_feat_map mdcr_el2_feat_map[] = {
>         NEEDS_FEAT(MDCR_EL2_EBWE, FEAT_Debugv8p9),
>         NEEDS_FEAT(MDCR_EL2_TDOSA, FEAT_DoubleLock),
> @@ -1249,6 +1327,7 @@ void __init check_feature_map(void)
>         check_reg_desc(&sctlr2_desc);
>         check_reg_desc(&tcr2_el2_desc);
>         check_reg_desc(&sctlr_el1_desc);
> +       check_reg_desc(&sctlr_el2_desc);
>         check_reg_desc(&mdcr_el2_desc);
>         check_reg_desc(&vtcr_el2_desc);
>  }
> @@ -1454,6 +1533,9 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
>         case SCTLR_EL1:
>                 resx = compute_reg_resx_bits(kvm, &sctlr_el1_desc, 0, 0);
>                 break;
> +       case SCTLR_EL2:
> +               resx = compute_reg_resx_bits(kvm, &sctlr_el2_desc, 0, 0);
> +               break;
>         case MDCR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &mdcr_el2_desc, 0, 0);
>                 break;
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 96e899dbd9192..ed710228484f3 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1766,6 +1766,10 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
>         resx = get_reg_fixed_bits(kvm, SCTLR_EL1);
>         set_sysreg_masks(kvm, SCTLR_EL1, resx);
>
> +       /* SCTLR_EL2 */
> +       resx = get_reg_fixed_bits(kvm, SCTLR_EL2);
> +       set_sysreg_masks(kvm, SCTLR_EL2, resx);
> +
>         /* SCTLR2_ELx */
>         resx = get_reg_fixed_bits(kvm, SCTLR2_EL1);
>         set_sysreg_masks(kvm, SCTLR2_EL1, resx);
> --
> 2.47.3
>
