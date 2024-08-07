Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E25170A3C
	for <kvmarm@lists.linux.dev>; Wed,  7 Aug 2024 12:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723032225; cv=none; b=JwIasjYV7FGeGrz77Oop30cdY8GMQcUq8u8zJ2Ut4Ic6sTmGSG8+bvvKpPQC5dA2e5c2TL/YRzptLFxqcieY5+sNKcMiiizhbomjnxHa8iXzL3SzDivDqTC3HpNfZclKm7/RU9zTT3imrNj81q4TWR47aYJBqe5aiQqDROL+4LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723032225; c=relaxed/simple;
	bh=eHnzZxvF15NpFQFuEEUPzUKpxsYKctPkdoG+AlVdl7o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cw6Yiw4/fhTtR8/3Yqgdy7zOtzqisdQZ+DeiEJm/AWq86NUMwzJv7s4TIR3e5+MucPf2blB4CpeuWWl5Rbp/1Tbh97GX53lBv8aO3sbTjM1IEpuGbaXNpG4yHhWMEnhF3anJkA6+sIr8fxS/mTcVmXZqdC5k8P5NrHf2dyBXJNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JEjGgs6w; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JEjGgs6w"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a7aada2358fso140004966b.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Aug 2024 05:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723032222; x=1723637022; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y0TEK7VexrgHrcuRN/0zKNDoFgC5jZ1V28n+hBRwak0=;
        b=JEjGgs6w2xdTHwUamjnSh8vibf+3hWYEV+AeMwECi8FccJWnzCaCrZU0UDM1TSoskf
         sJ2UThqXuJa4ntZhQCMLPxO0nZZF1yCd6KemMzzgsVU7y8KaLZUB2GEAb98CZHm6BuIN
         3qBcRg5xSXpZjhx3hRNyTfzq8SPpu2SoTYravRn13M6i7UqvxTBkizRLjo+HfvEbYV8G
         ftR8+2KuarjvxM422evSz8igNeu9RZM0CrvjNyxNsBF0B+vk9KnLix8goyy5VbDEGwFw
         FSloemwWMHsIE5yP+hzbCdhRrghWwq6eAwUTsXnYoqZwXi/ivc9GTOyrNr89WBKy5G5n
         FFiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723032222; x=1723637022;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y0TEK7VexrgHrcuRN/0zKNDoFgC5jZ1V28n+hBRwak0=;
        b=uIn87CPUrxqV1ru9zqRif9ElNBIdwdX3Q5CgAZHLyWn+syIbPqz4vvvOBWnre79mKx
         N+3rpUL3AnWvLtITj914GGiiPB4Wx7LqbUkRfOPk1avaAM98J6rcvFbX8oecCojJQUVY
         ziD61sZw9JxEIMmPqZ135B7x0VJUj0a0ZRQa4/njbiKATsCwiUsDaccBe3D8hCkNhNyZ
         O8vRTm8EN17JjJ1uIJ7iUzOBTHh8UpS3WZckW8wI9PgoJyyYfxwoU/W0jOJMMA1HcObn
         RHzigfL4FSpYDztn+h74E9VJ20qeLNYyI4NCBRdrwkxPnEVdpSRfWguoI6k/FLmno/FZ
         YJ6w==
X-Gm-Message-State: AOJu0YzPHvk/vzoEF6MGe5nezoInM0YDko831+USFie0unhIhBjol9Hp
	50KdzLQkmP63l9adcAO+YqSHF5RORG7CjbAx4DNDiWy7iow/qQUocdDHcczvrdqgo5T6qdthZXs
	KVotp73VzCRdmJF10Qxxgx7ZI6L1KuFGb24lL7g==
X-Google-Smtp-Source: AGHT+IGTVN+IAvtqUg54NSlcZRxqUYzfVGO8u0Dk8yXtigYp1alhJB0nuEHChv2kofRqFw7L4Y+G/Gne2p43XudD/dY=
X-Received: by 2002:a17:907:3f86:b0:a7a:1c7b:dc17 with SMTP id
 a640c23a62f3a-a80791a644emr143296466b.22.1723032221748; Wed, 07 Aug 2024
 05:03:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240807115144.3237260-1-maz@kernel.org>
In-Reply-To: <20240807115144.3237260-1-maz@kernel.org>
From: Arnd Bergmann <arnd@linaro.org>
Date: Wed, 7 Aug 2024 14:03:28 +0200
Message-ID: <CAKWjNY-=WWxUX-u0g4A_a26U1GNsv2Faak49dkjP-x=ZuQfPvA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Enforce dependency on an ARMv8.4-aware toolchain
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 Aug 2024 at 13:51, Marc Zyngier <maz@kernel.org> wrote:
>
> With the NV support of TLBI-range operations, KVM makes use of
> instructions that are only supported by binutils versions >= 2.30.
>
> This breaks the build for very old toolchains.
>
> Make KVM support conditional on having ARMv8.4 support in the
> assembler, side-stepping the issue.
>
> Fixes: 5d476ca57d7d ("KVM: arm64: nv: Add handling of range-based TLBI operations")
> Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
> Suggested-by: Arnd Bergmann <arnd@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

>  menuconfig KVM
>         bool "Kernel-based Virtual Machine (KVM) support"
> +       depends on AS_HAS_ARMV8_4
>         select KVM_COMMON
>         select KVM_GENERIC_HARDWARE_ENABLING
>         select KVM_GENERIC_MMU_NOTIFIER

I think this is good enough here, only slightly more limiting than
we strictly need. A slightly more fine-grained approach would
turn off VHE mode on old binutils but keep NVHE. That is still
inaccurate of course since VHE only depends on v8.2, so
I'm in favor of keeping the version you posted.

For reference, even the gcc-5.5 toolchain I built for kernel.org
in 2019 came with recent enough binutils, and we are likely to
soon require gcc-8 or higher anyway.

        Arnd
