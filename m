Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C767473
	for <kvmarm@lists.linux.dev>; Thu,  1 Dec 2022 16:51:50 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id x13-20020a17090a46cd00b00218f611b6e9so2653242pjg.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Dec 2022 08:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vTY+8zbB0KLCO6w0Ejf7JKks2CQ81Juv1hZh5NUQZR4=;
        b=c2tDzLnwBzOZzqviYzit1W1/hj0S+WHGqFBG67B3f014LVPjpgKuphY8pgHLNJEhKX
         rhdrNHHIxdP/IH+KoaJv1ex/0Ea7kLjT/hyOZ+w7qEbjgwgUsyxutS1qpPVbTa5fxMsJ
         3bGQ5f6h+Mmr2kpnXnJKqZFNic3Sy62qxsFhJHgitibcuPZuuRcMPSe/to1zaadGZ2q4
         TUNpyR0HI8HE5Kzfnws4K8x8fftdyFGt19wwqa0rLS2ENbD7qoQ787Ttm2KUt5uDV6v1
         Nh77eHD1xFwa5fKDgsSZWV8pRJZNVWBIBfnuyyMPUDeKk1ZfQOw91OnGcq0KP4l7KMgm
         UJLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vTY+8zbB0KLCO6w0Ejf7JKks2CQ81Juv1hZh5NUQZR4=;
        b=vfbWG8iO962dAJg0K0y3xaeP5MKCb3QL5iatygvb5FuVbEAxm9ITAdf4roPdJvzy9F
         KBaE0YF3Vj/M8/wBh5VIEx1MTwguH6w6etfnEpIocPNcQ4SvIMTpTk07LBaGRi0N4pwZ
         QRdddPxzPij/AnTzMXSSkOAV8Dwa9B475JgyTymfsCBj9p0GjFjc6bQUFTO/9zqRIpbx
         g7VbL6PaEHPIk1w4k+aQVWlpkNgvsxipAhTbTqCtQzu7Xkkj3TlPHRGfMy9xy1ww4X0F
         o5/Ys6VQXQxfyMzdMh0SIpTSZjq553DjvQMi1WlF2v56+qU9a+KJJYiYBUVvRU922KM/
         qXmQ==
X-Gm-Message-State: ANoB5pkoDu1qZG04oO7wuREP1ftUwZw3sBDWLTu+uEH9IDztamssGYM5
	X2i8Ax5kRrrZG6QByM0F8izoHg==
X-Google-Smtp-Source: AA0mqf5UZ9qHBSuQEb51ccUtt96/EYaqD9BX/Idpdnx6b6AJi+o87tpAhwiganp1cvDCxUMzAoT9UA==
X-Received: by 2002:a17:903:240b:b0:186:9fc5:6c2c with SMTP id e11-20020a170903240b00b001869fc56c2cmr48339955plo.174.1669913509971;
        Thu, 01 Dec 2022 08:51:49 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id ij19-20020a170902ab5300b001769e6d4fafsm3865136plb.57.2022.12.01.08.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 08:51:49 -0800 (PST)
Date: Thu, 1 Dec 2022 08:51:46 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v4 04/16] KVM: arm64: PMU: Distinguish between 64bit
 counter and 64bit overflow
Message-ID: <Y4jbosgHbUDI0WF4@google.com>
References: <20221113163832.3154370-1-maz@kernel.org>
 <20221113163832.3154370-5-maz@kernel.org>
 <Y4jasyxvFRNvvmox@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4jasyxvFRNvvmox@google.com>
Message-ID: <20221201165146.y7gbOa9Bq82xxQG2FppbZdRJnGanpk0V_SOhmelPw2Q@z>

On Thu, Dec 01, 2022 at 08:47:47AM -0800, Ricardo Koller wrote:
> On Sun, Nov 13, 2022 at 04:38:20PM +0000, Marc Zyngier wrote:
> > The PMU architecture makes a subtle difference between a 64bit
> > counter and a counter that has a 64bit overflow. This is for example
> > the case of the cycle counter, which can generate an overflow on
> > a 32bit boundary if PMCR_EL0.LC==0 despite the accumulation being
> > done on 64 bits.
> > 
> > Use this distinction in the few cases where it matters in the code,
> > as we will reuse this with PMUv3p5 long counters.
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/kvm/pmu-emul.c | 43 ++++++++++++++++++++++++++++-----------
> >  1 file changed, 31 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index 69b67ab3c4bf..d050143326b5 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -50,6 +50,11 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
> >   * @select_idx: The counter index
> >   */
> >  static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
> > +{
> > +	return (select_idx == ARMV8_PMU_CYCLE_IDX);
> > +}
> > +
> > +static bool kvm_pmu_idx_has_64bit_overflow(struct kvm_vcpu *vcpu, u64 select_idx)
> >  {
> >  	return (select_idx == ARMV8_PMU_CYCLE_IDX &&
> >  		__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
> > @@ -57,7 +62,8 @@ static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
> >  
> >  static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u64 idx)
> >  {
> > -	return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX);
> > +	return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX &&
> > +		!kvm_pmu_idx_has_64bit_overflow(vcpu, idx));
> >  }
> >  
> >  static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
> > @@ -97,7 +103,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> >  		counter += perf_event_read_value(pmc->perf_event, &enabled,
> >  						 &running);
> >  
> > -	if (select_idx != ARMV8_PMU_CYCLE_IDX)
> > +	if (!kvm_pmu_idx_is_64bit(vcpu, select_idx))
> >  		counter = lower_32_bits(counter);
> >  
> >  	return counter;
> > @@ -423,6 +429,23 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
> >  	}
> >  }
> >  
> > +/* Compute the sample period for a given counter value */
> > +static u64 compute_period(struct kvm_vcpu *vcpu, u64 select_idx, u64 counter)
> > +{
> > +	u64 val;
> > +
> > +	if (kvm_pmu_idx_is_64bit(vcpu, select_idx)) {
> > +		if (!kvm_pmu_idx_has_64bit_overflow(vcpu, select_idx))
> > +			val = -(counter & GENMASK(31, 0));
> 
> If I understand things correctly, this might be missing another mask:
> 
> +		if (!kvm_pmu_idx_has_64bit_overflow(vcpu, select_idx)) {
> +			val = -(counter & GENMASK(31, 0));
> +			val &= GENMASK(31, 0);
> +		} else {
> 
> For example, if the counter is 64-bits wide, it overflows at 32-bits,
> and it is _one_ sample away from overflowing at 32-bits:
> 
> 	0x01010101_ffffffff
> 
> Then "val = (-counter) & GENMASK(63, 0)" would return 0xffffffff_00000001.

Sorry, this should be:

	Then "val = -(counter & GENMASK(31, 0))" would return 0xffffffff_00000001.

> But the right period is 0x00000000_00000001 (it's one sample away from
> overflowing).
> 
> > +		else
> > +			val = (-counter) & GENMASK(63, 0);
> > +	} else {
> > +		val = (-counter) & GENMASK(31, 0);
> > +	}
> > +
> > +	return val;
> > +}
> > +
> >  /**
> >   * When the perf event overflows, set the overflow status and inform the vcpu.
> >   */
> > @@ -442,10 +465,7 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
> >  	 * Reset the sample period to the architectural limit,
> >  	 * i.e. the point where the counter overflows.
> >  	 */
> > -	period = -(local64_read(&perf_event->count));
> > -
> > -	if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
> > -		period &= GENMASK(31, 0);
> > +	period = compute_period(vcpu, idx, local64_read(&perf_event->count));
> >  
> >  	local64_set(&perf_event->hw.period_left, 0);
> >  	perf_event->attr.sample_period = period;
> > @@ -571,14 +591,13 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
> >  
> >  	/*
> >  	 * If counting with a 64bit counter, advertise it to the perf
> > -	 * code, carefully dealing with the initial sample period.
> > +	 * code, carefully dealing with the initial sample period
> > +	 * which also depends on the overflow.
> >  	 */
> > -	if (kvm_pmu_idx_is_64bit(vcpu, select_idx)) {
> > +	if (kvm_pmu_idx_is_64bit(vcpu, select_idx))
> >  		attr.config1 |= PERF_ATTR_CFG1_COUNTER_64BIT;
> > -		attr.sample_period = (-counter) & GENMASK(63, 0);
> > -	} else {
> > -		attr.sample_period = (-counter) & GENMASK(31, 0);
> > -	}
> > +
> > +	attr.sample_period = compute_period(vcpu, select_idx, counter);
> >  
> >  	event = perf_event_create_kernel_counter(&attr, -1, current,
> >  						 kvm_pmu_perf_overflow, pmc);
> > -- 
> > 2.34.1
> > 
> > 
