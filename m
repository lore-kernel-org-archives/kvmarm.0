From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 10/13] KVM: arm/arm64: vgic: forwarding control
Date: Thu, 19 Nov 2015 14:54:00 +0000
Message-ID: <1447944843-17731-11-git-send-email-eric.auger@linaro.org>
References: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6867049A55
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9E71DL0u7Rkq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2015 09:53:48 -0500 (EST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A8DA4989E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:48 -0500 (EST)
Received: by wmww144 with SMTP id w144so241835115wmw.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 06:54:27 -0800 (PST)
In-Reply-To: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Implements kvm_vgic_[set|unset]_forward.

Handle low-level VGIC programming: physical IRQ/guest IRQ mapping,
list register cleanup, VGIC state machine. Also interacts with
the irqchip.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v3 -> v4:
- use the target vCPU in set/unset_forward
- rebase after removal of vgic_irq_lr_map
- clarify set/unset_forward comments,
- host_irq renamed into irq and virt_irq (SPI ID) now used in
  place of SPI index (former guest_irq)
- replaced BUG_ON by WARN_ON
- simplify unset_forward implementation by using vgic_unqueue_irqs
- handle edge mapped unshared IRQs

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
 include/kvm/arm_vgic.h |   5 +++
 virt/kvm/arm/vgic.c    | 118 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9bf6a30..8090ab4 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -368,4 +368,9 @@ static inline int vgic_v3_probe(struct device_node *vgic_node,
 }
 #endif
 
+int kvm_vgic_set_forward(struct kvm *kvm, unsigned int irq,
+			 unsigned int virt_irq);
+void kvm_vgic_unset_forward(struct kvm *kvm, unsigned int irq,
+			    unsigned int virt_irq);
+
 #endif
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index e96f79e..bd500b4 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2500,3 +2500,121 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 {
 	return 0;
 }
+
+/**
+ * kvm_vgic_set_forward - Set IRQ forwarding
+ *
+ * @kvm: handle to the VM
+ * @irq: the host linux IRQ
+ * @virt_irq: the guest SPI ID
+ *
+ * This function is supposed to be called only if the IRQ
+ * is not in progress: ie. not active at GIC level and not
+ * currently under injection in the guest. The physical IRQ must
+ * also be disabled and all vCPUs must have been exited and
+ * prevented from being re-entered.
+ */
+int kvm_vgic_set_forward(struct kvm *kvm, unsigned int irq,
+			 unsigned int virt_irq)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct kvm_vcpu *vcpu;
+	struct irq_phys_map *map;
+	int cpu_id;
+
+	kvm_debug("%s irq=%d virt_irq=%d\n", __func__, irq, virt_irq);
+
+	cpu_id = dist->irq_spi_cpu[virt_irq - VGIC_NR_PRIVATE_IRQS];
+	vcpu = kvm_get_vcpu(kvm, cpu_id);
+	if (!vcpu)
+		return 0;
+	/*
+	 * let's tell the irqchip driver that after this function
+	 * returns, a new occurrence of that physical irq will be handled
+	 * as a forwarded IRQ, ie. the host will only perform priority
+	 * drop but will not deactivate the physical IRQ: guest will
+	 */
+	irq_set_vcpu_affinity(irq, vcpu);
+
+	/*
+	 * let's program the vgic so that after this function returns
+	 * any subsequent virt_irq injection will be considered as
+	 * forwarded and LR will be programmed with HWbit set
+	 */
+	map = kvm_vgic_map_phys_irq(vcpu, virt_irq, irq, false);
+
+	return !map;
+}
+
+/**
+ * kvm_vgic_unset_forward - Unset IRQ forwarding
+ *
+ * @kvm: handle to the VM
+ * @irq: host Linux IRQ number
+ * @virt_irq: virtual SPI ID
+ *
+ * This function must be called when the host irq is disabled
+ * and all vCPUs have been exited and prevented from being re-entered.
+ */
+void kvm_vgic_unset_forward(struct kvm *kvm,
+			      unsigned int irq,
+			      unsigned int virt_irq)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct kvm_vcpu *vcpu;
+	int cpu_id;
+	bool active, is_level;
+	struct irq_phys_map *map;
+
+	kvm_debug("%s irq=%d virt_irq=%d\n", __func__, irq, virt_irq);
+
+	spin_lock(&dist->lock);
+
+	cpu_id = dist->irq_spi_cpu[virt_irq - VGIC_NR_PRIVATE_IRQS];
+	vcpu = kvm_get_vcpu(kvm, cpu_id);
+	is_level = !vgic_irq_is_edge(vcpu, virt_irq);
+
+	irq_get_irqchip_state(irq, IRQCHIP_STATE_ACTIVE, &active);
+
+	if (!vcpu)
+		goto out;
+
+	map = vgic_irq_map_search(vcpu, virt_irq);
+	if (!map || map->shared || kvm_vgic_unmap_phys_irq(vcpu, map)) {
+		WARN_ON(1);
+		goto out;
+	}
+
+	if (!active) {
+		/*
+		 * The physical IRQ is not active so no virtual IRQ
+		 * is under injection, reset the level state which was
+		 * not modelled.
+		 */
+		vgic_dist_irq_clear_level(vcpu, virt_irq);
+		goto out;
+	}
+
+	vgic_unqueue_irqs(vcpu);
+
+	if (vgic_dist_irq_is_pending(vcpu, virt_irq) ||
+	    vgic_irq_is_active(vcpu, virt_irq)) {
+		/*
+		 * on next flush, LR for virt_irq will be programmed
+		 * with maintenance IRQ. For level sensitive IRQ,
+		 * let's set the level which was not modelled up to now
+		 */
+		if (is_level)
+			vgic_dist_irq_set_level(vcpu, virt_irq);
+	} else {
+		vgic_dist_irq_clear_level(vcpu, virt_irq);
+	}
+
+out:
+	/* Let's deactivate and unmap the physical IRQ from the vCPU */
+	irq_set_irqchip_state(irq, IRQCHIP_STATE_ACTIVE, false);
+	irq_set_vcpu_affinity(irq, NULL);
+
+	spin_unlock(&dist->lock);
+}
+
-- 
1.9.1
