From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 25/37] KVM: arm64: vgic-its: Fix pending table sync
Date: Tue,  9 May 2017 12:44:54 +0200
Message-ID: <20170509104506.30929-26-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BD1240CC6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M8f7yMC-NK+L for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 06:42:24 -0400 (EDT)
Received: from mail-qk0-f171.google.com (mail-qk0-f171.google.com
 [209.85.220.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9FA9840C74
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:21 -0400 (EDT)
Received: by mail-qk0-f171.google.com with SMTP id a72so58967029qkj.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 May 2017 03:45:36 -0700 (PDT)
In-Reply-To: <20170509104506.30929-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

In its_sync_lpi_pending_table() we currently ignore the
target_vcpu of the LPIs. We sync the pending bit found in
the vcpu pending table even if the LPI is not targeting it.

Also in vgic_its_cmd_handle_invall() we are supposed to
read the config table data for the LPIs associated to the
collection ID. At the moment we refresh all LPI config
information.

This patch passes a vpcu to vgic_copy_lpi_list() so that
this latter returns a snapshot of the LPIs targeting this
CPU and only those.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index adb3d9e..9f7105c 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -301,13 +301,13 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 }
 
 /*
- * Create a snapshot of the current LPI list, so that we can enumerate all
- * LPIs without holding any lock.
- * Returns the array length and puts the kmalloc'ed array into intid_ptr.
+ * Create a snapshot of the current LPIs targeting @vcpu, so that we can
+ * enumerate those LPIs without holding any lock.
+ * Returns their number and puts the kmalloc'ed array into intid_ptr.
  */
-static int vgic_copy_lpi_list(struct kvm *kvm, u32 **intid_ptr)
+static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
 {
-	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct vgic_irq *irq;
 	u32 *intids;
 	int irq_count = dist->lpi_list_count, i = 0;
@@ -326,14 +326,14 @@ static int vgic_copy_lpi_list(struct kvm *kvm, u32 **intid_ptr)
 	spin_lock(&dist->lpi_list_lock);
 	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
 		/* We don't need to "get" the IRQ, as we hold the list lock. */
-		intids[i] = irq->intid;
-		if (++i == irq_count)
-			break;
+		if (irq->target_vcpu != vcpu)
+			continue;
+		intids[i++] = irq->intid;
 	}
 	spin_unlock(&dist->lpi_list_lock);
 
 	*intid_ptr = intids;
-	return irq_count;
+	return i;
 }
 
 /*
@@ -382,7 +382,7 @@ static u32 max_lpis_propbaser(u64 propbaser)
 }
 
 /*
- * Scan the whole LPI pending table and sync the pending bit in there
+ * Sync the pending table pending bit of LPIs targeting @vcpu
  * with our own data structures. This relies on the LPI being
  * mapped before.
  */
@@ -395,7 +395,7 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 	u32 *intids;
 	int nr_irqs, i;
 
-	nr_irqs = vgic_copy_lpi_list(vcpu->kvm, &intids);
+	nr_irqs = vgic_copy_lpi_list(vcpu, &intids);
 	if (nr_irqs < 0)
 		return nr_irqs;
 
@@ -1081,7 +1081,7 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
 
 	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
 
-	irq_count = vgic_copy_lpi_list(kvm, &intids);
+	irq_count = vgic_copy_lpi_list(vcpu, &intids);
 	if (irq_count < 0)
 		return irq_count;
 
-- 
2.9.0
