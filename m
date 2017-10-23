From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 04/10] KVM: arm/arm64: vgic-its: Check GITS_BASER Valid bit
 before saving tables
Date: Mon, 23 Oct 2017 16:08:23 +0200
Message-ID: <1508767709-15256-5-git-send-email-eric.auger@redhat.com>
References: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E87FA49D29
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Oct 2017 10:07:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2zeINcrjJwkB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Oct 2017 10:07:46 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EFF2B49D20
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Oct 2017 10:07:45 -0400 (EDT)
In-Reply-To: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com
Cc: wu.wubin@huawei.com
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

need to be CC'ed stable

v2 -> v3:
- slight rewording of the commit message
- added Andre's and Christoffer's R-b
---
 virt/kvm/arm/vgic/vgic-its.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 1eb355e..b6650c2 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -2071,11 +2071,12 @@ static int vgic_its_device_cmp(void *priv, struct list_head *a,
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
 
@@ -2232,17 +2233,17 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz,
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
@@ -2278,17 +2279,18 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
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
