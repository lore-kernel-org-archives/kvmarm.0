Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1292344DBB
	for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 15:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771601837; cv=pass; b=U6DHnz1uSfiEoJJJWYVT4oszEJY7gShhjuwX2Wa0mfmOjAs2ldzgBp6QhAcQmMHcacLsf5eiugbwMreS527G+HG4s4xYlqWydmus1lRz5mF6qi3djuTu1irJyNSOUitP6BDO8xL8XS1cPlYhyopxyePaHv/nIQOnpfHUTQsMBmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771601837; c=relaxed/simple;
	bh=olnVWDeY5rwJuxtxMXv+U2cF2QPXRXXzofR2+8hylsg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pf42aoz1auWatnwRgdOpTbZpGfPRNCTj9/GOHXPti1ffstQHI9qKtgnB5JOz/OkILoTPwFdn6sXtLYnd4U9S+YNRnkN/VwkeRFi23ZKvxNcW6Hg+icZGiNRDgEJDA7+N6jyqC3MUOcpUdyWstjh2iJwgB0xTVX+aieIsSNf58v0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oi+VR5J1; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oi+VR5J1"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5069a785ed2so499531cf.1
        for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 07:37:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771601835; cv=none;
        d=google.com; s=arc-20240605;
        b=QHBW3UKt2VmUik2m8uVRu5rsOYHX/DkTjy3sUMH+faZ3RjdO2Qr1x9mbW2roYoNDM8
         j0bpBAYXUn+g2/hs0z4au6XgtaMVG69L53O3ooPvlyrSGar4oOt4egDVQD4hls+CLG41
         ZsxcWoquJT5pcj/PUX4x6ofHUVocfSARLxeIfEPAyVKgDlGDFGmqepDk1kToaWRjMDIm
         n+LyoiGvnwWglUeYSvXCc4uLWn+eCj+uWfk7taex/rBLhY72Q8KKXbJ6AQq95eL/FDJm
         ZhDgFIzktKhpsdSrCZKQj0b6cErtM1gJ08uk+Ffw+jnZntnMshxJoRLqb+ifgOHtvKpf
         KQqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=J1/6eSd9O2TiB54fazCUnv3/4wHam8gBubDcUImrnEg=;
        fh=oLngtk94CJgema5y1CscEFZ6LE1kE4/kmfgtEoPXlm8=;
        b=gweIYkj2jnKexv0QphKPBJSJnPiKrSbo7krU4Bhld5X00E7uJvqNOZXQJqMtWgQsv5
         0svnQ4UY3G127Zf3/qIXDI/U+eHFdTAY3k3MaKYx9U/qlAfA+DZwJ3PZpDXjoYdniSBI
         ElOVJdUa5bqE4w8DkQGKn4BCk3HKAFhtM9QaT9QDRwxsV4LN6iHqeLLPA2FDcAl/8Sk0
         k0rPL7IJPpUsc8yDvv2qvKmMr8WxMbWsqgIDsyeeL54OJZCB/+FkhFRBGEajC0+IOg4y
         XfPmmLACjOgDOVxe3lEofCbpUDcR3aWBxwrz9POsTLqrdIkIb91Rcl/vvpccYQG6QF//
         Tytg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771601835; x=1772206635; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J1/6eSd9O2TiB54fazCUnv3/4wHam8gBubDcUImrnEg=;
        b=oi+VR5J1zGkq82GElhZMJes3vySN09bxVeN2FZNg8y2djXScY5qR+KIAsdeQJMGtxO
         23EgLlI3NqPOa4ZUZiJhUmpdNOeaS/k4tYrCRhkvpIaj4LLOSuyonbvovLJ0gZpADI1Y
         sib/5olcJ23ZnXyhBOW4XTfodVT1U6SID+mgGjpep9ZxS7WpdeyPofYqo92FL+FBvu2R
         GXvo8Q67d0E4P/2+ddKmgcBSutnQehs5Umd+U3IRPiOXeCOL24do5mdufWrnCnL8SixC
         sWqm1FXLO5BjuuiV/Z4UxvkMqJMIKuUjK3GiEB1sjQtcvPJTguzJXN681V2l3cgBvLp/
         nE8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771601835; x=1772206635;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J1/6eSd9O2TiB54fazCUnv3/4wHam8gBubDcUImrnEg=;
        b=jotgY1OII3U9CsyaYqY09jREwETfYOC98mYTPC4lIXi8MGqZtZmGgi/CyxpNMI7DO7
         TsPfC00iVvZ2ZneROV2VE8oKbEZFZdgB4M2SCnIiu5w5xQaM9CF61Hpcxdd8+ZCtw4LJ
         Q9rONYoJtraOna5qqgOsY0a91GukoY3anVuyHExmc+mT5npBibFd1MN6Ko2jqgVZKO1n
         1vAHOyLX2lBt3dgLUJ8IahlUunx2etoCCwYQMBIWN6VP0cXb1NWQi5gWnJTQJd4+5ZQT
         zA0RRAJxuhP7Swp0N77yfnIsxDmp4UJ75MDITrk5orAgMA4HClnoB8zrN/0HJIGKHsyO
         8WVg==
X-Forwarded-Encrypted: i=1; AJvYcCXBg53hj8KBhsdmCgxRGI4Qt8ZoMnso/0QZ7jo3sH5VnYOF4Rz7zrEkl/uqq8AtCzV7aIFDtI8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPRIEn13GWMSetLFa2mAW0F8qnYX2Sq1ocEXPZpFdrDyH6CTZ2
	O5HXZ2As+mpYfn3rbauF6Qjr0odnDpYA60NTFPuD38a7izRlCyGCqntZQuC6dgU0q7lgiSEQjFs
	TEqSe557MIm+eMZAV1s1K+HkMQ6mGK8rs0GNdkxWe6N0m1n6r8Ri06AvTp3g=
X-Gm-Gg: AZuq6aK8/MtFbkVkeNTJjJ/RDVlp5Cpz91MUiDPkYCjN04K8qiNi4OYyB1OUvd6GI0J
	LR3DNlAIKuWluHIvNxHnXF3GZJp1PdG3dYBkPooUlEuaE9iMIR15EeCvGAE+IRaz4TADE0dPFQw
	Ewb2/o2qGXltyxiELPUCdCSw1/U1N1kFotA8xvwwOG6VXzuz+ANiuYV66SKVb4bEOidIUhgU29z
	dfjHFxY5KMNCQCqSCDN5TeO9nRpdySDc4AQja3/rE9NHIcKh33Qob3ujPuivSslKN79AhEhjhik
	apvbKREZ
X-Received: by 2002:ac8:7dc9:0:b0:4ff:cb25:998b with SMTP id
 d75a77b69052e-506fb460d90mr12763151cf.12.1771601834241; Fri, 20 Feb 2026
 07:37:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260219195533.2455736-1-maz@kernel.org> <20260219195533.2455736-2-maz@kernel.org>
 <CA+EHjTzVRq3r-7UR-MJYvv-Aw4kHQDHEmwtqY9is-fRDm-J06A@mail.gmail.com>
 <86v7frafpx.wl-maz@kernel.org> <CA+EHjTzj9wEm7oBKBXF8sYpK60FYeLOJwEapxDiO1HxK5e6Y6g@mail.gmail.com>
 <86tsvba2nc.wl-maz@kernel.org>
In-Reply-To: <86tsvba2nc.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 20 Feb 2026 15:36:37 +0000
X-Gm-Features: AaiRm51t-AEADLr9nyHpAp9_H4zOdIaeHbP0gvJbqYqGMNKiq_N-HiLcrQzzmes
Message-ID: <CA+EHjTyiHALTEgA7tuqQZ2ZLW3_vFdTU=vUb7+vn1T4OoMjgsw@mail.gmail.com>
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

On Fri, 20 Feb 2026 at 14:52, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 20 Feb 2026 11:06:03 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > > > > +               switch (ftrp->visibility) {
> > > > > +               case FTR_VISIBLE:
> > > > > +                       val = arm64_ftr_set_value(ftrp, val, ftr_new);
> > > > >                         user_mask |= ftr_mask;
> > > > > -               else
> > > > > +                       break;
> > > > > +               case FTR_ALL_HIDDEN:
> > > > > +                       val = arm64_ftr_set_value(ftrp, val, ftrp->safe_val);
> > > > > +                       reg->user_val = arm64_ftr_set_value(ftrp,
> > > > > +                                                           reg->user_val,
> > > > > +                                                           ftrp->safe_val);
> > > >
> > > > Should we also take the safe value in update_cpu_ftr_reg() for FTR_ALL_HIDDEN?
> > >
> > > I would expect arm64_ftr_safe_value() to do the right thing at that
> > > stage, given that we have primed the boot CPU with the safe value, and
> > > that we rely on that bootstrap to make the registers converge towards
> > > something safe. This is also what happens for the command-line override.
> > >
> > > Or have you spotted a case where this go wrong?
> >
> > I think so... What if a future FTR_ALL_HIDDEN feature is defined as
> > FTR_HIGHER_SAFE? Wouldn't that cause problems on secondary CPUs?
> > init_cpu_ftr_reg() primes sys_val with safe_val on the boot CPU,
> > update_cpu_ftr_reg() on secondary CPUs compares the hardware value
> > (ftr_new) against safe_val (ftr_cur). For FTR_HIGHER_SAFE,
> > arm64_ftr_safe_value() returns max(ftr_new, safe_val). Since the
> > hardware value is higher, update_cpu_ftr_reg() overwrites sys_val with
> > the hardware value, resurrecting the hidden feature globally.
>
> Huh, that's an interesting observation.
>
> SpecSEI is the only case we currently deal with that is
> HIGHER_SAFE. But look at what this feature describes: bloody
> speculative SErrors! Not taking this into account could be really
> deadly, and the kernel really ought to know about it.

I didn't think that much about it, but I guess features designated as
FTR_HIGHER_SAFE (like SpecSEI) usually represent hardware errata or
critical mitigations. So we should not be hiding them at all.

> >
> > The features in this patch are FTR_LOWER_SAFE or FTR_EXACT (which
> > happen to sink to safe_val), which is why it's not a problem with
> > these current features.
>
> My conclusion is that it is simply not safe to make such feature
> conditional in any way. Note that's also the case of for an override:
> look at how we will refuse to downgrade a value in init_cpu_ftr_reg():
>
>                 if ((ftr_mask & reg->override->mask) == ftr_mask) {
>                         s64 tmp = arm64_ftr_safe_value(ftrp, ftr_ovr, ftr_new);
>                         char *str = NULL;
>
>                         if (ftr_ovr != tmp) {
>                                 /* Unsafe, remove the override */
>                                 reg->override->mask &= ~ftr_mask;
>                                 reg->override->val &= ~ftr_mask;
>                                 tmp = ftr_ovr;
>                                 str = "ignoring override";
>                 [...]
>
> I think we must prevent this downgrade the same way, meaning that
> ALL_HIDDEN and FTR_HIGHER are mutually exclusive.
>
> How about that:
>
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index d58931e63a0b6..2cae00b4b0c5f 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1067,7 +1067,14 @@ static void init_cpu_ftr_reg(u32 sys_reg, u64 new)
>                         user_mask |= ftr_mask;
>                         break;
>                 case FTR_ALL_HIDDEN:
> -                       val = arm64_ftr_set_value(ftrp, val, ftrp->safe_val);
> +                       /*
> +                        * ALL_HIDDEN and HIGHER_SAFE are incompatible.
> +                        * Only hide from userspace, and log the oddity.
> +                        */
> +                       if (WARN_ON(ftrp->type == FTR_HIGHER_SAFE))
> +                               val = arm64_ftr_set_value(ftrp, val, ftr_new);
> +                       else
> +                               val = arm64_ftr_set_value(ftrp, val, ftrp->safe_val);
>                         reg->user_val = arm64_ftr_set_value(ftrp,
>                                                             reg->user_val,
>                                                             ftrp->safe_val);
>

Yes, I think WARN_ON() here is the right call.

That said, I still think you should explicitly short-circuit
update_cpu_ftr_reg() for FTR_ALL_HIDDEN features, in addition to the
WARN_ON(). Relying on arm64_ftr_safe_value() to naturally preserve the
safe_val during secondary CPU boot seems mathematically fragile.

Take MTE_frac as an example. It uses S_ARM64_FTR_BITS and
FTR_LOWER_SAFE with a safe_val of 0. If it were marked FTR_ALL_HIDDEN,
init_cpu_ftr_reg() would prime sys_val with 0. But if a secondary CPU
boots and reports -1 (NI), arm64_ftr_safe_value() will execute min(-1,
0) and return -1. update_cpu_ftr_reg() will then overwrite the primed
safe_val (0) with -1. The "hidden" state established by the boot CPU
is gone, and the feature's hardware state is now exposed globally.

Note that MTE is currently ALL_HIDDEN when configured out, so it's not
totally inconceivable that someone decides to make MTE_frac ALL_HIDDEN
as well. Explicitly short-circuiting for FTR_ALL_HIDDEN features in
update_cpu_ftr_reg() seems to be the safer bet here.

Cheers,
/fuad

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
