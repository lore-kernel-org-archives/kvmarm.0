From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v4 05/14] dma-reserved-iommu: iommu_get/put_single_reserved
Date: Fri, 26 Feb 2016 17:35:45 +0000
Message-ID: <1456508154-2253-6-git-send-email-eric.auger@linaro.org>
References: <1456508154-2253-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAEF6410D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 12:29:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uV71cDa-Bgh7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Feb 2016 12:29:24 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E6304968B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 12:29:24 -0500 (EST)
Received: by mail-wm0-f41.google.com with SMTP id c200so82105390wme.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 09:36:16 -0800 (PST)
In-Reply-To: <1456508154-2253-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch introduces iommu_get/put_single_reserved.

iommu_get_single_reserved allows to allocate a new reserved iova page
and map it onto the physical page that contains a given physical address.
Page size is the IOMMU page one. It is the responsability of the
system integrator to make sure the in use IOMMU page size corresponds
to the granularity of the MSI frame.

It returns the iova that is mapped onto the provided physical address.
Hence the physical address passed in argument does not need to be aligned.

In case a mapping already exists between both pages, the IOVA mapped
to the PA is directly returned.

Each time an iova is successfully returned a binding ref count is
incremented.

iommu_put_single_reserved decrements the ref count and when this latter
is null, the mapping is destroyed and the iova is released.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Ankit Jindal <ajindal@apm.com>
Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>

---

v3 -> v4:
- formerly in iommu: iommu_get/put_single_reserved &
  iommu/arm-smmu: implement iommu_get/put_single_reserved
- Attempted to address Marc's doubts about missing size/alignment
  at VFIO level (user-space knows the IOMMU page size and the number
  of IOVA pages to provision)

v2 -> v3:
- remove static implementation of iommu_get_single_reserved &
  iommu_put_single_reserved when CONFIG_IOMMU_API is not set

v1 -> v2:
- previously a VFIO API, named vfio_alloc_map/unmap_free_reserved_iova
---
 drivers/iommu/dma-reserved-iommu.c | 115 +++++++++++++++++++++++++++++++++++++
 include/linux/dma-reserved-iommu.h |  26 +++++++++
 2 files changed, 141 insertions(+)

diff --git a/drivers/iommu/dma-reserved-iommu.c b/drivers/iommu/dma-reserved-iommu.c
index 30d54d0..537c83e 100644
--- a/drivers/iommu/dma-reserved-iommu.c
+++ b/drivers/iommu/dma-reserved-iommu.c
@@ -132,3 +132,118 @@ void iommu_free_reserved_iova_domain(struct iommu_domain *domain)
 	mutex_unlock(&domain->reserved_mutex);
 }
 EXPORT_SYMBOL_GPL(iommu_free_reserved_iova_domain);
+
+int iommu_get_single_reserved(struct iommu_domain *domain,
+			      phys_addr_t addr, int prot,
+			      dma_addr_t *iova)
+{
+	unsigned long order = __ffs(domain->ops->pgsize_bitmap);
+	size_t page_size = 1 << order;
+	phys_addr_t mask = page_size - 1;
+	phys_addr_t aligned_addr = addr & ~mask;
+	phys_addr_t offset  = addr - aligned_addr;
+	struct iommu_reserved_binding *b;
+	struct iova *p_iova;
+	struct iova_domain *iovad =
+		(struct iova_domain *)domain->reserved_iova_cookie;
+	int ret;
+
+	if (!iovad)
+		return -EINVAL;
+
+	mutex_lock(&domain->reserved_mutex);
+
+	b = find_reserved_binding(domain, aligned_addr, page_size);
+	if (b) {
+		*iova = b->iova + offset;
+		kref_get(&b->kref);
+		ret = 0;
+		goto unlock;
+	}
+
+	/* there is no existing reserved iova for this pa */
+	p_iova = alloc_iova(iovad, 1, iovad->dma_32bit_pfn, true);
+	if (!p_iova) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+	*iova = p_iova->pfn_lo << order;
+
+	b = kzalloc(sizeof(*b), GFP_KERNEL);
+	if (!b) {
+		ret = -ENOMEM;
+		goto free_iova_unlock;
+	}
+
+	ret = iommu_map(domain, *iova, aligned_addr, page_size, prot);
+	if (ret)
+		goto free_binding_iova_unlock;
+
+	kref_init(&b->kref);
+	kref_get(&b->kref);
+	b->domain = domain;
+	b->addr = aligned_addr;
+	b->iova = *iova;
+	b->size = page_size;
+
+	link_reserved_binding(domain, b);
+
+	*iova += offset;
+	goto unlock;
+
+free_binding_iova_unlock:
+	kfree(b);
+free_iova_unlock:
+	free_iova(iovad, *iova >> order);
+unlock:
+	mutex_unlock(&domain->reserved_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_get_single_reserved);
+
+/* called with reserved_mutex locked */
+static void reserved_binding_release(struct kref *kref)
+{
+	struct iommu_reserved_binding *b =
+		container_of(kref, struct iommu_reserved_binding, kref);
+	struct iommu_domain *d = b->domain;
+	struct iova_domain *iovad =
+		(struct iova_domain *)d->reserved_iova_cookie;
+	unsigned long order = __ffs(b->size);
+
+	iommu_unmap(d, b->iova, b->size);
+	free_iova(iovad, b->iova >> order);
+	unlink_reserved_binding(d, b);
+	kfree(b);
+}
+
+void iommu_put_single_reserved(struct iommu_domain *domain, dma_addr_t iova)
+{
+	unsigned long order;
+	phys_addr_t aligned_addr;
+	dma_addr_t aligned_iova, page_size, mask, offset;
+	struct iommu_reserved_binding *b;
+
+	order = __ffs(domain->ops->pgsize_bitmap);
+	page_size = (uint64_t)1 << order;
+	mask = page_size - 1;
+
+	aligned_iova = iova & ~mask;
+	offset = iova - aligned_iova;
+
+	aligned_addr = iommu_iova_to_phys(domain, aligned_iova);
+
+	mutex_lock(&domain->reserved_mutex);
+
+	b = find_reserved_binding(domain, aligned_addr, page_size);
+	if (!b)
+		goto unlock;
+	kref_put(&b->kref, reserved_binding_release);
+
+unlock:
+	mutex_unlock(&domain->reserved_mutex);
+}
+EXPORT_SYMBOL_GPL(iommu_put_single_reserved);
+
+
+
diff --git a/include/linux/dma-reserved-iommu.h b/include/linux/dma-reserved-iommu.h
index 5bf863b..71ec800 100644
--- a/include/linux/dma-reserved-iommu.h
+++ b/include/linux/dma-reserved-iommu.h
@@ -40,6 +40,32 @@ int iommu_alloc_reserved_iova_domain(struct iommu_domain *domain,
  */
 void iommu_free_reserved_iova_domain(struct iommu_domain *domain);
 
+/**
+ * iommu_get_single_reserved: allocate a reserved iova page and bind
+ * it onto the page that contains a physical address (@addr)
+ *
+ * @domain: iommu domain handle
+ * @addr: physical address to bind
+ * @prot: mapping protection attribute
+ * @iova: returned iova
+ *
+ * In case the 2 pages already are bound simply return @iova and
+ * increment a ref count
+ */
+int iommu_get_single_reserved(struct iommu_domain *domain,
+			      phys_addr_t addr, int prot,
+			      dma_addr_t *iova);
+
+/**
+ * iommu_put_single_reserved: decrement a ref count of the iova page
+ *
+ * @domain: iommu domain handle
+ * @iova: iova whose binding ref count is decremented
+ *
+ * if the binding ref count is null, unmap the iova page and release the iova
+ */
+void iommu_put_single_reserved(struct iommu_domain *domain, dma_addr_t iova);
+
 #endif	/* CONFIG_IOMMU_DMA_RESERVED */
 #endif	/* __KERNEL__ */
 #endif	/* __DMA_RESERVED_IOMMU_H */
-- 
1.9.1
