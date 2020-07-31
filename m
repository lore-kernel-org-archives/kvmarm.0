Return-Path: <SRS0=F5E6=BK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D45DAC433E3
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 07:43:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 93AAB20829
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 07:43:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93AAB20829
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 311084B334;
	Fri, 31 Jul 2020 03:43:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BZ6BirUFHMwW; Fri, 31 Jul 2020 03:43:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C31654B4EA;
	Fri, 31 Jul 2020 03:43:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71EB14B388
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 03:43:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b1gWv7bpQsEb for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jul 2020 03:43:49 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A21984B36E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 03:43:46 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id BA0EE64F97D95F17C648;
 Fri, 31 Jul 2020 15:43:36 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.42) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Fri, 31 Jul 2020 15:43:28 +0800
From: Jingyi Wang <wangjingyi11@huawei.com>
To: <drjones@redhat.com>, <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
Subject: [kvm-unit-tests PATCH v3 08/10] arm64: microbench: Add vtimer latency
 test
Date: Fri, 31 Jul 2020 15:42:42 +0800
Message-ID: <20200731074244.20432-9-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
In-Reply-To: <20200731074244.20432-1-wangjingyi11@huawei.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Cc: maz@kernel.org, prime.zeng@hisilicon.com
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

Trigger PPIs by setting up a 10msec timer and test the latency.

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arm/micro-bench.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 09d9d53..1e1bde5 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -21,8 +21,10 @@
 #include <libcflat.h>
 #include <asm/gic.h>
 #include <asm/gic-v3-its.h>
+#include <asm/timer.h>
 
 #define NS_5_SECONDS (5 * 1000 * 1000 * 1000UL)
+
 static u32 cntfrq;
 
 static volatile bool irq_ready, irq_received;
@@ -33,9 +35,16 @@ static void (*write_eoir)(u32 irqstat);
 
 static void gic_irq_handler(struct pt_regs *regs)
 {
+	u32 irqstat = gic_read_iar();
 	irq_ready = false;
 	irq_received = true;
-	gic_write_eoir(gic_read_iar());
+	gic_write_eoir(irqstat);
+
+	if (irqstat == PPI(TIMER_VTIMER_IRQ)) {
+		write_sysreg((ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE),
+			     cntv_ctl_el0);
+		isb();
+	}
 	irq_ready = true;
 }
 
@@ -198,6 +207,47 @@ static void lpi_exec(void)
 	assert_msg(irq_received, "failed to receive LPI in time, but received %d successfully\n", received);
 }
 
+static bool timer_prep(void)
+{
+	static void *gic_isenabler;
+
+	gic_enable_defaults();
+	install_irq_handler(EL1H_IRQ, gic_irq_handler);
+	local_irq_enable();
+
+	gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
+	writel(1 << PPI(TIMER_VTIMER_IRQ), gic_isenabler);
+	write_sysreg(ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
+	isb();
+
+	gic_prep_common();
+	return true;
+}
+
+static void timer_exec(void)
+{
+	u64 before_timer;
+	u64 timer_10ms;
+	unsigned tries = 1 << 28;
+	static int received = 0;
+
+	irq_received = false;
+
+	before_timer = read_sysreg(cntvct_el0);
+	timer_10ms = cntfrq / 100;
+	write_sysreg(before_timer + timer_10ms, cntv_cval_el0);
+	write_sysreg(ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
+	isb();
+
+	while (!irq_received && tries--)
+		cpu_relax();
+
+	if (irq_received)
+		++received;
+
+	assert_msg(irq_received, "failed to receive PPI in time, but received %d successfully\n", received);
+}
+
 static void hvc_exec(void)
 {
 	asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
@@ -245,6 +295,7 @@ static struct exit_test tests[] = {
 	{"ipi",			ipi_prep,	ipi_exec,		65536,		true},
 	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		65536,		true},
 	{"lpi",			lpi_prep,	lpi_exec,		65536,		true},
+	{"timer_10ms",		timer_prep,	timer_exec,		256,		true},
 };
 
 struct ns_time {
-- 
2.19.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
