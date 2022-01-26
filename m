Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69501C28CF5
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 05:22:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D690F49DE3;
	Wed, 26 Jan 2022 00:22:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lsInhB5OWDNf; Wed, 26 Jan 2022 00:22:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5502F40DCB;
	Wed, 26 Jan 2022 00:22:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF560408F4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 00:22:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f9Yq66Nla7g8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 00:22:23 -0500 (EST)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8139E408BA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 00:22:23 -0500 (EST)
Received: by mail-pl1-f180.google.com with SMTP id c3so21402388pls.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 21:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=NOoWjvyVLqfIkw2JFMhzZWLlrGE6AAdot/2kzaXU3VI=;
 b=EjAEeSuUX32yK4JahNfTxSoeN7Z/GDGdGWMaRX6msmxldrmUbUIlxaJfuNyehuENzP
 XJ/Y8XThsBptZnW5xRXQTEPtkAkGr/0k3kLgomgTty3iAjouf3iNXc4efK2y3ugEW/hI
 g2Tj+udzGglj9XgGRZGE+a6FOIGlxmHGRPgcXAFZPSaHelO/aMIPsPHF814UjrYI9uUP
 dGY3bfB1KZkM/AXwLWdQ50wThEcRBPtjr4jSeqNsp/4Kjd/Lfa7vkCpQP6n1jPRh2mAD
 vLd28jAQpgSJQxpIRnO26qcsbn5ra6/9XJzu4dCe/ZaDDpsWkoxp/VZ+6Cc1mcDZ3C/L
 4oSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=NOoWjvyVLqfIkw2JFMhzZWLlrGE6AAdot/2kzaXU3VI=;
 b=g5bQn6g8N0GT+25m8tHSuYglwxzfTuZ3Jus0xgZUSoZPxHR+hKH9ZtrquMjRd2SuIm
 6UaZ6rcy2tjuFLwBnOVWx/Egu4g3v5Ny1psF1l5cruQXXMCIv4ymltl/ZpjfIEYoFubc
 sm6oRgLMNXTk3ejAwJmo/P9YGiXIkKY8de+/7wLCLJNuh4TUKDbFdJjvPrwP+m8jQmHD
 D66V9IlfROi1vjmPitHdE8ZDA7Z0Xde5gKT1cke0uHrnA6E/w0X1dmeRHc8AOAUmjuLQ
 AkrLZiWJhxaTeiWOQLzNHPpsmOIbI0EbK7w0/2zBFANeEX5M4v0L44c9gDjPTtpR8Mmw
 GBNA==
X-Gm-Message-State: AOAM530tNploR2UkS//3Mze6ldbf8ci5xupYigGddj9wztzIsIY3Gzlt
 Zq2JfVFRLDdSAR7iCVU4si/i3w==
X-Google-Smtp-Source: ABdhPJwyLx+5eAlTJPtgJIvXyC2iwxmisAyHMyKDzZKtjO/Aqsn9ofM0P83getrTAM+DrFefFCeCGw==
X-Received: by 2002:a17:903:31c8:b0:149:a463:ad38 with SMTP id
 v8-20020a17090331c800b00149a463ad38mr21425083ple.76.1643174542251; 
 Tue, 25 Jan 2022 21:22:22 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id k16sm700956pfu.140.2022.01.25.21.22.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 25 Jan 2022 21:22:21 -0800 (PST)
Date: Tue, 25 Jan 2022 21:22:17 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH v4 02/26] KVM: arm64: Save ID registers' sanitized
 value per guest
Message-ID: <YfDaiUbSkpi9/5YY@google.com>
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-3-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220106042708.2869332-3-reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Wed, Jan 05, 2022 at 08:26:44PM -0800, Reiji Watanabe wrote:
> Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
> and save ID registers' sanitized value in the array at KVM_CREATE_VM.
> Use the saved ones when ID registers are read by the guest or
> userspace (via KVM_GET_ONE_REG).
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 16 ++++++++
>  arch/arm64/kvm/arm.c              |  1 +
>  arch/arm64/kvm/sys_regs.c         | 62 ++++++++++++++++++++++---------
>  3 files changed, 62 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 2a5f7f38006f..c789a0137f58 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -102,6 +102,17 @@ struct kvm_s2_mmu {
>  struct kvm_arch_memory_slot {
>  };
>  
> +/*
> + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> + * where 0<=crm<8, 0<=op2<8.

Is this observation based on this table?

Table D12-2 System instruction encodings for non-Debug System register accesses

in that case, it seems that the ID registers list might grow after
crm=7, and as CRm has 4 bits, why not 16*8=128?

> + */
> +#define KVM_ARM_ID_REG_MAX_NUM	64
> +#define IDREG_IDX(id)		((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> +#define is_id_reg(id)	\
> +	(sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&	\
> +	 sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 0 &&	\
> +	 sys_reg_CRm(id) < 8)
> +
>  struct kvm_arch {
>  	struct kvm_s2_mmu mmu;
>  
> @@ -137,6 +148,9 @@ struct kvm_arch {
>  
>  	/* Memory Tagging Extension enabled for the guest */
>  	bool mte_enabled;
> +
> +	/* ID registers for the guest. */
> +	u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];
>  };
>  
>  struct kvm_vcpu_fault_info {
> @@ -734,6 +748,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>  				struct kvm_arm_copy_mte_tags *copy_tags);
>  
> +void set_default_id_regs(struct kvm *kvm);
> +
>  /* Guest/host FPSIMD coordination helpers */
>  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e4727dc771bf..5f497a0af254 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -156,6 +156,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
>  
>  	set_default_spectre(kvm);
> +	set_default_id_regs(kvm);
>  
>  	return ret;
>  out_free_stage2_pgd:
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e3ec1a44f94d..80dc62f98ef0 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -33,6 +33,8 @@
>  
>  #include "trace.h"
>  
> +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
> +
>  /*
>   * All of this file is extremely similar to the ARM coproc.c, but the
>   * types are different. My gut feeling is that it should be pretty
> @@ -273,7 +275,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
>  			  struct sys_reg_params *p,
>  			  const struct sys_reg_desc *r)
>  {
> -	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> +	u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
>  	u32 sr = reg_to_encoding(r);
>  
>  	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
> @@ -1059,17 +1061,9 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> -static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> -		struct sys_reg_desc const *r, bool raz)
> +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>  {
> -	u32 id = reg_to_encoding(r);
> -	u64 val;
> -
> -	if (raz)
> -		return 0;
> -
> -	val = read_sanitised_ftr_reg(id);
> +	u64 val = vcpu->kvm->arch.id_regs[IDREG_IDX(id)];
>  
>  	switch (id) {
>  	case SYS_ID_AA64PFR0_EL1:
> @@ -1119,6 +1113,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  	return val;
>  }
>  
> +static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> +		       struct sys_reg_desc const *r, bool raz)
> +{
> +	u32 id = reg_to_encoding(r);
> +
> +	return raz ? 0 : __read_id_reg(vcpu, id);
> +}
> +
>  static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
>  				  const struct sys_reg_desc *r)
>  {
> @@ -1223,9 +1225,8 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  /*
>   * cpufeature ID register user accessors
>   *
> - * For now, these registers are immutable for userspace, so no values
> - * are stored, and for set_id_reg() we don't allow the effective value
> - * to be changed.
> + * For now, these registers are immutable for userspace, so for set_id_reg()
> + * we don't allow the effective value to be changed.
>   */
>  static int __get_id_reg(const struct kvm_vcpu *vcpu,
>  			const struct sys_reg_desc *rd, void __user *uaddr,
> @@ -1237,7 +1238,7 @@ static int __get_id_reg(const struct kvm_vcpu *vcpu,
>  	return reg_to_user(uaddr, &val, id);
>  }
>  
> -static int __set_id_reg(const struct kvm_vcpu *vcpu,
> +static int __set_id_reg(struct kvm_vcpu *vcpu,
>  			const struct sys_reg_desc *rd, void __user *uaddr,
>  			bool raz)
>  {
> @@ -1837,8 +1838,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
>  	if (p->is_write) {
>  		return ignore_write(vcpu, p);
>  	} else {
> -		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> -		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> +		u64 dfr = __read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
> +		u64 pfr = __read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
>  		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
>  
>  		p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
> @@ -2850,3 +2851,30 @@ void kvm_sys_reg_table_init(void)
>  	/* Clear all higher bits. */
>  	cache_levels &= (1 << (i*3))-1;
>  }
> +
> +/*
> + * Set the guest's ID registers that are defined in sys_reg_descs[]
> + * with ID_SANITISED() to the host's sanitized value.
> + */
> +void set_default_id_regs(struct kvm *kvm)
> +{
> +	int i;
> +	u32 id;
> +	const struct sys_reg_desc *rd;
> +	u64 val;
> +
> +	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> +		rd = &sys_reg_descs[i];
> +		if (rd->access != access_id_reg)
> +			/* Not ID register, or hidden/reserved ID register */
> +			continue;
> +
> +		id = reg_to_encoding(rd);
> +		if (WARN_ON_ONCE(!is_id_reg(id)))
> +			/* Shouldn't happen */
> +			continue;
> +
> +		val = read_sanitised_ftr_reg(id);

I'm a bit confused. Shouldn't the default+sanitized values already use
arm64_ftr_bits_kvm (instead of arm64_ftr_regs)?

> +		kvm->arch.id_regs[IDREG_IDX(id)] = val;
> +	}
> +}
> -- 
> 2.34.1.448.ga2b2bfdf31-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
