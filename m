Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9F618950C
	for <kvmarm@lists.linux.dev>; Thu,  8 Aug 2024 07:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723101608; cv=none; b=DWEW45jsiGT7gbritJ6weqKJAVzTFLgwVFVB/BT9xvejRvlO4UVmcTKOfYaUrH1HJq0wj5gs2RcDxAApR3Yf+eNhPAANFDd0AgGIYV7dfsMSChXhcuBrJYxFZdtyEs2DXlIFgrco14CIaX/wKO0lqrqDtqQ/lVdLxcRVA3h3caw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723101608; c=relaxed/simple;
	bh=b/kpH/3tmPauPmCl8Zu5mF23kdDNk69dX/Z2CiAKZro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s/mryH5ubvcB4lW6GxH4SM67hthGFbj1/P7uCC5bx/e8rRShefntH4/EENW8cl51Lb/7MYn1PwJDGlcDfL0d1e4rhp6oq/2nwz/asf70Id0f4C4stKF9s5MM+mB6UQx/nlX8gyYPiZ+2Q7/9g5WWkTUoFT0V2qdM1/hKz1gaC4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bF1fRGwf; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bF1fRGwf"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-70d162eef54so553172b3a.3
        for <kvmarm@lists.linux.dev>; Thu, 08 Aug 2024 00:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723101606; x=1723706406; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=61Dq28Nf3F9g5/Td//Ft/plKsDILKvExnLDG0dDTx/E=;
        b=bF1fRGwfr8HjAt17t+xJHcsDdQl3fmDhJLo328tISb3DPbS/LeRNhU0d8i7YClJVFr
         9IGjxLTTbZup0w0mxezprC59kO/gqaGspBB7TEYZV5KWri91l2Zd1ML+i5P4GQtwWlr6
         f27mEH2TRDPswj8gnPUCMKnOHDbqLB39NAxJoiyYIPm+fGBt5/asvtfchlermPuYupr4
         hte2dcew8lWhz8znQXmqAkGwcZoSy3kAd02jIiXqytr7BJjmH1DWM55X6WruIUv02a69
         U1TIwT3GQddB6KTbGwmWd3iXAy4K7n4rH4cx81uUPWvND0TKmlG9Dt7oLem42uN5bjCN
         c3Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723101606; x=1723706406;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61Dq28Nf3F9g5/Td//Ft/plKsDILKvExnLDG0dDTx/E=;
        b=Anwa4TKgYKtM1hliwjUgYSa5thc82HtO/FQ1AHePhvp1Oy5h/QBkHGrjOboJtUMaXh
         FO5JBEwkPc1pa5TjcrQxNR7HFHe/JDhbQZTiQwJF0lIQqk9yVSZd7htsjEAru817TMkS
         fKCf3Hr7xVB+D87xzg59RKAGek26oHf2p7ZnGOitYzGs463bh8UcN8Q0ZYldtQdUgQd0
         SFiUKKP/y9XLoFICpmuijd8FCx7+VmuQk2EcPSC8vhJTbyTsfpfkagk8gI3Dk+ikl3SV
         xKjDmjJt39aL9XIkNpNVoFXSfm5tLT+oy0aaA8Mv6p6ca+n6sxHdwyh6kyq7yWBsNnPM
         6vUw==
X-Gm-Message-State: AOJu0YxORINgvnjr5SbiC3bAX65BpjEr3N297yV4v6GA5d1oDF07fgoI
	tAZa6wgeV5emLohYOUfA8PXn9wf5exkMPAvWQhReuet48hlH7/gw79EFpljyYgo=
X-Google-Smtp-Source: AGHT+IHVwhaQmB+d14u8C5u0Db/YHWcOUNGK2FDbdbISVxJ0Yl/Gk9DnzZRjMnbItZYZ8mQzqORc6A==
X-Received: by 2002:a05:6a21:328c:b0:1c4:986a:de71 with SMTP id adf61e73a8af0-1c6fcf82a90mr1091067637.35.1723101605996;
        Thu, 08 Aug 2024 00:20:05 -0700 (PDT)
Received: from localhost ([122.172.84.129])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710cb2e74fbsm572565b3a.168.2024.08.08.00.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 00:20:05 -0700 (PDT)
Date: Thu, 8 Aug 2024 12:50:03 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Arnd Bergmann <arnd@linaro.org>
Subject: Re: [PATCH] KVM: arm64: Enforce dependency on an ARMv8.4-aware
 toolchain
Message-ID: <20240808072003.3r6cfgaxbcvayhrg@vireshk-i7>
References: <20240807115144.3237260-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807115144.3237260-1-maz@kernel.org>

On 07-08-24, 12:51, Marc Zyngier wrote:
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
> ---
>  arch/arm64/kvm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 58f09370d17e..8304eb342be9 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -19,6 +19,7 @@ if VIRTUALIZATION
>  
>  menuconfig KVM
>  	bool "Kernel-based Virtual Machine (KVM) support"
> +	depends on AS_HAS_ARMV8_4
>  	select KVM_COMMON
>  	select KVM_GENERIC_HARDWARE_ENABLING
>  	select KVM_GENERIC_MMU_NOTIFIER

Tested-by: Viresh Kumar <viresh.kumar@linaro.org>

(Build only).

-- 
viresh
