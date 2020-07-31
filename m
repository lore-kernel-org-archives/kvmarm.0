Return-Path: <SRS0=F5E6=BK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 231F1C433E3
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 07:43:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D61802067D
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 07:43:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D61802067D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 905A64B4D1;
	Fri, 31 Jul 2020 03:43:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NZxpuouUF-PM; Fri, 31 Jul 2020 03:43:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C0B54B4D7;
	Fri, 31 Jul 2020 03:43:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEB4C4B37C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 03:43:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i0icTRSGPeJg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jul 2020 03:43:36 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C4924B378
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 03:43:36 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id B6649BDBE9EA21171F6C;
 Fri, 31 Jul 2020 15:43:31 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.42) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Fri, 31 Jul 2020 15:43:24 +0800
From: Jingyi Wang <wangjingyi11@huawei.com>
To: <drjones@redhat.com>, <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
Subject: [kvm-unit-tests PATCH v3 03/10] arm64: microbench: gic: Add ipi
 latency test for gicv4.1 support kvm
Date: Fri, 31 Jul 2020 15:42:37 +0800
Message-ID: <20200731074244.20432-4-wangjingyi11@huawei.com>
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

If gicv4.1(sgi hardware injection) is supported in kvm, we test ipi
injection via hw/sw way separately.

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arm/micro-bench.c    | 62 ++++++++++++++++++++++++++++++++++++++------
 lib/arm/asm/gic-v3.h |  3 +++
 lib/arm/asm/gic.h    |  1 +
 3 files changed, 58 insertions(+), 8 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index fc4d356..f8314db 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -26,6 +26,8 @@
 static u32 cntfrq;
 
 static volatile bool irq_ready, irq_received;
+static int nr_ipi_received;
+
 static void *vgic_dist_base;
 static void (*write_eoir)(u32 irqstat);
 
@@ -91,15 +93,55 @@ static void gic_prep_common(void)
 	assert(irq_ready);
 }
 
-static void ipi_prep(void)
+static bool ipi_prep(void)
+{
+	u32 val;
+
+	val = readl(vgic_dist_base + GICD_CTLR);
+	if (readl(vgic_dist_base + GICD_TYPER2) & GICD_TYPER2_nASSGIcap) {
+		/* nASSGIreq can be changed only when GICD is disabled */
+		val &= ~GICD_CTLR_ENABLE_G1A;
+		val &= ~GICD_CTLR_nASSGIreq;
+		writel(val, vgic_dist_base + GICD_CTLR);
+		gicv3_dist_wait_for_rwp();
+
+		val |= GICD_CTLR_ENABLE_G1A;
+		writel(val, vgic_dist_base + GICD_CTLR);
+		gicv3_dist_wait_for_rwp();
+	}
+
+	nr_ipi_received = 0;
+	gic_prep_common();
+	return true;
+}
+
+static bool ipi_hw_prep(void)
 {
+	u32 val;
+
+	val = readl(vgic_dist_base + GICD_CTLR);
+	if (readl(vgic_dist_base + GICD_TYPER2) & GICD_TYPER2_nASSGIcap) {
+		/* nASSGIreq can be changed only when GICD is disabled */
+		val &= ~GICD_CTLR_ENABLE_G1A;
+		val |= GICD_CTLR_nASSGIreq;
+		writel(val, vgic_dist_base + GICD_CTLR);
+		gicv3_dist_wait_for_rwp();
+
+		val |= GICD_CTLR_ENABLE_G1A;
+		writel(val, vgic_dist_base + GICD_CTLR);
+		gicv3_dist_wait_for_rwp();
+	} else {
+		return false;
+	}
+
+	nr_ipi_received = 0;
 	gic_prep_common();
+	return true;
 }
 
 static void ipi_exec(void)
 {
 	unsigned tries = 1 << 28;
-	static int received = 0;
 
 	irq_received = false;
 
@@ -109,9 +151,9 @@ static void ipi_exec(void)
 		cpu_relax();
 
 	if (irq_received)
-		++received;
+		++nr_ipi_received;
 
-	assert_msg(irq_received, "failed to receive IPI in time, but received %d successfully\n", received);
+	assert_msg(irq_received, "failed to receive IPI in time, but received %d successfully\n", nr_ipi_received);
 }
 
 static void hvc_exec(void)
@@ -147,7 +189,7 @@ static void eoi_exec(void)
 
 struct exit_test {
 	const char *name;
-	void (*prep)(void);
+	bool (*prep)(void);
 	void (*exec)(void);
 	bool run;
 };
@@ -158,6 +200,7 @@ static struct exit_test tests[] = {
 	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	true},
 	{"eoi",			NULL,		eoi_exec,		true},
 	{"ipi",			ipi_prep,	ipi_exec,		true},
+	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		true},
 };
 
 struct ns_time {
@@ -181,9 +224,12 @@ static void loop_test(struct exit_test *test)
 	uint64_t start, end, total_ticks, ntimes = NTIMES;
 	struct ns_time total_ns, avg_ns;
 
-	if (test->prep)
-		test->prep();
-
+	if (test->prep) {
+		if(!test->prep()) {
+			printf("%s test skipped\n", test->name);
+			return;
+		}
+	}
 	isb();
 	start = read_sysreg(cntpct_el0);
 	while (ntimes--)
diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index cb72922..b4ce130 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -20,10 +20,13 @@
  */
 #define GICD_CTLR			0x0000
 #define GICD_CTLR_RWP			(1U << 31)
+#define GICD_CTLR_nASSGIreq		(1U << 8)
 #define GICD_CTLR_ARE_NS		(1U << 4)
 #define GICD_CTLR_ENABLE_G1A		(1U << 1)
 #define GICD_CTLR_ENABLE_G1		(1U << 0)
 
+#define GICD_TYPER2_nASSGIcap		(1U << 8)
+
 /* Re-Distributor registers, offsets from RD_base */
 #define GICR_TYPER			0x0008
 
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 38e79b2..1898400 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -13,6 +13,7 @@
 #define GICD_CTLR			0x0000
 #define GICD_TYPER			0x0004
 #define GICD_IIDR			0x0008
+#define GICD_TYPER2			0x000C
 #define GICD_IGROUPR			0x0080
 #define GICD_ISENABLER			0x0100
 #define GICD_ICENABLER			0x0180
-- 
2.19.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
