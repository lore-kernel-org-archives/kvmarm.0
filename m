Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C53F46AE
	for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 16:53:59 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id y66-20020a253245000000b007cb4f1e3e57so2442932yby.8
        for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 08:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3lDmrfi+HjrUZeHRFrGSbTeg3Od0rKhtY0IfxLDbzY8=;
        b=epBHYM+tAT6MpQNCXx0TrlsLJDIe06G8gccOfv5IWJlXaOsnw3c5oUOAwGKKyRxxyB
         dQkVmcmbnfEEN93iGpOfcxIUHFflVppGaLv8nB2KU2578B9Up3t/LtJ0tqnrT4I9KH3i
         wUuW90OszIVUmwJLlPSSRFIkAxzd42b8KHHWfDIghROrKobBzaMBoeAR4+RoOt4JlpAd
         PAKAS/8fElttyDmwRz9JG+Geg+VVkR7RhqFgtzhRJuVyHOu1Vg4qmuP9bgQuBN6hZAtx
         S1fy+AhDnrmACgEM0eIy6gkZEHYnKXVc6AcrT4W4yDDoMjdIlHbUl6rSdGgMmM0QkOyQ
         Rzvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3lDmrfi+HjrUZeHRFrGSbTeg3Od0rKhtY0IfxLDbzY8=;
        b=uW5WUlDbCEcLuyPtpQG+4X1XEznENd7humc/T5oKtVuoQLWqy1+TOnIs2zBJv/9sSl
         zq5BVwgD6eRrpeQActX8xMG9ToJreUgPlkS0wHvawnlPquj0e/Ou4XSGThBKNXBjCS4s
         O/zmxAzc4zG7e533o09pKwpUXN15vZAhg5k/TGlicDHx0huDn0MwjWRUcZNKdrii0L7k
         TyK4tjwz+jKvgXOBDx9amRv+L7f3LzrihRcEpeWemoMrDrawwLn1wJXF/sB5BfD5p+N1
         rcvRpHz12sRvKvQRSY1AoDH8w+yNwJJ0iw/0EWE7PJHjzwgjNcIDgE7AJKQb7Spqc8sA
         wehA==
X-Gm-Message-State: AFqh2krziNX4haFwHuyqPyAtMh1sMbynf0d0FzGU75N9xtkrAZ2JkuP6
	6XY4u+IY/6RsXlQbcCYBuAYdwv6pBxzGDA==
X-Google-Smtp-Source: AMrXdXsasyF/0U1lpEv0xVZylGG9Pc412/O0dWUZHMGef0j+GYlVfTE1grKd0aoLFot/Y2OVNIPolLfcFwWWHw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:1681:0:b0:475:9f2c:899 with SMTP id
 123-20020a811681000000b004759f2c0899mr5243518yww.290.1674752038614; Thu, 26
 Jan 2023 08:53:58 -0800 (PST)
Date: Thu, 26 Jan 2023 16:53:48 +0000
In-Reply-To: <20230126165351.2561582-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230126165351.2561582-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126165351.2561582-4-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v4 3/6] arm: pmu: Rename ALL_SET and PRE_OVERFLOW
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	oliver.upton@linux.dev, reijiw@google.com, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

Given that the arm PMU tests now handle 64-bit counters and overflows,
it's better to be precise about what the ALL_SET and PRE_OVERFLOW
macros actually are. Given that they are both 32-bit counters,
just add _32 to both of them.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 78 +++++++++++++++++++++++++++----------------------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 06cbd73..08e956d 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -54,9 +54,9 @@
 #define EXT_COMMON_EVENTS_LOW	0x4000
 #define EXT_COMMON_EVENTS_HIGH	0x403F
 
-#define ALL_SET			0x00000000FFFFFFFFULL
+#define ALL_SET_32			0x00000000FFFFFFFFULL
 #define ALL_CLEAR		0x0000000000000000ULL
-#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
+#define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
 #define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
 
 #define PMU_PPI			23
@@ -153,11 +153,11 @@ static void pmu_reset(void)
 	/* reset all counters, counting disabled at PMCR level*/
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
 	/* Disable all counters */
-	write_sysreg(ALL_SET, PMCNTENCLR);
+	write_sysreg(ALL_SET_32, PMCNTENCLR);
 	/* clear overflow reg */
-	write_sysreg(ALL_SET, PMOVSR);
+	write_sysreg(ALL_SET_32, PMOVSR);
 	/* disable overflow interrupts on all counters */
-	write_sysreg(ALL_SET, PMINTENCLR);
+	write_sysreg(ALL_SET_32, PMINTENCLR);
 	isb();
 }
 
@@ -322,7 +322,7 @@ static void irq_handler(struct pt_regs *regs)
 				pmu_stats.bitmap |= 1 << i;
 			}
 		}
-		write_sysreg(ALL_SET, pmovsclr_el0);
+		write_sysreg(ALL_SET_32, pmovsclr_el0);
 		isb();
 	} else {
 		pmu_stats.unexpected = true;
@@ -346,11 +346,11 @@ static void pmu_reset(void)
 	/* reset all counters, counting disabled at PMCR level*/
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
 	/* Disable all counters */
-	write_sysreg_s(ALL_SET, PMCNTENCLR_EL0);
+	write_sysreg_s(ALL_SET_32, PMCNTENCLR_EL0);
 	/* clear overflow reg */
-	write_sysreg(ALL_SET, pmovsclr_el0);
+	write_sysreg(ALL_SET_32, pmovsclr_el0);
 	/* disable overflow interrupts on all counters */
-	write_sysreg(ALL_SET, pmintenclr_el1);
+	write_sysreg(ALL_SET_32, pmintenclr_el1);
 	pmu_reset_stats();
 	isb();
 }
@@ -463,7 +463,7 @@ static void test_basic_event_count(bool overflow_at_64bits)
 	write_regn_el0(pmevtyper, 1, INST_RETIRED | PMEVTYPER_EXCLUDE_EL0);
 
 	/* disable all counters */
-	write_sysreg_s(ALL_SET, PMCNTENCLR_EL0);
+	write_sysreg_s(ALL_SET_32, PMCNTENCLR_EL0);
 	report(!read_sysreg_s(PMCNTENCLR_EL0) && !read_sysreg_s(PMCNTENSET_EL0),
 		"pmcntenclr: disable all counters");
 
@@ -476,8 +476,8 @@ static void test_basic_event_count(bool overflow_at_64bits)
 	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC), "pmcr: reset counters");
 
 	/* Preset counter #0 to pre overflow value to trigger an overflow */
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
-	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
+	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW_32,
 		"counter #0 preset to pre-overflow value");
 	report(!read_regn_el0(pmevcntr, 1), "counter #1 is 0");
 
@@ -499,11 +499,11 @@ static void test_basic_event_count(bool overflow_at_64bits)
 		"pmcntenset: just enabled #0 and #1");
 
 	/* clear overflow register */
-	write_sysreg(ALL_SET, pmovsclr_el0);
+	write_sysreg(ALL_SET_32, pmovsclr_el0);
 	report(!read_sysreg(pmovsclr_el0), "check overflow reg is 0");
 
 	/* disable overflow interrupts on all counters*/
-	write_sysreg(ALL_SET, pmintenclr_el1);
+	write_sysreg(ALL_SET_32, pmintenclr_el1);
 	report(!read_sysreg(pmintenclr_el1),
 		"pmintenclr_el1=0, all interrupts disabled");
 
@@ -551,8 +551,8 @@ static void test_mem_access(bool overflow_at_64bits)
 
 	pmu_reset();
 
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
-	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
+	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW_32);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	isb();
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
@@ -566,7 +566,7 @@ static void test_mem_access(bool overflow_at_64bits)
 static void test_sw_incr(bool overflow_at_64bits)
 {
 	uint32_t events[] = {SW_INCR, SW_INCR};
-	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
+	uint64_t cntr0 = (PRE_OVERFLOW_32 + 100) & pmevcntr_mask();
 	int i;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
@@ -580,7 +580,7 @@ static void test_sw_incr(bool overflow_at_64bits)
 	/* enable counters #0 and #1 */
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
 	isb();
 
 	for (i = 0; i < 100; i++)
@@ -588,12 +588,12 @@ static void test_sw_incr(bool overflow_at_64bits)
 
 	isb();
 	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
-	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
+	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW_32,
 		"PWSYNC does not increment if PMCR.E is unset");
 
 	pmu_reset();
 
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
 	isb();
@@ -623,7 +623,7 @@ static void test_chained_counters(bool unused)
 	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
 	/* enable counters #0 and #1 */
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
 
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 
@@ -635,15 +635,15 @@ static void test_chained_counters(bool unused)
 	pmu_reset();
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
 	write_regn_el0(pmevcntr, 1, 0x1);
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
 	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
 	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
 
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
-	write_regn_el0(pmevcntr, 1, ALL_SET);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
+	write_regn_el0(pmevcntr, 1, ALL_SET_32);
 
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
@@ -654,8 +654,8 @@ static void test_chained_counters(bool unused)
 static void test_chained_sw_incr(bool unused)
 {
 	uint32_t events[] = {SW_INCR, CHAIN};
-	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
-	uint64_t cntr1 = (ALL_SET + 1) & pmevcntr_mask();
+	uint64_t cntr0 = (PRE_OVERFLOW_32 + 100) & pmevcntr_mask();
+	uint64_t cntr1 = (ALL_SET_32 + 1) & pmevcntr_mask();
 	int i;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
@@ -668,7 +668,7 @@ static void test_chained_sw_incr(bool unused)
 	/* enable counters #0 and #1 */
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
 	isb();
 
@@ -686,8 +686,8 @@ static void test_chained_sw_incr(bool unused)
 	pmu_reset();
 
 	write_regn_el0(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
-	write_regn_el0(pmevcntr, 1, ALL_SET);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
+	write_regn_el0(pmevcntr, 1, ALL_SET_32);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
 	isb();
@@ -725,7 +725,7 @@ static void test_chain_promotion(bool unused)
 
 	/* Only enable even counter */
 	pmu_reset();
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
 	write_sysreg_s(0x1, PMCNTENSET_EL0);
 	isb();
 
@@ -873,8 +873,8 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
 	write_regn_el0(pmevtyper, 1, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
-	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
+	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW_32);
 	isb();
 
 	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
@@ -893,13 +893,13 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 	isb();
 	report(expect_interrupts(0), "no overflow interrupt after counting");
 
-	/* enable interrupts (PMINTENSET_EL1 <= ALL_SET) */
+	/* enable interrupts (PMINTENSET_EL1 <= ALL_SET_32) */
 
 	pmu_reset_stats();
 
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
-	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
-	write_sysreg(ALL_SET, pmintenset_el1);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
+	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW_32);
+	write_sysreg(ALL_SET_32, pmintenset_el1);
 	isb();
 
 	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
@@ -916,7 +916,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 	pmu_reset_stats();
 
 	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
 	isb();
 	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
 	report(expect_interrupts(0x1),
@@ -924,8 +924,8 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 
 	/* overflow on odd counter */
 	pmu_reset_stats();
-	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
-	write_regn_el0(pmevcntr, 1, ALL_SET);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
+	write_regn_el0(pmevcntr, 1, ALL_SET_32);
 	isb();
 	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
 	report(expect_interrupts(0x3),
-- 
2.39.1.456.gfc5497dd1b-goog

