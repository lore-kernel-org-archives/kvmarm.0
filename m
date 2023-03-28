Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3007E4
	for <kvmarm@lists.linux.dev>; Tue, 28 Mar 2023 22:37:11 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1a2104d8b00so60755ad.1
        for <kvmarm@lists.linux.dev>; Tue, 28 Mar 2023 15:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680043030;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G8/ShPdlrxP6qoJ+7uZdUIPgjUJdB7QJCFSyrMp059E=;
        b=KNXZEz2ZEMKAPaLwXU1Kki9OMtoysRO3T/RzTvfWh8XZWMaXOvNcM+wkeIC6dtJ5TZ
         wTY38lxLtmw8mrr4IjrM9qXZyZhnutJpWJ4GLMkSO9JPQQvPYSqvJ/Ef9HTP7ows7GwC
         +wCiGO226xh36SCvNe5K6HQNjhM1NpqN8+C4AZ99WRWY8o5BZCAzJMF7m0QbOTku+T3t
         jxDIXvHh15Rwj1k7rmYNIMw9UfJvqVv3kZGby/yuvyj4v++AD28gU8U4fVaHC0vwMcqN
         yVvYhtDncbccjAfuVE0IpBr22ScOjcjx9bzTf2Z/jiUKCWvH+DuaTbhemEhUAp/uCQgF
         LrKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680043030;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G8/ShPdlrxP6qoJ+7uZdUIPgjUJdB7QJCFSyrMp059E=;
        b=vLvKIBNmbUT4w7HyWYLEzeMcXl5PWAEsr4reYhxbGCs2zeMGiXgnGN+uRe2yP9B0ob
         MzAmI7RgYErrcsUZgbUrCSzGuTKD8SbLJE+NnC1+W6ig60Mdm4Vi35ng4p/C1vwCbFOL
         dqftbhsUiYIPnI66xcLE1kbxytjdsdUwPXyFjh8qT0tIacIaPBqdCxOtjAHaUr4qKr6f
         oNSwhIXm4ZTqX45azq62gqGZvu9LUnyWHAiYSkJ6y5TiUs8ETmJVmIzj45Jy5iymObQC
         wuF9/hTAmmsfYyFiS2MGzFvn1NQ3+llPI74k9IewjqL5HmyV7PU2vO5TWq4mICk/LoKl
         GEDA==
X-Gm-Message-State: AAQBX9cU4rmIUjsxUPZxh1S/KcyLFBwSEXK/z3vbLE8QQbQC+uqrbvK/
	s91jULsRf1VlUo5JEZlH3IN2kA==
X-Google-Smtp-Source: AKy350YCoGK/+fC7AlbxKOkWGrBOSv48LQpBuyFHfbSM2pf0T1HtCbEr1VNX7X89EIsR+5FL52xqUw==
X-Received: by 2002:a17:902:7616:b0:1a2:185a:cf7 with SMTP id k22-20020a170902761600b001a2185a0cf7mr32108pll.9.1680043030342;
        Tue, 28 Mar 2023 15:37:10 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id l62-20020a632541000000b004fb10399da2sm20483906pgl.56.2023.03.28.15.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 15:37:09 -0700 (PDT)
Date: Tue, 28 Mar 2023 15:37:05 -0700
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
	Will Deacon <will@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v1] KVM: arm64: PMU: Restore the guest's EL0 event
 counting after migration
Message-ID: <20230328223705.3thlifihm6q3wfcm@google.com>
References: <20230328034725.2051499-1-reijiw@google.com>
 <86pm8tw2ts.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86pm8tw2ts.wl-maz@kernel.org>

Hi Marc,

On Tue, Mar 28, 2023 at 12:08:31PM +0100, Marc Zyngier wrote:
> On Tue, 28 Mar 2023 04:47:25 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> > 
> > Currently, with VHE, KVM enables the EL0 event counting for the
> > guest on vcpu_load() or KVM enables it as a part of the PMU
> > register emulation process, when needed.  However, in the migration
> > case (with VHE), the same handling is lacking.  So, enable it on the
> > first KVM_RUN with VHE (after the migration) when needed.
> 
> It wasn't completely clear to me how the migration case was affected
> by this until I started digging into the call stack:
> 
> At load-time, the PMCR_EL0 effects haven't been propagated yet (the
> events haven't been created, as this is what kvm_pmu_handle_pmcr()
> does on first run). So there is an ordering inversion between
> kvm_pmu_handle_pmcr() and kvm_vcpu_pmu_restore_guest().
> 
> Moving the latter call into the former fixes the issue, completely
> emulating an extra write to PMCR_EL0.
> 
> I think it would be worth capturing some of the above in the commit
> message so that it doesn't get lost...

I agree with that. I will add the explanation in the commit message,
and will post v2.

> 
> > 
> > Fixes: d0c94c49792c ("KVM: arm64: Restore PMU configuration on first run")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/pmu-emul.c | 1 +
> >  arch/arm64/kvm/sys_regs.c | 1 -
> >  2 files changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index c243b10f3e15..5eca0cdd961d 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -558,6 +558,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
> >  		for_each_set_bit(i, &mask, 32)
> >  			kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, i), 0, true);
> >  	}
> > +	kvm_vcpu_pmu_restore_guest(vcpu);
> >  }
> >  
> >  static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 1b2c161120be..34688918c811 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -794,7 +794,6 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >  		if (!kvm_supports_32bit_el0())
> >  			val |= ARMV8_PMU_PMCR_LC;
> >  		kvm_pmu_handle_pmcr(vcpu, val);
> > -		kvm_vcpu_pmu_restore_guest(vcpu);
> >  	} else {
> >  		/* PMCR.P & PMCR.C are RAZ */
> >  		val = __vcpu_sys_reg(vcpu, PMCR_EL0)
> 
> With the nitpicking above addressed, and should this go into 6.3 as a
> fix:
> 
> Reviewed-by: Marc Zyngier <maz@kernel.org>

Thank you!
Reiji


> 
> I can otherwise take it into 6.4, depending on what Oliver decides to
> do.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
