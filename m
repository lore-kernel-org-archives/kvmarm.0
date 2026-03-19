Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2391A3009E2;
	Thu, 19 Mar 2026 18:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773946268; cv=none; b=fv1nJVd6QJWaNq84GB0gu4iPFmdzpiHH/7pgkXL1b/FzS1nafb87k1qiwIrTOuV8I04WVJr2DtcAi4XfP3JwfXQm1iJBaAFvRzeJmM56QweRIiYmEckxI5jeiTHJtLE5XTJi3ZDdcc+vapvsUXnAQmB0ELylmAOZnDOEz6qAU9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773946268; c=relaxed/simple;
	bh=wQL8oyqZ+Dngpza4C+otz3BBsfXKzyvLTqxEWVzoHOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mI136Jzc3I8Q6T3c1Hh7tRgyLZ36eqp04MGGzXDUqImj62m4eMJqfzMkwQ/rwq40JJYFKlOpXcd5qHV4R4g++tpj6OayiKydiKpaKNH99MCatNQOQ/dynUC48o8bVerXv2bmQZFuTaRi4L9+qJGV5ADgoKrHXGv9vmDdj6kqKek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 372552247;
	Thu, 19 Mar 2026 11:50:59 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C4C1D3F7BD;
	Thu, 19 Mar 2026 11:51:00 -0700 (PDT)
Date: Thu, 19 Mar 2026 18:50:52 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH v13 39/48] arm64: RMI: Propagate number of breakpoints
 and watchpoints to userspace
Message-ID: <yqg4omdkqvslldhxbdzctbgxirxomw6mparqvhuybwyzthhdy3@6glrgqmfydsj>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-40-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318155413.793430-40-steven.price@arm.com>

On Wed, Mar 18, 2026 at 03:54:03PM +0000, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> The RMM describes the maximum number of BPs/WPs available to the guest
> in the Feature Register 0. Propagate those numbers into ID_AA64DFR0_EL1,
> which is visible to userspace. A VMM needs this information in order to
> set up realm parameters.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> ---
>  arch/arm64/include/asm/kvm_rmi.h |  2 ++
>  arch/arm64/kvm/rmi.c             | 22 ++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c        |  2 +-
>  3 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index 17bb7e2a2aa0..8fb526764c30 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -87,6 +87,8 @@ struct realm_rec {
>  void kvm_init_rmi(void);
>  u32 kvm_realm_ipa_limit(void);
>  
> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
> +
>  bool kvm_rmi_supports_sve(void);
>  bool kvm_rmi_supports_pmu(void);
>  
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 8dc090da6e5f..01519d934d3a 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -212,6 +212,28 @@ u32 kvm_realm_ipa_limit(void)
>  	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
>  }
>  
> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
> +{
> +	u32 bps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_BPS);
> +	u32 wps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_WPS);
> +	u32 ctx_cmps;
> +
> +	if (!kvm_is_realm(vcpu->kvm))
> +		return val;
> +
> +	/* Ensure CTX_CMPs is still valid */
> +	ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs, val);
> +	ctx_cmps = min(bps, ctx_cmps);
> +
> +	val &= ~(ID_AA64DFR0_EL1_BRPs_MASK | ID_AA64DFR0_EL1_WRPs_MASK |
> +		 ID_AA64DFR0_EL1_CTX_CMPs);
> +	val |= FIELD_PREP(ID_AA64DFR0_EL1_BRPs_MASK, bps) |
> +	       FIELD_PREP(ID_AA64DFR0_EL1_WRPs_MASK, wps) |
> +	       FIELD_PREP(ID_AA64DFR0_EL1_CTX_CMPs, ctx_cmps);
> +
> +	return val;
> +}
> +
>  static int get_start_level(struct realm *realm)
>  {
>  	return 4 - stage2_pgtable_levels(realm->ia_bits);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 46f5e2ab3e2c..83b5c36f43bf 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2043,7 +2043,7 @@ static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>  	/* Hide BRBE from guests */
>  	val &= ~ID_AA64DFR0_EL1_BRBE_MASK;
>  
> -	return val;
> +	return kvm_realm_reset_id_aa64dfr0_el1(vcpu, val);

Hi,

Nit:
In other places we condition on kvm_is_realm() to separate
realm/non-realm paths but here everyone goes into kvm_realm_*, do you
think it's more consistent to move the kvm_is_realm() check out of this
function?

Thanks,
Wei-Lin Chang

>  }
>  
>  /*
> -- 
> 2.43.0
> 
