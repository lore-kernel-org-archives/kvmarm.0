Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D690646
	for <kvmarm@lists.linux.dev>; Sat, 27 May 2023 04:17:05 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1b025aaeddbso48445ad.1
        for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 21:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685161024; x=1687753024;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tTkVIXYjWmne41FQ3L+MqOdG7qcUyKdU8JEYz2d+D7Q=;
        b=jjTph/L+q/4Xr3luAS5gZM1ly8cWMAZuFXX5bIzxO9CMCOycUEsHzriNHfdqMgJRsj
         4cjyZ90416g+nPcCNHV6LaNExyTKxOlHW5GLPoJEti3I7EzW2jY2C5w6H1VxvVJxQtxt
         qIFOgoqylZVQJr5ebDaUyqKYOqQb+BRoNAQg+tAupOWWhYxHS0NZNhg5O9Pv2+kSnGVd
         eeWOxJS6wGVqCmIRyarEvHNW3EM8NQlSzKK8u87YMz9/ciMNnlvbhO/k5zc/mAYuBM3F
         iOVF9raJzJju/gfsJIp3IxoJLGcDAAGwxFT+GVSWS/UPG+zdTtOIr/Qy24b99GnsNDWc
         4usw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685161024; x=1687753024;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tTkVIXYjWmne41FQ3L+MqOdG7qcUyKdU8JEYz2d+D7Q=;
        b=iM/q92klSvje1d9xgvZFxeZIm7X7yKngmTgHlRtWvr/36CvpzKsPs/Yr2F9DyJzHwm
         Lpu+P87pnkW57aIFHYHKqN8SpujUarJqrpSvCu3+Ss0wkXU/N5u4pjinEymBHs9eiW7x
         5wBdeHAE3JibsP9Bk0mYZGd7LcC4ZfjgAyKKbu8ynCfFEAeZw16fnLLpwD6g8bEecC5v
         io0JAs/M+E7F9BZ4RhV9v8M1AEJiVC3DOT7F6c/bXScNyAYu+9bUh4Bs146NLdZFvnvC
         JFrtL81pcpSDhQ/NmJeXJtO3i4w/CTu9i1kyYqasxuL5FKgOVl5ljJCcikOWeySYdAhN
         FjCQ==
X-Gm-Message-State: AC+VfDzSiM/wxgODs5sH/PUNFb8ruuSe5JcYw02SQqRhdBoq4K/AHeB/
	5LwTJrY9wbkAHJ6/Qab6Rj7VlQ==
X-Google-Smtp-Source: ACHHUZ5DaOGqibQNNDW0I0W+/JEbCkQd8Ae7x++7CZXwBh74PbWHKgNbD6xrC8JOc4mOiVkoXAVZGA==
X-Received: by 2002:a17:903:228e:b0:1b0:cea:294d with SMTP id b14-20020a170903228e00b001b00cea294dmr109847plh.20.1685161024446;
        Fri, 26 May 2023 21:17:04 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id g18-20020a170902869200b001b0034557afsm2681019plo.15.2023.05.26.21.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 21:17:03 -0700 (PDT)
Date: Fri, 26 May 2023 21:16:58 -0700
From: Reiji Watanabe <reijiw@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Raghavendra Rao Anata <rananta@google.com>,
	Shaoqin Huang <shahuang@redhat.com>, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 2/2] KVM: arm64: PMU: Don't overwrite PMUSERENR with
 vcpu loaded
Message-ID: <20230527041658.zgftvtaskylzmr6l@google.com>
References: <20230415164029.526895-1-reijiw@google.com>
 <20230415164029.526895-3-reijiw@google.com>
 <ZG/w95pYjWnMJB62@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZG/w95pYjWnMJB62@linux.dev>

Hi Oliver,

On Thu, May 25, 2023 at 11:36:23PM +0000, Oliver Upton wrote:
> Hi Reiji,
> 
> Apologies, this fell off my list of reviews.
> 
> On Sat, Apr 15, 2023 at 09:40:29AM -0700, Reiji Watanabe wrote:
> 
> [...]
> 
> >  static void armv8pmu_enable_event(struct perf_event *event)
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index 6718731729fd..7e73be12cfaf 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -82,12 +82,24 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
> >  	 */
> >  	if (kvm_arm_support_pmu_v3()) {
> >  		struct kvm_cpu_context *hctxt;
> > +		unsigned long flags;
> >  
> >  		write_sysreg(0, pmselr_el0);
> >  
> >  		hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> > +
> > +		/*
> > +		 * Disable IRQs to prevent a race condition between the
> > +		 * following code and IPIs that attempts to update
> > +		 * PMUSERENR_EL0. See also kvm_set_pmuserenr().
> > +		 */
> > +		local_irq_save(flags);
> > +
> >  		ctxt_sys_reg(hctxt, PMUSERENR_EL0) = read_sysreg(pmuserenr_el0);
> >  		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
> > +		vcpu_set_flag(vcpu, PMUSERENR_ON_CPU);
> > +
> > +		local_irq_restore(flags);
> 
> Can the IRQ save/restore be moved to {activate,deactivate}_traps_vhe_{load,put}()?
> 
> That'd eliminate the dance to avoid using kernel-only symbols in nVHE
> and would be consistent with the existing usage of
> __{activate,deactivate}_traps_common() from nVHE (IRQs already
> disabled).
> 
> IMO, the less nVHE knows about the kernel the better.

Thank you for the comments.
Sure, I will move them to {activate,deactivate}_traps_vhe_{load,put}().


> 
> >  	}
> >  
> >  	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
> > @@ -112,9 +124,21 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
> >  	write_sysreg(0, hstr_el2);
> >  	if (kvm_arm_support_pmu_v3()) {
> >  		struct kvm_cpu_context *hctxt;
> > +		unsigned long flags;
> >  
> >  		hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> > +
> > +		/*
> > +		 * Disable IRQs to prevent a race condition between the
> > +		 * following code and IPIs that attempts to update
> > +		 * PMUSERENR_EL0. See also kvm_set_pmuserenr().
> > +		 */
> > +		local_irq_save(flags);
> > +
> >  		write_sysreg(ctxt_sys_reg(hctxt, PMUSERENR_EL0), pmuserenr_el0);
> > +		vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
> > +
> > +		local_irq_restore(flags);
> >  	}
> >  
> >  	if (cpus_have_final_cap(ARM64_SME)) {
> > diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> > index 530347cdebe3..2c08a54ca7d9 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > @@ -10,7 +10,7 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS
> >  # will explode instantly (Words of Marc Zyngier). So introduce a generic flag
> >  # __DISABLE_TRACE_MMIO__ to disable MMIO tracing for nVHE KVM.
> >  ccflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS -D__DISABLE_TRACE_MMIO__
> > -ccflags-y += -fno-stack-protector	\
> > +ccflags-y += -fno-stack-protector -DNO_TRACE_IRQFLAGS \
> >  	     -DDISABLE_BRANCH_PROFILING	\
> >  	     $(DISABLE_STACKLEAK_PLUGIN)
> >  
> > diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> > index 7887133d15f0..d6a863853bfe 100644
> > --- a/arch/arm64/kvm/pmu.c
> > +++ b/arch/arm64/kvm/pmu.c
> > @@ -209,3 +209,28 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
> >  	kvm_vcpu_pmu_enable_el0(events_host);
> >  	kvm_vcpu_pmu_disable_el0(events_guest);
> >  }
> > +
> > +/*
> > + * With VHE, keep track of the PMUSERENR_EL0 value for the host EL0 on the pCPU
> > + * where PMUSERENR_EL0 for the guest is loaded, since PMUSERENR_EL0 is switched
> > + * to the value for the guest on vcpu_load().  The value for the host EL0
> > + * will be restored on vcpu_put(), before returning to the EL0.
> 
> wording: s/the EL0/EL0. Or, alternatively, to avoid repeating yourself
> you can just say "returning to userspace".
> 
> You may also want to mention in passing why this isn't necessary for
> nVHE, as the register is context switched for every guest enter/exit.

Thank you for the suggestions. I will fix those.

Thank you,
Reiji


> 
> > + *
> > + * Return true if KVM takes care of the register. Otherwise return false.
> > + */
> > +bool kvm_set_pmuserenr(u64 val)
> > +{
> > +	struct kvm_cpu_context *hctxt;
> > +	struct kvm_vcpu *vcpu;
> > +
> > +	if (!kvm_arm_support_pmu_v3() || !has_vhe())
> > +		return false;
> > +
> > +	vcpu = kvm_get_running_vcpu();
> > +	if (!vcpu || !vcpu_get_flag(vcpu, PMUSERENR_ON_CPU))
> > +		return false;
> > +
> > +	hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> > +	ctxt_sys_reg(hctxt, PMUSERENR_EL0) = val;
> > +	return true;
> > +}
> 
> -- 
> Thanks,
> Oliver
