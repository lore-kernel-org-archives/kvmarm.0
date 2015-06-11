From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 06/10] KVM: arm/arm64: vgic: Allow dynamic mapping of
 physical/virtual interrupts
Date: Thu, 11 Jun 2015 09:56:39 +0100
Message-ID: <55794D47.7040702@arm.com>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
 <1433783045-8002-7-git-send-email-marc.zyngier@arm.com>
 <55794A31.5050901@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93E1853CF0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2015 04:46:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QBl8x0NZOuuv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Jun 2015 04:46:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0288053CE5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2015 04:46:20 -0400 (EDT)
In-Reply-To: <55794A31.5050901@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 11/06/15 09:43, Andre Przywara wrote:
> Hi,
> 
> On 06/08/2015 06:04 PM, Marc Zyngier wrote:
>> In order to be able to feed physical interrupts to a guest, we need
>> to be able to establish the virtual-physical mapping between the two
>> worlds.
>>
>> The mapping is kept in a rbtree, indexed by virtual interrupts.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  include/kvm/arm_vgic.h |  18 ++++++++
>>  virt/kvm/arm/vgic.c    | 110 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 128 insertions(+)
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index 4f9fa1d..33d121a 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -159,6 +159,14 @@ struct vgic_io_device {
>>  	struct kvm_io_device dev;
>>  };
>>  
>> +struct irq_phys_map {
>> +	struct rb_node		node;
>> +	u32			virt_irq;
>> +	u32			phys_irq;
>> +	u32			irq;
> 
> Can you add comments explaining the different IRQ types here?
> So I take it that phys_irq is the actual SPI number (hwirq in irqchip
> lingo), virt_irq is the guest's virtual IRQ number and irq is Linux'
> notion of the IRQ number (the first column in /proc/interrupts)?
> Would renaming help? (phys_irq to hwirq? virt_irq to guest_irq?)

Adding comments would probably help. Renaming, I'm not sure. The virt vs
phys was clear enough for me. The ambiguous one would be "irq"... I'll
try to work something out anyway.

> 
>> +	bool			active;
>> +};
>> +
>>  struct vgic_dist {
>>  	spinlock_t		lock;
>>  	bool			in_kernel;
>> @@ -256,6 +264,10 @@ struct vgic_dist {
>>  	struct vgic_vm_ops	vm_ops;
>>  	struct vgic_io_device	dist_iodev;
>>  	struct vgic_io_device	*redist_iodevs;
>> +
>> +	/* Virtual irq to hwirq mapping */
>> +	spinlock_t		irq_phys_map_lock;
>> +	struct rb_root		irq_phys_map;
>>  };
>>  
>>  struct vgic_v2_cpu_if {
>> @@ -307,6 +319,9 @@ struct vgic_cpu {
>>  		struct vgic_v2_cpu_if	vgic_v2;
>>  		struct vgic_v3_cpu_if	vgic_v3;
>>  	};
>> +
>> +	/* Protected by the distributor's irq_phys_map_lock */
>> +	struct rb_root	irq_phys_map;
>>  };
>>  
>>  #define LR_EMPTY	0xff
>> @@ -331,6 +346,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
>>  void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
>>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
>>  int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
>> +struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>> +				       int virt_irq, int irq);
>> +int vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
>>  
>>  #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
>>  #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>> index 59ed7a3..c6604f2 100644
>> --- a/virt/kvm/arm/vgic.c
>> +++ b/virt/kvm/arm/vgic.c
>> @@ -24,6 +24,7 @@
>>  #include <linux/of.h>
>>  #include <linux/of_address.h>
>>  #include <linux/of_irq.h>
>> +#include <linux/rbtree.h>
>>  #include <linux/uaccess.h>
>>  
>>  #include <linux/irqchip/arm-gic.h>
>> @@ -84,6 +85,8 @@ static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu);
>>  static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu);
>>  static struct vgic_lr vgic_get_lr(const struct kvm_vcpu *vcpu, int lr);
>>  static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr, struct vgic_lr lr_desc);
>> +static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
>> +						int virt_irq);
>>  
>>  static const struct vgic_ops *vgic_ops;
>>  static const struct vgic_params *vgic;
>> @@ -1585,6 +1588,112 @@ static irqreturn_t vgic_maintenance_handler(int irq, void *data)
>>  	return IRQ_HANDLED;
>>  }
>>  
>> +static struct rb_root *vgic_get_irq_phys_map(struct kvm_vcpu *vcpu,
>> +					     int virt_irq)
>> +{
>> +	if (virt_irq < VGIC_NR_PRIVATE_IRQS)
>> +		return &vcpu->arch.vgic_cpu.irq_phys_map;
>> +	else
>> +		return &vcpu->kvm->arch.vgic.irq_phys_map;
>> +}
>> +
>> +struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>> +				       int virt_irq, int irq)
>> +{
>> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>> +	struct rb_root *root = vgic_get_irq_phys_map(vcpu, virt_irq);
>> +	struct rb_node **new = &root->rb_node, *parent = NULL;
>> +	struct irq_phys_map *new_map;
>> +	struct irq_desc *desc;
>> +	struct irq_data *data;
>> +	int phys_irq;
>> +
>> +	desc = irq_to_desc(irq);
>> +	if (!desc) {
>> +		kvm_err("kvm_arch_timer: can't obtain interrupt descriptor\n");
> 
> I guess kvm_arch_timer: is a left-over of the original user?
> 
>> +		return NULL;
>> +	}
>> +
>> +	data = irq_desc_get_irq_data(desc);
>> +	while (data->parent_data)
>> +		data = data->parent_data;
>> +
>> +	phys_irq = data->hwirq;
> 
> So if I get this correctly we "cache" hwirq/phys_irq in this map to get
> a cheaper access to it, but actually it is redundant since we have
> Linux' irq number, isn't it?

Define what you call by redundant. Parsing the irq_data hierarchy can be
arbitrarily long, and what we're after is the irq vs GIC view of the HW irq.

> Are we sure that the irqdomain mapping of irq and phys_irq never will
> change while this map entry is valid? This is probably true for the
> timer, but does that still hold in the future with other devices?
> (see also the next email for more rationale)

How could such a mapping change? We have done a request_irq on this IRQ
line. If it was to change, we'd get notifier when *another device* is
interrupting us. That would simply defeat the whole purpose of having
separate interrupts.

	M.
-- 
Jazz is not dead. It just smells funny...
