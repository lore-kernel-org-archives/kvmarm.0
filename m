Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794405563;
	b=Gou4EnMaD//yT1wX6g0iuXJWSz7KvsD2+j+q1dijEdYw4dacrdBfoFhTVILO4CwOTGvt
	 ZICSUT2uUyFtHY3veVGWZWHu4AfOk3LjArPvcBHWCfwkT/x/D1azutLt8Ja+zZ8/2GUt0
	 HQXZX4dSbSXMxgUoxma5J2J0pMQAWJOuvEQxMtDQ9P3SdQ6Ur4s1hM6ziMhenbiaEFnBZ
	 MezoW9nApDiqqys7kwa6x7SHGl6dGwMepRuHLOS916sPjty/QGlv8kdkD3glxpA1zbCt2
	 gLTUAfbMszBNATeKMjJoe9t5raOo0CO/aceY5/rPm8/IgRX657oKnXrqU3mVP6Hs0ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794405563;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=yWS0+4kurKjndaOQRErlwqMS9KCLA/8IMzcMt6fHeEk=;
	b=Cura92ARFU1GGJtFEsFFTchRgaBVv4W9ms/42oTAWmaHnIwVN5secfnPatNhBaIclknm
	 HvBTsps4wbC4dgAeasxVdoE0R+Dy2dfA4Ayb+JCGM9yLx4icbwWLQdCARozKguxdIEsq9
	 yhcOPvWEtFT1+SGSpm4TzSNLxRNHpgyKNKcOVAXrILgKxbYir29Jkmlq5NFREGso1EK8d
	 afOvS7UPkpNloNXQLg9od0Yz8lTzjCmWERskeBPmlYWeXYrVZ3SVCAM42iCVGrGaX2V1/
	 0eU+P69YKXGW9VgKo8zn+EdDnEl5WVPNkFBWULUmUn8gKfYcHQT3P2oUN4vq21c7sig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=eO3N8mVU;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83D87606A326
	for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 13:59:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83D87606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=eO3N8mVU
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E68AB1576;
	Wed, 11 Nov 2026 05:59:18 -0800 (PST)
Received: from [10.57.69.47] (unknown [10.57.69.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD9FE3F673;
	Wed, 11 Nov 2026 05:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794405561; bh=ZS/6+logSEVjBhsJ898Tt4DanlJ8je6TCRqCH1C6kak=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eO3N8mVUBUtNqhII9a/tEc81Ec4bqXfC3opjg7RtnAwOj48vBxoFwn0gTgJjSe28j
	 azwZd8fu84HHjudgNafZPbstRNInc2Bj0M4wjZcfOLEnhYbNtLA5Mf3TPRwFsRl/9u
	 ZATQVUicbb+glkJc/EWmw1eC3blUY/XrGaS/I4Jc=
Message-ID: <5fa8a1fb-4e2c-4746-8a70-a47f387ef0d6@arm.com>
Date: Wed, 11 Nov 2026 13:59:17 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/18] KVM: arm64: Implement HVC handling for protected
 guests at EL2
To: Fuad Tabba <fuad.tabba@linux.dev>, maz@kernel.org, oupton@kernel.org,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com,
 seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 mark.rutland@arm.com, steven.price@arm.com, vdonnefort@google.com,
 qperret@google.com, tabba@google.com
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
 <20261001135711.1640520-10-fuad.tabba@linux.dev>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20261001135711.1640520-10-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Faud,

I have some drive-by comments for this patch, having stumbled upon it while
poking around in SSBS code today...


On 01/10/2026 14:57, Fuad Tabba wrote:
> Extend kvm_handle_pvm_hvc64() to handle SMCCC_VERSION,
> SMCCC_ARCH_FEATURES and the vendor hypervisor call UID at EL2, so
> these queries don't reach the host. ARCH_FEATURES is mandatory from
> SMCCC 1.1, the version EL2 implements: it returns SUCCESS for itself and
> for SMCCC_VERSION, NOT_SUPPORTED for anything else, and handles the
> ARCH_WORKAROUND_1/2/3 queries as the host does, from a copy of the
> host's mitigation state taken at init with the sanitised ID registers.
> The workaround calls themselves are already handled on hyp entry.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_hyp.h |  4 ++
>  arch/arm64/kvm/arm.c             |  4 ++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c   | 68 ++++++++++++++++++++++++++++++++
>  3 files changed, 76 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 4974492744cc8..7609c78c68f34 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -10,6 +10,7 @@
>  #include <linux/compiler.h>
>  #include <linux/kvm_host.h>
>  #include <asm/alternative.h>
> +#include <asm/spectre.h>
>  #include <asm/sysreg.h>
>  
>  DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
> @@ -150,6 +151,9 @@ extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
>  
>  extern unsigned long kvm_nvhe_sym(__icache_flags);
>  extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
> +extern enum mitigation_state kvm_nvhe_sym(spectre_v2_state);
> +extern enum mitigation_state kvm_nvhe_sym(spectre_v4_state);
> +extern enum mitigation_state kvm_nvhe_sym(spectre_bhb_state);
>  extern unsigned int kvm_nvhe_sym(kvm_host_sve_max_vl);
>  extern unsigned long kvm_nvhe_sym(hyp_nr_cpus);
>  extern unsigned int kvm_nvhe_sym(hyp_gicv3_nr_lr);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index db36815630790..cceeeee266902 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2622,6 +2622,10 @@ static void kvm_hyp_init_symbols(void)
>  	kvm_nvhe_sym(__icache_flags) = __icache_flags;
>  	kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
>  
> +	kvm_nvhe_sym(spectre_v2_state) = arm64_get_spectre_v2_state();
> +	kvm_nvhe_sym(spectre_v4_state) = arm64_get_spectre_v4_state();
> +	kvm_nvhe_sym(spectre_bhb_state) = arm64_get_spectre_bhb_state();

Is it really correct to snapshot this state then use it at runtime assuming its
still accurate? See below...


> +
>  	/* Propagate the FGT state to the nVHE side */
>  	kvm_nvhe_sym(hfgrtr_masks)  = hfgrtr_masks;
>  	kvm_nvhe_sym(hfgwtr_masks)  = hfgwtr_masks;
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 6ff08d195ff56..10ff2ba6c6c1b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -10,12 +10,18 @@
>  #include <linux/mm.h>
>  
>  #include <asm/kvm_emulate.h>
> +#include <asm/spectre.h>
>  
>  #include <nvhe/mem_protect.h>
>  #include <nvhe/memory.h>
>  #include <nvhe/pkvm.h>
>  #include <nvhe/trap_handler.h>
>  
> +/* The host's Spectre mitigation state, for SMCCC_ARCH_FEATURES. */
> +enum mitigation_state spectre_v2_state;
> +enum mitigation_state spectre_v4_state;
> +enum mitigation_state spectre_bhb_state;
> +
>  /* Used by icache_is_aliasing(). */
>  unsigned long __icache_flags;
>  
> @@ -1181,8 +1187,70 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>  	u64 val[4] = { SMCCC_RET_INVALID_PARAMETER };
>  	bool handled = true;
> +	u32 feature;
> +	uuid_t uuid;
>  
>  	switch (smccc_get_function(vcpu)) {
> +	case ARM_SMCCC_VERSION_FUNC_ID:
> +		/* Nothing to be handled by the host. Go back to the guest. */
> +		val[0] = ARM_SMCCC_VERSION_1_1;
> +		break;
> +	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> +		/* The workaround calls themselves are handled on hyp entry. */
> +		val[0] = SMCCC_RET_NOT_SUPPORTED;
> +		feature = smccc_get_arg1(vcpu);
> +		switch (feature) {
> +		case ARM_SMCCC_VERSION_FUNC_ID:
> +		case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> +			val[0] = SMCCC_RET_SUCCESS;
> +			break;
> +		case ARM_SMCCC_ARCH_WORKAROUND_1:
> +			switch (spectre_v2_state) {
> +			case SPECTRE_VULNERABLE:
> +				break;
> +			case SPECTRE_MITIGATED:
> +				val[0] = SMCCC_RET_SUCCESS;
> +				break;
> +			case SPECTRE_UNAFFECTED:
> +				val[0] = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
> +				break;
> +			}
> +			break;
> +		case ARM_SMCCC_ARCH_WORKAROUND_2:
> +			switch (spectre_v4_state) {
> +			case SPECTRE_VULNERABLE:
> +				break;
> +			case SPECTRE_MITIGATED:
> +				/* With SSBS advertised the guest's default is safe. */
> +				if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, SSBS, IMP))
> +					break;

For this case (and the break immediately above) you return val[0] =
SMCCC_RET_INVALID_PARAMETER (from init at top of this function). But the
kernel's kvm_smccc_call_handler() returns val[0] = SMCCC_RET_NOT_SUPPORTED in
these cases (which seems more likely to be correct). Does this violate the ABI?

> +				fallthrough;
> +			case SPECTRE_UNAFFECTED:
> +				val[0] = SMCCC_RET_NOT_REQUIRED;

Is it possible that the (compromised) kernel could have disabled the mitigation
after the state snapshot was taken? I.e. spectre_v4_state == SPECTRE_MITIGATED
and the VM doesn't advertise SSBS so it returns SMCCC_RET_NOT_REQUIRED here. But
the kernel has since turned off the mitigation?

Thanks,
Ryan

> +				break;
> +			}
> +			break;
> +		case ARM_SMCCC_ARCH_WORKAROUND_3:
> +			switch (spectre_bhb_state) {
> +			case SPECTRE_VULNERABLE:
> +				break;
> +			case SPECTRE_MITIGATED:
> +				val[0] = SMCCC_RET_SUCCESS;
> +				break;
> +			case SPECTRE_UNAFFECTED:
> +				val[0] = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
> +				break;
> +			}
> +			break;
> +		}
> +		break;
> +	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
> +		uuid = ARM_SMCCC_VENDOR_HYP_UID_KVM;
> +		val[0] = smccc_uuid_to_reg(&uuid, 0);
> +		val[1] = smccc_uuid_to_reg(&uuid, 1);
> +		val[2] = smccc_uuid_to_reg(&uuid, 2);
> +		val[3] = smccc_uuid_to_reg(&uuid, 3);
> +		break;
>  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
>  		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
>  		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_HYP_MEMINFO);

