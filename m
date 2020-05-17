Return-Path: <SRS0=26+9=67=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E7BC433E4
	for <kvmarm@archiver.kernel.org>; Sun, 17 May 2020 10:11:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D8CB4207FB
	for <kvmarm@archiver.kernel.org>; Sun, 17 May 2020 10:11:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8CB4207FB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 929BB4B0F5;
	Sun, 17 May 2020 06:11:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ruT14AY0EW1H; Sun, 17 May 2020 06:11:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5CD44B114;
	Sun, 17 May 2020 06:11:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 880F94B0F5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 May 2020 06:11:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mjgysBxjZqJs for <kvmarm@lists.cs.columbia.edu>;
 Sun, 17 May 2020 06:11:27 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 75C594B0FA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 May 2020 06:11:27 -0400 (EDT)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 085EB41220321354A7B0;
 Sun, 17 May 2020 18:11:24 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.173.222.58) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Sun, 17 May 2020 18:11:14 +0800
From: Jingyi Wang <wangjingyi11@huawei.com>
To: <drjones@redhat.com>, <kvm@vger.kernel.org>,
 <kvmarm@lists.cs.columbia.edu>, <wangjingyi11@huawei.com>
Subject: [kvm-unit-tests PATCH 2/6] arm64: microbench: Use the funcions for
 ipi test as the general functions for gic(ipi/lpi/timer) test.
Date: Sun, 17 May 2020 18:08:56 +0800
Message-ID: <20200517100900.30792-3-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
In-Reply-To: <20200517100900.30792-1-wangjingyi11@huawei.com>
References: <20200517100900.30792-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.173.222.58]
X-CFilter-Loop: Reflected
Cc: maz@kernel.org
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

The following patches will use that.

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arm/micro-bench.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index ca022d9..fc4d356 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -25,24 +25,24 @@
 
 static u32 cntfrq;
 
-static volatile bool ipi_ready, ipi_received;
+static volatile bool irq_ready, irq_received;
 static void *vgic_dist_base;
 static void (*write_eoir)(u32 irqstat);
 
-static void ipi_irq_handler(struct pt_regs *regs)
+static void gic_irq_handler(struct pt_regs *regs)
 {
-	ipi_ready = false;
-	ipi_received = true;
+	irq_ready = false;
+	irq_received = true;
 	gic_write_eoir(gic_read_iar());
-	ipi_ready = true;
+	irq_ready = true;
 }
 
-static void ipi_secondary_entry(void *data)
+static void gic_secondary_entry(void *data)
 {
-	install_irq_handler(EL1H_IRQ, ipi_irq_handler);
+	install_irq_handler(EL1H_IRQ, gic_irq_handler);
 	gic_enable_defaults();
 	local_irq_enable();
-	ipi_ready = true;
+	irq_ready = true;
 	while (true)
 		cpu_relax();
 }
@@ -72,9 +72,9 @@ static bool test_init(void)
 		break;
 	}
 
-	ipi_ready = false;
+	irq_ready = false;
 	gic_enable_defaults();
-	on_cpu_async(1, ipi_secondary_entry, NULL);
+	on_cpu_async(1, gic_secondary_entry, NULL);
 
 	cntfrq = get_cntfrq();
 	printf("Timer Frequency %d Hz (Output in microseconds)\n", cntfrq);
@@ -82,13 +82,18 @@ static bool test_init(void)
 	return true;
 }
 
-static void ipi_prep(void)
+static void gic_prep_common(void)
 {
 	unsigned tries = 1 << 28;
 
-	while (!ipi_ready && tries--)
+	while (!irq_ready && tries--)
 		cpu_relax();
-	assert(ipi_ready);
+	assert(irq_ready);
+}
+
+static void ipi_prep(void)
+{
+	gic_prep_common();
 }
 
 static void ipi_exec(void)
@@ -96,17 +101,17 @@ static void ipi_exec(void)
 	unsigned tries = 1 << 28;
 	static int received = 0;
 
-	ipi_received = false;
+	irq_received = false;
 
 	gic_ipi_send_single(1, 1);
 
-	while (!ipi_received && tries--)
+	while (!irq_received && tries--)
 		cpu_relax();
 
-	if (ipi_recieved)
+	if (irq_received)
 		++received;
 
-	assert_msg(ipi_received, "failed to receive IPI in time, but received %d successfully\n", received);
+	assert_msg(irq_received, "failed to receive IPI in time, but received %d successfully\n", received);
 }
 
 static void hvc_exec(void)
-- 
2.19.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
