Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A3015B0
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 01:07:39 +0000 (UTC)
Received: by mail-il1-f201.google.com with SMTP id k13-20020a92c24d000000b003127853ef5dso12373163ilo.5
        for <kvmarm@lists.linux.dev>; Tue, 14 Feb 2023 17:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E305a934JyKR6d0LbQnwDb1KLXy1uRhITDhO1feUNVQ=;
        b=I9xImCmVWCFNHbTSunyTqAaQSap8s5DCNhGLVbV7DgL0T5/D1hdtBQJhSlNOe0jyPF
         voYUROttsE9l9SnEr6HvowKBOJbe3Owouy9OMVDxedlEyBXWr5K1mib2fl7gRhdLO48L
         fnbPgDfuU6IyeV5gmtkDjhnSwbDWrRJiY/rOnl9/nyjQn/kkRiKJ7TrYIVTF4wF6Riqy
         H4EGjONPbs2vlw0XIQt4v1m1JZuOeQ5uTUSmzUK+wKvS/rdrVoM46iwXIui3VhOGipia
         XgImDP9+Y9tLkAorIZjdPiohqFBlpPbzSEPNJfNVZHgYBDc7MHB0TWhNYdEakb6KtRlu
         ToZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E305a934JyKR6d0LbQnwDb1KLXy1uRhITDhO1feUNVQ=;
        b=CxQZ46scaYxhbLYdojC0DwBnbb7kOPAuep0NkgJC++PZRMJ9dwMs9Ts/w6C/H40PTs
         BPCLWWCeiA4Lf3On6b+Zi8G1DU4bGHvxHniI90c3IPdTffeML3RV4U6zzDUWQde4TNi6
         DCRIa+fvgeuYFixfvXSCpIRy42JsZM+S3M+if/3aH8b470gNqmnAb1KTdtS2sL1UUZLC
         tMV3bBFIa7TXA9MTcoX36nUlEtQUuV49W8dqhQrTZ83cxBP9VodBtsO+/fEJ7k5bHiv6
         ig0IxGH+mUWL+tm4jEQpoJ6bT/Hs3hOSo9FLuYbpKj6iW74+Pmrh3uGvIZEb11GL3nC9
         yVsQ==
X-Gm-Message-State: AO0yUKUev+/oyY1oY3ZHIhaO1T1/RmKJrIX4eOcwrbUKZFgi6cU4/zmb
	GcRwmyAvLAu2yxw3J2XEyJ92R8FIvyXI
X-Google-Smtp-Source: AK7set+b4ssQzb8aMv+uSf2RmCPqXoTCRttRjQLG+i9Fm0UeKWjHu4LVoeyGHXP+DptEEnYx2/E5xZzWwpO6
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a6b:fb01:0:b0:71c:479d:741a with SMTP id
 h1-20020a6bfb01000000b0071c479d741amr332606iog.38.1676423258679; Tue, 14 Feb
 2023 17:07:38 -0800 (PST)
Date: Wed, 15 Feb 2023 01:07:15 +0000
In-Reply-To: <20230215010717.3612794-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010717.3612794-15-rananta@google.com>
Subject: [REPOST PATCH 14/16] selftests: KVM: aarch64: Add PMU test to chain
 all the counters
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

