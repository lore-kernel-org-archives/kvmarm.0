Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3B23E5567
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 13:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772457299; cv=pass; b=prNIcJQsQuR+AKx4f/3amAuhltGW9u9VQzePzb+OpLu5H0txpzGPmdH+pJa/Qc8D6PPC9ZUpYb2ioQYB9jECPWw1/brDsIPiUX3vmkn2rT1HtMXl2c5NLXpB2wmFqq1txXx7VHQeYBQ0s6wwOFSvc4QnaBkFOKvzerp0y0xIGrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772457299; c=relaxed/simple;
	bh=jvMEXUHJ79MPhFgZ2wHofIu2DqgMdWUOQB/Nicw5AIg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qj2VQNu03TURnEJNrT1r7gCRgPpdt0aCNI72+aZPWB7y/se45DFRWTkfrW3H3dseognzNDMdXvq2lwUqdjgWM011tyMDp7FWsO6mDHFejjdyfac5Up7VjKJxOV1eEWHYhjhU4mmvcvr7S73F4hyEYYofeZ8pQoZqEYG1IQ+17YE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pK2ola4R; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pK2ola4R"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-506a355aedfso1018511cf.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Mar 2026 05:14:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772457293; cv=none;
        d=google.com; s=arc-20240605;
        b=OAwS0t923b+12mD5Plrd8Xzhr1lPNgOcPN09a7uy9xcWXg2t6WNJtNmbmHdswLUe2G
         WlCT9m0cWaWwMHIH0eUSYylKHQVGfmrpgVSjRuWzuJ+r/5LpItZpOkZCrSYE1h2Riqwk
         h5xw6c9r7dfrKO5ozSUBsJm1u9+7UHZvtJRWXuxafeBxdMW0sY+juG9xfMl/mboW66Lh
         ZK5kdB6xcDuMVUslrZ9nM3m2frzWHcTKDnfp1FMrftFdShTE957Z1XFeCcMWmIIrbn+6
         MibN+PDXOkjni28JzuT6MP9aCQN0+nLBaJRZvVz09mu13ozLXEpsUgvVE8mGvkD0zR86
         e1/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=BdCPnffZML7kxbwJKrhPE0nWT3T0abqC8IY8tAq2JzI=;
        fh=yWOT2/cGJ6pTjugiyon+9Xgyd5DE0gP4QRjQiryLkf0=;
        b=jammZHZpuFF/sOPF4zU3QlTocASryBV6j3V6e+73xHcDs5O2MpKBiaYIg9DuFdI9lx
         XIaiirGabeOugji3SZBFpWkI522qieyg9d1IJBSsuZRPX8z2eA5/CEremSP7P3/cu21f
         K0Sy2JhgHHOvEvTnE3qsE8U1bjQDp+7BljN5egZozxF5QwAkknoCvfnSPfV+rQJNnLZz
         C2isi8ZiU4DT5WbM3sDInxk6iQSkKzcy2Rkj/wf4vsKyGMtwf163QTc/YL8GpiGbNofv
         cBfB45UDukFM9ZNSOIFnB5cfKlLwYnKQkHhiCI7LzyqlL2nfUyLx2T60OnVmTzrfKF3z
         vRHg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772457293; x=1773062093; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BdCPnffZML7kxbwJKrhPE0nWT3T0abqC8IY8tAq2JzI=;
        b=pK2ola4R6feojKRp/6b9qetyKmEs/RbjLaTffgsqNW4pER8075pYCry651R38J8TcI
         LuUhVE4Fo8W3V+pI4FpGh/c15H5LQore7sPIscQyBiiEfBxVtketAW6SoWuDJAeRJkn6
         1LjJVRo+JnGf9K7G2tHFP1Yp0kKTOJ4hVhUnT3HUc4beBAuHSA3kqNfiEl685A8fNwTu
         tyjlyBm9chHQVL9Gg6WZorNGSaKEcG1tn43lazYpZESw3DRP17qrBrocgnjtvVrRtQqf
         Fm1YQVbOzE2TwhTjApfkGhzxRYj17krQYTXnd2PM6/GH2q4A6MHd2eGPGXsUWwFmFPrX
         kR8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772457293; x=1773062093;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BdCPnffZML7kxbwJKrhPE0nWT3T0abqC8IY8tAq2JzI=;
        b=GU6An7bgXA8nflv7lkFKFflN9/fauP7VnUxPn3X0wiofSSKYkfQxxK5L/RxgimZ2Yv
         4R5wHBPxcdfeJicW2umscjnK/zNNy/O7wd21oA+hY0nU7NBfx2Bao3ujapi0nIA+HeJ1
         hj5U6Fi0nlHIT0Zgdp25WwtB7pDsX1vXtgPz6P/pl0RqMccPimavQpEF9kMKKLO/VeTH
         1xwbgdvro3FKhhiSQSb+OLIWw2vmpI3POFsljogoiTbq1hN1CrQDL3JGy0ENnZGi1pRF
         jnppcryvjOhPeePYQ14CH2Es5VyGM5qB/o3yr/C+Q/PPQBnRYLC2SWwRjCr3wtVzwLQP
         X4ag==
X-Forwarded-Encrypted: i=1; AJvYcCWtLgXDhBLMLadselkevSvrtGB8kE2Q1vNtH6AoluWT1pwKg1NlvZb8ZPi3nWyp2vf14de+6xM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxLz4+vKNH6BdBtrMZxhiR2giqg/YoSrW1+qR2PZdrjAhyIfKOS
	kS6eAGcjXB2NnXJH1QEmXakumuUhjg7DcVInEqpEPy1f2fYTZBrQXOTZPmq1NLS3+RVDFXn27TN
	D+EqENOQIdfiTc78qXokSdL1YiQ9+fuM/wuK55wPY
X-Gm-Gg: ATEYQzzjUiYnBnbAMbtgEKapLyCTQCwNgYm+PSPEk+XJKl/3ADwri6TWfL0Dpc1rK7m
	Hg9ybqU3kNu5r0ccuPdarACE+OtDXhd63ZhG6miZyrzUiWgZGsKDlB1YkWy0a+Finf9PNrDq8wp
	4mRnB6Ft/tJzUkbjMgbhdxlisizs4fFLC8+r/aEfsRtFPpn8UErHSdQqMfkExNPmf6LY2OkjNjH
	bnGo8kbk8anvkE54h38NGQMM+XFJTSrXnb486SokIcwzLe4v1f1JQqqIU3RtAaEEhH61LtyU98I
	eA+oXd4E
X-Received: by 2002:ac8:7d06:0:b0:503:2e98:7842 with SMTP id
 d75a77b69052e-5075fd22f86mr20835191cf.4.1772457292926; Mon, 02 Mar 2026
 05:14:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260302115653.1517326-1-maz@kernel.org> <20260302115653.1517326-2-maz@kernel.org>
 <CA+EHjTwYhdjfmZxyW4yjfOaokNdVGkHB1h6Qb9O-4D_3f1a-Jw@mail.gmail.com>
In-Reply-To: <CA+EHjTwYhdjfmZxyW4yjfOaokNdVGkHB1h6Qb9O-4D_3f1a-Jw@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Mar 2026 13:14:15 +0000
X-Gm-Features: AaiRm52zbAJaUiKA2h0ehijliBClOvA-7sxDw9s8hswO4KclN4NGMGHaGZeuTPY
Message-ID: <CA+EHjTw+zpNyAnsJsxFYxH5RiH2f_jNR0E_Zz5hnegzfy9Mh-g@mail.gmail.com>
Subject: Re: [PATCH v2 01/11] arm64: Skip update of an idreg field affected by
 an override
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 2 Mar 2026 at 13:05, Fuad Tabba <tabba@google.com> wrote:
>
> Hi Marc,
>
> On Mon, 2 Mar 2026 at 11:57, Marc Zyngier <maz@kernel.org> wrote:
> >
> > When computing the new value od an idreg that contains a field
>
> nit: od->of
>
> > affected by an override, do not update that particular field.
> >
> > The value computed at init-time must be kept as-is, as that's
> > what the user has asked for, for better or worse.
> >
> > Signed-off-by: Marc Zyngier <maz@kernel.org>

Another nit, should you add a fixes tag, since this flaw is tired to
the original override facility? i.e.,
8f266a5d878a ("arm64: cpufeature: Add global feature override facility").

> Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

> Cheers,
> /fuad
>
>
> > ---
> >  arch/arm64/kernel/cpufeature.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > index c31f8e17732a3..28fc77443ccd3 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -1224,6 +1224,13 @@ static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
> >                 s64 ftr_cur = arm64_ftr_value(ftrp, reg->sys_val);
> >                 s64 ftr_new = arm64_ftr_value(ftrp, new);
> >
> > +               /*
> > +                * Don't alter the initial value that has been forced
> > +                * by an override.
> > +                */
> > +               if ((reg->override->mask & arm64_ftr_mask(ftrp)) == arm64_ftr_mask(ftrp))
> > +                       continue;
> > +
> >                 if (ftr_cur == ftr_new)
> >                         continue;
> >                 /* Find a safe value */
> > --
> > 2.47.3
> >
