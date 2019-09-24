Return-Path: <SRS0=oENQ=XT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2ED6C4360C
	for <kvmarm@archiver.kernel.org>; Tue, 24 Sep 2019 15:23:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B596A20665
	for <kvmarm@archiver.kernel.org>; Tue, 24 Sep 2019 15:23:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B596A20665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 422CB4A6CC;
	Tue, 24 Sep 2019 11:23:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s1dqDLpPlZhd; Tue, 24 Sep 2019 11:23:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E41304A6E5;
	Tue, 24 Sep 2019 11:23:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F3044A6BC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 11:23:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p6zmkFdVNVoT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Sep 2019 11:23:40 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1DE4D4A66F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 11:23:36 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 72028C8DBC18647CE88C;
 Tue, 24 Sep 2019 23:23:27 +0800 (CST)
Received: from linux-Bxxcye.huawei.com (10.175.104.222) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Tue, 24 Sep 2019 23:23:19 +0800
From: Heyi Guo <guoheyi@huawei.com>
To: <qemu-arm@nongnu.org>, <qemu-devel@nongnu.org>,
 <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>
Subject: [RFC PATCH 08/12] arm/sdei: add support to register interrupt bind
 notifier
Date: Tue, 24 Sep 2019 23:21:47 +0800
Message-ID: <1569338511-3572-9-git-send-email-guoheyi@huawei.com>
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

Other qemu modules related with the interrupt bind operation may want
to be notified when guest requests to bind interrupt to sdei event, so
we add register and unregister interfaces.

Signed-off-by: Heyi Guo <guoheyi@huawei.com>
Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
---
 target/arm/sdei.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 target/arm/sdei.h | 17 +++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/target/arm/sdei.c b/target/arm/sdei.c
index 9ceb131..efdb681 100644
--- a/target/arm/sdei.c
+++ b/target/arm/sdei.c
@@ -45,6 +45,52 @@
 
 static QemuSDEState *sde_state;
 
+typedef struct QemuSDEIBindNotifyEntry {
+    QTAILQ_ENTRY(QemuSDEIBindNotifyEntry) entry;
+    QemuSDEIBindNotify *func;
+    void *opaque;
+    int irq;
+} QemuSDEIBindNotifyEntry;
+
+static QTAILQ_HEAD(, QemuSDEIBindNotifyEntry) bind_notifiers =
+    QTAILQ_HEAD_INITIALIZER(bind_notifiers);
+
+void qemu_register_sdei_bind_notifier(QemuSDEIBindNotify *func,
+                                      void *opaque, int irq)
+{
+    QemuSDEIBindNotifyEntry *be = g_new0(QemuSDEIBindNotifyEntry, 1);
+
+    be->func = func;
+    be->opaque = opaque;
+    be->irq = irq;
+    QTAILQ_INSERT_TAIL(&bind_notifiers, be, entry);
+}
+
+void qemu_unregister_sdei_bind_notifier(QemuSDEIBindNotify *func,
+                                        void *opaque, int irq)
+{
+    QemuSDEIBindNotifyEntry *be;
+
+    QTAILQ_FOREACH(be, &bind_notifiers, entry) {
+        if (be->func == func && be->opaque == opaque && be->irq == irq) {
+            QTAILQ_REMOVE(&bind_notifiers, be, entry);
+            g_free(be);
+            return;
+        }
+    }
+}
+
+static void sdei_notify_bind(int irq, int32_t event, bool bind)
+{
+    QemuSDEIBindNotifyEntry *be, *nbe;
+
+    QTAILQ_FOREACH_SAFE(be, &bind_notifiers, entry, nbe) {
+        if (be->irq == irq) {
+            be->func(be->opaque, irq, event, bind);
+        }
+    }
+}
+
 static void qemu_sde_prop_init(QemuSDEState *s)
 {
     QemuSDEProp *sde_props = s->sde_props_state;
@@ -502,6 +548,7 @@ static int32_t sdei_alloc_event_num(QemuSDEState *s, bool is_critical,
             sde_props[index].interrupt = intid;
             sde_props[index].is_shared = is_shared;
             sde_props[index].is_critical = is_critical;
+            sdei_notify_bind(intid, event, true);
             override_qemu_irq(s, event, intid);
             s->irq_map[intid] = event;
             qemu_mutex_unlock(&sde_props[index].lock);
@@ -522,6 +569,7 @@ static int32_t sdei_free_event_num_locked(QemuSDEState *s, QemuSDEProp *prop)
         goto unlock_return;
     }
 
+    sdei_notify_bind(prop->interrupt, prop->event_id, false);
     restore_qemu_irq(s, prop->event_id, prop->interrupt);
     s->irq_map[prop->interrupt] = SDEI_INVALID_EVENT_ID;
     prop->event_id = SDEI_INVALID_EVENT_ID;
@@ -1331,6 +1379,7 @@ static int qemu_sdei_post_load(void *opaque, int version_id)
         int intid = sde_props[i].interrupt;
         if (intid != SDEI_INVALID_INTERRUPT) {
             s->irq_map[intid] = sde_props[i].event_id;
+            sdei_notify_bind(intid, sde_props[i].event_id, true);
             override_qemu_irq(s, sde_props[i].event_id, intid);
         }
     }
diff --git a/target/arm/sdei.h b/target/arm/sdei.h
index a61e788..feaaf1a 100644
--- a/target/arm/sdei.h
+++ b/target/arm/sdei.h
@@ -38,4 +38,21 @@ void sdei_handle_request(CPUState *cs, struct kvm_run *run);
  */
 bool trigger_sdei_by_irq(int cpu, int irq);
 
+/*
+ * Notify callback prototype; the argument "bind" tells whether it is a bind
+ * operation or unbind one.
+ */
+typedef void QemuSDEIBindNotify(void *opaque, int irq,
+                                int32_t event, bool bind);
+/*
+ * Register a notify callback for a specific interrupt bind operation; the
+ * client be both notified by bind and unbind operation.
+ */
+void qemu_register_sdei_bind_notifier(QemuSDEIBindNotify *func,
+                                      void *opaque, int irq);
+/*
+ * Unregister a notify callback for a specific interrupt bind operation.
+ */
+void qemu_unregister_sdei_bind_notifier(QemuSDEIBindNotify *func,
+                                        void *opaque, int irq);
 #endif
-- 
1.8.3.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
