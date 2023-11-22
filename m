Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54FCD58AB2
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 18:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0ECD11042;
	Wed, 22 Nov 2023 10:07:07 -0800 (PST)
Received: from [10.57.42.32] (unknown [10.57.42.32])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D1C6F3F73F;
	Wed, 22 Nov 2023 10:06:18 -0800 (PST)
Message-ID: <dc403ac9-c136-4bdc-ad83-63bead99a39e@arm.com>
Date: Wed, 22 Nov 2023 18:06:17 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/13] KVM: arm64: Force guest's HCR_EL2.E2H RES1 when
 NV1 is not implemented
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231120123721.851738-1-maz@kernel.org>
 <20231120123721.851738-14-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20231120123721.851738-14-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/11/2023 12:37, Marc Zyngier wrote:
> If NV1 isn't supported on a system, make sure we always evaluate
> the guest's HCR_EL2.E2H as RES1, irrespective of what the guest
> may have written there.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> ---
>   arch/arm64/include/asm/kvm_emulate.h |  3 ++-
>   arch/arm64/kvm/sys_regs.c            | 12 +++++++++++-
>   2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 78a550537b67..7b10a44189d0 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -213,7 +213,8 @@ static inline bool vcpu_is_el2(const struct kvm_vcpu *vcpu)
>   
>   static inline bool __vcpu_el2_e2h_is_set(const struct kvm_cpu_context *ctxt)
>   {
> -	return ctxt_sys_reg(ctxt, HCR_EL2) & HCR_E2H;
> +	return (cpus_have_final_cap(ARM64_HCR_NV1_RES0) ||
> +		(ctxt_sys_reg(ctxt, HCR_EL2) & HCR_E2H));
>   }
>   
>   static inline bool vcpu_el2_e2h_is_set(const struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ff2e66f0bda1..9e1e3da2ed4a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2022,6 +2022,16 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
>   	return true;
>   }
>   
> +static u64 reset_hcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +	u64 val = r->val;
> +
> +	if (cpus_have_final_cap(ARM64_HCR_NV1_RES0))
> +		val |= HCR_E2H;
> +
> +	return __vcpu_sys_reg(vcpu, r->reg) = val;
> +}
> +
>   /*
>    * Architected system registers.
>    * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
> @@ -2513,7 +2523,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>   	EL2_REG(VMPIDR_EL2, access_rw, reset_unknown, 0),
>   	EL2_REG(SCTLR_EL2, access_rw, reset_val, SCTLR_EL2_RES1),
>   	EL2_REG(ACTLR_EL2, access_rw, reset_val, 0),
> -	EL2_REG(HCR_EL2, access_rw, reset_val, 0),
> +	EL2_REG(HCR_EL2, access_rw, reset_hcr, 0),
>   	EL2_REG(MDCR_EL2, access_rw, reset_val, 0),
>   	EL2_REG(CPTR_EL2, access_rw, reset_val, CPTR_NVHE_EL2_RES1),
>   	EL2_REG(HSTR_EL2, access_rw, reset_val, 0),

