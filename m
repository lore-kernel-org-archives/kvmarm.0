From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 08/12] KVM: arm64: connect LPIs to the VGIC emulation
Date: Sat, 26 Mar 2016 02:14:06 +0000
Message-ID: <1458958450-19662-9-git-send-email-andre.przywara@arm.com>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D959412ED
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2016 22:13:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R4VSnhtGVddv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Mar 2016 22:13:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6113249B1D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2016 22:13:31 -0400 (EDT)
In-Reply-To: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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
 virt/kvm/arm/vgic/its-emul.c | 29 +++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h     |  8 +++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/its-emul.c b/virt/kvm/arm/vgic/its-emul.c
index c0334ff..1188e9a 100644
--- a/virt/kvm/arm/vgic/its-emul.c
+++ b/virt/kvm/arm/vgic/its-emul.c
@@ -55,11 +55,29 @@ struct its_collection {
 struct its_itte {
 	struct list_head itte_list;
 
+	struct vgic_irq irq;
 	struct its_collection *collection;
 	u32 lpi;
 	u32 event_id;
 };
 
+/* To be used as an iterator this macro misses the enclosing parentheses */
+#define for_each_lpi(dev, itte, kvm) \
+	list_for_each_entry(dev, &(kvm)->arch.vgic.its.device_list, dev_list) \
+		list_for_each_entry(itte, &(dev)->itt, itte_list)
+
+static struct its_itte *find_itte_by_lpi(struct kvm *kvm, int lpi)
+{
+	struct its_device *device;
+	struct its_itte *itte;
+
+	for_each_lpi(device, itte, kvm) {
+		if (itte->lpi == lpi)
+			return itte;
+	}
+	return NULL;
+}
+
 #define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
 
 static int vgic_mmio_read_its_ctlr(struct kvm_vcpu *vcpu,
@@ -166,6 +184,17 @@ static int vgic_mmio_read_its_idregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid)
+{
+	struct its_itte *itte;
+
+	itte = find_itte_by_lpi(kvm, intid);
+	if (!itte)
+		return NULL;
+
+	return &itte->irq;
+}
+
 static void its_free_itte(struct its_itte *itte)
 {
 	list_del(&itte->itte_list);
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 08f97d1..160c511 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -63,6 +63,7 @@ int vgic_register_redist_regions(struct kvm *kvm, gpa_t dist_base_address);
 
 int vits_init(struct kvm *kvm);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
+struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid);
 void vits_destroy(struct kvm *kvm);
 #else
 static inline void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid,
@@ -129,7 +130,7 @@ static inline int vgic_register_redist_regions(struct kvm *kvm,
 	return -ENODEV;
 }
 
-int vits_init(struct kvm *kvm)
+static inline int vits_init(struct kvm *kvm)
 {
 	return 0;
 }
@@ -139,6 +140,11 @@ static inline void vgic_enable_lpis(struct kvm_vcpu *vcpu)
 	return;
 }
 
+static inline struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid)
+{
+	return NULL;
+}
+
 static inline void vits_destroy(struct kvm *kvm)
 {
 	return;
-- 
2.7.3
