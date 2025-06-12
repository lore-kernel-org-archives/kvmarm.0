Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DCB1BC2A
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 15:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749741416; cv=none; b=S8peYo3wxLp2tLq9kMZRZVLoe3F0U5k2VTkpPK+d1vvvOR1ylGAdl0HjcEVPrrghxs0zikwCB2hW5GxoS6egXGCnlwd2hVdSSYC/YryNYC9I/RXIqmE0xJ+VPE9C4D492wDn1AKqVX4PP1JFe6TvOPWt9RGf1czZiGNtIxj4zRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749741416; c=relaxed/simple;
	bh=VHtWmZvNEEluK5e3KkLcIqngznyWAjhm6ToignebZu0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NxMpsy2Z30Erm2x3kuRYWshx0Hk/+UpIiUKyv1oO3cIoUYhiJ6gCZG8kbXQCYDkd0DQYUrTxPzoxFyROVO4DtLfNSs6xqTXzlYM3lxw3RwguGNsZrS32iI9n1l84W8iODHcIWsA6rlvdhxcmWVGaYYn8bEKH++k/omHtvAPjBIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HJowRHUJ; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HJowRHUJ"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-70e3c6b88dbso7363277b3.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 08:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749741413; x=1750346213; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pynYP3g1x7bEvnpKVAJ2PfUrR08T2TE/exFWGnDSM3k=;
        b=HJowRHUJnCdBBX7a3anEB1c1FjMMI2oS0PAPV/1Hx9WCioBAycltIxSKF+d3pMlnef
         qZfT5M2PTxH2c00I5ddIEfumZrOha5B/COWsmOd2/O2Szg6jE50Oo+VpS+bb50KhZy6V
         p4OWOHk293QdmVgaaotb+DJ0DG8rd30UZouZXva3OJ3fBcDcbp9wKQMx9skaugctkv53
         tFx16oMvrpRiKivJHNfAOJZhvR9xlPrAaEMmdb8CRn/JmH7QlPAyoCe4/g+YjtUn07g+
         P3F8OV06Sbv9Cjn+O/JoYr9FsKwiZsgazqp4RC2Tf00IFXg+Pp3SHjrv+Ahq74dpSMgt
         qwDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749741413; x=1750346213;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pynYP3g1x7bEvnpKVAJ2PfUrR08T2TE/exFWGnDSM3k=;
        b=CkyARDnKJ2B+3Ft3SNGeaua2uadXJpgXUPBA+E74K574ujujcLsbNeOZWUsZXcYz6i
         Y2oDj0xpJP3elgqljb5lYohN7L8iAGkc6PNVFq6s/my5rSkePrcxf+vAtJORlI3+dwfy
         rTSzYKcH84/PIitcReKHpE1YQhBUUdnWV+8mEWLETFII/ybSFkcce5562+kCfSxsvDJj
         4F2B9Y1z4C3IYD7iw5d+/syjPrNBTrS9vftV8haCD9tWaesGvcC5Kt57yz7lPUnOh9Ei
         SnfoYc+LHuMlwBdvMsFOZ+j1AH7yIzASkn8XfLTTLX9FCPeBogV4kO8hrc35a/fnZd+p
         L0yA==
X-Forwarded-Encrypted: i=1; AJvYcCX+ztnDroepQbugIauZpvsuo2xqm0orlBpBX4TpPtXm0Gc+fmz9fS11lxfQvi2IVYswlTj/TzA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAShpVNcu4dYwEtQUzD1KBg0ZYlaPWHp3+o+C04VUs7lsSbUlj
	f0gMR75cnLbQUEAb3ehXqi/OjayyDPs7nD9eGSTP198VSsZPgQs5wzuraDRBEuQRh1eMzw5wb9/
	UsUPkAu3jLeNM5lSEuOrKLHNmxNWiW/xcX//ZRYXeoA==
X-Gm-Gg: ASbGncvAO37LoxijEvLYD7kBfHUaabTeu24bRXioBxDYKqartHGcEnEItFef7OfMSYm
	T/08h2w0JWMs7TcuNF5VlkN9q36uaHOb7l/U+j9689XcZxhubHP2PbIHmUFAVRE+BC0C4/8ife4
	Lasz4YE1XzLx0ximQjHwBfLPjLvmzJehbuLP+vYemrT8U3
X-Google-Smtp-Source: AGHT+IGYiecPIEGI+SJaCfuiYeexAAl9RgvSgy2FQZTT1sSnvIQJSJ8BM7RWlCmuhu4n7BWqsMQg6VdmdcMZ9NIZDqM=
X-Received: by 2002:a05:690c:39b:b0:6fb:b37f:2072 with SMTP id
 00721157ae682-71140ab6714mr108064287b3.22.1749741413249; Thu, 12 Jun 2025
 08:16:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250515153907.151174-1-cohuck@redhat.com> <20250515153907.151174-9-cohuck@redhat.com>
In-Reply-To: <20250515153907.151174-9-cohuck@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 12 Jun 2025 16:16:41 +0100
X-Gm-Features: AX0GCFuBHrJGT1DhrRgfURJ0MalgsW4xYAj3mIR8h1lKcbEjMTHrKhv4wIVn_nY
Message-ID: <CAFEAcA-c=EaE-Y4DMVz_meVd2cbxuCyFGFOXET-COOgMWHXWWA@mail.gmail.com>
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

On Thu, 15 May 2025 at 16:40, Cornelia Huck <cohuck@redhat.com> wrote:
>
> From: Eric Auger <eric.auger@redhat.com>
>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  hw/intc/armv7m_nvic.c     |  12 ++--
>  target/arm/cpu-features.h |  36 +++++-----
>  target/arm/cpu.c          |  24 +++----
>  target/arm/cpu.h          |   7 --
>  target/arm/cpu64.c        |  28 ++++----
>  target/arm/helper.c       |  14 ++--
>  target/arm/kvm.c          |  21 ++----
>  target/arm/tcg/cpu-v7m.c  |  90 +++++++++++++-----------
>  target/arm/tcg/cpu32.c    | 144 +++++++++++++++++++++-----------------
>  target/arm/tcg/cpu64.c    | 108 ++++++++++++++--------------
>  10 files changed, 243 insertions(+), 241 deletions(-)

This doesn't compile:

../../target/arm/tcg/cpu-v7m.c:70:5: error: incompatible pointer types
initializing 'ARMISARe
gisters *' (aka 'struct ARMISARegisters *') with an expression of type
'uint64_t *' (aka 'unsigned long *')
[-Werror,-Wincompatible-pointer-types]
   70 |     SET_IDREG(idregs, ID_ISAR0, 0x01141110);
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../../target/arm/cpu.h:875:26: note: expanded from macro 'SET_IDREG'
  875 |         ARMISARegisters *i_ = (ISAR);
         \
      |                          ^    ~~~~~~
../../target/arm/tcg/cpu-v7m.c:71:5: error: incompatible pointer types
initializing 'ARMISARegisters *' (aka 'struct ARMISARegisters *') with
an expression of type 'uint64_t *' (aka 'unsigned long *')
[-Werror,-Wincompatible-pointer-types]
   71 |     SET_IDREG(idregs, ID_ISAR1, 0x02111000);
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../../target/arm/cpu.h:875:26: note: expanded from macro 'SET_IDREG'
  875 |         ARMISARegisters *i_ = (ISAR);
         \
      |                          ^    ~~~~~~

(and more similar errors until the compiler gives up).

-- PMM
