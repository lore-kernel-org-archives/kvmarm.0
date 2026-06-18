Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EE01F5437
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 17:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781802879; cv=none; b=LhCuc39flFz8l5mDmcCRTuGzw2cBym8Cxfub7QcFO7RXo1uA/w5LLgbjEijUud8IiFuco0Q0MlEVDQC9FojyP8aoEKa16Af1Iy4TCHNlp+zXXJvVQRHEAlAZKdq3cQrMGBIQ65RnG90bfnWWTaw4r006XMSkXCnWGt2f8c4RPd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781802879; c=relaxed/simple;
	bh=aLRhpNncKn9DUj8bxhQ/4BAqsypCWpBBw8Z5q0jDYdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RG5m2TszsPXdwBpWnQgvKCFNAz5sWbRUTejg/wJfHOS+Oil6gJR6L/fHbwPWNXJrsg0/dIvzlYwyQtOCm4HAByHeA9VaIQx7V3lirGlOsskUUCn6uMv0iYTjbzFRQp+ZANfPvWRJsqfSfrXgZkIvcu+D0Gu6JwngrrTFDJvvf6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PyGP1pbG; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PyGP1pbG"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-45fd464d51fso770643f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 10:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781802877; x=1782407677; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q37gll9uXRgmI+EFMA1NhDtwvLbIk280Pp5eRyLMrZs=;
        b=PyGP1pbGT4xwZnS3Nf9JnKKZDLjSRPGADF6wsFhubMhnmdAChDHhgxOk2GPDQ40DM2
         pvwSMpktQE1vs48t6eC6ytk6FBMkGsxZWupQrRVgrA4rGqPOxILNrBL5Y/CqoxaZp/AG
         DClt1aTOtvxIGKDH1ZB2PWdvKAe7eyCzCrARWIjXsDMNAdToPY6QcsPq+B9bQqs6/tjv
         n+NgyX5MOi2Kqr6gKv8jxiD6vP5tgrs4im8FF6O7sU+uceUs+dSP3V1uYXChefyXT7CZ
         oP8yTLYWBhx1nVZXHqRnQXz4PUXbOywL3kkX21YwBnpst+vWCf9PAvB9Jt/MWm0sVBzB
         e+hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781802877; x=1782407677;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q37gll9uXRgmI+EFMA1NhDtwvLbIk280Pp5eRyLMrZs=;
        b=owD9wVOUNRPfo3lO7ldRIXFBNL0c/My20Jk6uwEFV6pOMjwc3xUyZc4d3ubWXs/BGN
         53zby9aifdYLA9qFM4sb0JpuGGrh/cRFxliZmtt++j0IMFSRYZ2fn0p8oGw6/QL/MDgg
         3mkRwh5rLV90Mhy4+19/tQrf5f8+xLJb2INW23nfNVKVMz1vQQo/pqrLRTOU4nID92WJ
         y4gaqkMnxuA9WkU0mPM27M8yDMjdvj+ehjRR3iFn1WLDs192L/5vaDH08PNbTHoDA2og
         05DzyCATfQEMqlBfZ8BKGzEo8+6E1fb0R8798RNMI9jXt8wyahvCU0K5llXFH8wIAfEy
         +dmg==
X-Forwarded-Encrypted: i=1; AFNElJ/p8jg2EOxL/KqNo/BNNz3uWcmhPw1fZDTKAhv3AjYYLbf5dxVXG+DG0Z7M9Ml/yRCXwx+GviE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyPfE7HxGvjwDnSFXod7+fcAS+LNBm/gJoh8iBkGDZOsz5KtCR0
	oxVril5mnueim4tiXGw4yqqYlnpslxI4OBFB8tV/Q4GOokb89X+gni7ZhCFrxZc7SQ==
X-Gm-Gg: AfdE7cnASuH4xDE7XielkU+u8kze4zUjPlQvcRkUsNdvwwjgpCPT0LSQ9lD0sAMmTAp
	Q+3E02FGba1EA8JJGxj4WQIh9qJDRiHa/DZAs4UvbQ/3i8IMpl1lTMwqcrBb06KmBJs58tokcnm
	ir6IHLr3Zb48Ej4tfTgGLTEIEeaQGKiHdeUwaW47xWhn+gqRPQxcFY6t+Jx1hwDrXkeqX+uUaNF
	5q8JPbnlwl/V81ygHjsLTifSoEasQhSkAzjfKW7YlB4Xyahual0759MmhWVObTUtwWvn1Prgg49
	Pusa4W+0dp1df3Wpmy5q77Gy25ptkqm9qm+p4OjqKz1u5h64FIf6buI4AVWjqA6/HcdpjvD3yir
	knTOalH0Zq5kaV+G7SNyGMAeAbAl+QMadLsoe0ucQIVYl3L0QAdxWj/A2JRcgqKNCNXZ0tJHrAe
	45KJywI7MQU7HwGilFIyW9rUV6IPZjq5MQYi5RaYXsOQkxNktwa3pnRthY
X-Received: by 2002:a05:6000:184b:b0:45e:fa38:c899 with SMTP id ffacd0b85a97d-46500a02b15mr590072f8f.4.1781802875940;
        Thu, 18 Jun 2026 10:14:35 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46508a0546fsm418554f8f.2.2026.06.18.10.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 10:14:35 -0700 (PDT)
Date: Thu, 18 Jun 2026 18:14:32 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, oupton@kernel.org, sudeep.holla@kernel.org,
	will@kernel.org, jens.wiklander@linaro.org, joey.gouly@arm.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	maz@kernel.org, mrigendra.chaubey@gmail.com,
	op-tee@lists.trustedfirmware.org, perlarsen@google.com,
	seiden@linux.ibm.com, smostafa@google.com, sumit.garg@kernel.org,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	Sashiko AI <sashiko-bot@kernel.org>
Subject: Re: [PATCH v7 7/7] KVM: arm64: Zero out the stack initialized data
 in the FFA handler
Message-ID: <ajQneFTingGFdPSb@google.com>
References: <20260617145130.3729015-1-sebastianene@google.com>
 <20260617145130.3729015-8-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617145130.3729015-8-sebastianene@google.com>

On Wed, Jun 17, 2026 at 02:51:30PM +0000, Sebastian Ene wrote:
> Don't leak hypervisor stack data when using the FFA_VERSION call.
> When the compiler doesn't support -ftrivial-auto-var-init=zero option

Even when it does, I believe this is an optional kernel option.

> we need to zero out the stack initialized variable before returning data
> to the host caller.
> 
> Reported-by: Sashiko AI <sashiko-bot@kernel.org>

It seems most people are using "Reported-by: Sashiko <sashiko-bot@kernel.org>"

> Closes:
> https://lore.kernel.org/all/20260616160016.C62C81F000E9@smtp.kernel.org/
> Fixes: c9c012625e12 ("KVM: arm64: Trap FFA_VERSION host call in pKVM")
> Signed-off-by: Sebastian Ene <sebastianene@google.com>

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index d7c5701d0584..b321682ead04 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -883,7 +883,7 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
>  
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
> -	struct arm_smccc_1_2_regs res;
> +	struct arm_smccc_1_2_regs res = {0};
>  
>  	/*
>  	 * There's no way we can tell what a non-standard SMC call might
> -- 
> 2.54.0.1136.gdb2ca164c4-goog
> 
