Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B41F3E3C55
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 09:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785923293; cv=none; b=TI60/q6enTqH0qar4BuRUU/Rgv02/3mNvcC2zp4/GRhHnaIXQrhp9G6xU5OzmhoVU4DkJ9cvWPJXoHg13lH5qk9yT8MpO8HDYlPdzZBgK+H83elcMIq6FV2tcewIEPu94VU8U4pw1ChwIfTsrNvvLYyIvxabe6eK8rkrabiGsP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785923293; c=relaxed/simple;
	bh=CVfxZrZ5huEz9sWFUaYHx7H8oC8g6MtMzrFqIFwcjgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bdirn5oyZ+YYegMTB/d6RbxyLqYpu+XwwywG999korG7wiib4AImWCiMS4GlVWHAeguNM9owdGmvIgICTY6t8UOVRAic/YxpLs+Ies+Iy14A2pUDOQMowfoCPas78hcifCAMQZRpHYiXbnEFGSHyavgOA7NJ7f0X5Pu12JzM1e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=j/cpIwPE; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="j/cpIwPE"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785923286; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=jeqp+GWZYrC7CG++av88Z1rhW3KrVbOyZV3jpxeJENk=;
	b=j/cpIwPE6ZqHkgRSTVka8LRFVpq3l2TXaiADmbNRjXcCduVqgy4cYnX5rhE+e9z2zGWpQozpXZTyJo7IECH6ei7yrahUn8FzCc7vvMONvGhLQ3bNY9iTvZo9vf9w9BUJf3f/uaGIpjW1CqWXU0KiFa1iVfem2CkXRrt6ov3FzRU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X8Qm5AG_1785923285;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X8Qm5AG_1785923285 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 05 Aug 2026 17:48:05 +0800
Date: Wed, 5 Aug 2026 17:48:04 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Oliver Upton <oupton@kernel.org>, Peter Maydell <peter.maydell@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v18 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Message-ID: <enhoyivbkdaacgyazubgfzftt34xjemtrybvgpuqvr4czjtbhm@7qvrce5lmdyw>
References: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
 <20260803-arm64-gcs-v18-3-fd8c40f5ad88@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803-arm64-gcs-v18-3-fd8c40f5ad88@kernel.org>

On Mon, Aug 03, 2026 at 11:56:48PM +0800, Mark Brown wrote:
> GCS introduces a number of system registers, on systems with GCS we need
> to context switch them and expose them to VMMs to allow guests to use
> GCS.
>
> In order to allow guests to use GCS we also need to configure
> HCRX_EL2.GCSEn, if this is not set GCS instructions will be noops and
> CHKFEAT will report GCS as disabled.
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
...
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
> @@ -206,6 +227,11 @@ static inline void __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
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
> index be685b63e8cf..2431c18f5792 100644
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
>  	if (ctxt_has_sctlr2(&vcpu->arch.ctxt))
>  		__vcpu_assign_sys_reg(vcpu, SCTLR2_EL2, read_sysreg_el1(SYS_SCTLR2));
> @@ -133,6 +138,11 @@ static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
>
>  		if (ctxt_has_s1poe(&vcpu->arch.ctxt))
>  			write_sysreg_el1(__vcpu_sys_reg(vcpu, POR_EL2), SYS_POR);
> +
> +		if (ctxt_has_gcs(&vcpu->arch.ctxt)) {
> +			write_sysreg_el1(__vcpu_sys_reg(vcpu, GCSCR_EL2), SYS_GCSCR);
> +			write_sysreg_el1(__vcpu_sys_reg(vcpu, GCSPR_EL2), SYS_GCSPR);
> +		}

Hi Mark,

Looks the s1pie checking for GCS vEL2 context switch is
necessary yet IIUC, KVM does vEL2 context switch for nested
L1's EL2, it should follow same rule as non-nested L1's EL1
context switch.

>  	}
>
>  	write_sysreg_el1(__vcpu_sys_reg(vcpu, ESR_EL2),		SYS_ESR);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5d5c579d4579..d18ada283809 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -109,6 +109,10 @@ static enum sr_loc_attr locate_direct_register(const struct kvm_vcpu *vcpu,
>  	case PIR_EL1:
>  	case PIRE0_EL1:
>  	case POR_EL1:
> +	case GCSCRE0_EL1:
> +	case GCSPR_EL0:
> +	case GCSCR_EL1:
> +	case GCSPR_EL1:
>  	case ESR_EL1:
>  	case AFSR0_EL1:
>  	case AFSR1_EL1:
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
