From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v2 6/7] KVM: arm/arm64: enable MSI routing
Date: Thu,  9 Jul 2015 10:22:16 +0200
Message-ID: <1436430137-24205-7-git-send-email-eric.auger@linaro.org>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A705E58281
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 04:11:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EioqsxBynwjL for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 04:11:20 -0400 (EDT)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
 [209.85.212.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF199582B4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 04:11:20 -0400 (EDT)
Received: by wibdq8 with SMTP id dq8so234632361wib.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Jul 2015 01:22:55 -0700 (PDT)
In-Reply-To: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Up to now, only irqchip routing entries could be set. This patch
adds the capability to insert MSI routing entries, with or without
device id. Although standard MSI entries can be set, their
injection still is not supported. For ARM64, let's also increase
KVM_MAX_IRQ_ROUTES to 4096: include SPI irqchip flat routes plus
MSI routes. In the future this might be extended.

The new MSI routing entry type also must be managed similarly to
legacy KVM_IRQ_ROUTING_MSI in eventfd irqfd_wakeup and irqfd_update.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v1 -> v2:
- adapt to new routing entry types

RFC -> PATCH:
- move api MSI routing updates into that patch file
- use new devid field of user api struct
---
 Documentation/virtual/kvm/api.txt | 10 ++++++++++
 include/linux/kvm_host.h          |  2 ++
 virt/kvm/arm/vgic.c               | 13 +++++++++++++
 virt/kvm/eventfd.c                |  6 ++++--
 4 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 9276dac..686b121 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1431,6 +1431,11 @@ Sets the GSI routing table entries, overwriting any previously set entries.
 On arm/arm64, GSI routing has the following limitation:
 - GSI routing does not apply to KVM_IRQ_LINE but only to KVM_IRQFD.
 
+On arm/arm64, MSI routing through in-kernel GICv3 ITS must use
+KVM_IRQ_ROUTING_EXTENDED_MSI routing type and device ID must be set
+in msi struct. Otherwise, KVM_IRQ_ROUTING_MSI must be used without
+populating the msi devid field.
+
 struct kvm_irq_routing {
 	__u32 nr;
 	__u32 flags;
@@ -2342,6 +2347,11 @@ On arm/arm64, gsi routing being supported, the following can happen:
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
index cac0fe4..ea1a810 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -976,6 +976,8 @@ static inline int mmu_notifier_retry(struct kvm *kvm, unsigned long mmu_seq)
 
 #ifdef CONFIG_S390
 #define KVM_MAX_IRQ_ROUTES 4096 //FIXME: we can have more than that...
+#elif defined(CONFIG_ARM64)
+#define KVM_MAX_IRQ_ROUTES 4096
 #else
 #define KVM_MAX_IRQ_ROUTES 1024
 #endif
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 63be67e..c5546d8 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2252,6 +2252,19 @@ int kvm_set_routing_entry(struct kvm_kernel_irq_routing_entry *e,
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
+		e->msi.address_lo = ue->u.msi.address_lo;
+		e->msi.address_hi = ue->u.msi.address_hi;
+		e->msi.data = ue->u.msi.data;
+		e->devid = ue->u.msi.devid;
+		break;
 	default:
 		goto out;
 	}
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 9ff4193..d76d05d 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -238,7 +238,8 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 			irq = irqfd->irq_entry;
 		} while (read_seqcount_retry(&irqfd->irq_entry_sc, seq));
 		/* An event has been signaled, inject an interrupt */
-		if (irq.type == KVM_IRQ_ROUTING_MSI)
+		if (irq.type == KVM_IRQ_ROUTING_MSI ||
+		    irq.type == KVM_IRQ_ROUTING_EXTENDED_MSI)
 			kvm_set_msi(&irq, kvm, KVM_USERSPACE_IRQ_SOURCE_ID, 1,
 					false);
 		else
@@ -294,7 +295,8 @@ static void irqfd_update(struct kvm *kvm, struct _irqfd *irqfd)
 	e = entries;
 	for (i = 0; i < n_entries; ++i, ++e) {
 		/* Only fast-path MSI. */
-		if (e->type == KVM_IRQ_ROUTING_MSI)
+		if (e->type == KVM_IRQ_ROUTING_MSI ||
+		    e->type == KVM_IRQ_ROUTING_EXTENDED_MSI)
 			irqfd->irq_entry = *e;
 	}
 
-- 
1.9.1
