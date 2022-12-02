Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE84C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  2 Dec 2022 04:55:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EDF44B248;
	Thu,  1 Dec 2022 23:55:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mPRuqujKoEbY; Thu,  1 Dec 2022 23:55:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C22AF4B16F;
	Thu,  1 Dec 2022 23:55:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3CF54B0B9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 23:55:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uKePlcYkuvAt for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2022 23:55:34 -0500 (EST)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8230E49E34
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 23:55:34 -0500 (EST)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-3b0af5bcbd3so38367567b3.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Dec 2022 20:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=UWYoC1C7vLvgwnuJf/5t4YZu/UYVRlMlPl/Nd3cz8/k=;
 b=UKkIYduyOROeBe/8qzDkIHE+bh3g2clbyI9VybMrxEYMnL+5qIlK+c3SBaFAf3UVPo
 +68JmioMgLci+SyF0diG4OkWwH5J36rf8pcripXk7LF8mcYxxpVD0pTePemAffdjeOR6
 +Q+GiuFkRXwQUp3PWhtEefYYvIl7z0n0Qd+yAZd7on1apiAKNwCdsaOtA0ZitpRHqZBr
 hk+z13TtaCZ/98QH01jLzVd72LCnSSpAIaPZDFHOcv9Y1sBzf/PPjoM25egQKiGg0Ojk
 Z4Ni3Oc6wnmS+ZkI8kxLM5N1yzWA07FkHlKVyxIzETd+G3FAO7qdqUaB5dAsUD7N4wXa
 Y+zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=UWYoC1C7vLvgwnuJf/5t4YZu/UYVRlMlPl/Nd3cz8/k=;
 b=v3EVPr9FzzSkMZI8tzJvXhKE35OiCaL/VOOOSgenYDgLntDtlTxd0KqCZUeC1f73JE
 RzGAregO6FadCdvXsmRDPp6aA/UMR/E2uF67XccB2uVJfJzGblIE36Zga3KHwDAa0P+/
 TiGrMTUJnvQaPeIKNpQT5QLk/XfwgCa4tlu6l+hmjKnUDSnrdvetvEVdtMrovN1GnwoQ
 MgjQOtYrBq3GWibaJGdtUxozanIhJwaAHq3HdH2NPU7XH3i7sfQbuHmNIEAod7iKxohk
 5ne0pk6etQsITHd6Wm0nXxNOjBZW0ESILngOd80ateDBsujvo7g7WxixvWQbFHLZ0dxv
 vULw==
X-Gm-Message-State: ANoB5plsvkd3lb0wnqVuZThkdhBdAto5o22rew4Ru+gEk83auHqXuY2l
 QPToY1tzAy5uBM6xsUMgY98Gg7FHxO/GwA==
X-Google-Smtp-Source: AA0mqf5IaOCoNyWyBRi5C+jCmWXfzVKN66yMb+RMB1AWswia+RjOzlKyD4WeO4T93LoK0iPURRk0rV6XBGbVlg==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:5583:0:b0:6e7:878:74 with SMTP id
 j125-20020a255583000000b006e708780074mr49333861ybb.645.1669956934065; Thu, 01
 Dec 2022 20:55:34 -0800 (PST)
Date: Fri,  2 Dec 2022 04:55:26 +0000
In-Reply-To: <20221202045527.3646838-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221202045527.3646838-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202045527.3646838-3-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH 2/3] arm: pmu: Prepare for testing 64-bit
 overflows
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

PMUv3p5 adds a knob, PMCR_EL0.LP == 1, that allows overflowing at 64-bits
instead of 32. Prepare by doing these 3 things:

1. Add a "bool overflow_at_64bits" argument to all tests checking
   overflows.
2. Extend satisfy_prerequisites() to check if the machine supports
   "overflow_at_64bits".
3. Refactor the test invocations to use the new "run_test()" which adds a
   report prefix indicating whether the test uses 64 or 32-bit overflows.

A subsequent commit will actually add the 64-bit overflow tests.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 99 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 56 insertions(+), 43 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index eeac984..59e5bfe 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -164,13 +164,13 @@ static void pmu_reset(void)
 /* event counter tests only implemented for aarch64 */
 static void test_event_introspection(void) {}
 static void test_event_counter_config(void) {}
-static void test_basic_event_count(void) {}
-static void test_mem_access(void) {}
-static void test_sw_incr(void) {}
-static void test_chained_counters(void) {}
-static void test_chained_sw_incr(void) {}
-static void test_chain_promotion(void) {}
-static void test_overflow_interrupt(void) {}
+static void test_basic_event_count(bool overflow_at_64bits) {}
+static void test_mem_access(bool overflow_at_64bits) {}
+static void test_sw_incr(bool overflow_at_64bits) {}
+static void test_chained_counters(bool overflow_at_64bits) {}
+static void test_chained_sw_incr(bool overflow_at_64bits) {}
+static void test_chain_promotion(bool overflow_at_64bits) {}
+static void test_overflow_interrupt(bool overflow_at_64bits) {}
 
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -399,7 +399,8 @@ static void test_event_counter_config(void)
 		"read of a counter programmed with unsupported event");
 }
 
-static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events)
+static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events,
+				  bool overflow_at_64bits)
 {
 	int i;
 
@@ -416,16 +417,23 @@ static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events)
 			return false;
 		}
 	}
+
+	if (overflow_at_64bits && pmu.version < ID_DFR0_PMU_V3_8_5) {
+		report_skip("Skip test as 64 overflows need FEAT_PMUv3p5");
+		return false;
+	}
+
 	return true;
 }
 
-static void test_basic_event_count(void)
+static void test_basic_event_count(bool overflow_at_64bits)
 {
 	uint32_t implemented_counter_mask, non_implemented_counter_mask;
 	uint32_t counter_mask;
 	uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
+				   overflow_at_64bits))
 		return;
 
 	implemented_counter_mask = BIT(pmu.nb_implemented_counters) - 1;
@@ -499,12 +507,13 @@ static void test_basic_event_count(void)
 		"check overflow happened on #0 only");
 }
 
-static void test_mem_access(void)
+static void test_mem_access(bool overflow_at_64bits)
 {
 	void *addr = malloc(PAGE_SIZE);
 	uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
+				   overflow_at_64bits))
 		return;
 
 	pmu_reset();
@@ -535,13 +544,14 @@ static void test_mem_access(void)
 			read_sysreg(pmovsclr_el0));
 }
 
-static void test_sw_incr(void)
+static void test_sw_incr(bool overflow_at_64bits)
 {
 	uint32_t events[] = {SW_INCR, SW_INCR};
 	uint64_t cntr0;
 	int i;
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
+				   overflow_at_64bits))
 		return;
 
 	pmu_reset();
@@ -582,12 +592,13 @@ static void test_sw_incr(void)
 		"overflow on counter #0 after 100 SW_INCR");
 }
 
-static void test_chained_counters(void)
+static void test_chained_counters(bool overflow_at_64bits)
 {
 	uint32_t events[] = {CPU_CYCLES, CHAIN};
 	uint64_t cntr1;
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
+				   overflow_at_64bits))
 		return;
 
 	pmu_reset();
@@ -626,13 +637,14 @@ static void test_chained_counters(void)
 	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
 }
 
-static void test_chained_sw_incr(void)
+static void test_chained_sw_incr(bool overflow_at_64bits)
 {
 	uint32_t events[] = {SW_INCR, CHAIN};
 	uint64_t cntr0, cntr1;
 	int i;
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
+				   overflow_at_64bits))
 		return;
 
 	pmu_reset();
@@ -680,12 +692,13 @@ static void test_chained_sw_incr(void)
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
 
-static void test_chain_promotion(void)
+static void test_chain_promotion(bool overflow_at_64bits)
 {
 	uint32_t events[] = {MEM_ACCESS, CHAIN};
 	void *addr = malloc(PAGE_SIZE);
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
+				   overflow_at_64bits))
 		return;
 
 	/* Only enable CHAIN counter */
@@ -829,13 +842,14 @@ static bool expect_interrupts(uint32_t bitmap)
 	return true;
 }
 
-static void test_overflow_interrupt(void)
+static void test_overflow_interrupt(bool overflow_at_64bits)
 {
 	uint32_t events[] = {MEM_ACCESS, SW_INCR};
 	void *addr = malloc(PAGE_SIZE);
 	int i;
 
-	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
+				   overflow_at_64bits))
 		return;
 
 	gic_enable_defaults();
@@ -1059,6 +1073,19 @@ static bool pmu_probe(void)
 	return true;
 }
 
+static void run_test(char *name, void (*test)(bool), bool overflow_at_64bits)
+{
+	const char *prefix = overflow_at_64bits ? "64-bit" : "32-bit";
+
+	report_prefix_push(name);
+	report_prefix_push(prefix);
+
+	test(overflow_at_64bits);
+
+	report_prefix_pop();
+	report_prefix_pop();
+}
+
 int main(int argc, char *argv[])
 {
 	int cpi = 0;
@@ -1091,33 +1118,19 @@ int main(int argc, char *argv[])
 		test_event_counter_config();
 		report_prefix_pop();
 	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
-		report_prefix_push(argv[1]);
-		test_basic_event_count();
-		report_prefix_pop();
+		run_test(argv[1], test_basic_event_count, false);
 	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
-		report_prefix_push(argv[1]);
-		test_mem_access();
-		report_prefix_pop();
+		run_test(argv[1], test_mem_access, false);
 	} else if (strcmp(argv[1], "pmu-sw-incr") == 0) {
-		report_prefix_push(argv[1]);
-		test_sw_incr();
-		report_prefix_pop();
+		run_test(argv[1], test_sw_incr, false);
 	} else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
-		report_prefix_push(argv[1]);
-		test_chained_counters();
-		report_prefix_pop();
+		run_test(argv[1], test_chained_counters, false);
 	} else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
-		report_prefix_push(argv[1]);
-		test_chained_sw_incr();
-		report_prefix_pop();
+		run_test(argv[1], test_chained_sw_incr, false);
 	} else if (strcmp(argv[1], "pmu-chain-promotion") == 0) {
-		report_prefix_push(argv[1]);
-		test_chain_promotion();
-		report_prefix_pop();
+		run_test(argv[1], test_chain_promotion, false);
 	} else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
-		report_prefix_push(argv[1]);
-		test_overflow_interrupt();
-		report_prefix_pop();
+		run_test(argv[1], test_overflow_interrupt, false);
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
