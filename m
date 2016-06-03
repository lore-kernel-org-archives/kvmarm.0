From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 09/13] KVM: arm64: connect LPIs to the VGIC emulation
Date: Fri,  3 Jun 2016 15:02:48 +0100
Message-ID: <1464962572-3925-10-git-send-email-andre.przywara@arm.com>
References: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35F8349B3D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2016 09:58:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FWc9hu4ll4au for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jun 2016 09:58:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9E2E49AFA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2016 09:58:38 -0400 (EDT)
In-Reply-To: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

LPIs are dynamically created (mapped) at guest runtime and their
actual numbers can be quite high, but is mostly assigned using a very
sparse allocation scheme. So arrays are not an ideal data structure
to hold the information. We use our equivalent of the "Interrupt
Translation Table Entry" (ITTE) to hold the vgic_irq struct for a
virtual LPI embedded in in the ITTE.
Connect the VGIC core code via an accessor function to help it get the
struct vgic_irq for a certain LPI.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 34 ++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c     |  2 +-
 virt/kvm/arm/vgic/vgic.h     |  6 ++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 3ec12ef..4f248ef 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -68,11 +68,29 @@ struct its_collection {
 struct its_itte {
 	struct list_head itte_list;
 
+	struct vgic_irq irq;
 	struct its_collection *collection;
 	u32 lpi;
 	u32 event_id;
 };
 
+/* To be used as an iterator this macro misses the enclosing parentheses */
+#define for_each_lpi(dev, itte, its) \
+	list_for_each_entry(dev, &(its)->device_list, dev_list) \
+		list_for_each_entry(itte, &(dev)->itt, itte_list)
+
+static struct its_itte *find_itte_by_lpi(struct vgic_its *its, int lpi)
+{
+	struct its_device *device;
+	struct its_itte *itte;
+
+	for_each_lpi(device, itte, its) {
+		if (itte->lpi == lpi)
+			return itte;
+	}
+	return NULL;
+}
+
 #define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
 
 #define ITS_FRAME(addr) ((addr) & ~(SZ_64K - 1))
@@ -158,6 +176,22 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid)
+{
+	struct vgic_its *its;
+	struct its_itte *itte;
+
+	list_for_each_entry(its, &kvm->arch.vits_list, its_list) {
+		itte = find_itte_by_lpi(its, intid);
+		if (!itte)
+			continue;
+
+		return &itte->irq;
+	}
+
+	return NULL;
+}
+
 static void its_free_itte(struct its_itte *itte)
 {
 	list_del(&itte->itte_list);
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 69b61ab..6812ff1 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -58,7 +58,7 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 
 	/* LPIs are not yet covered */
 	if (intid >= VGIC_MIN_LPI)
-		return NULL;
+		return vgic_its_get_lpi(kvm, intid);
 
 	WARN(1, "Looking up struct vgic_irq for reserved INTID");
 	return NULL;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 66578d2..6fecd70 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -78,6 +78,7 @@ bool vgic_has_its(struct kvm *kvm);
 int vits_init(struct kvm *kvm, struct vgic_its *its);
 void vits_destroy(struct kvm *kvm, struct vgic_its *its);
 int kvm_vgic_register_its_device(void);
+struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
@@ -148,6 +149,11 @@ static int kvm_vgic_register_its_device(void)
 {
 	return -ENODEV;
 }
+
+static inline struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid)
+{
+	return NULL;
+}
 #endif
 
 int kvm_register_vgic_device(unsigned long type);
-- 
2.8.2
