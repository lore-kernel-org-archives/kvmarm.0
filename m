Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEBFEC433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 11:08:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6106364F5E
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 11:08:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6106364F5E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9F534B28B;
	Thu,  4 Feb 2021 06:08:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0mn0sI37+Ad2; Thu,  4 Feb 2021 06:08:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 571974B25C;
	Thu,  4 Feb 2021 06:08:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAF9C4B24E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 06:08:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uIq9EWWG7GrA for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 06:08:38 -0500 (EST)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com
 [209.85.128.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F04284B1E7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 06:08:37 -0500 (EST)
Received: by mail-wm1-f52.google.com with SMTP id t142so582336wmt.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Feb 2021 03:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Ac2cWoetiRazQ6sY02jAtUWhjT9m83ovv4OBQ4t/wAE=;
 b=A4pYkiXZ376bPY33RfHADMh/Av+CR5JRDGbuuLfF8edaHdTjgTDmNsL2P1wbxBnu9n
 6+VHNCMB4m+vXPsgmT/sW4vL31F9UfF1V2/d/I8u6zAhT2cr8tHLj6ujCg8u3or8NhU4
 9AjHewTcziPuwb5SF88UTdGtsaLLRiNGclmWIKW3x3YMCcy2J0SjCm6qzOOWHJHt/eM6
 EYA3/kcSK3f54psGOhTOHB2+XqczNu8pRisvRhZCpksIye+1a4Y4eSaW8/tkW02FenGC
 QYEwJmjsOfZ8SYkGnHTWHzwFxibFw5swOcjMKpm1B40MPRK43AUPNO2plnYy2tAau8AV
 cXDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Ac2cWoetiRazQ6sY02jAtUWhjT9m83ovv4OBQ4t/wAE=;
 b=jg7th1zuoSOrh0vrL+eXFnPs3G4NR02CAcwNKz42s7E6srsEWOphg0XwwbLHCBEHPu
 9tjOHOn6CqmvtVHbcPo19pPKRcaSpStNQL6iqIqoAfDpBttVsA2HGx8EbIQrzuPWaLTu
 ImeBRZZgeZt5dqi5jxW/ehnT/c7dJCvnLOawOwgmsoxHc+gYWIz1Y54gbI8lNhIjVHRY
 gXQq6Iuu77OtNHtZO11dueHQFEOY98Qfu1jy/ZcSu4ty6kHEstWwYYM2hAFBH1zXizul
 SGPcWE2m8NILSMOuF+c9EnSQqMy+UL/iiieh8cYzr8JInmpRhPuIJFtiG8fVqNNbVZZX
 vWGA==
X-Gm-Message-State: AOAM530BoGiF0tlOj1teUd8+NE11ANs+YdZtZozLvMUH7AP1ZUYiq89E
 hcRNbfYnWryozGC1g7ZjpLb01A==
X-Google-Smtp-Source: ABdhPJxofrOU9QtBbx8B1URQt7oPE0DC7M1sC/q1/8AlgNixgkixfYv7H9DmSmdVl0NIFGKJzk2aIg==
X-Received: by 2002:a1c:d7:: with SMTP id 206mr7022487wma.68.1612436916642;
 Thu, 04 Feb 2021 03:08:36 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id w25sm5923406wmc.42.2021.02.04.03.08.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Feb 2021 03:08:36 -0800 (PST)
Date: Thu, 4 Feb 2021 11:08:33 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH v2 17/26] KVM: arm64: Elevate Hyp mappings creation
 at EL2
Message-ID: <YBvVseNd/r8q5He1@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-18-qperret@google.com>
 <20210203153138.GB18974@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210203153138.GB18974@willie-the-truck>
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On Wednesday 03 Feb 2021 at 15:31:39 (+0000), Will Deacon wrote:
> On Fri, Jan 08, 2021 at 12:15:15PM +0000, Quentin Perret wrote:
> > Previous commits have introduced infrastructure at EL2 to enable the Hyp
> > code to manage its own memory, and more specifically its stage 1 page
> > tables. However, this was preliminary work, and none of it is currently
> > in use.
> > 
> > Put all of this together by elevating the hyp mappings creation at EL2
> > when memory protection is enabled. In this case, the host kernel running
> > at EL1 still creates _temporary_ Hyp mappings, only used while
> > initializing the hypervisor, but frees them right after.
> > 
> > As such, all calls to create_hyp_mappings() after kvm init has finished
> > turn into hypercalls, as the host now has no 'legal' way to modify the
> > hypevisor page tables directly.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_mmu.h |  1 -
> >  arch/arm64/kvm/arm.c             | 62 +++++++++++++++++++++++++++++---
> >  arch/arm64/kvm/mmu.c             | 34 ++++++++++++++++++
> >  3 files changed, 92 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > index d7ebd73ec86f..6c8466a042a9 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -309,6 +309,5 @@ static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
> >  	 */
> >  	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
> >  }
> > -
> >  #endif /* __ASSEMBLY__ */
> >  #endif /* __ARM64_KVM_MMU_H__ */
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 6af9204bcd5b..e524682c2ccf 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1421,7 +1421,7 @@ static void cpu_prepare_hyp_mode(int cpu)
> >  	kvm_flush_dcache_to_poc(params, sizeof(*params));
> >  }
> >  
> > -static void cpu_init_hyp_mode(void)
> > +static void kvm_set_hyp_vector(void)
> 
> Please do something about the naming: now we have both cpu_set_hyp_vector()
> and kvm_set_hyp_vector()!

I'll try to find something different, but no guarantees it'll be much
better :) Suggestions welcome.

> >  {
> >  	struct kvm_nvhe_init_params *params;
> >  	struct arm_smccc_res res;
> > @@ -1439,6 +1439,11 @@ static void cpu_init_hyp_mode(void)
> >  	params = this_cpu_ptr_nvhe_sym(kvm_init_params);
> >  	arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__kvm_hyp_init), virt_to_phys(params), &res);
> >  	WARN_ON(res.a0 != SMCCC_RET_SUCCESS);
> > +}
> > +
> > +static void cpu_init_hyp_mode(void)
> > +{
> > +	kvm_set_hyp_vector();
> >  
> >  	/*
> >  	 * Disabling SSBD on a non-VHE system requires us to enable SSBS
> > @@ -1481,7 +1486,10 @@ static void cpu_set_hyp_vector(void)
> >  	struct bp_hardening_data *data = this_cpu_ptr(&bp_hardening_data);
> >  	void *vector = hyp_spectre_vector_selector[data->slot];
> >  
> > -	*this_cpu_ptr_hyp_sym(kvm_hyp_vector) = (unsigned long)vector;
> > +	if (!is_protected_kvm_enabled())
> > +		*this_cpu_ptr_hyp_sym(kvm_hyp_vector) = (unsigned long)vector;
> > +	else
> > +		kvm_call_hyp_nvhe(__pkvm_cpu_set_vector, data->slot);
> 
> *Very* minor nit, but it might be cleaner to have static inline functions
> with the same prototypes as the hypercalls, just to make the code even
> easier to read. e.g
> 
> 	if (!is_protected_kvm_enabled())
> 		_cpu_set_vector(data->slot);
> 	else
> 		kvm_call_hyp_nvhe(__pkvm_cpu_set_vector, data->slot);
> 
> you could then conceivably wrap that in a macro and avoid having the
> "is_protected_kvm_enabled()" checks explicit every time.

Happy to do this here, but are you suggesting to generalize this pattern
to other places as well?

> >  }
> >  
> >  static void cpu_hyp_reinit(void)
> > @@ -1489,13 +1497,14 @@ static void cpu_hyp_reinit(void)
> >  	kvm_init_host_cpu_context(&this_cpu_ptr_hyp_sym(kvm_host_data)->host_ctxt);
> >  
> >  	cpu_hyp_reset();
> > -	cpu_set_hyp_vector();
> >  
> >  	if (is_kernel_in_hyp_mode())
> >  		kvm_timer_init_vhe();
> >  	else
> >  		cpu_init_hyp_mode();
> >  
> > +	cpu_set_hyp_vector();
> > +
> >  	kvm_arm_init_debug();
> >  
> >  	if (vgic_present)
> > @@ -1714,13 +1723,52 @@ static int copy_cpu_ftr_regs(void)
> >  	return 0;
> >  }
> >  
> > +static int kvm_hyp_enable_protection(void)
> > +{
> > +	void *per_cpu_base = kvm_ksym_ref(kvm_arm_hyp_percpu_base);
> > +	int ret, cpu;
> > +	void *addr;
> > +
> > +	if (!is_protected_kvm_enabled())
> > +		return 0;
> 
> Maybe I'm hung up on my previous suggestion, but I feel like we shouldn't
> get here if protected kvm isn't enabled.

The alternative is to move this check next to the call site, but it
won't help much IMO.

> 
> > +	if (!hyp_mem_base)
> > +		return -ENOMEM;
> > +
> > +	addr = phys_to_virt(hyp_mem_base);
> > +	ret = create_hyp_mappings(addr, addr + hyp_mem_size - 1, PAGE_HYP);
> > +	if (ret)
> > +		return ret;
> > +
> > +	preempt_disable();
> > +	kvm_set_hyp_vector();
> > +	ret = kvm_call_hyp_nvhe(__pkvm_init, hyp_mem_base, hyp_mem_size,
> > +				num_possible_cpus(), kern_hyp_va(per_cpu_base));
> 
> Would it make sense for the __pkvm_init() hypercall to set the vector as
> well, so that we wouldn't need to disable preemption over two hypercalls?

Not sure, kvm_set_hyp_vector() itself already does multiple hypercalls,
and I need it separate from __pkvm_init for secondary CPUs.

> Failing that, maybe move the whole preempt_disable/enable sequence into
> another function.

But that I can do.

> > +	preempt_enable();
> > +	if (ret)
> > +		return ret;
> > +
> > +	free_hyp_pgds();
> > +	for_each_possible_cpu(cpu)
> > +		free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
> > +
> > +	return 0;
> > +}
> > +
> >  /**
> >   * Inits Hyp-mode on all online CPUs
> >   */
> >  static int init_hyp_mode(void)
> >  {
> >  	int cpu;
> > -	int err = 0;
> > +	int err = -ENOMEM;
> > +
> > +	/*
> > +	 * The protected Hyp-mode cannot be initialized if the memory pool
> > +	 * allocation has failed.
> > +	 */
> > +	if (is_protected_kvm_enabled() && !hyp_mem_base)
> > +		return err;
> >  
> >  	/*
> >  	 * Copy the required CPU feature register in their EL2 counterpart
> > @@ -1854,6 +1902,12 @@ static int init_hyp_mode(void)
> >  	for_each_possible_cpu(cpu)
> >  		cpu_prepare_hyp_mode(cpu);
> >  
> > +	err = kvm_hyp_enable_protection();
> > +	if (err) {
> > +		kvm_err("Failed to enable hyp memory protection: %d\n", err);
> > +		goto out_err;
> > +	}
> > +
> >  	return 0;
> >  
> >  out_err:
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 3cf9397dabdb..9d4c9251208e 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -225,15 +225,39 @@ void free_hyp_pgds(void)
> >  	if (hyp_pgtable) {
> >  		kvm_pgtable_hyp_destroy(hyp_pgtable);
> >  		kfree(hyp_pgtable);
> > +		hyp_pgtable = NULL;
> >  	}
> >  	mutex_unlock(&kvm_hyp_pgd_mutex);
> >  }
> >  
> > +static bool kvm_host_owns_hyp_mappings(void)
> > +{
> > +	if (static_branch_likely(&kvm_protected_mode_initialized))
> > +		return false;
> > +
> > +	/*
> > +	 * This can happen at boot time when __create_hyp_mappings() is called
> > +	 * after the hyp protection has been enabled, but the static key has
> > +	 * not been flipped yet.
> > +	 */
> > +	if (!hyp_pgtable && is_protected_kvm_enabled())
> > +		return false;
> > +
> > +	BUG_ON(!hyp_pgtable);
> 
> Can we fail more gracefully, e.g. by continuing without KVM?

Got any suggestion as to how that can be done? We could also just remove
that line -- that really should not happen.

Thanks!
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
