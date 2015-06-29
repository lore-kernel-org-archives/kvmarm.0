From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 6/7] KVM: arm/arm64: enable MSI routing
Date: Mon, 29 Jun 2015 17:37:16 +0200
Message-ID: <1435592237-17924-7-git-send-email-eric.auger@linaro.org>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37FBF56A00
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 11:26:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uY2-eZZbnHUl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2015 11:26:47 -0400 (EDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
 [209.85.212.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D9A2569FB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 11:26:47 -0400 (EDT)
Received: by wibdq8 with SMTP id dq8so75973668wib.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 08:37:56 -0700 (PDT)
In-Reply-To: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, p.fedin@samsung.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Up to now, only irqchip routing entries could be set. This patch
adds the capability to insert MSI routing entries, extended or
standard ones. Although standard MSI entries can be set, their
injection still is not supported. For ARM64, let's also increase
KVM_MAX_IRQ_ROUTES to 4096: include SPI irqchip flat routes plus
MSI routes. In the future this might be extended.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

RFC -> PATCH:
- move api MSI routing updates into that patch file
- use new devid field of user api struct
---
 Documentation/virtual/kvm/api.txt |  9 +++++++++
 include/linux/kvm_host.h          |  2 ++
 virt/kvm/arm/vgic.c               | 13 +++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 1e0d5f5..b411232 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1405,6 +1405,10 @@ Sets the GSI routing table entries, overwriting any previously set entries.
 On arm/arm64, GSI routing has the following limitation:
 - GSI routing does not apply to KVM_IRQ_LINE but only to KVM_IRQFD.
 
+On arm/arm64, MSI routing through in-kernel GICv3 ITS must use
+KVM_IRQ_ROUTING_EXTENDED_MSI routing type to specify additionnal device ID.
+Otherwise, KVM_IRQ_ROUTING_MSI must be used.
+
 struct kvm_irq_routing {
 	__u32 nr;
 	__u32 flags;
@@ -2315,6 +2319,11 @@ On arm/arm64, gsi routing being supported, the following can happen:
 - in case no routing entry is associated to this gsi, injection fails
 - in case the gsi is associated to an irqchip routing entry,
   irqchip.pin + 32 corresponds to the injected SPI ID.
+- in case the gsi is associated to an MSI routing entry,
+  * without GICv3 ITS in-kernel emulation, MSI data patches the SPI ID
+    of the injected SPI
+  * with GICv3 ITS in-kernel emulation, the MSI message and device ID
+    are translated into an LPI.
 
 4.76 KVM_PPC_ALLOCATE_HTAB
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e1c1c0d..4ca8f8e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -927,6 +927,8 @@ static inline int mmu_notifier_retry(struct kvm *kvm, unsigned long mmu_seq)
 
 #ifdef CONFIG_S390
 #define KVM_MAX_IRQ_ROUTES 4096 //FIXME: we can have more than that...
+#elif defined(CONFIG_ARM64)
+#define KVM_MAX_IRQ_ROUTES 4096
 #else
 #define KVM_MAX_IRQ_ROUTES 1024
 #endif
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 410fee1..0b4c48c 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2258,6 +2258,19 @@ int kvm_set_routing_entry(struct kvm_kernel_irq_routing_entry *e,
 		    (e->irqchip.irqchip >= KVM_NR_IRQCHIPS))
 			goto out;
 		break;
+	case KVM_IRQ_ROUTING_MSI:
+		e->set = kvm_set_msi;
+		e->msi.address_lo = ue->u.msi.address_lo;
+		e->msi.address_hi = ue->u.msi.address_hi;
+		e->msi.data = ue->u.msi.data;
+		break;
+	case KVM_IRQ_ROUTING_EXTENDED_MSI:
+		e->set = kvm_set_msi;
+		e->ext_msi.address_lo = ue->u.msi.address_lo;
+		e->ext_msi.address_hi = ue->u.msi.address_hi;
+		e->ext_msi.data = ue->u.msi.data;
+		e->ext_msi.devid = ue->devid;
+		break;
 	default:
 		goto out;
 	}
-- 
1.9.1
