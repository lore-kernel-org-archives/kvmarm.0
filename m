Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E233955F9
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 08:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783929778; cv=none; b=VeyFZuPyQJJQMprHOvTnOxNEsRflK0eiiGSXbQ4QE9God1WdZeTYxDFD3iUNvuYGgZl/Kxxy2Q51WMH9VnU6M21X2c38U0N3Wj26b26l8aMtpVbo8tS8eVuxb1Ol3mIZcVp7Cn8G4iO8DdCf0IpCT+3gehITAH7DoxhXd/CYYy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783929778; c=relaxed/simple;
	bh=0Il60HPhYN8El4vcVpAIUvanEe/uUnAxZdvjILXmQsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iO/p0xvOYUIm81sfRjSzhce7754luPIVP3GB3x7WoRBOsJ3rxKuYaJrTiSpAz59vDfu8Ad6YZEIXfjQB10M60yG9S6bNWs17MwfuecN0/1qkyHguvTHFuUYNXb5JLoXV5SkIqNSEctEFzHa5VGRflv6S92aPs+RE02bGUEwlbCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tq+w4lMp; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tq+w4lMp"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493c19bad03so25151075e9.2
        for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 01:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783929774; x=1784534574; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ui/q0Z17SIjSQaEuUEryDLv/RC+iz2sf/IL8bGmgkiM=;
        b=tq+w4lMpVTdWybKl6fsNPUpdG+2uJP9xGraiRhgDIZ9Bcq0C+r0ly8csLicl25K8m2
         QBsuGvrink6NbusJwtOVzomHOPTHKQxQ68pJ+YPIcNPev8pQVevYIysdagCeT/JZnFsp
         uVTL6pEaFMylkhaqe+Gyoe5uoxqGlXGZa4G5N8IssoFJIQ2cQv/+j584sG+2/BKVphvI
         c+FPAJC9XB4kXZ1afQJarjj5jm5FW0xs8jUIh1nRr11Z7R+N53IFt+XRSWmD6wI/PMV7
         J2kt46l4f55o+XIgHwoSBn+EHKMPCc94HGkOVgiqLtVdnaCZMZgB4N25Zk081c5/8/oF
         gDNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783929774; x=1784534574;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Ui/q0Z17SIjSQaEuUEryDLv/RC+iz2sf/IL8bGmgkiM=;
        b=LvgbUSRa8zs4kB53YjNvhJe8pdjLcUfjuK+nZ2EIga/y3tPtKOJmiyrop+SeflW6BU
         zAelFlQU3NmgLrwDPkFswjycER5DpcGWShoJX4gz6GiGdE6OuXSWVoTnIY9QMJU+FcUJ
         blCVCEhBTNxRi4l956QMRfQaqyEQ2dBNZl+hYFJ72X6pBVEWFcXyTnVm2c7wa6ax/xYn
         iROoIKFRsmXRaZMaqaNWznB4CDQUDFp3THRcOns5iiM/RO/DCGdzDzv2LvhrAMIgVHf7
         ZJ/7yUHyhNZiATMRimOgTA/71YuTKFG+3agpZDPwDz399uHNbYddb0Ii+IGitIpSbptI
         /+Bw==
X-Forwarded-Encrypted: i=1; AHgh+RpiKo3duH7IbFhp2EPoni+VWVrcEyLyn8/GrbL7BPITsLrCDwmMOG5av/H7viFVeAKU1JO0SEE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwJfudfUMkNRMYXnY0on9pCX21ytNJj+eer590RAmreSyauebgJ
	LJB29YIxaG4j0UTTpXs40gDoHnwLxf0uwsFYkCN7/SZ6hjVMA7L13256NQBort9GPQ==
X-Gm-Gg: AfdE7cl25fCJeMUD22g8r5DFgXxk3I16XMe5VndMFvUaantpQnwewJdyR3wBSZ0OsW1
	0WbgsehashEJutLKv50026LBIAIrUp/nBgrfkeJY4zZY6ov9I7L+IANXctLtRuAJ5mZZT6cp1ND
	HPsotFs064qpLJmHQmLuRmrWpvdLrmcFXS6kx+Lf5i9iN+SPLVQspx6Cmcmmf4C+4eOsfDM1VhQ
	lILe0BouQ7rzTvhbq3WSHca/WcgdDibcdqLcUljY0gCkmItlYo+SDFa4dAUqMTRLP7oDf/iAooA
	1Z/2svCuSCCNuGeKZaLN4ciRPtR+Vfb1eNNLWzXLbbKXwD4dHpleuQ3l5dTyI7V9UsVH5R6ue5d
	FS8osBR4Mcvzh5Qea/KUQll8CO58/xQFDr4QecpP4liKbe3/zh/jOKU3nCfZaezPLAiJx3kqxdw
	RGbH5xzARtVgmwZxlrXOvEhOCgmgGt012XhPJ2BZrF3AGXcRvW7zE=
X-Received: by 2002:a05:600c:608e:b0:493:b03c:5650 with SMTP id 5b1f17b1804b1-493f8820806mr75041905e9.19.1783929773498;
        Mon, 13 Jul 2026 01:02:53 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2e77c2esm210021655e9.2.2026.07.13.01.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 01:02:52 -0700 (PDT)
Date: Mon, 13 Jul 2026 09:02:48 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oupton@kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, tabba@google.com
Subject: Re: [PATCH] KVM: arm64: Avoid naming collision in tracing
Message-ID: <alSbqDyV3Koez--u@google.com>
References: <20260712153835.2264905-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260712153835.2264905-1-smostafa@google.com>

On Sun, Jul 12, 2026 at 03:38:35PM +0000, Mostafa Saleh wrote:
> When the hypervisor tracing (CONFIG_NVHE_EL2_TRACING) is disabled, it
> defines a static inline stub for trace_clock().
> 
> However, trace_clock() is already declared as an extern function in
> linux/trace_clock.h which is pulled in EL2 compilation.

I am completely unable to reproduce that. CONFIG_NVHE_EL2_TRACING, isn't a
selectable option, it depends on NVHE_EL2_DEBUG.

How does your .config look like?

> 
> If the file <nvhe/clock.h> is included when CONFIG_NVHE_EL2_TRACING
> is disabled (by including it manually in setup.c) it will cause:
> In file included from arch/arm64/kvm/hyp/nvhe/setup.c:22:

nvhe/clock.h seems already included in setup.c

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
> 
> --
> I did not add Fixes tag as this is currently dormant and not breaking
> anything.
> ---
>  arch/arm64/kvm/hyp/include/nvhe/clock.h | 8 ++++----
>  arch/arm64/kvm/hyp/nvhe/clock.c         | 4 ++--
>  arch/arm64/kvm/hyp/nvhe/trace.c         | 4 ++--
>  3 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> index 9f429f5c0664..c2ccd0e8bf22 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/clock.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> @@ -6,11 +6,11 @@
>  #include <asm/kvm_hyp.h>
>  
>  #ifdef CONFIG_NVHE_EL2_TRACING
> -void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> -u64 trace_clock(void);
> +void hyp_trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> +u64 hyp_trace_clock(void);
>  #else
>  static inline void
> -trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
> -static inline u64 trace_clock(void) { return 0; }
> +hyp_trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
> +static inline u64 hyp_trace_clock(void) { return 0; }
>  #endif
>  #endif
> diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/clock.c
> index a7fc61976fd0..8adefb0b696c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/clock.c
> +++ b/arch/arm64/kvm/hyp/nvhe/clock.c
> @@ -30,7 +30,7 @@ static u64 __clock_mult_uint128(u64 cyc, u32 mult, u32 shift)
>  }
>  
>  /* Does not guarantee no reader on the modified bank. */
> -void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
> +void hyp_trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
>  {
>  	struct clock_data *clock = &trace_clock_data;
>  	u64 bank = clock->cur ^ 1;
> @@ -48,7 +48,7 @@ void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
>  }
>  
>  /* Use untrusted host data */
> -u64 trace_clock(void)
> +u64 hyp_trace_clock(void)
>  {
>  	struct clock_data *clock = &trace_clock_data;
>  	u64 bank = smp_load_acquire(&clock->cur);
> diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
> index e7e150ab265f..f2a32463c6c2 100644
> --- a/arch/arm64/kvm/hyp/nvhe/trace.c
> +++ b/arch/arm64/kvm/hyp/nvhe/trace.c
> @@ -35,7 +35,7 @@ static bool hyp_trace_buffer_loaded(struct hyp_trace_buffer *trace_buffer)
>  void *tracing_reserve_entry(unsigned long length)
>  {
>  	return simple_ring_buffer_reserve(this_cpu_ptr(trace_buffer.simple_rbs), length,
> -					  trace_clock());
> +					  hyp_trace_clock());
>  }
>  
>  void tracing_commit_entry(void)
> @@ -290,7 +290,7 @@ void __tracing_update_clock(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
>  	}
>  
>  	/* ...we can now override the old one and swap. */
> -	trace_clock_update(mult, shift, epoch_ns, epoch_cyc);
> +	hyp_trace_clock_update(mult, shift, epoch_ns, epoch_cyc);
>  }
>  
>  int __tracing_reset(unsigned int cpu)
> -- 
> 2.55.0.795.g602f6c329a-goog
> 
