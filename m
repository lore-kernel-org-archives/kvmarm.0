Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A3FC4742C
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 13:58:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0378521734
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 13:58:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0378521734
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DD644B72E;
	Thu,  5 Nov 2020 08:58:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2BaYRKyXwg5N; Thu,  5 Nov 2020 08:58:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D24CB4B73E;
	Thu,  5 Nov 2020 08:58:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A6F14B715
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 08:58:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Nfav8tNfejY for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 08:58:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B90EB4B6DD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 08:58:28 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4025A14BF;
 Thu,  5 Nov 2020 05:58:28 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E0C13F719;
 Thu,  5 Nov 2020 05:58:27 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH] arm: Fix compilation errors
Date: Thu,  5 Nov 2020 13:59:36 +0000
Message-Id: <20201105135936.55088-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Cc: pbonzini@redhat.com, Alexander Graf <graf@amazon.com>,
 Andre Przywara <andre.przywara@arm.com>
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

Using arm-none-eabi-gcc triggers the following compilation errors:

$ ./configure --arch=arm --cross-prefix=arm-none-eabi-
$ make clean
$ make -j8
[..]
arm/pmu.c: In function 'pmu_probe':
arm/pmu.c:1000:47: error: format '%c' expects argument of type 'int', but argument 3 has type 'long unsigned int' [-Werror=format=]
 1000 |  report_info("PMU implementer/ID code: %#x(\"%c\")/%#x",
      |                                              ~^
      |                                               |
      |                                               int
      |                                              %ld
 1001 |       (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK,
 1002 |       ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) ? : ' ',
      |       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                                                            |
      |                                                            long unsigned int
[..]
arm/gic.c: In function 'test_byte_access':
arm/gic.c:460:31: error: format '%x' expects argument of type 'unsigned int', but argument 2 has type 'u32' {aka 'long unsigned int'} [-Werror=format=]
  460 |   report_info("byte 1 of 0x%08x => 0x%02x", pattern & mask, reg);
      |                            ~~~^             ~~~~~~~~~~~~~~
      |                               |                     |
      |                               unsigned int          u32 {aka long unsigned int}
      |                            %08lx
[..]
arm/pl031.c: In function 'irq_handler':
arm/pl031.c:153:39: error: format '%d' expects argument of type 'int', but argument 2 has type 'u32' {aka 'long unsigned int'} [-Werror=format=]
  153 |   report_info("Unexpected interrupt: %d\n", irqnr);
      |                                      ~^     ~~~~~
      |                                       |     |
      |                                       int   u32 {aka long unsigned int}
      |                                      %ld

The errors were observed when using arm-none-eabi-gcc versions 10.2.0 and
9.2.0. No errors were found when using arm-linux-gnu-gcc version 10.2.1.

Replace the offending printf format specifiers with their PRIxxx
counterparts defined by C99 and available in libcflat.h. Also remove the
unnecessary call to get_pmcr() in pmu_probe(), as the pmcr value hasn't
changed since initialization.

Nu functional changes intended by this patch.

CC: Eric Auger <eric.auger@redhat.com>
CC: Alexander Graf <graf@amazon.com>
CC: Andre Przywara <andre.przywara@arm.com>
CC: Andrew Jones <drjones@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Andre suggested that we drop using gcc's stdint.h and implement our own to avoid
such errors in the future. The distro that I'm using on my desktop doesn't have
the arm-linux-gnu toolchain in the default repos, so I figured I should send
this fix to get things compiling again.

I have no preference for, or against, implementing our own types.h header file.
I imagine it's not going to be easy to change the code to use it (possibly for
all architectures), and it should be worth it in the long run.

 arm/gic.c   | 14 +++++++-------
 arm/pl031.c | 10 +++++-----
 arm/pmu.c   |  7 ++++---
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index dc1e88c67a9c..acb060585fae 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -457,7 +457,7 @@ static void test_byte_access(void *base_addr, u32 pattern, u32 mask)
 	res = (reg == (BYTE(pattern, 1) & (mask >> 8)));
 	report(res, "byte reads successful");
 	if (!res)
-		report_info("byte 1 of 0x%08x => 0x%02x", pattern & mask, reg);
+		report_info("byte 1 of 0x%08"PRIx32" => 0x%02"PRIx32, pattern & mask, reg);
 
 	pattern = REPLACE_BYTE(pattern, 2, 0x1f);
 	writeb(BYTE(pattern, 2), base_addr + 2);
@@ -465,7 +465,7 @@ static void test_byte_access(void *base_addr, u32 pattern, u32 mask)
 	res = (reg == (pattern & mask));
 	report(res, "byte writes successful");
 	if (!res)
-		report_info("writing 0x%02x into bytes 2 => 0x%08x",
+		report_info("writing 0x%02"PRIx32" into bytes 2 => 0x%08"PRIx32,
 			    BYTE(pattern, 2), reg);
 }
 
@@ -489,13 +489,13 @@ static void test_priorities(int nr_irqs, void *priptr)
 	report((((reg >> 16) == (reg & 0xffff)) &&
 	        ((reg & 0xff) == ((reg >> 8) & 0xff))),
 	       "consistent priority masking");
-	report_info("priority mask is 0x%08x", pri_mask);
+	report_info("priority mask is 0x%08"PRIx32, pri_mask);
 
 	reg = reg & 0xff;
 	for (pri_bits = 8; reg & 1; reg >>= 1, pri_bits--)
 		;
 	report(pri_bits >= 4, "implements at least 4 priority bits");
-	report_info("%d priority bits implemented", pri_bits);
+	report_info("%"PRIu32" priority bits implemented", pri_bits);
 
 	pattern = 0;
 	writel(pattern, first_spi);
@@ -555,7 +555,7 @@ static void test_targets(int nr_irqs)
 	reg = readl(targetsptr + GIC_FIRST_SPI);
 	report(reg == (pattern & cpu_mask), "register content preserved");
 	if (reg != (pattern & cpu_mask))
-		report_info("writing %08x reads back as %08x",
+		report_info("writing %08"PRIx32" reads back as %08"PRIx32,
 			    pattern & cpu_mask, reg);
 
 	/* The TARGETS registers are byte accessible. */
@@ -589,7 +589,7 @@ static void gic_test_mmio(void)
 
 	test_typer_v2(reg);
 
-	report_info("IIDR: 0x%08x", readl(gic_dist_base + GICD_IIDR));
+	report_info("IIDR: 0x%08"PRIx32, readl(gic_dist_base + GICD_IIDR));
 
 	report(test_readonly_32(gic_dist_base + GICD_TYPER, false),
                "GICD_TYPER is read-only");
@@ -598,7 +598,7 @@ static void gic_test_mmio(void)
 
 	reg = readl(idreg);
 	report(test_readonly_32(idreg, false), "ICPIDR2 is read-only");
-	report_info("value of ICPIDR2: 0x%08x", reg);
+	report_info("value of ICPIDR2: 0x%08"PRIx32, reg);
 
 	test_priorities(nr_irqs, gic_dist_base + GICD_IPRIORITYR);
 
diff --git a/arm/pl031.c b/arm/pl031.c
index 86035fa407e6..452fe0f3e36c 100644
--- a/arm/pl031.c
+++ b/arm/pl031.c
@@ -150,7 +150,7 @@ static void irq_handler(struct pt_regs *regs)
 		report(readl(&pl031->mis) == 0, "  RTC MIS == 0");
 		irq_triggered = true;
 	} else {
-		report_info("Unexpected interrupt: %d\n", irqnr);
+		report_info("Unexpected interrupt: %"PRIu32"\n", irqnr);
 		return;
 	}
 }
@@ -191,10 +191,10 @@ static int check_rtc_irq(void)
 	report(irq_triggered, "  IRQ triggered");
 	report(!gic_irq_pending(), "  RTC IRQ not pending anymore");
 	if (!irq_triggered) {
-		report_info("  RTC RIS: %x", readl(&pl031->ris));
-		report_info("  RTC MIS: %x", readl(&pl031->mis));
-		report_info("  RTC IMSC: %x", readl(&pl031->imsc));
-		report_info("  GIC IRQs pending: %08x %08x", readl(gic_ispendr), readl(gic_ispendr + 4));
+		report_info("  RTC RIS: %"PRIx32, readl(&pl031->ris));
+		report_info("  RTC MIS: %"PRIx32, readl(&pl031->mis));
+		report_info("  RTC IMSC: %"PRIx32, readl(&pl031->imsc));
+		report_info("  GIC IRQs pending: %08"PRIx32" %08"PRIx32, readl(gic_ispendr), readl(gic_ispendr + 4));
 	}
 
 	local_irq_disable();
diff --git a/arm/pmu.c b/arm/pmu.c
index 831fb6618279..cc959e6a5c76 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -989,6 +989,7 @@ static void pmccntr64_test(void)
 static bool pmu_probe(void)
 {
 	uint32_t pmcr = get_pmcr();
+	uint8_t implementer;
 
 	pmu.version = get_pmu_version();
 	if (pmu.version == ID_DFR0_PMU_NOTIMPL || pmu.version == ID_DFR0_PMU_IMPDEF)
@@ -996,10 +997,10 @@ static bool pmu_probe(void)
 
 	report_info("PMU version: 0x%x", pmu.version);
 
-	pmcr = get_pmcr();
-	report_info("PMU implementer/ID code: %#x(\"%c\")/%#x",
+	implementer = (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK;
+	report_info("PMU implementer/ID code: %#"PRIx32"(\"%c\")/%#"PRIx32,
 		    (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK,
-		    ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) ? : ' ',
+		    implementer ? implementer : ' ',
 		    (pmcr >> PMU_PMCR_ID_SHIFT) & PMU_PMCR_ID_MASK);
 
 	/* store read-only and RES0 fields of the PMCR bottom-half*/
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
