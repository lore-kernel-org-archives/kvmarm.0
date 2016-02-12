From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v3 08/15] iommu/arm-smmu: implement iommu_get/put_single_reserved
Date: Fri, 12 Feb 2016 08:13:10 +0000
Message-ID: <1455264797-2334-9-git-send-email-eric.auger@linaro.org>
References: <1455264797-2334-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4189049C1A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Feb 2016 03:08:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mG+0vQcMQr8T for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Feb 2016 03:08:22 -0500 (EST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11F7A49C1D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Feb 2016 03:08:22 -0500 (EST)
Received: by mail-wm0-f53.google.com with SMTP id c200so9153930wme.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Feb 2016 00:14:20 -0800 (PST)
In-Reply-To: <1455264797-2334-1-git-send-email-eric.auger@linaro.org>
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

Implement the iommu_get/put_single_reserved API in arm-smmu.

In order to track which physical address is already mapped we
use the RB tree indexed by PA.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v1 -> v2:
- previously in vfio_iommu_type1.c
---
 drivers/iommu/arm-smmu.c | 114 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 729a4c6..9961bfd 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1563,6 +1563,118 @@ static void arm_smmu_free_reserved_iova_domain(struct iommu_domain *domain)
 	mutex_unlock(&smmu_domain->reserved_mutex);
 }
 
+static int arm_smmu_get_single_reserved(struct iommu_domain *domain,
+					phys_addr_t addr, int prot,
+					dma_addr_t *iova)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	unsigned long order = __ffs(domain->ops->pgsize_bitmap);
+	size_t page_size = 1 << order;
+	phys_addr_t mask = page_size - 1;
+	phys_addr_t aligned_addr = addr & ~mask;
+	phys_addr_t offset  = addr - aligned_addr;
+	struct arm_smmu_reserved_binding *b;
+	struct iova *p_iova;
+	struct iova_domain *iovad = smmu_domain->reserved_iova_domain;
+	int ret;
+
+	if (!iovad)
+		return -EINVAL;
+
+	mutex_lock(&smmu_domain->reserved_mutex);
+
+	b = find_reserved_binding(smmu_domain, aligned_addr, page_size);
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
+	ret = arm_smmu_map(domain, *iova, aligned_addr, page_size, prot);
+	if (ret)
+		goto free_binding_iova_unlock;
+
+	kref_init(&b->kref);
+	kref_get(&b->kref);
+	b->domain = smmu_domain;
+	b->addr = aligned_addr;
+	b->iova = *iova;
+	b->size = page_size;
+
+	link_reserved_binding(smmu_domain, b);
+
+	*iova += offset;
+	goto unlock;
+
+free_binding_iova_unlock:
+	kfree(b);
+free_iova_unlock:
+	free_iova(smmu_domain->reserved_iova_domain, *iova >> order);
+unlock:
+	mutex_unlock(&smmu_domain->reserved_mutex);
+	return ret;
+}
+
+/* called with reserved_mutex locked */
+static void reserved_binding_release(struct kref *kref)
+{
+	struct arm_smmu_reserved_binding *b =
+		container_of(kref, struct arm_smmu_reserved_binding, kref);
+	struct arm_smmu_domain *smmu_domain = b->domain;
+	struct iommu_domain *d = &smmu_domain->domain;
+	unsigned long order = __ffs(b->size);
+
+
+	arm_smmu_unmap(d, b->iova, b->size);
+	free_iova(smmu_domain->reserved_iova_domain, b->iova >> order);
+	unlink_reserved_binding(smmu_domain, b);
+	kfree(b);
+}
+
+static void arm_smmu_put_single_reserved(struct iommu_domain *domain,
+					 dma_addr_t iova)
+{
+	unsigned long order;
+	phys_addr_t aligned_addr;
+	dma_addr_t aligned_iova, page_size, mask, offset;
+	struct arm_smmu_reserved_binding *b;
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
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
+	mutex_lock(&smmu_domain->reserved_mutex);
+
+	b = find_reserved_binding(smmu_domain, aligned_addr, page_size);
+	if (!b)
+		goto unlock;
+	kref_put(&b->kref, reserved_binding_release);
+
+unlock:
+	mutex_unlock(&smmu_domain->reserved_mutex);
+}
+
 static struct iommu_ops arm_smmu_ops = {
 	.capable			= arm_smmu_capable,
 	.domain_alloc			= arm_smmu_domain_alloc,
@@ -1580,6 +1692,8 @@ static struct iommu_ops arm_smmu_ops = {
 	.domain_set_attr		= arm_smmu_domain_set_attr,
 	.alloc_reserved_iova_domain	= arm_smmu_alloc_reserved_iova_domain,
 	.free_reserved_iova_domain	= arm_smmu_free_reserved_iova_domain,
+	.get_single_reserved		= arm_smmu_get_single_reserved,
+	.put_single_reserved		= arm_smmu_put_single_reserved,
 	/* Page size bitmap, restricted during device attach */
 	.pgsize_bitmap			= -1UL,
 };
-- 
1.9.1
