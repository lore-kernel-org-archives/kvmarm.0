From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 12/13] KVM: arm64: implement MSI injection in ITS emulation
Date: Fri, 29 May 2015 10:53:28 +0100
Message-ID: <1432893209-27313-13-git-send-email-andre.przywara@arm.com>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 869C0524A4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2015 05:44:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 00d9WhpO8Cca for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 May 2015 05:44:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C053E52479
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2015 05:43:59 -0400 (EDT)
In-Reply-To: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When userland wants to inject a MSI into the guest, we have to use
our data structures to find the LPI number and the VCPU to receivce
the interrupt.
Use the wrapper functions to iterate the linked lists and find the
proper Interrupt Translation Table Entry. Then set the pending bit
in this ITTE to be later picked up by the LR handling code. Kick
the VCPU which is meant to handle this interrupt.
We provide a VGIC emulation model specific routine for the actual
MSI injection. The wrapper functions return an error for models not
(yet) implementing MSIs (like the GICv2 emulation).

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/arm_vgic.h      |  1 +
 virt/kvm/arm/its-emul.c     | 49 +++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/its-emul.h     |  2 ++
 virt/kvm/arm/vgic-v3-emul.c |  1 +
 4 files changed, 53 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index de19c34..6bb138d 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -149,6 +149,7 @@ struct vgic_vm_ops {
 	int	(*map_resources)(struct kvm *, const struct vgic_params *);
 	bool	(*queue_lpis)(struct kvm_vcpu *);
 	void	(*unqueue_lpi)(struct kvm_vcpu *, int irq);
+	int	(*inject_msi)(struct kvm *, struct kvm_msi *);
 };
 
 struct vgic_io_device {
diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
index 574cf05..35e886c 100644
--- a/virt/kvm/arm/its-emul.c
+++ b/virt/kvm/arm/its-emul.c
@@ -340,6 +340,55 @@ static bool handle_mmio_gits_idregs(struct kvm_vcpu *vcpu,
 }
 
 /*
+ * Translates an incoming MSI request into the redistributor (=VCPU) and
+ * the associated LPI number. Sets the LPI pending bit and also marks the
+ * VCPU as having a pending interrupt.
+ */
+int vits_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_its *its = &dist->its;
+	struct its_itte *itte;
+	int cpuid;
+	bool inject = false;
+	int ret = 0;
+
+	if (!vgic_has_its(kvm))
+		return -ENODEV;
+
+	if (!(msi->flags & KVM_MSI_VALID_DEVID))
+		return -EINVAL;
+
+	spin_lock(&its->lock);
+
+	if (!its->enabled || !dist->lpis_enabled) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
+	itte = find_itte(kvm, msi->devid, msi->data);
+	/* Triggering an unmapped IRQ gets silently dropped. */
+	if (!itte || !itte->collection)
+		goto out_unlock;
+
+	cpuid = itte->collection->target_addr;
+	set_bit(cpuid, itte->pending);
+	inject = itte->enabled;
+
+out_unlock:
+	spin_unlock(&its->lock);
+
+	if (inject) {
+		spin_lock(&dist->lock);
+		set_bit(cpuid, dist->irq_pending_on_cpu);
+		spin_unlock(&dist->lock);
+		kvm_vcpu_kick(kvm_get_vcpu(kvm, cpuid));
+	}
+
+	return ret;
+}
+
+/*
  * Find all enabled and pending LPIs and queue them into the list
  * registers.
  * The dist lock is held by the caller.
diff --git a/virt/kvm/arm/its-emul.h b/virt/kvm/arm/its-emul.h
index 6152d04..cac1406 100644
--- a/virt/kvm/arm/its-emul.h
+++ b/virt/kvm/arm/its-emul.h
@@ -33,6 +33,8 @@ void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 int vits_init(struct kvm *kvm);
 void vits_destroy(struct kvm *kvm);
 
+int vits_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
+
 bool vits_queue_lpis(struct kvm_vcpu *vcpu);
 void vits_unqueue_lpi(struct kvm_vcpu *vcpu, int irq);
 
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index 66640c2fa..4513551 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -901,6 +901,7 @@ void vgic_v3_init_emulation(struct kvm *kvm)
 	dist->vm_ops.init_model = vgic_v3_init_model;
 	dist->vm_ops.destroy_model = vgic_v3_destroy_model;
 	dist->vm_ops.map_resources = vgic_v3_map_resources;
+	dist->vm_ops.inject_msi = vits_inject_msi;
 	dist->vm_ops.queue_lpis = vits_queue_lpis;
 	dist->vm_ops.unqueue_lpi = vits_unqueue_lpi;
 
-- 
2.3.5
