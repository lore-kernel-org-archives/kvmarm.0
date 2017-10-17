From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 05/11] KVM: arm/arm64: vgic-its: Check GITS_BASER Valid bit before saving tables
Date: Tue, 17 Oct 2017 09:10:03 +0200
Message-ID: <1508224209-15366-6-git-send-email-eric.auger@redhat.com>
References: <1508224209-15366-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508224209-15366-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com
Cc: wu.wubin@huawei.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

At the moment we don't properly check the GITS_BASER<n>.Valid
bit before saving the collection and device tables.

On vgic_its_save_collection_table() we use the GITS_BASER gpa
field whereas the Valid bit should be used.

On vgic_its_save_device_tables() there is no check. This can
cause various bugs, among which a subsequent fault when accessing
the table in guest memory.

Let's systematically check the Valid bit before doing anything.

We also uniformize the code between save and restore.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

---

v2 -> v3:
- slight rewording of the commit message
- added Andre's and Christoffer's R-b
---
 virt/kvm/arm/vgic/vgic-its.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index e61736b..3b539d4 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -2110,11 +2110,12 @@ static int vgic_its_device_cmp(void *priv, struct list_head *a,
 static int vgic_its_save_device_tables(struct vgic_its *its)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	u64 baser = its->baser_device_table;
 	struct its_device *dev;
 	int dte_esz = abi->dte_esz;
-	u64 baser;
 
-	baser = its->baser_device_table;
+	if (!(baser & GITS_BASER_VALID))
+		return 0;
 
 	list_sort(NULL, &its->device_list, vgic_its_device_cmp);
 
@@ -2285,17 +2286,17 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz,
 static int vgic_its_save_collection_table(struct vgic_its *its)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	u64 baser = its->baser_coll_table;
+	gpa_t gpa = BASER_ADDRESS(baser);
 	struct its_collection *collection;
 	u64 val;
-	gpa_t gpa;
 	size_t max_size, filled = 0;
 	int ret, cte_esz = abi->cte_esz;
 
-	gpa = BASER_ADDRESS(its->baser_coll_table);
-	if (!gpa)
+	if (!(baser & GITS_BASER_VALID))
 		return 0;
 
-	max_size = GITS_BASER_NR_PAGES(its->baser_coll_table) * SZ_64K;
+	max_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 
 	list_for_each_entry(collection, &its->collection_list, coll_list) {
 		ret = vgic_its_save_cte(its, collection, gpa, cte_esz);
@@ -2331,17 +2332,18 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 static int vgic_its_restore_collection_table(struct vgic_its *its)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	u64 baser = its->baser_coll_table;
 	int cte_esz = abi->cte_esz;
 	size_t max_size, read = 0;
 	gpa_t gpa;
 	int ret;
 
-	if (!(its->baser_coll_table & GITS_BASER_VALID))
+	if (!(baser & GITS_BASER_VALID))
 		return 0;
 
-	gpa = BASER_ADDRESS(its->baser_coll_table);
+	gpa = BASER_ADDRESS(baser);
 
-	max_size = GITS_BASER_NR_PAGES(its->baser_coll_table) * SZ_64K;
+	max_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 
 	while (read < max_size) {
 		bool last;
-- 
2.5.5
