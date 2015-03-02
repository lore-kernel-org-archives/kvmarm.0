From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: [PATCH v4 3/5] vfio: type1: replace domain wide protection flags with
 supported capabilities
Date: Mon,  2 Mar 2015 17:58:25 +0100
Message-ID: <1425315507-29661-4-git-send-email-b.reynal@virtualopensystems.com>
References: <1425315507-29661-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C42E4475EC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:53:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EEG2O4YZGjad for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2015 11:53:26 -0500 (EST)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
 [209.85.212.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB767475DF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:53:26 -0500 (EST)
Received: by wiwl15 with SMTP id l15so16423333wiw.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Mar 2015 08:59:23 -0800 (PST)
In-Reply-To: <1425315507-29661-1-git-send-email-b.reynal@virtualopensystems.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: iommu@lists.linux-foundation.org, kvmarm@lists.cs.columbia.edu
Cc: "open list:VFIO DRIVER" <kvm@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, tech@virtualopensystems.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Antonios Motakis <a.motakis@virtualopensystems.com>

VFIO_IOMMU_TYPE1 keeps track for each domain it knows a list of protection
flags it always applies to all mappings in the domain. This is used for
domains that support IOMMU_CAP_CACHE_COHERENCY.

Refactor this slightly, by keeping track instead that a given domain
supports the capability, and applying the IOMMU_CACHE protection flag when
doing the actual DMA mappings.

This will allow us to reuse the behavior for IOMMU_CAP_NOEXEC, which we
also want to keep track of, but without applying it to all domains that
support it unless the user explicitly requests it.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
[Baptiste Reynal: Use bit shifting for domain->caps]
Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>
---
 drivers/vfio/vfio_iommu_type1.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 57d8c37..998619b 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -65,7 +65,7 @@ struct vfio_domain {
 	struct iommu_domain	*domain;
 	struct list_head	next;
 	struct list_head	group_list;
-	int			prot;		/* IOMMU_CACHE */
+	int			caps;
 	bool			fgsp;		/* Fine-grained super pages */
 };
 
@@ -507,7 +507,7 @@ static int map_try_harder(struct vfio_domain *domain, dma_addr_t iova,
 	for (i = 0; i < npage; i++, pfn++, iova += PAGE_SIZE) {
 		ret = iommu_map(domain->domain, iova,
 				(phys_addr_t)pfn << PAGE_SHIFT,
-				PAGE_SIZE, prot | domain->prot);
+				PAGE_SIZE, prot);
 		if (ret)
 			break;
 	}
@@ -525,11 +525,16 @@ static int vfio_iommu_map(struct vfio_iommu *iommu, dma_addr_t iova,
 	int ret;
 
 	list_for_each_entry(d, &iommu->domain_list, next) {
+		int dprot = prot;
+
+		if (d->caps & (1 << IOMMU_CAP_CACHE_COHERENCY))
+			dprot |= IOMMU_CACHE;
+
 		ret = iommu_map(d->domain, iova, (phys_addr_t)pfn << PAGE_SHIFT,
-				npage << PAGE_SHIFT, prot | d->prot);
+				npage << PAGE_SHIFT, dprot);
 		if (ret) {
 			if (ret != -EBUSY ||
-			    map_try_harder(d, iova, pfn, npage, prot))
+			    map_try_harder(d, iova, pfn, npage, dprot))
 				goto unwind;
 		}
 
@@ -644,6 +649,10 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 	struct vfio_domain *d;
 	struct rb_node *n;
 	int ret;
+	int dprot = 0;
+
+	if (domain->caps & (1 << IOMMU_CAP_CACHE_COHERENCY))
+		dprot |= IOMMU_CACHE;
 
 	/* Arbitrarily pick the first domain in the list for lookups */
 	d = list_first_entry(&iommu->domain_list, struct vfio_domain, next);
@@ -677,7 +686,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				size += PAGE_SIZE;
 
 			ret = iommu_map(domain->domain, iova, phys,
-					size, dma->prot | domain->prot);
+					size, dma->prot | dprot);
 			if (ret)
 				return ret;
 
@@ -702,13 +711,17 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain)
 {
 	struct page *pages;
 	int ret, order = get_order(PAGE_SIZE * 2);
+	int dprot = 0;
+
+	if (domain->caps & (1 << IOMMU_CAP_CACHE_COHERENCY))
+		dprot |= IOMMU_CACHE;
 
 	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
 	if (!pages)
 		return;
 
 	ret = iommu_map(domain->domain, 0, page_to_phys(pages), PAGE_SIZE * 2,
-			IOMMU_READ | IOMMU_WRITE | domain->prot);
+			IOMMU_READ | IOMMU_WRITE | dprot);
 	if (!ret) {
 		size_t unmapped = iommu_unmap(domain->domain, 0, PAGE_SIZE);
 
@@ -787,7 +800,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	}
 
 	if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
-		domain->prot |= IOMMU_CACHE;
+		domain->caps |= (1 << IOMMU_CAP_CACHE_COHERENCY);
 
 	/*
 	 * Try to match an existing compatible domain.  We don't want to
@@ -798,7 +811,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	 */
 	list_for_each_entry(d, &iommu->domain_list, next) {
 		if (d->domain->ops == domain->domain->ops &&
-		    d->prot == domain->prot) {
+		    d->caps == domain->caps) {
 			iommu_detach_group(domain->domain, iommu_group);
 			if (!iommu_attach_group(d->domain, iommu_group)) {
 				list_add(&group->next, &d->group_list);
@@ -942,7 +955,7 @@ static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
 
 	mutex_lock(&iommu->lock);
 	list_for_each_entry(domain, &iommu->domain_list, next) {
-		if (!(domain->prot & IOMMU_CACHE)) {
+		if (!(domain->caps & IOMMU_CAP_CACHE_COHERENCY)) {
 			ret = 0;
 			break;
 		}
-- 
2.3.1
