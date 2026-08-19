Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D20B34499B1
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 16:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787157160; cv=none; b=G3vcdFQNdjjlvbXGDxLCHW3+5DrIh/R3W1Jg1JoLs9oz2fnfwsvC6ckBVd+ml/sHmOaez+lGZU8LM15T1UJk0t+5K9bX/K+pQYrjkI2Aaeqq2cR4x04XUF9HY4bP3JTe2Yev1229PAyBEAsaZc9EZAffhbpDsJMWc0JWmRkUUY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787157160; c=relaxed/simple;
	bh=2eJtgwak98qIUWwsWv9FGfQajinsx9ZUQplAmVYCRsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=aRFsU7DFUG2/K5ZeGJ57qnF8c7/mw7VlsJFqcFiH4qttcUQtUJxEdk8FZYACLueVuZRrhRaOR5KgSIb7zSjfXqmjgKf31j6CkgVdD56ccJj690hMbtUiT0iLl/YO7H2q00XUiHFOyzfQgV5nAhCCJKRGLqFn6OZ1y05w8e6uPKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fbxSxSMf; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fbxSxSMf"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 20D5314BF;
	Wed, 19 Aug 2026 09:32:33 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 421723F85F;
	Wed, 19 Aug 2026 09:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787157156; bh=2eJtgwak98qIUWwsWv9FGfQajinsx9ZUQplAmVYCRsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fbxSxSMfBx1067H9gGZHAiTopda7PI2PhWOU4B2n6mKE/MEnkBNXxMKSwtJ005R2B
	 41SSRfn/sW5JNW1NDnWojrz12otAOHjDPm9ymN7YaqPEPdDRTufXMFEUKcwjGPd3oi
	 ltHZ0deJEMrqHnR8UovkywhNWBffH/zbWYjT1c90=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 03/14] KVM: arm64: Manage GCS access and registers for guests
Date: Wed, 19 Aug 2026 17:32:25 +0100
Message-ID: <aoXamcdKoMynTkpX@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812-arm64-gcs-v19-3-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org> <20260812-arm64-gcs-v19-3-9105afd828ac@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Aug 12, 2026 at 08:12:02PM +0100, Mark Brown wrote:
> GCS introduces a number of system registers, on systems with GCS we need
> to context switch them and expose them to VMMs to allow guests to use
> GCS.
> 
> In order to allow guests to use GCS we also need to configure
> HCRX_EL2.GCSEn, if this is not set GCS instructions will be noops and
> CHKFEAT will report GCS as disabled.

It is zero on reset, and keeping it in zero disables GCS in EL0&EL1, so 
unless we are in EL2&0 (HCR_EL2.{E2H, TGE} is {1, 1}), we need to enable it 
so EL1&0 (guests) can have access to it.

> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h       |  3 +++
>  arch/arm64/include/asm/kvm_host.h          | 14 ++++++++++
>  arch/arm64/include/asm/vncr_mapping.h      |  2 ++
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 31 ++++++++++++++++++++++
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 10 +++++++
>  arch/arm64/kvm/sys_regs.c                  | 42 ++++++++++++++++++++++++++++++
>  6 files changed, 102 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 5bf3d7e1d92c..ee774c3b8dcd 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -686,6 +686,9 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
>  
>  		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
>  			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
> +
> +		if (kvm_has_gcs(kvm))
> +			vcpu->arch.hcrx_el2 |= HCRX_EL2_GCSEn;
>  	}
>  }
>  #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index bae2c4f92ef5..1f0da8988961 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -497,6 +497,10 @@ enum vcpu_sysreg {
>  
>  	POR_EL0,	/* Permission Overlay Register 0 (EL0) */
>  
> +	/* Guarded Control Stack registers */
> +	GCSCRE0_EL1,	/* Guarded Control Stack Control (EL0) */
> +	GCSPR_EL0,	/* Guarded Control Stack Pointer (EL0) */
> +
>  	/* FP/SIMD/SVE */
>  	SVCR,
>  	FPMR,
> @@ -517,6 +521,8 @@ enum vcpu_sysreg {
>  	PIRE0_EL2,	/* Permission Indirection Register 0 (EL2) */
>  	PIR_EL2,	/* Permission Indirection Register 1 (EL2) */
>  	POR_EL2,	/* Permission Overlay Register 2 (EL2) */
> +	GCSCR_EL2,	/* Guarded Control Stack Control Register (EL2) */
> +	GCSPR_EL2,	/* Guarded Control Stack Pointer Register (EL2) */
>  	SPSR_EL2,	/* EL2 saved program status register */
>  	ELR_EL2,	/* EL2 exception link register */
>  	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
> @@ -588,6 +594,10 @@ enum vcpu_sysreg {
>  	VNCR(VDISR_EL2),
>  	VNCR(VSESR_EL2),
>  
> +	/* Guarded Control Stack registers */
> +	VNCR(GCSPR_EL1),	/* Guarded Control Stack Pointer (EL1) */
> +	VNCR(GCSCR_EL1),	/* Guarded Control Stack Control (EL1) */
> +
>  	VNCR(HFGRTR_EL2),
>  	VNCR(HFGWTR_EL2),
>  	VNCR(HFGITR_EL2),
> @@ -1648,6 +1658,10 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
>  #define kvm_has_sctlr2(k)				\
>  	(kvm_has_feat((k), ID_AA64MMFR3_EL1, SCTLRX, IMP))
>  
> +#define kvm_has_gcs(k)					\
> +	(system_supports_gcs() &&			\
> +	 kvm_has_feat((k), ID_AA64PFR1_EL1, GCS, IMP))
> +
>  static inline bool kvm_arch_has_irq_bypass(void)
>  {
>  	return true;
> diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
> index 14366d35ce82..b260008c5e3e 100644
> --- a/arch/arm64/include/asm/vncr_mapping.h
> +++ b/arch/arm64/include/asm/vncr_mapping.h
> @@ -97,6 +97,8 @@
>  #define VNCR_PMSNEVFR_EL1       0x850
>  #define VNCR_PMSDSFR_EL1        0x858
>  #define VNCR_TRFCR_EL1          0x880
> +#define VNCR_GCSPR_EL1		0x8C0
> +#define VNCR_GCSCR_EL1		0x8D0
>  #define VNCR_MPAM1_EL1          0x900
>  #define VNCR_MPAMHCR_EL2        0x930
>  #define VNCR_MPAMVPMV_EL2       0x938
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index a17cbe7582de..053d7b3c5104 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -17,6 +17,7 @@
>  #include <asm/kvm_mmu.h>
>  
>  static inline bool ctxt_has_s1poe(struct kvm_cpu_context *ctxt);
> +static inline bool ctxt_has_gcs(struct kvm_cpu_context *ctxt);
>  
>  static inline struct kvm_vcpu *ctxt_to_vcpu(struct kvm_cpu_context *ctxt)
>  {
> @@ -67,6 +68,11 @@ static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
>  {
>  	ctxt_sys_reg(ctxt, TPIDR_EL0)	= read_sysreg(tpidr_el0);
>  	ctxt_sys_reg(ctxt, TPIDRRO_EL0)	= read_sysreg(tpidrro_el0);
> +
> +	if (ctxt_has_gcs(ctxt)) {
> +		ctxt_sys_reg(ctxt, GCSPR_EL0) = read_sysreg_s(SYS_GCSPR_EL0);
> +		ctxt_sys_reg(ctxt, GCSCRE0_EL1)	= read_sysreg_s(SYS_GCSCRE0_EL1);
> +	}
>  }
>  
>  static inline bool ctxt_has_mte(struct kvm_cpu_context *ctxt)
> @@ -131,6 +137,17 @@ static inline bool ctxt_has_sctlr2(struct kvm_cpu_context *ctxt)
>  	return kvm_has_sctlr2(kern_hyp_va(vcpu->kvm));
>  }
>  
> +static inline bool ctxt_has_gcs(struct kvm_cpu_context *ctxt)
> +{
> +	struct kvm_vcpu *vcpu;
> +
> +	if (!cpus_have_final_cap(ARM64_HAS_GCS))
> +		return false;
> +
> +	vcpu = ctxt_to_vcpu(ctxt);
> +	return kvm_has_feat(kern_hyp_va(vcpu->kvm), ID_AA64PFR1_EL1, GCS, IMP);
> +}
> +
>  static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>  {
>  	ctxt_sys_reg(ctxt, SCTLR_EL1)	= read_sysreg_el1(SYS_SCTLR);
> @@ -144,6 +161,10 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>  		if (ctxt_has_s1pie(ctxt)) {
>  			ctxt_sys_reg(ctxt, PIR_EL1)	= read_sysreg_el1(SYS_PIR);
>  			ctxt_sys_reg(ctxt, PIRE0_EL1)	= read_sysreg_el1(SYS_PIRE0);
> +			if (ctxt_has_gcs(ctxt)) {
> +				ctxt_sys_reg(ctxt, GCSPR_EL1)	= read_sysreg_el1(SYS_GCSPR);
> +				ctxt_sys_reg(ctxt, GCSCR_EL1)	= read_sysreg_el1(SYS_GCSCR);
> +			}
>  		}
>  
>  		if (ctxt_has_s1poe(ctxt))
> @@ -26,6 +227,11 @@ static inline void __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
>  {
>  	write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL0),	tpidr_el0);
>  	write_sysreg(ctxt_sys_reg(ctxt, TPIDRRO_EL0),	tpidrro_el0);
> +	if (ctxt_has_gcs(ctxt)) {
> +		write_sysreg_s(ctxt_sys_reg(ctxt, GCSPR_EL0), SYS_GCSPR_EL0);
> +		write_sysreg_s(ctxt_sys_reg(ctxt, GCSCRE0_EL1),
> +			       SYS_GCSCRE0_EL1);
> +	}
>  }
>  
>  static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
> @@ -239,6 +265,11 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
>  		if (ctxt_has_s1pie(ctxt)) {
>  			write_sysreg_el1(ctxt_sys_reg(ctxt, PIR_EL1),	SYS_PIR);
>  			write_sysreg_el1(ctxt_sys_reg(ctxt, PIRE0_EL1),	SYS_PIRE0);
> +
> +			if (ctxt_has_gcs(ctxt)) {
> +				write_sysreg_el1(ctxt_sys_reg(ctxt, GCSPR_EL1),	SYS_GCSPR);
> +				write_sysreg_el1(ctxt_sys_reg(ctxt, GCSCR_EL1),	SYS_GCSCR);
> +			}
>  		}
>  
>  		if (ctxt_has_s1poe(ctxt))
> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> index be685b63e8cf..4f775545c71b 100644
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> @@ -61,6 +61,9 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
>  
>  			if (ctxt_has_s1poe(&vcpu->arch.ctxt))
>  				__vcpu_assign_sys_reg(vcpu, POR_EL2, read_sysreg_el1(SYS_POR));
> +
> +			if (ctxt_has_gcs(&vcpu->arch.ctxt))
> +				__vcpu_assign_sys_reg(vcpu, GCSCR_EL2, read_sysreg_el1(SYS_GCSCR));
>  		}
>  
>  		/*
> @@ -77,6 +80,8 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
>  	__vcpu_assign_sys_reg(vcpu, SP_EL2,	 read_sysreg(sp_el1));
>  	__vcpu_assign_sys_reg(vcpu, ELR_EL2,	 read_sysreg_el1(SYS_ELR));
>  	__vcpu_assign_sys_reg(vcpu, SPSR_EL2,	 read_sysreg_el1(SYS_SPSR));
> +	if (ctxt_has_gcs(&vcpu->arch.ctxt))
> +		__vcpu_assign_sys_reg(vcpu, GCSPR_EL2, read_sysreg_el1(SYS_GCSPR));
>  

Out of curiosity here,
Why does the saving of GCSCR_EL2 depends on ctxt_has_tcrx() (and E2H set), 
and saving SYS_GCSPR does not? ...


>  	if (ctxt_has_sctlr2(&vcpu->arch.ctxt))
>  		__vcpu_assign_sys_reg(vcpu, SCTLR2_EL2, read_sysreg_el1(SYS_SCTLR2));
> @@ -129,6 +134,11 @@ static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
>  		if (ctxt_has_s1pie(&vcpu->arch.ctxt)) {
>  			write_sysreg_el1(__vcpu_sys_reg(vcpu, PIR_EL2), SYS_PIR);
>  			write_sysreg_el1(__vcpu_sys_reg(vcpu, PIRE0_EL2), SYS_PIRE0);
> +
> +			if (ctxt_has_gcs(&vcpu->arch.ctxt)) {
> +				write_sysreg_el1(__vcpu_sys_reg(vcpu, GCSCR_EL2), SYS_GCSCR);
> +				write_sysreg_el1(__vcpu_sys_reg(vcpu, GCSPR_EL2), SYS_GCSPR);
> +			}

... If restoring them both depends on TCRX, but not on E2H set? 

>  		}
>  
>  		if (ctxt_has_s1poe(&vcpu->arch.ctxt))
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5d5c579d4579..6aa4463c3d3a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -109,6 +109,8 @@ static enum sr_loc_attr locate_direct_register(const struct kvm_vcpu *vcpu,
>  	case PIR_EL1:
>  	case PIRE0_EL1:
>  	case POR_EL1:
> +	case GCSCR_EL1:
> +	case GCSPR_EL1:
>  	case ESR_EL1:
>  	case AFSR0_EL1:
>  	case AFSR1_EL1:
> @@ -135,6 +137,8 @@ static enum sr_loc_attr locate_direct_register(const struct kvm_vcpu *vcpu,
>  	case DACR32_EL2:
>  	case IFSR32_EL2:
>  	case DBGVCR32_EL2:
> +	case GCSCRE0_EL1:
> +	case GCSPR_EL0:
>  		/* These registers are always loaded, no matter what */
>  		return SR_LOC_LOADED;
>  
> @@ -200,6 +204,8 @@ static void locate_register(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg,
>  		MAPPED_EL2_SYSREG(PIR_EL2,     PIR_EL1,     NULL	     );
>  		MAPPED_EL2_SYSREG(PIRE0_EL2,   PIRE0_EL1,   NULL	     );
>  		MAPPED_EL2_SYSREG(POR_EL2,     POR_EL1,     NULL	     );
> +		MAPPED_EL2_SYSREG(GCSCR_EL2,   GCSCR_EL1,   NULL             );
> +		MAPPED_EL2_SYSREG(GCSPR_EL2,   GCSPR_EL1,   NULL             );
>  		MAPPED_EL2_SYSREG(AMAIR_EL2,   AMAIR_EL1,   NULL	     );
>  		MAPPED_EL2_SYSREG(ELR_EL2,     ELR_EL1,	    NULL	     );
>  		MAPPED_EL2_SYSREG(SPSR_EL2,    SPSR_EL1,    NULL	     );
> @@ -228,6 +234,10 @@ static u64 read_sr_from_cpu(enum vcpu_sysreg reg)
>  	case TCR2_EL1:		val = read_sysreg_s(SYS_TCR2_EL12);	break;
>  	case PIR_EL1:		val = read_sysreg_s(SYS_PIR_EL12);	break;
>  	case PIRE0_EL1:		val = read_sysreg_s(SYS_PIRE0_EL12);	break;
> +	case GCSPR_EL0:		val = read_sysreg_s(SYS_GCSPR_EL0);	break;
> +	case GCSCRE0_EL1:	val = read_sysreg_s(SYS_GCSCRE0_EL1);	break;
> +	case GCSCR_EL1:		val = read_sysreg_s(SYS_GCSCR_EL12);	break;
> +	case GCSPR_EL1:		val = read_sysreg_s(SYS_GCSPR_EL12);	break;
>  	case POR_EL1:		val = read_sysreg_s(SYS_POR_EL12);	break;
>  	case ESR_EL1:		val = read_sysreg_s(SYS_ESR_EL12);	break;
>  	case AFSR0_EL1:		val = read_sysreg_s(SYS_AFSR0_EL12);	break;
> @@ -267,6 +277,10 @@ static void write_sr_to_cpu(enum vcpu_sysreg reg, u64 val)
>  	case PIR_EL1:		write_sysreg_s(val, SYS_PIR_EL12);	break;
>  	case PIRE0_EL1:		write_sysreg_s(val, SYS_PIRE0_EL12);	break;
>  	case POR_EL1:		write_sysreg_s(val, SYS_POR_EL12);	break;
> +	case GCSCRE0_EL1:	write_sysreg_s(val, SYS_GCSCRE0_EL1);	break;
> +	case GCSPR_EL0:		write_sysreg_s(val, SYS_GCSPR_EL0);	break;
> +	case GCSCR_EL1:		write_sysreg_s(val, SYS_GCSCR_EL12);	break;
> +	case GCSPR_EL1:		write_sysreg_s(val, SYS_GCSPR_EL12);	break;
>  	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	break;
>  	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	break;
>  	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	break;
> @@ -2995,6 +3009,21 @@ static unsigned int cnthv_visibility(const struct kvm_vcpu *vcpu,
>  	return REG_HIDDEN;
>  }
>  
> +static unsigned int gcs_visibility(const struct kvm_vcpu *vcpu,
> +				   const struct sys_reg_desc *r)
> +{
> +	if (kvm_has_gcs(vcpu->kvm))
> +		return 0;
> +
> +	return REG_HIDDEN;
> +}
> +
> +static unsigned int gcs_el2_visibility(const struct kvm_vcpu *vcpu,
> +				       const struct sys_reg_desc *rd)
> +{
> +	return __el2_visibility(vcpu, rd, gcs_visibility);
> +}
> +
>  static bool access_mdcr(struct kvm_vcpu *vcpu,
>  			struct sys_reg_params *p,
>  			const struct sys_reg_desc *r)
> @@ -3399,6 +3428,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	PTRAUTH_KEY(APDB),
>  	PTRAUTH_KEY(APGA),
>  
> +	{ SYS_DESC(SYS_GCSCR_EL1), NULL, reset_val, GCSCR_EL1, 0,
> +	  .visibility = gcs_visibility },
> +	{ SYS_DESC(SYS_GCSPR_EL1), NULL, reset_unknown, GCSPR_EL1,
> +	  .visibility = gcs_visibility },
> +	{ SYS_DESC(SYS_GCSCRE0_EL1), NULL, reset_val, GCSCRE0_EL1, 0,
> +	  .visibility = gcs_visibility },
> +
>  	{ SYS_DESC(SYS_SPSR_EL1), access_spsr},
>  	{ SYS_DESC(SYS_ELR_EL1), access_elr},
>  
> @@ -3523,6 +3559,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  		    CTR_EL0_DminLine_MASK |
>  		    CTR_EL0_L1Ip_MASK |
>  		    CTR_EL0_IminLine_MASK),
> +	{ SYS_DESC(SYS_GCSPR_EL0), NULL, reset_unknown, GCSPR_EL0,
> +	  .visibility = gcs_visibility },
>  	{ SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility  },
>  	{ SYS_DESC(SYS_FPMR), undef_access, reset_val, FPMR, 0, .visibility = fp8_visibility },
>  
> @@ -3764,6 +3802,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	EL2_REG_FILTERED(VNCR_EL2, bad_vncr_trap, reset_val, 0,
>  			 vncr_el2_visibility),
>  
> +	EL2_REG_FILTERED(GCSCR_EL2, access_rw, reset_val, 0,
> +			 gcs_el2_visibility),
> +	EL2_REG_FILTERED(GCSPR_EL2, access_rw, reset_val, 0,
> +			 gcs_el2_visibility),
>  	{ SYS_DESC(SYS_DACR32_EL2), undef_access, reset_unknown, DACR32_EL2 },
>  	EL2_REG_VNCR_FILT(HDFGRTR2_EL2, fgt2_visibility),
>  	EL2_REG_VNCR_FILT(HDFGWTR2_EL2, fgt2_visibility),
> 
> -- 
> 2.47.3
> 

Thanks!
Leo
