Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FD029C33E
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 15:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749742760; cv=none; b=outXwcJmY1c/jSGxbr0/SDhmTt+bXsmfdssb94PPYkjnOIY1k7CA27o95D0FUadIbP0A8Dm62zFyZwwBxx+qP5MfXLuU722OS5uiO6YkLxeaMDPd+NGghNAkx0fvKsZ2IJS94uIj0WxDsavqZ1YZCrWYRrdqMlRdLUodaJltuIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749742760; c=relaxed/simple;
	bh=rCixxRG8XEbplAB3xHRDv0Dp2IIYCT861jPSCMat2qw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lmjWxXzVeHEDMYuHKE0v8CS8P2gER2A4N6LpfpLChbsMYPzIEHbPZsPz/6Lch50C8OD5vFrKWtRSWblsHU1MWZEoOLDN3rdsFsWdsA3VdQ+KwKVgGd060LkXCeeY39+x1UrbaY7u6A5ZSapBSV6953JRGBxDf+i3z6Msxu1mKB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Uj9GzWw5; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Uj9GzWw5"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-70e1d8c2dc2so9894927b3.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 08:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749742757; x=1750347557; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JXT9+xCu2kLTPNMjKZBijcIVT4PBIX3CMqzxcmCHJhc=;
        b=Uj9GzWw5XbOUZaLD42XlmeJ5VRRAb2tfxGn4/Y+8fnJUqADQbhuOnsvmB5P4xchsDF
         SUMT6dG3xXt557MRAzDvDwJ9RrblSlQ7w+CSgXX7qZUIFxmgB5ZOviuhyUd1oRHDFRQ6
         ZvdzG0ihZ6QLg+oCedSnHiLW4gBsdJv3ea57BlRHL0fss8VV9XtWGebznI8LnBEy++pI
         JcN1dfiB7sKTvrWc45qTDQH2j3xFDH64umBLbqwIXYtVHapF2D/IAQP+BS05g8zWnU6p
         01TEaKap4mWbtS3DfCZm6pMlHUiWlmMEzCJgBdRseYQUX5bGcLsNRIA/gBdg2D892XeC
         gvDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749742757; x=1750347557;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JXT9+xCu2kLTPNMjKZBijcIVT4PBIX3CMqzxcmCHJhc=;
        b=LKRMyLpa+Jpq7DdnnI0jeBc5fWHSbtENIQzsUP7nvgRYuONDSR4oYooQOE0qB9v6GW
         OR7guWT4Ps+iR2RHZKSBTRLdhNGnsyq/sszdjvHFwvBpcYThUlyqVAK93rES2fGGRUIt
         6JM0JoZixjh0RVByQ/V/z125XPEh8pFVNOze4TkPAcrrnRs+CvhIJoGF1LUDf+Dgrb4c
         z3DKXBo6AkP49yBM7HuMRoMbv10x2AZq+jcD+6TJLUDT/3k/LrSfv2oGfxsRcEX+gZd7
         e/+2gLnynMGnK07LDoGmOS25UPRul4aWjE4S5TGpSWVCV9fo77CAVyC2qGNvQeB+Tix9
         sL3w==
X-Forwarded-Encrypted: i=1; AJvYcCXdCV4DSkQqxA+fHLZMR9j9qMLEM7e3NOpcDtegx49Jr9KW3pfssVfTLSWfTcu6Qp8TR9daKgE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyGXJh0YDJgdQQW4rWaa5KetaGj3Rzez+DC/kxk8ys4NYVIYGVS
	Ia1avL4gdvwe2UNeQdCwSvIFWdkffrSzn3z1gK535Vb+rqQXs/BjUOegUpRTKXEKp4mXfpfZuTV
	3Oz7IeHi4v7tnRG/j61Sui+22/hyqCQVV5fZfCc6Pcw==
X-Gm-Gg: ASbGncumoVl5fDutKtL0yEh5Yxca/aJcNDwKWvnPv/MLf0ABfGq4ZAHQeXZewo8u6oE
	7R3gOsIxH2cxbcQ78v31muOYpj3+unUdAH8yDOB/WfnD0pidYSoUn6DxXexpcpxwDiUdWaXQJ7f
	ttTm3EtYzlvYSQbfEfL8ffXfNwXfrz3lSOZsquTi7gZde5
X-Google-Smtp-Source: AGHT+IHlkIH86GpFkBYLnTKRfBrIjt+QS7YNu/3E5ZRMJuF1GJLPYhHPNq89j0URmxtX1O2VULTTrxcSXSpqiX18NXM=
X-Received: by 2002:a05:690c:907:b0:70e:143:b827 with SMTP id
 00721157ae682-71161e26ee3mr5727027b3.8.1749742757338; Thu, 12 Jun 2025
 08:39:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250515153907.151174-1-cohuck@redhat.com> <20250515153907.151174-9-cohuck@redhat.com>
 <CAFEAcA-c=EaE-Y4DMVz_meVd2cbxuCyFGFOXET-COOgMWHXWWA@mail.gmail.com> <87a56d9dlb.fsf@redhat.com>
In-Reply-To: <87a56d9dlb.fsf@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 12 Jun 2025 16:39:04 +0100
X-Gm-Features: AX0GCFuzI2YyCIMD8vpl4ErMfb7p-rmxq7r54GM8puuwIMjmPs8pzpmH3mOQeEs
Message-ID: <CAFEAcA-rYNaaZ3LFFkhek0duptPeMXUBbPbBnWa7teNPM+c6ug@mail.gmail.com>
Subject: Re: [PATCH v7 08/14] arm/cpu: Store id_isar0-7 into the idregs array
To: Cornelia Huck <cohuck@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org, 
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org, 
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev, 
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com, 
	berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com, 
	agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Jun 2025 at 16:36, Cornelia Huck <cohuck@redhat.com> wrote:
>
> On Thu, Jun 12 2025, Peter Maydell <peter.maydell@linaro.org> wrote:
>
> > On Thu, 15 May 2025 at 16:40, Cornelia Huck <cohuck@redhat.com> wrote:
> >>
> >> From: Eric Auger <eric.auger@redhat.com>
> >>
> >> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> >> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> >> ---
> >>  hw/intc/armv7m_nvic.c     |  12 ++--
> >>  target/arm/cpu-features.h |  36 +++++-----
> >>  target/arm/cpu.c          |  24 +++----
> >>  target/arm/cpu.h          |   7 --
> >>  target/arm/cpu64.c        |  28 ++++----
> >>  target/arm/helper.c       |  14 ++--
> >>  target/arm/kvm.c          |  21 ++----
> >>  target/arm/tcg/cpu-v7m.c  |  90 +++++++++++++-----------
> >>  target/arm/tcg/cpu32.c    | 144 +++++++++++++++++++++-----------------
> >>  target/arm/tcg/cpu64.c    | 108 ++++++++++++++--------------
> >>  10 files changed, 243 insertions(+), 241 deletions(-)
> >
> > This doesn't compile:
> >
> > ../../target/arm/tcg/cpu-v7m.c:70:5: error: incompatible pointer types
> > initializing 'ARMISARe
> > gisters *' (aka 'struct ARMISARegisters *') with an expression of type
> > 'uint64_t *' (aka 'unsigned long *')
> > [-Werror,-Wincompatible-pointer-types]
> >    70 |     SET_IDREG(idregs, ID_ISAR0, 0x01141110);
> >       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > ../../target/arm/cpu.h:875:26: note: expanded from macro 'SET_IDREG'
> >   875 |         ARMISARegisters *i_ = (ISAR);
> >          \
> >       |                          ^    ~~~~~~
> > ../../target/arm/tcg/cpu-v7m.c:71:5: error: incompatible pointer types
> > initializing 'ARMISARegisters *' (aka 'struct ARMISARegisters *') with
> > an expression of type 'uint64_t *' (aka 'unsigned long *')
> > [-Werror,-Wincompatible-pointer-types]
> >    71 |     SET_IDREG(idregs, ID_ISAR1, 0x02111000);
> >       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > ../../target/arm/cpu.h:875:26: note: expanded from macro 'SET_IDREG'
> >   875 |         ARMISARegisters *i_ = (ISAR);
> >          \
> >       |                          ^    ~~~~~~
> >
> > (and more similar errors until the compiler gives up).
>
> What configs/compiler are you using? I obviously would have fixed that
> if I had hit it...

This is clang 18.1.3 (1ubuntu1) on x86-64 Linux, configured with

'../../configure' '--cc=clang' '--cxx=clang++' '--enable-ubsan'
'--target-list=arm-softmmu,arm-linux-user,aarch64-softmmu,aarch64-linux-user'

Whatever the problem is, it goes away on a later patch, so probably
it's just that some fragment in a later patch needs to move into
this one.

thanks
-- PMM
