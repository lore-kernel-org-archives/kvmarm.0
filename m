Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB783A873A
	for <kvmarm@lists.linux.dev>; Sun, 12 Jul 2026 13:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783863905; cv=none; b=k6gnRnzCvHKThhPBPsac4WBl0dy7LebliSLc35P/XpTZrEP5KIHmMCiJ9T32uRlnxGCHgTEqzRpAnw5Y7mhr+q2+MYIqAFFMmaaNidRsfl2rFDTeeMnYC9CY4qiUOU4mrnaNsx0X9C5llKW3HjlzTvvtdkh5P2B1PbqI00nlLus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783863905; c=relaxed/simple;
	bh=AXZGh2qsEnhsJBJ9tb/EgXIirhdjZjiMPZit1Z9ULxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fSmcco7GKmRdfjR5DJF3csNOhr8mNLr4poJAEaMp7oq4PFJnsr5Sz7yQI83WdjN3UE+eFYdLXgyXIf0jvmI0SzBMhRFpEkOLwFSSPaE46bsxTClq7C3oJ/G9l/z+b7bBMYVSkhPaAS2Tv1RL4wXdWxTeVOPtgz0LM5GjvAtMT2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m/aEVz9q; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m/aEVz9q"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493c556ada3so56015e9.0
        for <kvmarm@lists.linux.dev>; Sun, 12 Jul 2026 06:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783863902; x=1784468702; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cB15QmrcA0tyUGkN33GVVZ7yR2pDZvCE9+bOTq+KGW8=;
        b=m/aEVz9qBoA7c3SAe4FILtDer3TQ01jgcyE3j+cEsujYo8WsZBmlVKZ9OCTBG5xvox
         q1FSMitIQB3Nm5QRI/8SGroIpjirX9k8dh70aODe+u1Thxt6NphOrRaTCTAomf+Nae+P
         DwmC4ZuSSdVLo6VO+5K1UMR5rqMjJqRdzHhe5KfyyMlliGweN/s/5SBkTZFvlynYBwIw
         f8u7vRIAJnnsq26M/WVvI3eo+kTCn7oFsrhY+ZAVSvKa/2ttpeF0t35Y2OG/HTcMs14P
         KS12+wBInYNhfivG3GGV0WC/Dc26MYZQIDQ9k8pu3tr3Y+5fVM4vUCKnYNujbaymCbts
         WW9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783863902; x=1784468702;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cB15QmrcA0tyUGkN33GVVZ7yR2pDZvCE9+bOTq+KGW8=;
        b=Di0cGE5JVxao7hHvWvqQxHgGLjImdaHzUoOKOPmtlCv3EMzIAOqiFFJsb7xJo6lr0U
         PdWCsoIb9V3cER8th2UKyEdKc7Rm2PlbEJ0Zu0+UE+h/h1XGhgNBb8klqc6Ta4LyIxF7
         NNgcvTKLe1XXOQsfZv9UBufHIBRQdB6yEoy6zdP3+49pJuQ3mEIFGXLvacigI80coHUF
         esP4PsjNe0A6oX5abUuTkFxjv9MSEOUD65uaDKz2bxKPPXVz8uZVTp7NNaWNTrCmV+0U
         HN39z9grdBmqXBC2l0GCrYhgtbsxzxY8je7QPbBgcyEHX/jD6LG+P636ncMUaf6ZEcDN
         sq2A==
X-Forwarded-Encrypted: i=1; AHgh+RodfYcZl7v37VEyUPlIBpjkPT1egPy/yA7FTn5hgbndYmzAj2SNLclFjcQaN9pcwqROmd8m3Zk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyEGXchCkhmcUITaJe26/iIBhZ8UKrH81QI6IfT35wShoxS9J48
	u1pqVkMEl9N8osjNfjZFtR7sAF2VEHVkCCfyGvM0yPuTy+K7fDgl0VAng573U/gY1Q==
X-Gm-Gg: AfdE7cmic5SUC7opfeVfCyztUHkqaYHcRPYRC3GW96Rr0K6LanxhXJ8s6gY2E11A402
	/Lnz8E8vmG+Odj06gdZ/C57anbcDtB9qr9nBN/bDSaFs6u20MmA1+yEz6lasxonOdZ7P/CoK1po
	3FC7Wg5PuK+wSpBe1dvYkqA5/CJVn6I/e68ahd3j01RgckOpWXXTOGS97dm0xhrQN+mLkvZPUxL
	HmG4kxseBqd4Txby4R/coTmb3l1yQo3KRx8gek0aGniixOBFyZlPrXmFTNg04YVpV2Z1K2ZUid/
	WC0NsOwgu+RZY8wUfu4eVeedBuqqsqriCzq64mgo2gZzMHIkeKgsY38V7x27JMCr8yOWvzO/30c
	DZ5wQqjnHkSz0Jp4zgoUbibsLg1g7ieZAAAvUQ36kdeagOwPadkWDnlsoac6CL9p8HM+gVH0CPU
	0VM2iOK9jiO2Tz+lsA7+S6ow0OQXWTAsOW2z0Xtcq5icli4IeKqC8rrlpkzzQ=
X-Received: by 2002:a05:600c:17c5:b0:493:b47f:a24 with SMTP id 5b1f17b1804b1-493f85a0c29mr1695425e9.6.1783863901494;
        Sun, 12 Jul 2026 06:45:01 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1e785sm76064126f8f.8.2026.07.12.06.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 06:44:59 -0700 (PDT)
Date: Sun, 12 Jul 2026 13:44:55 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	jgg@ziepe.ca, mark.rutland@arm.com, qperret@google.com,
	tabba@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 01/25] KVM: arm64: Generalize trace clock
Message-ID: <alOaV1q7t2mn_jOn@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-2-smostafa@google.com>
 <alD_hwRhUZ0IPTte@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alD_hwRhUZ0IPTte@google.com>

Hi Vincent,

On Fri, Jul 10, 2026 at 03:19:51PM +0100, Vincent Donnefort wrote:
> Hi Mostafa,
> 
> Sorry I should have looked at this a while ago!
> 
> On Fri, May 01, 2026 at 11:19:03AM +0000, Mostafa Saleh wrote:
> > IOMMU drivers need to track time, mainly for timeouts.
> > Generalize the tracing clock functions in the hypervsior, so they can
> > be used from IOMMU drivers.
> > 
> > 1) Make the compilation independent from tracing.
> > 
> > 2) As drivers might need to use that quite early, provide default
> >    values for the clock data based on cntfrq_el0, the driver can
> >    keep using these values without calling hyp_clock_update() as
> >    they don't need to sync with the host timers.
> > 
> > This is mainly used for timeouts, so a malicious host can DoS the
> > system or cause premature timeouts which likely end up in hyp panic,
> > that should be acceptable as neither of those would undermine the
> > security guarantees.
> 
> This still sounds very risky if the usage shift, and as I explain later I don't
> believe this is completely OK as regard to mult/shift updates.

I see, I still think it is not a security risk though.
My main concern is switching banks between polling might cause
problems.

> 
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/clock.h | 11 ++-----
> >  arch/arm64/kvm/hyp/nvhe/Makefile        |  4 +--
> >  arch/arm64/kvm/hyp/nvhe/clock.c         | 44 ++++++++++++++++++++++---
> >  arch/arm64/kvm/hyp/nvhe/setup.c         |  5 +++
> >  arch/arm64/kvm/hyp/nvhe/trace.c         |  4 +--
> >  5 files changed, 51 insertions(+), 17 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > index 9f429f5c0664..e6a0e43af88d 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > @@ -5,12 +5,7 @@
> >  
> >  #include <asm/kvm_hyp.h>
> >  
> > -#ifdef CONFIG_NVHE_EL2_TRACING
> > -void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> > -u64 trace_clock(void);
> > -#else
> > -static inline void
> > -trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
> > -static inline u64 trace_clock(void) { return 0; }
> > -#endif
> > +void hyp_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> > +u64 hyp_clock_ns(void);
> > +int hyp_clock_init(void);
> >  #endif
> > diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> > index 62cdfbff7562..89d0533921f9 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > @@ -26,10 +26,10 @@ hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
> >  	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
> >  	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
> >  hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
> > -	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o
> > +	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o clock.o
> >  hyp-obj-y += ../../../kernel/smccc-call.o
> >  hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
> > -hyp-obj-$(CONFIG_NVHE_EL2_TRACING) += clock.o trace.o events.o
> > +hyp-obj-$(CONFIG_NVHE_EL2_TRACING) += trace.o events.o
> >  hyp-obj-y += $(lib-objs)
> >  
> >  # Path to simple_ring_buffer.c
> > diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/clock.c
> > index 32fc4313fe43..53d0bd55e866 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/clock.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/clock.c
> > @@ -18,7 +18,41 @@ static struct clock_data {
> >  		u64 cyc_overflow64;
> >  	} data[2];
> >  	u64 cur;
> > -} trace_clock_data;
> > +} clock_data;
> 
> I believe this should be separated. the trace_clock is "unsafe" but synchronised
> with the host. the clock you need must be "safe" but we don't really need to be
> synchronised. 
> 
> So overall, I would keep all the trace_clock_* interface unchanged and introduce
> in the same file a hyp_clock, with its own hyp_clock_data.

Makes sense, I will do that, I will make the file compile outside of
tracing but I will keep the tracing code as is. I will introduce 2
functions to read the system timer and to init the hypervisor which
was similar to the earlier versions.

> 
> > +
> > +#define HYP_CLK_SEC_TO_NS 1000000000UL
> 
> Not possible to use NSEC_PER_SEC?
>

It should, we have to include include/vdso/time64.h for that.

> > +
> > +int hyp_clock_init(void)
> > +{
> > +	u32 timer_freq = read_sysreg(cntfrq_el0);
> > +	u32 shift = 32;
> > +	u64 mult;
> > +
> > +	/*
> > +	 * KVM will not initialize if FW didn't set cntfrq_el0, that is already
> > +	 * part of the boot protocol.
> > +	 */
> > +	if (!timer_freq)
> > +		return -ENODEV;
> > +
> > +	/* Timer freq can't be larger than 1Ghz by spec. */
> > +	if (timer_freq > HYP_CLK_SEC_TO_NS)
> > +		return -EINVAL;
> > +
> > +	/* Simplified logic from clocks_calc_mult_shift() */
> > +	do {
> > +		mult = (HYP_CLK_SEC_TO_NS << shift);
> > +		mult = div_u64(mult, timer_freq);
> > +		if (mult <= (~0U))
> > +			break;
> > +		shift--;
> > +	} while (shift > 0);
> > +
> > +	clock_data.data[0].shift = shift;
> > +	clock_data.data[0].mult = mult;
> > +	clock_data.data[0].cyc_overflow64 = ULONG_MAX / mult;
> 
> I don't know if we want to update this from time to time, but we can't rely on
> host provided data. Perhaps the call to that clock could self-update?
> 
> Worst case we fallback on 128-bits mult. but perhaps this isn't a problem for a
> wait loop()?
> 
> And as this is wait loop, perhaps we could reduce the resolution quite heavily,
> so we reduce the risk of overflow?

As mentioned, I will drop this and rely on a wrapper for the system
counter instead, and the caller can handle the overflow as in
__delay()

> 
> > +	return 0;
> > +}
> >  
> >  static u64 __clock_mult_uint128(u64 cyc, u32 mult, u32 shift)
> >  {
> > @@ -30,9 +64,9 @@ static u64 __clock_mult_uint128(u64 cyc, u32 mult, u32 shift)
> >  }
> >  
> >  /* Does not guarantee no reader on the modified bank. */
> 
>  ^
> And here's another reason why you should have another clock. It works because of
> tricks in the tracing interface.

Agreed, this was my concern too.

> 
> > -void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
> > +void hyp_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
> >  {
> > -	struct clock_data *clock = &trace_clock_data;
> > +	struct clock_data *clock = &clock_data;
> >  	u64 bank = clock->cur ^ 1;
> >  
> >  	clock->data[bank].mult			= mult;
> > @@ -45,9 +79,9 @@ void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
> >  }
> >  
> >  /* Use untrusted host data */
> > -u64 trace_clock(void)
> > +u64 hyp_clock_ns(void)
> >  {
> > -	struct clock_data *clock = &trace_clock_data;
> > +	struct clock_data *clock = &clock_data;
> >  	u64 bank = smp_load_acquire(&clock->cur);
> 
> The whole bank system is not necessary if not updated by the host.

But tracing can be enabled along side the SMMUv3.

Thanks,
Mostafa

