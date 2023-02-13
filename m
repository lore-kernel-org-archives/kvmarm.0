Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B719AA959
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 18:02:52 +0000 (UTC)
Received: by mail-il1-f202.google.com with SMTP id r8-20020a92cd88000000b00313f4759a73so9894542ilb.9
        for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 10:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E305a934JyKR6d0LbQnwDb1KLXy1uRhITDhO1feUNVQ=;
        b=klshuBOzJGsDndpswreQ0XlinbMaJK4kRqAQ+37wZY8lmbOhHgx/ZdZOFpaN1lJ6Yy
         GKSvylJPXQGCRQtm8PG+CoJXz3i/KEj97JV/Ab045b8U+Wj43GYkWufOUVvppWmGFm0v
         WaQbsZTE/P4Putg06m5v8Od47rRyUpcHCvrxvuzKG+FvCNge/NQA8/pfj9YEQUHWkd1n
         t1T8Jk93C0yORnKG07Q1162qgwKRkb9xUo9DJnwrkywAG4Rmh/eaGJg6ea6LmI7s1gpt
         sHUJKKq/+DnRWgfVNv9ltO9gOAFPNz18MlmUrWzqIN8X8XsBaKgJsikEtqscWqdJj/h9
         2Zgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E305a934JyKR6d0LbQnwDb1KLXy1uRhITDhO1feUNVQ=;
        b=hOUDnmCl68X4fE1ifw7da1Rr3eR0VeC3Nl80bi6v7erqoNewgRa4z+4aiHicFJ+sfx
         8wxfgB4CkDpGMUdNVRirJeFNHmwnUO0nj6aPTdbd6ODISL/LqnraO+SrLlSAOrh8Y3RM
         AZ9rNLhQscth36JmLP8bZKg5Dc4BPGj1E9pOPOcXUznhmZky7QxD9oRUlLCnYkAKooiZ
         dxVdK0JF0gnYwKMB/fq9pUn8rzt0qOQTIxNqCCIdsMhdaenpcSqWS1urZ5GfFfdJh9Nk
         F1KWenX/M84Be5Mm13BPz6fNvJ3QanbIh4x0ndof7elqAtofXO7L4PnyuM65ilsS5BMB
         HuWg==
X-Gm-Message-State: AO0yUKWb/LuyyliM6Hkzvc7Er1H8ug9u0pyhElcR/ww1bfjSpcJrsAHw
	lfa6BdrQpwek5/WMJw2CV9nzcJk/gTw4
X-Google-Smtp-Source: AK7set9XcTIYijLiXD+fG0978y9t+ze0/330Z/53BuCCPZ7jl1ZgND52wYhOh70n0GJQrhaPSQBmbepj7EJS
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6638:d0c:b0:3a7:e46f:1018 with SMTP id
 q12-20020a0566380d0c00b003a7e46f1018mr113jaj.2.1676311371815; Mon, 13 Feb
 2023 10:02:51 -0800 (PST)
Date: Mon, 13 Feb 2023 18:02:32 +0000
In-Reply-To: <20230213180234.2885032-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230213180234.2885032-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230213180234.2885032-12-rananta@google.com>
Subject: [PATCH 11/13] selftests: KVM: aarch64: Add PMU test to chain all the counters
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@google.com>, Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Extend the vCPU migration test to occupy all the vPMU counters,
by configuring chained events on alternate counter-ids and chaining
them with its corresponding predecessor counter, and verify against
the extended behavior.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/aarch64/vpmu_test.c | 60 +++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
index de725f4339ad5..fd00acb9391c8 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
@@ -710,6 +710,63 @@ static void test_chained_count(int pmc_idx)
 	pmu_irq_exit(chained_pmc_idx);
 }
 
+static void test_chain_all_counters(void)
+{
+	int i;
+	uint64_t cnt, pmcr_n = get_pmcr_n();
+	struct pmc_accessor *acc = &pmc_accessors[0];
+
+	/*
+	 * Test the occupancy of all the event counters, by chaining the
+	 * alternate counters. The test assumes that the host hasn't
+	 * occupied any counters. Hence, if the test fails, it could be
+	 * because all the counters weren't available to the guest or
+	 * there's actually a bug in KVM.
+	 */
+
+	/*
+	 * Configure even numbered counters to count cpu-cycles, and chain
+	 * each of them with its odd numbered counter.
+	 */
+	for (i = 0; i < pmcr_n; i++) {
+		if (i % 2) {
+			acc->write_typer(i, ARMV8_PMUV3_PERFCTR_CHAIN);
+			acc->write_cntr(i, 1);
+		} else {
+			pmu_irq_init(i);
+			acc->write_cntr(i, PRE_OVERFLOW_32);
+			acc->write_typer(i, ARMV8_PMUV3_PERFCTR_CPU_CYCLES);
+		}
+		enable_counter(i);
+	}
+
+	/* Introduce some cycles */
+	execute_precise_instrs(500, ARMV8_PMU_PMCR_E);
+
+	/*
+	 * An overflow interrupt should've arrived for all the even numbered
+	 * counters but none for the odd numbered ones. The odd numbered ones
+	 * should've incremented exactly by 1.
+	 */
+	for (i = 0; i < pmcr_n; i++) {
+		if (i % 2) {
+			GUEST_ASSERT_1(!pmu_irq_received(i), i);
+
+			cnt = acc->read_cntr(i);
+			GUEST_ASSERT_2(cnt == 2, i, cnt);
+		} else {
+			GUEST_ASSERT_1(pmu_irq_received(i), i);
+		}
+	}
+
+	/* Cleanup the states */
+	for (i = 0; i < pmcr_n; i++) {
+		if (i % 2 == 0)
+			pmu_irq_exit(i);
+		disable_counter(i);
+	}
+}
+
 static void test_event_count(uint64_t event, int pmc_idx, bool expect_count)
 {
 	switch (event) {
@@ -739,6 +796,9 @@ static void test_basic_pmu_functionality(void)
 
 	/* Test chained events */
 	test_chained_count(0);
+
+	/* Test running chained events on all the implemented counters */
+	test_chain_all_counters();
 }
 
 /*
-- 
2.39.1.581.gbfd45094c4-goog

