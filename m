Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 897DCC001B2
	for <kvmarm@archiver.kernel.org>; Tue, 20 Dec 2022 03:10:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 466FD4B81A;
	Mon, 19 Dec 2022 22:10:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7wXtpqcDMTjL; Mon, 19 Dec 2022 22:10:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 570A64B82A;
	Mon, 19 Dec 2022 22:10:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEC1C4B62A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 22:10:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mth-cdhLWrMy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2022 22:10:40 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 699FF4B7FC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 22:10:40 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 n190-20020a25dac7000000b007447d7a25e4so5600171ybf.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 19:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=ieYMeABHvjFgvGVv5lxYkk0Hu+698TGVrD+YW7hTeDI=;
 b=LJ3qbwRJneHwgVusnaykSfCZzZ6LQ71IIZOTmiR8rY9uQD3Ye/uX32QNWHsAatJD98
 jjY6QP/IobpAny3/LY/mrt08ywDCxNbiMYn427udENbh2KK8Y6ABPOlmE5OjQMG7gZbg
 uCzbwlanufZMXEsa7JqU+r58r73QufZQNsKTkAGmwBRI+mRbviZrpnAxVK1xAFKboCxh
 sCt9fQA7YKUOHct6RG52k1UwB7Th6Xk96OT9VjlbRZIG1izDASDfGxKYBTBKj8YgAPic
 U+1GQYw3lD5bih5P8Qa09saikTBC+WOeUBa2MWDEoUDa9cGCrTpM4zv2kdryBq9oIffv
 I9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=ieYMeABHvjFgvGVv5lxYkk0Hu+698TGVrD+YW7hTeDI=;
 b=ClzA615zt513BsEYUXQ9gIvGX42ETtGLii1mrcD67cqcKN8tplF7GV4pQ7NdSzDBma
 COlCLLKvkb6nAtaGqxDnCCxxGSFPy8lR2XFJEhIGEa1en09DvvyHJhrVH+a3qaaBcmg8
 +fUJjFKl+7LOejoypsfQcpywUs8XZmSYugmqZOc0itccwTHtuJxR5r+vVHHwZBJNS+MZ
 ENuFboAPAEC5VBQrxRZIKBvHea/kGcqQHnBu0szTNbQRURawTykM7jHK5ls6vteLetBl
 W8rFjp1f0OBYLcodLeAs76/7dXi4olIhdl0YRcryZEEOIq39EzcF0l1f2DlQ8it3YUBH
 Tw5A==
X-Gm-Message-State: ANoB5pl1q/rGLuV3ORNCp49yj6CnAUe1yZhVIUDdt9SXyksv2j43Re/b
 LviXFjfY61ZdqAIxMq3FHCJr+ar8qD6kiQ==
X-Google-Smtp-Source: AA0mqf5EDlv5DBhFeVKHkvhyq762mNT3cZIJ/jIGjMw6ceX8MXQZS3gy3W/5Pdr8i8UIx5IplMWIEHsXEvjItg==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:690c:58d:b0:3c7:8c92:1243 with SMTP
 id bo13-20020a05690c058d00b003c78c921243mr4166653ywb.81.1671505840023; Mon,
 19 Dec 2022 19:10:40 -0800 (PST)
Date: Tue, 20 Dec 2022 03:10:31 +0000
In-Reply-To: <20221220031032.2648701-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221220031032.2648701-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220031032.2648701-4-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v2 3/4] arm: pmu: Add tests for 64-bit overflows
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
 arm/pmu.c | 97 ++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 64 insertions(+), 33 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 4cd3790..680623d 100644
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
@@ -58,9 +59,11 @@
 #define ALL_SET_64		0xFFFFFFFFFFFFFFFFULL
 #define ALL_CLEAR		0x0000000000000000ULL
 #define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
+#define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
 #define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
 
-#define ALL_SET_AT(_64b)       (_64b ? ALL_SET_64 : ALL_SET)
+#define PRE_OVERFLOW_AT(_64b)	(_64b ? PRE_OVERFLOW_64 : PRE_OVERFLOW)
+#define ALL_SET_AT(_64b)	(_64b ? ALL_SET_64 : ALL_SET)
 
 #define PMU_PPI			23
 
@@ -436,8 +439,10 @@ static bool check_overflow_prerequisites(bool overflow_at_64bits)
 static void test_basic_event_count(bool overflow_at_64bits)
 {
 	uint32_t implemented_counter_mask, non_implemented_counter_mask;
-	uint32_t counter_mask;
+	uint64_t pre_overflow = PRE_OVERFLOW_AT(overflow_at_64bits);
+	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
 	uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
+	uint32_t counter_mask;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
 	    !check_overflow_prerequisites(overflow_at_64bits))
@@ -459,13 +464,13 @@ static void test_basic_event_count(bool overflow_at_64bits)
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
 
@@ -518,6 +523,8 @@ static void test_mem_access(bool overflow_at_64bits)
 {
 	void *addr = malloc(PAGE_SIZE);
 	uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
+	uint64_t pre_overflow = PRE_OVERFLOW_AT(overflow_at_64bits);
+	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
 	    !check_overflow_prerequisites(overflow_at_64bits))
@@ -529,7 +536,7 @@ static void test_mem_access(bool overflow_at_64bits)
 	write_regn_el0(pmevtyper, 1, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	isb();
-	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	report_info("counter #0 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
 	report_info("counter #1 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
 	/* We may measure more than 20 mem access depending on the core */
@@ -539,11 +546,11 @@ static void test_mem_access(bool overflow_at_64bits)
 
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
@@ -553,6 +560,8 @@ static void test_mem_access(bool overflow_at_64bits)
 
 static void test_sw_incr(bool overflow_at_64bits)
 {
+	uint64_t pre_overflow = PRE_OVERFLOW_AT(overflow_at_64bits);
+	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
 	uint32_t events[] = {SW_INCR, SW_INCR};
 	uint64_t cntr0;
 	int i;
@@ -568,7 +577,7 @@ static void test_sw_incr(bool overflow_at_64bits)
 	/* enable counters #0 and #1 */
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 0, pre_overflow);
 	isb();
 
 	for (i = 0; i < 100; i++)
@@ -576,14 +585,14 @@ static void test_sw_incr(bool overflow_at_64bits)
 
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
@@ -591,8 +600,8 @@ static void test_sw_incr(bool overflow_at_64bits)
 
 	isb();
 	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ?
-		(uint32_t)PRE_OVERFLOW + 100 :
-		(uint64_t)PRE_OVERFLOW + 100;
+		(uint32_t)pre_overflow + 100 :
+		(uint64_t)pre_overflow + 100;
 	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
 	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
 	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
@@ -851,6 +860,9 @@ static bool expect_interrupts(uint32_t bitmap)
 
 static void test_overflow_interrupt(bool overflow_at_64bits)
 {
+	uint64_t pre_overflow = PRE_OVERFLOW_AT(overflow_at_64bits);
+	uint64_t all_set = ALL_SET_AT(overflow_at_64bits);
+	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
 	uint32_t events[] = {MEM_ACCESS, SW_INCR};
 	void *addr = malloc(PAGE_SIZE);
 	int i;
@@ -869,16 +881,16 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
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
@@ -893,12 +905,12 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 
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
 
@@ -907,25 +919,40 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
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
+	if (overflow_at_64bits) {
+		report(expect_interrupts(0x1),
+		       "expect overflow interrupt on even counter");
+		report(read_regn_el0(pmevcntr, 1) == all_set,
+		       "Odd counter did not change");
+	} else {
+		report(expect_interrupts(0x3),
+		       "expect overflow interrupt on even and odd counter");
+		report(read_regn_el0(pmevcntr, 1) != all_set,
+		       "Odd counter wrapped");
+	}
 }
 #endif
 
@@ -1126,10 +1153,13 @@ int main(int argc, char *argv[])
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
@@ -1138,6 +1168,7 @@ int main(int argc, char *argv[])
 		run_test(argv[1], test_chain_promotion, false);
 	} else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
 		run_test(argv[1], test_overflow_interrupt, false);
+		run_test(argv[1], test_overflow_interrupt, true);
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
-- 
2.39.0.314.g84b9a713c41-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
