Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F88346AF9
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 17:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769708642; cv=pass; b=I4EGKnAhd12XD1LC3PUcBYB6D44NluBc/jxKmEA03xdcfcO1p9TjuwUeGhV0RovICN9XiedlnLkESDq/MKxPM914tDdnIfzuIMLyuMsMtP+ktpQC8/7e89RPRP0eVkaMDD1lJ9g8gsl6rBnTAalddUjaiU57JOppmd5YEz7ta/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769708642; c=relaxed/simple;
	bh=Qm7IrBwcroMf4JNK902e+KjqQCbztMqp90GzMr7Ke1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uEoM51VDUerOEzdPYTx/+pvAmqqQxmXedDnzOPACpq6iK3Nqlro324iTH7kddUPiQUsx0mc3KLIGk3ZaoFOZ/Xx5Tp0Kuj1kuT2bdW7+C0ZnLcn3FQNKpYGlnWSiXJieez7hzwPRVAMawjohO1EEIs/OWgg/1CUvhvxasWvpQ24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gd95YsDg; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gd95YsDg"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5033b64256dso6401cf.0
        for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 09:44:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769708640; cv=none;
        d=google.com; s=arc-20240605;
        b=Y51OAQrYnMl19lF2Y+0jBeyUHcI0ndDI51FUHdqPnDFOC59zqDv+FSpHoiXpZf+9x/
         eNidrb8W0OQWsJ8TmSVUdvfyVfke+tghL8TFdeamJXFNxS5JvYN0srKh8V7jXtMg/pk7
         4unexPEoNcUZBhOf3b3WWRJQ8sXpKL4wSOfQi6+eH3W+aGQzzaa14TNFUcOe0sXh8Npd
         a4DnTfMlffQxgtXRtAwFrxPlq8uJzjq1XPnZIB+zO+teag2yx2KoJH73BzbmtmIzJCSR
         N1E/jnaEHgGr7XfuLkARZ85pHIZsoo7FD7Qa/BLJD8zVTdbcqVw5+xm17+zplX8NrUd5
         DbFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=BPx3FQm16cHh/4wjy/zL7AjgWXFPiOJBez90RRz9q3A=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=Uwv1OSfzafoA0dAVpDH5lVv8DIzbldfplnYHK5WC0KsFPVXvhFL4DO2ek/QcbZd4o/
         PoI/I6/W6sLUBYCfj0t/7XDYhdIIYI8ESw6zQYSYmbvyJkfqfq5BHYOsMS3M49XaCYaZ
         mLm+gzo0j+BRA8xQ5GfICBAFvC/gnH20NW7cL31YXLyOYo364MCbHW3KIVzuBlJNKYXx
         wVHekBL5XxvsrtIkGFBtaGT5aU+DEkznexG8kygbyaUaNmPWEN+9gNK76wR+iyXysA2W
         7Xh2ejju1INhKmt1Uoy9bcfp5Ei+b0SbxhhCbBwsqEH6CttErkPH+AuicKm+FUHGSSXl
         mgDg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769708640; x=1770313440; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BPx3FQm16cHh/4wjy/zL7AjgWXFPiOJBez90RRz9q3A=;
        b=gd95YsDgpz31+iKSVP7P5zuWsyoEOQcKfZHZTBmpw1zDIIJdg4YAGC0yTVQsUc+clV
         MYbUvwdh+hFeCHdkBf9nbAcEvcWZGsiIGXqA1XwrHucMGnnxwt95o5MsSjiZZFDMbQV2
         HyOmeS9c7Llh0JBZ8Jz5ujUMKVsKyatZprnp5IsZRIjgKXHuq4eJmO9UuhYRpIFzqu7g
         SB01+rUtnNzo7sy9bE7JOTWiJtnru6nQIXFLHKhGIGKBq1rSJ63wSseVjI6FZ77F7M58
         w6PPmrtd738fxiLaEVCe7ySgkr1OPoLeTzT6LdxRiCYlPUUGotOq1UCDzIX2UT0xSiCX
         pqVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769708640; x=1770313440;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BPx3FQm16cHh/4wjy/zL7AjgWXFPiOJBez90RRz9q3A=;
        b=eEI7IntWd9M5Uest9c07zmmlZRNpkQ1eruM8qQDNT/yAK1JWgPwK4HP/P7tPHM3id8
         YVEqnC9p8Auxv8abWIQagsqvrCH/HmYJ+/dWCUS+P1F+0hQKmUbTmga9f7QjLB2AC5wx
         WQyQiehmlMwvh5VV0F+cKRlgNw1nUHGhLHpVuti0uo98lfa6gesv3QSQVImT4B0VbjjH
         mG00TaABEVu/rqEwEIBHGUhDcG94FxIsfOLdrY6mNtyAEjPdKAlcvuOwCVFtAKqELXQp
         mrAupjm4NDOM113b0MWM+RnezvUJi0pLaWgN0x8dAa9pxKvmqWzucEOw7DIVCAq2543j
         Sw2g==
X-Gm-Message-State: AOJu0YzoOTdeQF+Jh6KOWOBqL/Z9foYecjKVN93bhkhBih4UAevVP6nj
	4qBpRqMb6ld1X8rP4CPhET0w01L+5NKAQkSkRyxhF7EpYTbaTPwj2CNpZO/YE/5tGSiqzM0uKb9
	n4LiydqvLVrUXDmOtALQc1/wg1+/p1g9L6jZJlF7z
X-Gm-Gg: AZuq6aK6F2suk52vgrHRhFRDPLCZDfFZTaUdiLb0OKaMeA1eZ5RcxT3PpKOo8W7eNLm
	q2DXsVm0jvXJoTGMIp9Bcs2ay09Tz/VS8PJMY4CV7zCOcYXMwzqucnb9ntY6T4uT0fTET7WMAMI
	6lnekjZHqWmvz0wHGxQxoCowMnqvFZrNwq2H6CikeusgV6cro8wKyiX+tCvJbhJlfWzmp2gDy4W
	RdijiDpqWxgMOXg0XUsh4EINWLtaHCvnX7/s0LarE/rvGfvq4hUrZOIFQhkv3lMFJM21VXh
X-Received: by 2002:ac8:7c45:0:b0:4ff:bfdd:3f46 with SMTP id
 d75a77b69052e-504310ac4a2mr11679881cf.15.1769708639982; Thu, 29 Jan 2026
 09:43:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-18-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-18-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 17:43:23 +0000
X-Gm-Features: AZwV_QhgZBr5ml0xnQ-vrwj2DQaUpUwkeGPKKe1ptuTmjpFjMzKIrzIPGRs2pns
Message-ID: <CA+EHjTzvwhu4zkLmn4AtA0GZuUy85LDnZ-YUesw1PeoJPqdt_A@mail.gmail.com>
Subject: Re: [PATCH 17/20] KVM: arm64: Remove all traces of FEAT_TME
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> FEAT_TME has been dropped from the architecture. Retrospectively.
> I'm sure someone is crying somewhere, but most of us won't.

:'-(

Please don't do a web search for my name and "Transactional Memory".

> Clean-up time.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

I checked and it is indeed withdrawn. So with a heavy heart:

Reviewed-by: Fuad Tabba <tabba@google.com>

RIP,
/fuad







> ---
>  arch/arm64/kvm/config.c                         |  7 -------
>  arch/arm64/kvm/nested.c                         |  5 -----
>  arch/arm64/tools/sysreg                         | 12 +++---------
>  tools/perf/Documentation/perf-arm-spe.txt       |  1 -
>  tools/testing/selftests/kvm/arm64/set_id_regs.c |  1 -
>  5 files changed, 3 insertions(+), 23 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 0c037742215ac..f892098b70c0b 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -184,7 +184,6 @@ struct reg_feat_map_desc {
>  #define FEAT_RME               ID_AA64PFR0_EL1, RME, IMP
>  #define FEAT_MPAM              ID_AA64PFR0_EL1, MPAM, 1
>  #define FEAT_S2FWB             ID_AA64MMFR2_EL1, FWB, IMP
> -#define FEAT_TME               ID_AA64ISAR0_EL1, TME, IMP
>  #define FEAT_TWED              ID_AA64MMFR1_EL1, TWED, IMP
>  #define FEAT_E2H0              ID_AA64MMFR4_EL1, E2H0, IMP
>  #define FEAT_SRMASK            ID_AA64MMFR4_EL1, SRMASK, IMP
> @@ -997,7 +996,6 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
>         NEEDS_FEAT(HCR_EL2_FIEN, feat_rasv1p1),
>         NEEDS_FEAT(HCR_EL2_GPF, FEAT_RME),
>         NEEDS_FEAT(HCR_EL2_FWB, FEAT_S2FWB),
> -       NEEDS_FEAT(HCR_EL2_TME, FEAT_TME),
>         NEEDS_FEAT(HCR_EL2_TWEDEL       |
>                    HCR_EL2_TWEDEn,
>                    FEAT_TWED),
> @@ -1109,11 +1107,6 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
>         NEEDS_FEAT(SCTLR_EL1_EnRCTX, FEAT_SPECRES),
>         NEEDS_FEAT(SCTLR_EL1_DSSBS, FEAT_SSBS),
>         NEEDS_FEAT(SCTLR_EL1_TIDCP, FEAT_TIDCP1),
> -       NEEDS_FEAT(SCTLR_EL1_TME0       |
> -                  SCTLR_EL1_TME        |
> -                  SCTLR_EL1_TMT0       |
> -                  SCTLR_EL1_TMT,
> -                  FEAT_TME),
>         NEEDS_FEAT(SCTLR_EL1_TWEDEL     |
>                    SCTLR_EL1_TWEDEn,
>                    FEAT_TWED),
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 75a23f1c56d13..96e899dbd9192 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1505,11 +1505,6 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
>         u64 orig_val = val;
>
>         switch (reg) {
> -       case SYS_ID_AA64ISAR0_EL1:
> -               /* Support everything but TME */
> -               val &= ~ID_AA64ISAR0_EL1_TME;
> -               break;
> -
>         case SYS_ID_AA64ISAR1_EL1:
>                 /* Support everything but LS64 and Spec Invalidation */
>                 val &= ~(ID_AA64ISAR1_EL1_LS64  |
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 969a75615d612..650d7d477087e 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -1856,10 +1856,7 @@ UnsignedEnum     31:28   RDM
>         0b0000  NI
>         0b0001  IMP
>  EndEnum
> -UnsignedEnum   27:24   TME
> -       0b0000  NI
> -       0b0001  IMP
> -EndEnum
> +Res0   27:24
>  UnsignedEnum   23:20   ATOMIC
>         0b0000  NI
>         0b0010  IMP
> @@ -2432,10 +2429,7 @@ Field    57      EPAN
>  Field  56      EnALS
>  Field  55      EnAS0
>  Field  54      EnASR
> -Field  53      TME
> -Field  52      TME0
> -Field  51      TMT
> -Field  50      TMT0
> +Res0   53:50
>  Field  49:46   TWEDEL
>  Field  45      TWEDEn
>  Field  44      DSSBS
> @@ -3840,7 +3834,7 @@ Field     43      NV1
>  Field  42      NV
>  Field  41      API
>  Field  40      APK
> -Field  39      TME
> +Res0   39
>  Field  38      MIOCNCE
>  Field  37      TEA
>  Field  36      TERR
> diff --git a/tools/perf/Documentation/perf-arm-spe.txt b/tools/perf/Documentation/perf-arm-spe.txt
> index 8b02e5b983fa9..201a82bec0de4 100644
> --- a/tools/perf/Documentation/perf-arm-spe.txt
> +++ b/tools/perf/Documentation/perf-arm-spe.txt
> @@ -176,7 +176,6 @@ and inv_event_filter are:
>    bit 10    - Remote access (FEAT_SPEv1p4)
>    bit 11    - Misaligned access (FEAT_SPEv1p1)
>    bit 12-15 - IMPLEMENTATION DEFINED events (when implemented)
> -  bit 16    - Transaction (FEAT_TME)
>    bit 17    - Partial or empty SME or SVE predicate (FEAT_SPEv1p1)
>    bit 18    - Empty SME or SVE predicate (FEAT_SPEv1p1)
>    bit 19    - L2D access (FEAT_SPEv1p4)
> diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> index c4815d3658167..73de5be58bab0 100644
> --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> @@ -91,7 +91,6 @@ static const struct reg_ftr_bits ftr_id_aa64isar0_el1[] = {
>         REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, SM3, 0),
>         REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, SHA3, 0),
>         REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, RDM, 0),
> -       REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, TME, 0),
>         REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, ATOMIC, 0),
>         REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, CRC32, 0),
>         REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, SHA2, 0),
> --
> 2.47.3
>
