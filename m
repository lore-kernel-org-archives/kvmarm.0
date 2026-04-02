Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94213371CF5
	for <kvmarm@lists.linux.dev>; Thu,  2 Apr 2026 18:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775155587; cv=pass; b=E88pHK0mXohfZXloWMvz7mOFpqLluIxdS4ONVM3l3VkmTSxZepJ4tQkbUSwvzGDSWlLmE6mn4rjd9aJlTMM79nBKaq7ObS3y5yr7AQnQWBt8KtX7+hKtq/Xx4DuRp3S/W2v2KCXkQ9TD+WMSSPvFJ/PcarKAZg8HWP/3xaeKmVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775155587; c=relaxed/simple;
	bh=is9kVVlCANLLA3pZyMy3PBKMbjtjB1RxABSh93m3hjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b5t6dreBTtSzD7fbYBHwX0naPiqf5RoO4yopQa71qdwacNDB/hidkMdsxEd21hzLd/KC6Lb1P5FbvkGL+HfNo9nbdtN8DvX/XT8evDcwtT9zo+wUFqZCuhNO+VfBjCmqIDJ9nZjaPyjnFFSIgqoPAb846f91tES3RvLScHimIAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aiyuolIa; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aiyuolIa"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5091ed02c54so57041cf.1
        for <kvmarm@lists.linux.dev>; Thu, 02 Apr 2026 11:46:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775155584; cv=none;
        d=google.com; s=arc-20240605;
        b=GVaIuozpVT56ngvmVIKDppsIVVD7VvgReceF29TW8kL+w3GQ3HzNLGJiDc0i+2FMCz
         PegryD0jIHjNg8zCO45lxD/c48WAyeIJNMStD4XvOldOJxYrYrum1m9u/5ilbKsRKEaU
         aOIeGje3x1WLpyeH0Wrz6ZtAU5sXLH7PThdVnBemKBXnjFYgT2inbDwy406u7id9T1at
         JdxPjLbybC+YuyPEQlx1r4IhfE0+IhH4RS5OO35tATNuJ+SocO8Vd1hxzf0lKGHizjaG
         UaDK/PCBd0w8B/3i0VSb8VBZnYJGTW0bcDep4tPUTud43tIRUHK5wz6H6afmgez9nIoD
         tguQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Wl4zvQGiUZSrx3wg3ehuntk10fOXbNpq860F8ZeG11M=;
        fh=hGOkORdbQ7vLKIlBFb44l/ky7FO/szQuMX/ThQNleaM=;
        b=X9clVSeqvJikSbatcqG9icftGwN6xEdVjWD8KLj4AMh4CBqe9B9fmWjD8egpeyeV1c
         czJzheAP4xsnDb02439Rf5aq72LZnLOVOtrbDudVqWvJZxev0+oPru+NsBIQJJNxGtc4
         IMCHqQ/pGh/LOuznyqiD+U9SeckhkpXWN9t7qG4EsFtyZzY5eDoArB+zdA0hpmvruzl8
         0814FPXwdLWPXj9oes+kdK5WcDyzRyvlWlITq7GghlVSkkAuNARM8OAduTLwPoT5GlWb
         BfXvVbAvYZ3TaG84LQpfUOeUrs6tz40KybHZA5yXCat8rpY5IIfvGT5hoijamaAIOHK8
         xc+Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775155584; x=1775760384; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wl4zvQGiUZSrx3wg3ehuntk10fOXbNpq860F8ZeG11M=;
        b=aiyuolIadrSLr3HpR5RHJ2OrvVUwZJnS1cUEFPl8D8/JgiEmUMXgRUQr3xH30pmT9a
         tfrlkfuLGdN9gENSezhqd+yiPJjbnIraIIxDw+AQjNKqtBcuVUvsM0mg3qycTiiV9fiG
         197EdRk7K9i8Xs550yBDNJHTHPClbQFPzCwvjTRpvHRnLvEL5lNcWjP1mQNbJxu0Wzbn
         lGdgNdLJxNSe0zkxkOSkiGcldS4oHm5/gYPkIF+kPJkEL97nNioqoP2lFOWThpBNFiG/
         W/dFj20F86FGwCLs4btXcwCzBGE/koMDziBbd8VL2KJ/zDD96jS+sIehODfMujB1d54t
         oRUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775155584; x=1775760384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wl4zvQGiUZSrx3wg3ehuntk10fOXbNpq860F8ZeG11M=;
        b=nupUNhA7GG0QyXaAcnyjt+6rEFUhwppNDpsKkgwLM7eybsXazixPzr2/ACC4DHBvK0
         i4Ff4r8+aDh9EGBCIUxG1haUToCbtR+Ix9ujF9CRkRLMI96IB2qtqMDlIu4ML+oCeF8e
         EHUjLEwsXivuvQ+TZZgwhlro52RzH6Aumxo3l1GD34unZ9LCELAURaK3cAEe0QK1He1f
         nZSqR6+ckY+5bcibojRy3hmxz1DrtBac2Q36E4rsRf45G8L9tD/pUvPerCoNGULYldmf
         hBDtYqfWzkAscOCqGQo8jZSSYHUhIKnYMCPvoDJHUIYDrx5lDuURl/ogRy5Vh1GbgoXI
         FX+A==
X-Forwarded-Encrypted: i=1; AJvYcCUlZp41YcogKsd7Oe6/KfsFkS65HHC1ennEsSgWq8FFqolAn53sfe0HMSZgTzpQ5L2YxA94yO0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQgzWyt2x5vaofru7DNccZXZthT5+y60OqvdM8my+46/lGj8+C
	DEVZPyiReOTPx8mGpFdmx5P9VzN+g7I9SBDrdBzstP2GEFfUFdE4ARypUEivCiNWZo45NSRLV3P
	yse5txcZyj1z163vpXUIvRAqozvSVmFvvFoDCjL8w
X-Gm-Gg: ATEYQzxP7a8vt1OZuGFQTRxtKHcPGz8HF9AaMtTMDJHaqlP1MZU3YiRdweXNPfUJMM/
	JVAYzZQ7zuPPU36kK1f4/FLfDx1NB1CDa1sYwKhIlC0JjhTerEXStZtoNXIAisi5+Rfcd7+/weD
	AwD+lNO1887DkTddZ6Ci3gnYGT2QI4NxJ/LhkSb7HcBVTwVWYNWZ0jQcTVroe63MIPf447bIBpF
	GGaemulRpBY6tjfMBINkEBF73L7hnzx0DJmao7zoKdnnOyTv1I/0HA93TOoxMWSJTsIjpmE4UvJ
	fxc7
X-Received: by 2002:ac8:574f:0:b0:50b:bddf:14ee with SMTP id
 d75a77b69052e-50d5091f06emr14241431cf.16.1775155583876; Thu, 02 Apr 2026
 11:46:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260401123201.389906-1-sebastianene@google.com>
 <86341e4to0.wl-maz@kernel.org> <ac1UNj7Z1uVL4Nf6@google.com>
 <877bqqcz77.wl-maz@kernel.org> <875x6acyxc.wl-maz@kernel.org>
In-Reply-To: <875x6acyxc.wl-maz@kernel.org>
From: Sebastian Ene <sebastianene@google.com>
Date: Thu, 2 Apr 2026 19:46:12 +0100
X-Gm-Features: AQROBzBvFMvjURX0njbORtUtQfmHm_Ot_YasD3t7UZkZN1aUMR2GZbjvwVe8y2o
Message-ID: <CAHLR_pZ55+4cAknuuP4a1PzQjgvyegeXvpZksz=8+iy=CaSY4w@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Pass a 64bit function-id in the SMC handlers
To: Marc Zyngier <maz@kernel.org>
Cc: catalin.marinas@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, joey.gouly@arm.com, korneld@google.com, 
	mrigendra.chaubey@gmail.com, oupton@kernel.org, perlarsen@google.com, 
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 1, 2026 at 7:34=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 01 Apr 2026 19:28:28 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Wed, 01 Apr 2026 18:21:58 +0100,
> > Sebastian Ene <sebastianene@google.com> wrote:
> > >
> > > On Wed, Apr 01, 2026 at 03:55:11PM +0100, Marc Zyngier wrote:
> > > > On Wed, 01 Apr 2026 13:32:01 +0100,
> > > > Sebastian Ene <sebastianene@google.com> wrote:
> > > > >
> > > > > Make the SMC handlers accept a 64bit value for the function-id to=
 keep
> > > > > it uniform with the rest of the code and prevent a u64 -> u32 -> =
u64
> > > > > conversion as it currently happens when we handle PSCI.
> > > >
> > > > That seems overly creative. The spec says (2.5, from ARM DEN 0028 1=
.6
> > > > G):
> > >
> > > I'm not plannig to be *overly creative*. Thanks for pointing out the =
ARM
> > > spec.
> > >
> > > >
> > > > "The Function Identifier is passed on W0 on every SMC and HVC
> > > > call. Its 32-bit integer value indicates which function is being
> > > > requested by the caller. It is always passed as the first argument =
to
> > > > every SMC or HVC call in R0 or W0."
> > > >
> > > > which indicates that it is *always* a 32bit value.
> > > >
> > > > So if you have a 64bit value somewhere, *that* should be fixed, not
> > > > propagated arbitrarily.
> > >
> > > If you have a non SMCCC call that happen to have the first 32-bits of
> > > the function-id matching either PSCI or FF-A you will end up handling
> > > them instead of forwarding it to Trustzone because func_id is declare=
d as:
> > >
> > > DECLARE_REG(u64, func_id, host_ctxt, 0);
> >
> > Again, the correct approach to prevent the propagation of something
> > that is known to be wrong. Something like this:
> >

Hello Marc,

> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 007fc993f2319..dae993a1d081b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -694,6 +694,11 @@ static void handle_host_smc(struct kvm_cpu_context=
 *host_ctxt)
> >       DECLARE_REG(u64, func_id, host_ctxt, 0);
> >       bool handled;
> >
> > +     if (upper_32_bits(func_id)) {
> > +             cpu_reg(host_ctxt, 0) =3D SMCCC_RET_NOT_SUPPORTED;
> > +             kvm_skip_host_instr();
>
> Plus the obviously missing:
>
> +               return;
>

Thanks for the suggestion, I will do this and spin a new version.
Sebastian

> > +     }
> > +
>
>         M.
>
> --
> Jazz isn't dead. It just smells funny.
