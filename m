Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA253019C3
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 15:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783954869; cv=none; b=K7dda1gIeuzifYDkVWO+aG/81WlS4zmrc02W4K0S6tWFLLxMeB+b8QIXbzgPDxbInaJhsBRTAaVZHpQei/BQhZHejBlnAxblAEJGaWp0ZMHZcWehkZzBRfC35cxhsAJ1gNN+rq/iMpDMtGjo2l64hK+t96ODkJqFOKdkSSvtzUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783954869; c=relaxed/simple;
	bh=hlqIiRhZlkCHvonvTzLKSXIZj3XHXhx7E+Rk4m9S1RE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cc04nWCjcq3ZrujR2AQDyXQXDfHSbKUzBAftnv5p0W+lHZSsXEdFhFrn6+LCO4n3KdS6wAZVHDqUrIcSvyOir/Auxr/N5HX6q7AKg6dLl5XypsVBuWLjpSS6ra1CbvXTN0PPNoXbT8YpnNYLZqEpKpe3DR421seEkC17B/nM50U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hycoharl; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hycoharl"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-493ae59eca6so136045e9.1
        for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 08:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783954866; x=1784559666; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=d/zUrdSLYFP5PkDzH1dLf/JMl5TUcm+CxvXCyHNk/cg=;
        b=HycoharlY1OpC36DpjKuhpWMGNqxfzpQXSMcsAJywc+S56WXHM1Vv/NsiYSnKHe/z6
         beGdt3QtG1yiQYKNAotjtJCJ5gpbg8QsgcMzfwv+xiSBoAe7ggP4pCc4bzJb1hFJl7Oa
         IZr2YrcnkF4qM3SQlAiyhw2K+2qgSW39NxbUZuFbjkqw8lfUsjh3aSXOf5K98xpmlgMR
         NOwDODhBe5C6trzxEQyOXl6tWYPyd6cnk0H6WXiog6qkWj02KT2fA1kTMKK6A1VndpYH
         H/g1KeevZVx9FFtIUpD8IZOtlDJU2QF2ijvWioDc2ahL3dopPy7vYYloEfw9i41xYzfy
         RTdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783954866; x=1784559666;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=d/zUrdSLYFP5PkDzH1dLf/JMl5TUcm+CxvXCyHNk/cg=;
        b=TF7xH9l6gc03mdz39k6uMKYYWwHa8PdX8WJUVJy/8f3hqgxrHH4gaNgbzKdXRhlh8P
         qPL96VQbn2pMt3MVv3G5CUZQN/W8VPylugqmhwK1DqiOt1Cd1eBgHM1g2/x6vgCS0dbO
         yivWyHAcnFdUAZgLvPpix+4Ej5TGisQZSK5bsoeVC0BdBZlyaJ/UhaWHuCGAUosMMMpF
         82qfj/yD00msIC4biUUztAzvuR6TLiLy3gqLbUvkkWOClgw+5yJJzBeDwKP+IoleMo3/
         CET+SaNoW2hhhB/XHMtryY57Qh14nFJRYzp1ETJhXBLKNDdDRKBWtn2sMWCWavuzx0UU
         Tg+w==
X-Forwarded-Encrypted: i=1; AHgh+RrhV3G0vcFaURqqxQGlyxQNAuP8v8Lsi+i94EdsAie0TDK9HVjOZ3VdXQbpEg2bwiwF1TD8s8E=@lists.linux.dev
X-Gm-Message-State: AOJu0YxEiDaaY7ZoHNcyCl7JjxHKbQQZdd3NdBdE11jq80qvM84VpqaA
	UTwANM3m74CpvBFhKgWMBzyPBIWwwJCv3xTJpHYqhRK9sIRGkcoGhh4DaBY1PIBnBg==
X-Gm-Gg: AfdE7cmaUkSD/jgoI/YEI/QxI6mspocY0g7u8THoqnXnCcUEcsU9I9e8LSZ3L2DHRbW
	Dw+XRHgNy1gS5211sTiUdiVA0q/Wulr8CGAzfW6tikGErtATnRyo7IgPGKu0EVGZ54o5FpN03t2
	g9wQigqeQjGcowUFyz0jpvtAIRlErNeKBYFoW/yAoduOR9tp3nhwyg/f7BdBYRE0KppW3s/ADuI
	GAw8JUybm5Qr9yrWMw0NYOcxGKdQYoOgrnzBkrtZUP3RKgaCUSKVG8JxgcPjbqcHEAyuzzyysk5
	liGJqhU2Ltk6SEBfsls7Dps/2EwEDFuO0o78t77gZMR+CCd1ogCPQfLdYxcaJGcjjEWghw7Neuh
	eN4RnSm0zFo3IcA9p0JtHTHBezNMgEuvlRicS501RJ68wLiXNve38wd87uPAunWv1skGJQZSM0J
	LguZZw5kf6cS3EFAuEs8ZdB5nRevoiG3/f+sZtpIhbgbNZzhEZkDScg5c9jI6YVg==
X-Received: by 2002:a5d:588e:0:b0:47d:f43d:8947 with SMTP id ffacd0b85a97d-47f2dce306dmr11031006f8f.47.1783954864981;
        Mon, 13 Jul 2026 08:01:04 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f2465ae8bsm29830623f8f.36.2026.07.13.08.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 08:01:04 -0700 (PDT)
Date: Mon, 13 Jul 2026 16:01:01 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oupton@kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, tabba@google.com,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2] KVM: arm64: Avoid naming collision in tracing
Message-ID: <alT9rXz_azhiq6Zu@google.com>
References: <20260713141320.4065600-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260713141320.4065600-1-smostafa@google.com>

On Mon, Jul 13, 2026 at 02:13:20PM +0000, Mostafa Saleh wrote:
> When the hypervisor tracing (CONFIG_NVHE_EL2_TRACING) is disabled, it
> defines a static inline stub for trace_clock().
> 
> However, trace_clock() is already declared as an extern function in
> linux/trace_clock.h which is pulled in EL2 compilation.
> 
> If the file <nvhe/clock.h> is included when CONFIG_NVHE_EL2_TRACING
> is disabled (by including it manually in setup.c) it will cause:
> In file included from arch/arm64/kvm/hyp/nvhe/setup.c:22:
> 
> ./arch/arm64/kvm/hyp/include/nvhe/clock.h:14:19: error: static declaration of ‘trace_clock’ follows non-static declaration
> 
>    14 | static inline u64 trace_clock(void) { return 0; }
> 
>       |                   ^~~~~~~~~~~
> 
> on GCC and a linker error on LLVM (it seems to change the linkage to
> global)
> 
> Although that is not a problem at the moment, as no other files
> include <nvhe/clock.h>. That does not seem to be the intent of
> this code and that will cause issues with more users as the SMMUv3
> driver.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Tested-by: Fuad Tabba < fuad.tabba@linux.dev>
> 
> ---
> I did not add Fixes tag as this is currently dormant and not breaking
> anything.

Thanks for the respin

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/kvm/hyp/include/nvhe/clock.h | 8 ++++----
>  arch/arm64/kvm/hyp/nvhe/clock.c         | 4 ++--
>  arch/arm64/kvm/hyp/nvhe/trace.c         | 4 ++--
>  3 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> index 9f429f5c0664..ae03ec6965af 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/clock.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> @@ -6,11 +6,11 @@
>  #include <asm/kvm_hyp.h>
>  
>  #ifdef CONFIG_NVHE_EL2_TRACING
> -void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> -u64 trace_clock(void);
> +void trace_hyp_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> +u64 trace_hyp_clock(void);
>  #else
>  static inline void
> -trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
> -static inline u64 trace_clock(void) { return 0; }
> +trace_hyp_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
> +static inline u64 trace_hyp_clock(void) { return 0; }
>  #endif
>  #endif
> diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/clock.c
> index a7fc61976fd0..f3e2619db4e4 100644
> --- a/arch/arm64/kvm/hyp/nvhe/clock.c
> +++ b/arch/arm64/kvm/hyp/nvhe/clock.c
> @@ -30,7 +30,7 @@ static u64 __clock_mult_uint128(u64 cyc, u32 mult, u32 shift)
>  }
>  
>  /* Does not guarantee no reader on the modified bank. */
> -void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
> +void trace_hyp_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
>  {
>  	struct clock_data *clock = &trace_clock_data;
>  	u64 bank = clock->cur ^ 1;
> @@ -48,7 +48,7 @@ void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
>  }
>  
>  /* Use untrusted host data */
> -u64 trace_clock(void)
> +u64 trace_hyp_clock(void)
>  {
>  	struct clock_data *clock = &trace_clock_data;
>  	u64 bank = smp_load_acquire(&clock->cur);
> diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
> index e7e150ab265f..65be6c9fb379 100644
> --- a/arch/arm64/kvm/hyp/nvhe/trace.c
> +++ b/arch/arm64/kvm/hyp/nvhe/trace.c
> @@ -35,7 +35,7 @@ static bool hyp_trace_buffer_loaded(struct hyp_trace_buffer *trace_buffer)
>  void *tracing_reserve_entry(unsigned long length)
>  {
>  	return simple_ring_buffer_reserve(this_cpu_ptr(trace_buffer.simple_rbs), length,
> -					  trace_clock());
> +					  trace_hyp_clock());
>  }
>  
>  void tracing_commit_entry(void)
> @@ -290,7 +290,7 @@ void __tracing_update_clock(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
>  	}
>  
>  	/* ...we can now override the old one and swap. */
> -	trace_clock_update(mult, shift, epoch_ns, epoch_cyc);
> +	trace_hyp_clock_update(mult, shift, epoch_ns, epoch_cyc);
>  }
>  
>  int __tracing_reset(unsigned int cpu)
> -- 
> 2.55.0.795.g602f6c329a-goog
> 
