Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B77CC4332F
	for <kvmarm@archiver.kernel.org>; Mon,  5 Dec 2022 18:50:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5AFB4B2F1;
	Mon,  5 Dec 2022 13:50:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q5Vdjr17MSVz; Mon,  5 Dec 2022 13:50:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FF4A4B125;
	Mon,  5 Dec 2022 13:50:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C93FF4089C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2022 13:50:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZaA1A9p58IBF for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Dec 2022 13:50:40 -0500 (EST)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 750F14042A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2022 13:50:40 -0500 (EST)
Received: by mail-pg1-f178.google.com with SMTP id w37so11282945pga.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Dec 2022 10:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=p5ashMmlbLpHS/ekdQ6Rli3d8exmQ4txWz1/CMHFXQk=;
 b=GlALXVUVyecG1mOEFO21aXN1nBxC1f9g38wb9bXfpUl8Wgjy0xAtLTM2LaB3YxJ7/q
 x+fY+IFN9JVmqQ2JYJACVJsrBxsvE+qM3S5RfUK+NN5je79JbIGHvoGdd24y4HsUGWk9
 9+ywZIvougKMLPZ2DGq1i7x0rqiiQ0DQwoCmjUgJigXqREQGm6/zbQAKXDnoR9uvb2PT
 xBSXwFW9bHfA8xKAgNu3q6t4zjhzvCM5cmhD5oUl7NmjmD5pYIoOCQ1L0hFNTAtIEXFl
 BMf2gUvK8vxrI3ILX9IIOws45ZGxZlv9IyioR3V5tHqupBZEc0bCe3L7gtkMRRXU0qYk
 c+qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=p5ashMmlbLpHS/ekdQ6Rli3d8exmQ4txWz1/CMHFXQk=;
 b=7+Lqhu0gy5kfgTG9ZAG7r+n2BvPSX91QsxrLJEKvB2y0hF1m9tEjgk5KixNzHRbixY
 xZWVpqVYKEsiITgDvDWNuOOcGZYFj8FSFNlMPzCLJ0v17db6lS8mbJM/6fr0m8TsRwk9
 ++OffECbR2WA9ML/r/wNjzf6tMRwAVl0dc+NYrflYHgAMEcKAvNJYhDqELk/cra2SstC
 8qvwyM2Q4rONYbbpGJbBwu1Phrpa8YMRcBAw9bhxqhOYfn2iNHfGpIPLuaXRfPVy81lu
 CG8hhJ3Y+w6IqvLiIsz+KOh/9hK1v7aJBaEADBCujjdS5KQ+qHo1tmxW6LOOmpl6dBnY
 +wPg==
X-Gm-Message-State: ANoB5pnH8EIx0awRyqXDfWGrlREK540xXa/O4faQjuh6j6b6H/qVovbO
 BeeGVzio43/hHOYRmxy1XlzWIA==
X-Google-Smtp-Source: AA0mqf5twGUsQSeEi1/4s7d6sQeK1iMb4NejovSmn0WyEQ+wyi5jPiXs8MAqwng6CVsoyRqnvMgjMQ==
X-Received: by 2002:a05:6a00:198d:b0:569:92fa:cbbc with SMTP id
 d13-20020a056a00198d00b0056992facbbcmr66701255pfl.77.1670266239153; 
 Mon, 05 Dec 2022 10:50:39 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 q100-20020a17090a1b6d00b00218ddc8048bsm11243965pjq.34.2022.12.05.10.50.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 05 Dec 2022 10:50:38 -0800 (PST)
Date: Mon, 5 Dec 2022 10:50:35 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 04/16] KVM: arm64: PMU: Distinguish between 64bit
 counter and 64bit overflow
Message-ID: <Y449e7dMzf1zaOh4@google.com>
References: <20221113163832.3154370-1-maz@kernel.org>
 <20221113163832.3154370-5-maz@kernel.org>
 <Y4jasyxvFRNvvmox@google.com> <Y4jbosgHbUDI0WF4@google.com>
 <86zgc2kqcz.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86zgc2kqcz.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Dec 05, 2022 at 12:05:32PM +0000, Marc Zyngier wrote:
> On Thu, 01 Dec 2022 16:51:46 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Thu, Dec 01, 2022 at 08:47:47AM -0800, Ricardo Koller wrote:
> > > On Sun, Nov 13, 2022 at 04:38:20PM +0000, Marc Zyngier wrote:
> > > > The PMU architecture makes a subtle difference between a 64bit
> > > > counter and a counter that has a 64bit overflow. This is for example
> > > > the case of the cycle counter, which can generate an overflow on
> > > > a 32bit boundary if PMCR_EL0.LC==0 despite the accumulation being
> > > > done on 64 bits.
> > > > 
> > > > Use this distinction in the few cases where it matters in the code,
> > > > as we will reuse this with PMUv3p5 long counters.
> > > > 
> > > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > > ---
> > > >  arch/arm64/kvm/pmu-emul.c | 43 ++++++++++++++++++++++++++++-----------
> > > >  1 file changed, 31 insertions(+), 12 deletions(-)
> > > > 
> > > > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > > > index 69b67ab3c4bf..d050143326b5 100644
> > > > --- a/arch/arm64/kvm/pmu-emul.c
> > > > +++ b/arch/arm64/kvm/pmu-emul.c
> > > > @@ -50,6 +50,11 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
> > > >   * @select_idx: The counter index
> > > >   */
> > > >  static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
> > > > +{
> > > > +	return (select_idx == ARMV8_PMU_CYCLE_IDX);
> > > > +}
> > > > +
> > > > +static bool kvm_pmu_idx_has_64bit_overflow(struct kvm_vcpu *vcpu, u64 select_idx)
> > > >  {
> > > >  	return (select_idx == ARMV8_PMU_CYCLE_IDX &&
> > > >  		__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
> > > > @@ -57,7 +62,8 @@ static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
> > > >  
> > > >  static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u64 idx)
> > > >  {
> > > > -	return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX);
> > > > +	return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX &&
> > > > +		!kvm_pmu_idx_has_64bit_overflow(vcpu, idx));
> > > >  }
> > > >  
> > > >  static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
> > > > @@ -97,7 +103,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> > > >  		counter += perf_event_read_value(pmc->perf_event, &enabled,
> > > >  						 &running);
> > > >  
> > > > -	if (select_idx != ARMV8_PMU_CYCLE_IDX)
> > > > +	if (!kvm_pmu_idx_is_64bit(vcpu, select_idx))
> > > >  		counter = lower_32_bits(counter);
> > > >  
> > > >  	return counter;
> > > > @@ -423,6 +429,23 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
> > > >  	}
> > > >  }
> > > >  
> > > > +/* Compute the sample period for a given counter value */
> > > > +static u64 compute_period(struct kvm_vcpu *vcpu, u64 select_idx, u64 counter)
> > > > +{
> > > > +	u64 val;
> > > > +
> > > > +	if (kvm_pmu_idx_is_64bit(vcpu, select_idx)) {
> > > > +		if (!kvm_pmu_idx_has_64bit_overflow(vcpu, select_idx))
> > > > +			val = -(counter & GENMASK(31, 0));
> > > 
> > > If I understand things correctly, this might be missing another mask:
> > > 
> > > +		if (!kvm_pmu_idx_has_64bit_overflow(vcpu, select_idx)) {
> > > +			val = -(counter & GENMASK(31, 0));
> > > +			val &= GENMASK(31, 0);
> > > +		} else {
> > > 
> > > For example, if the counter is 64-bits wide, it overflows at 32-bits,
> > > and it is _one_ sample away from overflowing at 32-bits:
> > > 
> > > 	0x01010101_ffffffff
> > > 
> > > Then "val = (-counter) & GENMASK(63, 0)" would return 0xffffffff_00000001.
> > 
> > Sorry, this should be:
> > 
> > 	Then "val = -(counter & GENMASK(31, 0))" would return 0xffffffff_00000001.
> > 
> > > But the right period is 0x00000000_00000001 (it's one sample away from
> > > overflowing).
> 
> Yup, this is a bit bogus. But this can be simplified by falling back
> to the normal 32bit handling (on top of the pmu-unchained branch):
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index d8ea39943086..24908400e190 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -461,14 +461,10 @@ static u64 compute_period(struct kvm_pmc *pmc, u64 counter)
>  {
>  	u64 val;
>  
> -	if (kvm_pmc_is_64bit(pmc)) {
> -		if (!kvm_pmc_has_64bit_overflow(pmc))
> -			val = -(counter & GENMASK(31, 0));
> -		else
> -			val = (-counter) & GENMASK(63, 0);
> -	} else {
> +	if (kvm_pmc_is_64bit(pmc) && kvm_pmc_has_64bit_overflow(pmc))

Great, thanks! Yes, that definitely makes things simpler ^.

> +		val = (-counter) & GENMASK(63, 0);
> +	else
>  		val = (-counter) & GENMASK(31, 0);
> -	}
>  
>  	return val;
>  }
> 
> which satisfies the requirement without any extra masking, and makes
> it plain that only a 64bit counter with 64bit overflow gets its period
> computed on the full 64bit, and that anyone else gets the 32bit
> truncation.
> 
> I'll stash yet another patch on top and push it onto -next.
> 
> Thanks!
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
