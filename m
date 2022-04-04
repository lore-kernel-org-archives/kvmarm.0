Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B19FC4332F
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 21:46:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7AB14B2BC;
	Mon,  4 Apr 2022 17:46:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UYEAWd3SWVje; Mon,  4 Apr 2022 17:46:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC0C84B2BD;
	Mon,  4 Apr 2022 17:46:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA38B4B1D2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 17:46:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kFs0BgrE-dRk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 17:46:52 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EBC484B1C7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 17:46:51 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 oo16-20020a17090b1c9000b001c6d21e8c04so299183pjb.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2022 14:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=0Da54QmQhPyKSBpywHOsh755eaM//izhUjRyQA01ctw=;
 b=XG9czNznMGcfKiIl+XNBLnFq9gYuIbGgu/srSxcykchYxyNcgEjCouI7EjWMM1m8sg
 EtnSxq4Cl6wqHEkPoFJ492qPNOaRbJ+/XxP/BBHDNJ8hp2DIxtQ212KYyu1ucSWm2XQ7
 HWKCvaEB2jAQu3pZ/c09midtZzBib6caokg+2YzhzpA3RqJLG25oMxohBUxCDzWJhTOq
 3nyIp3FOWFOUzSamSGN2pSWBLM0q5noKSFgXBC8QEinYixPLWYE9QIWs9h1K4KYM9jyY
 Nv/edooPmXgeRlfP1OaFPf/pXtlkwjzeAbocN4rqaxj/TFVITfj179JicelnJw4kYZhG
 xsLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=0Da54QmQhPyKSBpywHOsh755eaM//izhUjRyQA01ctw=;
 b=AUUY8WjSG0ZFjD0dAqd0jRXRmzNWHACdwqy04o9KVZHw71kO7W6ZUUOBzm7BucDKcr
 nGzoONHiEPSYlOjDKtNIfWChl/l0M/+OYa1JpYsKt1uo7vSU3ytfnwjGtJ/Yp2R6Z0YX
 kFPTpGrMQcw7EGdzKXFAcKdkeZar9GRSTBO5OEJFHNnk3t5PYhaAYrFLCOqP8g3lAUB5
 eyzCzKUl0sPcDgx1CibIbRWZlkS5YZY237orb9yCz72nd5THoT1pa/FHExbDBH/vtp0A
 TijOzw4+TxKyt3ikjffwNVphVGxKoxht1eEhtDDD1MY/LGegmSg5tazvuwarXSVOmP1N
 F7mw==
X-Gm-Message-State: AOAM530vlQf9LdD6ReUXb15YzKqHrdSV5mqzwMi3df0EjZYpwte+clvM
 Z7iSVRoQ7I4diyG42pqyZ+hSht/TKYQOQg==
X-Google-Smtp-Source: ABdhPJznrg23OQjzBeXSFiYfrfxDtxSloiR8sIApdjlg8nZ6pmkGjqGeZmqBqj8j7t9bcbEpPCHqb5o2qr32Gw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:228f:b0:4fa:e4c9:7b3b with SMTP
 id f15-20020a056a00228f00b004fae4c97b3bmr148188pfe.61.1649108810982; Mon, 04
 Apr 2022 14:46:50 -0700 (PDT)
Date: Mon,  4 Apr 2022 14:46:41 -0700
In-Reply-To: <20220404214642.3201659-1-ricarkol@google.com>
Message-Id: <20220404214642.3201659-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220404214642.3201659-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v4 3/4] KVM: arm64: selftests: add arch_timer_edge_cases
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, pbonzini@redhat.com
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

Add an arch_timer edge-cases selftest. For now, just add some basic
sanity checks, and some stress conditions (like waiting for the timers
while re-scheduling the vcpu). The next commit will add the actual edge
case tests.

This test fails without a867e9d0cc1 "KVM: arm64: Don't miss pending
interrupts for suspended vCPU".

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/arch_timer_edge_cases.c       | 608 ++++++++++++++++++
 3 files changed, 610 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index dce7de7755e6..8f7e0123dd28 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 /aarch64/arch_timer
+/aarch64/arch_timer_edge_cases
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
 /aarch64/psci_cpu_on_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0e4926bc9a58..17a0f32cfc91 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -101,6 +101,7 @@ TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 
 TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
+TEST_GEN_PROGS_aarch64 += aarch64/arch_timer_edge_cases
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
new file mode 100644
index 000000000000..5f1e9c050b99
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
@@ -0,0 +1,608 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * arch_timer_edge_cases.c - Tests the aarch64 timer IRQ functionality.
+ *
+ * Some of these tests program timers and then wait indefinitely for them to
+ * fire.  We rely on having a timeout mechanism in the "runner", like
+ * tools/testing/selftests/kselftest/runner.sh.
+ *
+ * Copyright (c) 2022, Google LLC.
+ */
+
+#define _GNU_SOURCE
+
+#include <stdlib.h>
+#include <pthread.h>
+#include <linux/kvm.h>
+#include <linux/sizes.h>
+#include <linux/bitmap.h>
+#include <sched.h>
+#include <sys/sysinfo.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "delay.h"
+#include "arch_timer.h"
+#include "gic.h"
+#include "vgic.h"
+
+#define VCPUID				0
+
+#define CVAL_MAX			(~0ULL)
+/* tval is a signed 32-bit int. */
+#define TVAL_MAX			INT_MAX
+#define TVAL_MIN			INT_MIN
+
+#define GICD_BASE_GPA			0x8000000ULL
+#define GICR_BASE_GPA			0x80A0000ULL
+
+/* After how much time we say there is no IRQ. */
+#define TIMEOUT_NO_IRQ_US		(50 * 1000LL)
+
+/* A nice counter value to use as the starting one for most tests. */
+#define DEF_CNT				(CVAL_MAX / 2)
+
+/* Number of runs. */
+#define NR_TEST_ITERS_DEF		5
+
+/* Shared with IRQ handler. */
+volatile struct test_vcpu_shared_data {
+	int handled;
+} shared_data;
+
+struct test_args {
+	/* Virtual or physical timer and counter tests. */
+	enum arch_timer timer;
+	/* Number of iterations. */
+	int iterations;
+};
+
+struct test_args test_args = {
+	/* Only testing VIRTUAL timers for now. */
+	.timer = VIRTUAL,
+	.iterations = NR_TEST_ITERS_DEF,
+};
+
+static int vtimer_irq, ptimer_irq;
+
+enum sync_cmd {
+	SET_REG_KVM_REG_ARM_TIMER_CNT,
+	USERSPACE_SCHED_YIELD,
+	USERSPACE_MIGRATE_SELF,
+};
+
+typedef void (*wait_method_t)(void);
+
+static void wait_for_non_spurious_irq(void);
+static void wait_poll_for_irq(void);
+static void wait_sched_poll_for_irq(void);
+static void wait_migrate_poll_for_irq(void);
+
+wait_method_t wait_method[] = {
+	wait_for_non_spurious_irq,
+	wait_poll_for_irq,
+	wait_sched_poll_for_irq,
+	wait_migrate_poll_for_irq,
+};
+
+enum timer_view {
+	TIMER_CVAL,
+	TIMER_TVAL,
+};
+
+/* Pair of pcpus for the test to alternate between. */
+static int pcpus[2] = {-1, -1};
+static int pcpus_idx;
+
+static uint32_t next_pcpu(void)
+{
+	pcpus_idx = 1 - pcpus_idx;
+	return pcpus[pcpus_idx];
+}
+
+#define ASSERT_IRQS_HANDLED_2(__nr, arg1, arg2) do {				\
+	int __h = shared_data.handled;						\
+	GUEST_ASSERT_4(__h == (__nr), __h, __nr, arg1, arg2);			\
+} while (0)
+
+#define ASSERT_IRQS_HANDLED_1(__nr, arg1)					\
+	ASSERT_IRQS_HANDLED_2((__nr), arg1, 0)
+
+#define ASSERT_IRQS_HANDLED(__nr)						\
+	ASSERT_IRQS_HANDLED_2((__nr), 0, 0)
+
+#define SET_COUNTER(__ctr, __t)							\
+	GUEST_SYNC_ARGS(SET_REG_KVM_REG_ARM_TIMER_CNT, (__ctr), (__t), 0, 0)
+
+#define USERSPACE_CMD(__cmd)							\
+	GUEST_SYNC_ARGS(__cmd, 0, 0, 0, 0)
+
+#define USERSPACE_SCHEDULE()							\
+	USERSPACE_CMD(USERSPACE_SCHED_YIELD)
+
+#define USERSPACE_MIGRATE_VCPU()						\
+	USERSPACE_CMD(USERSPACE_MIGRATE_SELF)
+
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	unsigned int intid = gic_get_and_ack_irq();
+	uint64_t cnt, cval;
+	uint32_t ctl;
+
+	if (intid == IAR_SPURIOUS)
+		return;
+
+	GUEST_ASSERT(gic_irq_get_pending(intid));
+
+	ctl = timer_get_ctl(test_args.timer);
+	cnt = timer_get_cntct(test_args.timer);
+	cval = timer_get_cval(test_args.timer);
+
+	GUEST_ASSERT_1(ctl & CTL_ISTATUS, ctl);
+
+	/* Disable and mask the timer. */
+	timer_set_ctl(test_args.timer, CTL_IMASK);
+	GUEST_ASSERT(!gic_irq_get_pending(intid));
+
+	shared_data.handled++;
+
+	/* The IRQ should not fire before time. */
+	GUEST_ASSERT_2(cnt >= cval, cnt, cval);
+
+	gic_set_eoi(intid);
+}
+
+/*
+ * Sleep for usec microseconds by polling in the guest (userspace=0) or in
+ * userspace (e.g., userspace=1 and userspace_cmd=USERSPACE_SCHEDULE).
+ */
+static void guest_poll(enum arch_timer timer, uint64_t usec,
+		bool userspace, enum sync_cmd userspace_cmd)
+{
+	uint64_t cycles = usec_to_cycles(usec);
+	uint64_t start = timer_get_cntct(timer);
+
+	/*
+	 * TODO: Take care of roll-overs. Right now, we are fine as we use the
+	 * virtual timer/counter for all of our roll-over tests, and so we can use
+	 * the physical counter for this function. Assert this (temporarily):
+	 */
+	GUEST_ASSERT(test_args.timer == VIRTUAL && timer == PHYSICAL);
+
+	while ((timer_get_cntct(timer) - start) < cycles) {
+		if (userspace)
+			USERSPACE_CMD(userspace_cmd);
+		else
+			cpu_relax();
+	}
+}
+
+static void sleep_poll(uint64_t usec)
+{
+	if (test_args.timer == VIRTUAL)
+		guest_poll(PHYSICAL, usec, false, -1);
+	else
+		GUEST_ASSERT(0); /* Not implemented. */
+}
+
+static void program_timer_irq(uint64_t xval, uint32_t ctl, enum timer_view tv)
+{
+	shared_data.handled = 0;
+
+	switch (tv) {
+	case TIMER_CVAL:
+		timer_set_cval(test_args.timer, xval);
+		timer_set_ctl(test_args.timer, ctl);
+		break;
+	case TIMER_TVAL:
+		timer_set_tval(test_args.timer, xval);
+		timer_set_ctl(test_args.timer, ctl);
+		break;
+	default:
+		GUEST_ASSERT(0);
+	}
+}
+
+/*
+ * Should be called with IRQs masked.
+ */
+static void wait_for_non_spurious_irq(void)
+{
+	int h = shared_data.handled;
+
+	/* Wait for the IRQ handler to process an interrupt */
+	while (h == shared_data.handled) {
+		asm volatile("wfi\n"
+			     "msr daifclr, #2\n"
+			     /* handle IRQ */
+			     "isb\n"
+			     "msr daifset, #2\n"
+			     : : : "memory");
+	}
+}
+
+/*
+ * Wait for an non-spurious IRQ by polling in the guest (userspace=0) or in
+ * userspace (e.g., userspace=1 and userspace_cmd=USERSPACE_SCHED_YIELD).
+ *
+ * Should be called with IRQs masked. Not really needed like the wfi above, but
+ * it should match the others.
+ */
+static void poll_for_non_spurious_irq(bool userspace,
+		enum sync_cmd userspace_cmd)
+{
+	int h;
+
+	h = shared_data.handled;
+
+	local_irq_enable();
+	while (h == shared_data.handled) {
+		if (userspace)
+			USERSPACE_CMD(userspace_cmd);
+		else
+			cpu_relax();
+	}
+	local_irq_disable();
+}
+
+static void wait_poll_for_irq(void)
+{
+	poll_for_non_spurious_irq(false, -1);
+}
+
+static void wait_sched_poll_for_irq(void)
+{
+	poll_for_non_spurious_irq(true, USERSPACE_SCHED_YIELD);
+}
+
+static void wait_migrate_poll_for_irq(void)
+{
+	poll_for_non_spurious_irq(true, USERSPACE_MIGRATE_SELF);
+}
+
+/*
+ * Reset the timer state to some nice values like the counter not being close
+ * to the edge, and the control register masked and disabled.
+ */
+static void reset_timer_state(uint64_t cnt)
+{
+	SET_COUNTER(cnt, test_args.timer);
+	timer_set_ctl(test_args.timer, CTL_IMASK);
+}
+
+static void test_timer(uint64_t reset_cnt, uint64_t xval,
+		wait_method_t wm, enum timer_view tv)
+{
+	local_irq_disable();
+
+	reset_timer_state(reset_cnt);
+
+	program_timer_irq(xval, CTL_ENABLE, tv);
+	wm();
+
+	ASSERT_IRQS_HANDLED_1(1, tv);
+	local_irq_enable();
+}
+
+static void test_basic_functionality(void)
+{
+	int32_t tval = (int32_t)msec_to_cycles(10);
+	uint64_t cval;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(wait_method); i++) {
+		wait_method_t wm = wait_method[i];
+
+		cval = DEF_CNT + msec_to_cycles(10);
+
+		test_timer(DEF_CNT, cval, wm, TIMER_CVAL);
+		test_timer(DEF_CNT, tval, wm, TIMER_TVAL);
+	}
+}
+
+/*
+ * This test checks basic timer behavior without actually firing timers, things
+ * like: the relationship between cval and tval, tval down-counting.
+ */
+static void timers_sanity_checks(bool use_sched)
+{
+	uint64_t cval;
+
+	reset_timer_state(DEF_CNT);
+
+	local_irq_disable();
+
+	/* cval in the past */
+	timer_set_cval(test_args.timer, timer_get_cntct(test_args.timer) - 1);
+	if (use_sched)
+		USERSPACE_SCHEDULE();
+	GUEST_ASSERT(timer_get_tval(test_args.timer) < 0);
+
+	/* tval in the past */
+	timer_set_tval(test_args.timer, -1);
+	if (use_sched)
+		USERSPACE_SCHEDULE();
+	GUEST_ASSERT(timer_get_cval(test_args.timer) <
+			timer_get_cntct(test_args.timer));
+
+	/* tval larger than TVAL_MAX. */
+	cval = timer_get_cntct(test_args.timer) + 2ULL * TVAL_MAX - 1;
+	timer_set_cval(test_args.timer, cval);
+	if (use_sched)
+		USERSPACE_SCHEDULE();
+	GUEST_ASSERT(timer_get_tval(test_args.timer) <= 0);
+	GUEST_ASSERT_EQ(cval, timer_get_cval(test_args.timer));
+
+	/* tval should keep down-counting from 0 to -1. */
+	SET_COUNTER(DEF_CNT, test_args.timer);
+	timer_set_tval(test_args.timer, 0);
+	if (use_sched)
+		USERSPACE_SCHEDULE();
+	/* We just need 1 counter tick to pass. */
+	sleep_poll(1);
+	GUEST_ASSERT(timer_get_tval(test_args.timer) < 0);
+
+	local_irq_enable();
+
+	/* Mask and disable any pending timer. */
+	timer_set_ctl(test_args.timer, CTL_IMASK);
+}
+
+static void test_timers_sanity_checks(void)
+{
+	timers_sanity_checks(false);
+	/* Check how KVM saves/restores these edge-case values. */
+	timers_sanity_checks(true);
+}
+
+static void guest_run_iteration(void)
+{
+	test_timers_sanity_checks();
+	test_basic_functionality();
+}
+
+static void guest_code(void)
+{
+	int i;
+
+	local_irq_disable();
+
+	gic_init(GIC_V3, 1, (void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
+
+	timer_set_ctl(test_args.timer, CTL_IMASK);
+	timer_set_ctl(PHYSICAL, CTL_IMASK);
+
+	gic_irq_enable(vtimer_irq);
+	gic_irq_enable(ptimer_irq);
+	local_irq_enable();
+
+	for (i = 0; i < test_args.iterations; i++) {
+		GUEST_SYNC(i);
+		guest_run_iteration();
+	}
+
+	GUEST_DONE();
+}
+
+static void migrate_self(uint32_t new_pcpu)
+{
+	int ret;
+	cpu_set_t cpuset;
+	pthread_t thread;
+
+	thread = pthread_self();
+
+	CPU_ZERO(&cpuset);
+	CPU_SET(new_pcpu, &cpuset);
+
+	pr_debug("Migrating from %u to %u\n", sched_getcpu(), new_pcpu);
+
+	ret = pthread_setaffinity_np(thread, sizeof(cpuset), &cpuset);
+
+	TEST_ASSERT(ret == 0, "Failed to migrate to pCPU: %u; ret: %d\n",
+			new_pcpu, ret);
+}
+
+/*
+ * Set the two pcpus that the test will use to alternate between. Default to
+ * use the current cpu as pcpus[0] and the one right after in the affinity set
+ * as pcpus[1].
+ */
+static void set_default_pcpus(void)
+{
+	int curr = sched_getcpu();
+	cpu_set_t cpuset;
+	long i;
+
+	pcpus[0] = curr;
+
+	sched_getaffinity(getpid(), sizeof(cpu_set_t), &cpuset);
+	for (i = (curr + 1) % CPU_SETSIZE; i != curr; i = (i + 1) % CPU_SETSIZE) {
+		if (CPU_ISSET(i, &cpuset)) {
+			pcpus[1] = i;
+			break;
+		}
+	}
+
+	TEST_ASSERT(pcpus[1] != -1, "Couldn't find a second pcpu.");
+	pr_debug("pcpus: %d %d\n", pcpus[0], pcpus[1]);
+}
+
+static void kvm_set_cntxct(struct kvm_vm *vm, uint64_t cnt, enum arch_timer timer)
+{
+	TEST_ASSERT(timer == VIRTUAL,
+		"Only supports setting the virtual counter for now.");
+
+	struct kvm_one_reg reg = {
+		.id = KVM_REG_ARM_TIMER_CNT,
+		.addr = (uint64_t)&cnt,
+	};
+	vcpu_set_reg(vm, 0, &reg);
+}
+
+static void handle_sync(struct kvm_vm *vm, struct ucall *uc)
+{
+	enum sync_cmd cmd = uc->args[1];
+	uint64_t val = uc->args[2];
+	enum arch_timer timer = uc->args[3];
+
+	switch (cmd) {
+	case SET_REG_KVM_REG_ARM_TIMER_CNT:
+		kvm_set_cntxct(vm, val, timer);
+		break;
+	case USERSPACE_SCHED_YIELD:
+		sched_yield();
+		break;
+	case USERSPACE_MIGRATE_SELF:
+		migrate_self(next_pcpu());
+		break;
+	default:
+		break;
+	}
+}
+
+static void test_run(struct kvm_vm *vm)
+{
+	struct ucall uc;
+	int stage = 0;
+
+	/* Start on the first pcpu. */
+	migrate_self(pcpus[0]);
+
+	sync_global_to_guest(vm, test_args);
+
+	for (stage = 0; ; stage++) {
+		vcpu_run(vm, VCPUID);
+		switch (get_ucall(vm, VCPUID, &uc)) {
+		case UCALL_SYNC:
+			handle_sync(vm, &uc);
+			break;
+		case UCALL_DONE:
+			goto out;
+		case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld\n\tvalues: %lu, %lu; %lu",
+				(const char *)uc.args[0], __FILE__, uc.args[1],
+				uc.args[2], uc.args[3], uc.args[4]);
+			goto out;
+		default:
+			TEST_FAIL("Unexpected guest exit\n");
+		}
+	}
+
+out:
+	return;
+}
+
+static void test_init_timer_irq(struct kvm_vm *vm)
+{
+	int vcpu_fd = vcpu_get_fd(vm, VCPUID);
+
+	kvm_device_access(vcpu_fd, KVM_ARM_VCPU_TIMER_CTRL,
+			KVM_ARM_VCPU_TIMER_IRQ_PTIMER, &ptimer_irq, false);
+	kvm_device_access(vcpu_fd, KVM_ARM_VCPU_TIMER_CTRL,
+			KVM_ARM_VCPU_TIMER_IRQ_VTIMER, &vtimer_irq, false);
+
+	sync_global_to_guest(vm, ptimer_irq);
+	sync_global_to_guest(vm, vtimer_irq);
+
+	pr_debug("ptimer_irq: %d; vtimer_irq: %d\n", ptimer_irq, vtimer_irq);
+}
+
+static struct kvm_vm *test_vm_create(void)
+{
+	struct kvm_vm *vm;
+	int ret;
+
+	vm = vm_create_default(VCPUID, 0, guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, guest_irq_handler);
+
+	vcpu_init_descriptor_tables(vm, 0);
+
+	ucall_init(vm, NULL);
+	test_init_timer_irq(vm);
+	ret = vgic_v3_setup(vm, 1, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+	if (ret < 0) {
+		print_skip("Failed to create vgic-v3");
+		exit(KSFT_SKIP);
+	}
+
+	return vm;
+}
+
+static void test_print_help(char *name)
+{
+	pr_info("Usage: %s [-h] [-i iterations] [-w] [-p pcpu1,pcpu2]\n",
+		name);
+	pr_info("\t-i: Number of iterations (default: %u)\n",
+		NR_TEST_ITERS_DEF);
+	pr_info("\t-p: Pair of pcpus for the vcpus to alternate between.\n");
+	pr_info("\t-h: Print this help message\n");
+}
+
+static bool parse_args(int argc, char *argv[])
+{
+	int opt, ret;
+
+	while ((opt = getopt(argc, argv, "hi:p:")) != -1) {
+		switch (opt) {
+		case 'i':
+			test_args.iterations = atoi(optarg);
+			if (test_args.iterations <= 0) {
+				print_skip("Positive value needed for -i");
+				goto err;
+			}
+			break;
+		case 'p':
+			ret = sscanf(optarg, "%u,%u", &pcpus[0], &pcpus[1]);
+			if (ret != 2) {
+				print_skip("Could not parse the pcpus string");
+				goto err;
+			}
+			if (!is_cpu_eligible_to_run(pcpus[0])) {
+				print_skip("Invalid pcpu %d", pcpus[0]);
+				goto err;
+			}
+			if (!is_cpu_eligible_to_run(pcpus[1])) {
+				print_skip("Invalid pcpu %d", pcpus[1]);
+				goto err;
+			}
+			break;
+		case 'h':
+		default:
+			goto err;
+		}
+	}
+
+	return true;
+
+err:
+	test_print_help(argv[0]);
+	return false;
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+
+	/* Tell stdout not to buffer its content */
+	setbuf(stdout, NULL);
+
+	if (!parse_args(argc, argv))
+		exit(KSFT_SKIP);
+
+	if (get_nprocs() < 2) {
+		print_skip("Need at least 2 online pcpus");
+		exit(KSFT_SKIP);
+	}
+
+	if (pcpus[0] == -1 || pcpus[1] == -1)
+		set_default_pcpus();
+
+	vm = test_vm_create();
+	test_run(vm);
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
