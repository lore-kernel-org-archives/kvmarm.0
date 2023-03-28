Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E058BE0
	for <kvmarm@lists.linux.dev>; Tue, 28 Mar 2023 15:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEADC433EF;
	Tue, 28 Mar 2023 15:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680017271;
	bh=+sUblLnhTmkAAsgpAOod8vL7GHeeAQRVuYluSyOviD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gi82WVE4vrCgOQWUh+F/nNZvj++qkRD5UlvmUIG6r9+mGrTeSXwkYiMN6FwjzxMVs
	 ekWN3GS9xRN5oJGvBvoai1Zz6ccvLgBrferRDk0xUgn/PuwpEIV1gurWnnofmZVNSl
	 ndcsY5v2wfGqJsIm5ydzItH5p+C3594hqIPDMiJzUS4p9t4jxlFG7vZt68MAKRSm0b
	 +6l7l/eLTYoPKlW8TkKI1Q11W61LRYEpDHKqdnUkBNALfTS760CDLMVj7utiwDXKAl
	 mAQPyKPw8NPWluwm7O91Ve1gquSMEGjtBStQklgT4yh2JyQXfm1bSp8ryUL9H8Ci/x
	 TSYGhwXwkC76A==
Date: Tue, 28 Mar 2023 16:27:45 +0100
From: Will Deacon <will@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 2/2] KVM: arm64: Move FGT value configuration to vCPU
 state
Message-ID: <20230328152744.GB1844@willie-the-truck>
References: <20230301-kvm-arm64-fgt-v2-0-c11c0dcf810a@kernel.org>
 <20230301-kvm-arm64-fgt-v2-2-c11c0dcf810a@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301-kvm-arm64-fgt-v2-2-c11c0dcf810a@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Mar 23, 2023 at 03:48:36PM +0000, Mark Brown wrote:
> Currently the only fine grained traps we use are the SME ones and we decide
> if we want to manage fine grained traps for the guest and which to
> enable based on the presence of that feature. In order to support SME,
> PIE and other features where we need fine grained traps we will need to
> select per guest which traps are enabled. Move to storing the traps to
> enable in the vCPU data, updating the registers if fine grained traps
> are supported and any are enabled. In order to ensure that the fine
> grained traps are restored along with other traps there is a bit of
> asymmetry with where the registers are restored on guest exit.
> 
> Currently we always set this register to 0 when running the guest so
> unconditionally use that value for guests, future patches will configure
> this.
> 
> No functional change, though we will do additional saves of the guest
> FGT register configurations and will save and restore even if the host
> and guest states are identical.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h       | 16 ++++++++++++++
>  arch/arm64/include/asm/kvm_host.h          |  2 ++
>  arch/arm64/kvm/arm.c                       |  1 +
>  arch/arm64/kvm/hyp/include/hyp/switch.h    | 35 ++++++++++++++++--------------
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  9 ++++++++
>  5 files changed, 47 insertions(+), 16 deletions(-)

[...]

> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 07d37ff88a3f..bf0183a3a82d 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -88,33 +88,36 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
>  	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
>  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>  
> -	if (cpus_have_final_cap(ARM64_SME)) {
> -		sysreg_clear_set_s(SYS_HFGRTR_EL2,
> -				   HFGxTR_EL2_nSMPRI_EL1_MASK |
> -				   HFGxTR_EL2_nTPIDR2_EL0_MASK,
> -				   0);
> -		sysreg_clear_set_s(SYS_HFGWTR_EL2,
> -				   HFGxTR_EL2_nSMPRI_EL1_MASK |
> -				   HFGxTR_EL2_nTPIDR2_EL0_MASK,
> -				   0);
> +	if (cpus_have_final_cap(ARM64_HAS_FGT)) {
> +		write_sysreg_s(__vcpu_sys_reg(vcpu, HFGRTR_EL2),
> +			       SYS_HFGRTR_EL2);
> +
> +		write_sysreg_s(__vcpu_sys_reg(vcpu, HFGWTR_EL2),
> +			       SYS_HFGWTR_EL2);
>  	}
>  }
>  
>  static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_cpu_context *host_ctxt;
> +
>  	write_sysreg(vcpu->arch.mdcr_el2_host, mdcr_el2);
>  
>  	write_sysreg(0, hstr_el2);
>  	if (kvm_arm_support_pmu_v3())
>  		write_sysreg(0, pmuserenr_el0);
>  
> -	if (cpus_have_final_cap(ARM64_SME)) {
> -		sysreg_clear_set_s(SYS_HFGRTR_EL2, 0,
> -				   HFGxTR_EL2_nSMPRI_EL1_MASK |
> -				   HFGxTR_EL2_nTPIDR2_EL0_MASK);
> -		sysreg_clear_set_s(SYS_HFGWTR_EL2, 0,
> -				   HFGxTR_EL2_nSMPRI_EL1_MASK |
> -				   HFGxTR_EL2_nTPIDR2_EL0_MASK);
> +	/*
> +	 * Restore the host FGT configuration here since it's managing
> +	 * traps.
> +	 */
> +	if (cpus_have_final_cap(ARM64_HAS_FGT)) {
> +		host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> +
> +		write_sysreg_s(__vcpu_sys_reg(vcpu, HFGRTR_EL2),
> +			       SYS_HFGRTR_EL2);
> +		write_sysreg_s(__vcpu_sys_reg(vcpu, HFGWTR_EL2),
> +			       SYS_HFGWTR_EL2);

I don't understand this hunk. Where is `host_ctxt` being used?

Will
