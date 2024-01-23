Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB9EE5F841
	for <kvmarm@lists.linux.dev>; Tue, 23 Jan 2024 14:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706018495; cv=none; b=ihT9suBe05LKvTrlvvvWIsRdSw0Vj4Aex2Y7orL4LOmaPz/7luOpnemuGhtmThB9D+QSCVWnfT4QHdpA/LtLQvzUU9MHOl5W1sxeu4sVHyx3ZuvlhJZlOFyrgU7e9yNutqnR8AQedoTGHv7fegPY2UCmfpHJEO4bdN119lgzV/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706018495; c=relaxed/simple;
	bh=P8Cq+aVBlWvw5YwhK8HVEGtCY9PMiaCucmh92lhFAuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X2aaAGe9HqKkST2sHqtEJ3wGupBw9QKeI/8Jcj4CicVMUIkpDkeGOX4/DiGzmCBEMRbSbUJhrRarvcCtJngE/wvoxh2bdvFNrCfqwLNxVWVb7l9HeUdv80jLOWHdaroMNSbVZheOzWYLT1k270y0QGjm2Y5mB82tzFeuM1Qps7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 765431FB;
	Tue, 23 Jan 2024 06:02:17 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CB9033F762;
	Tue, 23 Jan 2024 06:01:30 -0800 (PST)
Date: Tue, 23 Jan 2024 14:01:28 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 07/25] KVM: arm64: nv: Drop sanitised_sys_reg() helper
Message-ID: <20240123140128.GC1283334@e124191.cambridge.arm.com>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-8-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-8-maz@kernel.org>

Hi,

On Mon, Jan 22, 2024 at 08:18:34PM +0000, Marc Zyngier wrote:
> Now that we have the infrastructure to enforce a sanitised register
> value depending on the VM configuration, drop the helper that only
> used the architectural RES0 value.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/emulate-nested.c | 22 +++++++---------------
>  1 file changed, 7 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 431fd429932d..7a4a886adb9d 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -1897,14 +1897,6 @@ static bool check_fgt_bit(u64 val, const union trap_config tc)
>  	return ((val >> tc.bit) & 1) == tc.pol;
>  }
>  
> -#define sanitised_sys_reg(vcpu, reg)			\
> -	({						\
> -		u64 __val;				\
> -		__val = __vcpu_sys_reg(vcpu, reg);	\
> -		__val &= ~__ ## reg ## _RES0;		\
> -		(__val);				\
> -	})
> -
>  bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>  {
>  	union trap_config tc;
> @@ -1940,25 +1932,25 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>  
>  	case HFGxTR_GROUP:
>  		if (is_read)
> -			val = sanitised_sys_reg(vcpu, HFGRTR_EL2);
> +			val = __vcpu_sys_reg(vcpu, HFGRTR_EL2);
>  		else
> -			val = sanitised_sys_reg(vcpu, HFGWTR_EL2);
> +			val = __vcpu_sys_reg(vcpu, HFGWTR_EL2);
>  		break;
>  
>  	case HDFGRTR_GROUP:
>  	case HDFGWTR_GROUP:
>  		if (is_read)
> -			val = sanitised_sys_reg(vcpu, HDFGRTR_EL2);
> +			val = __vcpu_sys_reg(vcpu, HDFGRTR_EL2);
>  		else
> -			val = sanitised_sys_reg(vcpu, HDFGWTR_EL2);
> +			val = __vcpu_sys_reg(vcpu, HDFGWTR_EL2);
>  		break;
>  
>  	case HAFGRTR_GROUP:
> -		val = sanitised_sys_reg(vcpu, HAFGRTR_EL2);
> +		val = __vcpu_sys_reg(vcpu, HAFGRTR_EL2);
>  		break;
>  
>  	case HFGITR_GROUP:
> -		val = sanitised_sys_reg(vcpu, HFGITR_EL2);
> +		val = __vcpu_sys_reg(vcpu, HFGITR_EL2);
>  		switch (tc.fgf) {
>  			u64 tmp;
>  
> @@ -1966,7 +1958,7 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>  			break;
>  
>  		case HCRX_FGTnXS:
> -			tmp = sanitised_sys_reg(vcpu, HCRX_EL2);
> +			tmp = __vcpu_sys_reg(vcpu, HCRX_EL2);
>  			if (tmp & HCRX_EL2_FGTnXS)
>  				tc.fgt = __NO_FGT_GROUP__;
>  		}

Thanks,
Joey
