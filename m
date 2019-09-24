Return-Path: <SRS0=oENQ=XT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 900F5C432C2
	for <kvmarm@archiver.kernel.org>; Tue, 24 Sep 2019 15:23:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 500C2217D9
	for <kvmarm@archiver.kernel.org>; Tue, 24 Sep 2019 15:23:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 500C2217D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E20D84A68F;
	Tue, 24 Sep 2019 11:23:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QqqZzfUT05ks; Tue, 24 Sep 2019 11:23:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5D1E4A6C2;
	Tue, 24 Sep 2019 11:23:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 567DD4A64A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 11:23:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8Vj76D8APqjk for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Sep 2019 11:23:40 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D0B74A650
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 11:23:37 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 6C35B257579530C63335;
 Tue, 24 Sep 2019 23:23:27 +0800 (CST)
Received: from linux-Bxxcye.huawei.com (10.175.104.222) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Tue, 24 Sep 2019 23:23:21 +0800
From: Heyi Guo <guoheyi@huawei.com>
To: <qemu-arm@nongnu.org>, <qemu-devel@nongnu.org>,
 <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>
Subject: [RFC PATCH 10/12] arm/sdei: check KVM cap and enable SDEI
Date: Tue, 24 Sep 2019 23:21:49 +0800
Message-ID: <1569338511-3572-11-git-send-email-guoheyi@huawei.com>
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

Check KVM hypercall forward capability and enable it, and set global
flag "sdei_enabled" to true if everything works well.

Signed-off-by: Heyi Guo <guoheyi@huawei.com>
Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
---
 target/arm/sdei.c | 17 +++++++++++++++++
 target/arm/sdei.h |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/target/arm/sdei.c b/target/arm/sdei.c
index efdb681..000545e 100644
--- a/target/arm/sdei.c
+++ b/target/arm/sdei.c
@@ -43,6 +43,7 @@
 #define TYPE_QEMU_SDEI "qemu_sdei"
 #define QEMU_SDEI(obj) OBJECT_CHECK(QemuSDEState, (obj), TYPE_QEMU_SDEI)
 
+bool sdei_enabled;
 static QemuSDEState *sde_state;
 
 typedef struct QemuSDEIBindNotifyEntry {
@@ -1465,6 +1466,7 @@ static const VMStateDescription vmstate_sde_state = {
 static void sdei_initfn(Object *obj)
 {
     QemuSDEState *s = QEMU_SDEI(obj);
+    KVMState *kvm = KVM_STATE(current_machine->accelerator);
 
     if (sde_state) {
         error_report("Only one SDEI dispatcher is allowed!");
@@ -1474,6 +1476,21 @@ static void sdei_initfn(Object *obj)
 
     qemu_sde_init(s);
     qemu_register_reset(qemu_sde_reset, s);
+
+    if (kvm_check_extension(kvm, KVM_CAP_FORWARD_HYPERCALL)) {
+        int ret;
+        ret = kvm_vm_enable_cap(kvm, KVM_CAP_FORWARD_HYPERCALL, 0,
+                                KVM_CAP_FORWARD_HYPERCALL_EXCL_PSCI);
+        if (ret < 0) {
+            error_report("Enable hypercall forwarding failed: %s",
+                         strerror(-ret));
+            abort();
+        }
+        sdei_enabled = true;
+        info_report("qemu sdei enabled");
+    } else {
+        info_report("KVM does not support forwarding hypercall.");
+    }
 }
 
 static void qemu_sde_class_init(ObjectClass *klass, void *data)
diff --git a/target/arm/sdei.h b/target/arm/sdei.h
index feaaf1a..95e7d8d 100644
--- a/target/arm/sdei.h
+++ b/target/arm/sdei.h
@@ -29,6 +29,8 @@
 
 #define SDEI_MAX_REQ        SDEI_1_0_FN(0x12)
 
+extern bool sdei_enabled;
+
 void sdei_handle_request(CPUState *cs, struct kvm_run *run);
 
 /*
-- 
1.8.3.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
