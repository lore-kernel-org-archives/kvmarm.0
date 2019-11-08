Return-Path: <SRS0=fmje=ZA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E3BFC6198
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 14:43:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E876B2245A
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 14:43:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E876B2245A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FC374AEDF;
	Fri,  8 Nov 2019 09:43:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cC21iJn+Y9tm; Fri,  8 Nov 2019 09:43:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57BB84AC70;
	Fri,  8 Nov 2019 09:43:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E24F4AED9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 09:43:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kl0KFVJKPyIv for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Nov 2019 09:43:02 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AF714AEF7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 09:43:00 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D84807A7;
 Fri,  8 Nov 2019 06:42:59 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB5E13F719;
 Fri,  8 Nov 2019 06:42:58 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Andrew Jones <drjones@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 07/17] arm: gic: Extend check_acked() to allow
 silent call
Date: Fri,  8 Nov 2019 14:42:30 +0000
Message-Id: <20191108144240.204202-8-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108144240.204202-1-andre.przywara@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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

For future tests we will need to call check_acked() twice for the same
interrupt (to test delivery of Group 0 and Group 1 interrupts).
This should be reported as a single test, so allow check_acked() to be
called with a "NULL" test name, to suppress output. We report the test
result via the return value, so the outcome is not lost.

Also this amends the new trigger_and_check_spi() wrapper, to propagate
the test result to callers of that function.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 3be76cb..63aa9f4 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -62,7 +62,7 @@ static void stats_reset(void)
 	smp_wmb();
 }
 
-static void check_acked(const char *testname, cpumask_t *mask)
+static int check_acked(const char *testname, cpumask_t *mask)
 {
 	int missing = 0, extra = 0, unexpected = 0;
 	int nr_pass, cpu, i;
@@ -91,16 +91,20 @@ static void check_acked(const char *testname, cpumask_t *mask)
 			}
 		}
 		if (!noirqs && nr_pass == nr_cpus) {
-			report("%s", !bad, testname);
-			if (i)
-				report_info("took more than %d ms", i * 100);
-			return;
+			if (testname) {
+				report("%s", !bad, testname);
+				if (i)
+					report_info("took more than %d ms",
+						    i * 100);
+			}
+			return i * 100;
 		}
 	}
 
 	if (noirqs && nr_pass == nr_cpus) {
-		report("%s", !bad, testname);
-		return;
+		if (testname)
+			report("%s", !bad, testname);
+		return i * 100;
 	}
 
 	for_each_present_cpu(cpu) {
@@ -115,9 +119,11 @@ static void check_acked(const char *testname, cpumask_t *mask)
 		}
 	}
 
-	report("%s", false, testname);
+	if (testname)
+		report("%s", false, testname);
 	report_info("Timed-out (5s). ACKS: missing=%d extra=%d unexpected=%d",
 		    missing, extra, unexpected);
+	return -1;
 }
 
 static void check_spurious(void)
@@ -567,11 +573,12 @@ static void spi_configure_irq(int irq, int cpu)
  * Wait for an SPI to fire (or not) on a certain CPU.
  * Clears the pending bit if requested afterwards.
  */
-static void trigger_and_check_spi(const char *test_name,
+static bool trigger_and_check_spi(const char *test_name,
 				  unsigned int irq_stat,
 				  int cpu)
 {
 	cpumask_t cpumask;
+	bool ret = true;
 
 	stats_reset();
 	gic_spi_trigger(SPI_IRQ);
@@ -584,11 +591,13 @@ static void trigger_and_check_spi(const char *test_name,
 		break;
 	}
 
-	check_acked(test_name, &cpumask);
+	ret = (check_acked(test_name, &cpumask) >= 0);
 
 	/* Clean up pending bit in case this IRQ wasn't taken. */
 	if (!(irq_stat & IRQ_STAT_NO_CLEAR))
 		gic_set_irq_bit(SPI_IRQ, GICD_ICPENDR);
+
+	return ret;
 }
 
 static void spi_test_single(void)
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
