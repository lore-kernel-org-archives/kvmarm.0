Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A86255E43
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 16:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767976194; cv=none; b=GIyw26ntt5ruIiN24JgQ5i4S31/g3BYFNxZTdV74AdVXc1ZpEiq4aoKyoEAl6QJLVaq21jBsQY1mKMrGzO0FDuoqhWUNqd0gbhQd66txqADA/0JUvDWe4LHLorGkjPpesacOabLq2kC+QfLYW6c37eUkP9YCPzDAwp3MFuT33N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767976194; c=relaxed/simple;
	bh=UvTVTF8nfEujcFPt/XShhDXGNTvbVzJWBQPca5w8kck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PcQAw+CvlLR0inV2b5It+OkxvfkgElI5+qw8ce1ISt9pPvO+FFaR6CfaHiAs1fGAQXLXqilQ+yKesgktjMsariOra+431IBhf/7h2R1mPdWN3EveKikQ5lin19qSTA+wJmphRZUwFdQVNmksaJ75UPipuqX7AOEFFVE5ZTVHmLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gZDqvnI4; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gZDqvnI4"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4775e891b5eso21276705e9.2
        for <kvmarm@lists.linux.dev>; Fri, 09 Jan 2026 08:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767976191; x=1768580991; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sH82HZeooQjJu3LbcyB4SEm/Qe0ZcN7MT6wknG495Aw=;
        b=gZDqvnI4rls0aB4DSxUFYp54QlRGyw9+ntM18qtFUgHI3lNqTjXgzLnKT2rFRCpwYL
         Jq98T8bh0R15jolsEF1C7yc7Csxa/JN7m5w50cbmpMoUGdZqX8q0CNRZa6NROgwDid6a
         UkssuAhsvSeHQWb0K2IqlvQpz7JsLPrmhn0dgkrITZbyGP26/e9iiSWo3PdgtZXPG3kM
         IlbLQSTZkUhVRZ8xqWZ1lNiB/an+84R11iCGBCaiWIDOA0dfA4dedamKNycRFZZvlgL+
         p5l15fF2brFZNx3JrIjEfDy0kTrg1zeWXAqNwTdVGrqLiLqoZj8weKm7Iq0wTYMGapmW
         Gcxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767976191; x=1768580991;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sH82HZeooQjJu3LbcyB4SEm/Qe0ZcN7MT6wknG495Aw=;
        b=agkwYaIo0NcDf3GP8cudgkPU8LBrrkM4dlJlkAYUScBr4W/uoCWH2ItRXwRHhZGYqa
         TTnKxW10HCx3nf1xSuEDsCDR6Pgxfe9muzwfDASzSJ932+YTyx1o8HmY4W6c2DYvb6f7
         FqNxJIte+kUjy0ffukQ+BcHK4m7wdURNKcSmf7QfSeD9hQXk6uuP1RQWmx0LP1KRfu04
         AaEvyq/H91NjcKWbGit/ztk8BJTzCFhvvU6yJkoYg31OiFulIIR7o+RqS+Qnm827Y4uB
         2VoZucijYtwo6jDdCXNEn/e35YNQzbtaXNOcVIyaE1QwB3vyo4PX4XSVy7TPCLzYsKR1
         l4UQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwBidduzUmTQDYsm0NINVjRcoJF3p/4EfHT26F9D0Uj6mtEX34EtLU7nAvL93UCbJuSGrPhzE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQ6z1UzmQXKOSXrRC36zirbWQJ3RK748SYTjrwV20WJ3nnvK2J
	0RIeTtAvDPh0GZv2jIMAA/wUB/3LTA6HyQk4zRWkB4x1FrJ/uvlSjspZMZbmshGluQM=
X-Gm-Gg: AY/fxX5hrb6gIgEq06P/pq1PQOiKUZvC4FdQY0dFnskCm8y63wBqm1OgogpwlA2a8sw
	jfaZyIZXgTpMKCGLcxcEcBsB4GeHlclzootUOwQ9Jh1OE3HEha7wtnrLELtR5Tq3jr9dR3DhDRJ
	VcARrgLTn9LsTq2l77edXmQalX8rEhFyvRDmutCa1rm9ousTgsBZqUuLCkUTdT05EkOqHr6eIZk
	RfPaGNG/GpFpPTmPqfQ1NbfWrhJOqXbXezQs+EFj4mmKI1fS4ZkEDAPgd0Rz/Ibb2SsrS+yNwmk
	IoylcoWmNKJLRPvURZgrc+1gLNIrvi/LsEr1vzbZaUbExhwXK8yyWgvc6Ev6/U5vpNUSfbr/1s9
	uTPVA6rYMzoiA7QfsC2S+WQl2P0vNlIDbv3IiUxz3/cNe2E512aNjcp54uVcZtgNYPMWxFKKWtN
	Ubpvb0L+JggYAJu3b4
X-Google-Smtp-Source: AGHT+IFvEex0eSGI0zBvBOU+P4xfAclyVh4ZDcQNrtmGp7L94SuKsKC0/wbJy9k8++p9SZf17t8s9Q==
X-Received: by 2002:a05:600c:444c:b0:477:9f34:17b8 with SMTP id 5b1f17b1804b1-47d84b0a9e5mr121188225e9.1.1767976191330;
        Fri, 09 Jan 2026 08:29:51 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d8678cad8sm70961885e9.3.2026.01.09.08.29.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 08:29:51 -0800 (PST)
Message-ID: <1aaffbcd-ba0c-4371-80d7-ce59ac7f13a9@linaro.org>
Date: Fri, 9 Jan 2026 16:29:50 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 03/35] KVM: arm64: Add CONFIG_KVM_ARM_SPE Kconfig
 option
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: mark.rutland@arm.com, james.morse@arm.com, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-4-alexandru.elisei@arm.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20251114160717.163230-4-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 14/11/2025 4:06 pm, Alexandru Elisei wrote:
> Add a new configuration option that will be used for KVM SPE emulation.
> CONFIG_KVM_ARM_SPE depends on the SPE driver being builtin because:
> 
> 1. The SPE driver maintains a cpumask of physical CPUs that support SPE,
>     and that will be used by KVM to emulate SPE on heterogeneous systems.
> 
> 2. KVM will rely on the SPE driver enabling the SPE interrupt at the GIC
>     level.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   arch/arm64/kvm/Kconfig | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 4f803fd1c99a..31388b5b2655 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -83,4 +83,12 @@ config PTDUMP_STAGE2_DEBUGFS
>   
>   	  If in doubt, say N.
>   
> +config KVM_ARM_SPE
> +	bool
> +	depends on KVM && ARM_SPE_PMU=y

I think the most common configuration is module, so requiring built-in 
isn't great. If there's any way of avoiding it, even if it costs a 
little bit of pain, it would be good for adoption.

It was basically the first thing I got stuck on trying to get it to 
work. Or if it really can't be done, maybe some kind of debug message to 
say why enabling failed.

> +	default n
> +	help
> +	  Adds support for Statistical Profiling Extension (SPE) in virtual
> +	  machines.
> +
>   endif # VIRTUALIZATION

