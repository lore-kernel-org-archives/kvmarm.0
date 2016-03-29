From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 03/45] KVM: arm/arm64: arch_timer: rework VGIC <->
 timer interface
Date: Tue, 29 Mar 2016 15:01:35 +0200
Message-ID: <20160329130135.GD4126@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-4-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458871508-17279-4-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 25, 2016 at 02:04:26AM +0000, Andre Przywara wrote:
> Adapt the interface between the virtualized arch timer and the
> emulated VGIC to avoid the phys_map when possible.
> This prepares the arch timer to go with both the existing VGIC
> implementation and the new version later without too many code
> changes.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/arm_vgic.h    |  7 ++++---
>  virt/kvm/arm/arch_timer.c | 11 +++++------
>  virt/kvm/arm/vgic.c       | 18 +++++++++---------
>  3 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 2b89e27..7656a46 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -345,13 +345,14 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
>  int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
>  			bool level);
>  int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
> -			       struct irq_phys_map *map, bool level);
> +			       int virt_irq, bool level);
>  void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
>  struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>  					   int virt_irq, int irq);
> -int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
> -bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
> +int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map,
> +			    int virt_irq);

I don't understand the benefit of this change.  You're now passing the
virt_irq in both the struct and as a parameter.

If you want to get rid of the irq_phys_map structure, just replace all
occurences of it with two parameters/arguments instead, int virt_irq,
int phys_irq, both of which are INTIDs.

You don't need to pass the Linux IRQ number from outside the vgic to the
vgic anymore, and it's just there for historical reasons, so you can
remove that with a separate patch if you want.

If you want me to send a patch removing the IRQ field, let me know.  It
looks something like this:

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 281caf8..9ffe29c 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -157,7 +157,6 @@ struct vgic_io_device {
 struct irq_phys_map {
 	u32			virt_irq;
 	u32			phys_irq;
-	u32			irq;
 };
 
 struct irq_phys_map_entry {
@@ -345,7 +344,7 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
-					   int virt_irq, int irq);
+					   int virt_irq, int phys_irq);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index a9ad4fe..73ca3e5 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -274,7 +274,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	if (timer->active_cleared_last && !phys_active)
 		return;
 
-	ret = irq_set_irqchip_state(timer->map->irq,
+	ret = irq_set_irqchip_state(host_vtimer_irq,
 				    IRQCHIP_STATE_ACTIVE,
 				    phys_active);
 	WARN_ON(ret);
@@ -307,6 +307,9 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct irq_phys_map *map;
+	struct irq_desc *desc;
+	struct irq_data *data;
+	int phys_irq;
 
 	/*
 	 * The vcpu timer irq number cannot be determined in
@@ -326,10 +329,25 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	kvm_timer_update_state(vcpu);
 
 	/*
+	 * Find the physical IRQ number corresponding to the host_vtimer_irq
+	 */
+	desc = irq_to_desc(host_vtimer_irq);
+	if (!desc) {
+		kvm_err("%s: no interrupt descriptor\n", __func__);
+		return -EINVAL;
+	}
+
+	data = irq_desc_get_irq_data(desc);
+	while (data->parent_data)
+		data = data->parent_data;
+
+	phys_irq = data->hwirq;
+
+	/*
 	 * Tell the VGIC that the virtual interrupt is tied to a
 	 * physical interrupt. We do that once per VCPU.
 	 */
-	map = kvm_vgic_map_phys_irq(vcpu, irq->irq, host_vtimer_irq);
+	map = kvm_vgic_map_phys_irq(vcpu, irq->irq, phys_irq);
 	if (WARN_ON(IS_ERR(map)))
 		return PTR_ERR(map);
 
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 00429b3..012f428 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1724,27 +1724,13 @@ static struct list_head *vgic_get_irq_phys_map_list(struct kvm_vcpu *vcpu,
  * Returns a valid pointer on success, and an error pointer otherwise
  */
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
-					   int virt_irq, int irq)
+					   int virt_irq, int phys_irq)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct list_head *root = vgic_get_irq_phys_map_list(vcpu, virt_irq);
 	struct irq_phys_map *map;
 	struct irq_phys_map_entry *entry;
-	struct irq_desc *desc;
-	struct irq_data *data;
-	int phys_irq;
 
-	desc = irq_to_desc(irq);
-	if (!desc) {
-		kvm_err("%s: no interrupt descriptor\n", __func__);
-		return ERR_PTR(-EINVAL);
-	}
-
-	data = irq_desc_get_irq_data(desc);
-	while (data->parent_data)
-		data = data->parent_data;
-
-	phys_irq = data->hwirq;
 
 	/* Create a new mapping */
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
@@ -1757,8 +1743,7 @@ struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 	map = vgic_irq_map_search(vcpu, virt_irq);
 	if (map) {
 		/* Make sure this mapping matches */
-		if (map->phys_irq != phys_irq	||
-		    map->irq      != irq)
+		if (map->phys_irq != phys_irq)
 			map = ERR_PTR(-EINVAL);
 
 		/* Found an existing, valid mapping */
@@ -1768,7 +1753,6 @@ struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 	map           = &entry->map;
 	map->virt_irq = virt_irq;
 	map->phys_irq = phys_irq;
-	map->irq      = irq;
 
 	list_add_tail_rcu(&entry->entry, root);
 

