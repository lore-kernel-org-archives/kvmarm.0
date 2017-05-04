From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 20/24] KVM: arm64: vgic-its: vgic_its_check_id returns the
 entry's GPA
Date: Thu,  4 May 2017 13:44:40 +0200
Message-ID: <1493898284-29504-21-git-send-email-eric.auger@redhat.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 521B14095A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 07:43:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DTHhgpYWkJBP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 May 2017 07:43:55 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E6BC340190
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 07:43:54 -0400 (EDT)
In-Reply-To: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, bjsprakash.linux@gmail.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

As vgic_its_check_id() computes the device/collection entry's
GPA, let's return it so that new callers can retrieve it easily.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Acked-by: Christoffer Dall <cdall@linaro.org>

---
v5 -> v6:
- add Christoffer's A-b

v3 -> v4:
- check eaddr is not NULL to allow passing NULL eaddr parameter
  to vgic_its_check_id

v2: new
---
 virt/kvm/arm/vgic/vgic-its.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 6bef9147..a3ed52a 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -668,7 +668,8 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
  * is actually valid (covered by a memslot and guest accessible).
  * For this we have to read the respective first level entry.
  */
-static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id)
+static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
+			      gpa_t *eaddr)
 {
 	int l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 	u64 indirect_ptr, type = GITS_BASER_TYPE(baser);
@@ -699,6 +700,8 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id)
 		addr = BASER_ADDRESS(baser) + id * esz;
 		gfn = addr >> PAGE_SHIFT;
 
+		if (eaddr)
+			*eaddr = addr;
 		return kvm_is_visible_gfn(its->dev->kvm, gfn);
 	}
 
@@ -731,6 +734,8 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id)
 	indirect_ptr += index * esz;
 	gfn = indirect_ptr >> PAGE_SHIFT;
 
+	if (eaddr)
+		*eaddr = indirect_ptr;
 	return kvm_is_visible_gfn(its->dev->kvm, gfn);
 }
 
@@ -740,7 +745,7 @@ static int vgic_its_alloc_collection(struct vgic_its *its,
 {
 	struct its_collection *collection;
 
-	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id))
+	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
 		return E_ITS_MAPC_COLLECTION_OOR;
 
 	collection = kzalloc(sizeof(*collection), GFP_KERNEL);
@@ -913,7 +918,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
 	struct its_device *device;
 
-	if (!vgic_its_check_id(its, its->baser_device_table, device_id))
+	if (!vgic_its_check_id(its, its->baser_device_table, device_id, NULL))
 		return E_ITS_MAPD_DEVICE_OOR;
 
 	if (valid && num_eventid_bits > VITS_TYPER_IDBITS)
-- 
2.5.5
