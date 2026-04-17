Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3DEB33F8B7
	for <kvmarm@lists.linux.dev>; Fri, 17 Apr 2026 16:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776442232; cv=none; b=A8HzU02M3fRGxzTh9XojbkLRGOFfpERdEhDMY8X59dhXA9zZYrzLzvkgfLyi5TbC/xfGVcjZiL5DVynfltTgSMsK/8vU8N6B+soumjQQDEx5HcivPGgYgQWXmlM/KdfEYyEA3+2yfp50w7lm7g7o1dg2w0ZVQGmEBFVwo0xXPC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776442232; c=relaxed/simple;
	bh=XX5Jc5mwKcR3BHo7TPiJOgf4iAQTIKsLBFkjvK6rZPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BFiUDrSviBZDoiNpV33I4K6SvFbunBR9ZDMgPR01FJkmgyaCQDcqMGz+lZddPBfDwqs8BLHRhNslXOJtQbA+OaoeP+CUZkAUlNGNSQL1thsQgnVrS7CE7MXpvRDRVydpOS4vXuV2x0QnYcJHz4QUvmsQbMDw3fVwVlZNEeMQ+k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OmPMow/v; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OmPMow/v"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 59A871DB5;
	Fri, 17 Apr 2026 09:10:24 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D42973F641;
	Fri, 17 Apr 2026 09:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776442230; bh=XX5Jc5mwKcR3BHo7TPiJOgf4iAQTIKsLBFkjvK6rZPM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OmPMow/vX8WYOIT1UZvNxYcV3rE+cDGzptJrJv//wnH/4t7JrUskipDkXBTQvwWvC
	 SHD334VgWS2Zr5iDQ5mAhsTkGdXeDX4Ml94dUOUPrGb3bNkcmgJIXubWuH8gxmsopo
	 VmQKtLOkLErgUnwB+X8igVawt8eezB79SU8IEj6o=
Date: Fri, 17 Apr 2026 17:10:26 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: Re: [PATCH 09/18] KVM: arm64: vgic-v5: Limit support to 64 PPIs
Message-ID: <20260417161026.GC3311048@e124191.cambridge.arm.com>
References: <20260415115559.2227718-1-maz@kernel.org>
 <20260415115559.2227718-10-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415115559.2227718-10-maz@kernel.org>

On Wed, Apr 15, 2026 at 12:55:50PM +0100, Marc Zyngier wrote:
> Although we have some code supporting 128 PPIs, the only supported
> configuration is 64 PPIs. There is no way to test the 128 PPI code,
> so it is bound to bitrot very quickly.
> 
> Given that KVM/arm64's goal has always been to stick to non-IMPDEF
> behaviours, drop the 128 PPI support. Someone motivated enough and
> with very strong arguments can always bring it back -- it's all in
> the git history.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/hyp/vgic-v5-sr.c       | 82 ++++++---------------------
>  arch/arm64/kvm/sys_regs.c             | 17 +++---
>  arch/arm64/kvm/vgic/vgic-kvm-device.c |  9 +--
>  3 files changed, 26 insertions(+), 82 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-sr.c
> index 47e6bcd437029..6d69dfe89a96c 100644
> --- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
> @@ -30,10 +30,9 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_if)
>  {
>  	/*
>  	 * The following code assumes that the bitmap storage that we have for
> -	 * PPIs is either 64 (architected PPIs, only) or 128 bits (architected &
> -	 * impdef PPIs).
> +	 * PPIs is either 64 (architected PPIs, only).
>  	 */
> -	BUILD_BUG_ON(VGIC_V5_NR_PRIVATE_IRQS % 64);
> +	BUILD_BUG_ON(VGIC_V5_NR_PRIVATE_IRQS != 64);
>  
>  	bitmap_write(host_data_ptr(vgic_v5_ppi_state)->activer_exit,
>  		     read_sysreg_s(SYS_ICH_PPI_ACTIVER0_EL2), 0, 64);
> @@ -49,22 +48,6 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_if)
>  	cpu_if->vgic_ppi_priorityr[6] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR6_EL2);
>  	cpu_if->vgic_ppi_priorityr[7] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR7_EL2);
>  
> -	if (VGIC_V5_NR_PRIVATE_IRQS == 128) {
> -		bitmap_write(host_data_ptr(vgic_v5_ppi_state)->activer_exit,
> -			     read_sysreg_s(SYS_ICH_PPI_ACTIVER1_EL2), 64, 64);
> -		bitmap_write(host_data_ptr(vgic_v5_ppi_state)->pendr,
> -			     read_sysreg_s(SYS_ICH_PPI_PENDR1_EL2), 64, 64);
> -
> -		cpu_if->vgic_ppi_priorityr[8] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR8_EL2);
> -		cpu_if->vgic_ppi_priorityr[9] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR9_EL2);
> -		cpu_if->vgic_ppi_priorityr[10] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR10_EL2);
> -		cpu_if->vgic_ppi_priorityr[11] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR11_EL2);
> -		cpu_if->vgic_ppi_priorityr[12] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR12_EL2);
> -		cpu_if->vgic_ppi_priorityr[13] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR13_EL2);
> -		cpu_if->vgic_ppi_priorityr[14] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR14_EL2);
> -		cpu_if->vgic_ppi_priorityr[15] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR15_EL2);
> -	}
> -
>  	/* Now that we are done, disable DVI */
>  	write_sysreg_s(0, SYS_ICH_PPI_DVIR0_EL2);
>  	write_sysreg_s(0, SYS_ICH_PPI_DVIR1_EL2);
> @@ -74,9 +57,6 @@ void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if)
>  {
>  	DECLARE_BITMAP(pendr, VGIC_V5_NR_PRIVATE_IRQS);
>  
> -	/* We assume 64 or 128 PPIs - see above comment */
> -	BUILD_BUG_ON(VGIC_V5_NR_PRIVATE_IRQS % 64);
> -
>  	/* Enable DVI so that the guest's interrupt config takes over */
>  	write_sysreg_s(bitmap_read(cpu_if->vgic_ppi_dvir, 0, 64),
>  		       SYS_ICH_PPI_DVIR0_EL2);
> @@ -108,50 +88,20 @@ void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if)
>  	write_sysreg_s(cpu_if->vgic_ppi_priorityr[7],
>  		       SYS_ICH_PPI_PRIORITYR7_EL2);
>  
> -	if (VGIC_V5_NR_PRIVATE_IRQS == 128) {
> -		/* Enable DVI so that the guest's interrupt config takes over */
> -		write_sysreg_s(bitmap_read(cpu_if->vgic_ppi_dvir, 64, 64),
> -			       SYS_ICH_PPI_DVIR1_EL2);
> -
> -		write_sysreg_s(bitmap_read(cpu_if->vgic_ppi_activer, 64, 64),
> -			       SYS_ICH_PPI_ACTIVER1_EL2);
> -		write_sysreg_s(bitmap_read(cpu_if->vgic_ppi_enabler, 64, 64),
> -			       SYS_ICH_PPI_ENABLER1_EL2);
> -		write_sysreg_s(bitmap_read(pendr, 64, 64),
> -			       SYS_ICH_PPI_PENDR1_EL2);
> -
> -		write_sysreg_s(cpu_if->vgic_ppi_priorityr[8],
> -			       SYS_ICH_PPI_PRIORITYR8_EL2);
> -		write_sysreg_s(cpu_if->vgic_ppi_priorityr[9],
> -			       SYS_ICH_PPI_PRIORITYR9_EL2);
> -		write_sysreg_s(cpu_if->vgic_ppi_priorityr[10],
> -			       SYS_ICH_PPI_PRIORITYR10_EL2);
> -		write_sysreg_s(cpu_if->vgic_ppi_priorityr[11],
> -			       SYS_ICH_PPI_PRIORITYR11_EL2);
> -		write_sysreg_s(cpu_if->vgic_ppi_priorityr[12],
> -			       SYS_ICH_PPI_PRIORITYR12_EL2);
> -		write_sysreg_s(cpu_if->vgic_ppi_priorityr[13],
> -			       SYS_ICH_PPI_PRIORITYR13_EL2);
> -		write_sysreg_s(cpu_if->vgic_ppi_priorityr[14],
> -			       SYS_ICH_PPI_PRIORITYR14_EL2);
> -		write_sysreg_s(cpu_if->vgic_ppi_priorityr[15],
> -			       SYS_ICH_PPI_PRIORITYR15_EL2);
> -	} else {
> -		write_sysreg_s(0, SYS_ICH_PPI_DVIR1_EL2);
> -
> -		write_sysreg_s(0, SYS_ICH_PPI_ACTIVER1_EL2);
> -		write_sysreg_s(0, SYS_ICH_PPI_ENABLER1_EL2);
> -		write_sysreg_s(0, SYS_ICH_PPI_PENDR1_EL2);
> -
> -		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR8_EL2);
> -		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR9_EL2);
> -		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR10_EL2);
> -		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR11_EL2);
> -		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR12_EL2);
> -		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR13_EL2);
> -		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR14_EL2);
> -		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR15_EL2);
> -	}
> +	write_sysreg_s(0, SYS_ICH_PPI_DVIR1_EL2);
> +
> +	write_sysreg_s(0, SYS_ICH_PPI_ACTIVER1_EL2);
> +	write_sysreg_s(0, SYS_ICH_PPI_ENABLER1_EL2);
> +	write_sysreg_s(0, SYS_ICH_PPI_PENDR1_EL2);
> +
> +	write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR8_EL2);
> +	write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR9_EL2);
> +	write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR10_EL2);
> +	write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR11_EL2);
> +	write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR12_EL2);
> +	write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR13_EL2);
> +	write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR14_EL2);
> +	write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR15_EL2);
>  }
>  
>  void __vgic_v5_save_state(struct vgic_v5_cpu_if *cpu_if)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 4ef13ac0703df..eba3ef793097d 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -724,6 +724,7 @@ static bool access_gicv5_ppi_enabler(struct kvm_vcpu *vcpu,
>  {
>  	unsigned long *mask = vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask;
>  	struct vgic_v5_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v5;
> +	unsigned long reg = p->regval;
>  	int i;
>  
>  	/* We never expect to get here with a read! */
> @@ -731,21 +732,17 @@ static bool access_gicv5_ppi_enabler(struct kvm_vcpu *vcpu,
>  		return undef_access(vcpu, p, r);
>  
>  	/*
> -	 * If we're only handling architected PPIs and the guest writes to the
> -	 * enable for the non-architected PPIs, we just return as there's
> -	 * nothing to do at all. We don't even allocate the storage for them in
> -	 * this case.
> +	 * As we're only handling architected PPIs, the guest writes to the
> +	 * enable for the non-architected PPIs just return as there's
> +	 * nothing to do at all. We don't even allocate the storage for them.
>  	 */
> -	if (VGIC_V5_NR_PRIVATE_IRQS == 64 && p->Op2 % 2)
> +	if (p->Op2 % 2)
>  		return true;
>  
>  	/*
> -	 * Merge the raw guest write into out bitmap at an offset of either 0 or
> -	 * 64, then and it with our PPI mask.
> +	 * Merge the raw guest write into out bitmap, anded with our PPI mask.
>  	 */
> -	bitmap_write(cpu_if->vgic_ppi_enabler, p->regval, 64 * (p->Op2 % 2), 64);
> -	bitmap_and(cpu_if->vgic_ppi_enabler, cpu_if->vgic_ppi_enabler, mask,
> -		   VGIC_V5_NR_PRIVATE_IRQS);
> +	bitmap_and(cpu_if->vgic_ppi_enabler, &reg, mask, VGIC_V5_NR_PRIVATE_IRQS);
>  
>  	/*
>  	 * Sync the change in enable states to the vgic_irqs. We consider all
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index a96c77dccf353..90be99443df3b 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -730,18 +730,15 @@ static int vgic_v5_get_userspace_ppis(struct kvm_device *dev,
>  	guard(mutex)(&dev->kvm->arch.config_lock);
>  
>  	/*
> -	 * We either support 64 or 128 PPIs. In the former case, we need to
> -	 * return 0s for the second 64 bits as we have no storage backing those.
> +	 * We only support 64 PPIs, so, we need to return 0s for the
> +	 * second 64 bits as we have no storage backing those.
>  	 */
>  	ret = put_user(bitmap_read(gicv5_vm->userspace_ppis, 0, 64), uaddr);
>  	if (ret)
>  		return ret;
>  	uaddr++;
>  
> -	if (VGIC_V5_NR_PRIVATE_IRQS == 128)
> -		ret = put_user(bitmap_read(gicv5_vm->userspace_ppis, 64, 128), uaddr);
> -	else
> -		ret = put_user(0, uaddr);
> +	ret = put_user(0, uaddr);
>  
>  	return ret;
>  }
> -- 
> 2.47.3
> 
