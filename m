Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A99F315D23
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 14:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765463445; cv=pass; b=KnS8mRhtfJF1CqVauE4uB0RIR1Mz/5w1CZKg7RhVqu8S9FDJCOqqCla3JwHP8xoWNVvYqt3prthOEj9dC/REOU2Pw6QTCbxoWVcaapps2wy6Je6FI3VO3gzJjHLSkZ6h99YslqIt1eNgJx02JyOUpAs70xZeFCOhBTISlU7cC3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765463445; c=relaxed/simple;
	bh=JFjzYzXKwQSP6iSsNRz75EAq2acEDG9Cc+XM1pWcsDs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gutv8ekBiyMLqN938RrilajjvnMDlpJzmTuxFweNWB/epJiWCgv9heVEXrMonqeYDlyBtfzFeMKP+DqP+h6z10XK1hkbFl700szK44dtxFkHFv70OeQdD286InjcUuyEgbW3rTrE95VGZNaG2b+RDh5ODld+oLlMld7JSWK8cms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HExrVj7w; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HExrVj7w"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4edb8d6e98aso628041cf.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 06:30:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765463441; cv=none;
        d=google.com; s=arc-20240605;
        b=SzSZKTlcyVUQ0TEs20h9enEalc44kZQAbJkhqMwy9kD2em+iubL3EN9QmPPYCsqiQl
         h8lh5F7/J2R3fbSalmIzeXOaWozNhAD8mO7/jBWCCLncJq6ZYYI/h4EMEIX7ATkwBKON
         dJA/AVXwgXDYRIODyjYpfuOpHLayXIJ3x7Ip9ifd3fkiFSkd4oM++VQ38L1N9PFCvdTD
         XyQFq0AgFKuEgqLIUcW7L2A8A+VAp/TdN2da88488a98s8Y8HmFf/vLKxLgM1maENq9M
         b5aCHBVF1E3dh1bCTMoQxcy0yKfBCUGzFWYZhHjh4ONq8M4a4n8CirqZGj/CaNskDiwW
         rSaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CXKK+XMOV+BG1j0Dmg65GZuKWhjmotSC6I9z/HN+0TE=;
        fh=NG/nEuPEgoaPuGimMFCytjJ02a7zmffXXGabTKRy8/o=;
        b=A/U2SBXIR+ykUkBknnMIIQyDi6tbnUN85+ffH3//yAIDw4Raekgta7/u20S3ZSpNAw
         Zl0Fl6gj0n1td+DiaM0Z1KdRSasQnL+EfKOePHmw8sL95/aiVvY4bIxSA8EuUYixy253
         77LJOgh0zEEnCKFuwvVP0Z1hC5akpH9q1KFb5IACrHtj6RJ+PKT07pLOIohIUPTan7b7
         Pihywiqw6QI1b/w9acwD/SVnVo/CEJpnCJwX7WD6Z10/dGwxT5ZJd13vrTwDi+anIPaj
         MYlpx3P4ZJPAbBmYCCJxwElp7C5UhIpjqFru9mfj0l76Fb+HkHy2UXwlVIRF1s9iKAgw
         6FLg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765463441; x=1766068241; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CXKK+XMOV+BG1j0Dmg65GZuKWhjmotSC6I9z/HN+0TE=;
        b=HExrVj7wl54ROlDuoQo0HB87AHgOsAhpyybyb2peOgeYIwgpCtQtAdBOfNix5Zzf8b
         peXXwwrai48YMtVUVttCduolSRoqNpUqE6uaTIXHKhF2jy18YvCRBVaXtkEEQFSH92SB
         FQyUsyQfj0aMpl+XHbCHNmRKjhajr9e04f7f4YjF5r2xW34E070ExRLYXBhr64tAe5yJ
         y5M63jqK0mVP2mp9z0pd+fsmGllnGswZFxe7NvwQ+WIZxLeksclykYFHxA8zc+6xVNIk
         XgpxspOzHFDPGAAu0CbiWeEaN3qGMgH8d1PQ3lbQW28jHbAxL8ikgq9dNMPVBTADfYpb
         VMTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765463441; x=1766068241;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CXKK+XMOV+BG1j0Dmg65GZuKWhjmotSC6I9z/HN+0TE=;
        b=jUozwavOCXaZ5cK5rEm5OW9QL0ro9LsfwbJ0M72paxVIoagADHpDRdw6NqyBcKsvne
         8V8g8wDNNHM9fVrQ7Ki33Ps0BvopGx81yf1RADaNVkWIQPwYs6b9npWKDfAkQUU08LTj
         mf1apQODNZ82yfr8BgBsfP1ynUBGxydfsafgOhwuXJI9AB3EFkicXZSWyyigBydGNtIp
         RKltJIEEoz0iBLUwKomCRJTC250zkINmQewOU/2BhQ1eJCnLY4rebSSOhti7iRxuZQyD
         OMJmbyJ7GOpbYrVzwv+U8Km7Zgz/kRNV2UMInrSDKYpPBMVWJqfqRBvRtrQUYxhX0jDG
         HjzA==
X-Gm-Message-State: AOJu0Yxv19mKv/2ktjsADGotn5jffyBnWmsXyBxsxuvF4S7acTapaNpU
	2yoiec+X7TvrhlXFNSFFizBWvHS7N2tFxQa7wk+OrUVCs+WADXuOUmS1hIB5i0S3EPqUS1MptaL
	NKrgem2mWyuAnDvka6fCEh1G8s8rXEA4CnaV+yfw7LWWPuo3x/3GQ51NN
X-Gm-Gg: AY/fxX4MM5F5ALwXt60vE2K2RWTxHqjnCrqJrmdzixsg3i3kJrcNFWdi6x4oI9K7W7P
	q5CqrvymECc2Y9A7WHP9fcdwQx98HP094bJoJ02OO8JFFXZvmiOMVMezHRj0LdD6k4q6rWcvYRu
	dSCCCEVw/1q76SCcAUSswL1Jvjr2VoTH+viSxEqAZmWq4Ww6RLue6X6sBGS1eYtpa2DaPjraIGP
	xZ2d9XbCBFAthxbrS8dVDEE+dIfsGyeZ9HHJsMzJTddv9pugYAPrPTY/dlDStDU3ZFfUAkT
X-Google-Smtp-Source: AGHT+IHOTRmzXfJZ1LxuUaQCR8PjN6XcJs7sQ/sZlzHzbcwman+GYjtDsYLbkyW9r2wgCAu14xGlJhBPAApNgAZIVaM=
X-Received: by 2002:a05:622a:a:b0:4ed:ff77:1a87 with SMTP id
 d75a77b69052e-4f1bee1ac37mr9103321cf.19.1765463440630; Thu, 11 Dec 2025
 06:30:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210173024.561160-1-maz@kernel.org> <20251210173024.561160-5-maz@kernel.org>
In-Reply-To: <20251210173024.561160-5-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 11 Dec 2025 14:30:03 +0000
X-Gm-Features: AQt7F2pDHRhtoAmbiPDRAiv1SfNZGM-FeRtbrSAxL2i7eJPuZsyFVaRGyD0DPvo
Message-ID: <CA+EHjTy2=NjAOwG32_Aj2akEDS8yo92nTMmd_rkUPABDAAcdAA@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: arm64: Account for RES1 bits in
 DECLARE_FEAT_MAP() and co
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Sascha Bischoff <Sascha.Bischoff@arm.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 Dec 2025 at 17:30, Marc Zyngier <maz@kernel.org> wrote:
>
> None of the registers we manage in the feature dependency infrastructure
> so far has any RES1 bit. This is about to change, as VTCR_EL2 has
> its bit 31 being RES1.
>
> In order to not fail the consistency checks by not describing a bit,
> add RES1 bits to the set of immutable bits. This requires some extra
> surgery for the FGT handling, as we now need to track RES1 bits there
> as well.
>
> There are no RES1 FGT bits *yet*. Watch this space.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>


Reviewed-by: Fuad Tabba <tabba@google.com>

/fuad

> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/config.c           | 25 +++++++-------
>  arch/arm64/kvm/emulate-nested.c   | 55 +++++++++++++++++--------------
>  3 files changed, 45 insertions(+), 36 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index ac7f970c78830..b552a1e03848c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -638,6 +638,7 @@ struct fgt_masks {
>         u64             mask;
>         u64             nmask;
>         u64             res0;
> +       u64             res1;
>  };
>
>  extern struct fgt_masks hfgrtr_masks;
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 24bb3f36e9d59..3845b188551b6 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -16,14 +16,14 @@
>   */
>  struct reg_bits_to_feat_map {
>         union {
> -               u64     bits;
> -               u64     *res0p;
> +               u64              bits;
> +               struct fgt_masks *masks;
>         };
>
>  #define        NEVER_FGU       BIT(0)  /* Can trap, but never UNDEF */
>  #define        CALL_FUNC       BIT(1)  /* Needs to evaluate tons of crap */
>  #define        FIXED_VALUE     BIT(2)  /* RAZ/WI or RAO/WI in KVM */
> -#define        RES0_POINTER    BIT(3)  /* Pointer to RES0 value instead of bits */
> +#define        MASKS_POINTER   BIT(3)  /* Pointer to fgt_masks struct instead of bits */
>
>         unsigned long   flags;
>
> @@ -92,8 +92,8 @@ struct reg_feat_map_desc {
>  #define NEEDS_FEAT_FIXED(m, ...)                       \
>         __NEEDS_FEAT_FLAG(m, FIXED_VALUE, bits, __VA_ARGS__, 0)
>
> -#define NEEDS_FEAT_RES0(p, ...)                                \
> -       __NEEDS_FEAT_FLAG(p, RES0_POINTER, res0p, __VA_ARGS__)
> +#define NEEDS_FEAT_MASKS(p, ...)                               \
> +       __NEEDS_FEAT_FLAG(p, MASKS_POINTER, masks, __VA_ARGS__)
>
>  /*
>   * Declare the dependency between a set of bits and a set of features,
> @@ -109,19 +109,20 @@ struct reg_feat_map_desc {
>  #define DECLARE_FEAT_MAP(n, r, m, f)                                   \
>         struct reg_feat_map_desc n = {                                  \
>                 .name                   = #r,                           \
> -               .feat_map               = NEEDS_FEAT(~r##_RES0, f),     \
> +               .feat_map               = NEEDS_FEAT(~(r##_RES0 |       \
> +                                                      r##_RES1), f),   \
>                 .bit_feat_map           = m,                            \
>                 .bit_feat_map_sz        = ARRAY_SIZE(m),                \
>         }
>
>  /*
>   * Specialised version of the above for FGT registers that have their
> - * RES0 masks described as struct fgt_masks.
> + * RESx masks described as struct fgt_masks.
>   */
>  #define DECLARE_FEAT_MAP_FGT(n, msk, m, f)                             \
>         struct reg_feat_map_desc n = {                                  \
>                 .name                   = #msk,                         \
> -               .feat_map               = NEEDS_FEAT_RES0(&msk.res0, f),\
> +               .feat_map               = NEEDS_FEAT_MASKS(&msk, f),    \
>                 .bit_feat_map           = m,                            \
>                 .bit_feat_map_sz        = ARRAY_SIZE(m),                \
>         }
> @@ -1168,21 +1169,21 @@ static const DECLARE_FEAT_MAP(mdcr_el2_desc, MDCR_EL2,
>                               mdcr_el2_feat_map, FEAT_AA64EL2);
>
>  static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
> -                                 int map_size, u64 res0, const char *str)
> +                                 int map_size, u64 resx, const char *str)
>  {
>         u64 mask = 0;
>
>         for (int i = 0; i < map_size; i++)
>                 mask |= map[i].bits;
>
> -       if (mask != ~res0)
> +       if (mask != ~resx)
>                 kvm_err("Undefined %s behaviour, bits %016llx\n",
> -                       str, mask ^ ~res0);
> +                       str, mask ^ ~resx);
>  }
>
>  static u64 reg_feat_map_bits(const struct reg_bits_to_feat_map *map)
>  {
> -       return map->flags & RES0_POINTER ? ~(*map->res0p) : map->bits;
> +       return map->flags & MASKS_POINTER ? (map->masks->mask | map->masks->nmask) : map->bits;
>  }
>
>  static void __init check_reg_desc(const struct reg_feat_map_desc *r)
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 834f13fb1fb7d..75d49f83342a5 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2105,23 +2105,24 @@ static u32 encoding_next(u32 encoding)
>  }
>
>  #define FGT_MASKS(__n, __m)                                            \
> -       struct fgt_masks __n = { .str = #__m, .res0 = __m, }
> -
> -FGT_MASKS(hfgrtr_masks, HFGRTR_EL2_RES0);
> -FGT_MASKS(hfgwtr_masks, HFGWTR_EL2_RES0);
> -FGT_MASKS(hfgitr_masks, HFGITR_EL2_RES0);
> -FGT_MASKS(hdfgrtr_masks, HDFGRTR_EL2_RES0);
> -FGT_MASKS(hdfgwtr_masks, HDFGWTR_EL2_RES0);
> -FGT_MASKS(hafgrtr_masks, HAFGRTR_EL2_RES0);
> -FGT_MASKS(hfgrtr2_masks, HFGRTR2_EL2_RES0);
> -FGT_MASKS(hfgwtr2_masks, HFGWTR2_EL2_RES0);
> -FGT_MASKS(hfgitr2_masks, HFGITR2_EL2_RES0);
> -FGT_MASKS(hdfgrtr2_masks, HDFGRTR2_EL2_RES0);
> -FGT_MASKS(hdfgwtr2_masks, HDFGWTR2_EL2_RES0);
> +       struct fgt_masks __n = { .str = #__m, .res0 = __m ## _RES0, .res1 = __m ## _RES1 }
> +
> +FGT_MASKS(hfgrtr_masks, HFGRTR_EL2);
> +FGT_MASKS(hfgwtr_masks, HFGWTR_EL2);
> +FGT_MASKS(hfgitr_masks, HFGITR_EL2);
> +FGT_MASKS(hdfgrtr_masks, HDFGRTR_EL2);
> +FGT_MASKS(hdfgwtr_masks, HDFGWTR_EL2);
> +FGT_MASKS(hafgrtr_masks, HAFGRTR_EL2);
> +FGT_MASKS(hfgrtr2_masks, HFGRTR2_EL2);
> +FGT_MASKS(hfgwtr2_masks, HFGWTR2_EL2);
> +FGT_MASKS(hfgitr2_masks, HFGITR2_EL2);
> +FGT_MASKS(hdfgrtr2_masks, HDFGRTR2_EL2);
> +FGT_MASKS(hdfgwtr2_masks, HDFGWTR2_EL2);
>
>  static __init bool aggregate_fgt(union trap_config tc)
>  {
>         struct fgt_masks *rmasks, *wmasks;
> +       u64 rresx, wresx;
>
>         switch (tc.fgt) {
>         case HFGRTR_GROUP:
> @@ -2154,24 +2155,27 @@ static __init bool aggregate_fgt(union trap_config tc)
>                 break;
>         }
>
> +       rresx = rmasks->res0 | rmasks->res1;
> +       if (wmasks)
> +               wresx = wmasks->res0 | wmasks->res1;
> +
>         /*
>          * A bit can be reserved in either the R or W register, but
>          * not both.
>          */
> -       if ((BIT(tc.bit) & rmasks->res0) &&
> -           (!wmasks || (BIT(tc.bit) & wmasks->res0)))
> +       if ((BIT(tc.bit) & rresx) && (!wmasks || (BIT(tc.bit) & wresx)))
>                 return false;
>
>         if (tc.pol)
> -               rmasks->mask |= BIT(tc.bit) & ~rmasks->res0;
> +               rmasks->mask |= BIT(tc.bit) & ~rresx;
>         else
> -               rmasks->nmask |= BIT(tc.bit) & ~rmasks->res0;
> +               rmasks->nmask |= BIT(tc.bit) & ~rresx;
>
>         if (wmasks) {
>                 if (tc.pol)
> -                       wmasks->mask |= BIT(tc.bit) & ~wmasks->res0;
> +                       wmasks->mask |= BIT(tc.bit) & ~wresx;
>                 else
> -                       wmasks->nmask |= BIT(tc.bit) & ~wmasks->res0;
> +                       wmasks->nmask |= BIT(tc.bit) & ~wresx;
>         }
>
>         return true;
> @@ -2180,7 +2184,6 @@ static __init bool aggregate_fgt(union trap_config tc)
>  static __init int check_fgt_masks(struct fgt_masks *masks)
>  {
>         unsigned long duplicate = masks->mask & masks->nmask;
> -       u64 res0 = masks->res0;
>         int ret = 0;
>
>         if (duplicate) {
> @@ -2194,10 +2197,14 @@ static __init int check_fgt_masks(struct fgt_masks *masks)
>                 ret = -EINVAL;
>         }
>
> -       masks->res0 = ~(masks->mask | masks->nmask);
> -       if (masks->res0 != res0)
> -               kvm_info("Implicit %s = %016llx, expecting %016llx\n",
> -                        masks->str, masks->res0, res0);
> +       if ((masks->res0 | masks->res1 | masks->mask | masks->nmask) != GENMASK(63, 0) ||
> +           (masks->res0 & masks->res1)  || (masks->res0 & masks->mask) ||
> +           (masks->res0 & masks->nmask) || (masks->res1 & masks->mask)  ||
> +           (masks->res1 & masks->nmask) || (masks->mask & masks->nmask)) {
> +               kvm_info("Inconsistent masks for %s (%016llx, %016llx, %016llx, %016llx)\n",
> +                        masks->str, masks->res0, masks->res1, masks->mask, masks->nmask);
> +               masks->res0 = ~(masks->res1 | masks->mask | masks->nmask);
> +       }
>
>         return ret;
>  }
> --
> 2.47.3
>
