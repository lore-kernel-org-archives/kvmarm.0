From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 6/7] KVM: arm/arm64: enable MSI routing
Date: Mon,  4 Apr 2016 10:47:36 +0200
Message-ID: <1459759657-7402-7-git-send-email-eric.auger@linaro.org>
References: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, pbonzini@redhat.com, p.fedin@samsung.com, Manish.Jaggi@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

Up to now, only irqchip routing entries could be set. This patch
adds the capability to insert MSI routing entries.

For ARM64, let's also increase KVM_MAX_IRQ_ROUTES to 4096: this
include SPI irqchip routes plus MSI routes. In the future this
might be extended.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v2 -> v3:
- remove any reference to KVM_IRQ_ROUTING_EXTENDED_MSI type
- unconditionnaly uapi flags and devid downto the kernel
  routing entry struct
- handle KVM_MSI_VALID_DEVID flag in kvm_set_irq_routing
- note about KVM_CAP_MSI_DEVID moved in the first patch file
  of the series

v1 -> v2:
- adapt to new routing entry types

RFC -> PATCH:
- move api MSI routing updates into that patch file
- use new devid field of user api struct
---
 Documentation/virtual/kvm/api.txt | 5 +++++
 include/linux/kvm_host.h          | 2 ++
 virt/kvm/arm/vgic/vgic_irqfd.c    | 8 ++++++++
 virt/kvm/irqchip.c                | 2 +-
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 61f8f27..217b460 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2368,6 +2368,11 @@ On arm/arm64, gsi routing being supported, the following can happen:
 - in case no routing entry is associated to this gsi, injection fails
 - in case the gsi is associated to an irqchip routing entry,
   irqchip.pin + 32 corresponds to the injected SPI ID.
+- in case the gsi is associated to an MSI routing entry,
+  * without GICv3 ITS in-kernel emulation, MSI data matches the SPI ID
+    of the injected SPI
+  * with GICv3 ITS in-kernel emulation, the MSI message and device ID
+    are translated into an LPI.
 
 4.76 KVM_PPC_ALLOCATE_HTAB
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 461e480..f25613d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1021,6 +1021,8 @@ static inline int mmu_notifier_retry(struct kvm *kvm, unsigned long mmu_seq)
 
 #ifdef CONFIG_S390
 #define KVM_MAX_IRQ_ROUTES 4096 //FIXME: we can have more than that...
+#elif defined(CONFIG_ARM64)
+#define KVM_MAX_IRQ_ROUTES 4096
 #else
 #define KVM_MAX_IRQ_ROUTES 1024
 #endif
diff --git a/virt/kvm/arm/vgic/vgic_irqfd.c b/virt/kvm/arm/vgic/vgic_irqfd.c
index a76994f..a3a7f02 100644
--- a/virt/kvm/arm/vgic/vgic_irqfd.c
+++ b/virt/kvm/arm/vgic/vgic_irqfd.c
@@ -64,6 +64,14 @@ int kvm_set_routing_entry(struct kvm_kernel_irq_routing_entry *e,
 		    (e->irqchip.irqchip >= KVM_NR_IRQCHIPS))
 			goto out;
 		break;
+	case KVM_IRQ_ROUTING_MSI:
+		e->set = kvm_set_msi;
+		e->msi.address_lo = ue->u.msi.address_lo;
+		e->msi.address_hi = ue->u.msi.address_hi;
+		e->msi.data = ue->u.msi.data;
+		e->flags = ue->flags;
+		e->devid = ue->u.msi.devid;
+		break;
 	default:
 		goto out;
 	}
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index b4222d6..269d949 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -211,7 +211,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
 			goto out;
 
 		r = -EINVAL;
-		if (ue->flags) {
+		if (ue->flags & ~KVM_MSI_VALID_DEVID) {
 			kfree(e);
 			goto out;
 		}
-- 
1.9.1

