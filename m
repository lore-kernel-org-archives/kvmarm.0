Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDC5C4167B
	for <kvmarm@archiver.kernel.org>; Fri,  2 Dec 2022 04:55:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF3C74B16F;
	Thu,  1 Dec 2022 23:55:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wPYMakO5p5M1; Thu,  1 Dec 2022 23:55:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4F9E4B27F;
	Thu,  1 Dec 2022 23:55:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C7CE40E25
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 23:55:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4Qeb+QMpY+9T for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2022 23:55:36 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EFAD34B1AD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 23:55:35 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id
 j6-20020a05690212c600b006fc7f6e6955so3189638ybu.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Dec 2022 20:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=uRcBcYBhcK2NFHWoVxmpF09t7tRHe45LFzDCXQhbeiI=;
 b=G+EjzY/fhE5Hp0d5sz5Sst7KvfmwMgiKeHyqn57eMfAVPUkFy+YszzcpRMod4EmjaJ
 jr7KzFWoz/JEDCEhKLOgXlxoa6GG/Bll4Vi+L1NOFD4QHgiBzWMCsqq+yDk5Oi3i+qBU
 lcYzA1qpmSZ/oMazPB2Tiq73FQbmwzD75wxsKcNpVJAp7aZn2aC1hegfd+VkVbB7TghL
 Y7WWGC5ph0BYPe5EgxTTSe708O1uxNrQKlZqvu5O67bjmAoNm4REqwwB1EWp0g5yZpOM
 oi+YTEnHMmK6iEWPtVa+9GPStuqFJX+MLWa3aEyq8kU7Jtx8HRfoHJb1XZfthyvFHOV9
 ad9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=uRcBcYBhcK2NFHWoVxmpF09t7tRHe45LFzDCXQhbeiI=;
 b=vZfd8QUxbIzdVD4q2KEkTLYNESJxMHqVOkO/OanNuzi31757merWVwQB7cCwG+1Tk5
 itHjOG4Rh9jtmZT8b15byul2f7zP+WwH08eWQ6//iE1aqDzXDI8GaCrI5r1jbg9ntYdK
 X1QnouKeYe6gsAo0HMAJGPRh2tbgRfrnuhdp9Jg3UWcLStLcNoWP97wnyWfEBXypxzwV
 9gGz+sJa0ATB9DWZprR7jQVLPLX+Ew5byhDc282RmmUNSHR8JKaB/W67qDdkCk3gBFsE
 KuocT6gMpSSp0m5x6+fCidJBjhNs6Rm9qRqjLV3ZonTVWLFs6RymPEivawifPqeKvH7t
 3Tvw==
X-Gm-Message-State: ANoB5pkdUJQX7i/jsWaSCFW2v35E3hNkqt6c5Y4euuJSjcakpoWfanky
 H4ajpTmjNQneRLA9/LNBnGwbw0m/2Dp6Lg==
X-Google-Smtp-Source: AA0mqf5/z0V4HhAkHhS66x/c3XI6gjQ0P/ZMMMaGl5hNJ6YT9xRP1+986m7vYWWUA3qJQDPe6PYdm3h8CsJvqA==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6902:4e6:b0:6cb:f83c:98d5 with SMTP
 id w6-20020a05690204e600b006cbf83c98d5mr48943119ybs.544.1669956935539; Thu,
 01 Dec 2022 20:55:35 -0800 (PST)
Date: Fri,  2 Dec 2022 04:55:27 +0000
In-Reply-To: <20221202045527.3646838-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221202045527.3646838-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202045527.3646838-4-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH 3/3] arm: pmu: Add tests for 64-bit overflows
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
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

Modify all tests checking overflows to support both 32 (PMCR_EL0.LP == 0)
and 64-bit overflows (PMCR_EL0.LP == 1). 64-bit overflows are only
supported on PMUv3p5.

Note that chained tests do not implement "overflow_at_64bits == true".
That's because there are no CHAIN events when "PMCR_EL0.LP == 1" (for more
details see AArch64.IncrementEventCounter() pseudocode in the ARM ARM DDI
0487H.a, J1.1.1 "aarch64/debug").

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 91 ++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 31 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 59e5bfe..3cb563b 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -28,6 +28,7 @@
 #define PMU_PMCR_X         (1 << 4)
 #define PMU_PMCR_DP        (1 << 5)
 #define PMU_PMCR_LC        (1 << 6)
+#define PMU_PMCR_LP        (1 << 7)
 #define PMU_PMCR_N_SHIFT   11
 #define PMU_PMCR_N_MASK    0x1f
 #define PMU_PMCR_ID_SHIFT  16
@@ -55,10 +56,15 @@
 #define EXT_COMMON_EVENTS_HIGH	0x403F
 
 #define ALL_SET			0x00000000FFFFFFFFULL
+#define ALL_SET_64		0xFFFFFFFFFFFFFFFFULL
 #define ALL_CLEAR		0x0000000000000000ULL
 #define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
+#define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
 #define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
 
+#define PRE_OVERFLOW_AT(_64b)	(_64b ? PRE_OVERFLOW_64 : PRE_OVERFLOW)
+#define ALL_SET_AT(_64b)	(_64b ? ALL_SET_64 : ALL_SET)
+
 #define PMU_PPI			23
 
 struct pmu {
@@ -429,8 +435,10 @@ static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events,
 static void test_basic_event_count(bool overflow_at_64bits)
 {
 	uint32_t implemented_counter_mask, non_implemented_counter_mask;
-	uint32_t counter_mask;
+	uint64_t pre_overflow = PRE_OVERFLOW_AT(overflow_at_64bits);
+	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
 	uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
+	uint32_t counter_mask;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
 				   overflow_at_64bits))
@@ -452,13 +460,13 @@ static void test_basic_event_count(bool overflow_at_64bits)
 	 * clear cycle and all event counters and allow counter enablement
 	 * through PMCNTENSET. LC is RES1.
 	 */
-	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P | pmcr_lp);
 	isb();
-	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC), "pmcr: reset counters");
+	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC | pmcr_lp), "pmcr: reset counters");
 
 	/* Preset counter #0 to pre overflow value to trigger an overflow */
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
-	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
+	write_regn_el0(pmevcntr, 0, pre_overflow);
+	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
 		"counter #0 preset to pre-overflow value");
 	report(!read_regn_el0(pmevcntr, 1), "counter #1 is 0");
 
@@ -511,6 +519,8 @@ static void test_mem_access(bool overflow_at_64bits)
 {
 	void *addr = malloc(PAGE_SIZE);
 	uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
+	uint64_t pre_overflow = PRE_OVERFLOW_AT(overflow_at_64bits);
+	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
 				   overflow_at_64bits))
@@ -522,7 +532,7 @@ static void test_mem_access(bool overflow_at_64bits)
 	write_regn_el0(pmevtyper, 1, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	isb();
-	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	report_info("counter #0 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
 	report_info("counter #1 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
 	/* We may measure more than 20 mem access depending on the core */
@@ -532,11 +542,11 @@ static void test_mem_access(bool overflow_at_64bits)
 
 	pmu_reset();
 
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
-	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 0, pre_overflow);
+	write_regn_el0(pmevcntr, 1, pre_overflow);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	isb();
-	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	report(read_sysreg(pmovsclr_el0) == 0x3,
 	       "Ran 20 mem accesses with expected overflows on both counters");
 	report_info("cnt#0 = %ld cnt#1=%ld overflow=0x%lx",
@@ -546,6 +556,8 @@ static void test_mem_access(bool overflow_at_64bits)
 
 static void test_sw_incr(bool overflow_at_64bits)
 {
+	uint64_t pre_overflow = PRE_OVERFLOW_AT(overflow_at_64bits);
+	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
 	uint32_t events[] = {SW_INCR, SW_INCR};
 	uint64_t cntr0;
 	int i;
@@ -561,7 +573,7 @@ static void test_sw_incr(bool overflow_at_64bits)
 	/* enable counters #0 and #1 */
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 0, pre_overflow);
 	isb();
 
 	for (i = 0; i < 100; i++)
@@ -569,21 +581,21 @@ static void test_sw_incr(bool overflow_at_64bits)
 
 	isb();
 	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
-	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
+	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
 		"PWSYNC does not increment if PMCR.E is unset");
 
 	pmu_reset();
 
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 0, pre_overflow);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
-	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	isb();
 
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x3, pmswinc_el0);
 
 	isb();
-	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : PRE_OVERFLOW + 100;
+	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : pre_overflow + 100;
 	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
 	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
 	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
@@ -844,6 +856,9 @@ static bool expect_interrupts(uint32_t bitmap)
 
 static void test_overflow_interrupt(bool overflow_at_64bits)
 {
+	uint64_t pre_overflow = PRE_OVERFLOW_AT(overflow_at_64bits);
+	uint64_t all_set = ALL_SET_AT(overflow_at_64bits);
+	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
 	uint32_t events[] = {MEM_ACCESS, SW_INCR};
 	void *addr = malloc(PAGE_SIZE);
 	int i;
@@ -862,16 +877,16 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
 	write_regn_el0(pmevtyper, 1, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
-	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 0, pre_overflow);
+	write_regn_el0(pmevcntr, 1, pre_overflow);
 	isb();
 
 	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
 
-	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	report(expect_interrupts(0), "no overflow interrupt after preset");
 
-	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	isb();
 
 	for (i = 0; i < 100; i++)
@@ -886,12 +901,12 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 
 	pmu_reset_stats();
 
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
-	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 0, pre_overflow);
+	write_regn_el0(pmevcntr, 1, pre_overflow);
 	write_sysreg(ALL_SET, pmintenset_el1);
 	isb();
 
-	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x3, pmswinc_el0);
 
@@ -900,25 +915,35 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 	report(expect_interrupts(0x3),
 		"overflow interrupts expected on #0 and #1");
 
-	/* promote to 64-b */
+	/*
+	 * promote to 64-b:
+	 *
+	 * This only applies to the !overflow_at_64bits case, as
+	 * overflow_at_64bits doesn't implement CHAIN events. The
+	 * overflow_at_64bits case just checks that chained counters are
+	 * not incremented when PMCR.LP == 1.
+	 */
 
 	pmu_reset_stats();
 
 	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 0, pre_overflow);
 	isb();
-	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
-	report(expect_interrupts(0x1),
-		"expect overflow interrupt on 32b boundary");
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
+	report(expect_interrupts(0x1), "expect overflow interrupt");
 
 	/* overflow on odd counter */
 	pmu_reset_stats();
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
-	write_regn_el0(pmevcntr, 1, ALL_SET);
+	write_regn_el0(pmevcntr, 0, pre_overflow);
+	write_regn_el0(pmevcntr, 1, all_set);
 	isb();
-	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
-	report(expect_interrupts(0x3),
-		"expect overflow interrupt on even and odd counter");
+	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
+	if (overflow_at_64bits)
+		report(expect_interrupts(0x1),
+		       "expect overflow interrupt on even counter");
+	else
+		report(expect_interrupts(0x3),
+		       "expect overflow interrupt on even and odd counter");
 }
 #endif
 
@@ -1119,10 +1144,13 @@ int main(int argc, char *argv[])
 		report_prefix_pop();
 	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
 		run_test(argv[1], test_basic_event_count, false);
+		run_test(argv[1], test_basic_event_count, true);
 	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
 		run_test(argv[1], test_mem_access, false);
+		run_test(argv[1], test_mem_access, true);
 	} else if (strcmp(argv[1], "pmu-sw-incr") == 0) {
 		run_test(argv[1], test_sw_incr, false);
+		run_test(argv[1], test_sw_incr, true);
 	} else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
 		run_test(argv[1], test_chained_counters, false);
 	} else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
@@ -1131,6 +1159,7 @@ int main(int argc, char *argv[])
 		run_test(argv[1], test_chain_promotion, false);
 	} else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
 		run_test(argv[1], test_overflow_interrupt, false);
+		run_test(argv[1], test_overflow_interrupt, true);
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
