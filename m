Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F4C1EBA0F
	for <kvmarm@lists.linux.dev>; Thu, 24 Oct 2024 15:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729783584; cv=none; b=ryQ7HKrCUGv3+Y8WnSkr0bqo1ez7FEzf6x87DEnggu7infqIkbXZmtUKY7FraBqKRyCzt8GJeRlmkuYbHNdhlrAfNWxD2x25I9fr5UDDz/sSqpBtcqvgfuhBZiVveEXGKx1qpAvBCCoueNcYa1ha8CtN/+qvlVYkIdZTVzCQiBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729783584; c=relaxed/simple;
	bh=kzZsei3tp2cmcvoB+MW177567m4eG8TwCQWOhTvDpkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iVK9QbByLWXjZ0X1mOlIYWqFr5LysWN6gzCKLj+TxWfXwxWGc8M5LlwpH7W3numDB7h51++8V7Fdw6baXwDHwc3CxG6mYKqE37KE3LaASfjARcHqufZ6RjXgHznqPjQ5UlwLigjUGlQnEeIjx+g9pKsVscxL854HdWDHBKT1zY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22EB1339;
	Thu, 24 Oct 2024 08:26:51 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4866B3F528;
	Thu, 24 Oct 2024 08:26:20 -0700 (PDT)
Date: Thu, 24 Oct 2024 16:26:18 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v5 33/37] KVM: arm64: Add POE save/restore for AT
 emulation fast-path
Message-ID: <20241024152618.GE1403933@e124191.cambridge.arm.com>
References: <20241023145345.1613824-1-maz@kernel.org>
 <20241023145345.1613824-34-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023145345.1613824-34-maz@kernel.org>

On Wed, Oct 23, 2024 at 03:53:41PM +0100, Marc Zyngier wrote:
> Just like the other extensions affecting address translation,
> we must save/restore POE so that an out-of-context translation
> context can be restored and used with the AT instructions.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/at.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index de7109111e404..ef1643faedeb4 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -440,6 +440,8 @@ struct mmu_config {
>  	u64	tcr2;
>  	u64	pir;
>  	u64	pire0;
> +	u64	por_el0;
> +	u64	por_el1;
>  	u64	sctlr;
>  	u64	vttbr;
>  	u64	vtcr;
> @@ -458,6 +460,10 @@ static void __mmu_config_save(struct mmu_config *config)
>  			config->pir	= read_sysreg_el1(SYS_PIR);
>  			config->pire0	= read_sysreg_el1(SYS_PIRE0);
>  		}
> +		if (system_supports_poe()) {
> +			config->por_el1	= read_sysreg_el1(SYS_POR);
> +			config->por_el0	= read_sysreg_s(SYS_POR_EL0);
> +		}
>  	}
>  	config->sctlr	= read_sysreg_el1(SYS_SCTLR);
>  	config->vttbr	= read_sysreg(vttbr_el2);
> @@ -485,6 +491,10 @@ static void __mmu_config_restore(struct mmu_config *config)
>  			write_sysreg_el1(config->pir, SYS_PIR);
>  			write_sysreg_el1(config->pire0, SYS_PIRE0);
>  		}
> +		if (system_supports_poe()) {
> +			write_sysreg_el1(config->por_el1, SYS_POR);
> +			write_sysreg_s(config->por_el0, SYS_POR_EL0);
> +		}
>  	}
>  	write_sysreg_el1(config->sctlr,	SYS_SCTLR);
>  	write_sysreg(config->vttbr,	vttbr_el2);
> @@ -1105,6 +1115,10 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIR_EL1), SYS_PIR);
>  			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIRE0_EL1), SYS_PIRE0);
>  		}
> +		if (kvm_has_s1poe(vcpu->kvm)) {
> +			write_sysreg_el1(vcpu_read_sys_reg(vcpu, POR_EL1), SYS_POR);
> +			write_sysreg_s(vcpu_read_sys_reg(vcpu, POR_EL0), SYS_POR_EL0);
> +		}
>  	}
>  	write_sysreg_el1(vcpu_read_sys_reg(vcpu, SCTLR_EL1),	SYS_SCTLR);
>  	__load_stage2(mmu, mmu->arch);
> -- 
> 2.39.2
> 
