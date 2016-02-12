From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v3 09/15] iommu/arm-smmu: relinquish reserved resources on
 domain deletion
Date: Fri, 12 Feb 2016 08:13:11 +0000
Message-ID: <1455264797-2334-10-git-send-email-eric.auger@linaro.org>
References: <1455264797-2334-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36EE549C20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Feb 2016 03:08:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5hvk0fS4byXE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Feb 2016 03:08:24 -0500 (EST)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 476DD49C1D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Feb 2016 03:08:24 -0500 (EST)
Received: by mail-wm0-f54.google.com with SMTP id g62so52008521wme.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Feb 2016 00:14:22 -0800 (PST)
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

arm_smmu_unmap_reserved releases all reserved binding resources:
destroy all bindings, free iova, free iova_domain. This happens
on domain deletion.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/iommu/arm-smmu.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 9961bfd..ae8a97d 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -363,6 +363,7 @@ struct arm_smmu_reserved_binding {
 	dma_addr_t		iova;
 	size_t			size;
 };
+static void arm_smmu_unmap_reserved(struct iommu_domain *domain);
 
 static struct iommu_ops arm_smmu_ops;
 
@@ -1057,6 +1058,7 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 	 * already been detached.
 	 */
 	arm_smmu_destroy_domain_context(domain);
+	arm_smmu_unmap_reserved(domain);
 	kfree(smmu_domain);
 }
 
@@ -1547,19 +1549,23 @@ unlock:
 	return ret;
 }
 
-static void arm_smmu_free_reserved_iova_domain(struct iommu_domain *domain)
+static void __arm_smmu_free_reserved_iova_domain(struct arm_smmu_domain *sd)
 {
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	struct iova_domain *iovad = smmu_domain->reserved_iova_domain;
+	struct iova_domain *iovad = sd->reserved_iova_domain;
 
 	if (!iovad)
 		return;
 
-	mutex_lock(&smmu_domain->reserved_mutex);
-
 	put_iova_domain(iovad);
 	kfree(iovad);
+}
 
+static void arm_smmu_free_reserved_iova_domain(struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+
+	mutex_lock(&smmu_domain->reserved_mutex);
+	__arm_smmu_free_reserved_iova_domain(smmu_domain);
 	mutex_unlock(&smmu_domain->reserved_mutex);
 }
 
@@ -1675,6 +1681,24 @@ unlock:
 	mutex_unlock(&smmu_domain->reserved_mutex);
 }
 
+static void arm_smmu_unmap_reserved(struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct rb_node *node;
+
+	mutex_lock(&smmu_domain->reserved_mutex);
+	while ((node = rb_first(&smmu_domain->reserved_binding_list))) {
+		struct arm_smmu_reserved_binding *b =
+			rb_entry(node, struct arm_smmu_reserved_binding, node);
+
+		while (!kref_put(&b->kref, reserved_binding_release))
+			;
+	}
+	smmu_domain->reserved_binding_list = RB_ROOT;
+	__arm_smmu_free_reserved_iova_domain(smmu_domain);
+	mutex_unlock(&smmu_domain->reserved_mutex);
+}
+
 static struct iommu_ops arm_smmu_ops = {
 	.capable			= arm_smmu_capable,
 	.domain_alloc			= arm_smmu_domain_alloc,
-- 
1.9.1
