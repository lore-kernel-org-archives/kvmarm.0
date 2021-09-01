Return-Path: <SRS0=uZLN=NX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4428C432BE
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 21:15:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5585B60FDC
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 21:15:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5585B60FDC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 075534B136;
	Wed,  1 Sep 2021 17:15:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iIaGSE1ZBWBN; Wed,  1 Sep 2021 17:15:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DFAD4B149;
	Wed,  1 Sep 2021 17:15:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2D024B191
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 17:15:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zcGGcker27at for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Sep 2021 17:15:01 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 51E6F4B160
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 17:14:49 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 ne16-20020a17090b375000b0018f4f0ba3fbso262491pjb.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Sep 2021 14:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=WG0Fg/Yf+a11z7ESLkqU5iQE0sXU2MSi6aUV/LVfUZw=;
 b=Fku6usIivlbptUqnUNKQ0v8l7RlTIYoQtevPGUFobKjPmZRWSwQ064olfLL/Qas4HL
 Z1qqnf3VZiDLfYxUOpc9pR7TuaVGp02hVQ9VvlxOyDKaJXQnLVtrorlzY1H7eVzh73CL
 0eNx3EydGh8xiaeWztLNghUqSt6QJrnzdmouO6z8+Jl/Xgs4oyTSKkuWR+ZviJ3G/PCC
 1dpIU8731qLTxdK6B/B4D6S6ZfHODp9aPyNf1P3fPgD7IR4XejcpU5FUrDT/ve0aqnCw
 M0MXQegNOqg0Jijov3TK18134xhWs22DzO2Hk/rXRamIDK4tokxZAIT83T5yqiTw66vk
 5ncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=WG0Fg/Yf+a11z7ESLkqU5iQE0sXU2MSi6aUV/LVfUZw=;
 b=W/YxMAehVglEMeu13yO5PQKEVzw+2oF0yDzvHkOATlbdYUly62dfrTA3bIq55nDB6o
 xfeRX6QNHOUgJoAgvclR6EVJtpDrIWow6AnOw+08Yla6MfUVpiNhiEiJvQIpnj1DUgTp
 /fcDRDt4IF9PTGdcb3ty5qlXumjazrCDvN9tEtIuH6Ldzb8elVC1J0B4wo6HPi8L9qhF
 UP4T02jLTLbl2LyCbM0mXRqyfYXcGiapR2IL7lYSKd3ovtU1jMNLzoYBzF/S6wlk2lR4
 VcloyfcMXtE4XyZZvMPnVrR13eoI98wA/cXOvT0BBM0DdeDTiGPD+YEpXXBfSJ3mWAt7
 s8Fg==
X-Gm-Message-State: AOAM5333VpWdQEiW/RL9O70MZGlhiBSzVLSnvaB4/t6nH1pqw1EUFvPT
 +ctnoHCZMkaTEpSI3oCAnNZbb6kZ/jtB
X-Google-Smtp-Source: ABdhPJyLwKx++f51vmUbjpY9Z8DI9cb27LEwjBp0tPaXfU+HpIg1XRabm5+K56DHo3WKL5KJLIyEVcbTkuvm
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:ec8:: with SMTP id
 gz8mr1417499pjb.41.1630530888390; Wed, 01 Sep 2021 14:14:48 -0700 (PDT)
Date: Wed,  1 Sep 2021 21:14:12 +0000
In-Reply-To: <20210901211412.4171835-1-rananta@google.com>
Message-Id: <20210901211412.4171835-13-rananta@google.com>
Mime-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v3 12/12] KVM: arm64: selftests: arch_timer: Support vCPU
 migration
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Since the timer stack (hardware and KVM) is per-CPU, there
are potential chances for races to occur when the scheduler
decides to migrate a vCPU thread to a different physical CPU.
Hence, include an option to stress-test this part as well by
forcing the vCPUs to migrate across physical CPUs in the
system at a particular rate.

Originally, the bug for the fix with commit 3134cc8beb69d0d
("KVM: arm64: vgic: Resample HW pending state on deactivation")
was discovered using arch_timer test with vCPU migrations and
can be easily reproduced.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/aarch64/arch_timer.c        | 108 +++++++++++++++++-
 1 file changed, 107 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 1383f33850e9..de246c7afab2 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -14,6 +14,8 @@
  *
  * The test provides command-line options to configure the timer's
  * period (-p), number of vCPUs (-n), and iterations per stage (-i).
+ * To stress-test the timer stack even more, an option to migrate the
+ * vCPUs across pCPUs (-m), at a particular rate, is also provided.
  *
  * Copyright (c) 2021, Google LLC.
  */
@@ -24,6 +26,8 @@
 #include <pthread.h>
 #include <linux/kvm.h>
 #include <linux/sizes.h>
+#include <linux/bitmap.h>
+#include <sys/sysinfo.h>
 
 #include "kvm_util.h"
 #include "processor.h"
@@ -41,12 +45,14 @@ struct test_args {
 	int nr_vcpus;
 	int nr_iter;
 	int timer_period_ms;
+	int migration_freq_ms;
 };
 
 static struct test_args test_args = {
 	.nr_vcpus = NR_VCPUS_DEF,
 	.nr_iter = NR_TEST_ITERS_DEF,
 	.timer_period_ms = TIMER_TEST_PERIOD_MS_DEF,
+	.migration_freq_ms = 0,		/* Turn off migrations by default */
 };
 
 #define msecs_to_usecs(msec)		((msec) * 1000LL)
@@ -81,6 +87,9 @@ struct test_vcpu {
 static struct test_vcpu test_vcpu[KVM_MAX_VCPUS];
 static struct test_vcpu_shared_data vcpu_shared_data[KVM_MAX_VCPUS];
 
+static unsigned long *vcpu_done_map;
+static pthread_mutex_t vcpu_done_map_lock;
+
 static void
 guest_configure_timer_action(struct test_vcpu_shared_data *shared_data)
 {
@@ -216,6 +225,11 @@ static void *test_vcpu_run(void *arg)
 
 	vcpu_run(vm, vcpuid);
 
+	/* Currently, any exit from guest is an indication of completion */
+	pthread_mutex_lock(&vcpu_done_map_lock);
+	set_bit(vcpuid, vcpu_done_map);
+	pthread_mutex_unlock(&vcpu_done_map_lock);
+
 	switch (get_ucall(vm, vcpuid, &uc)) {
 	case UCALL_SYNC:
 	case UCALL_DONE:
@@ -235,9 +249,73 @@ static void *test_vcpu_run(void *arg)
 	return NULL;
 }
 
+static uint32_t test_get_pcpu(void)
+{
+	uint32_t pcpu;
+	unsigned int nproc_conf;
+	cpu_set_t online_cpuset;
+
+	nproc_conf = get_nprocs_conf();
+	sched_getaffinity(0, sizeof(cpu_set_t), &online_cpuset);
+
+	/* Randomly find an available pCPU to place a vCPU on */
+	do {
+		pcpu = rand() % nproc_conf;
+	} while (!CPU_ISSET(pcpu, &online_cpuset));
+
+	return pcpu;
+}
+static int test_migrate_vcpu(struct test_vcpu *vcpu)
+{
+	int ret;
+	cpu_set_t cpuset;
+	uint32_t new_pcpu = test_get_pcpu();
+
+	CPU_ZERO(&cpuset);
+	CPU_SET(new_pcpu, &cpuset);
+	ret = pthread_setaffinity_np(vcpu->pt_vcpu_run,
+					sizeof(cpuset), &cpuset);
+
+	/* Allow the error where the vCPU thread is already finished */
+	TEST_ASSERT(ret == 0 || ret == ESRCH,
+			"Failed to migrate the vCPU:%u to pCPU: %u; ret: %d\n",
+			vcpu->vcpuid, new_pcpu, ret);
+
+	return ret;
+}
+static void *test_vcpu_migration(void *arg)
+{
+	unsigned int i, n_done;
+	bool vcpu_done;
+
+	do {
+		usleep(msecs_to_usecs(test_args.migration_freq_ms));
+
+		for (n_done = 0, i = 0; i < test_args.nr_vcpus; i++) {
+			pthread_mutex_lock(&vcpu_done_map_lock);
+			vcpu_done = test_bit(i, vcpu_done_map);
+			pthread_mutex_unlock(&vcpu_done_map_lock);
+
+			if (vcpu_done) {
+				n_done++;
+				continue;
+			}
+
+			test_migrate_vcpu(&test_vcpu[i]);
+		}
+	} while (test_args.nr_vcpus != n_done);
+
+	return NULL;
+}
+
 static void test_run(struct kvm_vm *vm)
 {
 	int i, ret;
+	pthread_t pt_vcpu_migration;
+
+	pthread_mutex_init(&vcpu_done_map_lock, NULL);
+	vcpu_done_map = bitmap_alloc(test_args.nr_vcpus);
+	TEST_ASSERT(vcpu_done_map, "Failed to allocate vcpu done bitmap\n");
 
 	for (i = 0; i < test_args.nr_vcpus; i++) {
 		ret = pthread_create(&test_vcpu[i].pt_vcpu_run, NULL,
@@ -245,8 +323,23 @@ static void test_run(struct kvm_vm *vm)
 		TEST_ASSERT(!ret, "Failed to create vCPU-%d pthread\n", i);
 	}
 
+	/* Spawn a thread to control the vCPU migrations */
+	if (test_args.migration_freq_ms) {
+		srand(time(NULL));
+
+		ret = pthread_create(&pt_vcpu_migration, NULL,
+					test_vcpu_migration, NULL);
+		TEST_ASSERT(!ret, "Failed to create the migration pthread\n");
+	}
+
+
 	for (i = 0; i < test_args.nr_vcpus; i++)
 		pthread_join(test_vcpu[i].pt_vcpu_run, NULL);
+
+	if (test_args.migration_freq_ms)
+		pthread_join(pt_vcpu_migration, NULL);
+
+	bitmap_free(vcpu_done_map);
 }
 
 static struct kvm_vm *test_vm_create(void)
@@ -286,6 +379,7 @@ static void test_print_help(char *name)
 		NR_TEST_ITERS_DEF);
 	pr_info("\t-p: Periodicity (in ms) of the guest timer (default: %u)\n",
 		TIMER_TEST_PERIOD_MS_DEF);
+	pr_info("\t-m: Frequency (in ms) of vCPUs to migrate to different pCPU. 0 to turn off (default: 0)\n");
 	pr_info("\t-h: print this help screen\n");
 }
 
@@ -293,7 +387,7 @@ static bool parse_args(int argc, char *argv[])
 {
 	int opt;
 
-	while ((opt = getopt(argc, argv, "hn:i:p:")) != -1) {
+	while ((opt = getopt(argc, argv, "hn:i:p:m:")) != -1) {
 		switch (opt) {
 		case 'n':
 			test_args.nr_vcpus = atoi(optarg);
@@ -320,6 +414,13 @@ static bool parse_args(int argc, char *argv[])
 				goto err;
 			}
 			break;
+		case 'm':
+			test_args.migration_freq_ms = atoi(optarg);
+			if (test_args.migration_freq_ms < 0) {
+				pr_info("0 or positive value needed for -m\n");
+				goto err;
+			}
+			break;
 		case 'h':
 		default:
 			goto err;
@@ -343,6 +444,11 @@ int main(int argc, char *argv[])
 	if (!parse_args(argc, argv))
 		exit(KSFT_SKIP);
 
+	if (get_nprocs() < 2) {
+		print_skip("At least two physical CPUs needed for vCPU migration");
+		exit(KSFT_SKIP);
+	}
+
 	vm = test_vm_create();
 	test_run(vm);
 	kvm_vm_free(vm);
-- 
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
