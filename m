From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 8/8] KVM: arm/arm64: vgic-its: Check GITS_BASER Valid bit
 before saving tables
Date: Mon, 30 Oct 2017 03:56:03 +0100
Message-ID: <20171030025603.23550-9-christoffer.dall@linaro.org>
References: <20171030025603.23550-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51C4F49D6F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 22:54:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xP9SA-V0gCBW for <kvmarm@lists.cs.columbia.edu>;
 Sun, 29 Oct 2017 22:54:49 -0400 (EDT)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC7F049D6A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 22:54:48 -0400 (EDT)
Received: by mail-wm0-f68.google.com with SMTP id r196so13472039wmf.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 19:56:21 -0700 (PDT)
In-Reply-To: <20171030025603.23550-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

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
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index e69ef7d27fde..547f12dc4d54 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -2067,11 +2067,12 @@ static int vgic_its_device_cmp(void *priv, struct list_head *a,
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
 
@@ -2215,17 +2216,17 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
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
@@ -2256,17 +2257,18 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
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
 		ret = vgic_its_restore_cte(its, gpa, cte_esz);
-- 
2.14.2
