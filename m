From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 07/15] iommu: iommu_get/put_single_reserved
Date: Thu, 11 Feb 2016 14:34:14 +0000
Message-ID: <1455201262-5259-8-git-send-email-eric.auger@linaro.org>
References: <1455201262-5259-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89F3249B9F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 09:29:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bXwdmxR8s2i5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 09:29:26 -0500 (EST)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B6A549BCB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 09:29:26 -0500 (EST)
Received: by mail-wm0-f46.google.com with SMTP id g62so71548099wme.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 06:35:21 -0800 (PST)
In-Reply-To: <1455201262-5259-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Thomas.Lendacky@amd.com, brijesh.singh@amd.com, patches@linaro.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, leo.duran@amd.com, sherry.hurwitz@amd.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch introduces iommu_get/put_single_reserved.

iommu_get_single_reserved allows to allocate a new reserved iova page
and map it onto the physical page that contains a given physical address.
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

Currently the ref counting is does not really used. All bindings will be
destroyed when the domain is killed.

v1 -> v2:
- previously a VFIO API, named vfio_alloc_map/unmap_free_reserved_iova
---
 drivers/iommu/iommu.c | 21 +++++++++++++++++++++
 include/linux/iommu.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index a994f34..14ebde1 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1415,6 +1415,27 @@ size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
 	return unmapped;
 }
 EXPORT_SYMBOL_GPL(iommu_unmap);
+int iommu_get_single_reserved(struct iommu_domain *domain,
+			      phys_addr_t addr, int prot,
+			      dma_addr_t *iova)
+{
+	if (!domain->ops->get_single_reserved)
+		return  -ENODEV;
+
+	return domain->ops->get_single_reserved(domain, addr, prot, iova);
+
+}
+EXPORT_SYMBOL_GPL(iommu_get_single_reserved);
+
+void iommu_put_single_reserved(struct iommu_domain *domain,
+			       dma_addr_t iova)
+{
+	if (!domain->ops->put_single_reserved)
+		return;
+
+	domain->ops->put_single_reserved(domain, iova);
+}
+EXPORT_SYMBOL_GPL(iommu_put_single_reserved);
 
 size_t default_iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 			 struct scatterlist *sg, unsigned int nents, int prot)
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 32c1a4e..148465b8 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -201,6 +201,21 @@ struct iommu_ops {
 					  unsigned long order);
 	/* frees the reserved iova domain */
 	void (*free_reserved_iova_domain)(struct iommu_domain *domain);
+	/**
+	 * allocate a reserved iova page and bind it onto the page that
+	 * contains a physical address (@addr), returns the @iova bound to
+	 * @addr. In case the 2 pages already are bound simply return @iova
+	 * and increment a ref count.
+	 */
+	int (*get_single_reserved)(struct iommu_domain *domain,
+					 phys_addr_t addr, int prot,
+					 dma_addr_t *iova);
+	/**
+	 * decrement a ref count of the iova page. If null, unmap the iova page
+	 * and release the iova
+	 */
+	void (*put_single_reserved)(struct iommu_domain *domain,
+					   dma_addr_t iova);
 
 #ifdef CONFIG_OF_IOMMU
 	int (*of_xlate)(struct device *dev, struct of_phandle_args *args);
@@ -276,6 +291,11 @@ extern int iommu_alloc_reserved_iova_domain(struct iommu_domain *domain,
 					    dma_addr_t iova, size_t size,
 					    unsigned long order);
 extern void iommu_free_reserved_iova_domain(struct iommu_domain *domain);
+extern int iommu_get_single_reserved(struct iommu_domain *domain,
+				     phys_addr_t paddr, int prot,
+				     dma_addr_t *iova);
+extern void iommu_put_single_reserved(struct iommu_domain *domain,
+				      dma_addr_t iova);
 struct device *iommu_device_create(struct device *parent, void *drvdata,
 				   const struct attribute_group **groups,
 				   const char *fmt, ...) __printf(4, 5);
@@ -562,6 +582,17 @@ static void iommu_free_reserved_iova_domain(struct iommu_domain *domain)
 {
 }
 
+static int iommu_get_single_reserved(struct iommu_domain *domain,
+				     phys_addr_t paddr, int prot,
+				     dma_addr_t *iova)
+{
+	return -EINVAL;
+}
+static void iommu_put_single_reserved(struct iommu_domain *domain,
+				      dma_addr_t iova)
+{
+}
+
 #endif /* CONFIG_IOMMU_API */
 
 #endif /* __LINUX_IOMMU_H */
-- 
1.9.1
