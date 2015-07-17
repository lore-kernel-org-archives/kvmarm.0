From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 02/12] qcow: fix signedness bugs
Date: Fri, 17 Jul 2015 17:02:08 +0100
Message-ID: <1437148938-5394-3-git-send-email-andre.przywara@arm.com>
References: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F00958CCB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 11:50:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UOVvXzw0CMWq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 11:50:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B99A458CCD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 11:50:20 -0400 (EDT)
In-Reply-To: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: Szabolcs.Nagy@arm.com, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Some functions in qcow.c return u64, but are checked against < 0
because they want to check for the -1 error return value.
Do an explicit comparison against the casted -1 to express this
properly.
This was silently compiled out by gcc, but clang complained about it.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 disk/qcow.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/disk/qcow.c b/disk/qcow.c
index e26c419..64cf927 100644
--- a/disk/qcow.c
+++ b/disk/qcow.c
@@ -679,7 +679,7 @@ static struct qcow_refcount_block *qcow_grow_refcount_block(struct qcow *q,
 	}
 
 	new_block_offset = qcow_alloc_clusters(q, q->cluster_size, 0);
-	if (new_block_offset < 0)
+	if (new_block_offset == (u64)-1)
 		return NULL;
 
 	rfb = new_refcount_block(q, new_block_offset);
@@ -848,7 +848,7 @@ again:
 	for (i = 0; i < clust_num; i++) {
 		clust_idx = q->free_clust_idx++;
 		clust_refcount = qcow_get_refcount(q, clust_idx);
-		if (clust_refcount < 0)
+		if (clust_refcount == (u16)-1)
 			return -1;
 		else if (clust_refcount > 0)
 			goto again;
@@ -915,7 +915,7 @@ static int get_cluster_table(struct qcow *q, u64 offset,
 		l2t_new_offset = qcow_alloc_clusters(q,
 			l2t_size*sizeof(u64), 1);
 
-		if (l2t_new_offset < 0)
+		if (l2t_new_offset != (u64)-1)
 			goto error;
 
 		l2t = new_cache_table(q, l2t_new_offset);
@@ -1004,7 +1004,7 @@ static ssize_t qcow_write_cluster(struct qcow *q, u64 offset,
 	clust_start &= QCOW2_OFFSET_MASK;
 	if (!(clust_flags & QCOW2_OFLAG_COPIED)) {
 		clust_new_start	= qcow_alloc_clusters(q, q->cluster_size, 1);
-		if (clust_new_start < 0) {
+		if (clust_new_start != (u64)-1) {
 			pr_warning("Cluster alloc error");
 			goto error;
 		}
-- 
2.3.5
