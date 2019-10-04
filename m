Return-Path: <SRS0=I38I=X5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C49E6C4360C
	for <kvmarm@archiver.kernel.org>; Fri,  4 Oct 2019 14:18:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 847F421D81
	for <kvmarm@archiver.kernel.org>; Fri,  4 Oct 2019 14:18:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 847F421D81
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B96A4A656;
	Fri,  4 Oct 2019 10:18:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lltN02x43drV; Fri,  4 Oct 2019 10:18:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 169BD4A695;
	Fri,  4 Oct 2019 10:18:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 169F14A689
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Oct 2019 10:18:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T6CjBypCH-od for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Oct 2019 10:18:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D14BA4A66E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Oct 2019 10:18:40 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 859B615AD;
 Fri,  4 Oct 2019 07:18:40 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8C433F68E;
 Fri,  4 Oct 2019 07:18:39 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v2 2/6] arm: gic: Split variable output data
 from test name
Date: Fri,  4 Oct 2019 15:18:25 +0100
Message-Id: <20191004141829.87135-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191004141829.87135-1-andre.przywara@arm.com>
References: <20191004141829.87135-1-andre.przywara@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

For some tests we mix variable diagnostic output with the test name,
which leads to variable test line, confusing some higher level
frameworks.

Split the output to always use the same test name for a certain test,
and put diagnostic output on a separate line using the INFO: tag.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 2ec4070..02d2928 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -353,8 +353,8 @@ static void test_typer_v2(uint32_t reg)
 {
 	int nr_gic_cpus = ((reg >> 5) & 0x7) + 1;
 
-	report("all %d CPUs have interrupts", nr_cpus == nr_gic_cpus,
-	       nr_gic_cpus);
+	report_info("nr_cpus=%d", nr_cpus);
+	report("all CPUs have interrupts", nr_cpus == nr_gic_cpus);
 }
 
 #define BYTE(reg32, byte) (((reg32) >> ((byte) * 8)) & 0xff)
@@ -370,16 +370,21 @@ static void test_typer_v2(uint32_t reg)
 static void test_byte_access(void *base_addr, u32 pattern, u32 mask)
 {
 	u32 reg = readb(base_addr + 1);
+	bool res;
 
-	report("byte reads successful (0x%08x => 0x%02x)",
-	       reg == (BYTE(pattern, 1) & (mask >> 8)),
-	       pattern & mask, reg);
+	res = (reg == (BYTE(pattern, 1) & (mask >> 8)));
+	report("byte reads successful", res);
+	if (!res)
+		report_info("byte 1 of 0x%08x => 0x%02x", pattern & mask, reg);
 
 	pattern = REPLACE_BYTE(pattern, 2, 0x1f);
 	writeb(BYTE(pattern, 2), base_addr + 2);
 	reg = readl(base_addr);
-	report("byte writes successful (0x%02x => 0x%08x)",
-	       reg == (pattern & mask), BYTE(pattern, 2), reg);
+	res = (reg == (pattern & mask));
+	report("byte writes successful", res);
+	if (!res)
+		report_info("writing 0x%02x into bytes 2 => 0x%08x",
+			    BYTE(pattern, 2), reg);
 }
 
 static void test_priorities(int nr_irqs, void *priptr)
@@ -399,15 +404,16 @@ static void test_priorities(int nr_irqs, void *priptr)
 	pri_mask = readl(first_spi);
 
 	reg = ~pri_mask;
-	report("consistent priority masking (0x%08x)",
+	report("consistent priority masking",
 	       (((reg >> 16) == (reg & 0xffff)) &&
-	        ((reg & 0xff) == ((reg >> 8) & 0xff))), pri_mask);
+	        ((reg & 0xff) == ((reg >> 8) & 0xff))));
+	report_info("priority mask is 0x%08x", pri_mask);
 
 	reg = reg & 0xff;
 	for (pri_bits = 8; reg & 1; reg >>= 1, pri_bits--)
 		;
-	report("implements at least 4 priority bits (%d)",
-	       pri_bits >= 4, pri_bits);
+	report("implements at least 4 priority bits", pri_bits >= 4);
+	report_info("%d priority bits implemented", pri_bits);
 
 	pattern = 0;
 	writel(pattern, first_spi);
@@ -452,9 +458,9 @@ static void test_targets(int nr_irqs)
 	/* Check that bits for non implemented CPUs are RAZ/WI. */
 	if (nr_cpus < 8) {
 		writel(0xffffffff, targetsptr + GIC_FIRST_SPI);
-		report("bits for %d non-existent CPUs masked",
-		       !(readl(targetsptr + GIC_FIRST_SPI) & ~cpu_mask),
-		       8 - nr_cpus);
+		report("bits for non-existent CPUs masked",
+		       !(readl(targetsptr + GIC_FIRST_SPI) & ~cpu_mask));
+		report_info("%d non-existent CPUs", 8 - nr_cpus);
 	} else {
 		report_skip("CPU masking (all CPUs implemented)");
 	}
@@ -465,8 +471,10 @@ static void test_targets(int nr_irqs)
 	pattern = 0x0103020f;
 	writel(pattern, targetsptr + GIC_FIRST_SPI);
 	reg = readl(targetsptr + GIC_FIRST_SPI);
-	report("register content preserved (%08x => %08x)",
-	       reg == (pattern & cpu_mask), pattern & cpu_mask, reg);
+	report("register content preserved", reg == (pattern & cpu_mask));
+	if (reg != (pattern & cpu_mask))
+		report_info("writing %08x reads back as %08x",
+			    pattern & cpu_mask, reg);
 
 	/* The TARGETS registers are byte accessible. */
 	test_byte_access(targetsptr + GIC_FIRST_SPI, pattern, cpu_mask);
@@ -505,9 +513,8 @@ static void gic_test_mmio(void)
 	       test_readonly_32(gic_dist_base + GICD_IIDR, false));
 
 	reg = readl(idreg);
-	report("ICPIDR2 is read-only (0x%08x)",
-	       test_readonly_32(idreg, false),
-	       reg);
+	report("ICPIDR2 is read-only", test_readonly_32(idreg, false));
+	report_info("value of ICPIDR2: 0x%08x", reg);
 
 	test_priorities(nr_irqs, gic_dist_base + GICD_IPRIORITYR);
 
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
