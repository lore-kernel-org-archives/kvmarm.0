Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BE627D77B
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 16:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741107390; cv=none; b=uROFZoDSLX9/29Nd08r4YZdM8+Og5HUcRCBwZrCgpwCzv5OSnvGlEhndnRIshGmiWj900nDPrxc8gJRaaEu82b424RBItDaHEiJXzmo7twYtUtvHk+xJEkDFKzXAmkQziiqPjglyW0tuaehemx/WvFpjHz8JTHtiMrV7+YMCMvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741107390; c=relaxed/simple;
	bh=i8jamBfI+P0eeepl+Uhp4JL8/Pr1Lgs5TPF4k0VKrP0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JuXBJIpMbwOcs/eZyKcEmk6HgXrN2jpnLmPU1kLcva2WYX5k6el8LTb7ItFNdT+bFONuQfIotjCcL3TBvqDgSiAS+OpmuLoX5hdW4d74xCkwWVws/XM20nETq5MlsZFgaBzeTowpZocmDIjlEb/zIzn3TX93/OX9dkPcOiyxmQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GjI+Fweb; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GjI+Fweb"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-474e1b8c935so446911cf.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Mar 2025 08:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741107388; x=1741712188; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9DtRkP6CYCN2VX6LAP0NMel2JbBrN6HKmyX2jA5Yc7E=;
        b=GjI+Fweb3M3xkOoGXEXMp0cWrkfueFtAFD0/7ubsZ7T8L/9KV4HwaBCUASlAgfZiR7
         wfA32+dEsOJ84IDeGE7SJa+oFXBpPCa/hYnnvz2ba+okFEI2MvXSRwIZ+0NQPKatgPYH
         MPeMhX9+cIJCM3F4eq+HyXlfKh+PWsB84qHwQoOO/W3OcmiV8ahJDIo9BnU0/GMxcKNc
         rzpzSPy7oLheEqPe2L5BL64GAp8mRZwkuylSTk96xFQsBXxUTc2T/xSh0FMIxZilVLJY
         bpgpRUotD0qYHoC5+8bwLeCd606426XtAZxsEraGtlacMMXhs4QJOhZWz1lHGWSQdg4r
         LQ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741107388; x=1741712188;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9DtRkP6CYCN2VX6LAP0NMel2JbBrN6HKmyX2jA5Yc7E=;
        b=XtuXjMpYl7qH8qv7XIHJLSm/M8Tj7ILhibhcpgT6poBIsKwK5LGS4TAdvppUdU4+Kl
         5VBOUfBwIwZOZodo5/OcTArxa09QSAde+OG6SxJdbbcyxQqdxDtgaTaFckdRhn+T2eXj
         eXDp4R5CcvX95LIFFslgkhcd90yKldkmtx9rEd5myDXXIXjFSwVpXDBcwKb5FEOqRFVR
         VpAZUfIY5w12ZbHa2gXcHq7DAACwqtqKCHM6HwEnlSdrVIInjQg4umJt8aa7if12smVn
         qP+Is7no5NjfbXovG8QG8w3TvQ+/SzykPXjhgmVQi7odtCUbn1J9kVQBo3DQ5Hl4oSvI
         WVcA==
X-Gm-Message-State: AOJu0YwpVq5Hlh0y3qSnFYVsCrF0fdYGcyOAu7NJuSPZJExKYstgXZAT
	F4uI0Rs62xvIjoLyZ++uEkuqRr0md/cIpg3CCKj1CgsjWR41e+N586ezjBGGwXI6s9NRrF5et83
	HO/AUj33UXz354Lk6EdQM70XYqX1IKibiw41/
X-Gm-Gg: ASbGncvJvhVzMD3sE3r5he46w9/gXiuf9Ae/ggYn5x2kNtORq9El6t16SyCQtcFOoOF
	zeAhr764jBsxEoan5zzkzuObHto5e/sk1Qw73W+tYGVjQdHtJj1n3/kQfR0ef82Fu7pSUhkSU+t
	tvNgmd/7iyXMDU1ll9/ZvwGTgpeDzftzqXbo4Nz2OASms1YxFuw4axjg==
X-Google-Smtp-Source: AGHT+IF23vzPgXJFq7laGxxdPorzVUnziNDjwTEtrDs+9M/YfHZweGHZAZN5eGiioteQmHR0kHXdQj+z0gs3Xcfs9rk=
X-Received: by 2002:a05:622a:48e:b0:474:cbac:a983 with SMTP id
 d75a77b69052e-4750a4d1015mr307611cf.6.1741107387427; Tue, 04 Mar 2025
 08:56:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250210184150.2145093-1-maz@kernel.org> <20250210184150.2145093-8-maz@kernel.org>
In-Reply-To: <20250210184150.2145093-8-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 4 Mar 2025 16:55:50 +0000
X-Gm-Features: AQ5f1JpeNlKdk-l5r71vf2tqDSYKeajf6KLHiNZ0LiUdyjmTYrSWEAH6GprWQ2A
Message-ID: <CA+EHjTwm4CosWDGcaH_tnLU7zMNCq8twDyEcKd7-V0Lu7b-LcA@mail.gmail.com>
Subject: Re: [PATCH 07/18] KVM: arm64: Compute FGT masks from KVM's own FGT tables
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 10 Feb 2025 at 18:42, Marc Zyngier <maz@kernel.org> wrote:
>
> In the process of decoupling KVM's view of the FGT bits from the
> wider architectural state, use KVM's own FGT tables to build
> a synthitic view of what is actually known.

synthitic -> synthetic


> This allows for some checking along the way.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h  |   4 ++
>  arch/arm64/include/asm/kvm_host.h |  14 ++++
>  arch/arm64/kvm/emulate-nested.c   | 102 ++++++++++++++++++++++++++++++
>  3 files changed, 120 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 8d94a6c0ed5c4..e424085f2aaca 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -359,6 +359,10 @@
>  #define __HAFGRTR_EL2_MASK     (GENMASK(49, 17) | GENMASK(4, 0))
>  #define __HAFGRTR_EL2_nMASK    ~(__HAFGRTR_EL2_RES0 | __HAFGRTR_EL2_MASK)
>
> +/* Because the sysreg file mixes R and W... */
> +#define HFGRTR_EL2_RES0                HFGxTR_EL2_RES0 (0)
> +#define HFGWTR_EL2_RES0                (HFGRTR_EL2_RES0 | __HFGRTR_ONLY_MASK)

__HFGRTR_ONLY_MASK is a hand-crafted bitmask. The only bit remaining
in HFGxTR_EL2 that is RES0 is bit 51. If that were to be used as an
HFGRTR-only bit without __HFGRTR_ONLY_MASK getting updated, then
aggregate_fgt() below would set its bit in hfgwtr_masks. Could this be
a problem if this happens and the polarity of this bit ends up being
negative, thereby setting the corresponding nmask bit?

Cheers,
/fuad

> +
>  /* Similar definitions for HCRX_EL2 */
>  #define __HCRX_EL2_RES0         HCRX_EL2_RES0
>  #define __HCRX_EL2_MASK                (BIT(6))
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7cfa024de4e34..4e67d4064f409 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -569,6 +569,20 @@ struct kvm_sysreg_masks {
>         } mask[NR_SYS_REGS - __SANITISED_REG_START__];
>  };
>
> +struct fgt_masks {
> +       const char      *str;
> +       u64             mask;
> +       u64             nmask;
> +       u64             res0;
> +};
> +
> +extern struct fgt_masks hfgrtr_masks;
> +extern struct fgt_masks hfgwtr_masks;
> +extern struct fgt_masks hfgitr_masks;
> +extern struct fgt_masks hdfgrtr_masks;
> +extern struct fgt_masks hdfgwtr_masks;
> +extern struct fgt_masks hafgrtr_masks;
> +
>  struct kvm_cpu_context {
>         struct user_pt_regs regs;       /* sp = sp_el0 */
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 607d37bab70b4..bbfe89c37a86e 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2033,6 +2033,101 @@ static u32 encoding_next(u32 encoding)
>         return sys_reg(op0 + 1, 0, 0, 0, 0);
>  }
>
> +#define FGT_MASKS(__n, __m)                                            \
> +       struct fgt_masks __n = { .str = #__m, .res0 = __m, }
> +
> +FGT_MASKS(hfgrtr_masks, HFGRTR_EL2_RES0);
> +FGT_MASKS(hfgwtr_masks, HFGWTR_EL2_RES0);
> +FGT_MASKS(hfgitr_masks, HFGITR_EL2_RES0);
> +FGT_MASKS(hdfgrtr_masks, HDFGRTR_EL2_RES0);
> +FGT_MASKS(hdfgwtr_masks, HDFGWTR_EL2_RES0);
> +FGT_MASKS(hafgrtr_masks, HAFGRTR_EL2_RES0);
> +
> +static __init bool aggregate_fgt(union trap_config tc)
> +{
> +       struct fgt_masks *rmasks, *wmasks;
> +
> +       switch (tc.fgt) {
> +       case HFGxTR_GROUP:
> +               rmasks = &hfgrtr_masks;
> +               wmasks = &hfgwtr_masks;
> +               break;
> +       case HDFGRTR_GROUP:
> +               rmasks = &hdfgrtr_masks;
> +               wmasks = &hdfgwtr_masks;
> +               break;
> +       case HAFGRTR_GROUP:
> +               rmasks = &hafgrtr_masks;
> +               wmasks = NULL;
> +               break;
> +       case HFGITR_GROUP:
> +               rmasks = &hfgitr_masks;
> +               wmasks = NULL;
> +               break;
> +       }
> +
> +       /*
> +        * A bit can be reserved in either the R or W register, but
> +        * not both.
> +        */
> +       if ((BIT(tc.bit) & rmasks->res0) &&
> +           (!wmasks || (BIT(tc.bit) & wmasks->res0)))
> +               return false;
> +
> +       if (tc.pol)
> +               rmasks->mask |= BIT(tc.bit) & ~rmasks->res0;
> +       else
> +               rmasks->nmask |= BIT(tc.bit) & ~rmasks->res0;
> +
> +       if (wmasks) {
> +               if (tc.pol)
> +                       wmasks->mask |= BIT(tc.bit) & ~wmasks->res0;
> +               else
> +                       wmasks->nmask |= BIT(tc.bit) & ~wmasks->res0;
> +       }
> +
> +       return true;
> +}
> +
> +static __init int check_fgt_masks(struct fgt_masks *masks)
> +{
> +       unsigned long duplicate = masks->mask & masks->nmask;
> +       u64 res0 = masks->res0;
> +       int ret = 0;
> +
> +       if (duplicate) {
> +               int i;
> +
> +               for_each_set_bit(i, &duplicate, 64) {
> +                       kvm_err("%s[%d] bit has both polarities\n",
> +                               masks->str, i);
> +               }
> +
> +               ret = -EINVAL;
> +       }
> +
> +       masks->res0 = ~(masks->mask | masks->nmask);
> +       if (masks->res0 != res0)
> +               kvm_info("Implicit %s = %016llx, expecting %016llx\n",
> +                        masks->str, masks->res0, res0);
> +
> +       return ret;
> +}
> +
> +static __init int check_all_fgt_masks(int ret)
> +{
> +       int err = 0;
> +
> +       err |= check_fgt_masks(&hfgrtr_masks);
> +       err |= check_fgt_masks(&hfgwtr_masks);
> +       err |= check_fgt_masks(&hfgitr_masks);
> +       err |= check_fgt_masks(&hdfgrtr_masks);
> +       err |= check_fgt_masks(&hdfgwtr_masks);
> +       err |= check_fgt_masks(&hafgrtr_masks);
> +
> +       return ret ?: err;
> +}
> +
>  int __init populate_nv_trap_config(void)
>  {
>         int ret = 0;
> @@ -2097,8 +2192,15 @@ int __init populate_nv_trap_config(void)
>                         ret = xa_err(prev);
>                         print_nv_trap_error(fgt, "Failed FGT insertion", ret);
>                 }
> +
> +               if (!aggregate_fgt(tc)) {
> +                       ret = -EINVAL;
> +                       print_nv_trap_error(fgt, "FGT bit is reserved", ret);
> +               }
>         }
>
> +       ret = check_all_fgt_masks(ret);
> +
>         kvm_info("nv: %ld fine grained trap handlers\n",
>                  ARRAY_SIZE(encoding_to_fgt));
>
> --
> 2.39.2
>
