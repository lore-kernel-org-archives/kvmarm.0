From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 09/10] KVM: arm/arm64: vgic: forwarding control
Date: Mon, 10 Aug 2015 15:21:03 +0200
Message-ID: <1439212864-12954-10-git-send-email-eric.auger@linaro.org>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D22F5A669
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:09:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9RVmGKSJL4Pt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Aug 2015 09:09:06 -0400 (EDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
 [209.85.212.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 500885A6BF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:09:06 -0400 (EDT)
Received: by wicne3 with SMTP id ne3so21962342wic.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 06:22:06 -0700 (PDT)
In-Reply-To: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, feng.wu@intel.com
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Implements kvm_vgic_[set|unset]_forward.

Handle low-level VGIC programming: physical IRQ/guest IRQ mapping,
list register cleanup, VGIC state machine. Also interacts with
the irqchip.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v2 -> v3:
- on unforward, we do not compute & output the active state anymore.
  This means if the unforward happens while the physical IRQ is
  active, we will not VFIO mask the IRQ while deactiving it. If a
  new physical IRQ hits, the corresponding virtual IRQ might not
  be injected (hence lost) due to VGIC state machine.

bypass rfc v2:
- use irq_set_vcpu_affinity API
- use irq_set_irqchip_state instead of chip->irq_eoi

bypass rfc:
- rename kvm_arch_{set|unset}_forward into
  kvm_vgic_{set|unset}_forward. Remove __KVM_HAVE_ARCH_HALT_GUEST.
  The function is bound to be called by ARM code only.

v4 -> v5:
- fix arm64 compilation issues, ie. also defines
  __KVM_HAVE_ARCH_HALT_GUEST for arm64

v3 -> v4:
- code originally located in kvm_vfio_arm.c
- kvm_arch_vfio_{set|unset}_forward renamed into
  kvm_arch_{set|unset}_forward
- split into 2 functions (set/unset) since unset does not fail anymore
- unset can be invoked at whatever time. Extra care is taken to handle
  transition in VGIC state machine, LR cleanup, ...

v2 -> v3:
- renaming of kvm_arch_set_fwd_state into kvm_arch_vfio_set_forward
- takes a bool arg instead of kvm_fwd_irq_action enum
- removal of KVM_VFIO_IRQ_CLEANUP
- platform device check now happens here
- more precise errors returned
- irq_eoi handled externally to this patch (VGIC)
- correct enable_irq bug done twice
- reword the commit message
- correct check of platform_bus_type
- use raw_spin_lock_irqsave and check the validity of the handler
---
 include/kvm/arm_vgic.h |   6 ++
 virt/kvm/arm/vgic.c    | 149 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 155 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 7ef9ce0..409ac0f 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -363,6 +363,12 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
 bool kvm_vgic_get_phys_irq_active(struct irq_phys_map *map);
 void kvm_vgic_set_phys_irq_active(struct irq_phys_map *map, bool active);
 
+int kvm_vgic_set_forward(struct kvm *kvm,
+			 unsigned int host_irq, unsigned int guest_irq);
+
+void kvm_vgic_unset_forward(struct kvm *kvm,
+			    unsigned int host_irq, unsigned int guest_irq);
+
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
 #define vgic_ready(k)		((k)->arch.vgic.ready)
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 03a85b3..b15999a 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2551,3 +2551,152 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 {
 	return 0;
 }
+
+/**
+ * kvm_vgic_set_forward - Set IRQ forwarding
+ *
+ * @kvm: handle to the VM
+ * @host_irq: physical IRQ number
+ * @guest_irq: virtual IRQ number
+ *
+ * This function is supposed to be called only if the IRQ
+ * is not in progress: ie. not active at GIC level and not
+ * currently under injection in the guest. The physical IRQ must
+ * also be disabled and the guest must have been exited and
+ * prevented from being re-entered.
+ */
+int kvm_vgic_set_forward(struct kvm *kvm,
+			 unsigned int host_irq,
+			 unsigned int guest_irq)
+{
+	struct irq_phys_map *map = NULL;
+	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, 0);
+	int spi_id = guest_irq + VGIC_NR_PRIVATE_IRQS;
+
+	kvm_debug("%s host_irq=%d guest_irq=%d\n",
+		__func__, host_irq, guest_irq);
+
+	if (!vcpu)
+		return 0;
+
+	irq_set_vcpu_affinity(host_irq, vcpu);
+	/*
+	 * next physical IRQ will be be handled as forwarded
+	 * by the host (priority drop only)
+	 */
+
+	map = kvm_vgic_map_phys_irq(vcpu, spi_id, host_irq, false);
+	/*
+	 * next guest_irq injection will be considered as
+	 * forwarded and next flush will program LR
+	 * without maintenance IRQ but with HW bit set
+	 */
+	return !map;
+}
+
+/**
+ * kvm_vgic_unset_forward - Unset IRQ forwarding
+ *
+ * @kvm: handle to the VM
+ * @host_irq: physical IRQ number
+ * @guest_irq: virtual IRQ number
+ *
+ * This function must be called when the host_irq is disabled
+ * and guest has been exited and prevented from being re-entered.
+ *
+ */
+void kvm_vgic_unset_forward(struct kvm *kvm,
+			    unsigned int host_irq,
+			    unsigned int guest_irq)
+{
+	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, 0);
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	int ret, lr;
+	struct vgic_lr vlr;
+	int spi_id = guest_irq + VGIC_NR_PRIVATE_IRQS;
+	bool queued = false, needs_deactivate = true;
+	struct irq_phys_map *map;
+	bool active;
+
+	kvm_debug("%s host_irq=%d guest_irq=%d\n",
+		__func__, host_irq, guest_irq);
+
+	spin_lock(&dist->lock);
+
+	irq_get_irqchip_state(host_irq, IRQCHIP_STATE_ACTIVE, &active);
+
+	if (!vcpu)
+		goto out;
+
+	map = vgic_irq_map_search(vcpu, spi_id);
+	BUG_ON(!map);
+	ret = kvm_vgic_unmap_phys_irq(vcpu, map);
+	BUG_ON(ret);
+	/*
+	 * subsequent update_irq_pending or flush will handle this
+	 * irq as not forwarded
+	 */
+	if (likely(!(active))) {
+		/*
+		 * the IRQ was not active. let's simply prepare the states
+		 * for subsequent non forwarded injection.
+		 */
+		vgic_dist_irq_clear_level(vcpu, spi_id);
+		vgic_dist_irq_clear_pending(vcpu, spi_id);
+		vgic_irq_clear_queued(vcpu, spi_id);
+		needs_deactivate = false;
+		goto out;
+	}
+
+	/* is there any list register with valid state? */
+	lr = vgic_cpu->vgic_irq_lr_map[spi_id];
+	if (lr != LR_EMPTY) {
+		vlr = vgic_get_lr(vcpu, lr);
+		if (vlr.state & LR_STATE_MASK)
+			queued = true;
+	}
+
+	if (!queued) {
+		vgic_irq_clear_queued(vcpu, spi_id);
+		if (vgic_dist_irq_is_pending(vcpu, spi_id)) {
+			/*
+			 * IRQ is injected but not yet queued. LR will be
+			 * written with EOI_INT and process_maintenance will
+			 * reset the states: queued, level(resampler). Pending
+			 * will be reset on flush.
+			 */
+			vgic_dist_irq_set_level(vcpu, spi_id);
+		} else {
+			/*
+			 * We are somewhere before the update_irq_pending.
+			 * we can't be sure the virtual IRQ will ever be
+			 * injected (due to previous disable_irq).
+			 * Let's simply clear the level which was not correctly
+			 * modelled in forwarded state.
+			 */
+			vgic_dist_irq_clear_level(vcpu, spi_id);
+		}
+		goto out;
+	}
+
+	/*
+	 * the virtual IRQ is queued and a valid LR exists, let's patch it so
+	 * that when EOI happens a maintenance IRQ gets triggered
+	 */
+	vlr.state |= LR_EOI_INT;
+	vgic_set_lr(vcpu, lr, vlr);
+
+	vgic_dist_irq_set_level(vcpu, spi_id);
+	vgic_dist_irq_set_pending(vcpu, spi_id);
+	vgic_irq_set_queued(vcpu, spi_id);
+	 /* The maintenance IRQ will reset all states above */
+
+out:
+	irq_set_irqchip_state(host_irq, IRQCHIP_STATE_ACTIVE, false);
+	irq_set_vcpu_affinity(host_irq, NULL);
+	/* next occurrence will be deactivated by the host */
+
+	spin_unlock(&dist->lock);
+}
+
-- 
1.9.1
