Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E4333F8DA
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 16:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769705700; cv=pass; b=id4dPJAK6gZ+E9lCAJOWZPrfZmBqluZWuACPNJ2dzm6ZXKpgVuXYw21YAahc6fxzJ7f/CYVNdO7/VTDuYYSo50njmbK7PGlXbnl+BmZ1PuE8lL9jHicGAN1tSLkzfpGY6tFpFzab/B9E6KuA/xFRcR9Ms73WSPdiVL0wFMy6/+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769705700; c=relaxed/simple;
	bh=4G47EEjFhfQZfbYifopHjluz9xuiDm0HdG8jST5wUwY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rQUF3SK6bp8PAwrR8nUckVHVB9v5l329rXduPejyhyHWUyjtmp9bZmWp7zV0VoiZzci5tYX3eQZcSyNjVjeRvvtxJjB0vZs/JWvIWZoevsWkBwDJY2fsjgZZH7AGTMu3/HUPNHGUUtSGMYwGin0aPFr1aJRMcsq6vZiHjXyq2Fo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TqY5yABF; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TqY5yABF"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5033b0b6eabso646521cf.1
        for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 08:54:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769705697; cv=none;
        d=google.com; s=arc-20240605;
        b=OJjHcHK0FvTsLFxR2wlEXVEVIjMX/+pHVqTxBy3t3/aj6teM5g6ResQkVGD71hxNHJ
         gZrA5qMG1/eYGeeWkPY4VB8xHsVhFWK4e6AQlUGa3gwHbdGBOo1PEvA6qq5LYExJdWM5
         0FiVS35qXqUSBPYRk9uNhlSvBrMs7iNsMwkbpKrcAQWLSJetMhrTEEMf94VTve3WDM2D
         Dr8+lo8ktgLwToLqDvDJWX0H1W8zPu3gNcwehH6NT5wXyLNWQvi8c1gVj4O5Be+l3j16
         9dC6cUCFLTgEod6KmTlGbr/tjsCGPJ6KNaWveUUU6fYUM1wISWz5f+grHImQm+RF7O0+
         T20w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=lGnprIM0uOwwzce7Mf6HJCnNaV9WLSnSkIbwPkk6n4U=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=LZ033AfMLEfs3X5dr2tJ5DtWpvs2Rbmgn6O0H8tlD6XbBQkrOCaUmjKNTCdMjC4oYM
         c6/msCs0A5/giOspfMeP7Rd0AZ6rpWoZNaUF79z+hHS01njXZ0FHbAddc/aDMgbDJyG2
         KxcPU/wL+mM0c1f5d07eRmmoUUEufkafdYiyy12nvQfRdCi8lLXJGM7lhM47G1PbsahX
         L5XbHTUG9eJAb33ggOcugl8KBfRefnpHSZfLNWe41uSpB5oJY2Ol+pPJop9QvVI27DeI
         hYY1d1N8DFvQGm6dy/OnFveaQlce4WIMb1Q7ph4FbbyRjLVlGI9U0n2nQmjfpYG322Gh
         /saQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769705697; x=1770310497; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lGnprIM0uOwwzce7Mf6HJCnNaV9WLSnSkIbwPkk6n4U=;
        b=TqY5yABFyowNVemKborAFMlcwh37XogyzsM6JFXCrq+jdCh9ABe1236dqIdkAWpNLe
         2FG99VOB1V4IRNfcNm4617ir3VUavgiEik+9jFVdhBfuCZnIVfD187+EXEF//K+fdzow
         LJyp70Y6dlBfntJWGl4qgffFXjRP2IsmbiOYFid8KLPhO5G2uufhaAIgIcgT885yzRfi
         vR5DQpgycq9HL85R9AWWquAkJ3AoHPd+egxNh8qRTNsCDavb2DrUBl5E5psv9ceImae7
         //MolcBobG8jxuCS1yOkLkC6Ibt3FmE9MravvWYjdmJm4QDLpiiXMhO7+tq2LhusJyeE
         CBlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769705697; x=1770310497;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lGnprIM0uOwwzce7Mf6HJCnNaV9WLSnSkIbwPkk6n4U=;
        b=GvOe7w+AfossJFWOwOb+n98yZohTUimGTMYNxz2vzX7BKM4u6yM6PXZ6se8BEdn+Z4
         G98o3n3FFERYVEKnbfKb0f7c5VRyTvX5Gray0uZ2TgTNuyWnbvf+vwHdh0KsgfWcBQah
         tILFN4aheTybSIEQYEYfcyjKIraPtGMpZDVfzdjE7RdoKxcu4Lru5vkrtTOVoKqWDTqY
         Eg0vwTU1zBVx11rU3xVphfy95zicwsCqAPNnVvffRqdonLWgh8K2Ut2oh3zJRDhJw6ac
         MjDkDV8VhhqaSDkotG08WjiEUw+K4ftGDRdKrVHNqtHeV9DJl/tdjMgOb4jgfna/Nnl5
         7RoA==
X-Gm-Message-State: AOJu0YyXkfM6sIJt61d+GiAP86Dutojz0zrGttOi3n/sErHVbDrLGYbG
	korr11zJmH6bDHdAgyEYFGbbHL8VHFBjVsASkMYCpfjoK9EVhyLo1GlnDUKKrWdXAAnSZjDy08m
	7rJ5xXSDTyab1/tGSplKsc3wWuz7SdNoVKQ1B8+wq
X-Gm-Gg: AZuq6aLSS+W4RWUUw8Hjp9hCjhPmscP57u08nO40uh1sCZuyeyzd6fX2CHs3biWP5sc
	G+3JPeJnbO1LVAIVFvTKLjacKQ9QhFNRzwcjSDP+VZBnkoibOkH6FjMrnFrURTSZkHd5aKzS6UB
	b2zKKghFQd8utt2tN9/pq2eK3dlczRcsX1voFJuXYAM3mm+hj6rOxJyDoAfcH0j/OkrvIXg8iY1
	7WvHf+8YNc2qA10noKPEyQGUiUPrQ7Pcw46Uvkn3bMHPrYUiGpi+tiuYJcNymDVwyn/2vu5
X-Received: by 2002:ac8:7c45:0:b0:4ff:bfdd:3f46 with SMTP id
 d75a77b69052e-504310ac4a2mr11072831cf.15.1769705696188; Thu, 29 Jan 2026
 08:54:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-16-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-16-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 16:54:19 +0000
X-Gm-Features: AZwV_QieftfkWMiOf6SsY4TTgpSg92NfpZxoIL88Ar5MLjnc5YDmaX24FaMexnE
Message-ID: <CA+EHjTx7MzcU2pnbmFsbUsiy2b2HY=MRhZ_sG5YxYiTbz6VUNg@mail.gmail.com>
Subject: Re: [PATCH 15/20] KVM: arm64: Get rid of FIXED_VALUE altogether
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> We have now killed every occurrences of FIXED_VALUE, and we can therefore
> drop the whole infrastructure. Good riddance.

Indeed.

> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  arch/arm64/kvm/config.c | 24 +++---------------------
>  1 file changed, 3 insertions(+), 21 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 187d047a9cf4a..28e534f2850ea 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -22,7 +22,7 @@ struct reg_bits_to_feat_map {
>
>  #define        NEVER_FGU       BIT(0)  /* Can trap, but never UNDEF */
>  #define        CALL_FUNC       BIT(1)  /* Needs to evaluate tons of crap */
> -#define        FIXED_VALUE     BIT(2)  /* RAZ/WI or RAO/WI in KVM */
> +#define        FORCE_RESx      BIT(2)  /* Unconditional RESx */
>  #define        MASKS_POINTER   BIT(3)  /* Pointer to fgt_masks struct instead of bits */
>  #define        AS_RES1         BIT(4)  /* RES1 when not supported */
>  #define        REQUIRES_E2H1   BIT(5)  /* Add HCR_EL2.E2H RES1 as a pre-condition */
> @@ -30,7 +30,6 @@ struct reg_bits_to_feat_map {
>  #define        RES0_WHEN_E2H1  BIT(7)  /* RES0 when E2H=1 and not supported */
>  #define        RES1_WHEN_E2H0  BIT(8)  /* RES1 when E2H=0 and not supported */
>  #define        RES1_WHEN_E2H1  BIT(9)  /* RES1 when E2H=1 and not supported */
> -#define        FORCE_RESx      BIT(10) /* Unconditional RESx */
>
>         unsigned long   flags;
>
> @@ -43,7 +42,6 @@ struct reg_bits_to_feat_map {
>                         s8      lo_lim;
>                 };
>                 bool    (*match)(struct kvm *);
> -               bool    (*fval)(struct kvm *, struct resx *);
>         };
>  };
>
> @@ -76,13 +74,6 @@ struct reg_feat_map_desc {
>                 .lo_lim = id ##_## fld ##_## lim        \
>         }
>
> -#define __NEEDS_FEAT_2(m, f, w, fun, dummy)            \
> -       {                                               \
> -               .w      = (m),                          \
> -               .flags = (f) | CALL_FUNC,               \
> -               .fval = (fun),                          \
> -       }
> -
>  #define __NEEDS_FEAT_1(m, f, w, fun)                   \
>         {                                               \
>                 .w      = (m),                          \
> @@ -96,9 +87,6 @@ struct reg_feat_map_desc {
>  #define NEEDS_FEAT_FLAG(m, f, ...)                     \
>         __NEEDS_FEAT_FLAG(m, f, bits, __VA_ARGS__)
>
> -#define NEEDS_FEAT_FIXED(m, ...)                       \
> -       __NEEDS_FEAT_FLAG(m, FIXED_VALUE, bits, __VA_ARGS__, 0)
> -
>  #define NEEDS_FEAT_MASKS(p, ...)                               \
>         __NEEDS_FEAT_FLAG(p, MASKS_POINTER, masks, __VA_ARGS__)
>
> @@ -1306,16 +1294,10 @@ struct resx compute_resx_bits(struct kvm *kvm,
>                 if (map[i].flags & exclude)
>                         continue;
>
> -               switch (map[i].flags & (CALL_FUNC | FIXED_VALUE)) {
> -               case CALL_FUNC | FIXED_VALUE:
> -                       map[i].fval(kvm, &resx);
> -                       continue;
> -               case CALL_FUNC:
> +               if (map[i].flags & CALL_FUNC)
>                         match = map[i].match(kvm);
> -                       break;
> -               default:
> +               else
>                         match = idreg_feat_match(kvm, &map[i]);
> -               }
>
>                 if (map[i].flags & REQUIRES_E2H1)
>                         match &= !e2h0;
> --
> 2.47.3
>
