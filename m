Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C0F218596
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 10:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756722976; cv=none; b=Km4542AMOF7oh71OFAI7BP2TBG5fxc8rh2yT2edwMVnhUtEF4MHtGu8pLy0v9h3Eikai253LlDYQm4WvPjoPbmCbaXomvUeem4XZ6rCPS+I2e4NZmVo3uTnPQ3CjGV9cksO5I3i4f0Rybwet0SwlmTXwZ6WJGvU9H1M/Orpifvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756722976; c=relaxed/simple;
	bh=cX4xW+wuCiPdTnfFxi6/ITymE0ZAMVnLHY/t+kS6+mo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TdXZg2nIoC+6irES1ykkVwPivmEhYNWKwL+yynHzZKW0WPFnD6qZQGIKUxymDHXic1j5BkZ9KA/ocJMZ4p4AZ8ZqJDT1nmRBhTZhpavbvT8Wgj0BXdfXMbkDlmI74Sw0cX5+NCwSqYgRbnmGXr+kj7fzizuPjPsbvRtY4ePZuyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KziJG7To; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KziJG7To"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b9edf4cf6cso3448633f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 01 Sep 2025 03:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756722973; x=1757327773; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XpExexnZOKJ7iqaCQ+poNcR7uax4pW5z9HIKRX8sboo=;
        b=KziJG7TovgaLfUz4yjykuvvw8c7tqi229qFGzBZO8BwJD/EV/s2u4G/F5ATWATQaGC
         9NrFoozLQn1L0lry1wxeIhrtD5FzRa5zWrYbPBXzrB2RTRVZHotPHYx4BMm6l/W/o21l
         t2qmatjTQwA5pEKd4l2UG+vRTEXwxD61DqtEd/xiej9+YaVjZ/3JrhgZhLJV70NjNATv
         HsCxVDu++JDOOj2RPdS+ekqq1KXdVV8MX1XTk7xNGCrjEX5TGRddADYCm1JOLlG9w5sc
         SBuG0KKJJYPbL6T60WsmGECSAzDcdC7PHYUgsYTgt5J5GJoMG17y/ufY1od9zCpXK4FK
         n8vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756722973; x=1757327773;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XpExexnZOKJ7iqaCQ+poNcR7uax4pW5z9HIKRX8sboo=;
        b=jnsheGE5Bct+f0xgYoMYzFVc4zHi10U84abIrA4MtSgDXOZlSTESKkX1bzDkdYXWbv
         EtNBJZgIehMr72Qcqy9Yv8lBY8AEOJizIRKhEvwUnCkWy0CGiss1KwZziecOy5Svm7Is
         F3hHOUJ/pesKCRlwV1DQpvCtEx+/iGKBnhV/zlxDXgl0peQRdMSHbaSyKEbVHrTXnEqd
         fyl6QY9YTlNtCTc8ZMzbSgS0zwksXVZOlzIpBm2pucxUrIJD7YBdd5AKqNXLIt4ovZ4V
         62p9SMLxhXPKIkKTb/C1JSNFKBpfVM3kaIRrqdGzK7OqLZP4GIlkDniuFgKGMYVJcBRh
         L1uA==
X-Forwarded-Encrypted: i=1; AJvYcCW5mFixTkPL4KTgqbwgxdIygoFHyRUsRSM60T/bPw7qDvS8gTWgxZFtbxI22FgMKspjWjRuihI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyfj0ifO3Y1ndCj8tcTlthRxunxkWPBCtRVirkcaKHddadDuD9q
	WUYZtSQsUbT+zt1VxGEMi7dG4n+GlOiFFPfPLnTEJZ7d3SzcoqqUeYjU88DWZIKLvC4=
X-Gm-Gg: ASbGncszlahk5kpVP131cUDL80G5cePkphy/hkEQu2SKaWiSY/SbiHcrBk5wP4kcYSA
	Cm7ZpMRYJ7uKrYzsiuRaZuNgpccdP+I8zZtSzJuJ9HsYSyCn2BS5MysQRJqqVh56OOWQbPRRr88
	pEGsmKB2JRU1lmC8teKc8bhZRqj4PEKSPJZbPnWBbQtFMwDA0z0e4qsM6s7h3hqJsknYzgDkSzJ
	4+KUmjaIs9bPLjvfIG0emDflay7yS78MBfPChQrq+F1g0AT6scE8oC5EcHbsffVMmAAOm6GgJQV
	0q88MMvhxrlhFlnjHSFo2vGnCDnBWF7hRtEiYy9LkBkcEZMHfFfKvVMVyvmcv9mKQ15VzmDQavI
	7ZbEPgv0tb0Uy7mWAvW7QUbpuVlWk7dYc7R71ag==
X-Google-Smtp-Source: AGHT+IEusUyvpzGTFZ+MI8lsnkKYt5dsttV6VWwq3/MdNt28CRdwWKratkBzJoTnQ6bNa1MHsKujcA==
X-Received: by 2002:a05:6000:1a8c:b0:3cf:3477:6bbd with SMTP id ffacd0b85a97d-3d1df1568b2mr5850878f8f.54.1756722973005;
        Mon, 01 Sep 2025 03:36:13 -0700 (PDT)
Received: from [192.168.1.3] ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d690f2ebb9sm4115919f8f.20.2025.09.01.03.36.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 03:36:12 -0700 (PDT)
Message-ID: <450f11c2-6c11-4ffa-ae20-db4ea419a3ca@linaro.org>
Date: Mon, 1 Sep 2025 11:36:11 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Fix NULL pointer access issue
To: Yingchao Deng <yingchao.deng@oss.qualcomm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, quic_yingdeng@quicinc.com,
 jinlong.mao@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20250901-etm_crash-v1-1-ce65e44c137c@oss.qualcomm.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20250901-etm_crash-v1-1-ce65e44c137c@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 01/09/2025 11:01 am, Yingchao Deng wrote:
> When linux is booted in EL1, macro "host_data_ptr()" is a wrapper that
> resolves to "&per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)",
> is_hyp_mode_available() return false during kvm_arm_init, the per-CPU base
> pointer __kvm_nvhe_kvm_arm_hyp_percpu_base[cpu] remains uninitialized.
> Consequently, any access via per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)
> will result in a NULL pointer.
> 
> Add is_kvm_arm_initialised() condition check to ensure that kvm_arm_init
> completes all necessary initialization steps, including init_hyp_mode.
> 
> Fixes: 054b88391bbe2 ("KVM: arm64: Support trace filtering for guests")
> Signed-off-by: Yingchao Deng <yingchao.deng@oss.qualcomm.com>
> ---
> Add a check to prevent accessing uninitialized per-CPU data.
> ---
>   arch/arm64/kvm/debug.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index 381382c19fe4741980c79b08bbdab6a1bcd825ad..add58056297293b4eb337028773b1b018ecc9d35 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -233,7 +233,7 @@ void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val)
>   void kvm_enable_trbe(void)
>   {
>   	if (has_vhe() || is_protected_kvm_enabled() ||
> -	    WARN_ON_ONCE(preemptible()))
> +	    WARN_ON_ONCE(preemptible()) || !is_kvm_arm_initialised())

Hi Yingchao,

There shouldn't be a warning for this, at least for the case where it's 
not initialized and never will be. If you're never going to run a guest 
these functions can all skip, the same way for !has_vhe() etc.

A warning would only make sense if it's not initialized but will be in 
the future. I'm not sure if we need to worry about that though, because 
the KVM init stuff happens before the ETM driver is used.

Thanks
James

>   		return;
>   
>   	host_data_set_flag(TRBE_ENABLED);
> @@ -243,7 +243,7 @@ EXPORT_SYMBOL_GPL(kvm_enable_trbe);
>   void kvm_disable_trbe(void)
>   {
>   	if (has_vhe() || is_protected_kvm_enabled() ||
> -	    WARN_ON_ONCE(preemptible()))
> +	    WARN_ON_ONCE(preemptible()) || !is_kvm_arm_initialised())
>   		return;
>   
>   	host_data_clear_flag(TRBE_ENABLED);
> @@ -252,7 +252,8 @@ EXPORT_SYMBOL_GPL(kvm_disable_trbe);
>   
>   void kvm_tracing_set_el1_configuration(u64 trfcr_while_in_guest)
>   {
> -	if (is_protected_kvm_enabled() || WARN_ON_ONCE(preemptible()))
> +	if (is_protected_kvm_enabled() || WARN_ON_ONCE(preemptible()) ||
> +	    !is_kvm_arm_initialised())
>   		return;
>   
>   	if (has_vhe()) {
> 
> ---
> base-commit: 8cd53fb40a304576fa86ba985f3045d5c55b0ae3
> change-id: 20250901-etm_crash-0ee923eee98c
> 
> Best regards,

