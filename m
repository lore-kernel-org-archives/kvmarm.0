From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 7/7] KVM: arm: enable KVM_SIGNAL_MSI and MSI routing
Date: Mon,  4 Apr 2016 10:47:37 +0200
Message-ID: <1459759657-7402-8-git-send-email-eric.auger@linaro.org>
References: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D987040F77
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:48:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dycQZ8BOGvqs for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 04:48:02 -0400 (EDT)
Received: from mail-lf0-f48.google.com (mail-lf0-f48.google.com
 [209.85.215.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A69F40F90
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:47:59 -0400 (EDT)
Received: by mail-lf0-f48.google.com with SMTP id c62so158944351lfc.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2016 01:49:15 -0700 (PDT)
In-Reply-To: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, Manish.Jaggi@caviumnetworks.com, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

If the ITS modality is not available, let's simply support MSI
injection by transforming the MSI.data into an SPI ID.

This becomes possible to use KVM_SIGNAL_MSI ioctl and MSI
routing for arm too.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v2 -> v3:
- reword the commit message
- add sanity check about devid provision

v1 -> v2:
- introduce vgic_v2m_inject_msi in vgic-v2-emul.c following Andre's
  advice

Conflicts:
	arch/arm/kvm/Kconfig

Conflicts:
	arch/arm/kvm/Kconfig
---
 arch/arm/kvm/Kconfig           |  1 +
 virt/kvm/arm/vgic/vgic-v2.c    | 15 +++++++++++++++
 virt/kvm/arm/vgic/vgic.h       |  1 +
 virt/kvm/arm/vgic/vgic_irqfd.c |  2 +-
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 92c3aec..67019e5 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -50,6 +50,7 @@ config KVM_NEW_VGIC
 	bool "New VGIC implementation"
 	depends on KVM
 	default y
+	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
 	---help---
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 5f7c289..7400af0 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -248,6 +248,21 @@ void vgic_v2_enable(struct kvm_vcpu *vcpu)
 	vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr = GICH_HCR_EN;
 }
 
+/**
+ * vgic_v2m_inject_msi: emulates GICv2M MSI injection by injecting
+ * the SPI ID matching the msi data
+ *
+ * @kvm: pointer to the kvm struct
+ * @msi: the msi struct handle
+ */
+int vgic_v2m_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	if (msi->flags & KVM_MSI_VALID_DEVID)
+		return -EINVAL;
+
+	return kvm_vgic_inject_irq(kvm, 0, msi->data, 1);
+}
+
 int vgic_v2_map_resources(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 223c778..354a865 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -44,6 +44,7 @@ int vgic_v2_probe(struct device_node *vgic_node);
 int vgic_v2_map_resources(struct kvm *kvm);
 int vgic_register_dist_regions(struct kvm *kvm, gpa_t dist_base_address,
 			       enum vgic_type);
+int vgic_v2m_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
 
 #ifdef CONFIG_KVM_ARM_VGIC_V3
 void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid, u64 mpidr);
diff --git a/virt/kvm/arm/vgic/vgic_irqfd.c b/virt/kvm/arm/vgic/vgic_irqfd.c
index a3a7f02..588cdd6 100644
--- a/virt/kvm/arm/vgic/vgic_irqfd.c
+++ b/virt/kvm/arm/vgic/vgic_irqfd.c
@@ -100,7 +100,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 	msi.devid = e->devid;
 
 	if (!vgic_has_its(kvm))
-		return -ENODEV;
+		return vgic_v2m_inject_msi(kvm, &msi);
 
 	return vits_inject_msi(kvm, &msi);
 }
-- 
1.9.1
