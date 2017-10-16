From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 09/11] KVM: arm/arm64: vgic-its: free caches when GITS_BASER Valid bit is cleared
Date: Mon, 16 Oct 2017 17:03:30 +0200
Message-ID: <1508166212-9599-10-git-send-email-eric.auger@redhat.com>
References: <1508166212-9599-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508166212-9599-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com
Cc: wu.wubin@huawei.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

When the GITS_BASER<n>.Valid gets cleared, the data structures in
guest RAM are not valid anymore. The device, collection
and LPI lists stored in the in-kernel ITS represent the same
information in some form of cache. So let's void the cache.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v2 -> v3:
- add a comment and clear cache in if block
---
 virt/kvm/arm/vgic/vgic-its.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 1e17cfe..c3f57ea 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1471,8 +1471,9 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 				      unsigned long val)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
-	u64 entry_size, device_type;
+	u64 entry_size;
 	u64 reg, *regptr, clearbits = 0;
+	int type;
 
 	/* When GITS_CTLR.Enable is 1, we ignore write accesses. */
 	if (its->enabled)
@@ -1482,12 +1483,12 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 	case 0:
 		regptr = &its->baser_device_table;
 		entry_size = abi->dte_esz;
-		device_type = GITS_BASER_TYPE_DEVICE;
+		type = GITS_BASER_TYPE_DEVICE;
 		break;
 	case 1:
 		regptr = &its->baser_coll_table;
 		entry_size = abi->cte_esz;
-		device_type = GITS_BASER_TYPE_COLLECTION;
+		type = GITS_BASER_TYPE_COLLECTION;
 		clearbits = GITS_BASER_INDIRECT;
 		break;
 	default:
@@ -1499,10 +1500,24 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 	reg &= ~clearbits;
 
 	reg |= (entry_size - 1) << GITS_BASER_ENTRY_SIZE_SHIFT;
-	reg |= device_type << GITS_BASER_TYPE_SHIFT;
+	reg |= (u64)type << GITS_BASER_TYPE_SHIFT;
 	reg = vgic_sanitise_its_baser(reg);
 
 	*regptr = reg;
+
+	/* Table no longer valid: clear cached data */
+	if (!(reg & GITS_BASER_VALID)) {
+		switch (type) {
+		case GITS_BASER_TYPE_DEVICE:
+			vgic_its_free_device_list(kvm, its);
+			break;
+		case GITS_BASER_TYPE_COLLECTION:
+			vgic_its_free_collection_list(kvm, its);
+			break;
+		default:
+			break;
+		}
+	}
 }
 
 static unsigned long vgic_mmio_read_its_ctlr(struct kvm *vcpu,
-- 
2.5.5
