From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 03/10] KVM: arm/arm64: vgic-its: Check CBASER/BASER
 validity before enabling the ITS
Date: Mon, 23 Oct 2017 16:08:22 +0200
Message-ID: <1508767709-15256-4-git-send-email-eric.auger@redhat.com>
References: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5BC349D47
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Oct 2017 10:07:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GoCFtpBCQNZz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Oct 2017 10:07:38 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C8F1849D36
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Oct 2017 10:07:37 -0400 (EDT)
In-Reply-To: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
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

need to be CC'ed stable

v4 -> v5:
- check the condition before updating its->enabled and
  fix its->cbaser && GITS_CBASER_VALID

v3: creation
---
 virt/kvm/arm/vgic/vgic-its.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index b0ba80f..1eb355e 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1466,6 +1466,16 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
 {
 	mutex_lock(&its->cmd_lock);
 
+	/*
+	 * It is UNPREDICTABLE to enable the ITS if any of the CBASER or
+	 * device/collection BASER are invalid
+	 */
+	if (!its->enabled && (val & GITS_CTLR_ENABLE) &&
+		(!(its->baser_device_table & GITS_BASER_VALID) ||
+		 !(its->baser_coll_table & GITS_BASER_VALID) ||
+		 !(its->cbaser & GITS_CBASER_VALID)))
+		goto out;
+
 	its->enabled = !!(val & GITS_CTLR_ENABLE);
 
 	/*
@@ -1474,6 +1484,7 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
 	 */
 	vgic_its_process_commands(kvm, its);
 
+out:
 	mutex_unlock(&its->cmd_lock);
 }
 
-- 
2.5.5
