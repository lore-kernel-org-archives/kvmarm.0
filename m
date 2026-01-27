Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0841240611
	for <kvmarm@lists.linux.dev>; Tue, 27 Jan 2026 18:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769537216; cv=pass; b=gcNw3wkFd/dWNA2yPeyi7h16jkinGD6yspEcsej4CwJq+hgwAjklgCaZkahPpW59g8SO07/fH8P8HTSh+jiJxT/JplpLFsXoowArkVOysQDyFge8VmuDV9P3lxAgsX2KzKTNEIkRokLlESphWotyXVpBlwpfpvkEBfjIE59iHOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769537216; c=relaxed/simple;
	bh=FdDMKZN5A9ilbMPhYJZHvxzQCJptewoM58zrvbTDYAA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dFnon1qxqprX/bZJNvp75qgbNKDMiOhvvh1CfhFmaWsawub+KVPm7Y/VyqU8lgn1gLYCw9IGismkJwNvdLQAk/Wxkp0WIJ6EdAiPTK13TbVzgcuZsIk+X6sXATmGtjpu7iavGoQkjV962VAhMIloD+e5YUf1k9fdwcPt3ZgZJRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t2Wt+5qF; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t2Wt+5qF"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5014b5d8551so22891cf.0
        for <kvmarm@lists.linux.dev>; Tue, 27 Jan 2026 10:06:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769537214; cv=none;
        d=google.com; s=arc-20240605;
        b=kzVCYnOoE5aU4lgBARACm4Vy+fHTBdoJa1mJQwLLLgNMO+Ta0V8slqTA/hM7grWBh1
         d8iNJBpKeNO+mPS9fCH+xKQ7D+9djJlkCQ9ga/uitbYXpvgwUFGrHvZsq23KK+S464t5
         EDHIrFsUeRRsbot9mHs6QnfoBpmjUIqH7xCfpVmawEKEpMlpGQj2A8fEp1VM68wtPvy6
         250ECXN+JBcIFuI22HQ3Ta4lrB4oEurNiLHphsVttF/rHYY1qgiZ4hjeci7lkrE1cBBN
         PhgyfVPgQbYmjyG1585T37Mr2eJbkY9oidoqgDs7jMvR+v9BVSVOjOZeVtuEGofATeN4
         N6jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=fxlVnf19hj6wgXG/633VtKF1hJb/wU2Bd3Aj6hrMbwA=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=FxwAnqmTStGf2TBDqv3iMtLUA5LHlu/Uu2L6UxK9kKww1z/Yu/qhp/+XWjD7ZPNgRA
         T6XnK2wHP2N/W/urkx8w9At6qNpTYo7679+LpViSsWEjEwD1zmRJO0UFXIbap7Q+wrdM
         eyeRCLDVsQmjNE+byEQuvVdpLv0MrQbd/AVm/WczR7hi/ix0/8BDk4r+n8jcl9Cr0RzF
         XOFxhNrFnne5uzx5I00oUZYs7Rf+fnpn50B+Ufnq+4td2VVBqzUhvaVZjUNSX7JlVB+r
         pozBi7GWYvfRzCc9UyLAkVifv95SYm2WhIrspsNo+Ol90LJe81F3tHGHhIWdiTk3it3I
         01KA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769537214; x=1770142014; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fxlVnf19hj6wgXG/633VtKF1hJb/wU2Bd3Aj6hrMbwA=;
        b=t2Wt+5qFG5Y13/hrorZ9FpfOiuFukbgQVu+7V4LRKcUqVMNQU7DAdOY4WDnOQloS6j
         g4GVjkzG6PRcpzdse09F4SeyTrV5TpNKwt9273obf3VgQJLYtyH3PyjiZznklMMAwH6Q
         4BVcJIse6l7rfPhSZrbW6T7+13REOfcWVSuhIw8UA4vKidLQzr+M8Xr9xBTLGksxKCuX
         X60+gTUEYh8tYTACdpRyyIZXwtRchKeDw16vsBf7j7y9uG4r2bAv+OZH41QJKkh4qD28
         VtRrPDocszokIqzvzE8TqJQ68rQn4CotYtv3cAx3yhMxNy/dmjwwqP6/zjoVqFu6nf2o
         BLlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769537214; x=1770142014;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fxlVnf19hj6wgXG/633VtKF1hJb/wU2Bd3Aj6hrMbwA=;
        b=m2Oorfqd/LczkKiw50g1QgHlgtp+8XbCEvH0r3oIGDAC/dXG02vKpNalUhOD/eZs7s
         l7ydBDHP5Y5BdEJvlXou8thTvweKr0cZB3zvmr8kX6N60Jvi7s/cP+aHSTP+S042hqyd
         +yhpzj0lSYdFui+dCINT/rW0N6Adf1Zg6YGb+cBurlzIlD2NIf+CfN+zJsWTs7Zu3e+T
         ymB7g/pxMr2ce4kR4za7PFPxphOBMt7yWeRM4F/D345nvDydkcx42QtB2+cZ5z0z/w/+
         GP0pXDR+RkScuzuVa6G5zZohLNaJtpymv1PVHdB3k4YlcFZV9WGGANZtgCqSB0aMmeax
         K0Mg==
X-Gm-Message-State: AOJu0YyeO8dPbjr8SxN/FjRtVoIOgUdUSTHb7MW54TeGCr/PzIOBwd46
	eRBXH8qYYybj5SuULQwP0m8E6pCYhJaWlwwYS06EKncWD1dkEHHe/lpTh9z2fTBu1H5wKuhx888
	3ZYTWa8luzf3P4hRmpUC8hv20BL/0Jg0J7MGn6YFN6E/pvEukWhiHvCJf
X-Gm-Gg: AZuq6aIYo+NybfnR76I9wKuYiexN+wQS/RwKcvSgIyHZvl/pD+aTPaYQSjhmyff5oRh
	vvi79lDNPgtBrcXdLtmxge/SkeB5slPqwPmrfQVtRJuUbCEQX8/rLpmxn5X5Z9+kc0Xw9CYir/P
	yX+oQC5Mka9SMLiY/mM03/5LvxZ0dZVeCh6vQs7iOVd5UHj/btyTLQApjVlBM5wW0/X7aUP3fDp
	N2Ua6CfMraEBAjM8joq32bw2jSiBhDOJ+ejzD2p/CfD5MUsf5uUP+j/96c9yNrcAVUFiWiC
X-Received: by 2002:ac8:5702:0:b0:4ed:70d6:6618 with SMTP id
 d75a77b69052e-503340e2460mr5795521cf.10.1769537213238; Tue, 27 Jan 2026
 10:06:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-9-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-9-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 27 Jan 2026 18:06:16 +0000
X-Gm-Features: AZwV_QjgCatYzl0uSF32P0svXsC6cgFGj2o9l3SKTnzzzCjPpV9QVQWXrqlbFrM
Message-ID: <CA+EHjTzCpT4VYQkcmmn7AOAyROA9e=ohKfj53kSvf804DWWODg@mail.gmail.com>
Subject: Re: [PATCH 08/20] KVM: arm64: Correctly handle SCTLR_EL1 RES1 bits
 for unsupported features
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
> A bunch of SCTLR_EL1 bits must be set to RES1 when the controlling

nit: controlling

> feature is not present. Add the AS_RES1 qualifier where needed.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Otherwise, it matches the Arm Arm.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> ---
>  arch/arm64/kvm/config.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 6a4674fabf865..68ed5af2b4d53 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1085,27 +1085,28 @@ static const DECLARE_FEAT_MAP(tcr2_el2_desc, TCR2_EL2,
>                               tcr2_el2_feat_map, FEAT_TCR2);
>
>  static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
> -       NEEDS_FEAT(SCTLR_EL1_CP15BEN    |
> -                  SCTLR_EL1_ITD        |
> -                  SCTLR_EL1_SED,
> -                  FEAT_AA32EL0),
> +       NEEDS_FEAT(SCTLR_EL1_CP15BEN, FEAT_AA32EL0),
> +       NEEDS_FEAT_FLAG(SCTLR_EL1_ITD   |
> +                       SCTLR_EL1_SED,
> +                       AS_RES1, FEAT_AA32EL0),
>         NEEDS_FEAT(SCTLR_EL1_BT0        |
>                    SCTLR_EL1_BT1,
>                    FEAT_BTI),
>         NEEDS_FEAT(SCTLR_EL1_CMOW, FEAT_CMOW),
> -       NEEDS_FEAT(SCTLR_EL1_TSCXT, feat_csv2_2_csv2_1p2),
> -       NEEDS_FEAT(SCTLR_EL1_EIS        |
> -                  SCTLR_EL1_EOS,
> -                  FEAT_ExS),
> +       NEEDS_FEAT_FLAG(SCTLR_EL1_TSCXT,
> +                       AS_RES1, feat_csv2_2_csv2_1p2),
> +       NEEDS_FEAT_FLAG(SCTLR_EL1_EIS   |
> +                       SCTLR_EL1_EOS,
> +                       AS_RES1, FEAT_ExS),
>         NEEDS_FEAT(SCTLR_EL1_EnFPM, FEAT_FPMR),
>         NEEDS_FEAT(SCTLR_EL1_IESB, FEAT_IESB),
>         NEEDS_FEAT(SCTLR_EL1_EnALS, FEAT_LS64),
>         NEEDS_FEAT(SCTLR_EL1_EnAS0, FEAT_LS64_ACCDATA),
>         NEEDS_FEAT(SCTLR_EL1_EnASR, FEAT_LS64_V),
>         NEEDS_FEAT(SCTLR_EL1_nAA, FEAT_LSE2),
> -       NEEDS_FEAT(SCTLR_EL1_LSMAOE     |
> -                  SCTLR_EL1_nTLSMD,
> -                  FEAT_LSMAOC),
> +       NEEDS_FEAT_FLAG(SCTLR_EL1_LSMAOE        |
> +                       SCTLR_EL1_nTLSMD,
> +                       AS_RES1, FEAT_LSMAOC),
>         NEEDS_FEAT(SCTLR_EL1_EE, FEAT_MixedEnd),
>         NEEDS_FEAT(SCTLR_EL1_E0E, feat_mixedendel0),
>         NEEDS_FEAT(SCTLR_EL1_MSCEn, FEAT_MOPS),
> @@ -1121,7 +1122,8 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
>         NEEDS_FEAT(SCTLR_EL1_NMI        |
>                    SCTLR_EL1_SPINTMASK,
>                    FEAT_NMI),
> -       NEEDS_FEAT(SCTLR_EL1_SPAN, FEAT_PAN),
> +       NEEDS_FEAT_FLAG(SCTLR_EL1_SPAN,
> +                       AS_RES1, FEAT_PAN),
>         NEEDS_FEAT(SCTLR_EL1_EPAN, FEAT_PAN3),
>         NEEDS_FEAT(SCTLR_EL1_EnDA       |
>                    SCTLR_EL1_EnDB       |
> --
> 2.47.3
>
