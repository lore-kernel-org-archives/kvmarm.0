From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 14/15] iommu/arm-smmu: do not advertise IOMMU_CAP_INTR_REMAP
Date: Thu, 11 Feb 2016 14:34:21 +0000
Message-ID: <1455201262-5259-15-git-send-email-eric.auger@linaro.org>
References: <1455201262-5259-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A07E49A0C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 09:29:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6UjA2Vzrt2qA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 09:29:54 -0500 (EST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B415749BB9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 09:29:54 -0500 (EST)
Received: by mail-wm0-f50.google.com with SMTP id p63so71019874wmp.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 06:35:50 -0800 (PST)
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

Do not advertise IOMMU_CAP_INTR_REMAP for arm-smmu. Indeed the
irq_remapping capability is abstracted on irqchip side for ARM as
opposed to Intel IOMMU featuring IRQ remapping HW.

So to check IRQ remmapping capability, the msi domain needs to be
checked instead.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/iommu/arm-smmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index ae8a97d..9a83285 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1354,7 +1354,7 @@ static bool arm_smmu_capable(enum iommu_cap cap)
 		 */
 		return true;
 	case IOMMU_CAP_INTR_REMAP:
-		return true; /* MSIs are just memory writes */
+		return false; /* MSIs are just memory writes */
 	case IOMMU_CAP_NOEXEC:
 		return true;
 	default:
-- 
1.9.1
