Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B3A6C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 03:02:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1CD53207F5
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 03:02:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CD53207F5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F30AC4B56A;
	Wed,  1 Jul 2020 23:02:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xr+45tvLxUL2; Wed,  1 Jul 2020 23:02:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08DC14B592;
	Wed,  1 Jul 2020 23:02:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08F144B569
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jul 2020 23:02:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qh6aCcxs2L1x for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Jul 2020 23:02:36 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2B3F4B56F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jul 2020 23:02:35 -0400 (EDT)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 7B081F3A8EDE9A469324;
 Thu,  2 Jul 2020 11:02:30 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.42) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Jul 2020 11:02:21 +0800
From: Jingyi Wang <wangjingyi11@huawei.com>
To: <drjones@redhat.com>, <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
Subject: [kvm-unit-tests PATCH v2 3/8] arm64: microbench: gic: Add gicv4.1
 support for ipi latency test.
Date: Thu, 2 Jul 2020 11:01:27 +0800
Message-ID: <20200702030132.20252-4-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
In-Reply-To: <20200702030132.20252-1-wangjingyi11@huawei.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.187.42]
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

If gicv4.1(sgi hardware injection) supported, we test ipi injection
via hw/sw way separately.

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arm/micro-bench.c    | 45 +++++++++++++++++++++++++++++++++++++++-----
 lib/arm/asm/gic-v3.h |  3 +++
 lib/arm/asm/gic.h    |  1 +
 3 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index fc4d356..80d8db3 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -91,9 +91,40 @@ static void gic_prep_common(void)
 	assert(irq_ready);
 }
 
-static void ipi_prep(void)
+static bool ipi_prep(void)
 {
+	u32 val;
+
+	val = readl(vgic_dist_base + GICD_CTLR);
+	if (readl(vgic_dist_base + GICD_TYPER2) & GICD_TYPER2_nASSGIcap) {
+		val &= ~GICD_CTLR_ENABLE_G1A;
+		val &= ~GICD_CTLR_nASSGIreq;
+		writel(val, vgic_dist_base + GICD_CTLR);
+		val |= GICD_CTLR_ENABLE_G1A;
+		writel(val, vgic_dist_base + GICD_CTLR);
+	}
+
 	gic_prep_common();
+	return true;
+}
+
+static bool ipi_hw_prep(void)
+{
+	u32 val;
+
+	val = readl(vgic_dist_base + GICD_CTLR);
+	if (readl(vgic_dist_base + GICD_TYPER2) & GICD_TYPER2_nASSGIcap) {
+		val &= ~GICD_CTLR_ENABLE_G1A;
+		val |= GICD_CTLR_nASSGIreq;
+		writel(val, vgic_dist_base + GICD_CTLR);
+		val |= GICD_CTLR_ENABLE_G1A;
+		writel(val, vgic_dist_base + GICD_CTLR);
+	} else {
+		return false;
+	}
+
+	gic_prep_common();
+	return true;
 }
 
 static void ipi_exec(void)
@@ -147,7 +178,7 @@ static void eoi_exec(void)
 
 struct exit_test {
 	const char *name;
-	void (*prep)(void);
+	bool (*prep)(void);
 	void (*exec)(void);
 	bool run;
 };
@@ -158,6 +189,7 @@ static struct exit_test tests[] = {
 	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	true},
 	{"eoi",			NULL,		eoi_exec,		true},
 	{"ipi",			ipi_prep,	ipi_exec,		true},
+	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		true},
 };
 
 struct ns_time {
@@ -181,9 +213,12 @@ static void loop_test(struct exit_test *test)
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
