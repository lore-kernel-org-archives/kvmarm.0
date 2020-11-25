Return-Path: <SRS0=WvL8=E7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A99DC5519F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Nov 2020 10:39:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D56C20857
	for <kvmarm@archiver.kernel.org>; Wed, 25 Nov 2020 10:39:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="A+RK8cDs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D56C20857
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAE3C4B8E0;
	Wed, 25 Nov 2020 05:39:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pkECDKpERpfx; Wed, 25 Nov 2020 05:39:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E1B14B8E1;
	Wed, 25 Nov 2020 05:39:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5563D4B8DF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 05:39:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p6XdQbmMpD-p for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Nov 2020 05:39:50 -0500 (EST)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EFE7E4B8DB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 05:39:49 -0500 (EST)
Received: by mail-wm1-f65.google.com with SMTP id a3so1659195wmb.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 02:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=xjb50VmueVKvqfo83tIt6FtxJUt2q7MIPJuzBp9Cqbo=;
 b=A+RK8cDsGXYGQGBcYpxEmIt9L6vCtE88Xe75D9UGls4BQT0srylt2atki0IdqYN+F8
 KHVAparz7lzg+ll7G5+dQPzbmvVehE1E7oBEhWuRGFsPOltGxytLaqnvz/BacEvxAUiT
 MG2fWNegQZKhzcVtfW8Zs0U6CWVtQKAETunMjnXfu3Q5BofAKBNo5jj3NJzalOOM7byV
 gWY4Ue2+4EFNZDej3P+jOZ+G2d9eak0NJQ6ixAiaCJxGJhduroRDFMD3AeNeoYFhtyab
 bCXUU6JLvPuBfP1epmbuGojXtVooYaP7r5MorXNy8vEFa1QFlmvP69u32JpithQ/LZ3J
 8L8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xjb50VmueVKvqfo83tIt6FtxJUt2q7MIPJuzBp9Cqbo=;
 b=RTLymqpRfzx11P3Zx+b28pC46VkqB8JrbxPbMFuqgtuhGgRKJIV7cNpBCI1FBe0pm8
 CDVgY/gjqDim2PJq4h41qseFwaahFCGKMcPh4752Njq0JCrZoVv75aF4hAD4FRyklB5U
 zY5MgMuQ1qFhd0O1A/10srhkAYorWE1boFngTbutf4/WcuYk3IjYvZ3u8DBl2t07GS1z
 xFx3fIoJneQWRsg3bpr92kd185Xq1V4haVFrepWZBcqg9/9nZBUagPB0zQSwtuyl6IuG
 HDHs9v/pmnl1lbYOfjNlYmJW53NeoMR8swBFo6kFDYMwej1tJFs5cGFV49iCj3iBvaAe
 8zNA==
X-Gm-Message-State: AOAM5320LyasuYHuDPPf7Ce/W4+bpu7lw2Y+QRMdRlQlJCzgfP4IY4vH
 o79RFvhVwk54/+/zqeBjTS1a/g==
X-Google-Smtp-Source: ABdhPJxNbgpC4Qt2/Bi063B58JqJVa8ChBTVh7QS2nzzb1U4glQNyD2Yffl1fAQn/K9PsT2PTBviLA==
X-Received: by 2002:a7b:c843:: with SMTP id c3mr3159938wml.100.1606300788652; 
 Wed, 25 Nov 2020 02:39:48 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:38bf:5817:e665:9b9b])
 by smtp.gmail.com with ESMTPSA id s4sm4093475wru.56.2020.11.25.02.39.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 25 Nov 2020 02:39:47 -0800 (PST)
Date: Wed, 25 Nov 2020 10:39:46 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 06/24] kvm: arm64: Move hyp-init params to a per-CPU
 struct
Message-ID: <20201125103946.2unmclsdfqpr3eyk@google.com>
References: <20201116204318.63987-1-dbrazdil@google.com>
 <20201116204318.63987-7-dbrazdil@google.com>
 <87lfes5f54.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87lfes5f54.wl-maz@kernel.org>
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Mon, Nov 23, 2020 at 02:20:07PM +0000, Marc Zyngier wrote:
> On Mon, 16 Nov 2020 20:43:00 +0000,
> David Brazdil <dbrazdil@google.com> wrote:
> > 
> > Once we start initializing KVM on newly booted cores before the rest of
> > the kernel, parameters to __do_hyp_init will need to be provided by EL2
> > rather than EL1. At that point it will not be possible to pass its four
> > arguments directly because PSCI_CPU_ON only supports one context
> > argument.
> > 
> > Refactor __do_hyp_init to accept its parameters in a struct. This
> > prepares the code for KVM booting cores as well as removes any limits on
> > the number of __do_hyp_init arguments.
> > 
> > Signed-off-by: David Brazdil <dbrazdil@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h   |  7 +++++++
> >  arch/arm64/include/asm/kvm_hyp.h   |  4 ++++
> >  arch/arm64/kernel/asm-offsets.c    |  4 ++++
> >  arch/arm64/kvm/arm.c               | 26 ++++++++++++++------------
> >  arch/arm64/kvm/hyp/nvhe/hyp-init.S | 21 ++++++++++-----------
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c |  2 ++
> >  6 files changed, 41 insertions(+), 23 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index 54387ccd1ab2..01904e88cead 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -150,6 +150,13 @@ extern void *__vhe_undefined_symbol;
> >  
> >  #endif
> >  
> > +struct kvm_nvhe_init_params {
> > +	unsigned long tpidr_el2;
> > +	unsigned long vector_hyp_va;
> > +	unsigned long stack_hyp_va;
> > +	phys_addr_t pgd_pa;
> > +};
> > +
> >  /* Translate a kernel address @ptr into its equivalent linear mapping */
> >  #define kvm_ksym_ref(ptr)						\
> >  	({								\
> > diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> > index 6b664de5ec1f..a3289071f3d8 100644
> > --- a/arch/arm64/include/asm/kvm_hyp.h
> > +++ b/arch/arm64/include/asm/kvm_hyp.h
> > @@ -15,6 +15,10 @@
> >  DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
> >  DECLARE_PER_CPU(unsigned long, kvm_hyp_vector);
> >  
> > +#ifdef __KVM_NVHE_HYPERVISOR__
> > +DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
> > +#endif
> 
> I'm not sure we should bother with this #ifdefery. Having the
> declaration present at all times doesn't really hurt, since it is only
> defined in the HYP code. Cutting down on the conditionals would
> certainly help readability.
> 
> > +
> >  #define read_sysreg_elx(r,nvh,vh)					\
> >  	({								\
> >  		u64 reg;						\
> > diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> > index 7d32fc959b1a..4435ad8be938 100644
> > --- a/arch/arm64/kernel/asm-offsets.c
> > +++ b/arch/arm64/kernel/asm-offsets.c
> > @@ -110,6 +110,10 @@ int main(void)
> >    DEFINE(CPU_APGAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APGAKEYLO_EL1]));
> >    DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
> >    DEFINE(HOST_DATA_CONTEXT,	offsetof(struct kvm_host_data, host_ctxt));
> > +  DEFINE(NVHE_INIT_TPIDR_EL2,	offsetof(struct kvm_nvhe_init_params, tpidr_el2));
> > +  DEFINE(NVHE_INIT_VECTOR_HYP_VA,	offsetof(struct kvm_nvhe_init_params, vector_hyp_va));
> > +  DEFINE(NVHE_INIT_STACK_HYP_VA,	offsetof(struct kvm_nvhe_init_params, stack_hyp_va));
> > +  DEFINE(NVHE_INIT_PGD_PA,	offsetof(struct kvm_nvhe_init_params, pgd_pa));
> >  #endif
> >  #ifdef CONFIG_CPU_PM
> >    DEFINE(CPU_CTX_SP,		offsetof(struct cpu_suspend_ctx, sp));
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index c0ffb019ca8b..4838556920fb 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -50,6 +50,7 @@ DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
> >  
> >  static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
> >  unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
> > +DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
> >  
> >  /* The VMID used in the VTTBR */
> >  static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
> > @@ -1347,10 +1348,7 @@ static int kvm_map_vectors(void)
> >  
> >  static void cpu_init_hyp_mode(void)
> >  {
> > -	phys_addr_t pgd_ptr;
> > -	unsigned long hyp_stack_ptr;
> > -	unsigned long vector_ptr;
> > -	unsigned long tpidr_el2;
> > +	struct kvm_nvhe_init_params *params = this_cpu_ptr_nvhe_sym(kvm_init_params);
> >  	struct arm_smccc_res res;
> >  
> >  	/* Switch from the HYP stub to our own HYP init vector */
> > @@ -1361,13 +1359,18 @@ static void cpu_init_hyp_mode(void)
> >  	 * kernel's mapping to the linear mapping, and store it in tpidr_el2
> >  	 * so that we can use adr_l to access per-cpu variables in EL2.
> >  	 */
> > -	tpidr_el2 = (unsigned long)this_cpu_ptr_nvhe_sym(__per_cpu_start) -
> > -		    (unsigned long)kvm_ksym_ref(CHOOSE_NVHE_SYM(__per_cpu_start));
> > +	params->tpidr_el2 = (unsigned long)this_cpu_ptr_nvhe_sym(__per_cpu_start) -
> > +			    (unsigned long)kvm_ksym_ref(CHOOSE_NVHE_SYM(__per_cpu_start));
> >  
> > -	pgd_ptr = kvm_mmu_get_httbr();
> > -	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
> > -	hyp_stack_ptr = kern_hyp_va(hyp_stack_ptr);
> > -	vector_ptr = (unsigned long)kern_hyp_va(kvm_ksym_ref(__kvm_hyp_host_vector));
> > +	params->vector_hyp_va = (unsigned long)kern_hyp_va(kvm_ksym_ref(__kvm_hyp_host_vector));
> > +	params->stack_hyp_va = kern_hyp_va(__this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE);
> > +	params->pgd_pa = kvm_mmu_get_httbr();
> 
> Note to self: rename this to kvm_mmu_get_hyp_pgd() (another AArch32-ism).
> 
> > +
> > +	/*
> > +	 * Flush the init params from the data cache because the struct will
> > +	 * be read while the MMU is off.
> > +	 */
> > +	__flush_dcache_area(params, sizeof(*params));
> 
> nit: please use kvm_flush_dcache_to_poc(), as it clearly indicates to
> which point we are flushing.

Will change, but out of curiosity - how is it different? AFAICT, it is just
an alias with a single use in __clean_dcache_guest_page:

  #define kvm_flush_dcache_to_poc(a,l)	__flush_dcache_area((a), (l))

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
