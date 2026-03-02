Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3333FB051
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 14:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772463483; cv=pass; b=OKhQWxjU1oMoSaeTw3RuAJDPo9ns6ZsMAvCxPpOAqw6HgKCIsXi16T3v5gtrepARZHX2YXVxPQbgdGd4wwG35rQHOH5xlBLU8Y43q8mc04+JzBZH1ufU0kl62c2CWCoXLoMMKxvypALLW//lnp8xxnMfDAcZVdiV5o1qfIjH3GY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772463483; c=relaxed/simple;
	bh=EsJDW3XfosU6J7GHFKy6ZO0oS3/mc8CmVcJ6ya+a+Xk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=coBjF/7rgOPizq1vVTW8USqjJcrK+fFT8ry+HYqlTPJ13OJWznwtU6xnGdNTf6d4noarLYbtJyTATCIAmyLUpZ0ysrt0fsX+4l6U9v4fLTdCFJ99vSzG8SlanYhDbgciBxt5fj56GalxbIxexrOxluWGjMkN03QtsNuhne3a00U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4eI8yev8; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4eI8yev8"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-505d3baf1a7so984831cf.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Mar 2026 06:58:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772463481; cv=none;
        d=google.com; s=arc-20240605;
        b=TnkHpCx88IyZbEpndne8apUC86ZhpwhavfW9lF14zSeWGTEzGJ/vJECB6YZGJ6gUff
         QUwPG/QQE/3P7XaBzckaNzd6Xrga7rDeuA87emQz3X4PFf6DuCwo6sr8x5ic+GMIPQyl
         I5KTPqAHSgrVlG2AoVg3fe47NJIbi0fz18HuE98A0nt5etzLl+LjJrZEjYZpX84VX2be
         4kbcnxFmQB1l7DLcGK4D6waMLAkHFSPHOM6hDDBXZ3XqAvHj5jNVeMkby2kvFbeZhg/S
         XoPTTaEzKbnCgITkpZ4F97V9vzB6P5b5gtEsGg11arXzdGDb+r7idRV6v7tizLCJU/vk
         Xx7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=G2tiCQAM7J3nKBvqatqhx2IcyXGt7NEO8HpnjOvw5gU=;
        fh=t0dKqXtIISObm4fdkYe8dgHolTbh8mMDQGo0HKszF54=;
        b=hpeHXPz1SBAbh5Ubr6+H3YgnjYk/lPy3uwkxX+PE+8jl+iUkUcBSCiM5bo82r35EK5
         DNR9wZzv6BTnsD+f8+hvZukfntcO2KanNsNao65UaA3sbN2J1W17Ey/fis86EgmPIhnz
         EepHblN8EPW/Jad3cQDfLQNQAmJhVaCo61Vg7MKgHy0sGSPDBSNu50pd91O6q/3s1HIH
         1oYy7dCUnNO9xVJ8QMPKZrxpSZh+WufLi967MrQHXRm6cLywWHS0NaY9fIej2UIQLb7A
         GI8LtrtUdqqBk7F7OeY6UQb3ZUNcVCf7DarLniCMOxECoNHMTrQbdFoj4yGFtj50QQdc
         GzzQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772463481; x=1773068281; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G2tiCQAM7J3nKBvqatqhx2IcyXGt7NEO8HpnjOvw5gU=;
        b=4eI8yev8VULgwHFGk/rIpOAvmPtEbVSCy/RhAeywom2C7AerAvuUQndHJEELQ2rQsm
         Tqzo+sakyGLxk1bLjpPmezb3gyLqE5Hh5r15CeieO6782IWstJAmiT72K0rd4++QyjJG
         7JTk2r3n2saR70+1zrHjYVzZwn24U8LAOpE8M3m5A/ub3Uny7nikIAkpta8kUAzSvFt1
         zQY2VzUxeoEqaTut6OGyCewuWfBSh5+4BhfSMmzG6yHMrPF5oNyKsKdw7r/qi8rXboyB
         TPuBDcVCoT/CR8hRqSSs8MnUizFXmyYiEtXOen7wK0Hngs3M7ncDkZfnvAyZpcdhws3j
         dD1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772463481; x=1773068281;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G2tiCQAM7J3nKBvqatqhx2IcyXGt7NEO8HpnjOvw5gU=;
        b=t4wpJ4Mh0AFS+CEIyZXIzMptvFdWW+lGK/eG39D1ZmmjonIIon5pcFP0IBLtJErwB7
         vVDZlUOSdyvVMy1NK0cLcM77l5z3J2tszhb1NBCzZUi1CiVBolNRzKczhcr7+SCi02jx
         2hY42mq47IIuTFXxKt3usrU5KZNtZYCd8CMrqqHErNZTXiU9KohUvLvxFlZWFMCryU7X
         GjZa/KoBRFN01eohAB1LBygEfKRa9DGbTsLss/hqEGw5wCfUXalZ6ZaLl/Tu6KTwUf5d
         70pW2PjxtBvh1ga0GRI1b6krShgkqltex5o5/lKDWjtVsmx+7CoQNSQcOosAMp0iTn1h
         m4Ww==
X-Forwarded-Encrypted: i=1; AJvYcCXlaRyT6TUeGVu7Aj8FHv54Nb7CQSpucpMutWpXsFwbP+0b9/wAt6mZKgizbE2HWFHoyKY2/9c=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNy78YgdkDRxqiVwjrdoO+fVH4d2WawxKcZ2F4dNhu5s4lwX3g
	nlEdmAWhSvOZHLpcH1od31CXwsaGzUomu7dJS+6473F+WRQpijvfaR+S8POO97a7TW2M3Ah+m6O
	E+BSqO/UmhRzsFHXbkzPyHMKFqI81TeN78ojJjQU+
X-Gm-Gg: ATEYQzx6kMJBz8SQv3lsjgCPVSA9UURRygfXB864Rq7V/AI75Fx5jKcBQx80HyA826B
	XBMQleGKlf0TshcGNzhramW1sqm0qpNiwap4tzhb9nlmGMHobdfr2aEnDOfvItnUlIMd5G55g+M
	OCXgAmqhsjYUglWBuP1fl70dYT80lUwalqjqv91NgBxg7gb4vyT+bioTRdNm0JuAIAiZFaoDnbb
	yEWKFzWbrvXXzsGBBmVaUIj0oTfXSTi4pMbLrKA/rC3RwW+k68+gtus7xWPl7VjkyCJu1eKlYHu
	MaWwjTyR
X-Received: by 2002:ac8:5995:0:b0:4ff:cb72:7c03 with SMTP id
 d75a77b69052e-507617532dcmr21520541cf.3.1772463478513; Mon, 02 Mar 2026
 06:57:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260302115653.1517326-1-maz@kernel.org> <20260302115653.1517326-4-maz@kernel.org>
In-Reply-To: <20260302115653.1517326-4-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Mar 2026 14:57:21 +0000
X-Gm-Features: AaiRm52cau_CBAybC8R8xab889bgpS_fXwwQzlJ-E-bLfbHFOruGTzIX5vD_ueY
Message-ID: <CA+EHjTxuZfiA77sckm=96x_0JoUpmqDUVrB9WX+TgomQjWyMkw@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] arm64: Add logic to fully remove features from
 sanitised id registers
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 2 Mar 2026 at 11:57, Marc Zyngier <maz@kernel.org> wrote:
>
> We currently make support for some features such as Pointer Auth,
> SVE or S1POE a compile time decision.
>
> However, while we hide that feature from userspace when such support
> is disabled, we still leave the value provided by the HW visible to
> the rest of the kernel, including KVM.
>
> This has the potential to result in ugly state leakage, as half of
> the kernel knows about the feature, and the other doesn't.
>
> Short of completely banning such compilation options and restore
> universal knowledge, introduce the possibility to fully remove such
> knowledge from the sanitised id registers.
>
> This has more or less the same effect as the idreg override that
> a user can pass on the command-line, only defined at build-time.
>
> For that purpose, we provide a new macro (FTR_CONFIG()) that defines
> the behaviour of a feature, both when enabled and disabled.
>
> At this stage, nothing is making use of this anti-feature.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/cpufeature.h | 17 +++++++++------
>  arch/arm64/kernel/cpufeature.c      | 32 ++++++++++++++++++++++-------
>  2 files changed, 36 insertions(+), 13 deletions(-)
>
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 4de51f8d92cba..e853a0ac7db38 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -53,17 +53,22 @@ enum ftr_type {
>  #define FTR_SIGNED     true    /* Value should be treated as signed */
>  #define FTR_UNSIGNED   false   /* Value should be treated as unsigned */
>
> -#define FTR_VISIBLE    true    /* Feature visible to the user space */
> -#define FTR_HIDDEN     false   /* Feature is hidden from the user */
> +enum ftr_visibility {
> +       FTR_HIDDEN,             /* Feature hidden from the user */
> +       FTR_ALL_HIDDEN,         /* Feature hidden from kernel, user and KVM */
> +       FTR_VISIBLE,            /* Feature visible to all observers */
> +};
> +
> +#define FTR_CONFIG(c, e, d)                            \
> +       (IS_ENABLED(c) ? FTR_ ## e : FTR_ ## d)
>
> -#define FTR_VISIBLE_IF_IS_ENABLED(config)              \
> -       (IS_ENABLED(config) ? FTR_VISIBLE : FTR_HIDDEN)
> +#define FTR_VISIBLE_IF_IS_ENABLED(c)   FTR_CONFIG(c, VISIBLE, HIDDEN)
>
>  struct arm64_ftr_bits {
>         bool            sign;   /* Value is signed ? */
> -       bool            visible;
> +       enum ftr_visibility visibility:8;
>         bool            strict; /* CPU Sanity check: strict matching required ? */
> -       enum ftr_type   type;
> +       enum ftr_type   type:8;
>         u8              shift;
>         u8              width;
>         s64             safe_val; /* safe value for FTR_EXACT features */
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 102c5bac4d502..965dd2acf0640 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -192,7 +192,7 @@ void dump_cpu_features(void)
>  #define __ARM64_FTR_BITS(SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) \
>         {                                               \
>                 .sign = SIGNED,                         \
> -               .visible = VISIBLE,                     \
> +               .visibility = VISIBLE,                  \
>                 .strict = STRICT,                       \
>                 .type = TYPE,                           \
>                 .shift = SHIFT,                         \
> @@ -1063,16 +1063,33 @@ static void init_cpu_ftr_reg(u32 sys_reg, u64 new)
>                                 ftrp->shift);
>                 }
>
> -               val = arm64_ftr_set_value(ftrp, val, ftr_new);
> -
>                 valid_mask |= ftr_mask;
>                 if (!ftrp->strict)
>                         strict_mask &= ~ftr_mask;
> -               if (ftrp->visible)
> +
> +               switch (ftrp->visibility) {
> +               case FTR_VISIBLE:
> +                       val = arm64_ftr_set_value(ftrp, val, ftr_new);
>                         user_mask |= ftr_mask;
> -               else
> +                       break;
> +               case FTR_ALL_HIDDEN:
> +                       /*
> +                        * ALL_HIDDEN and HIGHER_SAFE are incompatible.
> +                        * Only hide from userspace, and log the oddity.
> +                        */
> +                       if (WARN_ON(ftrp->type == FTR_HIGHER_SAFE))

What about FTR_HIGHER_OR_ZERO_SAFE? It's not actually being used for
any feature id register, only for CTR_EL0. Even there, it's a
(theoretical at this point) performance issue, not a correctness one,
as 0 assumes the largest possible size. I still think that it's safer
to include it here.

That said:

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> +                               val = arm64_ftr_set_value(ftrp, val, ftr_new);
> +                       else
> +                               val = arm64_ftr_set_safe_value(ftrp, val);
>                         reg->user_val = arm64_ftr_set_safe_value(ftrp,
>                                                                  reg->user_val);
> +                       break;
> +               case FTR_HIDDEN:
> +                       val = arm64_ftr_set_value(ftrp, val, ftr_new);
> +                       reg->user_val = arm64_ftr_set_safe_value(ftrp,
> +                                                                reg->user_val);
> +                       break;
> +               }
>         }
>
>         val &= valid_mask;
> @@ -1230,9 +1247,10 @@ static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
>
>                 /*
>                  * Don't alter the initial value that has been forced
> -                * by an override.
> +                * by an override or a disabled feature.
>                  */
> -               if ((reg->override->mask & arm64_ftr_mask(ftrp)) == arm64_ftr_mask(ftrp))
> +               if (ftrp->visibility == FTR_ALL_HIDDEN ||
> +                   (reg->override->mask & arm64_ftr_mask(ftrp)) == arm64_ftr_mask(ftrp))
>                         continue;
>
>                 if (ftr_cur == ftr_new)
> --
> 2.47.3
>
