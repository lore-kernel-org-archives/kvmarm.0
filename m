Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6524F7E78B
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 16:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706115446; cv=none; b=uWRrqTElEZltaJ3j/R0yHUI6fwV+4uA2zqC5g31Fg4u/V9WsljO7qWvwKu2UrzhAvGoOvugx4QUvXpGyKjHHnSqNfjr/gB0DyDaQZoT1sbUrDb89VveKyS2VC1kf6ekp2NwSQrE7X8I3g7eyxOLsRgGP3rUXYOTaa7QbwgIAehw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706115446; c=relaxed/simple;
	bh=cgTur/W6o3cGZBW0U2qon29cLXjTRoze49kvEMNEfBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q4C9+plSkKufRnbEOl0zmbqX6i27iIxnliKJSA7okKZdklhHKhBVPgUmFthzcIQnLXdqkpY8q9DobRU3yUNgqy9PdlXNB/sWeS89sJPZ8svi3xCLUJGE6Y0d705b5H/l1n8kbVhruwN4gGj1vn3at8Ym1nIFak6kTRxHrTysBdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78BA81FB;
	Wed, 24 Jan 2024 08:58:08 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 63BD03F762;
	Wed, 24 Jan 2024 08:57:22 -0800 (PST)
Date: Wed, 24 Jan 2024 16:57:20 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 16/25] KVM: arm64: Rename __check_nv_sr_forward() to
 triage_sysreg_trap()
Message-ID: <20240124165720.GL1283334@e124191.cambridge.arm.com>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-17-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-17-maz@kernel.org>

On Mon, Jan 22, 2024 at 08:18:43PM +0000, Marc Zyngier wrote:
> __check_nv_sr_forward() is not specific to NV anymore, and does
> a lot more. Rename it to triage_sysreg_trap(), making it plain
> that its role is to handle where an exception is to be handled.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h | 1 -
>  arch/arm64/kvm/emulate-nested.c     | 2 +-
>  arch/arm64/kvm/sys_regs.c           | 2 +-
>  arch/arm64/kvm/sys_regs.h           | 2 ++
>  4 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 68465f87d308..c77d795556e1 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -60,7 +60,6 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
>  	return ttbr0 & ~GENMASK_ULL(63, 48);
>  }
>  
> -extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu, int *sr_idx);
>  
>  int kvm_init_nv_sysregs(struct kvm *kvm);
>  
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 54ab4d240fc6..b39ced4ea331 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2001,7 +2001,7 @@ static bool check_fgt_bit(struct kvm *kvm, bool is_read,
>  	return !(kvm_get_sysreg_res0(kvm, sr) & BIT(tc.bit));
>  }
>  
> -bool __check_nv_sr_forward(struct kvm_vcpu *vcpu, int *sr_index)
> +bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
>  {
>  	union trap_config tc;
>  	enum trap_behaviour b;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 794d1f8c9bfe..c48bc2577162 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3484,7 +3484,7 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
>  
>  	trace_kvm_handle_sys_reg(esr);
>  
> -	if (__check_nv_sr_forward(vcpu, &sr_idx))
> +	if (triage_sysreg_trap(vcpu, &sr_idx))
>  		return 1;
>  
>  	params = esr_sys64_to_params(esr);
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index c65c129b3500..997eea21ba2a 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -233,6 +233,8 @@ int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
>  int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
>  			 const struct sys_reg_desc table[], unsigned int num);
>  
> +bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index);
> +
>  #define AA32(_x)	.aarch32_map = AA32_##_x
>  #define Op0(_x) 	.Op0 = _x
>  #define Op1(_x) 	.Op1 = _x

It's strange having triage_sysreg_trap() in emulate-nested.c, but moving that
would be churn for little benefit. Maybe once NV is all in.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
