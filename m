From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v7 06/17] KVM: arm/arm64: VGIC: add refcounting for IRQs
Date: Thu, 30 Jun 2016 16:17:39 +0100
Message-ID: <2da67866-0367-520c-3474-7d7546ecea51@arm.com>
References: <20160628123230.26255-1-andre.przywara@arm.com>
 <20160628123230.26255-7-andre.przywara@arm.com>
 <1b593082-8313-cce5-2a30-38b55a75e894@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54CB549B1A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 11:11:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kIGw-zt2fvfD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2016 11:11:39 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D394749AF5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 11:11:38 -0400 (EDT)
In-Reply-To: <1b593082-8313-cce5-2a30-38b55a75e894@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

thanks for going through the mes^Wpatches!

On 29/06/16 16:58, Auger Eric wrote:
> Hi Andre,
> 
> On 28/06/2016 14:32, Andre Przywara wrote:
>> In the moment our struct vgic_irq's are statically allocated at guest
>> creation time. So getting a pointer to an IRQ structure is trivial and
>> safe. LPIs are more dynamic, they can be mapped and unmapped at any time
>> during the guest's _runtime_.
>> In preparation for supporting LPIs we introduce reference counting for
>> those structures using the kernel's kref infrastructure.
>> Since private IRQs and SPIs are statically allocated, the reqcount never
> s/reqcount/refcount
>> drops to 0 at the moment, but we increase it when an IRQ gets onto a VCPU
>> list and decrease it when it gets removed.
> may be worth clarifying your incr/decr the refcount on vgic_get/put_irq
> and each time the irq is added/removed from the ap_list.
> 
>> This introduces vgic_put_irq(), which wraps kref_put and hides the
>> release function from the callers.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  include/kvm/vgic/vgic.h          |  1 +
>>  virt/kvm/arm/vgic/vgic-init.c    |  2 ++
>>  virt/kvm/arm/vgic/vgic-mmio-v2.c |  8 ++++++++
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 10 +++++++---
>>  virt/kvm/arm/vgic/vgic-mmio.c    | 22 +++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic-v2.c      |  1 +
>>  virt/kvm/arm/vgic/vgic-v3.c      |  1 +
>>  virt/kvm/arm/vgic/vgic.c         | 41 +++++++++++++++++++++++++++++++++-------
>>  virt/kvm/arm/vgic/vgic.h         |  1 +
>>  9 files changed, 77 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
>> index 2f26f37..a296d94 100644
>> --- a/include/kvm/vgic/vgic.h
>> +++ b/include/kvm/vgic/vgic.h
>> @@ -96,6 +96,7 @@ struct vgic_irq {
>>  	bool active;			/* not used for LPIs */
>>  	bool enabled;
>>  	bool hw;			/* Tied to HW IRQ */
>> +	struct kref refcount;		/* Used for LPIs */
>>  	u32 hwintid;			/* HW INTID number */
>>  	union {
>>  		u8 targets;			/* GICv2 target VCPUs mask */
>> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
>> index 90cae48..ac3c1a5 100644
>> --- a/virt/kvm/arm/vgic/vgic-init.c
>> +++ b/virt/kvm/arm/vgic/vgic-init.c
>> @@ -177,6 +177,7 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
>>  		spin_lock_init(&irq->irq_lock);
>>  		irq->vcpu = NULL;
>>  		irq->target_vcpu = vcpu0;
>> +		kref_init(&irq->refcount);
>>  		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
>>  			irq->targets = 0;
>>  		else
>> @@ -211,6 +212,7 @@ static void kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
>>  		irq->vcpu = NULL;
>>  		irq->target_vcpu = vcpu;
>>  		irq->targets = 1U << vcpu->vcpu_id;
>> +		kref_init(&irq->refcount);
>>  		if (vgic_irq_is_sgi(i)) {
>>  			/* SGIs */
>>  			irq->enabled = 1;
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> index a213936..4152348 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> @@ -102,6 +102,7 @@ static void vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
>>  		irq->source |= 1U << source_vcpu->vcpu_id;
>>  
>>  		vgic_queue_irq_unlock(source_vcpu->kvm, irq);
>> +		vgic_put_irq(source_vcpu->kvm, irq);
>>  	}
>>  }
>>  
>> @@ -116,6 +117,8 @@ static unsigned long vgic_mmio_read_target(struct kvm_vcpu *vcpu,
>>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>>  
>>  		val |= (u64)irq->targets << (i * 8);
>> +
>> +		vgic_put_irq(vcpu->kvm, irq);
>>  	}
>>  
>>  	return val;
>> @@ -143,6 +146,7 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
>>  		irq->target_vcpu = kvm_get_vcpu(vcpu->kvm, target);
>>  
>>  		spin_unlock(&irq->irq_lock);
>> +		vgic_put_irq(vcpu->kvm, irq);
>>  	}
>>  }
>>  
>> @@ -157,6 +161,8 @@ static unsigned long vgic_mmio_read_sgipend(struct kvm_vcpu *vcpu,
>>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>>  
>>  		val |= (u64)irq->source << (i * 8);
>> +
>> +		vgic_put_irq(vcpu->kvm, irq);
>>  	}
>>  	return val;
>>  }
>> @@ -178,6 +184,7 @@ static void vgic_mmio_write_sgipendc(struct kvm_vcpu *vcpu,
>>  			irq->pending = false;
>>  
>>  		spin_unlock(&irq->irq_lock);
>> +		vgic_put_irq(vcpu->kvm, irq);
>>  	}
>>  }
>>  
>> @@ -201,6 +208,7 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
>>  		} else {
>>  			spin_unlock(&irq->irq_lock);
>>  		}
>> +		vgic_put_irq(vcpu->kvm, irq);
>>  	}
>>  }
>>  
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index fc7b6c9..829909e 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -80,15 +80,17 @@ static unsigned long vgic_mmio_read_irouter(struct kvm_vcpu *vcpu,
>>  {
>>  	int intid = VGIC_ADDR_TO_INTID(addr, 64);
>>  	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
>> +	unsigned long ret = 0;
>>  
>>  	if (!irq)
>>  		return 0;
>>  
>>  	/* The upper word is RAZ for us. */
>> -	if (addr & 4)
>> -		return 0;
>> +	if (!(addr & 4))
>> +		ret = extract_bytes(READ_ONCE(irq->mpidr), addr & 7, len);
>>  
>> -	return extract_bytes(READ_ONCE(irq->mpidr), addr & 7, len);
>> +	vgic_put_irq(vcpu->kvm, irq);
>> +	return ret;
>>  }
>>  
>>  static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
>> @@ -112,6 +114,7 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
>>  	irq->target_vcpu = kvm_mpidr_to_vcpu(vcpu->kvm, irq->mpidr);
>>  
>>  	spin_unlock(&irq->irq_lock);
>> +	vgic_put_irq(vcpu->kvm, irq);
> you need one put in:
> 
> 	/* The upper word is WI for us since we don't implement Aff3. */
> 	if (addr & 4)
> 		return;

Oh dear, you are right (also about the other places).
That seems to be a fallout of the migration to kref from v6, where I was
taking the reference later in some places.

>>  }
>>  
>>  static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,

....

>> @@ -345,6 +365,8 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
>>  			irq->pending = irq->line_level | irq->soft_pending;
>>  		}
>>  		spin_unlock(&irq->irq_lock);
>> +
>> +		vgic_put_irq(vcpu->kvm, irq);
> you also need a put at:
> 		if (intid + i < VGIC_NR_PRIVATE_IRQS)
> 			continue;

That's a nice catch!
Will also fix all the other cases you mentioned.

Thanks for having a look!

Cheers,
Andre.
