From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v4 01/14] iommu: Add DOMAIN_ATTR_MSI_MAPPING attribute
Date: Fri, 26 Feb 2016 17:35:41 +0000
Message-ID: <1456508154-2253-2-git-send-email-eric.auger@linaro.org>
References: <1456508154-2253-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1ACE411F6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 12:29:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q8GPhVcIbo69 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Feb 2016 12:29:14 -0500 (EST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 08E3A410D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 12:29:13 -0500 (EST)
Received: by mail-wm0-f45.google.com with SMTP id g62so79654334wme.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 09:36:06 -0800 (PST)
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

Introduce new DOMAIN_ATTR_MSI_MAPPING domain attribute. If supported,
this means the MSI addresses need to be mapped in the IOMMU. ARM SMMUS
and FSL PAMU, at least expose this attribute.

x86 IOMMUs typically don't expose the attribute since on x86, MSI write
transaction addresses always are within the 1MB PA region [FEE0_0000h -
FEF0_000h] window which directly targets the APIC configuration space and
hence bypass the sMMU.

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

RFC v1 -> v1:
- the data field is not used
- for this attribute domain_get_attr simply returns 0 if the MSI_MAPPING
  capability if needed or <0 if not.
- removed struct iommu_domain_msi_maps
---
 drivers/iommu/arm-smmu.c        | 2 ++
 drivers/iommu/fsl_pamu_domain.c | 2 ++
 include/linux/iommu.h           | 1 +
 3 files changed, 5 insertions(+)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 59ee4b8..c8b7e71 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1409,6 +1409,8 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
 	case DOMAIN_ATTR_NESTING:
 		*(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
 		return 0;
+	case DOMAIN_ATTR_MSI_MAPPING:
+		return 0;
 	default:
 		return -ENODEV;
 	}
diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index da0e1e3..46d5c6a 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -856,6 +856,8 @@ static int fsl_pamu_get_domain_attr(struct iommu_domain *domain,
 	case DOMAIN_ATTR_FSL_PAMUV1:
 		*(int *)data = DOMAIN_ATTR_FSL_PAMUV1;
 		break;
+	case DOMAIN_ATTR_MSI_MAPPING:
+		break;
 	default:
 		pr_debug("Unsupported attribute type\n");
 		ret = -EINVAL;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index a5c539f..a4fe04a 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -112,6 +112,7 @@ enum iommu_attr {
 	DOMAIN_ATTR_FSL_PAMU_ENABLE,
 	DOMAIN_ATTR_FSL_PAMUV1,
 	DOMAIN_ATTR_NESTING,	/* two stages of translation */
+	DOMAIN_ATTR_MSI_MAPPING, /* Require MSIs mapping in iommu */
 	DOMAIN_ATTR_MAX,
 };
 
-- 
1.9.1
