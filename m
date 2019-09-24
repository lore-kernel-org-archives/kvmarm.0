Return-Path: <SRS0=oENQ=XT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE6FC432C2
	for <kvmarm@archiver.kernel.org>; Tue, 24 Sep 2019 15:23:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5FF07214DA
	for <kvmarm@archiver.kernel.org>; Tue, 24 Sep 2019 15:23:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FF07214DA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18EC14A6D0;
	Tue, 24 Sep 2019 11:23:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JIvFfXRaaM4C; Tue, 24 Sep 2019 11:23:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC3B54A681;
	Tue, 24 Sep 2019 11:23:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80AD44A66F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 11:23:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S86PFoBzTHOG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Sep 2019 11:23:31 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 77B084A67B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 11:23:30 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 5EA36BE9A1306E7B3A53;
 Tue, 24 Sep 2019 23:23:27 +0800 (CST)
Received: from linux-Bxxcye.huawei.com (10.175.104.222) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Tue, 24 Sep 2019 23:23:17 +0800
From: Heyi Guo <guoheyi@huawei.com>
To: <qemu-arm@nongnu.org>, <qemu-devel@nongnu.org>,
 <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>
Subject: [RFC PATCH 05/12] arm/sdei: add support to trigger event by GIC
 interrupt ID
Date: Tue, 24 Sep 2019 23:21:44 +0800
Message-ID: <1569338511-3572-6-git-send-email-guoheyi@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569338511-3572-1-git-send-email-guoheyi@huawei.com>
References: <1569338511-3572-1-git-send-email-guoheyi@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.175.104.222]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <marc.zyngier@arm.com>, Heyi Guo <guoheyi@huawei.com>,
 Dave Martin <Dave.Martin@arm.com>
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

Add an external interface to trigger an SDEI event bound to an
interrupt by providing GIC interrupt ID.

Signed-off-by: Heyi Guo <guoheyi@huawei.com>
Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
---
 target/arm/sdei.c | 38 ++++++++++++++++++++++++++++++++++++++
 target/arm/sdei.h |  7 +++++++
 2 files changed, 45 insertions(+)

diff --git a/target/arm/sdei.c b/target/arm/sdei.c
index f9a1208..088ed76 100644
--- a/target/arm/sdei.c
+++ b/target/arm/sdei.c
@@ -453,6 +453,29 @@ static int64_t sdei_version(QemuSDEState *s, CPUState *cs, struct kvm_run *run)
            (0ULL << SDEI_VERSION_MINOR_SHIFT);
 }
 
+static bool inject_event(QemuSDEState *s, CPUState *cs,
+                             int32_t event, int irq)
+{
+    QemuSDE *sde;
+
+    if (event < 0) {
+        return false;
+    }
+    sde = get_sde_no_check(s, event, cs);
+    if (sde->event_id == SDEI_INVALID_EVENT_ID) {
+        put_sde(sde, cs);
+        return false;
+    }
+    if (irq > 0 && sde->prop->interrupt != irq) {
+        /* Someone unbinds the interrupt! */
+        put_sde(sde, cs);
+        return false;
+    }
+    sde->pending = true;
+    dispatch_single(s, sde, cs);
+    return true;
+}
+
 static int64_t unregister_single_sde(QemuSDEState *s, int32_t event,
                                      CPUState *cs, bool force)
 {
@@ -1033,6 +1056,21 @@ void sdei_handle_request(CPUState *cs, struct kvm_run *run)
     }
 }
 
+bool trigger_sdei_by_irq(int cpu, int irq)
+{
+    QemuSDEState *s = sde_state;
+
+    if (!s || irq >= ARRAY_SIZE(s->irq_map)) {
+        return false;
+    }
+
+    if (s->irq_map[irq] == SDEI_INVALID_EVENT_ID) {
+        return false;
+    }
+
+    return inject_event(s, arm_get_cpu_by_id(cpu), s->irq_map[irq], irq);
+}
+
 static void qemu_shared_sde_init(QemuSDEState *s)
 {
     int i;
diff --git a/target/arm/sdei.h b/target/arm/sdei.h
index a69a0e4..a61e788 100644
--- a/target/arm/sdei.h
+++ b/target/arm/sdei.h
@@ -31,4 +31,11 @@
 
 void sdei_handle_request(CPUState *cs, struct kvm_run *run);
 
+/*
+ * Trigger an SDEI event bound to an interrupt.
+ * Return true if event has been triggered successfully.
+ * Return false if event has not been triggered for some reason.
+ */
+bool trigger_sdei_by_irq(int cpu, int irq);
+
 #endif
-- 
1.8.3.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
