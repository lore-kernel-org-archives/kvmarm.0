From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v8 7/7] KVM: arm: Enable KVM_SIGNAL_MSI and MSI routing
Date: Fri, 22 Jul 2016 13:46:40 +0000
Message-ID: <1469195200-6498-8-git-send-email-eric.auger@redhat.com>
References: <1469195200-6498-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1469195200-6498-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com
Cc: drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

If the ITS modality is not available, let's simply support MSI
injection by transforming the MSI.data into an SPI ID.

This becomes possible to use KVM_SIGNAL_MSI ioctl and MSI
routing for arm too.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v6 -> v7:
- move vgic_v2m_inject_msi into vgic-irqfd

v4 -> v5:
- on vgic_v2m_inject_msi check the msi->data is within the SPI range
- move KVM_HAVE_MSI in the KVM section (to be symetrical with ARM64)

v2 -> v3:
- reword the commit message
- add sanity check about devid provision

v1 -> v2:
- introduce vgic_v2m_inject_msi in vgic-v2-emul.c following Andre's
  advice
---
 arch/arm/kvm/Kconfig           |  1 +
 virt/kvm/arm/vgic/vgic-irqfd.c | 19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 3e1cd04..90d0176 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -34,6 +34,7 @@ config KVM
 	select HAVE_KVM_IRQFD
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
+	select HAVE_KVM_MSI
 	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
 	---help---
 	  Support hosting virtualized guest machines.
diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
index 04ce19f..67fb3f3 100644
--- a/virt/kvm/arm/vgic/vgic-irqfd.c
+++ b/virt/kvm/arm/vgic/vgic-irqfd.c
@@ -77,6 +77,23 @@ out:
 }
 
 /**
+ * vgic_v2m_inject_msi: emulates GICv2M MSI injection by injecting
+ * the SPI ID matching the msi data
+ *
+ * @kvm: pointer to the kvm struct
+ * @msi: the msi struct handle
+ */
+static int vgic_v2m_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	if (msi->flags & KVM_MSI_VALID_DEVID)
+		return -EINVAL;
+	if (!vgic_valid_spi(kvm, msi->data))
+		return -EINVAL;
+
+	return kvm_vgic_inject_irq(kvm, 0, msi->data, 1);
+}
+
+/**
  * kvm_set_msi: inject the MSI corresponding to the
  * MSI routing entry
  *
@@ -96,7 +113,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 	msi.devid = e->msi.devid;
 
 	if (!vgic_has_its(kvm))
-		return -ENODEV;
+		return vgic_v2m_inject_msi(kvm, &msi);
 
 	return vgic_its_inject_msi(kvm, &msi);
 }
-- 
1.9.1

