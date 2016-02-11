From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC v2 09/15] iommu/arm-smmu: relinquish reserved resources on
	domain deletion
Date: Thu, 11 Feb 2016 14:34:16 +0000
Message-ID: <1455201262-5259-10-git-send-email-eric.auger@linaro.org>
References: <1455201262-5259-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1455201262-5259-1-git-send-email-eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: eric.auger-qxv4g6HH51o@public.gmane.org, eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Thomas.Lendacky-5C7GfCeVMHo@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sherry.hurwitz-5C7GfCeVMHo@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

arm_smmu_unmap_reserved releases all reserved binding resources:
destroy all bindings, free iova, free iova_domain. This happens
on domain deletion.

Signed-off-by: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
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
