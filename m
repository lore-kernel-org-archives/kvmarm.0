Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52EE355C12
	for <kvmarm@lists.linux.dev>; Thu, 25 Jan 2024 13:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706190166; cv=none; b=GoZfnAC1pmY1ZtB3wX6bhdSR8YYNPPs52w6vURma3WtT3TpaWmCxXFC5FuYqFL+6mH/IQQtkNa5DyDCdZEXxpHZU6s/qwXwxH1rY2YgXR03PJN5cvzpLSdThdg937jltj9j+jhX0ONLvljrW0ft15wHdk/jWzrzAfJdRQU1aA6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706190166; c=relaxed/simple;
	bh=RvRs/OTe61/d0lsBdXKEIhOBtMak7jGeGBDp2FkeQfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hsOGJ77qcMMNS5qyLya8k9ObFqcwURyDykClaTiY/vehhprL94l0UgPA/G+KXevSsULnTTfPzLyZ2XtscNgHsamDZ0i2jckwxIPOcIVnfBnwxh/RO6F6tatRL9HWjyUYcELyIRhr8+s6TCAqKfzrlAjk2Mvj2yzQZWEYNQr5Np4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFE5A1FB;
	Thu, 25 Jan 2024 05:43:27 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EBE533F5A1;
	Thu, 25 Jan 2024 05:42:41 -0800 (PST)
Date: Thu, 25 Jan 2024 13:42:39 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 23/25] KVM: arm64: Make AMU sysreg UNDEF if FEAT_AMU is
 not advertised to the guest
Message-ID: <20240125134239.GE1535978@e124191.cambridge.arm.com>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-24-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-24-maz@kernel.org>

On Mon, Jan 22, 2024 at 08:18:50PM +0000, Marc Zyngier wrote:
> No AMU? No AMU! IF we see an AMU-related trap, let's turn it into
> an UNDEF!
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index bcde43b81755..afe6975fcf5c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3994,6 +3994,10 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
>  		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
>  						HFGxTR_EL2_nPIR_EL1);
>  
> +	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, IMP))
> +		kvm->arch.fgu[HAFGRTR_GROUP] |= ~(HAFGRTR_EL2_RES0 |
> +						  HAFGRTR_EL2_RES1);
> +
>  	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
>  out:
>  	mutex_unlock(&kvm->arch.config_lock);

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
