Return-Path: <SRS0=3b8a=HV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18C9FC433E6
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 12:13:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C2BEA64EC0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 12:13:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2BEA64EC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 645A24B34F;
	Fri, 19 Feb 2021 07:13:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KcNZ9S59kIvn; Fri, 19 Feb 2021 07:13:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 107964B2E4;
	Fri, 19 Feb 2021 07:13:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F5944B2D9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 07:13:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UnOB-ox8jEGi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Feb 2021 07:13:43 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EA0E4B2CD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 07:13:42 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44EFA1435;
 Fri, 19 Feb 2021 04:13:42 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 674BB3F73B;
 Fri, 19 Feb 2021 04:13:41 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v4 08/11] arm/arm64: gic: Split check_acked()
 into two functions
Date: Fri, 19 Feb 2021 12:13:34 +0000
Message-Id: <20210219121337.76533-9-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210219121337.76533-1-alexandru.elisei@arm.com>
References: <20210219121337.76533-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: andre.przywara@arm.com
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

check_acked() has several peculiarities: is the only function among the
check_* functions which calls report() directly, it does two things
(waits for interrupts and checks for misfired interrupts) and it also
mixes printf, report_info and report calls.

check_acked() also reports a pass and returns as soon all the target CPUs
have received interrupts, However, a CPU not having received an interrupt
*now* does not guarantee not receiving an erroneous interrupt if we wait
long enough.

Rework the function by splitting it into two separate functions, each with
a single responsibility: wait_for_interrupts(), which waits for the
expected interrupts to fire, and check_acked() which checks that interrupts
have been received as expected.

wait_for_interrupts() also waits an extra 100 milliseconds after the
expected interrupts have been received in an effort to make sure we don't
miss misfiring interrupts.

Splitting check_acked() into two functions will also allow us to
customize the behavior of each function in the future more easily
without using an unnecessarily long list of arguments for check_acked().

CC: Andre Przywara <andre.przywara@arm.com>
Acked-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/gic.c | 74 ++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 48 insertions(+), 26 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index af4d4645c0ae..2c96cf49ce8c 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -61,41 +61,43 @@ static void stats_reset(void)
 	}
 }
 
-static void check_acked(const char *testname, cpumask_t *mask)
+static void wait_for_interrupts(cpumask_t *mask)
 {
-	int missing = 0, extra = 0, unexpected = 0;
 	int nr_pass, cpu, i;
-	bool bad = false;
 
 	/* Wait up to 5s for all interrupts to be delivered */
-	for (i = 0; i < 50; ++i) {
+	for (i = 0; i < 50; i++) {
 		mdelay(100);
 		nr_pass = 0;
 		for_each_present_cpu(cpu) {
+			/*
+			 * A CPU having received more than one interrupts will
+			 * show up in check_acked(), and no matter how long we
+			 * wait it cannot un-receive it. Consider at least one
+			 * interrupt as a pass.
+			 */
 			nr_pass += cpumask_test_cpu(cpu, mask) ?
-				acked[cpu] == 1 : acked[cpu] == 0;
-			smp_rmb(); /* pairs with smp_wmb in ipi_handler */
-
-			if (bad_sender[cpu] != -1) {
-				printf("cpu%d received IPI from wrong sender %d\n",
-					cpu, bad_sender[cpu]);
-				bad = true;
-			}
-
-			if (bad_irq[cpu] != -1) {
-				printf("cpu%d received wrong irq %d\n",
-					cpu, bad_irq[cpu]);
-				bad = true;
-			}
+				acked[cpu] >= 1 : acked[cpu] == 0;
 		}
+
 		if (nr_pass == nr_cpus) {
-			report(!bad, "%s", testname);
 			if (i)
-				report_info("took more than %d ms", i * 100);
+				report_info("interrupts took more than %d ms", i * 100);
+			/* Wait for unexpected interrupts to fire */
+			mdelay(100);
 			return;
 		}
 	}
 
+	report_info("interrupts timed-out (5s)");
+}
+
+static bool check_acked(cpumask_t *mask)
+{
+	int missing = 0, extra = 0, unexpected = 0;
+	bool pass = true;
+	int cpu;
+
 	for_each_present_cpu(cpu) {
 		if (cpumask_test_cpu(cpu, mask)) {
 			if (!acked[cpu])
@@ -106,11 +108,28 @@ static void check_acked(const char *testname, cpumask_t *mask)
 			if (acked[cpu])
 				++unexpected;
 		}
+		smp_rmb(); /* pairs with smp_wmb in ipi_handler */
+
+		if (bad_sender[cpu] != -1) {
+			report_info("cpu%d received IPI from wrong sender %d",
+					cpu, bad_sender[cpu]);
+			pass = false;
+		}
+
+		if (bad_irq[cpu] != -1) {
+			report_info("cpu%d received wrong irq %d",
+					cpu, bad_irq[cpu]);
+			pass = false;
+		}
+	}
+
+	if (missing || extra || unexpected) {
+		report_info("ACKS: missing=%d extra=%d unexpected=%d",
+				missing, extra, unexpected);
+		pass = false;
 	}
 
-	report(false, "%s", testname);
-	report_info("Timed-out (5s). ACKS: missing=%d extra=%d unexpected=%d",
-		    missing, extra, unexpected);
+	return pass;
 }
 
 static void check_spurious(void)
@@ -299,7 +318,8 @@ static void ipi_test_self(void)
 	cpumask_clear(&mask);
 	cpumask_set_cpu(smp_processor_id(), &mask);
 	gic->ipi.send_self();
-	check_acked("IPI: self", &mask);
+	wait_for_interrupts(&mask);
+	report(check_acked(&mask), "Interrupts received");
 	report_prefix_pop();
 }
 
@@ -314,7 +334,8 @@ static void ipi_test_smp(void)
 	for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
 		cpumask_clear_cpu(i, &mask);
 	gic_ipi_send_mask(IPI_IRQ, &mask);
-	check_acked("IPI: directed", &mask);
+	wait_for_interrupts(&mask);
+	report(check_acked(&mask), "Interrupts received");
 	report_prefix_pop();
 
 	report_prefix_push("broadcast");
@@ -322,7 +343,8 @@ static void ipi_test_smp(void)
 	cpumask_copy(&mask, &cpu_present_mask);
 	cpumask_clear_cpu(smp_processor_id(), &mask);
 	gic->ipi.send_broadcast();
-	check_acked("IPI: broadcast", &mask);
+	wait_for_interrupts(&mask);
+	report(check_acked(&mask), "Interrupts received");
 	report_prefix_pop();
 }
 
-- 
2.30.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
