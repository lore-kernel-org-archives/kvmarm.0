Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBAF414A4CC
	for <kvmarm@lists.linux.dev>; Mon, 11 Nov 2024 11:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731322823; cv=none; b=XIZP0WM18VYunVmmaB8UkxiOBHJak7kviA2cghQawe65bnrQuY5jg1bvMq2GvyVlPhrRrauQ/ZWElQNn3VG+RfokgZBynJWmhdHHkKPHh21nBrqKSMLszchjH4kEGWkbmhqSJINQxZhDfVV9iMxYKyQi6VPOLXgxor/aD9te+rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731322823; c=relaxed/simple;
	bh=ldAqtyJmElVRFidxGcXglTHqrWa7IWpCdhsJtzZLxOU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IxiRCopk+eVyB4/jZS+Urei9AavpZChHgY0zv4zl0PbQk9RSFKTo/MOXqcj+yqqavdkNvLk9s3IaN2kV23ziWknxKU+Gn+H1BHKyUQqebmmPv4b5+SxbV7ixLaEqbHdjIOHPw2Em9gnFk6RKEjgNSKlB+YDGXp8R6CSqq2tDcVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6FC11D14;
	Mon, 11 Nov 2024 03:00:43 -0800 (PST)
Received: from [10.57.79.116] (unknown [10.57.79.116])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 376CC3F6A8;
	Mon, 11 Nov 2024 03:00:12 -0800 (PST)
Message-ID: <5e7c19e2-e932-4664-9a9a-232623464a9b@arm.com>
Date: Mon, 11 Nov 2024 11:00:11 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/15] KVM: arm64: Get rid of __kvm_get_mdcr_el2() and
 related warts
Content-Language: en-GB
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Mingwei Zhang <mizhang@google.com>,
 Colton Lewis <coltonlewis@google.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
References: <20241108222418.1677420-1-oliver.upton@linux.dev>
 <20241108222418.1677420-3-oliver.upton@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20241108222418.1677420-3-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oliver,

Some minor nits below.

On 08/11/2024 22:24, Oliver Upton wrote:
> KVM caches MDCR_EL2 on a per-CPU basis in order to preserve the
> configuration of MDCR_EL2.HPMN while running a guest. This is a bit
> gross, since we're relying on some baked configuration rather than the
> hardware definition of implemented counters.
> 
> Discover the number of implemented counters by reading PMCR_EL0.N
> instead. This works because:
> 
>   - In VHE the kernel runs at EL2, and N always returns the number of
>     counters implemented in hardware
> 
>   - In {n,h}VHE, the EL2 setup code programs MDCR_EL2.HPMN with the EL2
>     view of PMCR_EL0.HPMN for the host

s/PMCR_EL0.HPMN/PMCR_EL0.N/

> 
> Lastly, avoid traps under nested virtualization by saving PMCR_EL0.N in
> host data.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/include/asm/kvm_asm.h   |  5 +----
>   arch/arm64/include/asm/kvm_host.h  |  7 +++++--
>   arch/arm64/kvm/arm.c               |  2 +-
>   arch/arm64/kvm/debug.c             | 29 +++++++++++------------------
>   arch/arm64/kvm/hyp/nvhe/debug-sr.c |  5 -----
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c |  6 ------
>   arch/arm64/kvm/hyp/vhe/debug-sr.c  |  5 -----
>   7 files changed, 18 insertions(+), 41 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index ca2590344313..063185c202ce 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -53,8 +53,7 @@
>   enum __kvm_host_smccc_func {
>   	/* Hypercalls available only prior to pKVM finalisation */
>   	/* __KVM_HOST_SMCCC_FUNC___kvm_hyp_init */
> -	__KVM_HOST_SMCCC_FUNC___kvm_get_mdcr_el2 = __KVM_HOST_SMCCC_FUNC___kvm_hyp_init + 1,
> -	__KVM_HOST_SMCCC_FUNC___pkvm_init,
> +	__KVM_HOST_SMCCC_FUNC___pkvm_init = __KVM_HOST_SMCCC_FUNC___kvm_hyp_init + 1,
>   	__KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping,
>   	__KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector,
>   	__KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs,
> @@ -247,8 +246,6 @@ extern void __kvm_adjust_pc(struct kvm_vcpu *vcpu);
>   extern u64 __vgic_v3_get_gic_config(void);
>   extern void __vgic_v3_init_lrs(void);
>   
> -extern u64 __kvm_get_mdcr_el2(void);
> -
>   #define __KVM_EXTABLE(from, to)						\
>   	"	.pushsection	__kvm_ex_table, \"a\"\n"		\
>   	"	.align		3\n"					\
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f333b189fb43..ad514434f3fe 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -642,7 +642,7 @@ struct kvm_host_data {
>   	 * host_debug_state contains the host registers which are
>   	 * saved and restored during world switches.
>   	 */
> -	 struct {
> +	struct {
>   		/* {Break,watch}point registers */
>   		struct kvm_guest_debug_arch regs;
>   		/* Statistical profiling extension */
> @@ -652,6 +652,9 @@ struct kvm_host_data {
>   		/* Values of trap registers for the host before guest entry. */
>   		u64 mdcr_el2;
>   	} host_debug_state;
> +
> +	/* Number of programmable event counters (PMCR_EL0.N) for this CPU */
> +	unsigned int nr_event_counters;
>   };
>   
>   struct kvm_host_psci_config {
> @@ -1332,7 +1335,7 @@ static inline bool kvm_system_needs_idmapped_vectors(void)
>   
>   static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>   
> -void kvm_arm_init_debug(void);
> +void kvm_init_host_debug_data(void);
>   void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
>   void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
>   void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index a102c3aebdbc..ab1bf9ccf385 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2109,6 +2109,7 @@ static void cpu_set_hyp_vector(void)
>   static void cpu_hyp_init_context(void)
>   {
>   	kvm_init_host_cpu_context(host_data_ptr(host_ctxt));
> +	kvm_init_host_debug_data();
>   
>   	if (!is_kernel_in_hyp_mode())
>   		cpu_init_hyp_mode();
> @@ -2117,7 +2118,6 @@ static void cpu_hyp_init_context(void)
>   static void cpu_hyp_init_features(void)
>   {
>   	cpu_set_hyp_vector();
> -	kvm_arm_init_debug();
>   
>   	if (is_kernel_in_hyp_mode())
>   		kvm_timer_init_vhe();
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index 587e9eb4372e..90ecf1210bd0 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -16,8 +16,6 @@
>   
>   #include "trace.h"
>   
> -static DEFINE_PER_CPU(u64, mdcr_el2);
> -
>   /*
>    * save/restore_guest_debug_regs
>    *
> @@ -60,21 +58,6 @@ static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
>   		*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
>   }
>   
> -/**
> - * kvm_arm_init_debug - grab what we need for debug
> - *
> - * Currently the sole task of this function is to retrieve the initial
> - * value of mdcr_el2 so we can preserve MDCR_EL2.HPMN which has
> - * presumably been set-up by some knowledgeable bootcode.
> - *
> - * It is called once per-cpu during CPU hyp initialisation.
> - */
> -
> -void kvm_arm_init_debug(void)
> -{
> -	__this_cpu_write(mdcr_el2, kvm_call_hyp_ret(__kvm_get_mdcr_el2));
> -}
> -
>   /**
>    * kvm_arm_setup_mdcr_el2 - configure vcpu mdcr_el2 value
>    *
> @@ -94,7 +77,8 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
>   	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
>   	 * to disable guest access to the profiling and trace buffers
>   	 */
> -	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
> +	vcpu->arch.mdcr_el2 = FIELD_PREP(ARMV8_PMU_PMCR_N,

Shouldn't this be : MDCR_EL2_HPMN_MASK ?

> +					 *host_data_ptr(nr_event_counters));
>   	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
>   				MDCR_EL2_TPMS |
>   				MDCR_EL2_TTRF |
> @@ -338,3 +322,12 @@ void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu)
>   	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_SPE);
>   	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
>   }
> +
> +void kvm_init_host_debug_data(void)
> +{
> +	u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
> +
> +	if (cpuid_feature_extract_signed_field(dfr0, ID_AA64DFR0_EL1_PMUVer_SHIFT) > 0)
> +		*host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
> +							      read_sysreg(pmcr_el0));
> +}

Rest looks good to me

Suzuki


