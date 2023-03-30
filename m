Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E461854
	for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 03:55:52 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1a273b3b466so68725ad.1
        for <kvmarm@lists.linux.dev>; Wed, 29 Mar 2023 20:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680148551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+CVAOLuwD80Bd5PzmarfCnim42bOXcWvf05MWwjZBAE=;
        b=lc+fBWtgGa5qjeLygju1S5fN83HoFYZLDyYq1ypW9Q7+E5lruuj2wUMR7nYareVx6r
         KMxBoCBzpRTIn3oBWWck5U22wXDmjTOOzs1WzSzNRAaLFFjDMHBIKbLdWp+hqGo8faO/
         julebdE8XgdhEFX86mw7hM/RjBw9HOLloW66GUrYUzz9WPfqShMkUfcNipTpRE7m2SZG
         IzJBcymV6hSeoHy7vbsSTKOEEWELxXArcC/oqNU4fxgI1b2FRGrJCjTuaNu750gzQAHM
         f6mGGfCTwezdycufQGlLiUxlg6CySA4J9Rq0439XHF+25GhuvdN+FHinjEymEASeVs1u
         5NUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680148551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+CVAOLuwD80Bd5PzmarfCnim42bOXcWvf05MWwjZBAE=;
        b=lcCO2c9GC9eduS2txpZCk7I5ENvg4essKUgfWyX/DphCGalLVrryVJNw9hN4mM2ZjC
         9TnlMHbG6m7XQ57ut0kcFOatrB8paExfW7n6JWlX7URk+8ibP4YKqe10udFKCPnJpJFJ
         QMW2tmLlWM/KHYz1qR1Q0Q8aZhG5KeKkwXNg9vCZrO1njXYTHhiE3wwsxY8Gf/Hj8V7y
         EtHJNWwIWGT7cHJnKy9GdnAS6r1W+QQgmCWSddocc9G7LCZUZmzE7OgqhBxLFEBOMW6C
         w9kKaka4dXhYgw591K8XPH/Ic7/K/nEnCZWm/p0ozhr6wIonUOhIZxUypEJXUnZHR4fP
         /jrA==
X-Gm-Message-State: AAQBX9fOsDqpk9BUt96Z64ymvESQZh5tks1ZYtQg63D78WeuZ8bHKnQD
	RZW9ixneWFtXydPprRRnWx/1Hw==
X-Google-Smtp-Source: AKy350YjIPGrObbdmLjCfoFpURisbH1QkXA0e533gkNFg4lYQooMr7BEnC8qsxqYUP8WeXbcWjqc9A==
X-Received: by 2002:a17:903:12c6:b0:1a2:4b5:8677 with SMTP id io6-20020a17090312c600b001a204b58677mr23679plb.7.1680148551326;
        Wed, 29 Mar 2023 20:55:51 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id n2-20020aa79042000000b00625e885a6ffsm13718927pfo.18.2023.03.29.20.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 20:55:50 -0700 (PDT)
Date: Wed, 29 Mar 2023 20:55:46 -0700
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Raghavendra Rao Anata <rananta@google.com>,
	Will Deacon <will@kernel.org>, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v1 2/2] KVM: arm64: PMU: Ensure to trap PMU access from
 EL0 to EL2
Message-ID: <20230330035546.zosorjtilwccvc4m@google.com>
References: <20230329002136.2463442-1-reijiw@google.com>
 <20230329002136.2463442-3-reijiw@google.com>
 <86jzyzwyrd.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86jzyzwyrd.wl-maz@kernel.org>

Hi Marc,

On Wed, Mar 29, 2023 at 01:03:18PM +0100, Marc Zyngier wrote:
> On Wed, 29 Mar 2023 01:21:36 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> > 
> > Currently, with VHE, KVM sets ER, CR, SW and EN bits of
> > PMUSERENR_EL0 to 1 on vcpu_load().  So, if the value of those bits
> > are cleared after vcpu_load() (the perf subsystem would do when PMU
> > counters are programmed for the guest), PMU access from the guest EL0
> > might be trapped to the guest EL1 directly regardless of the current
> > PMUSERENR_EL0 value of the vCPU.
> 
> + RobH.
> 
> Is that what is done when the event is created and armv8pmu_start()
> called? 

Yes, that is it.

> This is... crap. The EL0 access thing breaks everything, and
> nobody tested it with KVM, obviously.

It was a bit shocking, as we detected those EL0 related
issues just with the first EL0 PMU test we ran...

> 
> I would be tempted to start mitigating it with the following:
> 
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index dde06c0f97f3..8063525bf3dd 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -806,17 +806,19 @@ static void armv8pmu_disable_event(struct perf_event *event)
>  
>  static void armv8pmu_start(struct arm_pmu *cpu_pmu)
>  {
> -	struct perf_event_context *ctx;
> -	int nr_user = 0;
> +	if (sysctl_perf_user_access) {
> +		struct perf_event_context *ctx;
> +		int nr_user = 0;
>  
> -	ctx = perf_cpu_task_ctx();
> -	if (ctx)
> -		nr_user = ctx->nr_user;
> +		ctx = perf_cpu_task_ctx();
> +		if (ctx)
> +			nr_user = ctx->nr_user;
>  
> -	if (sysctl_perf_user_access && nr_user)
> -		armv8pmu_enable_user_access(cpu_pmu);
> -	else
> -		armv8pmu_disable_user_access();
> +		if (nr_user)
> +			armv8pmu_enable_user_access(cpu_pmu);
> +		else
> +			armv8pmu_disable_user_access();
> +	}
>  
>  	/* Enable all counters */
>  	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
> 
> but that's obviously not enough as we want it to work with EL0 access
> enabled on the host as well.

Right, also with the change above, since PMUSERENR_EL0 isn't explicitly
cleared, a perf client (EL0) might have an access to counters.
(with the current code, a non-perf client might have an access to
counters though)


> What we miss is something that tells the PMU code "we're in a context
> where host userspace isn't present", and this would be completely

Could you please elaborate ?
I'm not sure if I understand the above correctly.
Since the task actually has the host userspace, which could be using
the PMU, and both the host EL0 and guest EL0 events are associated with
the task context of the perf_cpu_context, I think the "something" we
want to say would be subtle (I would assume it is similar to what we
meant with exclude_guest == 0 && exclude_host == 1 in the event attr
for the guest, in terms of events?).


> skipped, relying on KVM to restore the appropriate state on
> vcpu_put(). But then the IPI stuff that controls EL0 can always come
> in and wreck things. Gahhh...
> 
> I'm a bit reluctant to use the "save/restore all the time" hammer,
> because it only hides that the EL0 counter infrastructure is a bit
> broken.

Looking at the current code only, since KVM directly silently
modifies the PMU register (PMUSERENR_EL0) even though KVM is
a client of the perf in general, my original thought was
it made sense to have KVM restore the register value.


> > With VHE, fix this by setting those bits of the register on every
> > guest entry (as with nVHE).  Also, opportunistically make the similar
> > change for PMSELR_EL0, which is cleared by vcpu_load(), to ensure it
> > is always set to zero on guest entry (PMXEVCNTR_EL0 access might cause
> > UNDEF at EL1 instead of being trapped to EL2, depending on the value
> > of PMSELR_EL0).  I think that would be more robust, although I don't
> > find any kernel code that writes PMSELR_EL0.
> 
> This was changed a while ago to avoid using the selection register,
> see 0fdf1bb75953 ("arm64: perf: Avoid PMXEV* indirection"), and the
> rationale behind the reset of PMSELR_EL0 in 21cbe3cc8a48 ("arm64: KVM:
> pmu: Reset PMSELR_EL0.SEL to a sane value before entering the guest").
> 
> We *could* simply drop this zeroing of PMSELR_EL0 now that there is
> nothing else host-side that writes to it. But we need to agree on how
> to fix the above first.

We don't have to clear PMSELR_EL0 on every guest entry,
but I would think we still should do that at least in vcpu_load(),
since now the host EL0 could have a direct access to PMSELR_EL0.
(should be fine with the sane EL0 though)

Thank you,
Reiji
