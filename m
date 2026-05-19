Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE452AD0C
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 00:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779150432; cv=pass; b=IDv4Ry+p6H4UnlyFOxRAuTTk7vGOkUr28ZkClj4eE62zgrcd9IqMkcvlYeox2sWNbVN9g4uI5Fu0bG+1ViWQcJ+wvKW6ta1RQtsEQbPLupAT+mAXOMu+FkTRpgE41bUYD1RsLMZ9zCR29nQuvzvZvHFNszsxcXbnj+AM4ck0FLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779150432; c=relaxed/simple;
	bh=IYJByssWknTrVmQ7v6lmoabe76SwlIjHJ70lhPna2Do=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IlSHw8royGhxHwRtOavTyaUq4U3MtPHrtSpIMAd9EJyK2oYrexufg5KBEc9WHSTGzBPc9fNe1KjLXYfAoeB6yYwjiWsON7/VrYMgdNcTZaXNjXJOoMKbXViTTjd/W+oHPjGq09zKKStrfT4pOqBkK/5fhHVcHfFftc9NDhPL4q4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m8DQ8EKR; arc=pass smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m8DQ8EKR"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-65e170f1ca5so3015133d50.0
        for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 17:27:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779150430; cv=none;
        d=google.com; s=arc-20240605;
        b=RLvEEGVhsOP5rEzu43FGtA/cJAE8txKv0fGH1yCXrqS9xhB3argVk1Hd1p992SB0Mv
         GSHUkiDxGvy8Kiqj5bg8C7uL9DGxzC1cl5KYRogfkh6A+we+7oQpOYoyXPoMrIbzB0eI
         v8MbAplYShEeIERsbvsxrINt3LBVTnsTyBF70q+Rh+oAQ9938NDzAGkmSwpnVQbfpkVy
         Hx6JaamcXva6lZqmTTjMXxJsVFU5Ib/d1Pv/4znKuCA2tF3sbzrcDW+Nj1e58+Gli5nG
         XobwbN/97+yPBzVzhkkPLnJ0rLcuecKmXZjpcw68Zmj5RWCmEsljxFbeMY1977tWZ0S8
         nhqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IO1oTJwzLNJtEnpvkOX47eamVFbSKbRcWswCg+dtq2s=;
        fh=67I2/wTgFxSRsQqscwuV8vhVr+vBQ4+pcyjnStg5wAQ=;
        b=PBb5szKe6tx5euxi782UlhvyzUbS9kKomBNQC9btFuXjKJ2gMgEiGiSCI4b9pCxwFK
         0w8+/jKMqqzGgAG9EbTbssMILT8ztQKgUSiruMJeeYgQGqB9Ll5DU4GCOKy5/ZriNRId
         AfgDt8eFD89WVGqaTBhvb6eCZHpT6PQ5xWR/Gfb+pHcWEOrNbQN08oqHgtah6WuIYbvj
         Ja+7fvGpAJMndeFpgW2NnmA/Uis32RGceYfY4O8kfv34Lm4kAFDSyiZF+3QJr9SOLjAO
         sWJKrHUVq6y9/jYoSyEi5ZwqQbnRaKqXGsu9zhV6XXLl2g+1jSVsX1x13VNjBUqIim07
         KVFw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779150430; x=1779755230; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IO1oTJwzLNJtEnpvkOX47eamVFbSKbRcWswCg+dtq2s=;
        b=m8DQ8EKRS4XC5CDJ9MgL+HJshv4wO1PNqyNqG8MHuMW4WmrHwYSVKQhHHI+drd/sFq
         sZqVKrDoTUcQ0VRNrEXfp2Fngps5PtrRVhA5vmkN43aRPaAvbo9EU2NeWhx7aVgQL4w+
         0l/bNZVRjlCNs2w0fc4/j0n1J4IzkkcpPpC+Z1OjlSRZdGgPpAVs8Xss/4qzllaNG1tl
         Hz7RQrQQ+XLWmKP5E4kRuLmhjxs841yYpV64UIO6KlQv08aeurwD5/6p1YLJuAScdcbj
         8KXvbbrGHI6BKVwXfZHcNb1w/oFDj7dpw6THre4cGT/mSOKCdtO/BLPa8kUDW8ClgtdF
         9fnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779150430; x=1779755230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IO1oTJwzLNJtEnpvkOX47eamVFbSKbRcWswCg+dtq2s=;
        b=PlZHfafXkJtNYTAuv/dgOpBw93J5l/j5ICYRnLQI95c+luOgoJKYY5vTdR5s1Z0XYN
         YIZ3PQltW/nQRdhQ0kJK4aiBEKqDHj6dFu3GrZXA8MVPzNcfa7a7CoDAhmFijeaF2f4U
         PS38WHdAKUJ2Jpx4/dwh9oy+xF+4h9mct3BmsVua8mV7Gukg58S4mUowWSiw+F3zuHMB
         ozSHu8xXmBcsf1hN6ReIO4NsByCBFhVarInHceUWz7PPUU/HMXiWnNvY7sJaLpGrZYec
         DTsHz5L29a0X8+2jYFYD1xt9RnaQRFl/TcvnfrSiZV9Adr3plzw/M4nyffwdexs1TOww
         eTwQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Nb9p8wBJqudoPwfhhVqU4+B0/FrjdvXeJ87h3X5YncIULAf+nvHnosZq0L3jlHGsLhqYs3qY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzXoHVFk3i0WGkd2A2ZUqzhdww6qvWfHvmUz3mOIs+TTT4JyBzm
	R2g+b4tnzXfILL2vxP0f9OiM3vYkgb191SfykFNZOC1+x6rzObs4w7dX1upQkIHwLZYBEU9s3ra
	ZacGIK6O/06aQTyKQOiMh3pckBF2uOZQ=
X-Gm-Gg: Acq92OGM/4Ms+BHiyb4yasHT5rnErHnUnksp3nTiD+lC2YUY47JQIkpYELeSY7qBObt
	lYjg3CK3UmKrvDBVuT152txIvwKxSf/f0L4HZLsgZo0RgWdindHihs5VWH4hYbSkq5dvJ2tE9K6
	KfHG1Tq6RBPbh6mIksxdhWhkGRpAEaGUvqT62TorNPUz/bDZLmo0T9mFRoAP7a5lDdvQF6aFKmy
	3Bwhw1C/G09q7oNg+MWhXGQ+vqa3ZAmNtRnKpavVoveZuO1ElitgNcslUJ/uMsJhB+z/f9emjBI
	vquMpi8stxf8eri8T5e27f3bR9Fk8KO3V+zuV9hZD1n+n6M=
X-Received: by 2002:a05:690e:138a:b0:65e:4447:da64 with SMTP id
 956f58d0204a3-65e4447db02mr9902073d50.50.1779150430274; Mon, 18 May 2026
 17:27:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260517181331.367676-1-michael.bommarito@gmail.com> <outz3fxn7c5tkfz3adoilikhtyjbii7qwxmknh2l4pdf4kv5bj@54lpduy2fuj4>
In-Reply-To: <outz3fxn7c5tkfz3adoilikhtyjbii7qwxmknh2l4pdf4kv5bj@54lpduy2fuj4>
From: Michael Bommarito <michael.bommarito@gmail.com>
Date: Mon, 18 May 2026 20:26:58 -0400
X-Gm-Features: AVHnY4Ku9jWfRwvIo7-h4T7kNEOsQvNYU_4O2yUmyt-qJls2SXN9VP3G8jsJ6CI
Message-ID: <CAJJ9bXyHRVqnL_n6wwyAXDK=1GmaKgDy41tjMRhXjTObbft7gg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: vgic: free private_irqs when init fails after allocation
To: Yao Yuan <yaoyuan@linux.alibaba.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2026 at 1:31=E2=80=AFAM Yao Yuan <yaoyuan@linux.alibaba.com=
> wrote:
> Ah. One thing I forgot to say:
>
> Do we need a fixes: tag here ?

I struggled with that a bit.  Will's sister commit in 250f25367b58
didn't have a Fixes: tag, but if I had to pick, it would probably be
this:
Fixes: 03b3d00a70b5 ("KVM: arm64: vgic: Allocate private interrupts on dema=
nd")

If you agree, I can send v2 with that added

Thanks,
Mike
