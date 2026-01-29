Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D059313281
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 16:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769704219; cv=pass; b=KGnks4Ax3mZHrb0IrKfhCdyvqxN1FrahQlGw+BmjerNRuTsTVBqISOP/J7VPMaEwQ8skQkIU6Xp5E6r1FDHVO8pF2THgCT4Qjs0yMLSQjjTGTYYa60qx43y2AU36dYHfgGK9UZeT8j4s8q51AeOiiegDGokgUlnsZsw0UHluJyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769704219; c=relaxed/simple;
	bh=h/Cx93hJfrTfffFA6Rug9AC4SNMrQ7BqZU5kiWeUNTs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QW+2p861xnCb2h1nBDCHNN6fDgUau+XbINyuNvk4jkp3KMHBzzhn7JTlhTrZOphAhMAYt7k7BrhnZupd6WiDjs2DlpxjAZH8Bj77mEOSAsEF0r33E5M6pSaRfRYUrPD7CWcr33UrFFsBJXYlHzcaydjHmueT/E0da1Pn+mJoPKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m4bi06vo; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m4bi06vo"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5014b5d8551so516501cf.0
        for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 08:30:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769704216; cv=none;
        d=google.com; s=arc-20240605;
        b=DEcIMTYcsk+mszgORauXToftT+G9/f1/nAyd36sDfmRg+SdujAqcHG5cHKqZZK0qGi
         t4PPm4DkjcdsLlY7pzcDhKhht7bHYvMkepr33YS+C8y8kf2eOSeKGAjN17DIhqp+cTDg
         r8ROKpbPzHeGha6L4X95m75gsSrKlBKc4OayUm48Sx+M+7RGR4YafBtNfFiuU7/XQ4Nt
         BFS3QJcHuto7TOgLoTH4C89cVriSMVPEsH7MKd0hv1GE4SDfEFL3G/hs4DnNRBsPElDp
         epDSei+YlZttcqT76MMM/SUFBrdnEADEeLl6vGQiYTabA/kmhAzAWnDNUkwZnuRuBQmj
         EHJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vQMIKkFFYhu4sIg3A2teqJk96QiqeuS9EHouVKYLx8Q=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=MTRxZvFXchnc5Q619GnrXUjQfCuOX2xj0E54eJvW02ochC1Qq68UKXI/Iqxey6d/LY
         XbxhmgZfXMK9iI+Wt8Sln3ei0IwDUtwqhu8CAD0Owj/sVY12/mSaJsjmKAKmFtLY4jOa
         g1Jsw5vyU3RNy8om3xbP5IiS4GwZjwgrN2fMOul4Ts8vqZsloevroJdv8wu2zzTF87KU
         tP7xSTWIFqLwzZuPZ3w1UqffqWfQ6wPApLWL0x8EHSf+MSTs9t2d6lXAARwNMjpM55jY
         p55G6QtSzxdyGjsf4F3TRiHm+1IYpfD/aoHrWmef+iaJdqRZLNcf2HffuMTjNJj5jIof
         mGeA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769704216; x=1770309016; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vQMIKkFFYhu4sIg3A2teqJk96QiqeuS9EHouVKYLx8Q=;
        b=m4bi06voM7Sh0cR9s/UWruW7nKsbeUkJ3y9+KuZiux5mF1GzvdReSvQ/jqUE2VQfB7
         A08v+9++ZEIEXqsnxeazRu6XKp1bZxT4XmAFZkt0/6Gc/FnDDm96dHd0VYnuTWW1GjYV
         G2q22Tsv5gW2JvpcgE//CdC7mJlr8Ymh7p+W8K97gDPo2Hk42PJFOmvndY4T21VwM4rr
         g5Eg3KJm2YzcuGdSUg0b+1fRCsFffw6NN+0NYIOfA4wInEzrBuoGfi/C45YlydhBtDYJ
         mAk1wB4gTYMof9ihKNn1MISK3OtaPbeZPE/ZEJ648pK0m5TKBI2RdIaju6kvRNfrqTbY
         Ag7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769704216; x=1770309016;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vQMIKkFFYhu4sIg3A2teqJk96QiqeuS9EHouVKYLx8Q=;
        b=GJfgBIu8uTFUIGE1tR5p9hnatixTpvz++Jq76yPkFCQYE5LsBE5D9OpRMtFs12IDtX
         g/l8oLDDpAlq03cOFyGb4wNEJ/+c3g3mf4xjFTMAVSNWfhPYH0rObzjDu/qjwH2tokGz
         dNzPdhtk2xOBKFeO0ir+V/LCITJLpF6vomtdZdBIsB1v1A5Fg9NEv6dayR3kTNtaV35I
         Z4yr2jfTwjKhoIuS0NzER1lItVSkpiOIcTuobI2BJKM8bx1kNio0i9Ayakj9OM5TzHww
         7n0XeiKrtDl4xE/z8zMmmw963rBdHtMu3f0Dy5yWu6ZuNqSQ1b6d1SkTmu+19jGARwhx
         t3VA==
X-Gm-Message-State: AOJu0YzM8ERAhzZrpbHyIQVfhHK7cihgulGtq+V3od7J8Go/bnShbAEL
	yFqAK25mbs7b22Y1VKMZuL+ho9/Z+5pTeeksaSoD8E5U1bkv2nDBn4iDR3I0QfjP69gnFeFko8T
	cEwo+Gr5UlWeNq/yimqRm6Zj+hvEcpCO4DCKOwMot
X-Gm-Gg: AZuq6aKDxiBe9xUq4C+70tm5DUK8/vkYBCNZODuaVZDK7yQaoPm5hrKuF0aIs4BPUUH
	R4aP6OfQrCC9h/MMVp+rsjdQfJJUGvxwtuu9lB6u/nnAX1kk4viBgU2vgW8qnjjn7M6Ht1dYfDj
	1aW6AN4qcrRapkYqFYcr8hW2Z2gBEAz0BTAHAuyiAErzzuwvzf+BY0RUOJx9pSMAuV1+RiQQcvc
	0xQdPnYVYqIKagZFHCG4/Tv0l0X/VZQISvP2Kx2iSZgDjgdNf5kl/gnRekjTG1Oghc1kHik
X-Received: by 2002:ac8:7c47:0:b0:503:2d8f:4cd9 with SMTP id
 d75a77b69052e-503b67573e4mr13934781cf.16.1769704215926; Thu, 29 Jan 2026
 08:30:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-14-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-14-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 16:29:39 +0000
X-Gm-Features: AZwV_Qg32GvW0ZtRM3k8KTI45TetsfMdg8KQdbLbqMmnl_DQjJAfz20-iM3f-6Q
Message-ID: <CA+EHjTw_4WJgiS7vTUprvJOjdNrnW=sjhazCkU9eQW8BUYuZZw@mail.gmail.com>
Subject: Re: [PATCH 13/20] KVM: arm64: Move RESx into individual register descriptors
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
> Instead of hacking the RES1 bits at runtime, move them into the
> register descriptors. This makes it significantly nicer.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/config.c | 36 +++++++++++++++++++++++++++++-------
>  1 file changed, 29 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 7063fffc22799..d5871758f1fcc 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -30,6 +30,7 @@ struct reg_bits_to_feat_map {
>  #define        RES0_WHEN_E2H1  BIT(7)  /* RES0 when E2H=1 and not supported */
>  #define        RES1_WHEN_E2H0  BIT(8)  /* RES1 when E2H=0 and not supported */
>  #define        RES1_WHEN_E2H1  BIT(9)  /* RES1 when E2H=1 and not supported */
> +#define        FORCE_RESx      BIT(10) /* Unconditional RESx */
>
>         unsigned long   flags;
>
> @@ -107,6 +108,11 @@ struct reg_feat_map_desc {
>   */
>  #define NEEDS_FEAT(m, ...)     NEEDS_FEAT_FLAG(m, 0, __VA_ARGS__)
>
> +/* Declare fixed RESx bits */
> +#define FORCE_RES0(m)          NEEDS_FEAT_FLAG(m, FORCE_RESx, enforce_resx)
> +#define FORCE_RES1(m)          NEEDS_FEAT_FLAG(m, FORCE_RESx | AS_RES1, \
> +                                               enforce_resx)
> +
>  /*
>   * Declare the dependency between a non-FGT register, a set of
>   * feature, and the set of individual bits it contains. This generates

nit: features

> @@ -230,6 +236,15 @@ struct reg_feat_map_desc {
>  #define FEAT_HCX               ID_AA64MMFR1_EL1, HCX, IMP
>  #define FEAT_S2PIE             ID_AA64MMFR3_EL1, S2PIE, IMP
>
> +static bool enforce_resx(struct kvm *kvm)
> +{
> +       /*
> +        * Returning false here means that the RESx bits will be always
> +        * addded to the fixed set bit. Yes, this is counter-intuitive.

nit: added

> +        */
> +       return false;
> +}

I see what you're doing here, but it took me a while to get it and
convince myself that there aren't any bugs (my self couldn't find any
bugs, but I wouldn't trust him that much). You already introduce a new
flag, FORCE_RESx. Why not just check that directly in the
compute_resx_bits() loop, before the check for CALL_FUNC?

+ if (map[i].flags & FORCE_RESx)
+     match = false;
+ else if (map[i].flags & CALL_FUNC)
...

The way it is now, to understand FORCE_RES0, you must trace a flag, a
macro expansion, and a function pointer, just to set a boolean to
false.

Cheers,
/fuad


> +
>  static bool not_feat_aa64el3(struct kvm *kvm)
>  {
>         return !kvm_has_feat(kvm, FEAT_AA64EL3);
> @@ -1009,6 +1024,8 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
>                    HCR_EL2_TWEDEn,
>                    FEAT_TWED),
>         NEEDS_FEAT_FIXED(HCR_EL2_E2H, compute_hcr_e2h),
> +       FORCE_RES0(HCR_EL2_RES0),
> +       FORCE_RES1(HCR_EL2_RES1),
>  };
>
>  static const DECLARE_FEAT_MAP(hcr_desc, HCR_EL2,
> @@ -1029,6 +1046,8 @@ static const struct reg_bits_to_feat_map sctlr2_feat_map[] = {
>                    SCTLR2_EL1_CPTM      |
>                    SCTLR2_EL1_CPTM0,
>                    FEAT_CPA2),
> +       FORCE_RES0(SCTLR2_EL1_RES0),
> +       FORCE_RES1(SCTLR2_EL1_RES1),
>  };
>
>  static const DECLARE_FEAT_MAP(sctlr2_desc, SCTLR2_EL1,
> @@ -1054,6 +1073,8 @@ static const struct reg_bits_to_feat_map tcr2_el2_feat_map[] = {
>                    TCR2_EL2_E0POE,
>                    FEAT_S1POE),
>         NEEDS_FEAT(TCR2_EL2_PIE, FEAT_S1PIE),
> +       FORCE_RES0(TCR2_EL2_RES0),
> +       FORCE_RES1(TCR2_EL2_RES1),
>  };
>
>  static const DECLARE_FEAT_MAP(tcr2_el2_desc, TCR2_EL2,
> @@ -1131,6 +1152,8 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
>                    SCTLR_EL1_A          |
>                    SCTLR_EL1_M,
>                    FEAT_AA64EL1),
> +       FORCE_RES0(SCTLR_EL1_RES0),
> +       FORCE_RES1(SCTLR_EL1_RES1),
>  };
>
>  static const DECLARE_FEAT_MAP(sctlr_el1_desc, SCTLR_EL1,
> @@ -1165,6 +1188,8 @@ static const struct reg_bits_to_feat_map mdcr_el2_feat_map[] = {
>                    MDCR_EL2_TDE         |
>                    MDCR_EL2_TDRA,
>                    FEAT_AA64EL1),
> +       FORCE_RES0(MDCR_EL2_RES0),
> +       FORCE_RES1(MDCR_EL2_RES1),
>  };
>
>  static const DECLARE_FEAT_MAP(mdcr_el2_desc, MDCR_EL2,
> @@ -1203,6 +1228,8 @@ static const struct reg_bits_to_feat_map vtcr_el2_feat_map[] = {
>                    VTCR_EL2_SL0         |
>                    VTCR_EL2_T0SZ,
>                    FEAT_AA64EL1),
> +       FORCE_RES0(VTCR_EL2_RES0),
> +       FORCE_RES1(VTCR_EL2_RES1),
>  };
>
>  static const DECLARE_FEAT_MAP(vtcr_el2_desc, VTCR_EL2,
> @@ -1214,7 +1241,8 @@ static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
>         u64 mask = 0;
>
>         for (int i = 0; i < map_size; i++)
> -               mask |= map[i].bits;
> +               if (!(map[i].flags & FORCE_RESx))
> +                       mask |= map[i].bits;
>
>         if (mask != ~resx)
>                 kvm_err("Undefined %s behaviour, bits %016llx\n",
> @@ -1447,28 +1475,22 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
>                 break;
>         case HCR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hcr_desc, 0, 0);
> -               resx.res1 |= HCR_EL2_RES1;
>                 break;
>         case SCTLR2_EL1:
>         case SCTLR2_EL2:
>                 resx = compute_reg_resx_bits(kvm, &sctlr2_desc, 0, 0);
> -               resx.res1 |= SCTLR2_EL1_RES1;
>                 break;
>         case TCR2_EL2:
>                 resx = compute_reg_resx_bits(kvm, &tcr2_el2_desc, 0, 0);
> -               resx.res1 |= TCR2_EL2_RES1;
>                 break;
>         case SCTLR_EL1:
>                 resx = compute_reg_resx_bits(kvm, &sctlr_el1_desc, 0, 0);
> -               resx.res1 |= SCTLR_EL1_RES1;
>                 break;
>         case MDCR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &mdcr_el2_desc, 0, 0);
> -               resx.res1 |= MDCR_EL2_RES1;
>                 break;
>         case VTCR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &vtcr_el2_desc, 0, 0);
> -               resx.res1 |= VTCR_EL2_RES1;
>                 break;
>         default:
>                 WARN_ON_ONCE(1);
> --
> 2.47.3
>
