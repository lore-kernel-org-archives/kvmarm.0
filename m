From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v8 6/7] KVM: arm/arm64: Enable MSI routing
Date: Fri, 22 Jul 2016 13:46:39 +0000
Message-ID: <1469195200-6498-7-git-send-email-eric.auger@redhat.com>
References: <1469195200-6498-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75C1049B5D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 09:40:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5ELOLK65Gkgk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 09:40:45 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8191649B58
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 09:40:45 -0400 (EDT)
In-Reply-To: <1469195200-6498-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Up to now, only irqchip routing entries could be set. This patch
adds the capability to insert MSI routing entries.

For ARM64, let's also increase KVM_MAX_IRQ_ROUTES to 4096: this
include SPI irqchip routes plus MSI routes. In the future this
might be extended.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>

---
v7 -> v8:
- adapt to changes in kvm_kernel_irq_routing_entry and check the
  user entry flags according to the user entry type

v6 -> v7:
- added Andre's R-b

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
 Documentation/virtual/kvm/api.txt |  5 +++++
 include/linux/kvm_host.h          |  2 ++
 virt/kvm/arm/vgic/vgic-irqfd.c    |  8 ++++++++
 virt/kvm/irqchip.c                | 24 +++++++++++++++---------
 4 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 3bb60d3..60d4999 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2375,6 +2375,11 @@ On arm/arm64, gsi routing being supported, the following can happen:
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
index 49e8152..9fa4bc2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1040,6 +1040,8 @@ static inline int mmu_notifier_retry(struct kvm *kvm, unsigned long mmu_seq)
 
 #ifdef CONFIG_S390
 #define KVM_MAX_IRQ_ROUTES 4096 //FIXME: we can have more than that...
+#elif defined(CONFIG_ARM64)
+#define KVM_MAX_IRQ_ROUTES 4096
 #else
 #define KVM_MAX_IRQ_ROUTES 1024
 #endif
diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
index 77be112..04ce19f 100644
--- a/virt/kvm/arm/vgic/vgic-irqfd.c
+++ b/virt/kvm/arm/vgic/vgic-irqfd.c
@@ -60,6 +60,14 @@ int kvm_set_routing_entry(struct kvm_kernel_irq_routing_entry *e,
 		    (e->irqchip.irqchip >= KVM_NR_IRQCHIPS))
 			goto out;
 		break;
+	case KVM_IRQ_ROUTING_MSI:
+		e->set = kvm_set_msi;
+		e->msi.address_lo = ue->u.msi.address_lo;
+		e->msi.address_hi = ue->u.msi.address_hi;
+		e->msi.data = ue->u.msi.data;
+		e->msi.flags = ue->flags;
+		e->msi.devid = ue->u.msi.devid;
+		break;
 	default:
 		goto out;
 	}
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 0c00054..349ea6d 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -178,6 +178,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
 			unsigned flags)
 {
 	struct kvm_irq_routing_table *new, *old;
+	struct kvm_kernel_irq_routing_entry *e;
 	u32 i, j, nr_rt_entries = 0;
 	int r;
 
@@ -201,23 +202,25 @@ int kvm_set_irq_routing(struct kvm *kvm,
 			new->chip[i][j] = -1;
 
 	for (i = 0; i < nr; ++i) {
-		struct kvm_kernel_irq_routing_entry *e;
-
 		r = -ENOMEM;
 		e = kzalloc(sizeof(*e), GFP_KERNEL);
 		if (!e)
 			goto out;
 
 		r = -EINVAL;
-		if (ue->flags) {
-			kfree(e);
-			goto out;
+		switch (ue->type) {
+		case KVM_IRQ_ROUTING_IRQCHIP:
+			if (ue->flags)
+				goto free_entry;
+			break;
+		case KVM_IRQ_ROUTING_MSI:
+			if (ue->flags & ~KVM_MSI_VALID_DEVID)
+				goto free_entry;
+			break;
 		}
 		r = setup_routing_entry(new, e, ue);
-		if (r) {
-			kfree(e);
-			goto out;
-		}
+		if (r)
+			goto free_entry;
 		++ue;
 	}
 
@@ -234,7 +237,10 @@ int kvm_set_irq_routing(struct kvm *kvm,
 
 	new = old;
 	r = 0;
+	goto out;
 
+free_entry:
+	kfree(e);
 out:
 	free_irq_routing_table(new);
 
-- 
1.9.1
