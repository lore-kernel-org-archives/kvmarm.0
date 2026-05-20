Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B11E613A86C
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 13:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779283607; cv=none; b=V4Yffnk8KELM62JPkJWoCtY6/pDM79f1vfEa87ih6GRE2GYkkJ5l2NknjD1N0yP9olNXnqZXYOFgLF2rgkvXIRBmT6j49lvozWXM9HfO75WfDoJy7MCZO2+mHLleJUXTNUrAGS4mAW8F8bXRtaEVB552sYSLmjsaIumP+hW726w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779283607; c=relaxed/simple;
	bh=V2hyoriKu3cBV4ukvXs163SoPkzDnGlLhKwzJje/42I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=axXxvLTv3/q2IosftohunK4UmyPrxw8g9PTO68o3mtb9qdGVeljRUTSid9Idt1sOeK8T1qQj6si9r/EtU6eTQY/OYv5pkTMyL9p1pKWGcwPLHsfa2ILD2cIA75LI/dcixKkPjbR5Wh4r6deiRvTHMZkUH4TUTUjgLk6Ziwb4z2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bqPSUanR; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bqPSUanR"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A440B1595;
	Wed, 20 May 2026 06:26:36 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C6523F632;
	Wed, 20 May 2026 06:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779283601; bh=V2hyoriKu3cBV4ukvXs163SoPkzDnGlLhKwzJje/42I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bqPSUanRr6VyJj7ojnzUcP8QP4AOTE3fTe0RQx7Kr8oitWAut7qL+qIXwvb3jGkCB
	 20IotPVaee7MMJtL9MaSUB3GD8QcRAbcMoKNj9twqqmv7hwwnCRgBCTNX7p3YaY1Ld
	 sQzZje2HuMn3aqGq4sR6l0NtMxlWzcftCE6YmpoA=
Date: Wed, 20 May 2026 14:26:35 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: Re: [PATCH v2 03/18] KVM: arm64: vgic-v5: Remove use of
 __assign_bit() with a constant
Message-ID: <20260520132635.GA4027812@e124191.cambridge.arm.com>
References: <20260520091949.542365-1-maz@kernel.org>
 <20260520091949.542365-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520091949.542365-4-maz@kernel.org>

On Wed, May 20, 2026 at 10:19:34AM +0100, Marc Zyngier wrote:
> Using __assign_bit() is very useful when the value of the bit is
> not known at compile time. In all other cases, __set_bit() and
> __clear_bit() are the correct tool for the job.
> 
> This also fixes an odd case of using VGIC_V5_NR_PRIVATE_IRQS as
> the bit value...
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/vgic/vgic-v5.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 7c146fccc9689..4d62b1c31fe8b 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -25,13 +25,13 @@ static void vgic_v5_get_implemented_ppis(void)
>  	 * If we have KVM, we have EL2, which means that we have support for the
>  	 * EL1 and EL2 Physical & Virtual timers.
>  	 */
> -	__assign_bit(GICV5_ARCH_PPI_CNTHP, ppi_caps.impl_ppi_mask, 1);
> -	__assign_bit(GICV5_ARCH_PPI_CNTV, ppi_caps.impl_ppi_mask, 1);
> -	__assign_bit(GICV5_ARCH_PPI_CNTHV, ppi_caps.impl_ppi_mask, 1);
> -	__assign_bit(GICV5_ARCH_PPI_CNTP, ppi_caps.impl_ppi_mask, 1);
> +	__set_bit(GICV5_ARCH_PPI_CNTHP, ppi_caps.impl_ppi_mask);
> +	__set_bit(GICV5_ARCH_PPI_CNTV, ppi_caps.impl_ppi_mask);
> +	__set_bit(GICV5_ARCH_PPI_CNTHV, ppi_caps.impl_ppi_mask);
> +	__set_bit(GICV5_ARCH_PPI_CNTP, ppi_caps.impl_ppi_mask);
>  
>  	/* The SW_PPI should be available */
> -	__assign_bit(GICV5_ARCH_PPI_SW_PPI, ppi_caps.impl_ppi_mask, 1);
> +	__set_bit(GICV5_ARCH_PPI_SW_PPI, ppi_caps.impl_ppi_mask);
>  
>  	/* The PMUIRQ is available if we have the PMU */
>  	__assign_bit(GICV5_ARCH_PPI_PMUIRQ, ppi_caps.impl_ppi_mask, system_supports_pmuv3());
> @@ -146,9 +146,7 @@ int vgic_v5_init(struct kvm *kvm)
>  	/* We only allow userspace to drive the SW_PPI, if it is implemented. */
>  	bitmap_zero(kvm->arch.vgic.gicv5_vm.userspace_ppis,
>  		    VGIC_V5_NR_PRIVATE_IRQS);
> -	__assign_bit(GICV5_ARCH_PPI_SW_PPI,
> -		     kvm->arch.vgic.gicv5_vm.userspace_ppis,
> -		     VGIC_V5_NR_PRIVATE_IRQS);
> +	__set_bit(GICV5_ARCH_PPI_SW_PPI, kvm->arch.vgic.gicv5_vm.userspace_ppis);
>  	bitmap_and(kvm->arch.vgic.gicv5_vm.userspace_ppis,
>  		   kvm->arch.vgic.gicv5_vm.userspace_ppis,
>  		   ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
> @@ -197,7 +195,7 @@ int vgic_v5_finalize_ppi_state(struct kvm *kvm)
>  		/* Expose PPIs with an owner or the SW_PPI, only */
>  		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
>  			if (irq->owner || i == GICV5_ARCH_PPI_SW_PPI) {
> -				__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, 1);
> +				__set_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
>  				__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
>  					     irq->config == VGIC_CONFIG_LEVEL);
>  			}
> -- 
> 2.47.3
> 
