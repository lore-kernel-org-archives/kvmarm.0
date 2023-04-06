Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF537ED
	for <kvmarm@lists.linux.dev>; Thu,  6 Apr 2023 02:28:43 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1a2104d8b00so132505ad.1
        for <kvmarm@lists.linux.dev>; Wed, 05 Apr 2023 19:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680748123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hXguFY8h5aiN5pGjbpoRIKuQBTDY/ONhMtdrEC8Fv+8=;
        b=KG7fB7R7PMvw3tql8dLjdgt9Y0JIn8mZc5eVun9hqmPHvX4H1wg/c/0dGfqwKZh75F
         rNGcEKds+5JE9qEZTvjPuv+aTpV/Xfw07eZrd90B0H8HkZ7w0g/kQJAeTMROJHGncigw
         Riw5vwXBXXXXQjEPScaQxJxfV66bDYtD5QlmAB4XfzY4kJEAHRodmT0E7LWvQnfHtNRH
         3yclnnh8TBzh0ZKdLeB5y/TSVLzY8Z2gWSJomdftPfbyTtgyxqfUzUS/n07bqv/UUwCz
         8Pukb9W/0MM38kQ9T3GTDxr/BncsWIJseTiXabu6UIDAtUCUCY9DoYVzVpkTuj0KTtt4
         Wh7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680748123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hXguFY8h5aiN5pGjbpoRIKuQBTDY/ONhMtdrEC8Fv+8=;
        b=mJSbgf1FYeWiEvhCp28/OiZjjQrm15EaFB597XjVeiFwmiU/8WL3JM7m6wVOySAzSs
         0SN3oeilzOZmXLi0Isv8I5oQU7aPUh3CrB4Tw9yxJMqwoB8/cd2e37fKHIwgn6R4EThS
         pd9WGeWbRsW4TEqEYa5wGO5PCDm6W3IesI5WjJa0Ir/qxVDzghpIU26wVI/5Dg43zXdL
         YTqRjkXIG8frWGT5OzEt/9fKXWWxm2ubBrtP7WzEYeTh+i2kXTJ+Wxy3Isd4aUdtIHwB
         CDTh6Nt3ifrbCiGX/Wa+zb6aaHW47cJz41QkSy7O+0PlHR+UnMyksYsPdcQJ7JUTmQQ/
         PeTg==
X-Gm-Message-State: AAQBX9euw9u3CxEEC37THPuWXmdg2HwjW9hkk2dbgKbO+af4VwcNB2qp
	CcSSInU2BL6UQhr4EvLC3dRuYw==
X-Google-Smtp-Source: AKy350Ygu1IrqtECJdIKy2koVgCo4UH+QArSzlZMXzvpa40LAdyBNT5y/CXQ6zIp7p68WbgZz0Mb+g==
X-Received: by 2002:a17:902:d706:b0:198:af4f:de0b with SMTP id w6-20020a170902d70600b00198af4fde0bmr66964ply.11.1680748122537;
        Wed, 05 Apr 2023 19:28:42 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id h9-20020a170902704900b001992e74d055sm220400plt.12.2023.04.05.19.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 19:28:41 -0700 (PDT)
Date: Wed, 5 Apr 2023 19:28:37 -0700
From: Reiji Watanabe <reijiw@google.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
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
Message-ID: <20230406022837.6wnk5elnccpolday@google.com>
References: <20230329002136.2463442-1-reijiw@google.com>
 <20230329002136.2463442-3-reijiw@google.com>
 <86jzyzwyrd.wl-maz@kernel.org>
 <ZCwzV7ACl21VbLru@FVFF77S0Q05N.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCwzV7ACl21VbLru@FVFF77S0Q05N.cambridge.arm.com>

On Tue, Apr 04, 2023 at 03:25:27PM +0100, Mark Rutland wrote:
> On Wed, Mar 29, 2023 at 01:03:18PM +0100, Marc Zyngier wrote:
> > On Wed, 29 Mar 2023 01:21:36 +0100,
> > Reiji Watanabe <reijiw@google.com> wrote:
> > > 
> > > Currently, with VHE, KVM sets ER, CR, SW and EN bits of
> > > PMUSERENR_EL0 to 1 on vcpu_load().  So, if the value of those bits
> > > are cleared after vcpu_load() (the perf subsystem would do when PMU
> > > counters are programmed for the guest), PMU access from the guest EL0
> > > might be trapped to the guest EL1 directly regardless of the current
> > > PMUSERENR_EL0 value of the vCPU.
> > 
> > + RobH.
> > 
> > Is that what is done when the event is created and armv8pmu_start()
> > called? This is... crap. The EL0 access thing breaks everything, and
> > nobody tested it with KVM, obviously.
> > 
> > I would be tempted to start mitigating it with the following:
> > 
> > diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> > index dde06c0f97f3..8063525bf3dd 100644
> > --- a/arch/arm64/kernel/perf_event.c
> > +++ b/arch/arm64/kernel/perf_event.c
> > @@ -806,17 +806,19 @@ static void armv8pmu_disable_event(struct perf_event *event)
> >  
> >  static void armv8pmu_start(struct arm_pmu *cpu_pmu)
> >  {
> > -	struct perf_event_context *ctx;
> > -	int nr_user = 0;
> > +	if (sysctl_perf_user_access) {
> > +		struct perf_event_context *ctx;
> > +		int nr_user = 0;
> >  
> > -	ctx = perf_cpu_task_ctx();
> > -	if (ctx)
> > -		nr_user = ctx->nr_user;
> > +		ctx = perf_cpu_task_ctx();
> > +		if (ctx)
> > +			nr_user = ctx->nr_user;
> >  
> > -	if (sysctl_perf_user_access && nr_user)
> > -		armv8pmu_enable_user_access(cpu_pmu);
> > -	else
> > -		armv8pmu_disable_user_access();
> > +		if (nr_user)
> > +			armv8pmu_enable_user_access(cpu_pmu);
> > +		else
> > +			armv8pmu_disable_user_access();
> > +	}
> >  
> >  	/* Enable all counters */
> >  	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
> > 
> > but that's obviously not enough as we want it to work with EL0 access
> > enabled on the host as well.
> > 
> > What we miss is something that tells the PMU code "we're in a context
> > where host userspace isn't present", and this would be completely
> > skipped, relying on KVM to restore the appropriate state on
> > vcpu_put(). But then the IPI stuff that controls EL0 can always come
> > in and wreck things. Gahhh...
> 
> AFAICT the perf code only writes to PMUSERENR_EL0 in contexts where IRQs (and
> hence preemption) are disabled, so as long as we have a shadow of the host
> PMUSERENR value somewhere, I think we can update the perf code with something
> like the below?
> 
> ... unless the KVM code is interruptible before saving the host value, or after
> restoring it?

Thank you for the suggestion.
I will update my patch based on the suggestion.

Thank you,
Reiji


> 
> Thanks,
> Mark.
> 
> ---->8----
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index dde06c0f97f3e..bdab3d5cbb5e3 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -741,11 +741,26 @@ static inline u32 armv8pmu_getreset_flags(void)
>         return value;
>  }
>  
> -static void armv8pmu_disable_user_access(void)
> +static void update_pmuserenr(u64 val)
>  {
> +       lockdep_assert_irqs_disabled();
> +
> +       if (IS_ENABLED(CONFIG_KVM)) {
> +               struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> +               if (vcpu) {
> +                       vcpu->arch.pmuserenr_host = val;
> +                       return;
> +               }
> +       }
> +
>         write_sysreg(0, pmuserenr_el0);
>  }
>  
> +static void armv8pmu_disable_user_access(void)
> +{
> +       update_pmuserenr(0);
> +}
> +
>  static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
>  {
>         int i;
> @@ -759,8 +774,7 @@ static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
>                         armv8pmu_write_evcntr(i, 0);
>         }
>  
> -       write_sysreg(0, pmuserenr_el0);
> -       write_sysreg(ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_CR, pmuserenr_el0);
> +       update_pmuserenr(ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_CR);
>  }
>  
>  static void armv8pmu_enable_event(struct perf_event *event)
> 
