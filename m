From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 06/17] KVM: arm/arm64: VGIC: add refcounting for IRQs
Date: Fri, 8 Jul 2016 11:50:57 +0100
Message-ID: <577F8591.1090502@arm.com>
References: <20160705112309.28877-1-andre.przywara@arm.com>
 <20160705112309.28877-7-andre.przywara@arm.com> <577E6E99.9040003@arm.com>
 <da96b431-11ed-cd7d-fa77-0e261a8ad44c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <da96b431-11ed-cd7d-fa77-0e261a8ad44c@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 08/07/16 11:28, Andre Przywara wrote:
> Hi,
> 
> On 07/07/16 16:00, Marc Zyngier wrote:
>> On 05/07/16 12:22, Andre Przywara wrote:
>>> In the moment our struct vgic_irq's are statically allocated at guest
>>> creation time. So getting a pointer to an IRQ structure is trivial and
>>> safe. LPIs are more dynamic, they can be mapped and unmapped at any time
>>> during the guest's _runtime_.
>>> In preparation for supporting LPIs we introduce reference counting for
>>> those structures using the kernel's kref infrastructure.
>>> Since private IRQs and SPIs are statically allocated, the refcount never
>>> drops to 0 at the moment, but we increase it when an IRQ gets onto a VCPU
>>> list and decrease it when it gets removed.
>>> This introduces vgic_put_irq(), which wraps kref_put and hides the
>>> release function from the callers.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>>  include/kvm/arm_vgic.h           |  1 +
>>>  virt/kvm/arm/vgic/vgic-init.c    |  2 ++
>>>  virt/kvm/arm/vgic/vgic-mmio-v2.c |  8 +++++++
>>>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 20 +++++++++++------
>>>  virt/kvm/arm/vgic/vgic-mmio.c    | 25 ++++++++++++++++++++-
>>>  virt/kvm/arm/vgic/vgic-v2.c      |  1 +
>>>  virt/kvm/arm/vgic/vgic-v3.c      |  1 +
>>>  virt/kvm/arm/vgic/vgic.c         | 48 +++++++++++++++++++++++++++++++---------
>>>  virt/kvm/arm/vgic/vgic.h         |  1 +
>>>  9 files changed, 89 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>>> index 5142e2a..450b4da 100644
>>> --- a/include/kvm/arm_vgic.h
>>> +++ b/include/kvm/arm_vgic.h
>>> @@ -96,6 +96,7 @@ struct vgic_irq {
>>>  	bool active;			/* not used for LPIs */
>>>  	bool enabled;
>>>  	bool hw;			/* Tied to HW IRQ */
>>> +	struct kref refcount;		/* Used for LPIs */
>>>  	u32 hwintid;			/* HW INTID number */
>>>  	union {
>>>  		u8 targets;			/* GICv2 target VCPUs mask */
>>> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
>>> index 90cae48..ac3c1a5 100644
>>> --- a/virt/kvm/arm/vgic/vgic-init.c
>>> +++ b/virt/kvm/arm/vgic/vgic-init.c
>>> @@ -177,6 +177,7 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
>>>  		spin_lock_init(&irq->irq_lock);
>>>  		irq->vcpu = NULL;
>>>  		irq->target_vcpu = vcpu0;
>>> +		kref_init(&irq->refcount);
>>>  		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
>>>  			irq->targets = 0;
>>>  		else
>>> @@ -211,6 +212,7 @@ static void kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
>>>  		irq->vcpu = NULL;
>>>  		irq->target_vcpu = vcpu;
>>>  		irq->targets = 1U << vcpu->vcpu_id;
>>> +		kref_init(&irq->refcount);
>>>  		if (vgic_irq_is_sgi(i)) {
>>>  			/* SGIs */
>>>  			irq->enabled = 1;
>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>>> index a213936..4152348 100644
>>> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
>>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>>> @@ -102,6 +102,7 @@ static void vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
>>>  		irq->source |= 1U << source_vcpu->vcpu_id;
>>>  
>>>  		vgic_queue_irq_unlock(source_vcpu->kvm, irq);
>>> +		vgic_put_irq(source_vcpu->kvm, irq);
>>>  	}
>>>  }
>>>  
>>> @@ -116,6 +117,8 @@ static unsigned long vgic_mmio_read_target(struct kvm_vcpu *vcpu,
>>>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>>>  
>>>  		val |= (u64)irq->targets << (i * 8);
>>> +
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  
>>>  	return val;
>>> @@ -143,6 +146,7 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
>>>  		irq->target_vcpu = kvm_get_vcpu(vcpu->kvm, target);
>>>  
>>>  		spin_unlock(&irq->irq_lock);
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  }
>>>  
>>> @@ -157,6 +161,8 @@ static unsigned long vgic_mmio_read_sgipend(struct kvm_vcpu *vcpu,
>>>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>>>  
>>>  		val |= (u64)irq->source << (i * 8);
>>> +
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  	return val;
>>>  }
>>> @@ -178,6 +184,7 @@ static void vgic_mmio_write_sgipendc(struct kvm_vcpu *vcpu,
>>>  			irq->pending = false;
>>>  
>>>  		spin_unlock(&irq->irq_lock);
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  }
>>>  
>>> @@ -201,6 +208,7 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
>>>  		} else {
>>>  			spin_unlock(&irq->irq_lock);
>>>  		}
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  }
>>>  
>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> index fc7b6c9..bfcafbd 100644
>>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> @@ -80,15 +80,17 @@ static unsigned long vgic_mmio_read_irouter(struct kvm_vcpu *vcpu,
>>>  {
>>>  	int intid = VGIC_ADDR_TO_INTID(addr, 64);
>>>  	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
>>> +	unsigned long ret = 0;
>>>  
>>>  	if (!irq)
>>>  		return 0;
>>>  
>>>  	/* The upper word is RAZ for us. */
>>> -	if (addr & 4)
>>> -		return 0;
>>> +	if (!(addr & 4))
>>> +		ret = extract_bytes(READ_ONCE(irq->mpidr), addr & 7, len);
>>>  
>>> -	return extract_bytes(READ_ONCE(irq->mpidr), addr & 7, len);
>>> +	vgic_put_irq(vcpu->kvm, irq);
>>> +	return ret;
>>>  }
>>>  
>>>  static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
>>> @@ -96,15 +98,17 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
>>>  				    unsigned long val)
>>>  {
>>>  	int intid = VGIC_ADDR_TO_INTID(addr, 64);
>>> -	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
>>> -
>>> -	if (!irq)
>>> -		return;
>>> +	struct vgic_irq *irq;
>>>  
>>>  	/* The upper word is WI for us since we don't implement Aff3. */
>>>  	if (addr & 4)
>>>  		return;
>>>  
>>> +	irq = vgic_get_irq(vcpu->kvm, NULL, intid);
>>> +
>>> +	if (!irq)
>>> +		return;
>>> +
>>>  	spin_lock(&irq->irq_lock);
>>>  
>>>  	/* We only care about and preserve Aff0, Aff1 and Aff2. */
>>> @@ -112,6 +116,7 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
>>>  	irq->target_vcpu = kvm_mpidr_to_vcpu(vcpu->kvm, irq->mpidr);
>>>  
>>>  	spin_unlock(&irq->irq_lock);
>>> +	vgic_put_irq(vcpu->kvm, irq);
>>>  }
>>>  
>>>  static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
>>> @@ -445,5 +450,6 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
>>>  		irq->pending = true;
>>>  
>>>  		vgic_queue_irq_unlock(vcpu->kvm, irq);
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  }
>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
>>> index 9f6fab7..5e79e01 100644
>>> --- a/virt/kvm/arm/vgic/vgic-mmio.c
>>> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
>>> @@ -56,6 +56,8 @@ unsigned long vgic_mmio_read_enable(struct kvm_vcpu *vcpu,
>>>  
>>>  		if (irq->enabled)
>>>  			value |= (1U << i);
>>> +
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  
>>>  	return value;
>>> @@ -74,6 +76,8 @@ void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
>>>  		spin_lock(&irq->irq_lock);
>>>  		irq->enabled = true;
>>>  		vgic_queue_irq_unlock(vcpu->kvm, irq);
>>> +
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  }
>>>  
>>> @@ -92,6 +96,7 @@ void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
>>>  		irq->enabled = false;
>>>  
>>>  		spin_unlock(&irq->irq_lock);
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  }
>>>  
>>> @@ -108,6 +113,8 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>>>  
>>>  		if (irq->pending)
>>>  			value |= (1U << i);
>>> +
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  
>>>  	return value;
>>> @@ -129,6 +136,7 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
>>>  			irq->soft_pending = true;
>>>  
>>>  		vgic_queue_irq_unlock(vcpu->kvm, irq);
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  }
>>>  
>>> @@ -152,6 +160,7 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
>>>  		}
>>>  
>>>  		spin_unlock(&irq->irq_lock);
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  }
>>>  
>>> @@ -168,6 +177,8 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
>>>  
>>>  		if (irq->active)
>>>  			value |= (1U << i);
>>> +
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  
>>>  	return value;
>>> @@ -242,6 +253,7 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
>>>  	for_each_set_bit(i, &val, len * 8) {
>>>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>>>  		vgic_mmio_change_active(vcpu, irq, false);
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  	vgic_change_active_finish(vcpu, intid);
>>>  }
>>> @@ -257,6 +269,7 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
>>>  	for_each_set_bit(i, &val, len * 8) {
>>>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>>>  		vgic_mmio_change_active(vcpu, irq, true);
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  	vgic_change_active_finish(vcpu, intid);
>>>  }
>>> @@ -272,6 +285,8 @@ unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
>>>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>>>  
>>>  		val |= (u64)irq->priority << (i * 8);
>>> +
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  
>>>  	return val;
>>> @@ -298,6 +313,8 @@ void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
>>>  		/* Narrow the priority range to what we actually support */
>>>  		irq->priority = (val >> (i * 8)) & GENMASK(7, 8 - VGIC_PRI_BITS);
>>>  		spin_unlock(&irq->irq_lock);
>>> +
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  }
>>>  
>>> @@ -313,6 +330,8 @@ unsigned long vgic_mmio_read_config(struct kvm_vcpu *vcpu,
>>>  
>>>  		if (irq->config == VGIC_CONFIG_EDGE)
>>>  			value |= (2U << (i * 2));
>>> +
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  
>>>  	return value;
>>> @@ -326,7 +345,7 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
>>>  	int i;
>>>  
>>>  	for (i = 0; i < len * 4; i++) {
>>> -		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>>> +		struct vgic_irq *irq;
>>>  
>>>  		/*
>>>  		 * The configuration cannot be changed for SGIs in general,
>>> @@ -337,14 +356,18 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
>>>  		if (intid + i < VGIC_NR_PRIVATE_IRQS)
>>>  			continue;
>>>  
>>> +		irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>>>  		spin_lock(&irq->irq_lock);
>>> +
>>>  		if (test_bit(i * 2 + 1, &val)) {
>>>  			irq->config = VGIC_CONFIG_EDGE;
>>>  		} else {
>>>  			irq->config = VGIC_CONFIG_LEVEL;
>>>  			irq->pending = irq->line_level | irq->soft_pending;
>>>  		}
>>> +
>>>  		spin_unlock(&irq->irq_lock);
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  }
>>>  
>>> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
>>> index 079bf67..0bf6709 100644
>>> --- a/virt/kvm/arm/vgic/vgic-v2.c
>>> +++ b/virt/kvm/arm/vgic/vgic-v2.c
>>> @@ -124,6 +124,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>>>  		}
>>>  
>>>  		spin_unlock(&irq->irq_lock);
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  }
>>>  
>>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>>> index e48a22e..f0ac064 100644
>>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>>> @@ -113,6 +113,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>>>  		}
>>>  
>>>  		spin_unlock(&irq->irq_lock);
>>> +		vgic_put_irq(vcpu->kvm, irq);
>>>  	}
>>>  }
>>>  
>>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>>> index 69b61ab..ae80894 100644
>>> --- a/virt/kvm/arm/vgic/vgic.c
>>> +++ b/virt/kvm/arm/vgic/vgic.c
>>> @@ -48,13 +48,20 @@ struct vgic_global __section(.hyp.text) kvm_vgic_global_state;
>>>  struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>>>  			      u32 intid)
>>>  {
>>> -	/* SGIs and PPIs */
>>> -	if (intid <= VGIC_MAX_PRIVATE)
>>> -		return &vcpu->arch.vgic_cpu.private_irqs[intid];
>>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>>> +	struct vgic_irq *irq;
>>>  
>>> -	/* SPIs */
>>> -	if (intid <= VGIC_MAX_SPI)
>>> -		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
>>> +	if (intid <= VGIC_MAX_PRIVATE) {        /* SGIs and PPIs */
>>> +		irq = &vcpu->arch.vgic_cpu.private_irqs[intid];
>>> +		kref_get(&irq->refcount);
>>> +		return irq;
>>> +	}
>>> +
>>> +	if (intid <= VGIC_MAX_SPI) {            /* SPIs */
>>> +		irq = &dist->spis[intid - VGIC_NR_PRIVATE_IRQS];
>>> +		kref_get(&irq->refcount);
>>> +		return irq;
>>> +	}
>>>  
>>>  	/* LPIs are not yet covered */
>>>  	if (intid >= VGIC_MIN_LPI)
>>> @@ -64,6 +71,17 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>>>  	return NULL;
>>>  }
>>>  
>>> +/* The refcount should never drop to 0 at the moment. */
>>> +static void vgic_irq_release(struct kref *ref)
>>> +{
>>> +	WARN_ON(1);
>>> +}
>>> +
>>> +void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
>>> +{
>>> +	kref_put(&irq->refcount, vgic_irq_release);
>>> +}
>>> +
>>>  /**
>>>   * kvm_vgic_target_oracle - compute the target vcpu for an irq
>>>   *
>>> @@ -236,6 +254,7 @@ retry:
>>>  		goto retry;
>>>  	}
>>>  
>>> +	kref_get(&irq->refcount);
>>
>> Could you use vgic_get_irq() instead? I know it is slightly overkill,
>> but I can already tell that we'll need to add some tracing in both the
>> put and get helpers in order to do some debugging. Having straight
>> kref_get/put is going to make this tracing difficult, so let's not go there.
> 
> I'd rather not.
> 1) Putting the IRQ on the ap_list is the "other user" of the
> refcounting, I don't want to mix that unnecessarily with the
> vgic_get_irq() (as in: get the struct by the number) use case. That may
> actually help tracing, since we can have separate tracepoints to
> distinguish them.

And yet you end-up doing a vgic_put_irq() in the fold operation. Which
is wrong, by the way, as the interrupt is still in in ap_list. This
should be moved to the prune operation.

> 2) This would violate the locking order, since we hold the irq_lock here
> and possibly take the lpi_list_lock in vgic_get_irq().
> I don't think we can or should drop the irq_lock and re-take it just for
> this.

That's a much more convincing argument. And when you take the above into
account, you realize that your locking is not correct. You shouldn't be
dropping the refcount in fold, but in prune, meaning that you're holding
the ap_lock and the irq_lock, same as when you inserted the interrupt in
the list.

This is outlining an essential principle: if your locking/refcounting is
not symmetric, it is likely that you're doing something wrong, and that
should bother you really badly.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
