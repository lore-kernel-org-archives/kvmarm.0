Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E06746AE
	for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 16:53:56 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id x188-20020a2531c5000000b00716de19d76bso2420543ybx.19
        for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 08:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=shYgfKRwhIAgTuaj5Y0w7vjI6+sPUsgjYlnsUjXkrH0=;
        b=lVzRX25LzEYV+PoC279pIXw1Dre+8sYnEw0e/hvbx7s6D0mta/drv249sxAN1i60Zs
         SyOId/M2Pzw0BCzi3wwGuULPwSgCliX7fF6aJGaEvLEUfQBemh6ZrkpRJOI2pZ8lIPlH
         QxHLcv2hRPgtj4GEiWXaUmRDLcBImh8czvJNCz658xQEdtlxvhpzWotEd46DrbsZL0lT
         /FeN8G8dlcpSfGwaPwB36wr0SEdL0pK5I9Fh6UBj6HwAsLeDWR0OuKiDCq+JQvBFsNrA
         QMGRTfNykr/wviT1X7+Lz6ye8uTc7TJ2ju7xLGWPNQWy2zUbL4HSumLd5YrSzUFVa6B3
         R/1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=shYgfKRwhIAgTuaj5Y0w7vjI6+sPUsgjYlnsUjXkrH0=;
        b=X1OJVKQgo0IJD3R/uFShbcX6gmmeNPKQDAtvoy9esDrH77vMVnxnmeRxXMAOXlIQ7o
         ZTrlHJ1/e68v8poXx/Q7HoET0k105QOQKPf/jlDNIQgWM1wOut9ekmS+3Dc5yQTQneTM
         7wiY9E7jOK/oA69nXSBwtsIeX8DkMY/QnbPVHWpZaMT8WnNaI/zHIgQWDsUIT5gqC4QT
         37LZcYmzFR4Yf9wk3XIzhayCtzroew3ZWMUvpnWAmCIV5CR98ghAJtA1YAMJRoaEK1jL
         Cq7cuEo5ZuJUcOeEY3q3afBGmT/WJD4D+gtVVc4Eczcwd86xJAFm2g9nKdMGe8LimqMQ
         hv9w==
X-Gm-Message-State: AFqh2krDMJa7oUrgof9MwOnmpb/fIHA+ZWVT7h5KmrJgzUJXwNSAudBp
	HotsAI3dDidFnsAPKf/vTeNJk8eoQLE8Qg==
X-Google-Smtp-Source: AMrXdXvjwChlMHS5H8B+nZTZzYAyG0v2rCTA903uuf8elhv5SFqElhbNUTcVggb2NJ2jnMmnn4ENxVuiuCgw5g==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:e611:0:b0:4ff:b3a2:5962 with SMTP id
 p17-20020a0de611000000b004ffb3a25962mr3345889ywe.111.1674752035680; Thu, 26
 Jan 2023 08:53:55 -0800 (PST)
Date: Thu, 26 Jan 2023 16:53:46 +0000
In-Reply-To: <20230126165351.2561582-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230126165351.2561582-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126165351.2561582-2-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v4 1/6] arm: pmu: Fix overflow checks for
 PMUv3p5 long counters
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	oliver.upton@linux.dev, reijiw@google.com, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

PMUv3p5 uses 64-bit counters irrespective of whether the PMU is configured
for overflowing at 32 or 64-bits. The consequence is that tests that check
the counter values after overflowing should not assume that values will be
wrapped around 32-bits: they overflow into the other half of the 64-bit
counters on PMUv3p5.

Fix tests by correctly checking overflowing-counters against the expected
64-bit value.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/pmu.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index cd47b14..7f0794d 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -54,10 +54,10 @@
 #define EXT_COMMON_EVENTS_LOW	0x4000
 #define EXT_COMMON_EVENTS_HIGH	0x403F
 
-#define ALL_SET			0xFFFFFFFF
-#define ALL_CLEAR		0x0
-#define PRE_OVERFLOW		0xFFFFFFF0
-#define PRE_OVERFLOW2		0xFFFFFFDC
+#define ALL_SET			0x00000000FFFFFFFFULL
+#define ALL_CLEAR		0x0000000000000000ULL
+#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
+#define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
 
 #define PMU_PPI			23
 
@@ -419,6 +419,22 @@ static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events)
 	return true;
 }
 
+static uint64_t pmevcntr_mask(void)
+{
+	/*
+	 * Bits [63:0] are always incremented for 64-bit counters,
+	 * even if the PMU is configured to generate an overflow at
+	 * bits [31:0]
+	 *
+	 * For more details see the AArch64.IncrementEventCounter()
+	 * pseudo-code in the ARM ARM DDI 0487I.a, section J1.1.1.
+	 */
+	if (pmu.version >= ID_DFR0_PMU_V3_8_5)
+		return ~0;
+
+	return (uint32_t)~0;
+}
+
 static void test_basic_event_count(void)
 {
 	uint32_t implemented_counter_mask, non_implemented_counter_mask;
@@ -538,6 +554,7 @@ static void test_mem_access(void)
 static void test_sw_incr(void)
 {
 	uint32_t events[] = {SW_INCR, SW_INCR};
+	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
 	int i;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
@@ -572,9 +589,8 @@ static void test_sw_incr(void)
 		write_sysreg(0x3, pmswinc_el0);
 
 	isb();
-	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
-	report(read_regn_el0(pmevcntr, 1)  == 100,
-		"counter #0 after + 100 SW_INCR");
+	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
+	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
 	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 	report(read_sysreg(pmovsclr_el0) == 0x1,
@@ -625,6 +641,8 @@ static void test_chained_counters(void)
 static void test_chained_sw_incr(void)
 {
 	uint32_t events[] = {SW_INCR, CHAIN};
+	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
+	uint64_t cntr1 = (ALL_SET + 1) & pmevcntr_mask();
 	int i;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
@@ -666,9 +684,9 @@ static void test_chained_sw_incr(void)
 
 	isb();
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
2.39.1.456.gfc5497dd1b-goog

