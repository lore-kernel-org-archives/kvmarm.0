From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 07/12] KVM: arm/arm64: simplify vgic_find_range() and
 callers
Date: Mon, 23 Mar 2015 15:58:24 +0000
Message-ID: <1427126309-11223-8-git-send-email-andre.przywara@arm.com>
References: <1427126309-11223-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2664649747
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2015 11:51:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9jZ-ge-g3TtF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2015 11:51:47 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABA2149743
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2015 11:51:45 -0400 (EDT)
In-Reply-To: <1427126309-11223-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, pbonzini@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The vgic_find_range() function in vgic.c takes a struct kvm_exit_mmio
argument, but actually only used the length field in there. Since we
need to get rid of that structure in that part of the code anyway,
let's rework the function (and it's callers) to pass the length
argument to the function directly.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic-v2-emul.c |    2 +-
 virt/kvm/arm/vgic.c         |   22 ++++++++--------------
 virt/kvm/arm/vgic.h         |    3 +--
 3 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
index ddb3135..1dd183e 100644
--- a/virt/kvm/arm/vgic-v2-emul.c
+++ b/virt/kvm/arm/vgic-v2-emul.c
@@ -715,7 +715,7 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 	default:
 		BUG();
 	}
-	r = vgic_find_range(ranges, &mmio, offset);
+	r = vgic_find_range(ranges, 4, offset);
 
 	if (unlikely(!r || !r->handle_mmio)) {
 		ret = -ENXIO;
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 21a3550..8802ad7 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -713,16 +713,13 @@ void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
 
 const
 struct vgic_io_range *vgic_find_range(const struct vgic_io_range *ranges,
-				      struct kvm_exit_mmio *mmio,
-				      phys_addr_t offset)
+				      int len, gpa_t offset)
 {
-	const struct vgic_io_range *r = ranges;
-
-	while (r->len) {
-		if (offset >= r->base &&
-		    (offset + mmio->len) <= (r->base + r->len))
-			return r;
-		r++;
+	while (ranges->len) {
+		if (offset >= ranges->base &&
+		    (offset + len) <= (ranges->base + ranges->len))
+			return ranges;
+		ranges++;
 	}
 
 	return NULL;
@@ -813,7 +810,7 @@ bool vgic_handle_mmio_range(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	unsigned long offset;
 
 	offset = mmio->phys_addr - mmio_base;
-	range = vgic_find_range(ranges, mmio, offset);
+	range = vgic_find_range(ranges, mmio->len, offset);
 	if (unlikely(!range || !range->handle_mmio)) {
 		pr_warn("Unhandled access %d %08llx %d\n",
 			mmio->is_write, mmio->phys_addr, mmio->len);
@@ -1986,10 +1983,7 @@ int vgic_get_common_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 
 int vgic_has_attr_regs(const struct vgic_io_range *ranges, phys_addr_t offset)
 {
-	struct kvm_exit_mmio dev_attr_mmio;
-
-	dev_attr_mmio.len = 4;
-	if (vgic_find_range(ranges, &dev_attr_mmio, offset))
+	if (vgic_find_range(ranges, 4, offset))
 		return 0;
 	else
 		return -ENXIO;
diff --git a/virt/kvm/arm/vgic.h b/virt/kvm/arm/vgic.h
index 6fccb96..01aa622 100644
--- a/virt/kvm/arm/vgic.h
+++ b/virt/kvm/arm/vgic.h
@@ -90,8 +90,7 @@ static inline bool is_in_range(phys_addr_t addr, unsigned long len,
 
 const
 struct vgic_io_range *vgic_find_range(const struct vgic_io_range *ranges,
-				      struct kvm_exit_mmio *mmio,
-				      phys_addr_t offset);
+				      int len, gpa_t offset);
 
 bool vgic_handle_mmio_range(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			    struct kvm_exit_mmio *mmio,
-- 
1.7.9.5
