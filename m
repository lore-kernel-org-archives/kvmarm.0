Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8256D3FA5EB
	for <kvmarm@lists.linux.dev>; Tue,  7 Jul 2026 11:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783424038; cv=none; b=NYbpHgmzUwnI0UiaIqiwwaXluGTB1R8h75HzInrii/u5nKop3s2WjamfewNDNAlDpjgL0ncLfaCnVzT4UDKa4j8aGvL/URmE/6l3zEwZlzTijSnAuYz11J9a9UW0ddbymjlE9peUq6doOWIL0pMyW0riWq+OBAFT3HmO8M5Df/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783424038; c=relaxed/simple;
	bh=1XAe2ZUhlvOC7QtmdS5UOWU2IRYchF7auYMnIfgw640=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cLI6UqUdgt3PjYwz+K1PgsLwE2Y5CTOH753MqDne5QyxvQzQfPxNE8x14UrJxwn9hZlz/WWTq0GEDig0XYbnMyu7zWzo0SHsovxHanW20lPyptssqqXEew5S4lrR2rVLXRZ9mp2J6px0cYKUXLd91QvSoB2daLYhPGeBTyrA/do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hi0VXlpI; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hi0VXlpI"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 38834175D;
	Tue,  7 Jul 2026 04:33:51 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.2.213.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 54FB93F85F;
	Tue,  7 Jul 2026 04:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783424035; bh=1XAe2ZUhlvOC7QtmdS5UOWU2IRYchF7auYMnIfgw640=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hi0VXlpIpiZ82hwRLQm5Vofkrk3YhxHCdOoNNs87xSBVSU1V0U0EEvdkkvK+DS0lg
	 GrfYYYtPrsBtb28egqmvgPcoydYQi2cefyaHB0nb2TN7baSbudDSaiSIlHOQmmL6Ze
	 Z1t3wvX4dTb6+G7meqSLeiOJ7g2ZDlU5HIc2HFYs=
Date: Tue, 7 Jul 2026 12:33:49 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 06/28] KVM: arm64: Classify CPTR_EL2 as a SR_LOC_SPECIAL
 register
Message-ID: <20260707113349.GA922094@e124191.cambridge.arm.com>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702160248.1377250-7-maz@kernel.org>

On Thu, Jul 02, 2026 at 05:02:26PM +0100, Marc Zyngier wrote:
> It may not be obvious unless you look at it closely, but CPTR_EL2
> is treated very differently from other registers. It is one the
> registers that, despite looking very similar between EL1 and EL2
> when E2H==1, have RES0 bits that get in the way.
> 
> Make it clear that CPTR_EL2 is odd by classifying it as SR_LOC_SPECIAL,
> just like CNTHCTL_EL2 (and for the same reasons). This makes it
> possible to use vcpu_read_sys_reg() with it, and will be necessary
> once we support FEAT_NV2P1.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/include/asm/kvm_emulate.h |  2 +-
>  arch/arm64/kvm/sys_regs.c            | 20 ++++++++++++++++++--
>  2 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 5bf3d7e1d92c7..9831166695186 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -617,7 +617,7 @@ static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
>   */
>  static inline u64 vcpu_sanitised_cptr_el2(const struct kvm_vcpu *vcpu)
>  {
> -	u64 cptr = __vcpu_sys_reg(vcpu, CPTR_EL2);
> +	u64 cptr = vcpu_read_sys_reg(vcpu, CPTR_EL2);
>  
>  	if (!vcpu_el2_e2h_is_set(vcpu))
>  		cptr = translate_cptr_el2_to_cpacr_el1(cptr);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5d5c579d45790..6b47d936efb32 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -183,8 +183,6 @@ static void locate_register(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg,
>  	switch (reg) {
>  		MAPPED_EL2_SYSREG(SCTLR_EL2,   SCTLR_EL1,
>  				  translate_sctlr_el2_to_sctlr_el1	     );
> -		MAPPED_EL2_SYSREG(CPTR_EL2,    CPACR_EL1,
> -				  translate_cptr_el2_to_cpacr_el1	     );
>  		MAPPED_EL2_SYSREG(TTBR0_EL2,   TTBR0_EL1,
>  				  translate_ttbr0_el2_to_ttbr0_el1	     );
>  		MAPPED_EL2_SYSREG(TTBR1_EL2,   TTBR1_EL1,   NULL	     );
> @@ -210,6 +208,19 @@ static void locate_register(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg,
>  		loc->loc = ((is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu)) ?
>  			    SR_LOC_SPECIAL : SR_LOC_MEMORY);
>  		break;
> +	case CPTR_EL2:
> +		/*
> +		 * CPTR_EL2 is just as special, and needs a certain amount
> +		 * of handholding. It always lives in memory, due to being
> +		 * heavily trapped thanks to CPACR_EL1.TCPAC being RES0.
> +		 * FEAT_NV2p1 fixes this.
> +		 */
> +		locate_mapped_el2_register(vcpu, CPTR_EL2, CPACR_EL1,
> +					   translate_cptr_el2_to_cpacr_el1,
> +					   loc);
> +		if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu))
> +			loc->loc = SR_LOC_SPECIAL;

Very Minor thing here (feel free to ignore) is that this deviates from
CNTHCTL_EL2 slightly in that it does: `loc->loc = .. ? SR_LOC : SR_LOC`..

> +		break;
>  	default:
>  		loc->loc = locate_direct_register(vcpu, reg);
>  	}
> @@ -314,6 +325,8 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
>  			val &= CNTKCTL_VALID_BITS;
>  			val |= __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
>  			return val;
> +		case CPTR_EL2:
> +			return __vcpu_sys_reg(vcpu, reg);
>  		default:
>  			WARN_ON_ONCE(1);
>  		}
> @@ -359,6 +372,9 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg reg)
>  			 */
>  			write_sysreg_el1(val, SYS_CNTKCTL);
>  			break;
> +		case CPTR_EL2:
> +			write_sysreg_el1(val, SYS_CPACR);
> +			break;
>  		default:
>  			WARN_ON_ONCE(1);
>  		}
> -- 
> 2.47.3
> 

Thanks,
Joey
