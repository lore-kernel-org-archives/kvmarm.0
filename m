From: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v11 7/8] iommu/arm-smmu: do not advertise IOMMU_CAP_INTR_REMAP
Date: Tue, 19 Jul 2016 13:11:33 +0000
Message-ID: <1468933894-23250-8-git-send-email-eric.auger@redhat.com>
References: <1468933894-23250-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1468933894-23250-1-git-send-email-eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, andre.przywara-5wv7dgnIgG8@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: drjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, robert.richter-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, yehuday-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Do not advertise IOMMU_CAP_INTR_REMAP for arm-smmu(-v3). Indeed the
irq_remapping capability is abstracted on irqchip side for ARM as
opposed to Intel IOMMU featuring IRQ remapping HW.

So to check IRQ remapping capability, the msi domain needs to be
checked instead.

This commit affects platform and PCIe device assignment use cases
on any platform featuring an unsafe MSI controller (currently the
ARM GICv2m). For those platforms the VFIO module must be loaded with
allow_unsafe_interrupts set to 1.

Signed-off-by: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---

v9 -> v10:
- reword the commit message (allow_unsafe_interrupts)
---
 drivers/iommu/arm-smmu-v3.c | 3 ++-
 drivers/iommu/arm-smmu.c    | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 960d377..a011eba 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -1387,7 +1387,8 @@ static bool arm_smmu_capable(enum iommu_cap cap)
 	case IOMMU_CAP_CACHE_COHERENCY:
 		return true;
 	case IOMMU_CAP_INTR_REMAP:
-		return true; /* MSIs are just memory writes */
+		/* interrupt translation handled at MSI controller level */
+		return false;
 	case IOMMU_CAP_NOEXEC:
 		return true;
 	default:
diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 867910b..b03a89b 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1380,7 +1380,8 @@ static bool arm_smmu_capable(enum iommu_cap cap)
 		 */
 		return true;
 	case IOMMU_CAP_INTR_REMAP:
-		return true; /* MSIs are just memory writes */
+		/* interrupt translation handled at MSI controller level */
+		return false;
 	case IOMMU_CAP_NOEXEC:
 		return true;
 	default:
-- 
1.9.1
