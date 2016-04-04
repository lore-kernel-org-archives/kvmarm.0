From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v6 1/7] iommu: Add DOMAIN_ATTR_MSI_MAPPING attribute
Date: Mon,  4 Apr 2016 08:06:56 +0000
Message-ID: <1459757222-2668-2-git-send-email-eric.auger@linaro.org>
References: <1459757222-2668-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36330407A0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:06:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mwio7YegX8SN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 04:05:59 -0400 (EDT)
Received: from mail-qg0-f41.google.com (mail-qg0-f41.google.com
 [209.85.192.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2620940B40
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:05:58 -0400 (EDT)
Received: by mail-qg0-f41.google.com with SMTP id y89so142673002qge.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2016 01:07:14 -0700 (PDT)
In-Reply-To: <1459757222-2668-1-git-send-email-eric.auger@linaro.org>
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

Introduce a new DOMAIN_ATTR_MSI_MAPPING domain attribute. If supported,
this means the MSI addresses need to be mapped in the IOMMU.

x86 IOMMUs typically don't expose the attribute since on x86, MSI write
transaction addresses always are within the 1MB PA region [FEE0_0000h -
FEF0_000h] window which directly targets the APIC configuration space and
hence bypass the sMMU. On ARM and PowerPC however MSI transactions are
conveyed through the IOMMU.

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v4 -> v5:
- introduce the user in the next patch

RFC v1 -> v1:
- the data field is not used
- for this attribute domain_get_attr simply returns 0 if the MSI_MAPPING
  capability if needed or <0 if not.
- removed struct iommu_domain_msi_maps
---
 include/linux/iommu.h | 1 +
 1 file changed, 1 insertion(+)

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
