Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3719E1CAA6C
	for <kvmarm@lists.linux.dev>; Tue, 21 Apr 2026 15:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776784940; cv=none; b=LbV2uG/iVDYa6E0KIcZp5WoDlDMfuFqPsDLgumhrf9YwcFtc5jKhIZSy5jZDnBdFQqevGDjJm46AkSfO36D31aHiRnA5XVWrN+oeO8YBZfriXjIaC6macm/sBX/cTq/vo3PqGrUo2dwK/rg3PF5r7QJZbUKiwq6cAMAvGXbgI3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776784940; c=relaxed/simple;
	bh=nPGT3rI946WNKlLJ1/PxwpN8nrpXwwpVI88NPQnP758=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o0auloTrPaV1/Nw1YOireTkdsiLRHP4uL8pfn99N20Ym2B7gs1P5QXy51KV/kfplnNvaWb2kNhYTZG+2iRTu5F5TPLL0MqdpPCqGC9ZNRRDGmWyD+ljk/ExFU0vcPCl7woTChK+h9yYsLYPi7c5WlD/CqOzbyDZjKNENeCjeG8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=s9PFCBQn; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="s9PFCBQn"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA8F0263D;
	Tue, 21 Apr 2026 08:22:11 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 32E993FAF5;
	Tue, 21 Apr 2026 08:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776784937; bh=nPGT3rI946WNKlLJ1/PxwpN8nrpXwwpVI88NPQnP758=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s9PFCBQnzXXsifSDLMAJDiYgp/ELv3jWXYhoqj5rn8bn/hb3D3HYIUyx4NqQyyZ0a
	 rNS+8kH96rVZkFUf74Io2v/WdtsEZrta7ThX8yANEkYr7LEVMax/GpQvMxUEClkftr
	 ABCEOi0eqWF/cHzZ/MzJMQG9psrwFFopJUkcsVjs=
Date: Tue, 21 Apr 2026 16:22:07 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: Re: [PATCH 06/18] KVM: arm64: vgic: Consolidate
 vgic_allocate_private_irqs_locked()
Message-ID: <20260421152207.GA3862683@e124191.cambridge.arm.com>
References: <20260415115559.2227718-1-maz@kernel.org>
 <20260415115559.2227718-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415115559.2227718-7-maz@kernel.org>

On Wed, Apr 15, 2026 at 12:55:47PM +0100, Marc Zyngier wrote:
> vgic_allocate_private_irqs_locked() calls two helpers, oddly named
> vgic_{,v5_}allocate_private_irq().
> 
> Not only these helpers don't allocate anything, but they also
> contain duplicate init code that would be better placed in the
> caller.
> 
> Consolidate the common init code in the caller, rename the helpers
> to vgic_{,v5_}setup_private_irq(), and pass the irq pointer around
> instead of the index of the interrupt.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c | 45 +++++++++++++--------------------
>  1 file changed, 18 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 933983bb20052..907057881b26a 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -271,18 +271,12 @@ int kvm_vgic_vcpu_nv_init(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> -static void vgic_allocate_private_irq(struct kvm_vcpu *vcpu, int i, u32 type)
> +static void vgic_setup_private_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> +				   u32 type)
>  {
> -	struct vgic_irq *irq = &vcpu->arch.vgic_cpu.private_irqs[i];
> +	irq->intid = irq - &vcpu->arch.vgic_cpu.private_irqs[0];

These are allocated in one block with kzalloc_objs(), so this pointer offsetting is fine!

>  
> -	INIT_LIST_HEAD(&irq->ap_list);
> -	raw_spin_lock_init(&irq->irq_lock);
> -	irq->vcpu = NULL;
> -	irq->target_vcpu = vcpu;
> -	refcount_set(&irq->refcount, 0);
> -
> -	irq->intid = i;
> -	if (vgic_irq_is_sgi(i)) {
> +	if (vgic_irq_is_sgi(irq->intid)) {
>  		/* SGIs */
>  		irq->enabled = 1;
>  		irq->config = VGIC_CONFIG_EDGE;
> @@ -303,18 +297,11 @@ static void vgic_allocate_private_irq(struct kvm_vcpu *vcpu, int i, u32 type)
>  	}
>  }
>  
> -static void vgic_v5_allocate_private_irq(struct kvm_vcpu *vcpu, int i, u32 type)
> +static void vgic_v5_setup_private_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
>  {
> -	struct vgic_irq *irq = &vcpu->arch.vgic_cpu.private_irqs[i];
> -	u32 intid = vgic_v5_make_ppi(i);
> -
> -	INIT_LIST_HEAD(&irq->ap_list);
> -	raw_spin_lock_init(&irq->irq_lock);
> -	irq->vcpu = NULL;
> -	irq->target_vcpu = vcpu;
> -	refcount_set(&irq->refcount, 0);
> +	int i = irq - &vcpu->arch.vgic_cpu.private_irqs[0];
>  
> -	irq->intid = intid;
> +	irq->intid = vgic_v5_make_ppi(i);
>  
>  	/* The only Edge architected PPI is the SW_PPI */
>  	if (i == GICV5_ARCH_PPI_SW_PPI)
> @@ -323,7 +310,7 @@ static void vgic_v5_allocate_private_irq(struct kvm_vcpu *vcpu, int i, u32 type)
>  		irq->config = VGIC_CONFIG_LEVEL;
>  
>  	/* Register the GICv5-specific PPI ops */
> -	vgic_v5_set_ppi_ops(vcpu, intid);
> +	vgic_v5_set_ppi_ops(vcpu, irq->intid);
>  }
>  
>  static int vgic_allocate_private_irqs_locked(struct kvm_vcpu *vcpu, u32 type)
> @@ -349,15 +336,19 @@ static int vgic_allocate_private_irqs_locked(struct kvm_vcpu *vcpu, u32 type)
>  	if (!vgic_cpu->private_irqs)
>  		return -ENOMEM;
>  
> -	/*
> -	 * Enable and configure all SGIs to be edge-triggered and
> -	 * configure all PPIs as level-triggered.
> -	 */
>  	for (i = 0; i < num_private_irqs; i++) {
> +		struct vgic_irq *irq = &vcpu->arch.vgic_cpu.private_irqs[i];
> +
> +		INIT_LIST_HEAD(&irq->ap_list);
> +		raw_spin_lock_init(&irq->irq_lock);
> +		irq->vcpu = NULL;
> +		irq->target_vcpu = vcpu;
> +		refcount_set(&irq->refcount, 0);
> +
>  		if (vgic_is_v5(vcpu->kvm))
> -			vgic_v5_allocate_private_irq(vcpu, i, type);
> +			vgic_v5_setup_private_irq(vcpu, irq);
>  		else
> -			vgic_allocate_private_irq(vcpu, i, type);
> +			vgic_setup_private_irq(vcpu, irq, type);
>  	}
>  
>  	return 0;

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
