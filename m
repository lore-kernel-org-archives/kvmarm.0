Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978153B2FF6
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 21:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773351851; cv=none; b=XC4RfegQ6Xudk5QTdShmBgVpJVJHigrh3a2Q9wAbYcdUZVEpdWj3dMbHtk/zVtvryKTT1JB0sTTv2OR4JnKhftFbXgFteRV7zb5bpAa3QD/myCZAMLDiN6jhX3lMmmBvLlK5B7dAdZmufqRLVy5rE4Xv0X3Jbe4svgpYqj8HE8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773351851; c=relaxed/simple;
	bh=I7nl7jHmssxHwX1Y1aJR4hNWXuSS9xzJFZzqEQOuF8M=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=SMoGjFFmiV2HLHfhnVSJJ/rfQrDRoaP37IxdprrNrELXsnFQMHOf05CGs8kjpZVO5N+gHgtQuh0Bqd5zyB5rEzfUJ4+IpvTE/6iUeDrCT5dpgu5aTWVoJRRicRw1C8a+Dz9L0icXBZOrKiRqsfenPaameEjOlvv5rIciCV89sB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JMXW+P9+; arc=none smtp.client-ip=209.85.160.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JMXW+P9+"
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-40f25e55f20so12142193fac.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 14:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773351849; x=1773956649; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zg6XMtE8EeAIh+U43OyGl3IYGEoYBFjR2P1yJw9hfSY=;
        b=JMXW+P9+VTEKsIQV7od30x30WXH8GsyhTtRlOtfsQA98vsZtG4Ebv3gVSs0wA5EpOY
         VICMDPseanLfGFACSvz7KYQMHFNQhAxVsBbwx63SonRGlmhorzLn4pIgMUEJVia0+wxY
         3S977Oi7hiF1c/P1Etp++QJY9TWUCD2Q/6+nrLSDLdpIn8MOni9sWOk7BwXnyF/+ul+u
         gDSqgJvV2bbYQDbEhdmFuSJnpZzQWfwSAOxVc8SyLyZMrxArm/fMGaS4cduOnzCYXTPI
         ajDgJwHwGQ9XgCh6Vusq0mGOtxndNz29ewIzObmIRmaV0atnduJxN3/Q+TqoZiE7EkJR
         rKug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773351849; x=1773956649;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zg6XMtE8EeAIh+U43OyGl3IYGEoYBFjR2P1yJw9hfSY=;
        b=FHBY8KUpMJ+GaTM2hyEbK8iHmdQ7cB/OAozW0vpGgafG2hVDcoFYbZBiPdNA8CHbzc
         Kdz03ABR/yGlU9rzbUTi42v3N/+XM+hRwYCfkUOY81lcmNbVTViUs3Nt5U0KREQqym6L
         MthhADuLhb6Gg0B9P21k/kbPCzDm4HeN5I91a+OeiGu7QHmMmLzqL0IKg6FIQ4o865E1
         9+OHPscs1HDGN3Da69khj7zcm3UcDgpn8ZiVI6nb7av/36s+LxegB5/YZjbDnhM3TFYH
         A3GhvJbgdLCxQaIOugcvh9NUsFWkmI0vEjCBnW8V2Uou8Pm1RSqxRarhT2/cR7T12E0D
         oXOg==
X-Forwarded-Encrypted: i=1; AJvYcCXtt0m4y1xuVORVGOehL98bGviXzquQXENXZm8q6xtfzJpxmbZvMeFKJsp8CX664BmxbVBFMAc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz88XW04TlKoKixbC+HWc2b4nRdYf3HTXwa8LaOi+dk/PYT8GGM
	lwRyxhi6C5bZiHLKbrfda1AKlfh9CDulvaA5XTJaCPHwbcLGplmQ9nxMBKFYHaHfXtIWelFJfx6
	krrwK94gDLsZllij152nRNAXjAw==
X-Received: from ileg2.prod.google.com ([2002:a05:6e02:1a22:b0:4f6:ee40:962])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:2215:b0:67b:c57c:7abc with SMTP id 006d021491bc7-67bda9bc852mr600462eaf.19.1773351849082;
 Thu, 12 Mar 2026 14:44:09 -0700 (PDT)
Date: Thu, 12 Mar 2026 21:44:07 +0000
In-Reply-To: <20260305-james-kvm-pmuver-sign-v2-0-ee80a125af9b@linaro.org>
 (message from James Clark on Thu, 05 Mar 2026 16:28:16 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntpl58oh94.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 0/3] KVM: arm64: Read PMUVer as unsigned
From: Colton Lewis <coltonlewis@google.com>
To: James Clark <james.clark@linaro.org>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, alexandru.elisei@arm.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, james.clark@linaro.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

James Clark <james.clark@linaro.org> writes:

> Fix some issues with the signedness of PMUVer and PerfMon ID fields.

> I ran into the first issue when testing "ARM64 PMU Partitioning" patches
> on the FVP. The second issue was only found by inspection.

> Signed-off-by: James Clark <james.clark@linaro.org>
> ---
> Changes in v2:
> - Handle ID_AA64DFR0_EL1_PMUVer_IMP_DEF correctly by using
>    pmuv3_implemented()
> - Fix another issue with incorrect sign in cpufeature.c
> - Add a commit to refactor has_pmuv3() to use pmuv3_implemented() for
>    consistency
> - Link to v1:  
> https://lore.kernel.org/r/20260305-james-kvm-pmuver-sign-v1-1-eea0a2116dd0@linaro.org

> ---
> James Clark (3):
>        KVM: arm64: Read PMUVer as unsigned
>        arm64: cpufeature: Make PMUVer and PerfMon unsigned
>        arm64: cpufeature: Use pmuv3_implemented() function

>   arch/arm/include/asm/arm_pmuv3.h |  7 +++++++
>   arch/arm64/kernel/cpufeature.c   | 16 ++++------------
>   arch/arm64/kvm/debug.c           |  5 ++++-
>   3 files changed, 15 insertions(+), 13 deletions(-)
> ---
> base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
> change-id: 20260305-james-kvm-pmuver-sign-fe830bdead2d

> Best regards,
> --
> James Clark <james.clark@linaro.org>

Thanks for testing my series James. Glad you caught this

Reviewed-by: Colton Lewis <coltonlewis@google.com>
