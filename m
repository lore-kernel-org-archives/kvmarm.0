From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 22/37] KVM: arm64: vgic-its: vgic_its_check_id returns the entry's GPA
Date: Tue,  9 May 2017 12:44:51 +0200
Message-ID: <20170509104506.30929-23-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170509104506.30929-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

As vgic_its_check_id() computes the device/collection entry's
GPA, let's return it so that new callers can retrieve it easily.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Acked-by: Christoffer Dall <cdall@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 5523f0a..90afc83 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -694,7 +694,8 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
  * is actually valid (covered by a memslot and guest accessible).
  * For this we have to read the respective first level entry.
  */
-static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id)
+static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
+			      gpa_t *eaddr)
 {
 	int l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 	u64 indirect_ptr, type = GITS_BASER_TYPE(baser);
@@ -725,6 +726,8 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id)
 		addr = BASER_ADDRESS(baser) + id * esz;
 		gfn = addr >> PAGE_SHIFT;
 
+		if (eaddr)
+			*eaddr = addr;
 		return kvm_is_visible_gfn(its->dev->kvm, gfn);
 	}
 
@@ -757,6 +760,8 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id)
 	indirect_ptr += index * esz;
 	gfn = indirect_ptr >> PAGE_SHIFT;
 
+	if (eaddr)
+		*eaddr = indirect_ptr;
 	return kvm_is_visible_gfn(its->dev->kvm, gfn);
 }
 
@@ -766,7 +771,7 @@ static int vgic_its_alloc_collection(struct vgic_its *its,
 {
 	struct its_collection *collection;
 
-	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id))
+	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
 		return E_ITS_MAPC_COLLECTION_OOR;
 
 	collection = kzalloc(sizeof(*collection), GFP_KERNEL);
@@ -939,7 +944,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
 	struct its_device *device;
 
-	if (!vgic_its_check_id(its, its->baser_device_table, device_id))
+	if (!vgic_its_check_id(its, its->baser_device_table, device_id, NULL))
 		return E_ITS_MAPD_DEVICE_OOR;
 
 	if (valid && num_eventid_bits > VITS_TYPER_IDBITS)
-- 
2.9.0
