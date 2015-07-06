From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 8/9] KVM: arm/arm64: vgic: forwarding control
Date: Mon,  6 Jul 2015 15:24:42 +0200
Message-ID: <1436189083-32527-9-git-send-email-eric.auger@linaro.org>
References: <1436189083-32527-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFFFF57C02
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 09:13:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZLCdtm22hxjJ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2015 09:13:58 -0400 (EDT)
Received: from mail-wg0-f46.google.com (mail-wg0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BCF7B57BED
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 09:13:57 -0400 (EDT)
Received: by wgqq4 with SMTP id q4so140439605wgq.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jul 2015 06:25:24 -0700 (PDT)
In-Reply-To: <1436189083-32527-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: pbonzini@redhat.com, alex.williamson@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Implements kvm_vgic_[set|unset]_forward.

Handle low-level VGIC programming: physical IRQ/guest IRQ mapping,
list register cleanup, VGIC state machine. Also interacts with
the irqchip.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

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
 include/kvm/arm_vgic.h |   7 ++
 virt/kvm/arm/vgic.c    | 195 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 202 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 5d47d60..93b379f 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -353,6 +353,13 @@ int vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
 bool vgic_get_phys_irq_active(struct irq_phys_map *map);
 void vgic_set_phys_irq_active(struct irq_phys_map *map, bool active);
 
+int kvm_vgic_set_forward(struct kvm *kvm,
+			 unsigned int host_irq, unsigned int guest_irq);
+
+void kvm_vgic_unset_forward(struct kvm *kvm,
+			    unsigned int host_irq, unsigned int guest_irq,
+			    bool *active);
+
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
 #define vgic_ready(k)		((k)->arch.vgic.ready)
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index eef35d9..9efc839 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2402,3 +2402,198 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
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
+ * currently under injection in the KVM. The physical IRQ must
+ * also be disabled and the guest must have been exited and
+ * prevented from being re-entered.
+ */
+int kvm_vgic_set_forward(struct kvm *kvm,
+			 unsigned int host_irq,
+			 unsigned int guest_irq)
+{
+	struct irq_desc *desc = irq_to_desc(host_irq);
+	struct irq_phys_map *map = NULL;
+	struct irq_data *d;
+	unsigned long flags;
+	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, 0);
+	int spi_id = guest_irq + VGIC_NR_PRIVATE_IRQS;
+	struct vgic_dist *dist = &kvm->arch.vgic;
+
+	kvm_debug("%s host_irq=%d guest_irq=%d\n",
+		__func__, host_irq, guest_irq);
+
+	if (!vcpu)
+		return 0;
+
+	spin_lock(&dist->lock);
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	d = &desc->irq_data;
+	irqd_set_irq_forwarded(d);
+	/*
+	 * next physical IRQ will be be handled as forwarded
+	 * by the host (priority drop only)
+	 */
+
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+	/*
+	 * need to release the dist spin_lock here since
+	 * vgic_map_phys_irq can sleep
+	 */
+	spin_unlock(&dist->lock);
+	map = vgic_map_phys_irq(vcpu, spi_id, host_irq, false);
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
+ * @active: returns whether the physical IRQ is active
+ *
+ * This function must be called when the host_irq is disabled
+ * and guest has been exited and prevented from being re-entered.
+ *
+ */
+void kvm_vgic_unset_forward(struct kvm *kvm,
+			    unsigned int host_irq,
+			    unsigned int guest_irq,
+			    bool *active)
+{
+	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, 0);
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	int ret, lr;
+	struct vgic_lr vlr;
+	struct irq_desc *desc = irq_to_desc(host_irq);
+	struct irq_data *d;
+	unsigned long flags;
+	int spi_id = guest_irq + VGIC_NR_PRIVATE_IRQS;
+	struct irq_chip *chip;
+	bool queued, needs_deactivate = true;
+	struct irq_phys_map *map;
+
+	kvm_debug("%s host_irq=%d guest_irq=%d\n",
+		__func__, host_irq, guest_irq);
+
+	spin_lock(&dist->lock);
+
+	irq_get_irqchip_state(host_irq, IRQCHIP_STATE_ACTIVE, active);
+
+	if (!vcpu)
+		goto out;
+
+	map = vgic_irq_map_search(vcpu, spi_id);
+	BUG_ON(!map);
+	ret = vgic_unmap_phys_irq(vcpu, map);
+	BUG_ON(ret);
+	/*
+	 * subsequent update_irq_pending or flush will handle this
+	 * irq as forwarded
+	 */
+
+	if (likely(!(*active))) {
+		/*
+		 * the IRQ was not active. It may happen the handle_fasteoi_irq
+		 * is entered afterwards due to lazy disable_irq. If this
+		 * happens the IRQ will be deactivated and never be injected.
+		 * let's simply prepare the states for subsequent non forwarded
+		 * injection
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
+	queued = false;
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
+			 * We are before the injection (update_irq_pending).
+			 * This is the most tricky window. Due to the usage of
+			 * disable_irq in generic unforward part (mandated by
+			 * resamplefd unmask VFIO integration), there is a risk
+			 * the fasteoi handler returns without calling the VFIO
+			 * handler and deactivates the physical IRQ (lazy
+			 * disable). Hence we cannot know whether the IRQ will
+			 * ever be injected. The only solution found is to do as
+			 * if the IRQ were not active. The active parameter
+			 * typically is used by the caller to know whether
+			 * it needs to mask * the IRQ. If not duly masked,
+			 * another physical IRQ may hit again while the previous
+			 * virtual IRQ is in progress. Update_irq_pending
+			 * validate_injection will prevent this injection.
+			 */
+			vgic_dist_irq_clear_level(vcpu, spi_id);
+			*active = false;
+		}
+		goto out;
+	}
+
+	/*
+	 * the virtual IRQ is queued and a valid LR exists, let's patch it for
+	 * EOI maintenance
+	 */
+	vlr.state |= LR_EOI_INT;
+	vgic_set_lr(vcpu, lr, vlr);
+	/*
+	 * we expect a maintenance IRQ which will reset the
+	 * queued, pending and level states
+	 */
+	vgic_dist_irq_set_level(vcpu, spi_id);
+	vgic_dist_irq_set_pending(vcpu, spi_id);
+	vgic_irq_set_queued(vcpu, spi_id);
+
+out:
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	d = irq_desc_get_irq_data(desc);
+	if (needs_deactivate) {
+		chip = irq_data_get_irq_chip(d);
+		chip->irq_eoi(d);
+	}
+	irqd_clr_irq_forwarded(d);
+	/* next occurrence will be deactivated by the host */
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+	*active = *active && vcpu;
+
+	spin_unlock(&dist->lock);
+}
+
-- 
1.9.1
