Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D1E345CD0
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 14:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783693201; cv=none; b=H496fATjPf1PS6pLm8NY2Xncim5eNW7SXaWOeNfm12mauORBkPSa4LkHtM0ooRnY9x7uxSm5/qDShffKdNpdGJqT+UmLxVEs9uozYJ9zoPX8wAngK6bTFPmZNfn9IjG2ms03XiAit91VEmCkvbCUFwBtlH4KXgOrlRyuGYBtj28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783693201; c=relaxed/simple;
	bh=Els+C7J6iBlKFPQSSEkXbgrKxPtKaY3EAsgl3s1Sd/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BM60yQAu1mN+6l05LPIrQ9TSboXzuEWKkHsxdpjwRaeVhxhBoIeXormLBWxrA1+n4kEjIu1lzKdZYAC13T/bCw2e2iQipqCfojebA12o6f0imoRRu69V+g7DdBo34CIU8YKXbguSkPwnkgNe//6wM8zVOGMccBwNapy8QUwqirA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NeOYUTQN; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NeOYUTQN"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493b27c7451so25884495e9.0
        for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 07:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783693198; x=1784297998; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ld/XzT4yLi3Bj0NOD+nEBxEpkiiGab87Y26X7/8DxIM=;
        b=NeOYUTQNOoX9wFH5oQRRFn1JbRgCPEiSlUfh0HfHWUJNvf6sI0P+N2HArsI90s25P/
         p7i5nt9/l7hnn9MWRTxebugouO1EBmHVWq27bqBUg9aZEDpK4I2mg84wTg4HAAjABNbq
         dyKuHVeT7CbpLbqHT97Hm06H6OKyjJrEmzrbL+MWeTDgOEMuDw8tLBUdkv9zJTFwPYaS
         uPenmjdTiOAk4fCcDIen2QpOaNDlO9fTW8/t9bd2Y3WMsw6dmxQ0tiNRIGC01BwndUWO
         fAHb/968belEK5JH57vYa8eVcvWqiVUeOP3g48zukvKnZ55DyTSRTT3P/V02vMViUraF
         LO7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783693198; x=1784297998;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ld/XzT4yLi3Bj0NOD+nEBxEpkiiGab87Y26X7/8DxIM=;
        b=YRD85FRJcRcVnXxe1BOkvLZTssb7EQxRPSvDYtbZc9Psj9Bh0GMndXl9ynyBJofGNL
         yo9XQzkpxHwHNFFLGfKAfX3p06XMvv+dWp/T5A5egz7bQAVdhC8CgEq85SgnWbPQ1oiv
         /BPNAEY4UDjX5YhsS164ajShwxYgTZPdNPWBpSD9IpxaW+iQhrGdAgz16P3WVewxyEYJ
         GppYoqaDWG2sjFKRGQQ7SP1ZFMsKguutr0eIx1Gmd9m/jvJOVxBZElrc7on0GHHvyeuD
         eCWIldU4BpPZwzrZZi91tL7lCqKR2Hpfdw6c9lgWcZ0jHnM3UHqEA0xc5Ye9XzxDjmpM
         fboQ==
X-Forwarded-Encrypted: i=1; AHgh+RqfHehcdCz3u/6ZTWQVvr8ZWnzMZlTkhjhcYzbaiEN/eN6lxEZEb0WbMlr8pmICuOpBiNnywOw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxF9/KjSYwmDc7eXp2f+Gw84W6GPa3zD/kUNuiVA8EJ6vkcoS30
	dTi1LdKR+xNUISba5pZrt1SbQuilIL+0TGt1aiSU9Y/LDk4CnDlxdm6MpqAl5iiWbg==
X-Gm-Gg: AfdE7ckf8pw20k0ICz0I+SiZTvxiczsxFVe4iPbvlowUYGLbHtcMKg3sJ7OYzeXQnJB
	Nj+2MDoqYRCoyGVaC98fprXf72o5rs/z9+VI2rD0mONTYMegjRFwpGNEx3F3oniXXa8MMV4wVw8
	7q3nfgB8qy0+A8QeO+NCQh62q+9eyIMPhHPMi+wn73wfa6LMkq/9zXKBfeOLEP9BGzK3BaNqgNL
	l6NQAp0GEu2/phpvvyE30h9DIqHU2bU+4jno23cuACpCJN3LgCF76gmUbFF07BnEshXwwN7W9P1
	z9NIDzt7R9ncb7V9INlNe7Fd51YowdAEbdm/7vOuczLJX9kdkbIkDDREcqGW4+A0rB97BziGPfO
	m8EYEshw5B1hZW2bvBV2L+AE0leZwlvxjazxJLudSoMA/0bspqOgzJ3dZ4a4Y+DkyxNgZnGaij8
	rOOtvhOjnrF5+4koOZOiQNZ8DFeUCYRellHH/PKzU2xErSdq0X4HA=
X-Received: by 2002:a05:600c:8119:b0:493:ee34:d875 with SMTP id 5b1f17b1804b1-493f2b3369fmr37932565e9.10.1783693197951;
        Fri, 10 Jul 2026 07:19:57 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6ccdbbsm147470855e9.3.2026.07.10.07.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 07:19:55 -0700 (PDT)
Date: Fri, 10 Jul 2026 15:19:51 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	jgg@ziepe.ca, mark.rutland@arm.com, qperret@google.com,
	tabba@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 01/25] KVM: arm64: Generalize trace clock
Message-ID: <alD_hwRhUZ0IPTte@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-2-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501111928.259252-2-smostafa@google.com>

Hi Mostafa,

Sorry I should have looked at this a while ago!

On Fri, May 01, 2026 at 11:19:03AM +0000, Mostafa Saleh wrote:
> IOMMU drivers need to track time, mainly for timeouts.
> Generalize the tracing clock functions in the hypervsior, so they can
> be used from IOMMU drivers.
> 
> 1) Make the compilation independent from tracing.
> 
> 2) As drivers might need to use that quite early, provide default
>    values for the clock data based on cntfrq_el0, the driver can
>    keep using these values without calling hyp_clock_update() as
>    they don't need to sync with the host timers.
> 
> This is mainly used for timeouts, so a malicious host can DoS the
> system or cause premature timeouts which likely end up in hyp panic,
> that should be acceptable as neither of those would undermine the
> security guarantees.

This still sounds very risky if the usage shift, and as I explain later I don't
believe this is completely OK as regard to mult/shift updates.

> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/clock.h | 11 ++-----
>  arch/arm64/kvm/hyp/nvhe/Makefile        |  4 +--
>  arch/arm64/kvm/hyp/nvhe/clock.c         | 44 ++++++++++++++++++++++---
>  arch/arm64/kvm/hyp/nvhe/setup.c         |  5 +++
>  arch/arm64/kvm/hyp/nvhe/trace.c         |  4 +--
>  5 files changed, 51 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> index 9f429f5c0664..e6a0e43af88d 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/clock.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> @@ -5,12 +5,7 @@
>  
>  #include <asm/kvm_hyp.h>
>  
> -#ifdef CONFIG_NVHE_EL2_TRACING
> -void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> -u64 trace_clock(void);
> -#else
> -static inline void
> -trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
> -static inline u64 trace_clock(void) { return 0; }
> -#endif
> +void hyp_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> +u64 hyp_clock_ns(void);
> +int hyp_clock_init(void);
>  #endif
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index 62cdfbff7562..89d0533921f9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -26,10 +26,10 @@ hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
>  	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
>  	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
>  hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
> -	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o
> +	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o clock.o
>  hyp-obj-y += ../../../kernel/smccc-call.o
>  hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
> -hyp-obj-$(CONFIG_NVHE_EL2_TRACING) += clock.o trace.o events.o
> +hyp-obj-$(CONFIG_NVHE_EL2_TRACING) += trace.o events.o
>  hyp-obj-y += $(lib-objs)
>  
>  # Path to simple_ring_buffer.c
> diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/clock.c
> index 32fc4313fe43..53d0bd55e866 100644
> --- a/arch/arm64/kvm/hyp/nvhe/clock.c
> +++ b/arch/arm64/kvm/hyp/nvhe/clock.c
> @@ -18,7 +18,41 @@ static struct clock_data {
>  		u64 cyc_overflow64;
>  	} data[2];
>  	u64 cur;
> -} trace_clock_data;
> +} clock_data;

I believe this should be separated. the trace_clock is "unsafe" but synchronised
with the host. the clock you need must be "safe" but we don't really need to be
synchronised. 

So overall, I would keep all the trace_clock_* interface unchanged and introduce
in the same file a hyp_clock, with its own hyp_clock_data.

> +
> +#define HYP_CLK_SEC_TO_NS 1000000000UL

Not possible to use NSEC_PER_SEC?

> +
> +int hyp_clock_init(void)
> +{
> +	u32 timer_freq = read_sysreg(cntfrq_el0);
> +	u32 shift = 32;
> +	u64 mult;
> +
> +	/*
> +	 * KVM will not initialize if FW didn't set cntfrq_el0, that is already
> +	 * part of the boot protocol.
> +	 */
> +	if (!timer_freq)
> +		return -ENODEV;
> +
> +	/* Timer freq can't be larger than 1Ghz by spec. */
> +	if (timer_freq > HYP_CLK_SEC_TO_NS)
> +		return -EINVAL;
> +
> +	/* Simplified logic from clocks_calc_mult_shift() */
> +	do {
> +		mult = (HYP_CLK_SEC_TO_NS << shift);
> +		mult = div_u64(mult, timer_freq);
> +		if (mult <= (~0U))
> +			break;
> +		shift--;
> +	} while (shift > 0);
> +
> +	clock_data.data[0].shift = shift;
> +	clock_data.data[0].mult = mult;
> +	clock_data.data[0].cyc_overflow64 = ULONG_MAX / mult;

I don't know if we want to update this from time to time, but we can't rely on
host provided data. Perhaps the call to that clock could self-update?

Worst case we fallback on 128-bits mult. but perhaps this isn't a problem for a
wait loop()?

And as this is wait loop, perhaps we could reduce the resolution quite heavily,
so we reduce the risk of overflow?

> +	return 0;
> +}
>  
>  static u64 __clock_mult_uint128(u64 cyc, u32 mult, u32 shift)
>  {
> @@ -30,9 +64,9 @@ static u64 __clock_mult_uint128(u64 cyc, u32 mult, u32 shift)
>  }
>  
>  /* Does not guarantee no reader on the modified bank. */

 ^
And here's another reason why you should have another clock. It works because of
tricks in the tracing interface.

> -void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
> +void hyp_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
>  {
> -	struct clock_data *clock = &trace_clock_data;
> +	struct clock_data *clock = &clock_data;
>  	u64 bank = clock->cur ^ 1;
>  
>  	clock->data[bank].mult			= mult;
> @@ -45,9 +79,9 @@ void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
>  }
>  
>  /* Use untrusted host data */
> -u64 trace_clock(void)
> +u64 hyp_clock_ns(void)
>  {
> -	struct clock_data *clock = &trace_clock_data;
> +	struct clock_data *clock = &clock_data;
>  	u64 bank = smp_load_acquire(&clock->cur);

The whole bank system is not necessary if not updated by the host.

>  	u64 cyc, ns;
>  
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index d8e5b563fd3d..8041f6e80cd1 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -10,6 +10,7 @@
>  #include <asm/kvm_pgtable.h>
>  #include <asm/kvm_pkvm.h>
>  
> +#include <nvhe/clock.h>
>  #include <nvhe/early_alloc.h>
>  #include <nvhe/ffa.h>
>  #include <nvhe/gfp.h>
> @@ -312,6 +313,10 @@ void __noreturn __pkvm_init_finalise(void)
>  	};
>  	pkvm_pgtable.mm_ops = &pkvm_pgtable_mm_ops;
>  
> +	ret = hyp_clock_init();
> +	if (ret)
> +		goto out;
> +
>  	ret = fix_host_ownership();
>  	if (ret)
>  		goto out;
> diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
> index a6ca27b18e15..e30de840e6c2 100644
> --- a/arch/arm64/kvm/hyp/nvhe/trace.c
> +++ b/arch/arm64/kvm/hyp/nvhe/trace.c
> @@ -35,7 +35,7 @@ static bool hyp_trace_buffer_loaded(struct hyp_trace_buffer *trace_buffer)
>  void *tracing_reserve_entry(unsigned long length)
>  {
>  	return simple_ring_buffer_reserve(this_cpu_ptr(trace_buffer.simple_rbs), length,
> -					  trace_clock());
> +					  hyp_clock_ns());
>  }
>  
>  void tracing_commit_entry(void)
> @@ -285,7 +285,7 @@ void __tracing_update_clock(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
>  	}
>  
>  	/* ...we can now override the old one and swap. */
> -	trace_clock_update(mult, shift, epoch_ns, epoch_cyc);
> +	hyp_clock_update(mult, shift, epoch_ns, epoch_cyc);
>  }
>  
>  int __tracing_reset(unsigned int cpu)
> -- 
> 2.54.0.545.g6539524ca2-goog
> 
