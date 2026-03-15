Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6FE34DB6C
	for <kvmarm@lists.linux.dev>; Sun, 15 Mar 2026 13:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773581129; cv=pass; b=rnWOUvfdBAizZW/qc9F26MzLSmXoyRSqaCf2o4Y6W1pM2Uxu9ePk2uKaErbDfvagQS+XMG+YALj2zLKW08mKeiXdnv+YNp411zV53ehDJnRtRvdf85vppqNQDg+O0BsT+Dfsdx6lRRYb35mp2O6X720aUZ/QwGvrsEU0poyYDSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773581129; c=relaxed/simple;
	bh=w6yIKDrooJZkDntGKOLJ0pPUp8pV6ejz+0sLWO7K/7I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LauqADVgoDxAgQNuZy51IutG7J7RKBPufnncnkdTKJsySIdLwuRWAPeKj6fSRKRnvuzJ+93FIisA1gJ6qDKuXSYbtYkrahNEtQCBXKcOHMzNGzMqQQyKd5sIQOAvySUXO5d2EZP5G4cP1VFJ6vinIdnlbLDiPWmxXYTes47rrh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LvT0kGIX; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LvT0kGIX"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5091ed02c54so591181cf.1
        for <kvmarm@lists.linux.dev>; Sun, 15 Mar 2026 06:25:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773581127; cv=none;
        d=google.com; s=arc-20240605;
        b=RTmzp8ZJNIyfriHiBqnxbYEXELI4eX6s5hn+14HTDz2viHwbTuzsqMD1Rauo2Kji6r
         1aGTr02NTDbWuoOe1mQcLY/CA+PtjUHCbdz7yO6+v6uwLLDEzbmNqqJKPomrPRFp+ZrT
         ffniTvJ3evAAHwVa/m3qG2lHFhpXmzAD5Lh0Y4xg9Og28THltrMNaGLNDs2GaZq2iiKR
         CdA9pJ05FyLncwmryxrxgIqE0Nse9CZtIfKhf+LLOYHXSqD4pzRaR+BCMxZZEmDCt/5T
         ULPRkucS2ir24GJfrb6ANJJNBSZuu3noTE7jXAVtuY4iTYXm9rJkKuRE5xMMGGKQYZjp
         XMtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ykRRvKlaRwZ6vZ+pDBOmf2gxxH/PlXPS+bT1nkMsSak=;
        fh=rXNRjTdf8rTcNEAMEmz551DI7bPvRXaWDAfT9Hffz48=;
        b=Zd6tQByxZpB2p0PUYVf7Ipbk6LjpuRmxcmykor+9ww86Z8JFp0R0ApwxKyrujO8Alt
         jfndINqB4JBfJM9Ue7y5Q2ei47EsN2XMP9JtH2PSS3ejtVvZ9MLkGE7bqZAuLvOf5edQ
         B4XwRyf5QBC4xYenK74bMp51bzWM19MrwRQIbS3GIktc2Z4WC8OSKytTGdKJnPA9gA4v
         8yXmNqS8gQ+Lhk+G2ZAh6Q+Nj7Fe6NzZeGjEc0VVJeI2Y6ZakdX0Xz5bfjdm1UJvoIM1
         PO468ZDPO+yiOMzxoxqsE2PdSMTnKUHcfQoc9uENorv8dAifoSnPF3pqDPQn7p4F1l1e
         c9yw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773581127; x=1774185927; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ykRRvKlaRwZ6vZ+pDBOmf2gxxH/PlXPS+bT1nkMsSak=;
        b=LvT0kGIXFWEEuuC5Pz0Zw6zI4OYN0p/PyO4DfkS/ZDAmHVAuhm1aA8W9UBePwHN6bG
         pJoYQnBpGRsWljL8D9gfkRoHJyChTySHx5ea4VJFXdR9cYbtk6TDrE91soaXBZIbhQ1D
         CZx3Uv40W24Y861QTgUIaqHNz31K/X2IKjATGVlODDtcgjcKvU0tPaxLI2AqzCJCb8t5
         Abj9+f2atpeLkz+6AFINThOn6pwuiyunWdvFAg0CLtpreBPMM43uMs9O/wBpDcJz5VQP
         +akB+iu8cE7CWoc3HcmyiN6mTGcC/hMmcXkHVVwUvwnGkCscBNk6fE5/MpJNr3ld7P12
         NUEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773581127; x=1774185927;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ykRRvKlaRwZ6vZ+pDBOmf2gxxH/PlXPS+bT1nkMsSak=;
        b=Df8JHVEEA+qFWgeifbFpL/DS+g1fGF1vTCDBX+aoM9qNKutV1IoBO04ovu+U8ZkORb
         IO9TSDVPunLkonpPI7RlYR/QoIaT+ho+UZ/3GcDjw6WTiimptWNmTrl56fZCZBuWUTce
         CV3PoXCFUer25KL6RyG4IhjqDa0PtdxFg+VmciYzuu3mju+e3mSL+v0RcfdOxnky1fBg
         3kjnWPW15SgxxpusZsbF69e7d5vgM8x+nymtxvx6V1wulTE/MLxopf7aaruzVbZi3dMt
         QaBqLfW1xb9HZqeVPm3oBo9xTeL7W7vSj1YGzAkGFGswsPV2PL8zP5sWgGdCPYlTIku3
         +AWA==
X-Forwarded-Encrypted: i=1; AJvYcCWyZaolt3bERoJJplUE5gXmIODkNtGt+C6T9W8z+JYyAUs2OGmXz5Wm+u8urcCFhLwxEbEVWhc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyd3z9DqRvE2EKFrGvQ+pdi+AoL0dJOjHP0Mfu/+Z03UC7MXh3u
	cth2MnPi4I/Tp/x4EguL+gSVSkO0/Y2sWKzdxZbfaOtz1YFdKeWauTNh0rFq03ivOYBSRinRZaT
	Yc9BjL96au8hnTVZ4wA5bRDAJ6XzqYBxzlr2mEq7r
X-Gm-Gg: ATEYQzxoxcBOXziZtvxmQ1gOjYbIxJZ53ac9JBS300eb60NPXNu7H4YnV7WaK3NEcHC
	AbmUIwQAan6XfX7lXWernGioRimkoEjPZV5jDvPAQ4hGCI/58AAk+8qRyt8B+zu+9e4dTkFWnqZ
	a/RNrG3HRrRUBmbc/XPIuUR4ljnMSfJJWqEH7d36nA2yt/u8DkdH1gilZTh7sxFY16tVkFeLbtb
	5+ZTipWS0U7jb7ygfKmNn8aCuMMT88E5z199Up4AyGpQtTWH0YI1vwF7hezR1ntDTqCnX1cokBl
	Cs9V3vZs
X-Received: by 2002:ac8:7e96:0:b0:509:21ff:cd49 with SMTP id
 d75a77b69052e-5096932b4c2mr17496991cf.4.1773581127102; Sun, 15 Mar 2026
 06:25:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com> <abQqqTYvmrtGp9l7@google.com>
In-Reply-To: <abQqqTYvmrtGp9l7@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 15 Mar 2026 13:24:50 +0000
X-Gm-Features: AaiRm50COl43rsD-SL2jfwrRIiZ4pJhZrhTRVXhXknnTzW9ZqzjepERwMSgeSPg
Message-ID: <CA+EHjTx0OvER0MmyCDzgJBjp=gdz5kC+HSNfYgwF4uBETd491g@mail.gmail.com>
Subject: Re: [RFC PATCH 00/14] KVM: ITS hardening for pKVM
To: Mostafa Saleh <smostafa@google.com>
Cc: Sebastian Ene <sebastianene@google.com>, alexandru.elisei@arm.com, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, android-kvm@google.com, catalin.marinas@arm.com, 
	dbrazdil@google.com, joey.gouly@arm.com, kees@kernel.org, 
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, perlarsen@google.com, 
	qperret@google.com, rananta@google.com, suzuki.poulose@arm.com, 
	tglx@kernel.org, vdonnefort@google.com, bgrzesik@google.com, will@kernel.org, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

> I tested the patches on Lenovo ideacenter Mini X Gen 10 Snapdragon,
> and the kernel hangs at boot for me with messags the following log:
>
> [    2.735838] ITS queue timeout (1056 1024)
> [    2.739969] ITS cmd its_build_mapd_cmd failed
> [    4.776344] ITS queue timeout (1120 1024)
> [    4.780472] ITS cmd its_build_mapti_cmd failed
> [    6.816677] ITS queue timeout (1184 1024)
> [    6.820806] ITS cmd its_build_mapti_cmd failed
> [    8.857009] ITS queue timeout (1248 1024)
> [    8.861129] ITS cmd its_build_mapti_cmd failed

I get the same running it on QEMU.

Cheers,
/fuad

> I am happy to do more debugging, let me know if I can try anything.
>
> Thanks,
> Mostafa
>
> >
> >  arch/arm64/include/asm/kvm_arm.h              |   3 +
> >  arch/arm64/include/asm/kvm_asm.h              |   1 +
> >  arch/arm64/include/asm/kvm_pkvm.h             |  20 +
> >  arch/arm64/kvm/hyp/include/nvhe/its_emulate.h |  17 +
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   2 +
> >  arch/arm64/kvm/hyp/nvhe/Makefile              |   3 +-
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  14 +
> >  arch/arm64/kvm/hyp/nvhe/its_emulate.c         | 653 ++++++++++++++++++
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 134 ++++
> >  arch/arm64/kvm/hyp/nvhe/setup.c               |  28 +
> >  arch/arm64/kvm/hyp/pgtable.c                  |   9 +-
> >  arch/arm64/kvm/pkvm.c                         |  60 ++
> >  drivers/irqchip/irq-gic-v3-its.c              | 177 ++++-
> >  include/linux/irqchip/arm-gic-v3.h            |  36 +
> >  14 files changed, 1126 insertions(+), 31 deletions(-)
> >  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/its_emulate.h
> >  create mode 100644 arch/arm64/kvm/hyp/nvhe/its_emulate.c
> >
> > --
> > 2.53.0.473.g4a7958ca14-goog
> >
