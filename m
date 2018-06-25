From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 2/4] KVM: arm/arm64: vgic: Add group field to struct irq
Date: Mon, 25 Jun 2018 11:00:50 +0100
Message-ID: <9c1462b6-b969-6364-452e-83a9dc3c72b5@arm.com>
References: <20180624221103.15055-1-christoffer.dall@arm.com>
 <20180624221103.15055-3-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180624221103.15055-3-christoffer.dall@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 24/06/18 23:11, Christoffer Dall wrote:
> In preparation for proper group 0 and group 1 support in the vgic, we
> add a field in the struct irq to store the group of all interrupts.
> 
> We initialize the group to group 0 when emulating GICv2 and to group 1
> when emulating GICv3, just like we treat them today.  LPIs are always
> group 1.  We also continue to ignore writes from the guest, preserving
> existing functionality, for now.
> 
> Finally, we also add this field to the vgic debug logic to show the
> group for all interrupts.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> ---
>  include/kvm/arm_vgic.h         |  1 +
>  virt/kvm/arm/vgic/vgic-debug.c |  8 +++++---
>  virt/kvm/arm/vgic/vgic-init.c  | 11 +++++++++--
>  virt/kvm/arm/vgic/vgic-its.c   |  1 +
>  4 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index cfdd2484cc42..d2d578d099de 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -133,6 +133,7 @@ struct vgic_irq {
>  	u8 source;			/* GICv2 SGIs only */
>  	u8 active_source;		/* GICv2 SGIs only */
>  	u8 priority;
> +	u8 group;			/* 0 == group 0, 1 == group 1 */
>  	enum vgic_irq_config config;	/* Level or edge */
>  
>  	/*
> diff --git a/virt/kvm/arm/vgic/vgic-debug.c b/virt/kvm/arm/vgic/vgic-debug.c
> index c589d4c2b478..d3a403f63010 100644
> --- a/virt/kvm/arm/vgic/vgic-debug.c
> +++ b/virt/kvm/arm/vgic/vgic-debug.c
> @@ -148,6 +148,7 @@ static void print_dist_state(struct seq_file *s, struct vgic_dist *dist)
>  
>  	seq_printf(s, "P=pending_latch, L=line_level, A=active\n");
>  	seq_printf(s, "E=enabled, H=hw, C=config (level=1, edge=0)\n");
> +	seq_printf(s, "G=group\n");
>  }
>  
>  static void print_header(struct seq_file *s, struct vgic_irq *irq,
> @@ -162,8 +163,8 @@ static void print_header(struct seq_file *s, struct vgic_irq *irq,
>  	}
>  
>  	seq_printf(s, "\n");
> -	seq_printf(s, "%s%2d TYP   ID TGT_ID PLAEHC     HWID   TARGET SRC PRI VCPU_ID\n", hdr, id);
> -	seq_printf(s, "---------------------------------------------------------------\n");
> +	seq_printf(s, "%s%2d TYP   ID TGT_ID PLAEHCG     HWID   TARGET SRC PRI VCPU_ID\n", hdr, id);
> +	seq_printf(s, "----------------------------------------------------------------\n");
>  }
>  
>  static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
> @@ -182,7 +183,7 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
>  
>  	seq_printf(s, "       %s %4d "
>  		      "    %2d "
> -		      "%d%d%d%d%d%d "
> +		      "%d%d%d%d%d%d%d "
>  		      "%8d "
>  		      "%8x "
>  		      " %2x "
> @@ -197,6 +198,7 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
>  			irq->enabled,
>  			irq->hw,
>  			irq->config == VGIC_CONFIG_LEVEL,
> +			irq->group,
>  			irq->hwintid,
>  			irq->mpidr,
>  			irq->source,
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 2673efce65f3..146a1bbb05c8 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -175,10 +175,13 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
>  		irq->vcpu = NULL;
>  		irq->target_vcpu = vcpu0;
>  		kref_init(&irq->refcount);
> -		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
> +		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2) {
>  			irq->targets = 0;
> -		else
> +			irq->group = 0;
> +		} else {
>  			irq->mpidr = 0;
> +			irq->group = 1;
> +		}
>  	}
>  	return 0;
>  }
> @@ -227,6 +230,10 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
>  			/* PPIs */
>  			irq->config = VGIC_CONFIG_LEVEL;
>  		}
> +		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
> +			irq->group = 0;
> +		else
> +			irq->group = 1;
>  	}
>  
>  	if (!irqchip_in_kernel(vcpu->kvm))
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 4ed79c939fb4..92840c06fcd7 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -71,6 +71,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
>  	kref_init(&irq->refcount);
>  	irq->intid = intid;
>  	irq->target_vcpu = vcpu;
> +	irq->group = 1;
>  
>  	spin_lock_irqsave(&dist->lpi_list_lock, flags);
>  
> 
