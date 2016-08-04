From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 6/8] KVM: arm/arm64: Enable MSI routing
Date: Thu,  4 Aug 2016 13:40:34 +0200
Message-ID: <1470310836-10371-7-git-send-email-christoffer.dall@linaro.org>
References: <1470310836-10371-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30B9449B70
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2016 07:34:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9hTUNDoYosMs for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Aug 2016 07:34:04 -0400 (EDT)
Received: from mail-lf0-f52.google.com (mail-lf0-f52.google.com
 [209.85.215.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E8AF749B4A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2016 07:34:02 -0400 (EDT)
Received: by mail-lf0-f52.google.com with SMTP id l69so180219235lfg.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Aug 2016 04:40:55 -0700 (PDT)
In-Reply-To: <1470310836-10371-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

Up to now, only irqchip routing entries could be set. This patch
adds the capability to insert MSI routing entries.

For ARM64, let's also increase KVM_MAX_IRQ_ROUTES to 4096: this
include SPI irqchip routes plus MSI routes. In the future this
might be extended.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/api.txt |  3 +++
 include/linux/kvm_host.h          |  2 ++
 virt/kvm/arm/vgic/vgic-irqfd.c    |  8 ++++++++
 virt/kvm/irqchip.c                | 24 +++++++++++++++---------
 4 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 7e5f9af..7a04216 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2381,6 +2381,9 @@ On arm/arm64, gsi routing being supported, the following can happen:
 - in case no routing entry is associated to this gsi, injection fails
 - in case the gsi is associated to an irqchip routing entry,
   irqchip.pin + 32 corresponds to the injected SPI ID.
+- in case the gsi is associated to an MSI routing entry, the MSI
+  message and device ID are translated into an LPI (support restricted
+  to GICv3 ITS in-kernel emulation).
 
 4.76 KVM_PPC_ALLOCATE_HTAB
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a7eb5c4..a318c3b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1048,6 +1048,8 @@ static inline int mmu_notifier_retry(struct kvm *kvm, unsigned long mmu_seq)
 
 #ifdef CONFIG_S390
 #define KVM_MAX_IRQ_ROUTES 4096 //FIXME: we can have more than that...
+#elif defined(CONFIG_ARM64)
+#define KVM_MAX_IRQ_ROUTES 4096
 #else
 #define KVM_MAX_IRQ_ROUTES 1024
 #endif
diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
index 6e84d53..683a589 100644
--- a/virt/kvm/arm/vgic/vgic-irqfd.c
+++ b/virt/kvm/arm/vgic/vgic-irqfd.c
@@ -59,6 +59,14 @@ int kvm_set_routing_entry(struct kvm_kernel_irq_routing_entry *e,
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
index 0c00054..c620219 100644
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
+		case KVM_IRQ_ROUTING_MSI:
+			if (ue->flags & ~KVM_MSI_VALID_DEVID)
+				goto free_entry;
+			break;
+		default:
+			if (ue->flags)
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
