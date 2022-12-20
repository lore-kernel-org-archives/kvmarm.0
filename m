Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F160C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 20 Dec 2022 03:10:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 910E54B62A;
	Mon, 19 Dec 2022 22:10:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fauxdrl-iyyu; Mon, 19 Dec 2022 22:10:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10E324B825;
	Mon, 19 Dec 2022 22:10:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 634594B7ED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 22:10:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F6Qst6DCKuWt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2022 22:10:37 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20ED64B5DB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 22:10:37 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-434eb7c6fa5so130023017b3.14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 19:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=Xnm0j9raQy1Oj01SJW34nfgs6KGA8/nvtuOTe2h8nwo=;
 b=hrRIewrniOFjcx89HXBcytfmHUrxu2ThlfaUgGK1xUxWtRSBTV4k3zH6dE9vlZVRCJ
 kfwG2dhZU0VMBD8ZM4V+wpU2dQZnfTRtr/OlWb0JApBmtQTmYEWlj/TwhKB735dnu8La
 q26+H7/iqrup4bDTeEk8Rsl+cXyP5MKY/tAbwy+ju9rr2NNmqiuZmD6OgL2rHRIfBed7
 qth6yDtoXw4lSnz6oRcgfc+s0ky8xovTFuIZhDLLftg0yRS+M7C4aOabIx9gNe1j6wXq
 K7qT8EIOl3m1DFtxviz9s/gLLkkioHpuFvg1VHN7SK0wCnnkMp0/wOkc8sRIhfHMrCmN
 b1uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=Xnm0j9raQy1Oj01SJW34nfgs6KGA8/nvtuOTe2h8nwo=;
 b=4hHhlHMJ+LIbCpOkVZAdMz634vUF5ZHeu4+WxncCwNIbXmaNR1W8GrbQNwcQ2o7kFR
 C+/wgl4SxctapQsa78LXR2ehqMemV7Nb+Eg9QpAPfv98jgHYzNlAMs1N6F3De6OKnlxf
 uUEbHjcL3FD/KKypxnfDJfgDeMVIEZ/Efi3oXBnWbdC1DwXqXLDciIuClOmz6mt7SfmF
 pSpIDaZvuLXySzlWCKmDrR1OVkA6AlMwUsemVdfGCx6uUztlB4TuanPl3F2OiTdTH9Ig
 WTtn32RoFEJgJEv9Is2iLJlJjWsagJtUXTbiOMQV19T65VknVEsmyY5qJ0BaT7MTYoUz
 Eq1A==
X-Gm-Message-State: AFqh2ko6NRIcO+Hz3Y3MB+d7e+drEaer2lSvy0TFwEAf41zehVb7y2jN
 1cyzxDJ7Q0U1FLuVllxb5piY9Vp2zUwodA==
X-Google-Smtp-Source: AMrXdXuRbbc+T4ZX0QDLQDgzFQz9i28hQuZPYyJmzA0LAiRQAX+qKPltO6C140SftXppeKYoNEvuEaFYgbxMFQ==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:fe07:0:b0:3d7:b4:9879 with SMTP id
 j7-20020a81fe07000000b003d700b49879mr2877714ywn.370.1671505836639; Mon, 19
 Dec 2022 19:10:36 -0800 (PST)
Date: Tue, 20 Dec 2022 03:10:29 +0000
In-Reply-To: <20221220031032.2648701-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221220031032.2648701-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220031032.2648701-2-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v2 1/4] arm: pmu: Fix overflow checks for
 PMUv3p5 long counters
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

PMUv3p5 uses 64-bit counters irrespective of whether the PMU is configured
for overflowing at 32 or 64-bits. The consequence is that tests that check
the counter values after overflowing should not assume that values will be
wrapped around 32-bits: they overflow into the other half of the 64-bit
counters on PMUv3p5.

Fix tests by correctly checking overflowing-counters against the expected
64-bit value.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index cd47b14..1b55e20 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -54,10 +54,13 @@
 #define EXT_COMMON_EVENTS_LOW	0x4000
 #define EXT_COMMON_EVENTS_HIGH	0x403F
 
-#define ALL_SET			0xFFFFFFFF
-#define ALL_CLEAR		0x0
-#define PRE_OVERFLOW		0xFFFFFFF0
-#define PRE_OVERFLOW2		0xFFFFFFDC
+#define ALL_SET			0x00000000FFFFFFFFULL
+#define ALL_SET_64		0xFFFFFFFFFFFFFFFFULL
+#define ALL_CLEAR		0x0000000000000000ULL
+#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
+#define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
+
+#define ALL_SET_AT(_64b)       (_64b ? ALL_SET_64 : ALL_SET)
 
 #define PMU_PPI			23
 
@@ -538,6 +541,7 @@ static void test_mem_access(void)
 static void test_sw_incr(void)
 {
 	uint32_t events[] = {SW_INCR, SW_INCR};
+	uint64_t cntr0;
 	int i;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
@@ -572,9 +576,11 @@ static void test_sw_incr(void)
 		write_sysreg(0x3, pmswinc_el0);
 
 	isb();
-	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
-	report(read_regn_el0(pmevcntr, 1)  == 100,
-		"counter #0 after + 100 SW_INCR");
+	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ?
+		(uint32_t)PRE_OVERFLOW + 100 :
+		(uint64_t)PRE_OVERFLOW + 100;
+	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
+	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
 	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 	report(read_sysreg(pmovsclr_el0) == 0x1,
@@ -584,6 +590,7 @@ static void test_sw_incr(void)
 static void test_chained_counters(void)
 {
 	uint32_t events[] = {CPU_CYCLES, CHAIN};
+	uint64_t all_set = ALL_SET_AT(pmu.version >= ID_DFR0_PMU_V3_8_5);
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
 		return;
@@ -614,17 +621,19 @@ static void test_chained_counters(void)
 	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
 
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
-	write_regn_el0(pmevcntr, 1, ALL_SET);
+	write_regn_el0(pmevcntr, 1, all_set);
 
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
-	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
+	report(read_regn_el0(pmevcntr, 1) == 0, "CHAIN counter #1 wrapped");
+
 	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
 }
 
 static void test_chained_sw_incr(void)
 {
 	uint32_t events[] = {SW_INCR, CHAIN};
+	uint64_t cntr0, cntr1;
 	int i;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
@@ -665,10 +674,14 @@ static void test_chained_sw_incr(void)
 		write_sysreg(0x1, pmswinc_el0);
 
 	isb();
+	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ?
+		(uint32_t)PRE_OVERFLOW + 100 :
+		(uint64_t)PRE_OVERFLOW + 100;
+	cntr1 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 0 : ALL_SET + 1;
 	report((read_sysreg(pmovsclr_el0) == 0x3) &&
-		(read_regn_el0(pmevcntr, 1) == 0) &&
-		(read_regn_el0(pmevcntr, 0) == 84),
-		"expected overflows and values after 100 SW_INCR/CHAIN");
+	       (read_regn_el0(pmevcntr, 0) == cntr0) &&
+	       (read_regn_el0(pmevcntr, 1) == cntr1),
+	       "expected overflows and values after 100 SW_INCR/CHAIN");
 	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
-- 
2.39.0.314.g84b9a713c41-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
