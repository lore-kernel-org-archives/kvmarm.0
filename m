From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 04/11] KVM: arm/arm64: vgic-its: Check CBASER/BASER
 validity before enabling the ITS
Date: Tue, 17 Oct 2017 09:10:02 +0200
Message-ID: <1508224209-15366-5-git-send-email-eric.auger@redhat.com>
References: <1508224209-15366-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEB2240795
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 03:09:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6ZpdBtb-43Du for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 03:09:47 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2076849D54
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 03:09:47 -0400 (EDT)
In-Reply-To: <1508224209-15366-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com
Cc: wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

The spec says it is UNPREDICTABLE to enable the ITS
if any of the following conditions are true:

- GITS_CBASER.Valid == 0.
- GITS_BASER<n>.Valid == 0, for any GITS_BASER<n> register
  where the Type field indicates Device.
- GITS_BASER<n>.Valid == 0, for any GITS_BASER<n> register
  where the Type field indicates Interrupt Collection and
  GITS_TYPER.HCC == 0.

In that case, let's keep the ITS disabled.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reported-by: Andre Przywara <andre.przywara@arm.com>

---

v3: creation
---
 virt/kvm/arm/vgic/vgic-its.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index e59363e..e61736b 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1488,6 +1488,16 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
 	its->enabled = !!(val & GITS_CTLR_ENABLE);
 
 	/*
+	 * It is UNPREDICTABLE to enable the ITS if any of the CBASER or
+	 * device/collection BASER are invalid
+	 */
+	if (its->enabled &&
+		(!(its->baser_device_table & GITS_BASER_VALID) ||
+		 !(its->baser_coll_table & GITS_BASER_VALID) ||
+		 !(its->cbaser && GITS_CBASER_VALID)))
+		its->enabled = false;
+
+	/*
 	 * Try to process any pending commands. This function bails out early
 	 * if the ITS is disabled or no commands have been queued.
 	 */
-- 
2.5.5
