From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v7 06/17] KVM: arm/arm64: VGIC: add refcounting for IRQs
Date: Wed, 29 Jun 2016 17:58:59 +0200
Message-ID: <1b593082-8313-cce5-2a30-38b55a75e894@redhat.com>
References: <20160628123230.26255-1-andre.przywara@arm.com>
 <20160628123230.26255-7-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C65F249B61
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 11:53:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q9RqoWT+I07G for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jun 2016 11:53:50 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 544BB49B5C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 11:53:50 -0400 (EDT)
In-Reply-To: <20160628123230.26255-7-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On 28/06/2016 14:32, Andre Przywara wrote:
> In the moment our struct vgic_irq's are statically allocated at guest
> creation time. So getting a pointer to an IRQ structure is trivial and
> safe. LPIs are more dynamic, they can be mapped and unmapped at any time
> during the guest's _runtime_.
> In preparation for supporting LPIs we introduce reference counting for
> those structures using the kernel's kref infrastructure.
> Since private IRQs and SPIs are statically allocated, the reqcount never
s/reqcount/refcount
> drops to 0 at the moment, but we increase it when an IRQ gets onto a VCPU
> list and decrease it when it gets removed.
may be worth clarifying your incr/decr the refcount on vgic_get/put_irq
and each time the irq is added/removed from the ap_list.

> This introduces vgic_put_irq(), which wraps kref_put and hides the
> release function from the callers.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/vgic/vgic.h          |  1 +
>  virt/kvm/arm/vgic/vgic-init.c    |  2 ++
>  virt/kvm/arm/vgic/vgic-mmio-v2.c |  8 ++++++++
>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 10 +++++++---
>  virt/kvm/arm/vgic/vgic-mmio.c    | 22 +++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v2.c      |  1 +
>  virt/kvm/arm/vgic/vgic-v3.c      |  1 +
>  virt/kvm/arm/vgic/vgic.c         | 41 +++++++++++++++++++++++++++++++++-------
>  virt/kvm/arm/vgic/vgic.h         |  1 +
>  9 files changed, 77 insertions(+), 10 deletions(-)
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index 2f26f37..a296d94 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -96,6 +96,7 @@ struct vgic_irq {
>  	bool active;			/* not used for LPIs */
>  	bool enabled;
>  	bool hw;			/* Tied to HW IRQ */
> +	struct kref refcount;		/* Used for LPIs */
>  	u32 hwintid;			/* HW INTID number */
>  	union {
>  		u8 targets;			/* GICv2 target VCPUs mask */
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 90cae48..ac3c1a5 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -177,6 +177,7 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
>  		spin_lock_init(&irq->irq_lock);
>  		irq->vcpu = NULL;
>  		irq->target_vcpu = vcpu0;
> +		kref_init(&irq->refcount);
>  		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
>  			irq->targets = 0;
>  		else
> @@ -211,6 +212,7 @@ static void kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
>  		irq->vcpu = NULL;
>  		irq->target_vcpu = vcpu;
>  		irq->targets = 1U << vcpu->vcpu_id;
> +		kref_init(&irq->refcount);
>  		if (vgic_irq_is_sgi(i)) {
>  			/* SGIs */
>  			irq->enabled = 1;
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index a213936..4152348 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -102,6 +102,7 @@ static void vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
>  		irq->source |= 1U << source_vcpu->vcpu_id;
>  
>  		vgic_queue_irq_unlock(source_vcpu->kvm, irq);
> +		vgic_put_irq(source_vcpu->kvm, irq);
>  	}
>  }
>  
> @@ -116,6 +117,8 @@ static unsigned long vgic_mmio_read_target(struct kvm_vcpu *vcpu,
>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>  
>  		val |= (u64)irq->targets << (i * 8);
> +
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  
>  	return val;
> @@ -143,6 +146,7 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
>  		irq->target_vcpu = kvm_get_vcpu(vcpu->kvm, target);
>  
>  		spin_unlock(&irq->irq_lock);
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  }
>  
> @@ -157,6 +161,8 @@ static unsigned long vgic_mmio_read_sgipend(struct kvm_vcpu *vcpu,
>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>  
>  		val |= (u64)irq->source << (i * 8);
> +
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  	return val;
>  }
> @@ -178,6 +184,7 @@ static void vgic_mmio_write_sgipendc(struct kvm_vcpu *vcpu,
>  			irq->pending = false;
>  
>  		spin_unlock(&irq->irq_lock);
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  }
>  
> @@ -201,6 +208,7 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
>  		} else {
>  			spin_unlock(&irq->irq_lock);
>  		}
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  }
>  
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index fc7b6c9..829909e 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -80,15 +80,17 @@ static unsigned long vgic_mmio_read_irouter(struct kvm_vcpu *vcpu,
>  {
>  	int intid = VGIC_ADDR_TO_INTID(addr, 64);
>  	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
> +	unsigned long ret = 0;
>  
>  	if (!irq)
>  		return 0;
>  
>  	/* The upper word is RAZ for us. */
> -	if (addr & 4)
> -		return 0;
> +	if (!(addr & 4))
> +		ret = extract_bytes(READ_ONCE(irq->mpidr), addr & 7, len);
>  
> -	return extract_bytes(READ_ONCE(irq->mpidr), addr & 7, len);
> +	vgic_put_irq(vcpu->kvm, irq);
> +	return ret;
>  }
>  
>  static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
> @@ -112,6 +114,7 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
>  	irq->target_vcpu = kvm_mpidr_to_vcpu(vcpu->kvm, irq->mpidr);
>  
>  	spin_unlock(&irq->irq_lock);
> +	vgic_put_irq(vcpu->kvm, irq);
you need one put in:

	/* The upper word is WI for us since we don't implement Aff3. */
	if (addr & 4)
		return;
>  }
>  
>  static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
> @@ -445,5 +448,6 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
>  		irq->pending = true;
>  
>  		vgic_queue_irq_unlock(vcpu->kvm, irq);
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  }
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index 9f6fab7..630d1c3 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -56,6 +56,8 @@ unsigned long vgic_mmio_read_enable(struct kvm_vcpu *vcpu,
>  
>  		if (irq->enabled)
>  			value |= (1U << i);
> +
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  
>  	return value;
> @@ -74,6 +76,8 @@ void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
>  		spin_lock(&irq->irq_lock);
>  		irq->enabled = true;
>  		vgic_queue_irq_unlock(vcpu->kvm, irq);
> +
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  }
>  
> @@ -92,6 +96,7 @@ void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
>  		irq->enabled = false;
>  
>  		spin_unlock(&irq->irq_lock);
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  }
>  
> @@ -108,6 +113,8 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>  
>  		if (irq->pending)
>  			value |= (1U << i);
> +
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  
>  	return value;
> @@ -129,6 +136,7 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
>  			irq->soft_pending = true;
>  
>  		vgic_queue_irq_unlock(vcpu->kvm, irq);
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  }
>  
> @@ -152,6 +160,7 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
>  		}
>  
>  		spin_unlock(&irq->irq_lock);
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  }
>  
> @@ -168,6 +177,8 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
>  
>  		if (irq->active)
>  			value |= (1U << i);
> +
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  
>  	return value;
> @@ -190,6 +201,7 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  	 * IRQ, so we release and re-acquire the spin_lock to let the
>  	 * other thread sync back the IRQ.
>  	 */
> +
unrelated new line?
>  	while (irq->vcpu && /* IRQ may have state in an LR somewhere */
>  	       irq->vcpu->cpu != -1) /* VCPU thread is running */
>  		cond_resched_lock(&irq->irq_lock);
> @@ -242,6 +254,7 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
>  	for_each_set_bit(i, &val, len * 8) {
>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>  		vgic_mmio_change_active(vcpu, irq, false);
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  	vgic_change_active_finish(vcpu, intid);
>  }
> @@ -257,6 +270,7 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
>  	for_each_set_bit(i, &val, len * 8) {
>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>  		vgic_mmio_change_active(vcpu, irq, true);
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  	vgic_change_active_finish(vcpu, intid);
>  }
> @@ -272,6 +286,8 @@ unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>  
>  		val |= (u64)irq->priority << (i * 8);
> +
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  
>  	return val;
> @@ -298,6 +314,8 @@ void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
>  		/* Narrow the priority range to what we actually support */
>  		irq->priority = (val >> (i * 8)) & GENMASK(7, 8 - VGIC_PRI_BITS);
>  		spin_unlock(&irq->irq_lock);
> +
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  }
>  
> @@ -313,6 +331,8 @@ unsigned long vgic_mmio_read_config(struct kvm_vcpu *vcpu,
>  
>  		if (irq->config == VGIC_CONFIG_EDGE)
>  			value |= (2U << (i * 2));
> +
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  
>  	return value;
> @@ -345,6 +365,8 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
>  			irq->pending = irq->line_level | irq->soft_pending;
>  		}
>  		spin_unlock(&irq->irq_lock);
> +
> +		vgic_put_irq(vcpu->kvm, irq);
you also need a put at:
		if (intid + i < VGIC_NR_PRIVATE_IRQS)
			continue;
>  	}
>  }
>  
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index 80313de..cedde7d 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -124,6 +124,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>  		}
>  
>  		spin_unlock(&irq->irq_lock);
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  }
>  
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index e48a22e..f0ac064 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -113,6 +113,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>  		}
>  
>  		spin_unlock(&irq->irq_lock);
> +		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  }
>  
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 69b61ab..b90705c 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -48,13 +48,20 @@ struct vgic_global __section(.hyp.text) kvm_vgic_global_state;
>  struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  			      u32 intid)
>  {
> -	/* SGIs and PPIs */
> -	if (intid <= VGIC_MAX_PRIVATE)
> -		return &vcpu->arch.vgic_cpu.private_irqs[intid];
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_irq *irq;
> +
> +	if (intid <= VGIC_MAX_PRIVATE) {        /* SGIs and PPIs */
> +		irq = &vcpu->arch.vgic_cpu.private_irqs[intid];
> +		kref_get(&irq->refcount);
> +		return irq;
> +	}
>  
> -	/* SPIs */
> -	if (intid <= VGIC_MAX_SPI)
> -		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
> +	if (intid <= VGIC_MAX_SPI) {            /* SPIs */
> +		irq = &dist->spis[intid - VGIC_NR_PRIVATE_IRQS];
> +		kref_get(&irq->refcount);
> +		return irq;
> +	}
>  
>  	/* LPIs are not yet covered */
>  	if (intid >= VGIC_MIN_LPI)
> @@ -64,6 +71,17 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  	return NULL;
>  }
>  
> +/* The refcount should never drop to 0 at the moment. */
> +static void vgic_irq_release(struct kref *ref)
> +{
> +	WARN_ON(1);
> +}
> +
> +void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
> +{
> +	kref_put(&irq->refcount, vgic_irq_release);
> +}
> +
>  /**
>   * kvm_vgic_target_oracle - compute the target vcpu for an irq
>   *
> @@ -236,6 +254,7 @@ retry:
>  		goto retry;
>  	}
>  
> +	kref_get(&irq->refcount);
>  	list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
>  	irq->vcpu = vcpu;
>  
> @@ -269,14 +288,17 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
>  	if (!irq)
>  		return -EINVAL;
>  
> -	if (irq->hw != mapped_irq)
> +	if (irq->hw != mapped_irq) {
> +		vgic_put_irq(kvm, irq);
>  		return -EINVAL;
> +	}
>  
>  	spin_lock(&irq->irq_lock);
>  
>  	if (!vgic_validate_injection(irq, level)) {
>  		/* Nothing to see here, move along... */
>  		spin_unlock(&irq->irq_lock);
> +		vgic_put_irq(kvm, irq);
maybe a goto label would be relevant?
>  		return 0;
>  	}
>  
> @@ -288,6 +310,7 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
>  	}
>  
>  	vgic_queue_irq_unlock(kvm, irq);
> +	vgic_put_irq(kvm, irq);
>  
>  	return 0;
>  }
> @@ -330,6 +353,7 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq)
>  	irq->hwintid = phys_irq;
>  
>  	spin_unlock(&irq->irq_lock);
> +	vgic_put_irq(vcpu->kvm, irq);
>  
>  	return 0;
>  }
> @@ -349,6 +373,7 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq)
>  	irq->hwintid = 0;
>  
>  	spin_unlock(&irq->irq_lock);
> +	vgic_put_irq(vcpu->kvm, irq);
put at:
	if (!vgic_initialized(vcpu->kvm))
		return -EAGAIN;

Cheers

Eric
>  
>  	return 0;
>  }
> @@ -386,6 +411,7 @@ retry:
>  			list_del(&irq->ap_list);
>  			irq->vcpu = NULL;
>  			spin_unlock(&irq->irq_lock);
> +			vgic_put_irq(vcpu->kvm, irq);
>  			continue;
>  		}
>  
> @@ -614,6 +640,7 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
>  	spin_lock(&irq->irq_lock);
>  	map_is_active = irq->hw && irq->active;
>  	spin_unlock(&irq->irq_lock);
> +	vgic_put_irq(vcpu->kvm, irq);
>  
>  	return map_is_active;
>  }
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index c752152..5b79c34 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -38,6 +38,7 @@ struct vgic_vmcr {
>  
>  struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  			      u32 intid);
> +void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
>  bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
>  void vgic_kick_vcpus(struct kvm *kvm);
>  
> 
