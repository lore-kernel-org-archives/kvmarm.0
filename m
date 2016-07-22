From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 31/55] KVM: arm/arm64: vgic: Add refcounting for IRQs
Date: Fri, 22 Jul 2016 18:28:48 +0100
Message-ID: <1469208552-4155-32-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Dan Carpenter <dan.carpenter@oracle.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

In the moment our struct vgic_irq's are statically allocated at guest
creation time. So getting a pointer to an IRQ structure is trivial and
safe. LPIs are more dynamic, they can be mapped and unmapped at any time
during the guest's _runtime_.
In preparation for supporting LPIs we introduce reference counting for
those structures using the kernel's kref infrastructure.
Since private IRQs and SPIs are statically allocated, we avoid actually
refcounting them, since they would never be released anyway.
But we take provisions to increase the refcount when an IRQ gets onto a
VCPU list and decrease it when it gets removed. Also this introduces
vgic_put_irq(), which wraps kref_put and hides the release function from
the callers.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h           |  1 +
 virt/kvm/arm/vgic/vgic-init.c    |  2 ++
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  8 +++++++
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 20 ++++++++++------
 virt/kvm/arm/vgic/vgic-mmio.c    | 25 ++++++++++++++++++-
 virt/kvm/arm/vgic/vgic-v2.c      |  1 +
 virt/kvm/arm/vgic/vgic-v3.c      |  1 +
 virt/kvm/arm/vgic/vgic.c         | 52 ++++++++++++++++++++++++++++++++++++----
 virt/kvm/arm/vgic/vgic.h         |  1 +
 9 files changed, 99 insertions(+), 12 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 5142e2a..450b4da 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -96,6 +96,7 @@ struct vgic_irq {
 	bool active;			/* not used for LPIs */
 	bool enabled;
 	bool hw;			/* Tied to HW IRQ */
+	struct kref refcount;		/* Used for LPIs */
 	u32 hwintid;			/* HW INTID number */
 	union {
 		u8 targets;			/* GICv2 target VCPUs mask */
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 90cae48..ac3c1a5 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -177,6 +177,7 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 		spin_lock_init(&irq->irq_lock);
 		irq->vcpu = NULL;
 		irq->target_vcpu = vcpu0;
+		kref_init(&irq->refcount);
 		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
 			irq->targets = 0;
 		else
@@ -211,6 +212,7 @@ static void kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 		irq->vcpu = NULL;
 		irq->target_vcpu = vcpu;
 		irq->targets = 1U << vcpu->vcpu_id;
+		kref_init(&irq->refcount);
 		if (vgic_irq_is_sgi(i)) {
 			/* SGIs */
 			irq->enabled = 1;
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index a213936..4152348 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -102,6 +102,7 @@ static void vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
 		irq->source |= 1U << source_vcpu->vcpu_id;
 
 		vgic_queue_irq_unlock(source_vcpu->kvm, irq);
+		vgic_put_irq(source_vcpu->kvm, irq);
 	}
 }
 
@@ -116,6 +117,8 @@ static unsigned long vgic_mmio_read_target(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
 		val |= (u64)irq->targets << (i * 8);
+
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 
 	return val;
@@ -143,6 +146,7 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
 		irq->target_vcpu = kvm_get_vcpu(vcpu->kvm, target);
 
 		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
 
@@ -157,6 +161,8 @@ static unsigned long vgic_mmio_read_sgipend(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
 		val |= (u64)irq->source << (i * 8);
+
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 	return val;
 }
@@ -178,6 +184,7 @@ static void vgic_mmio_write_sgipendc(struct kvm_vcpu *vcpu,
 			irq->pending = false;
 
 		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
 
@@ -201,6 +208,7 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
 		} else {
 			spin_unlock(&irq->irq_lock);
 		}
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index fc7b6c9..bfcafbd 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -80,15 +80,17 @@ static unsigned long vgic_mmio_read_irouter(struct kvm_vcpu *vcpu,
 {
 	int intid = VGIC_ADDR_TO_INTID(addr, 64);
 	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
+	unsigned long ret = 0;
 
 	if (!irq)
 		return 0;
 
 	/* The upper word is RAZ for us. */
-	if (addr & 4)
-		return 0;
+	if (!(addr & 4))
+		ret = extract_bytes(READ_ONCE(irq->mpidr), addr & 7, len);
 
-	return extract_bytes(READ_ONCE(irq->mpidr), addr & 7, len);
+	vgic_put_irq(vcpu->kvm, irq);
+	return ret;
 }
 
 static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
@@ -96,15 +98,17 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
 				    unsigned long val)
 {
 	int intid = VGIC_ADDR_TO_INTID(addr, 64);
-	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
-
-	if (!irq)
-		return;
+	struct vgic_irq *irq;
 
 	/* The upper word is WI for us since we don't implement Aff3. */
 	if (addr & 4)
 		return;
 
+	irq = vgic_get_irq(vcpu->kvm, NULL, intid);
+
+	if (!irq)
+		return;
+
 	spin_lock(&irq->irq_lock);
 
 	/* We only care about and preserve Aff0, Aff1 and Aff2. */
@@ -112,6 +116,7 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
 	irq->target_vcpu = kvm_mpidr_to_vcpu(vcpu->kvm, irq->mpidr);
 
 	spin_unlock(&irq->irq_lock);
+	vgic_put_irq(vcpu->kvm, irq);
 }
 
 static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
@@ -445,5 +450,6 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
 		irq->pending = true;
 
 		vgic_queue_irq_unlock(vcpu->kvm, irq);
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 9f6fab7..5e79e01 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -56,6 +56,8 @@ unsigned long vgic_mmio_read_enable(struct kvm_vcpu *vcpu,
 
 		if (irq->enabled)
 			value |= (1U << i);
+
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 
 	return value;
@@ -74,6 +76,8 @@ void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
 		spin_lock(&irq->irq_lock);
 		irq->enabled = true;
 		vgic_queue_irq_unlock(vcpu->kvm, irq);
+
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
 
@@ -92,6 +96,7 @@ void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
 		irq->enabled = false;
 
 		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
 
@@ -108,6 +113,8 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 
 		if (irq->pending)
 			value |= (1U << i);
+
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 
 	return value;
@@ -129,6 +136,7 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 			irq->soft_pending = true;
 
 		vgic_queue_irq_unlock(vcpu->kvm, irq);
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
 
@@ -152,6 +160,7 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 		}
 
 		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
 
@@ -168,6 +177,8 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 
 		if (irq->active)
 			value |= (1U << i);
+
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 
 	return value;
@@ -242,6 +253,7 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 		vgic_mmio_change_active(vcpu, irq, false);
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 	vgic_change_active_finish(vcpu, intid);
 }
@@ -257,6 +269,7 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 		vgic_mmio_change_active(vcpu, irq, true);
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 	vgic_change_active_finish(vcpu, intid);
 }
@@ -272,6 +285,8 @@ unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
 		val |= (u64)irq->priority << (i * 8);
+
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 
 	return val;
@@ -298,6 +313,8 @@ void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
 		/* Narrow the priority range to what we actually support */
 		irq->priority = (val >> (i * 8)) & GENMASK(7, 8 - VGIC_PRI_BITS);
 		spin_unlock(&irq->irq_lock);
+
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
 
@@ -313,6 +330,8 @@ unsigned long vgic_mmio_read_config(struct kvm_vcpu *vcpu,
 
 		if (irq->config == VGIC_CONFIG_EDGE)
 			value |= (2U << (i * 2));
+
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 
 	return value;
@@ -326,7 +345,7 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 	int i;
 
 	for (i = 0; i < len * 4; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq;
 
 		/*
 		 * The configuration cannot be changed for SGIs in general,
@@ -337,14 +356,18 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 		if (intid + i < VGIC_NR_PRIVATE_IRQS)
 			continue;
 
+		irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 		spin_lock(&irq->irq_lock);
+
 		if (test_bit(i * 2 + 1, &val)) {
 			irq->config = VGIC_CONFIG_EDGE;
 		} else {
 			irq->config = VGIC_CONFIG_LEVEL;
 			irq->pending = irq->line_level | irq->soft_pending;
 		}
+
 		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 079bf67..0bf6709 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -124,6 +124,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 		}
 
 		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index e48a22e..f0ac064 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -113,6 +113,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		}
 
 		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
 
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 69b61ab..fb19a55 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -64,6 +64,28 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	return NULL;
 }
 
+static void vgic_get_irq_kref(struct vgic_irq *irq)
+{
+	if (irq->intid < VGIC_MIN_LPI)
+		return;
+
+	kref_get(&irq->refcount);
+}
+
+/* The refcount should never drop to 0 at the moment. */
+static void vgic_irq_release(struct kref *ref)
+{
+	WARN_ON(1);
+}
+
+void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
+{
+	if (irq->intid < VGIC_MIN_LPI)
+		return;
+
+	kref_put(&irq->refcount, vgic_irq_release);
+}
+
 /**
  * kvm_vgic_target_oracle - compute the target vcpu for an irq
  *
@@ -236,6 +258,11 @@ retry:
 		goto retry;
 	}
 
+	/*
+	 * Grab a reference to the irq to reflect the fact that it is
+	 * now in the ap_list.
+	 */
+	vgic_get_irq_kref(irq);
 	list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
 	irq->vcpu = vcpu;
 
@@ -269,14 +296,17 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 	if (!irq)
 		return -EINVAL;
 
-	if (irq->hw != mapped_irq)
+	if (irq->hw != mapped_irq) {
+		vgic_put_irq(kvm, irq);
 		return -EINVAL;
+	}
 
 	spin_lock(&irq->irq_lock);
 
 	if (!vgic_validate_injection(irq, level)) {
 		/* Nothing to see here, move along... */
 		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(kvm, irq);
 		return 0;
 	}
 
@@ -288,6 +318,7 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 	}
 
 	vgic_queue_irq_unlock(kvm, irq);
+	vgic_put_irq(kvm, irq);
 
 	return 0;
 }
@@ -330,25 +361,28 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq)
 	irq->hwintid = phys_irq;
 
 	spin_unlock(&irq->irq_lock);
+	vgic_put_irq(vcpu->kvm, irq);
 
 	return 0;
 }
 
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 {
-	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
-
-	BUG_ON(!irq);
+	struct vgic_irq *irq;
 
 	if (!vgic_initialized(vcpu->kvm))
 		return -EAGAIN;
 
+	irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
+	BUG_ON(!irq);
+
 	spin_lock(&irq->irq_lock);
 
 	irq->hw = false;
 	irq->hwintid = 0;
 
 	spin_unlock(&irq->irq_lock);
+	vgic_put_irq(vcpu->kvm, irq);
 
 	return 0;
 }
@@ -386,6 +420,15 @@ retry:
 			list_del(&irq->ap_list);
 			irq->vcpu = NULL;
 			spin_unlock(&irq->irq_lock);
+
+			/*
+			 * This vgic_put_irq call matches the
+			 * vgic_get_irq_kref in vgic_queue_irq_unlock,
+			 * where we added the LPI to the ap_list. As
+			 * we remove the irq from the list, we drop
+			 * also drop the refcount.
+			 */
+			vgic_put_irq(vcpu->kvm, irq);
 			continue;
 		}
 
@@ -614,6 +657,7 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 	spin_lock(&irq->irq_lock);
 	map_is_active = irq->hw && irq->active;
 	spin_unlock(&irq->irq_lock);
+	vgic_put_irq(vcpu->kvm, irq);
 
 	return map_is_active;
 }
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index c752152..5b79c34 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -38,6 +38,7 @@ struct vgic_vmcr {
 
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid);
+void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
 bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
 void vgic_kick_vcpus(struct kvm *kvm);
 
-- 
2.8.1

