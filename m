Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C95101DB
	for <kvmarm@lists.linux.dev>; Thu, 13 Jul 2023 09:49:03 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2D641570;
	Thu, 13 Jul 2023 02:49:39 -0700 (PDT)
Received: from [10.1.36.45] (FVFF763DQ05P.cambridge.arm.com [10.1.36.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D0BFC3F740;
	Thu, 13 Jul 2023 02:48:55 -0700 (PDT)
Message-ID: <740731b6-5f3f-7acd-6d9f-8adfcef833ab@arm.com>
Date: Thu, 13 Jul 2023 10:48:54 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH v5 2/2] KVM: arm64: Move FGT value configuration to vCPU
 state
To: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
References: <20230712-kvm-arm64-fgt-v5-0-dae3ec236288@kernel.org>
 <20230712-kvm-arm64-fgt-v5-2-dae3ec236288@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20230712-kvm-arm64-fgt-v5-2-dae3ec236288@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/07/2023 13:50, Mark Brown wrote:
> Currently the only fine grained traps we use are the SME ones and we decide
> which to enable based on the presence of that feature. In order to support
> SME, GCS and other features where we need fine grained traps we will need to
> select per guest which traps are enabled. Move to storing the traps to
> enable in the vCPU data, updating the registers if fine grained traps are
> supported and any are enabled.
> 
> The code assumes that we never change the set of fine grained traps for the
> host after boot.
> 
> No functional change, though there will be a small overhead on systems with
> fine grained traps supported.  We could optimise slightly by assuming that
> host and guest always set the same pattern for read and write (they do
> currently) but this seemed more likely to cause surprises in future than
> it was worth.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_emulate.h    | 21 +++++++++++
>   arch/arm64/include/asm/kvm_host.h       |  6 ++++
>   arch/arm64/kvm/arm.c                    |  1 +
>   arch/arm64/kvm/hyp/include/hyp/switch.h | 62 +++++++++------------------------
>   4 files changed, 44 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index efc0b45d79c3..0d6c8d7e2aaa 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -108,6 +108,27 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
>   	return (unsigned long *)&vcpu->arch.hcr_el2;
>   }
>   
> +static inline void vcpu_reset_fgt(struct kvm_vcpu *vcpu)
> +{
> +	if (!cpus_have_const_cap(ARM64_HAS_FGT))
> +		return;
> +
> +	vcpu->arch.hfgrtr_el2 = 0;
> +	vcpu->arch.hfgwtr_el2 = 0;
> +
> +	/*
> +	 * Trap guest writes to TCR_EL1 to prevent it from enabling HA or HD.
> +	 */
> +	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38)) {
> +		vcpu->arch.hfgrtr_el2 |= HFGxTR_EL2_TCR_EL1_MASK;
> +		vcpu->arch.hfgwtr_el2 |= HFGxTR_EL2_TCR_EL1_MASK;
> +	}
> +
> +	/* We currently assume the host configuration never changes */
> +	vcpu->arch.hfgrtr_el2_host = read_sysreg_s(SYS_HFGRTR_EL2);
> +	vcpu->arch.hfgwtr_el2_host = read_sysreg_s(SYS_HFGWTR_EL2);

Doesn't this crash an nVHE host ?

Suzuki

