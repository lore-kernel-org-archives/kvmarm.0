Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5C72C0F8E
	for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 08:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771576604; cv=pass; b=DWleJn4VG1drBCBCUHOhphSYen7mVA2l337MGoB9aoJsvHye0R3P89ZfhbMdd6CAea/thAvAhwWeDcfg9pLlBdwpa0/Ij8Mttm7uP6uM0cl0X8U7+91MiNHNNrXUN+wyLET7yPYlRNWq2PQ6TgPtZDg431PYJs4cbAOTXUE4giw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771576604; c=relaxed/simple;
	bh=YkHtzaMTmobGuZlCVoJP9L0SgkxW0vFxw7cP7IwSG34=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=prwLUv4AG8TmYuSnLSmYy7vCO0udDGDAvgGW3x+5HfSFJAWF8szUPM5retxjsdyHRehlCf2iz4VG+2fzF6hlv9dE9Sgy1iz/6smFHvzc+sUpMXPOMaV4QIuERekHhUwyqFpmCPJWoesBg2uiSUXArbFqa0gfpdR0mKkV08oZC38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zC9cqTQr; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zC9cqTQr"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-505d3baf1a7so284881cf.1
        for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 00:36:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771576601; cv=none;
        d=google.com; s=arc-20240605;
        b=BHKR/njqA4DZN8A73d3JZ5o036jgIgXloHb1RfRg/4M+P4IHay9Vzz2d+0E2EkFsCZ
         M2McgsUgt/SizzHW3aLDoye6mNOqKADIQPeXRi49bgC0L+6kgZgBdgealcKESRt+ra6Y
         bAGBdz1y9DhXQLs5/cY5hDzfrmUljem+/vW/zIjJ2eXsbEI2hMSpt7srYdybvBOVb1Il
         y2DU8e/0gb9xSV619c21ldQKC0GkfSSNR3y4DE9FHXhRNGr/Ni2+BmdJBpAe/Ds3mKuA
         a7eEF1/dat5yJrLJJcad5ZaPc6hNGokmlBiguf5p9nv0/jgcfoySlWQIHnfo0wWNEjb3
         pfUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wDlaVVbBLdDal3YcpgZLDSMExLMyfMpma/ezoyrjcJA=;
        fh=WBvLjJLDiCxmTDW1d0256EL2mbx5FFxVJYpu7Ocng3Y=;
        b=h76ao1vRoi/KgOw8xdkG3MwnsZ0VSOsq9YaBeYShfGLKj2mbDFuLDmODiilR0rrEvc
         +xkkr7yA1bta7Xrs30FJUMfVdk+sooBsPe3PdvKaYrG1Wxgc4LiPkV2WAJToWCQ5hrF4
         B3yICIPu6whJaSJiUymXJSt9n6H5OG97RXZXqfHj2WAHlfB2u1znf0uBJGShldZHgdNb
         JSzVi4xa0kettJESEZJm+ALhQYT3R+nJfSbS9b07ryQJTpTgREe5sX+i0HBmEzKCwMlP
         E8gMvDJVDwf1YHNQzLJOiczK1BBxu++0tqH9rO1sSKOHA1X9Gwi70g7OTldg1DZpLNUb
         wMhA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771576601; x=1772181401; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wDlaVVbBLdDal3YcpgZLDSMExLMyfMpma/ezoyrjcJA=;
        b=zC9cqTQrulGd8BwKgyRqmwlL3WHw18zFJYLOjOPi1gpz46daOxWWam1ZJKiy0k0b+t
         XSZ1OBQAK9ko0XRZF2aiHUDdR/9kd8kPlstKlt7air9zMKUM6rVl4N8YlUdu1SsFae0q
         vj4+NENhNRHfsHKkybWZnt+y1L+KGZxoSVtbZhf7sQsNkNi/Vm6zxpxkpAlT8cAA8uSF
         qcYwWJnII0HAlPDKzMfZoIe2bY5clgvfZ9KlqK0ZTzR3liZhcAP3OtXzzluPeREEdW+a
         YGJbUbtKhkYGEHs+onmrITF6leHgvqd+QzkEzX8nrIgMQR3q8R1CoAU31bIBKYy8tyM9
         lxTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771576601; x=1772181401;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wDlaVVbBLdDal3YcpgZLDSMExLMyfMpma/ezoyrjcJA=;
        b=YvAeqTp7qXu/vWJX3M3fH+q5T565XYwh0zhyKj3h1nMQ1+xq7oEGNWsHSYAnQHRr2L
         9s3/tACEfdbzzkzMGxVrolcgOcI9jcXMwj5Hl6lZSfn1gXfyk8DRKvXovSQHjGSb874A
         rLoE/a86Fj/8NWoTb4DixiHHSGEZjlJNeooQDiiQtWC9yQNZH50dqiZ/UQujJ+ic2tz7
         KPKeCpfDxQYA9rzh41HBDn5JtIj1ACfxbu1WURlaVFQHFOedvoh5l7zAFcrSbZU+h7cb
         lN1YKfEYuB9DuxvHTS8nOkf5KSls/qIkJ63xwqEJLObDnQqmEZJfuu0Zmr4Lqo6HauQV
         TNsg==
X-Forwarded-Encrypted: i=1; AJvYcCX8PQUDRtG1v1kV66AqEnh3uVWf1Kz5axa47BHT7aHfK/SP7ggnWIEHmptkLWIXO+BbMDdeg34=@lists.linux.dev
X-Gm-Message-State: AOJu0YwnLPeZZmj4A8S+ZDG8EF2vg6Gw/yBBzL8fqqRzXDdczm1RD1yy
	euAcKIk9KM737SHptwHYxrL6hf28zFQm8FSOHj18uzQd0wGjasx+S7HzKO2joiLkE6qnObN9sfb
	CJvLytZOOW4MrD0izz/atfDJ9i6exPM/ZY8yF75GH
X-Gm-Gg: AZuq6aJoA19DttlWvTF6HRVTKzzJ/uTMA0cdnK4wc6UVWMVYLgDq+Zt8f5WUKaqgf0i
	/sXOavZ/AbljjPKA9OBxw4kkfXfnZzx9XrzK1zzIcL2hgVJyK7uI7sB7zlBcs0sjPs+19/zO/WH
	U4TVs0Bd2pYeHloIV4mDubTe9eIoWD3RSOdoOooIdN7sMbhipk/Yrz1Swc1P4YKslI9wyhEk6nu
	oJwz7o8g5BOvh3rk1ds75b4oXVmGIWzPTAkEVm6GoIZIRB1MZRwUq6CI0+iVxHxZpKBpOfC6yYg
	i6j+eh/rDRvrCCe1Dpk=
X-Received: by 2002:a05:622a:14e:b0:4f3:5475:6b10 with SMTP id
 d75a77b69052e-506fb4615e4mr8894251cf.8.1771576600947; Fri, 20 Feb 2026
 00:36:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260219195533.2455736-1-maz@kernel.org> <20260219195533.2455736-2-maz@kernel.org>
In-Reply-To: <20260219195533.2455736-2-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 20 Feb 2026 08:36:04 +0000
X-Gm-Features: AaiRm52jbJ9IZ7bNbbd9RDlERU8GTrUEk3PolIVa0wSoSiHCgwMBCb3XXwqiTBk
Message-ID: <CA+EHjTzVRq3r-7UR-MJYvv-Aw4kHQDHEmwtqY9is-fRDm-J06A@mail.gmail.com>
Subject: Re: [PATCH 1/9] arm64: Add logic to fully remove features from
 sanitised id registers
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Thu, 19 Feb 2026 at 19:55, Marc Zyngier <maz@kernel.org> wrote:
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
>  arch/arm64/include/asm/cpufeature.h | 15 ++++++++++-----
>  arch/arm64/kernel/cpufeature.c      | 21 ++++++++++++++++-----
>  2 files changed, 26 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 4de51f8d92cba..2731ea13c2c86 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -53,15 +53,20 @@ enum ftr_type {
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
> +       enum ftr_visibility visibility;
>         bool            strict; /* CPU Sanity check: strict matching required ? */
>         enum ftr_type   type;
>         u8              shift;

This introduces bloat. Should you group the bools together and the
enums together?

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index c840a93b9ef95..b34a39967d111 100644
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
> @@ -1057,17 +1057,28 @@ static void init_cpu_ftr_reg(u32 sys_reg, u64 new)
>                                 ftrp->shift);
>                 }
>
> -               val = arm64_ftr_set_value(ftrp, val, ftr_new);
> -
>                 valid_mask |= ftr_mask;
>                 if (!ftrp->strict)

Should FTR_ALL_HIDDEN also be removed from strict_mask? i.e.

-                 if (!ftrp->strict)
+                 if (!ftrp->strict || || ftrp->visibility == FTR_ALL_HIDDEN)

(or under the ALL_HIDDEN case below).


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
> +                       val = arm64_ftr_set_value(ftrp, val, ftrp->safe_val);
> +                       reg->user_val = arm64_ftr_set_value(ftrp,
> +                                                           reg->user_val,
> +                                                           ftrp->safe_val);

Should we also take the safe value in update_cpu_ftr_reg() for FTR_ALL_HIDDEN?

Cheers,
/fuad

> +                       break;
> +               case FTR_HIDDEN:
> +                       val = arm64_ftr_set_value(ftrp, val, ftr_new);
>                         reg->user_val = arm64_ftr_set_value(ftrp,
>                                                             reg->user_val,
>                                                             ftrp->safe_val);
> +                       break;
> +               }
>         }
>
>         val &= valid_mask;
> --
> 2.47.3
>
