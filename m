Return-Path: <SRS0=D0fm=3I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E719C33CB1
	for <kvmarm@archiver.kernel.org>; Sun, 19 Jan 2020 13:32:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A5CED20663
	for <kvmarm@archiver.kernel.org>; Sun, 19 Jan 2020 13:32:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5CED20663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFCBF4AEB3;
	Sun, 19 Jan 2020 08:32:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ux7mLXMINdx8; Sun, 19 Jan 2020 08:32:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B26484ACFA;
	Sun, 19 Jan 2020 08:32:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 997BA4ACFA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jan 2020 08:32:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E5w4vXv+UKpW for <kvmarm@lists.cs.columbia.edu>;
 Sun, 19 Jan 2020 08:32:31 -0500 (EST)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2B964ACE6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jan 2020 08:32:30 -0500 (EST)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 0BB7FE69CDB940A01276;
 Sun, 19 Jan 2020 21:32:27 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.173.222.27) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Sun, 19 Jan 2020 21:32:17 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <peter.maydell@linaro.org>, <qemu-arm@nongnu.org>, <qemu-devel@nongnu.org>
Subject: [PATCH] hw/intc/arm_gicv3_kvm: Stop wrongly programming
 GICR_PENDBASER.PTZ bit
Date: Sun, 19 Jan 2020 21:30:51 +0800
Message-ID: <20200119133051.642-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

If LPIs are disabled, KVM will just ignore the GICR_PENDBASER.PTZ bit when
restoring GICR_CTLR.  Setting PTZ here makes littlt sense in "reduce GIC
initialization time".

And what's worse, PTZ is generally programmed by guest to indicate to the
Redistributor whether the LPI Pending table is zero when enabling LPIs.
If migration is triggered when the PTZ has just been cleared by guest (and
before enabling LPIs), we will see PTZ==1 on the destination side, which
is not as expected.  Let's just drop this hackish userspace behavior.

Also take this chance to refine the comment a bit.

Fixes: 367b9f527bec ("hw/intc/arm_gicv3_kvm: Implement get/put functions")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 hw/intc/arm_gicv3_kvm.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/hw/intc/arm_gicv3_kvm.c b/hw/intc/arm_gicv3_kvm.c
index 9c7f4ab871..49304ca589 100644
--- a/hw/intc/arm_gicv3_kvm.c
+++ b/hw/intc/arm_gicv3_kvm.c
@@ -336,7 +336,10 @@ static void kvm_arm_gicv3_put(GICv3State *s)
     kvm_gicd_access(s, GICD_CTLR, &reg, true);
 
     if (redist_typer & GICR_TYPER_PLPIS) {
-        /* Set base addresses before LPIs are enabled by GICR_CTLR write */
+        /*
+         * Restore base addresses before LPIs are potentially enabled by
+         * GICR_CTLR write
+         */
         for (ncpu = 0; ncpu < s->num_cpu; ncpu++) {
             GICv3CPUState *c = &s->cpu[ncpu];
 
@@ -347,12 +350,6 @@ static void kvm_arm_gicv3_put(GICv3State *s)
             kvm_gicr_access(s, GICR_PROPBASER + 4, ncpu, &regh, true);
 
             reg64 = c->gicr_pendbaser;
-            if (!(c->gicr_ctlr & GICR_CTLR_ENABLE_LPIS)) {
-                /* Setting PTZ is advised if LPIs are disabled, to reduce
-                 * GIC initialization time.
-                 */
-                reg64 |= GICR_PENDBASER_PTZ;
-            }
             regl = (uint32_t)reg64;
             kvm_gicr_access(s, GICR_PENDBASER, ncpu, &regl, true);
             regh = (uint32_t)(reg64 >> 32);
-- 
2.19.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
