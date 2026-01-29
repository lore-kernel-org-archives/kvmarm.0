Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D583542C6
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 17:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769708427; cv=pass; b=nJJCvZh5XXbrq2HjWnCrYx8DE/AVanqdbdHDMh1LYU4oxgiTAlZf7Zt8Bf9LU6AJNg4LtjG9AZZX2arqyXU4LgexFmIj8mOQfui5sZgv1W9OqkiUtRSMOtKuc7EmZiiakiQwdPRFPUySgKTdbXYW8LJxbGF+/LTHrN5zlZb2o4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769708427; c=relaxed/simple;
	bh=xdVu8OJgzy9v9aQHZ3Bnvas9n3HUplybL2o+SRSYzgY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i8DyTp8mfRFoN5Uy+qec1TwZOYTwyH9ZxTaldgzd4IEl4DZA7thaQ314tnqK7ocm3gvm/0hR3cMi7bHOQ+lpei0gfWPVcCPhEf6G5vRYdZezonYRa61Sfw/mtkazHMyN5F7jfkGgd5FFP27M7ZFJHW3jJI2mCtvuti8ShYhh/EA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2jwaJQmH; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2jwaJQmH"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5033b0b6eabso675111cf.1
        for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 09:40:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769708423; cv=none;
        d=google.com; s=arc-20240605;
        b=Ci5BoWHgQurDPV//P0g3cwGjJRebU87g8EyriRHJNCNbs3gDU78GudyabLtZ5Xtr+i
         9tymDZDJIuF4BduBMPT45324gyBvgJ1Pf5yQ4D6UV1qU4GdpnaixCVQM+WtvZvZiJL1n
         u/qRDqT3Nzc9wuXr7Z4MqtcUzzs356JL+19PJbQZtYmEHFvGfV+MHpoSdDJr5JkEsdUl
         v7ockEd71cm7zwrbPyF+frNamANywwPZanOP7tfTSj3rLcdMeHIiBz4i4yYi07H4mEa5
         FHijA3ZPBLHQ5pabJjS4G/j+SKg/sojiompfn3sqJZAPZ4IEgDUqF/vq04HK7wbOHh0p
         ubYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=C9PI9Qi8HDlLbV57o548904J5pG00v1lKuCCnBvJ6co=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=UPkXZYklE1pToVbj85sK1sZzLXlEDlFI2lUfJYQtdZ+q8HzF6b/hOD7Np79jeqZSSC
         Ig9PethBXYU7TwbAlHkAdUH/7Bck1HO9GymhdP5ZvvK2ahVj/NE5OoKk7CAujuYxdnjz
         2c+6/VH4Q1cBLwQwmpPn7uH/xRrcapL3kAH0dPTPCtsuzpHdhAd7I3LrY9nU03PreN+i
         myedJ3wnT/FxQTcOyZ8KzARfIY5NS5giLvxsAkDOl+4yiaI+Gyl+r/e162AA7FgMf6Q7
         zNfbqb3Xqlu8ZdVZQ/u4CJmZfcWTLBaItrmRCt6vBTYi5B1K365UZPQ46Ywy5QbgjjIZ
         chdA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769708423; x=1770313223; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C9PI9Qi8HDlLbV57o548904J5pG00v1lKuCCnBvJ6co=;
        b=2jwaJQmHuFjtAvP8oeq9kTOwqD0Q86g0tv1exUOZfQBJnELZ0XybDWjo2d+lx/NJbG
         KxHjrcADBepTZ275rZAYGAcT3dxZZCLrXJ0mfr6LndgdUpFfKHfCdOhPPUpu3+xW3Tl8
         N3JXNLLAZSxe7J1PnFtTY69f6Vl+7rgbsckH1/BF9KeNjleF0wWBvH+J3kuOn1VssFOh
         hdCkFy62OSgnIVLULK25Ce9p/o60c1UbAnxRhOmjyONlDieRYOvv4Q4eW96jpEioDWvY
         j9zczaOkksQfbyBg3c8Xm97/XZU/VDaAvbYSXUNR79xFXPKvPoi1SjTH7zgFxcSdllK0
         lLIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769708423; x=1770313223;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C9PI9Qi8HDlLbV57o548904J5pG00v1lKuCCnBvJ6co=;
        b=e39BwK9ChZVguXSvaGUQQu3G5W0S4wrGqWNH5csazR/JYVouA13zbAWIRlfS0kFVG+
         W/6V9PmTzelmjJJlUGs2lgWGL493KPseqRkT3V7PESR1rONMNd9H2k2jvJjGfLddI6Pj
         uT9zkM+Z5YY1/AVXGw1MXCthu/7QRkqRXkvjXaIBSpMEoquUu0KMRov/KkpCPQK+/q0y
         X0ie9Eq9JgSRad4r9Xm6PJxny5MbyedUzB8bUIOESKCMjbWHBl+bZjhUZz24UtfsqnU6
         VSpxMFnYQuE03jvd8Gn5lamfqwSjFF7nrdV6ru/GkvgNFEXLUQT6hxzBTOOT6ZxcvgwK
         dOXA==
X-Gm-Message-State: AOJu0YxCP4qRvUtA1NKnvuaOikbgLQ1tDbOuIC161om6c6A+2yEf9AmY
	yabEyP3V0S36yXuchBs+6cUugLtd0Ybb42airwUW6M2jvKWvRsEX0mshjkjZHJwo1jjl6XN+F+W
	c6HtfsPqfOM/fmzBG3EOUu8TNkRdfRWkhl742kZUM
X-Gm-Gg: AZuq6aK3zUe8VX6ccy/GuEz8veRCTfQhKaBQk+QrB0todDCcRIHqRC+HiyG/NiHxU95
	vF4zMaSUNARAEYDML4J0YKmyOEJ5xFg4UKP/Bur4Y8ZZYFQf/KEhzoCFfn9b05ISpZr9rCwcB2f
	H7bM4CMJWUr6gazZpTZ4tcjv6VkJ0qHd12WuPNMtQqLCnTJcseZl3GAPGXcOM9K6TDIPQ+IEiDl
	UBQt2ijDD9obX3mH0TN5yGoAqWS+kco+xh+ggYnEvDi6R541iWSC0PB+XMhm2NJkItvnzEY
X-Received: by 2002:ac8:5a43:0:b0:4f1:9c6e:cf1c with SMTP id
 d75a77b69052e-504310b4cecmr11694721cf.17.1769708422703; Thu, 29 Jan 2026
 09:40:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-14-maz@kernel.org>
 <CA+EHjTw_4WJgiS7vTUprvJOjdNrnW=sjhazCkU9eQW8BUYuZZw@mail.gmail.com> <86a4xwbakk.wl-maz@kernel.org>
In-Reply-To: <86a4xwbakk.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 17:39:45 +0000
X-Gm-Features: AZwV_QgS_ySXSV2SHoit8uIkCqZLoVSe3rfHiqo21RvB3vOxbqAI8dmocE5xOnU
Message-ID: <CA+EHjTyf5Zhb2JFbg6jv1opCX=GV9_PMNiMo=0fCc9cYxzEAiw@mail.gmail.com>
Subject: Re: [PATCH 13/20] KVM: arm64: Move RESx into individual register descriptors
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

...
> > I see what you're doing here, but it took me a while to get it and
> > convince myself that there aren't any bugs (my self couldn't find any
> > bugs, but I wouldn't trust him that much). You already introduce a new
> > flag, FORCE_RESx. Why not just check that directly in the
> > compute_resx_bits() loop, before the check for CALL_FUNC?
> >
> > + if (map[i].flags & FORCE_RESx)
> > +     match = false;
> > + else if (map[i].flags & CALL_FUNC)
> > ...
> >
> > The way it is now, to understand FORCE_RES0, you must trace a flag, a
> > macro expansion, and a function pointer, just to set a boolean to
> > false.
>
> With that scheme, you'd write something like:
>
> +#define FORCE_RES0(m)          NEEDS_FEAT_FLAG(m, FORCE_RESx)
>
> This construct would need a new __NEEDS_FEAT_0() macro that doesn't
> take any argument other than flags. Something like below (untested).
>
>         M.

LGTM. Not tested either. I plan to test the series once I'm done reviewing it.

Thanks,
/fuad

>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 9485e1f2dc0b7..364bdd1e5be51 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -79,6 +79,12 @@ struct reg_feat_map_desc {
>                 .match = (fun),                         \
>         }
>
> +#define __NEEDS_FEAT_0(m, f, w, ...)                   \
> +       {                                               \
> +               .w      = (m),                          \
> +               .flags = (f),                           \
> +       }
> +
>  #define __NEEDS_FEAT_FLAG(m, f, w, ...)                        \
>         CONCATENATE(__NEEDS_FEAT_, COUNT_ARGS(__VA_ARGS__))(m, f, w, __VA_ARGS__)
>
> @@ -95,9 +101,8 @@ struct reg_feat_map_desc {
>  #define NEEDS_FEAT(m, ...)     NEEDS_FEAT_FLAG(m, 0, __VA_ARGS__)
>
>  /* Declare fixed RESx bits */
> -#define FORCE_RES0(m)          NEEDS_FEAT_FLAG(m, FORCE_RESx, enforce_resx)
> -#define FORCE_RES1(m)          NEEDS_FEAT_FLAG(m, FORCE_RESx | AS_RES1, \
> -                                               enforce_resx)
> +#define FORCE_RES0(m)          NEEDS_FEAT_FLAG(m, FORCE_RESx)
> +#define FORCE_RES1(m)          NEEDS_FEAT_FLAG(m, FORCE_RESx | AS_RES1)
>
>  /*
>   * Declare the dependency between a non-FGT register, a set of
> @@ -221,15 +226,6 @@ struct reg_feat_map_desc {
>  #define FEAT_HCX               ID_AA64MMFR1_EL1, HCX, IMP
>  #define FEAT_S2PIE             ID_AA64MMFR3_EL1, S2PIE, IMP
>
> -static bool enforce_resx(struct kvm *kvm)
> -{
> -       /*
> -        * Returning false here means that the RESx bits will be always
> -        * addded to the fixed set bit. Yes, this is counter-intuitive.
> -        */
> -       return false;
> -}
> -
>  static bool not_feat_aa64el3(struct kvm *kvm)
>  {
>         return !kvm_has_feat(kvm, FEAT_AA64EL3);
> @@ -996,7 +992,7 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
>         NEEDS_FEAT(HCR_EL2_TWEDEL       |
>                    HCR_EL2_TWEDEn,
>                    FEAT_TWED),
> -       NEEDS_FEAT_FLAG(HCR_EL2_E2H, RES1_WHEN_E2H1, enforce_resx),
> +       NEEDS_FEAT_FLAG(HCR_EL2_E2H, RES1_WHEN_E2H1 | FORCE_RESx),
>         FORCE_RES0(HCR_EL2_RES0),
>         FORCE_RES1(HCR_EL2_RES1),
>  };
> @@ -1362,7 +1358,9 @@ struct resx compute_resx_bits(struct kvm *kvm,
>                 if (map[i].flags & exclude)
>                         continue;
>
> -               if (map[i].flags & CALL_FUNC)
> +               if (map[i].flags & FORCE_RESx)
> +                       match = false;
> +               else if (map[i].flags & CALL_FUNC)
>                         match = map[i].match(kvm);
>                 else
>                         match = idreg_feat_match(kvm, &map[i]);
>
> --
> Without deviation from the norm, progress is not possible.
