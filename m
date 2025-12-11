Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41753128AC
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 13:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765460320; cv=pass; b=ZD6AgaEDKBoMY4C3v7C33Ccj2sqQFdHv0zpV/EnOvmf3/j9y2Xnw/k1Yo1fMqrgP8slZiBH8SoHpXbI6YZPtXP5vpNoiSnF9txEWt0EUndPPw6ZXorI1/txqzRd/wzM05v3ETwXqiKN4oPJEmrgrlG4URkZxLbLibjsKWgzNABE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765460320; c=relaxed/simple;
	bh=ZULG/eXPL1bxQuNNmFxDZle54SOquDAYpzZEieN3rko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kCRG2Ek3D/nj5vMkHEiy21RO8JlMHlMcXzPn5WuP0IhEsloCtwRAKVlGzEaVE8QLjT0Vfa2SX2oyLrBswZ3Sr+WptWqEU10xOx0/vsgMjn8GEzFkVxbx12+xwJ6Oo2Z5tOFhG4IgzE3aGV7jeNiVyCxB7fw/CtJlKqdfbfs5t8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DDMo/HzJ; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DDMo/HzJ"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ee147baf7bso408591cf.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 05:38:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765460318; cv=none;
        d=google.com; s=arc-20240605;
        b=XdrtUtxyUwRca4UGGpuMZLdTmEROXt7Eh8wlP4k/ar9Gu2pJBayoTeDnEeABfPCv6X
         Wn+3D5BaUq+Uq7qFM+DdDjuENPAXzSKWUmXH87+h0Z+M2DbIzD/fWd5bLHDFf95z/7gJ
         ARs+y+8sD7gVF04+Ac6uIrcnuOVMmPJmr45Yt61sDxv2NdZqk+5VUiriL2k3yJqgBTvF
         wwumwAj+GMfYuezRzGCh4GCmYeuzExm6KDBetvOHRwFBMg/i31GFY+hGXocNyh9/wC7d
         MB0ibI3wEbM6p8C2vEGl/ro5HMB+nLXt56yTQuWtWBi8Fu6rM6ImtLAdXrsfDRHZQLi8
         5xzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=i666Zwd4elC4IZ8NbSZ0mun/x9mHfJ63jUqZOhfWrkA=;
        fh=NG/nEuPEgoaPuGimMFCytjJ02a7zmffXXGabTKRy8/o=;
        b=bR4adawJHGy7l027lo7dQ/RTdtHPysVhTshqZA3I33wQ5d//j3bCgFk8tJa/RaIJGM
         1SfscSnapK1C6lDjSj7G5i7X0WZudJefopltIx3ioAsJf2HypXuS0ZvAUrtJaAtwzdSx
         heV/Ofz3lSBW1Dozn7QRH8lq5031dcBkvwOL8boDXYfwNv2duk7LuILvgg74s6+uP3/k
         MXwFvG9Dl2WSJmnXGakVWB0Yy7zvQu9pC734eiDSD5Ny/wbSDoyGHw99ky7VhMRZUjP7
         z9yFk8ATdnKvC8s6MzyUunm2CYAJdIasQ1FhDhhdB8eT7ayzD/e6b9V8XnQoL/7FllQR
         2Z6g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765460318; x=1766065118; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=i666Zwd4elC4IZ8NbSZ0mun/x9mHfJ63jUqZOhfWrkA=;
        b=DDMo/HzJ49xmSqzCSfl1ZDIiMhemdPTLBUdpeRYE9PmWTLcGDhWrKy4oFIDIp1JbaV
         JyKPQd56bK5S74wuhIGdhQlsBm5Y+j4S/tzFuUNGsdnYdaVQR5q/kIZ2+8OFLRV1tBD/
         Yo0vQHD14fVuyxS8bHCHAu4f1ngyEcrucvKJmP9loo/V9WJWcf1+6WItnFhfxK+cC7fC
         xbWV5QuGfD5NTPeWmwpr99tF0tn2pXZlOLNZ+CF/vykqSTqBM5/0Coy8wUkI6lJOZ44S
         eKzWkNtBCuywvFKFoFlHU4l4fe9oW47Dq0cezhsfi348/aHe0ZrOrCxa6ANElfLuQ24X
         lnzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765460318; x=1766065118;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i666Zwd4elC4IZ8NbSZ0mun/x9mHfJ63jUqZOhfWrkA=;
        b=Tr4TAdaEenKNZbjsKbiDjfSDm0lo3CjUC1ZC1seJUWfG2ZFOVAFWiD/8olYlqc5Noo
         WM/lFnlV97dv2awVuk/bEVFBe0cr9XsVfacrdXrvIMH5uAA1AgEwB6jMBAInymLhTxbG
         d4M5tkkTz0H6IqvqC4PrJKAQlfcl+glZVgI1rJJDYBtzCX4o8/0LIy0p9kAr2kCmxP/k
         n8rWoqgfqltaP2QbLYJaYwmBxNRLRVn0uBnZEpZeKfcX4ykCujLXJPRYE8gIcHW0TSle
         zRZJ1Td8UMCo6/cmERFGmbZ8IaXg7XTsHgs/yk3Y6cJi5F/1BffzuiP4WRz1u85V3V0c
         aFwA==
X-Gm-Message-State: AOJu0YzOaEJTrvvT6q+GoQuzykusCkGM2zhY+TvvNdUcAu4Pvv3Sc3md
	0FMQGeKMcWFi+HsDx9Y/EmR0AOOLCO7eUOtZ/G20t/Q3g0OSOr2sXdU6KKqeqhseBGfCfWhUijA
	UWAET+QXw354g4b2uRyy8MWwfcjOAcY2XmrnQUb0O
X-Gm-Gg: AY/fxX7YXuT+w89LlAYbGT8VeEnQnpS7LyoksISD87Vj7yRCJToo5/V7eYdC0uAQKs1
	r0+FGqclq9DpsIUNNunA8kVaq9LEsVKS8810nsHf0c69dMzcsDIiSu6x4fQ50N4zc6PC0YYz3wa
	2WnNzu1C9B10fhqczlL+8hagcBvJa/NpxQ+pUMT3sCqfls+QUYzj21KJaRbW4R/MwU+u7wBUhmg
	Lbl2xvP+VwF6PaOw26B41cT7YW3/wqXo4oplP5GLoK5j13B6ac+9bGAvJ2zoMh3+pDWMIcP
X-Google-Smtp-Source: AGHT+IHnlXgNY3uTjr2bG8YCH2KU2DqaaN3tTWcI65GXA9wGNxK0qa5+vVM2+v18wq1/nLG4NVQGVG9Az703nd7ZxLU=
X-Received: by 2002:a05:622a:1995:b0:4b2:ecb6:e6dd with SMTP id
 d75a77b69052e-4f1bed26845mr8937541cf.1.1765460317397; Thu, 11 Dec 2025
 05:38:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210173024.561160-1-maz@kernel.org> <20251210173024.561160-3-maz@kernel.org>
In-Reply-To: <20251210173024.561160-3-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 11 Dec 2025 13:38:00 +0000
X-Gm-Features: AQt7F2oGj2WRYea77WTrAg7wjaWZvfWC-2CRFkNaisf36pfzFJ-jdbVLpncMx2c
Message-ID: <CA+EHjTwNVxPz6rZ0d59_qz1Szpe6gRCyLa094Wi6sinbzAJ8iw@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] arm64: Convert ID_AA64MMFR0_EL1.TGRAN{4,16,64}_2
 to UnsignedEnum
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Sascha Bischoff <Sascha.Bischoff@arm.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Wed, 10 Dec 2025 at 17:30, Marc Zyngier <maz@kernel.org> wrote:
>
> ID_AA64MMFR0_EL1.TGRAN{4,16,64}_2 are currently represented as unordered
> enumerations. However, the architecture treats them as Unsigned,
> as hinted to by the MRS data:
>
> (FEAT_S2TGran4K <=> (((UInt(ID_AA64MMFR0_EL1.TGran4_2) == 0) &&
>                        FEAT_TGran4K) ||
>                      (UInt(ID_AA64MMFR0_EL1.TGran4_2) >= 2))))
>
> and similar descriptions exist for 16 and 64k.
>
> This is also confirmed by D24.1.3.3 ("Alternative ID scheme used for
> ID_AA64MMFR0_EL1 stage 2 granule sizes") in the L.b revision of
> the ARM ARM.
>
> Turn these fields into UnsignedEnum so that we can use the above
> description more or less literally.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>  arch/arm64/tools/sysreg | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 1c6cdf9d54bba..9d388f87d9a13 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2098,18 +2098,18 @@ UnsignedEnum    47:44   EXS
>         0b0000  NI
>         0b0001  IMP
>  EndEnum
> -Enum   43:40   TGRAN4_2
> +UnsignedEnum   43:40   TGRAN4_2
>         0b0000  TGRAN4
>         0b0001  NI
>         0b0010  IMP
>         0b0011  52_BIT
>  EndEnum
> -Enum   39:36   TGRAN64_2
> +UnsignedEnum   39:36   TGRAN64_2
>         0b0000  TGRAN64
>         0b0001  NI
>         0b0010  IMP
>  EndEnum
> -Enum   35:32   TGRAN16_2
> +UnsignedEnum   35:32   TGRAN16_2
>         0b0000  TGRAN16
>         0b0001  NI
>         0b0010  IMP
> --
> 2.47.3
>
