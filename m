Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D13E326D45
	for <kvmarm@lists.linux.dev>; Tue, 27 Jan 2026 18:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769538552; cv=pass; b=U3fwHVAX6GO4sC3BTWdJCON9C+1H0Sm3TYdShScitPZLsE0MlxzBANLXEzKQPsoCpTWvM3W39thEK2l6f8pI//vxJzcxHJkjyuSLbQdq0FoVsebT+Qdu68eAm13GkULd449gUcswH+rde/R+V5jYpDkvLfqzSAdDL5FZEEMzMmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769538552; c=relaxed/simple;
	bh=aWhPoXoCSpppHcH+Z9T+BsTa5z+q/lP1MwTGPt8CmR8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h1aDEtHLvsCJOAPEw48sh/Oi5xspjgkMQ2KN1C/M67zu5DpkulDTQ2Wv/E7FTwyhBtqRkgczM/FX+gOTs2xlzZP3h6SPnDAGc0kdiHn1O/BO1vN7RGgVbqc2MRAPBxw50TX6JsVWeQbDn9q3D63PxiRQpIbIUB+jpbfa1sFJ4uQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2eb9zbGn; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2eb9zbGn"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5014acad6f2so29871cf.1
        for <kvmarm@lists.linux.dev>; Tue, 27 Jan 2026 10:29:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769538550; cv=none;
        d=google.com; s=arc-20240605;
        b=WAdlV5u8P6aCUD9zW2VH/x+ygKziuNPm2InV6NcQs5gitoR9KMfaq/VsZZTs8lPAXr
         d47VDn/gRUqmRek1LSdNVmTqJa/s9UuI9XXbSuUu3FgindaPhtJZU7yZ1uNu8PFaMnvL
         EjjgKMUpfhAn5rdPhahHH67FqQlYTEaWnvqwRcyJPA9y7dQBajo3jEmtJRDboOJQNVYr
         jTc+BW9PZHMi/WyYSMxnPSrFBfdMc0Y+0WpW+9LCEXaFpwPqefMLlXGozpW0n8klN7yq
         tcv0OROX8VkBm3XWDRx84vG9/w0FsiTeahKRAVJ7r7EaLeUd+OMtES4SQefXWqkCSGEW
         3WsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wmqFys/juW1EZAgdfKq6MTjLgOXwmpAGq13j/IO6Ug8=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=UV/2cGdI2CTdgGo7s6dPEv2YpdVI5TgeulmmvgojH7sELq/WEgpKXR9OEMD65S4MM7
         +5PX/3nI4b6yHqZqV0tlkg1in6XmohKaWyq8hLchuQcRbcpXGQrTZJw8Dx9ZC08ywCHr
         dohvcjkHkufrMzBFtVIVxQOvDxIuW1ywszNn9PWvdMM0Pn6yVf4Y3+72Ex4WLuk5UuIT
         qERsZyo81+oWkK/tRfLj92qD09mab3MNf6ilpSmSxpeuzqNYutGpX/uINU+XgL39IMdU
         bFQx0QQZARQfodB3dznN6aauH3yRwuIqvvRNqYaHgjyWnsV+ZwA93PeyM4mg3YO+v3pS
         apPA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769538550; x=1770143350; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wmqFys/juW1EZAgdfKq6MTjLgOXwmpAGq13j/IO6Ug8=;
        b=2eb9zbGnsSkdJVTjizy+6ydcKMG090zycjCJi1oe1hVnFl2K5L7jGfjeiEE6B5I7Yv
         jMocLaThQNyaXK3JTMk81bLyhuDCeVq7X8PT5oXFPVJfzWMfTGQLzcKEwMwSOiPB6jxa
         g52QG7b4snK3DFwts14MbII4aOMHJ+csKq2zL4HGWO7JOv0+l+NyjKM19naZPkX1Hb0b
         gVc1rOfou92vrPqFFuS1YE5KfszVPiyzZvoN0jY4Rxhmo0qvdtpUc5/ia2hkMCA0UfK9
         w4OU6PWo8V5X8EGaqyhKTPiFbx1meONGarC6OGxkr/rasGcoi6jnM0QHLexFIhKPri0A
         r7LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769538550; x=1770143350;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wmqFys/juW1EZAgdfKq6MTjLgOXwmpAGq13j/IO6Ug8=;
        b=V1mQ218tVvT1lbpp8FubYyCZC1nMw4Qzo/DMa45Ti5Eltj/WDbXvlnUfh0s+/0behm
         6Pij0kvvWMk/Gl2FDHUl1venZztPtiCBC/pGQWFevh+G6hfNcs3tTA1BjqeYcdrSDWd2
         3mobSBGmP0GKmiZPw2MZ8EE2RYFEkQcYkihq0fKZvU7+jXO0kK7N1OD44JGzXk8ChNjT
         sz4pUFfI6K51bEzz9cwEDyDe16eJyt8zdnoaMr6QPLbyTL/R5T9Dtb7XUD1ffyY0KBX1
         1Lcth8BoyAeyLPTX1IT1QfMvcUILIXanAXolTkVIZk+NAvaAvzHh77QwMIZzO78AdzMR
         /T+g==
X-Gm-Message-State: AOJu0YwrUVIq9romiflTXoLYTH147Prx02DZWFZooZ6lt3KFbhNq4PLo
	jAsv43FqSM8FV38rB10RVnd1AP3wc85+MIOqCp4GuRZNm1Hn8cfhpO2nDCn/8k/T3e+UCameV4H
	TOA5PzwZ+UT/C18Qhb1hQtIMKYODCBWeCGthco8Fm
X-Gm-Gg: AZuq6aL+KoLfDaeRjKTOQATPyxVqc9Ikncl7ck6PHRmFMBeOgPtLkCqfZz1i7i4ElpU
	b5dCBCnV5iJCUgin6qSVOn/CIWkd4OwzdvvioLlg6gnK0MC5hCxwL7iVSNOeig+v5OE1aBV4tIz
	SQ//qODiwys9NWbvbSSvqAM5huOxanXhg07XMgTvLPGr7611SeCi9x3GOPtBmCusQPXlMujnkqy
	F+lItiPcSSy8bwB7S8Vbi579tfSDnx62PEHJBFwMiuuxz2oOoMIOrVDO23f1SGwJvSbcYvXo59N
	zLG8/y0=
X-Received: by 2002:a05:622a:34e:b0:4ff:bfdd:3f46 with SMTP id
 d75a77b69052e-5032f4e0be6mr10385161cf.15.1769538549723; Tue, 27 Jan 2026
 10:29:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-12-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-12-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 27 Jan 2026 18:28:33 +0000
X-Gm-Features: AZwV_QgXZBRUac8lgCEGhS0B6XOh32RhatNEEL4-duPDQxvYx3j74fO0pxo2Iak
Message-ID: <CA+EHjTyWmb9dEaHqi0Uef3y6vvpGSE0r64AENX98HdkpsSL7Rw@mail.gmail.com>
Subject: Re: [PATCH 11/20] KVM: arm64: Add REQUIRES_E2H1 constraint as
 configuration flags
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> A bunch of EL2 configuration are very similar to their EL1 counterpart,
> with the added constraint that HCR_EL2.E2H being 1.
>
> For us, this means HCR_EL2.E2H being RES1, which is something we can
> statically evaluate.
>
> Add a REQUIRES_E2H1 constraint, which allows us to express conditions
> in a much simpler way (without extra code). Existing occurrences are
> converted, before we add a lot more.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/config.c | 38 ++++++++++++++------------------------
>  1 file changed, 14 insertions(+), 24 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 4fac04d3132c0..1990cebc77c66 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -25,6 +25,7 @@ struct reg_bits_to_feat_map {
>  #define        FIXED_VALUE     BIT(2)  /* RAZ/WI or RAO/WI in KVM */
>  #define        MASKS_POINTER   BIT(3)  /* Pointer to fgt_masks struct instead of bits */
>  #define        AS_RES1         BIT(4)  /* RES1 when not supported */
> +#define        REQUIRES_E2H1   BIT(5)  /* Add HCR_EL2.E2H RES1 as a pre-condition */
>
>         unsigned long   flags;
>
> @@ -311,21 +312,6 @@ static bool feat_trbe_mpam(struct kvm *kvm)
>                 (read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_MPAM));
>  }
>
> -static bool feat_asid2_e2h1(struct kvm *kvm)
> -{
> -       return kvm_has_feat(kvm, FEAT_ASID2) && !kvm_has_feat(kvm, FEAT_E2H0);
> -}
> -
> -static bool feat_d128_e2h1(struct kvm *kvm)
> -{
> -       return kvm_has_feat(kvm, FEAT_D128) && !kvm_has_feat(kvm, FEAT_E2H0);
> -}
> -
> -static bool feat_mec_e2h1(struct kvm *kvm)
> -{
> -       return kvm_has_feat(kvm, FEAT_MEC) && !kvm_has_feat(kvm, FEAT_E2H0);
> -}
> -
>  static bool feat_ebep_pmuv3_ss(struct kvm *kvm)
>  {
>         return kvm_has_feat(kvm, FEAT_EBEP) || kvm_has_feat(kvm, FEAT_PMUv3_SS);
> @@ -1045,15 +1031,15 @@ static const DECLARE_FEAT_MAP(sctlr2_desc, SCTLR2_EL1,
>                               sctlr2_feat_map, FEAT_SCTLR2);
>
>  static const struct reg_bits_to_feat_map tcr2_el2_feat_map[] = {
> -       NEEDS_FEAT(TCR2_EL2_FNG1        |
> -                  TCR2_EL2_FNG0        |
> -                  TCR2_EL2_A2,
> -                  feat_asid2_e2h1),
> -       NEEDS_FEAT(TCR2_EL2_DisCH1      |
> -                  TCR2_EL2_DisCH0      |
> -                  TCR2_EL2_D128,
> -                  feat_d128_e2h1),
> -       NEEDS_FEAT(TCR2_EL2_AMEC1, feat_mec_e2h1),
> +       NEEDS_FEAT_FLAG(TCR2_EL2_FNG1   |
> +                       TCR2_EL2_FNG0   |
> +                       TCR2_EL2_A2,
> +                       REQUIRES_E2H1, FEAT_ASID2),
> +       NEEDS_FEAT_FLAG(TCR2_EL2_DisCH1 |
> +                       TCR2_EL2_DisCH0 |
> +                       TCR2_EL2_D128,
> +                       REQUIRES_E2H1, FEAT_D128),
> +       NEEDS_FEAT_FLAG(TCR2_EL2_AMEC1, REQUIRES_E2H1, FEAT_MEC),
>         NEEDS_FEAT(TCR2_EL2_AMEC0, FEAT_MEC),
>         NEEDS_FEAT(TCR2_EL2_HAFT, FEAT_HAFT),
>         NEEDS_FEAT(TCR2_EL2_PTTWI       |
> @@ -1285,6 +1271,7 @@ struct resx compute_resx_bits(struct kvm *kvm,
>                               unsigned long require,
>                               unsigned long exclude)
>  {
> +       bool e2h0 = kvm_has_feat(kvm, FEAT_E2H0);
>         struct resx resx = {};
>
>         for (int i = 0; i < map_size; i++) {
> @@ -1307,6 +1294,9 @@ struct resx compute_resx_bits(struct kvm *kvm,
>                         match = idreg_feat_match(kvm, &map[i]);
>                 }
>
> +               if (map[i].flags & REQUIRES_E2H1)
> +                       match &= !e2h0;
> +

nit: white space in the newline

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad




>                 if (!match) {
>                         if (map[i].flags & AS_RES1)
>                                 resx.res1 |= reg_feat_map_bits(&map[i]);
> --
> 2.47.3
>
