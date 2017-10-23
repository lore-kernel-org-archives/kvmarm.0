From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 08/10] KVM: arm/arm64: vgic-its: Free caches when GITS_BASER Valid bit is cleared
Date: Mon, 23 Oct 2017 16:08:27 +0200
Message-ID: <1508767709-15256-9-git-send-email-eric.auger@redhat.com>
References: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com
Cc: wu.wubin@huawei.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

When the GITS_BASER<n>.Valid gets cleared, the data structures in
guest RAM are not valid anymore. The device, collection
and LPI lists stored in the in-kernel ITS represent the same
information in some form of cache. So let's void the cache.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v4 -> v5:
- add comment about locking

v2 -> v3:
- add a comment and clear cache in if block
---
 virt/kvm/arm/vgic/vgic-its.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 8098f91..bdfceb4 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1434,8 +1434,9 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 				      unsigned long val)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
-	u64 entry_size, device_type;
+	u64 entry_size;
 	u64 reg, *regptr, clearbits = 0;
+	int type;
 
 	/* When GITS_CTLR.Enable is 1, we ignore write accesses. */
 	if (its->enabled)
@@ -1445,12 +1446,12 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
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
@@ -1462,10 +1463,28 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 	reg &= ~clearbits;
 
 	reg |= (entry_size - 1) << GITS_BASER_ENTRY_SIZE_SHIFT;
-	reg |= device_type << GITS_BASER_TYPE_SHIFT;
+	reg |= (u64)type << GITS_BASER_TYPE_SHIFT;
 	reg = vgic_sanitise_its_baser(reg);
 
 	*regptr = reg;
+
+	/*
+	 * If the table is no longer valid, we clear the associated cached data.
+	 * Note: there cannot be any race with save/restore code which locks
+	 * all vcpus.
+	 */
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
