Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE0617D4
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 04:09:05 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1a7ff4a454eso143585ad.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Apr 2023 21:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681877345; x=1684469345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KWBEh39STYHM00+MmxoH823Kw9il9T5jXW6faVZFYyg=;
        b=JHxTds/l2dcQoYGSJFQj67x5c53UT/qRv76LCTpc+zWFsZMe9UDNkJgm9Yf92I/1ZT
         rOIjzyASamuTGRPPRBOT7lpUz4o1PnFZCPdp5Xo6sNlYdoxcVT8f4eS87r+LnmtpPX4v
         FhTyNacwfNpPUgnqwfptodTFr0Ilx1vM2sPUlG201PMzc8vN19g7dD2J7NS5hiWTqjie
         kccKvp/fWrV4bzovHvK0EwTNf5KnGrt+5Bm7mWqqBWS+ZuUFhnsQvwDKwVtXOi+LXqlY
         UDOz4ijs/7XvGH5/0K9sLwbsgOeRylCoh+InElSk+adCnE3MRT83kLG7yi3IqhDD7xbV
         E+hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681877345; x=1684469345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KWBEh39STYHM00+MmxoH823Kw9il9T5jXW6faVZFYyg=;
        b=KtBuqRciAlo5cLTRXMsSrfZB9HrTIfvFGagJNcyMh+yt791wKuo6/3nrmUCKzx0qCF
         sN2WiBuF1+T7xRGCMJSwQFag/EDHK0Di4TgjWulWRiEk7lxokTNUeLz42rDQ8Nq0t/+r
         ezvV7BDIYZ7OwFPDbdZE2H6nPwMVfTkWNgszLllIoGLF9OAsI/36QZMW5s+hiMVjjK43
         S9nXzdkIVXGvVktYXUJDwEtACbCcrOptgBVFf3lRq7K14rRXKpVq7td6atSTm1btf7NI
         mvRSmqNWZXYLLglVZu0ZI080G09AG5Wsh+szu+Ivh4vFTzBNjAhbQbWKFXppT0NvNuEP
         0Yxw==
X-Gm-Message-State: AAQBX9c5EQFInrHjg+7yQLQ6+5p0yj5ucvgngYzOgCtjh/gTEzHEBi9S
	qZmSteC3OMgzUU+8rKq8e051Mg==
X-Google-Smtp-Source: AKy350ZHqYUaA+/DmYCo8HJk9zOvovcOI5YF28ywwBVjIbqq6Y13Jw+lGavtkoFhVw5TjebucHtJlw==
X-Received: by 2002:a17:903:2805:b0:191:4367:7fde with SMTP id kp5-20020a170903280500b0019143677fdemr186889plb.0.1681877344495;
        Tue, 18 Apr 2023 21:09:04 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id t5-20020a17090a5d8500b0023d386e4806sm342764pji.57.2023.04.18.21.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 21:09:03 -0700 (PDT)
Date: Tue, 18 Apr 2023 21:09:00 -0700
From: Reiji Watanabe <reijiw@google.com>
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
	ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v6 5/6] KVM: arm64: Reuse fields of sys_reg_desc for idreg
Message-ID: <20230419040900.mqrk4jvkujkehic6@google.com>
References: <20230404035344.4043856-1-jingzhangos@google.com>
 <20230404035344.4043856-6-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404035344.4043856-6-jingzhangos@google.com>

Hi Jing,

On Tue, Apr 04, 2023 at 03:53:43AM +0000, Jing Zhang wrote:
> Since reset() and val are not used for idreg in sys_reg_desc, they would
> be used with other purposes for idregs.
> The callback reset() would be used to return KVM sanitised id register
> values. The u64 val would be used as mask for writable fields in idregs.
> Only bits with 1 in val are writable from userspace.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/kvm/id_regs.c  | 44 +++++++++++++++++++----------
>  arch/arm64/kvm/sys_regs.c | 59 +++++++++++++++++++++++++++------------
>  arch/arm64/kvm/sys_regs.h | 10 ++++---
>  3 files changed, 77 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> index 6f65d30693fe..fe37b6786b4c 100644
> --- a/arch/arm64/kvm/id_regs.c
> +++ b/arch/arm64/kvm/id_regs.c
> @@ -55,6 +55,11 @@ static u8 pmuver_to_perfmon(u8 pmuver)
>  	}
>  }
>  
> +static u64 general_read_kvm_sanitised_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
> +{
> +	return read_sanitised_ftr_reg(reg_to_encoding(rd));
> +}
> +
>  u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>  {
>  	u64 val = IDREG(vcpu->kvm, id);
> @@ -324,6 +329,17 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +/*
> + * Since reset() callback and field val are not used for idregs, they will be
> + * used for specific purposes for idregs.
> + * The reset() would return KVM sanitised register value. The value would be the
> + * same as the host kernel sanitised value if there is no KVM sanitisation.
> + * The val would be used as a mask indicating writable fields for the idreg.
> + * Only bits with 1 are writable from userspace. This mask might not be

Nit: This comment update seems to be in the next patch,
since 'val' for AA64PFR0, AA64DFR0 and DFR0 is zero yet.


> + * necessary in the future whenever all ID registers are enabled as writable
> + * from userspace.
> + */
> +
>  /* sys_reg_desc initialiser for known cpufeature ID registers */
>  #define ID_SANITISED(name) {			\
>  	SYS_DESC(SYS_##name),			\
> @@ -331,6 +347,8 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>  	.get_user = get_id_reg,			\
>  	.set_user = set_id_reg,			\
>  	.visibility = id_visibility,		\
> +	.reset = general_read_kvm_sanitised_reg,\
> +	.val = 0,				\
>  }
>  
>  /* sys_reg_desc initialiser for known cpufeature ID registers */
> @@ -340,6 +358,8 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>  	.get_user = get_id_reg,			\
>  	.set_user = set_id_reg,			\
>  	.visibility = aa32_id_visibility,	\
> +	.reset = general_read_kvm_sanitised_reg,\
> +	.val = 0,				\
>  }
>  
>  /*
> @@ -352,7 +372,9 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>  	.access = access_id_reg,			\
>  	.get_user = get_id_reg,				\
>  	.set_user = set_id_reg,				\
> -	.visibility = raz_visibility			\
> +	.visibility = raz_visibility,			\
> +	.reset = NULL,					\
> +	.val = 0,					\
>  }
>  
>  /*
> @@ -366,6 +388,8 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>  	.get_user = get_id_reg,			\
>  	.set_user = set_id_reg,			\
>  	.visibility = raz_visibility,		\
> +	.reset = NULL,				\
> +	.val = 0,				\
>  }
>  
>  const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
> @@ -476,10 +500,7 @@ int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params)
>  	return 1;
>  }
>  
> -/*
> - * Set the guest's ID registers that are defined in id_reg_descs[]
> - * with ID_SANITISED() to the host's sanitized value.
> - */
> +/* Initialize the guest's ID registers with KVM sanitised values. */
>  void kvm_arm_init_id_regs(struct kvm *kvm)
>  {
>  	int i;
> @@ -492,16 +513,11 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
>  			/* Shouldn't happen */
>  			continue;
>  
> -		/*
> -		 * Some hidden ID registers which are not in arm64_ftr_regs[]
> -		 * would cause warnings from read_sanitised_ftr_reg().
> -		 * Skip those ID registers to avoid the warnings.
> -		 */
> -		if (id_reg_descs[i].visibility == raz_visibility)
> -			/* Hidden or reserved ID register */
> -			continue;
> +		val = 0;
> +		/* Read KVM sanitised register value if available */
> +		if (id_reg_descs[i].reset)
> +			val = id_reg_descs[i].reset(NULL, &id_reg_descs[i]);
>  
> -		val = read_sanitised_ftr_reg(id);
>  		IDREG(kvm, id) = val;
>  	}
>  
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 15979c2b87ab..703cf833345a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -540,10 +540,11 @@ static int get_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  	return 0;
>  }
>  
> -static void reset_bvr(struct kvm_vcpu *vcpu,
> +static u64 reset_bvr(struct kvm_vcpu *vcpu,
>  		      const struct sys_reg_desc *rd)
>  {
>  	vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm] = rd->val;
> +	return rd->val;
>  }
>  
>  static bool trap_bcr(struct kvm_vcpu *vcpu,
> @@ -576,10 +577,11 @@ static int get_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  	return 0;
>  }
>  
> -static void reset_bcr(struct kvm_vcpu *vcpu,
> +static u64 reset_bcr(struct kvm_vcpu *vcpu,
>  		      const struct sys_reg_desc *rd)
>  {
>  	vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm] = rd->val;
> +	return rd->val;
>  }
>  
>  static bool trap_wvr(struct kvm_vcpu *vcpu,
> @@ -613,10 +615,11 @@ static int get_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  	return 0;
>  }
>  
> -static void reset_wvr(struct kvm_vcpu *vcpu,
> +static u64 reset_wvr(struct kvm_vcpu *vcpu,
>  		      const struct sys_reg_desc *rd)
>  {
>  	vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm] = rd->val;
> +	return rd->val;
>  }
>  
>  static bool trap_wcr(struct kvm_vcpu *vcpu,
> @@ -649,25 +652,28 @@ static int get_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  	return 0;
>  }
>  
> -static void reset_wcr(struct kvm_vcpu *vcpu,
> +static u64 reset_wcr(struct kvm_vcpu *vcpu,
>  		      const struct sys_reg_desc *rd)
>  {
>  	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm] = rd->val;
> +	return rd->val;
>  }
>  
> -static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +static u64 reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	u64 amair = read_sysreg(amair_el1);
>  	vcpu_write_sys_reg(vcpu, amair, AMAIR_EL1);
> +	return amair;
>  }
>  
> -static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +static u64 reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	u64 actlr = read_sysreg(actlr_el1);
>  	vcpu_write_sys_reg(vcpu, actlr, ACTLR_EL1);
> +	return actlr;
>  }
>  
> -static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +static u64 reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	u64 mpidr;
>  
> @@ -681,7 +687,10 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
>  	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
>  	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
> -	vcpu_write_sys_reg(vcpu, (1ULL << 31) | mpidr, MPIDR_EL1);
> +	mpidr |= (1ULL << 31);
> +	vcpu_write_sys_reg(vcpu, mpidr, MPIDR_EL1);
> +
> +	return mpidr;
>  }
>  
>  static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
> @@ -693,13 +702,13 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
>  	return REG_HIDDEN;
>  }
>  
> -static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +static u64 reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
>  
>  	/* No PMU available, any PMU reg may UNDEF... */
>  	if (!kvm_arm_support_pmu_v3())
> -		return;
> +		return 0;
>  
>  	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
>  	n &= ARMV8_PMU_PMCR_N_MASK;
> @@ -708,33 +717,41 @@ static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  
>  	reset_unknown(vcpu, r);
>  	__vcpu_sys_reg(vcpu, r->reg) &= mask;
> +
> +	return __vcpu_sys_reg(vcpu, r->reg);
>  }
>  
> -static void reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +static u64 reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	reset_unknown(vcpu, r);
>  	__vcpu_sys_reg(vcpu, r->reg) &= GENMASK(31, 0);
> +
> +	return __vcpu_sys_reg(vcpu, r->reg);
>  }
>  
> -static void reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +static u64 reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	reset_unknown(vcpu, r);
>  	__vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_EVTYPE_MASK;
> +
> +	return __vcpu_sys_reg(vcpu, r->reg);
>  }
>  
> -static void reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +static u64 reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	reset_unknown(vcpu, r);
>  	__vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_COUNTER_MASK;
> +
> +	return __vcpu_sys_reg(vcpu, r->reg);
>  }
>  
> -static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	u64 pmcr;
>  
>  	/* No PMU available, PMCR_EL0 may UNDEF... */
>  	if (!kvm_arm_support_pmu_v3())
> -		return;
> +		return 0;
>  
>  	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
>  	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
> @@ -742,6 +759,8 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  		pmcr |= ARMV8_PMU_PMCR_LC;
>  
>  	__vcpu_sys_reg(vcpu, r->reg) = pmcr;
> +
> +	return __vcpu_sys_reg(vcpu, r->reg);
>  }
>  
>  static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
> @@ -1221,7 +1240,7 @@ static bool access_clidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>   * Fabricate a CLIDR_EL1 value instead of using the real value, which can vary
>   * by the physical CPU which the vcpu currently resides in.
>   */
> -static void reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	u64 ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
>  	u64 clidr;
> @@ -1269,6 +1288,8 @@ static void reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  		clidr |= 2 << CLIDR_TTYPE_SHIFT(loc);
>  
>  	__vcpu_sys_reg(vcpu, r->reg) = clidr;
> +
> +	return __vcpu_sys_reg(vcpu, r->reg);
>  }
>  
>  static int set_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> @@ -2622,19 +2643,21 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
>   */
>  
>  #define FUNCTION_INVARIANT(reg)						\
> -	static void get_##reg(struct kvm_vcpu *v,			\
> +	static u64 get_##reg(struct kvm_vcpu *v,			\
>  			      const struct sys_reg_desc *r)		\
>  	{								\
>  		((struct sys_reg_desc *)r)->val = read_sysreg(reg);	\
> +		return ((struct sys_reg_desc *)r)->val;			\
>  	}
>  
>  FUNCTION_INVARIANT(midr_el1)
>  FUNCTION_INVARIANT(revidr_el1)
>  FUNCTION_INVARIANT(aidr_el1)
>  
> -static void get_ctr_el0(struct kvm_vcpu *v, const struct sys_reg_desc *r)
> +static u64 get_ctr_el0(struct kvm_vcpu *v, const struct sys_reg_desc *r)
>  {
>  	((struct sys_reg_desc *)r)->val = read_sanitised_ftr_reg(SYS_CTR_EL0);
> +	return ((struct sys_reg_desc *)r)->val;
>  }
>  
>  /* ->val is filled in by kvm_sys_reg_table_init() */
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index e88fd77309b2..21869319f6e1 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -65,12 +65,12 @@ struct sys_reg_desc {
>  		       const struct sys_reg_desc *);
>  
>  	/* Initialization for vcpu. */
> -	void (*reset)(struct kvm_vcpu *, const struct sys_reg_desc *);
> +	u64 (*reset)(struct kvm_vcpu *, const struct sys_reg_desc *);

Could you add a comment what is return from reset() ?

Thank you,
Reiji

>  
>  	/* Index into sys_reg[], or 0 if we don't need to save it. */
>  	int reg;
>  
> -	/* Value (usually reset value) */
> +	/* Value (usually reset value), or write mask for idregs */
>  	u64 val;
>  
>  	/* Custom get/set_user functions, fallback to generic if NULL */
> @@ -123,19 +123,21 @@ static inline bool read_zero(struct kvm_vcpu *vcpu,
>  }
>  
>  /* Reset functions */
> -static inline void reset_unknown(struct kvm_vcpu *vcpu,
> +static inline u64 reset_unknown(struct kvm_vcpu *vcpu,
>  				 const struct sys_reg_desc *r)
>  {
>  	BUG_ON(!r->reg);
>  	BUG_ON(r->reg >= NR_SYS_REGS);
>  	__vcpu_sys_reg(vcpu, r->reg) = 0x1de7ec7edbadc0deULL;
> +	return __vcpu_sys_reg(vcpu, r->reg);
>  }
>  
> -static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +static inline u64 reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	BUG_ON(!r->reg);
>  	BUG_ON(r->reg >= NR_SYS_REGS);
>  	__vcpu_sys_reg(vcpu, r->reg) = r->val;
> +	return __vcpu_sys_reg(vcpu, r->reg);
>  }
>  
>  static inline unsigned int sysreg_visibility(const struct kvm_vcpu *vcpu,
> -- 
> 2.40.0.348.gf938b09366-goog
> 
