Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B64C34107F
	for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 11:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771585603; cv=pass; b=EXh8wSHS6PGQ6oZgBINRWqIoDoXyWjtVuT1xYjWE4hPzr7hJCR7l8mUMQjG8fWc/sHV9947EW/QyobYScIz08SDPJ7NeMcyI6ZqzFl6vhndBxx8xppWJVrM8pMs3xT/mXcIsgd4OoQ/K0ZJ5AfL8F/VzCk8ZCX842nmPGm80StE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771585603; c=relaxed/simple;
	bh=K0B/jLGRfuOpOCsiSctVYVq8zu0PCuE1VjFj60gH9wk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RG2BtMD4XCXdVuckuoxoM0aNzXHzK3U7gogtp+Dw3MWWf5NROGkOBnYCQTIxfmmsY/3/FHNJycrQNwmzsZbkq21ai0IxgkkRDLPBqkoPD9pyEya78NZU8/liHg/wlP20P1llHCl9p5GUnN7yCgmuEnwlMzvOr9e4R2hiOLcqCUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mDC8BfVT; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mDC8BfVT"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5069a785ed2so368631cf.1
        for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 03:06:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771585600; cv=none;
        d=google.com; s=arc-20240605;
        b=iQkZs9xu9j1/9njyA8LCWOn8fxypSqUutHCJAZx+oMEIgV6owfwpo9BD/19HStDg9I
         9QoYdd0RwR/XafFjQImxlF3YAGACij8C2g2x7V6OKSo+N9R9YDxeAtb4RUXBMWUmEjid
         gOthYArOn7RaPcW5u+K9SCXps/sRs5Ss5BOO7I/Tmlpnt6SSTpOmd8stkDG/eMfWx+Gj
         paNDwdbPG8BF9qQZqKpuvf+Xi8tkeMEMRvrDmgNS5eeOAteyGh4vXUMTlQZIMXQ49fwD
         5Wn2C6FIEDxdvfbVCSmGYxGu/ye2pD5yJeZiO7cUjOjpAHAqQR1vuT771CRhdWjjmfzE
         RdOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=RFp5DfGIm5rTdSxaBfSzcrJypBa2V3M4F1JeGuwI7jo=;
        fh=QWF0HqbCZMuI6suMPlCaxJVxa5yr1rooj5n0CAnZfVk=;
        b=chisVROz9QHpMFB6D3rJIU0G+iZLLwsIfOEM15Y69fMYufxEYwTvAlmZn9jnpLDvxp
         +kxEIiOFy3+NepxTfm4DTCr7cBZ0lC086/tvNmvnR8T7k5j1MX7tHUoS4RGLPghG1EIU
         ssREYtOqZUNnBd4ibcfmyastG94FQxGiZgEczt50xOiqt4eJuRSrDY0GI9j2aQr2lD4j
         yBX5VNM4d/Bpu/WOm8mZEAChwiQHlWlUcBRYI8+v+1mo6L4gmNtQ9eXENQYAC4M0ZrZk
         o9n2SRqeQ0HRHOayCNpbSbH0tIEv/Lzpuu46TDJbwF8QBMiryf+6Ry0Uz94okVqPpOxD
         jH6Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771585600; x=1772190400; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RFp5DfGIm5rTdSxaBfSzcrJypBa2V3M4F1JeGuwI7jo=;
        b=mDC8BfVTkjsvIn1IYzbxeyL9Zev4gSug7GbWuGLDaBj+BlbL9H92Ry0rhtvprYLKHC
         yRGWnKg/LeTYTjY0xeEgbOlnrLK2mf+Uh39jBExBb/hzLUpbj3pJfeS8/UireBFW4X7n
         O3yjafVRfs7gS+kK5EHNHg6ho1rhxGG+nUivVnD3hlVbr0wmKObwl2QadR3WjcvfgVZa
         OCawO+PtHwRKRFOFHakHwhMvUF2HnqokiUsdQM2AmqH/3x3Al+ZcIyauDx40k6sa5xmF
         0UJdrpQQu5HRGgcYtDfUsPIvcIii6uqCqyAqaWlb04/BTDfS7zwGhMaM0RnQuJ3Qtyeg
         MdIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771585600; x=1772190400;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RFp5DfGIm5rTdSxaBfSzcrJypBa2V3M4F1JeGuwI7jo=;
        b=wMcRIqu4E/Tow2QDmAxSw5j+NGlTiVgy0vNY0TIcR54M8HS7LPJl0qfFBFU6s3eXRJ
         jMI3VOtMYjF72rJiJAoaxPyQX3txZJ/ZK03EGkDp6BHkWAMlSBEfNZ1V6QGDj8uZ9Pqa
         UBqxBHQut3G7zWyveXyRHpnSv6xm8SHOYbbSuP7YCoaMgDds+XC2v5Q3KKU837nZJTpW
         jgaochH3hgQD/w3Ydy0b4k2+xhiqpnsfEQr4Zkk+m0eA6h97dU/cyCwCwnJS8KRCuchY
         yu9Dbks/ChaInWyRpWgEpEzGKAyZj9BqibLRBC8iYjrA2U6+X8NpSjQbO3HQBH/hzBU3
         s8Tw==
X-Forwarded-Encrypted: i=1; AJvYcCXjo3P+OAi/9giovCkqfmJUcutUr+B8gcXY7r2+Evxc30Db88CNDk99cqLYQvKV4Z4drx84w1k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz88vx3g2CuUGFFFf5XAHvZfuTNkrRfjVAJXi+kNhpZII/voBMx
	qxJ20Q8MHvfDn7q5zm0ztwe0U4wL/zEyDiNT8POHZ7tFhJEFLZlW5BL+0pacDxyMDGQxqx68OgT
	xPHh/nSTv9wiD4qOAPQugbNF8awlFCyH+urWdN16M
X-Gm-Gg: AZuq6aK6xAHf4cbQMmifKCf4rLvRKZEpv1ejA16WBdFVQ3PeNO83HSV+A2hUNoKKK9r
	qJEeY4FIeLYN9pgVLQkDevD8LfpKvHgooFOd3qryls9g8/7zRqW6c31rrAIL1kCZKb/DWt+UxyO
	XwFbI+s/voKuqb6y/RB6ivylSatAZQI5L1f2hoOUzbPlKMVED+TUxutBG+Sgj5N4JbJs6/4tHDE
	efRY5q08vNAeDgRH7hz89MXXuL5DPfNLD4Ot8vZMlTSVpUAcJ7VrJNwbCR9gSHkis9jdsBSYYhO
	eUR3iVW6
X-Received: by 2002:a05:622a:138b:b0:4ff:cb75:2a22 with SMTP id
 d75a77b69052e-506fc3e0c41mr7730581cf.3.1771585599550; Fri, 20 Feb 2026
 03:06:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260219195533.2455736-1-maz@kernel.org> <20260219195533.2455736-2-maz@kernel.org>
 <CA+EHjTzVRq3r-7UR-MJYvv-Aw4kHQDHEmwtqY9is-fRDm-J06A@mail.gmail.com> <86v7frafpx.wl-maz@kernel.org>
In-Reply-To: <86v7frafpx.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 20 Feb 2026 11:06:03 +0000
X-Gm-Features: AaiRm53GNWjxaOs-wYxPbiX3btlEdWrInHpONxoYyYWhEw30R7kUbfS5nY5TfDA
Message-ID: <CA+EHjTzj9wEm7oBKBXF8sYpK60FYeLOJwEapxDiO1HxK5e6Y6g@mail.gmail.com>
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

On Fri, 20 Feb 2026 at 10:09, Marc Zyngier <maz@kernel.org> wrote:
>
> Hey Fuad,
>
> Thanks for taking a look.
>
> On Fri, 20 Feb 2026 08:36:04 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Thu, 19 Feb 2026 at 19:55, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > We currently make support for some features such as Pointer Auth,
> > > SVE or S1POE a compile time decision.
> > >
> > > However, while we hide that feature from userspace when such support
> > > is disabled, we still leave the value provided by the HW visible to
> > > the rest of the kernel, including KVM.
> > >
> > > This has the potential to result in ugly state leakage, as half of
> > > the kernel knows about the feature, and the other doesn't.
> > >
> > > Short of completely banning such compilation options and restore
> > > universal knowledge, introduce the possibility to fully remove such
> > > knowledge from the sanitised id registers.
> > >
> > > This has more or less the same effect as the idreg override that
> > > a user can pass on the command-line, only defined at build-time.
> > >
> > > For that purpose, we provide a new macro (FTR_CONFIG()) that defines
> > > the behaviour of a feature, both when enabled and disabled.
> > >
> > > At this stage, nothing is making use of this anti-feature.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/include/asm/cpufeature.h | 15 ++++++++++-----
> > >  arch/arm64/kernel/cpufeature.c      | 21 ++++++++++++++++-----
> > >  2 files changed, 26 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> > > index 4de51f8d92cba..2731ea13c2c86 100644
> > > --- a/arch/arm64/include/asm/cpufeature.h
> > > +++ b/arch/arm64/include/asm/cpufeature.h
> > > @@ -53,15 +53,20 @@ enum ftr_type {
> > >  #define FTR_SIGNED     true    /* Value should be treated as signed */
> > >  #define FTR_UNSIGNED   false   /* Value should be treated as unsigned */
> > >
> > > -#define FTR_VISIBLE    true    /* Feature visible to the user space */
> > > -#define FTR_HIDDEN     false   /* Feature is hidden from the user */
> > > +enum ftr_visibility {
> > > +       FTR_HIDDEN,             /* Feature hidden from the user */
> > > +       FTR_ALL_HIDDEN,         /* Feature hidden from kernel, user and KVM */
> > > +       FTR_VISIBLE,            /* Feature visible to all observers */
> > > +};
> > > +
> > > +#define FTR_CONFIG(c, e, d)                            \
> > > +       (IS_ENABLED(c) ? FTR_ ## e : FTR_ ## d)
> > >
> > > -#define FTR_VISIBLE_IF_IS_ENABLED(config)              \
> > > -       (IS_ENABLED(config) ? FTR_VISIBLE : FTR_HIDDEN)
> > > +#define FTR_VISIBLE_IF_IS_ENABLED(c)   FTR_CONFIG(c, VISIBLE, HIDDEN)
> > >
> > >  struct arm64_ftr_bits {
> > >         bool            sign;   /* Value is signed ? */
> > > -       bool            visible;
> > > +       enum ftr_visibility visibility;
> > >         bool            strict; /* CPU Sanity check: strict matching required ? */
> > >         enum ftr_type   type;
> > >         u8              shift;
> >
> > This introduces bloat. Should you group the bools together and the
> > enums together?
>
> That should be possible as long as everybody ends up using the
> __ARM64_FTR_BITS macro. On the other hand, I could reduce the width of
> the enum to something more appropriate and keep the current layout.
>
> With the current changes, this looks like this:
>
> struct arm64_ftr_bits {
>         bool                       sign;                 /*     0     1 */
>
>         /* XXX 3 bytes hole, try to pack */
>
>         enum ftr_visibility        visibility;           /*     4     4 */
>         bool                       strict;               /*     8     1 */
>
>         /* XXX 3 bytes hole, try to pack */
>
>         enum ftr_type              type;                 /*    12     4 */
>         u8                         shift;                /*    16     1 */
>         u8                         width;                /*    17     1 */
>
>         /* XXX 6 bytes hole, try to pack */
>
>         s64                        safe_val;             /*    24     8 */
>
>         /* size: 32, cachelines: 1, members: 7 */
>         /* sum members: 20, holes: 3, sum holes: 12 */
>         /* last cacheline: 32 bytes */
> };
>
> which is 8 bytes larger than the upstream version. But if I do this:
>
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index adaae3060851c..d8accc9c94fab 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -64,9 +64,9 @@ enum ftr_visibility {
>
>  struct arm64_ftr_bits {
>         bool            sign;   /* Value is signed ? */
> -       enum ftr_visibility visibility;
> +       enum ftr_visibility visibility:8;
>         bool            strict; /* CPU Sanity check: strict matching required ? */
> -       enum ftr_type   type;
> +       enum ftr_type   type:8;
>         u8              shift;
>         u8              width;
>         s64             safe_val; /* safe value for FTR_EXACT features */
>
> I end up with the following layout:
>
> struct arm64_ftr_bits {
>         bool                       sign;                 /*     0     1 */
>
>         /* Bitfield combined with previous fields */
>
>         enum ftr_visibility        visibility:8;         /*     0: 8  4 */
>
>         /* Bitfield combined with next fields */
>
>         bool                       strict;               /*     2     1 */
>
>         /* Bitfield combined with previous fields */
>
>         enum ftr_type              type:8;               /*     0:24  4 */
>         u8                         shift;                /*     4     1 */
>         u8                         width;                /*     5     1 */
>
>         /* XXX 2 bytes hole, try to pack */
>
>         s64                        safe_val;             /*     8     8 */
>
>         /* size: 16, cachelines: 1, members: 7 */
>         /* sum members: 12, holes: 1, sum holes: 2 */
>         /* sum bitfield members: 16 bits (2 bytes) */
>         /* last cacheline: 16 bytes */
> };
>
> which is 8 bytes *smaller* than the upstream version, without
> reordering. WDYT?

Using 8-bit bitfields for the enums shrinks the footprint from 24 to
16 bytes while preserving the structure's semantic readability. I like
this approach.

>
> >
> > > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > > index c840a93b9ef95..b34a39967d111 100644
> > > --- a/arch/arm64/kernel/cpufeature.c
> > > +++ b/arch/arm64/kernel/cpufeature.c
> > > @@ -192,7 +192,7 @@ void dump_cpu_features(void)
> > >  #define __ARM64_FTR_BITS(SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) \
> > >         {                                               \
> > >                 .sign = SIGNED,                         \
> > > -               .visible = VISIBLE,                     \
> > > +               .visibility = VISIBLE,                  \
> > >                 .strict = STRICT,                       \
> > >                 .type = TYPE,                           \
> > >                 .shift = SHIFT,                         \
> > > @@ -1057,17 +1057,28 @@ static void init_cpu_ftr_reg(u32 sys_reg, u64 new)
> > >                                 ftrp->shift);
> > >                 }
> > >
> > > -               val = arm64_ftr_set_value(ftrp, val, ftr_new);
> > > -
> > >                 valid_mask |= ftr_mask;
> > >                 if (!ftrp->strict)
> >
> > Should FTR_ALL_HIDDEN also be removed from strict_mask? i.e.
> >
> > -                 if (!ftrp->strict)
> > +                 if (!ftrp->strict || || ftrp->visibility == FTR_ALL_HIDDEN)
> >
> > (or under the ALL_HIDDEN case below).
>
> If we run on a system that has diverging features, we probably want to
> know irrespective of the feature being enabled. After all, the
> integration is out of spec, and conveying that information is
> important, just in case the diverging feature affects behaviour in
> funny ways...

I see. If the kernel is booted on broken/asymmetric hardware, we still
want to warn the user about the underlying violation, even if we are
pretending the feature doesn't exist for our own purposes. Leaving it
in the strict_mask is the correct approach to retain that diagnostic
capability.

> >
> >
> > >                         strict_mask &= ~ftr_mask;
> > > -               if (ftrp->visible)
> > > +
> > > +               switch (ftrp->visibility) {
> > > +               case FTR_VISIBLE:
> > > +                       val = arm64_ftr_set_value(ftrp, val, ftr_new);
> > >                         user_mask |= ftr_mask;
> > > -               else
> > > +                       break;
> > > +               case FTR_ALL_HIDDEN:
> > > +                       val = arm64_ftr_set_value(ftrp, val, ftrp->safe_val);
> > > +                       reg->user_val = arm64_ftr_set_value(ftrp,
> > > +                                                           reg->user_val,
> > > +                                                           ftrp->safe_val);
> >
> > Should we also take the safe value in update_cpu_ftr_reg() for FTR_ALL_HIDDEN?
>
> I would expect arm64_ftr_safe_value() to do the right thing at that
> stage, given that we have primed the boot CPU with the safe value, and
> that we rely on that bootstrap to make the registers converge towards
> something safe. This is also what happens for the command-line override.
>
> Or have you spotted a case where this go wrong?

I think so... What if a future FTR_ALL_HIDDEN feature is defined as
FTR_HIGHER_SAFE? Wouldn't that cause problems on secondary CPUs?
init_cpu_ftr_reg() primes sys_val with safe_val on the boot CPU,
update_cpu_ftr_reg() on secondary CPUs compares the hardware value
(ftr_new) against safe_val (ftr_cur). For FTR_HIGHER_SAFE,
arm64_ftr_safe_value() returns max(ftr_new, safe_val). Since the
hardware value is higher, update_cpu_ftr_reg() overwrites sys_val with
the hardware value, resurrecting the hidden feature globally.

The features in this patch are FTR_LOWER_SAFE or FTR_EXACT (which
happen to sink to safe_val), which is why it's not a problem with
these current features.

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
