From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v6 4/5] iommu/arm-smmu: do not advertise IOMMU_CAP_INTR_REMAP
Date: Mon,  4 Apr 2016 08:30:10 +0000
Message-ID: <1459758611-2972-5-git-send-email-eric.auger@linaro.org>
References: <1459758611-2972-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3502F40B58
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:29:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qxqCTmexSxpO for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 04:29:18 -0400 (EDT)
Received: from mail-lf0-f54.google.com (mail-lf0-f54.google.com
 [209.85.215.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49962407A5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:29:18 -0400 (EDT)
Received: by mail-lf0-f54.google.com with SMTP id c126so39272807lfb.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2016 01:30:33 -0700 (PDT)
In-Reply-To: <1459758611-2972-1-git-send-email-eric.auger@linaro.org>
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

Do not advertise IOMMU_CAP_INTR_REMAP for arm-smmu. Indeed the
irq_remapping capability is abstracted on irqchip side for ARM as
opposed to Intel IOMMU featuring IRQ remapping HW.

So to check IRQ remapping capability, the msi domain needs to be
checked instead.

This commit needs to be applied after "vfio/type1: also check IRQ
remapping capability at msi domain" else the legacy interrupt
assignment gets broken with arm-smmu.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/iommu/arm-smmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 6562752..83d5200 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1304,7 +1304,7 @@ static bool arm_smmu_capable(enum iommu_cap cap)
 		 */
 		return true;
 	case IOMMU_CAP_INTR_REMAP:
-		return true; /* MSIs are just memory writes */
+		return false; /* interrupt translation handled at MSI controller level */
 	case IOMMU_CAP_NOEXEC:
 		return true;
 	default:
-- 
1.9.1
