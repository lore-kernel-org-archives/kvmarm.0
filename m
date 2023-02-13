Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A3AAD21
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 18:02:51 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id y125-20020a25c883000000b0086349255277so13151768ybf.8
        for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 10:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cRn8pqb+ZATFzovvOq02T9w/U2XDHj1IusmF+T0soEI=;
        b=Odev8Z6Kqs3GEhehIpX1NfnNvtpHcHO5P823Sx9vCSEvBaW+zpJ3MeA2k0DrQgW/hq
         qzZ0Hg7nt5uxsTCap5L4HuaZBZQTI3E1Zi5MUcXkCuJGIpYie9eqKdEIoyCQHFLzDhhG
         xlq5vIQJd3CcnFweyuBak5BSdKhSKWTI0i0kyNFGzwKtEuzFKbtmWbuUQceIbBCCHYyi
         kxFKKFTLFjxiMhp6TugfvW8TYUKvke2doRbaM8GV/h9rrqEyRRaZMrWlf3IqbBqhJGsH
         wTSTc75k7otoY5g1eF6K6WOJDyw2YWSdz0xPc0gMpyTcUXxLWhaGv9Wjfw3hc+h3rdFW
         vu0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cRn8pqb+ZATFzovvOq02T9w/U2XDHj1IusmF+T0soEI=;
        b=qDfAhsOKfGt7OAT5YmC1TmuuKrfvZyipV+vUo0u501WnBNrdUfYOA7taLxu0KMiSvK
         3LWZzmqw08ZwWJSoxJk9E7wv5KBA3tj6ixLwUc1iKm/My6Knz10WoOsizqn0eug/1cH5
         JiFQf17PEI0JSHhlRTZJqd4dWtMRzdaxctlP4+HfC5cL3VqxhsHmjTM5+VSVfM12/E5y
         1BAgC/ULY+c2n17IA27jjOq6zw2IezmaT8mtyj3+cQy/CVpQjmBr2Ck0rR4NQaraZItW
         BHVBeue7e2LtNRRm0hct9Yd6Jk71W23MXV3wqi3TJkSpfONEyMGVwC1kyAYxC3a/OZtm
         2a8w==
X-Gm-Message-State: AO0yUKWthZOkxAVGGyLWejNzsCnSOgNx1ZCqNBHNgaOZEjtJTKirQPYQ
	5HDS0LBDT71fQUNEfUBhXeSJM9d1rmU5
X-Google-Smtp-Source: AK7set8RHgzHP8c22NX4XX8rTz8mK48f2xqsC6kI1cPrwBMOEbu/WcXWtj02YO8LfVZHw/DkvQKxZKKZMH8A
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:690c:788:b0:52f:184a:da09 with SMTP id
 bw8-20020a05690c078800b0052f184ada09mr23ywb.2.1676311370417; Mon, 13 Feb 2023
 10:02:50 -0800 (PST)
Date: Mon, 13 Feb 2023 18:02:31 +0000
In-Reply-To: <20230213180234.2885032-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230213180234.2885032-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230213180234.2885032-11-rananta@google.com>
Subject: [PATCH 10/13] selftests: KVM: aarch64: Test chained events for PMU
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@google.com>, Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Extend the vPMU's vCPU migration test to validate
chained events, and their overflow conditions.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/aarch64/vpmu_test.c | 76 ++++++++++++++++++-
 1 file changed, 75 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
index 066dc17fa3906..de725f4339ad5 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
@@ -23,7 +23,7 @@
  * migrating the guest vCPU to random pCPUs in the system, and check
  * if the vPMU is still behaving as expected. The sub-tests include
  * testing basic functionalities such as basic counters behavior,
- * overflow, and overflow interrupts.
+ * overflow, overflow interrupts, and chained events.
  *
  * Copyright (c) 2022 Google LLC.
  *
@@ -61,6 +61,8 @@
 #define PRE_OVERFLOW_32		(GENMASK(31, 0) - COUNT_TO_OVERFLOW + 1)
 #define PRE_OVERFLOW_64		(GENMASK(63, 0) - COUNT_TO_OVERFLOW + 1)
 
+#define ALL_SET_64		GENMASK(63, 0)
+
 #define GICD_BASE_GPA	0x8000000ULL
 #define GICR_BASE_GPA	0x80A0000ULL
 
@@ -639,6 +641,75 @@ static void test_cycles_count(bool expect_count, bool test_overflow)
 	pmu_disable_reset();
 }
 
+static void test_chained_count(int pmc_idx)
+{
+	int i, chained_pmc_idx;
+	struct pmc_accessor *acc;
+	uint64_t pmcr_n, cnt, cntr_val;
+
+	/* The test needs at least two PMCs */
+	pmcr_n = get_pmcr_n();
+	GUEST_ASSERT_1(pmcr_n >= 2, pmcr_n);
+
+	/*
+	 * The chained counter's idx is always chained with (pmc_idx + 1).
+	 * pmc_idx should be even as the chained event doesn't count on
+	 * odd numbered counters.
+	 */
+	GUEST_ASSERT_1(pmc_idx % 2 == 0, pmc_idx);
+
+	/*
+	 * The max counter idx that the chained counter can occupy is
+	 * (pmcr_n - 1), while the actual event sits on (pmcr_n - 2).
+	 */
+	chained_pmc_idx = pmc_idx + 1;
+	GUEST_ASSERT(chained_pmc_idx < pmcr_n);
+
+	enable_counter(chained_pmc_idx);
+	pmu_irq_init(chained_pmc_idx);
+
+	/* Configure the chained event using all the possible ways*/
+	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
+		acc = &pmc_accessors[i];
+
+		/* Test if the chained counter increments when the base event overflows */
+
+		cntr_val = 1;
+		acc->write_cntr(chained_pmc_idx, cntr_val);
+		acc->write_typer(chained_pmc_idx, ARMV8_PMUV3_PERFCTR_CHAIN);
+
+		/* Chain the counter with pmc_idx that's configured for an overflow */
+		test_instructions_count(pmc_idx, true, true);
+
+		/*
+		 * pmc_idx is also configured to run for all the ARRAY_SIZE(pmc_accessors)
+		 * combinations. Hence, the chained chained_pmc_idx is expected to be
+		 * cntr_val + ARRAY_SIZE(pmc_accessors).
+		 */
+		cnt = acc->read_cntr(chained_pmc_idx);
+		GUEST_ASSERT_4(cnt == cntr_val + ARRAY_SIZE(pmc_accessors),
+				pmc_idx, i, cnt, cntr_val + ARRAY_SIZE(pmc_accessors));
+
+		/* Test for the overflow of the chained counter itself */
+
+		cntr_val = ALL_SET_64;
+		acc->write_cntr(chained_pmc_idx, cntr_val);
+
+		test_instructions_count(pmc_idx, true, true);
+
+		/*
+		 * At this point, an interrupt should've been fired for the chained
+		 * counter (which validates the overflow bit), and the counter should've
+		 * wrapped around to ARRAY_SIZE(pmc_accessors) - 1.
+		 */
+		cnt = acc->read_cntr(chained_pmc_idx);
+		GUEST_ASSERT_4(cnt == ARRAY_SIZE(pmc_accessors) - 1,
+				pmc_idx, i, cnt, ARRAY_SIZE(pmc_accessors));
+	}
+
+	pmu_irq_exit(chained_pmc_idx);
+}
+
 static void test_event_count(uint64_t event, int pmc_idx, bool expect_count)
 {
 	switch (event) {
@@ -665,6 +736,9 @@ static void test_basic_pmu_functionality(void)
 	/* Test overflow with interrupts on generic and cycle counters */
 	test_instructions_count(0, true, true);
 	test_cycles_count(true, true);
+
+	/* Test chained events */
+	test_chained_count(0);
 }
 
 /*
-- 
2.39.1.581.gbfd45094c4-goog

