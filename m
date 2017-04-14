From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 18/22] KVM: arm64: vgic-its: vgic_its_check_id returns the entry's GPA
Date: Fri, 14 Apr 2017 12:15:30 +0200
Message-ID: <1492164934-988-19-git-send-email-eric.auger@redhat.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

As vgic_its_check_id() computes the device/collection entry's
GPA, let's return it so that new callers can retrieve it easily.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v3 -> v4:
- check eaddr is not NULL to allow passing NULL eaddr parameter
  to vgic_its_check_id

v2: new
---
 virt/kvm/arm/vgic/vgic-its.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 484e541..35b2ca1 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -645,7 +645,8 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
  * is actually valid (covered by a memslot and guest accessible).
  * For this we have to read the respective first level entry.
  */
-static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id)
+static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
+			      gpa_t *eaddr)
 {
 	int l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 	int index;
@@ -665,6 +666,8 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id)
 		addr = BASER_ADDRESS(baser) + id * esz;
 		gfn = addr >> PAGE_SHIFT;
 
+		if (eaddr)
+			*eaddr = addr;
 		return kvm_is_visible_gfn(its->dev->kvm, gfn);
 	}
 
@@ -697,6 +700,8 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id)
 	indirect_ptr += index * esz;
 	gfn = indirect_ptr >> PAGE_SHIFT;
 
+	if (eaddr)
+		*eaddr = indirect_ptr;
 	return kvm_is_visible_gfn(its->dev->kvm, gfn);
 }
 
@@ -706,7 +711,7 @@ static int vgic_its_alloc_collection(struct vgic_its *its,
 {
 	struct its_collection *collection;
 
-	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id))
+	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
 		return E_ITS_MAPC_COLLECTION_OOR;
 
 	collection = kzalloc(sizeof(*collection), GFP_KERNEL);
@@ -889,7 +894,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
 	struct its_device *device;
 
-	if (!vgic_its_check_id(its, its->baser_device_table, device_id))
+	if (!vgic_its_check_id(its, its->baser_device_table, device_id, NULL))
 		return E_ITS_MAPD_DEVICE_OOR;
 
 	if (valid && nb_eventid_bits > VITS_TYPER_IDBITS)
-- 
2.5.5
