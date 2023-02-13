Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3D2AD20
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 18:02:49 +0000 (UTC)
Received: by mail-il1-f201.google.com with SMTP id s8-20020a056e0210c800b003155720bbbfso382153ilj.22
        for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 10:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NBYdz/0TDvO7IvfPjxUDSlCbo4CB4F+r8/XPr+qUWDQ=;
        b=q/9pkLp04O+q0/h8HqWtbW0b4VJCwyM93nDv77GqvjJ6CZ4Czxpm5H8d/lDlpTXsCj
         Lxw6nGE3jZxgA/Lo2HUBZdf5EE0qjSxvUgHGZW6o0+9e+HkhvQpiHgZdToFd+AbKHIFB
         A5CHSl5TSlCOZjqQlpxD5e5wkvR8X/0b6YcT5jL/nTql/+HqHR7svK3rwtTT1Y+ZTR7R
         GJ/moeEEW6KXP6NWUNqTjcT4/YBd1FC1rP0DUY32WTXTIIVoTMVTv09vwSp4CKIUlMXE
         jaIuuptu376OmVIHLWwwSlFCwuNah5pfd60Cn7DxqT17NURWdErBO2ZYOWNiy3gYm9fN
         UGog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NBYdz/0TDvO7IvfPjxUDSlCbo4CB4F+r8/XPr+qUWDQ=;
        b=MbfBksQgSw58KSQZ5RvuWGL2SIjvXbSFirklHuMjArbnwTHsIeiK11TS9pNgtO/+ar
         UVWU7v5DxK+nOloZdjPamAqsmFj+mHtcGwd0rMmtLA5LfPVFA9Mm5RjMB6GW4oGWQOMC
         p/3e46Wru3hTEozPOi9YctbvFCt0kQA1JVED2D0DsdjUKaTDIucmVejS9lr1fTcfCXj6
         ghLp4HXfRuQzqmtDyb8KUC40z7P4Xip3FJJmdiu9XC65ibc+b+X8zID/JpjhZApF9Vfc
         Yc1QIfFdnqzdqOSS5zA30dhn/BQEsq/em4RtPOPTRUTqRa1MtKC19t4Nenb+BDpXJJn3
         SfDA==
X-Gm-Message-State: AO0yUKV7tU/jkTRb0aTZhYlemqo8CLfUNa/X4lP/r1cIdJKS0R+KZVff
	gyWmst/XCcz9+1TeJPafzf7G5SM2V0sJ
X-Google-Smtp-Source: AK7set/5XtGkWzBFYSheugf2dkdONWpj2qzeqEPgWjWfAnOy0vxdZ74FjxG8HtTLpC55TP3sfOr6vpeLRU29
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a92:9407:0:b0:313:f870:58fb with SMTP id
 c7-20020a929407000000b00313f87058fbmr2508047ili.2.1676311368215; Mon, 13 Feb
 2023 10:02:48 -0800 (PST)
Date: Mon, 13 Feb 2023 18:02:29 +0000
In-Reply-To: <20230213180234.2885032-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230213180234.2885032-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230213180234.2885032-9-rananta@google.com>
Subject: [PATCH 08/13] selftests: KVM: aarch64: Add vCPU migration test for PMU
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@google.com>, Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Implement a stress test for KVM by frequently force-migrating the
vCPU to random pCPUs in the system. This would validate the
save/restore functionality of KVM and starting/stopping of
PMU counters as necessary.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/aarch64/vpmu_test.c | 195 +++++++++++++++++-
 1 file changed, 193 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
index 5c166df245589..0c9d801f4e602 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
@@ -19,9 +19,15 @@
  * higher exception levels (EL2, EL3). Verify this functionality by
  * configuring and trying to count the events for EL2 in the guest.
  *
+ * 4. Since the PMU registers are per-cpu, stress KVM by frequently
+ * migrating the guest vCPU to random pCPUs in the system, and check
+ * if the vPMU is still behaving as expected.
+ *
  * Copyright (c) 2022 Google LLC.
  *
  */
+#define _GNU_SOURCE
+
 #include <kvm_util.h>
 #include <processor.h>
 #include <test_util.h>
@@ -30,6 +36,11 @@
 #include <linux/arm-smccc.h>
 #include <linux/bitfield.h>
 #include <linux/bitmap.h>
+#include <stdlib.h>
+#include <pthread.h>
+#include <sys/sysinfo.h>
+
+#include "delay.h"
 
 /* The max number of the PMU event counters (excluding the cycle counter) */
 #define ARMV8_PMU_MAX_GENERAL_COUNTERS	(ARMV8_PMU_MAX_COUNTERS - 1)
@@ -37,6 +48,8 @@
 /* The max number of event numbers that's supported */
 #define ARMV8_PMU_MAX_EVENTS		64
 
+#define msecs_to_usecs(msec)		((msec) * 1000LL)
+
 /*
  * The macros and functions below for reading/writing PMEV{CNTR,TYPER}<n>_EL0
  * were basically copied from arch/arm64/kernel/perf_event.c.
@@ -265,6 +278,7 @@ enum test_stage {
 	TEST_STAGE_COUNTER_ACCESS = 1,
 	TEST_STAGE_KVM_EVENT_FILTER,
 	TEST_STAGE_KVM_EVTYPE_FILTER,
+	TEST_STAGE_VCPU_MIGRATION,
 };
 
 struct guest_data {
@@ -275,6 +289,19 @@ struct guest_data {
 
 static struct guest_data guest_data;
 
+#define VCPU_MIGRATIONS_TEST_ITERS_DEF		1000
+#define VCPU_MIGRATIONS_TEST_MIGRATION_FREQ_MS	2
+
+struct test_args {
+	int vcpu_migration_test_iter;
+	int vcpu_migration_test_migrate_freq_ms;
+};
+
+static struct test_args test_args = {
+	.vcpu_migration_test_iter = VCPU_MIGRATIONS_TEST_ITERS_DEF,
+	.vcpu_migration_test_migrate_freq_ms = VCPU_MIGRATIONS_TEST_MIGRATION_FREQ_MS,
+};
+
 static void guest_sync_handler(struct ex_regs *regs)
 {
 	uint64_t esr, ec;
@@ -352,7 +379,6 @@ static bool pmu_event_is_supported(uint64_t event)
 		GUEST_ASSERT_3(!(_tval & mask), _tval, mask, set_expected);\
 }
 
-
 /*
  * Extra instructions inserted by the compiler would be difficult to compensate
  * for, so hand assemble everything between, and including, the PMCR accesses
@@ -459,6 +485,13 @@ static void test_event_count(uint64_t event, int pmc_idx, bool expect_count)
 	}
 }
 
+static void test_basic_pmu_functionality(void)
+{
+	/* Test events on generic and cycle counters */
+	test_instructions_count(0, true);
+	test_cycles_count(true);
+}
+
 /*
  * Check if @mask bits in {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers
  * are set or cleared as specified in @set_expected.
@@ -748,6 +781,16 @@ static void guest_evtype_filter_test(void)
 	GUEST_ASSERT_2(cnt == 0, cnt, typer);
 }
 
+static void guest_vcpu_migration_test(void)
+{
+	/*
+	 * While the userspace continuously migrates this vCPU to random pCPUs,
+	 * run basic PMU functionalities and verify the results.
+	 */
+	while (test_args.vcpu_migration_test_iter--)
+		test_basic_pmu_functionality();
+}
+
 static void guest_code(void)
 {
 	switch (guest_data.test_stage) {
@@ -760,6 +803,9 @@ static void guest_code(void)
 	case TEST_STAGE_KVM_EVTYPE_FILTER:
 		guest_evtype_filter_test();
 		break;
+	case TEST_STAGE_VCPU_MIGRATION:
+		guest_vcpu_migration_test();
+		break;
 	default:
 		GUEST_ASSERT_1(0, guest_data.test_stage);
 	}
@@ -837,6 +883,7 @@ create_vpmu_vm(void *guest_code, struct kvm_pmu_event_filter *pmu_event_filters)
 
 	vpmu_vm->vm = vm = vm_create(1);
 	vm_init_descriptor_tables(vm);
+
 	/* Catch exceptions for easier debugging */
 	for (ec = 0; ec < ESR_EC_NUM; ec++) {
 		vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT, ec,
@@ -881,6 +928,8 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
 	struct ucall uc;
 
 	sync_global_to_guest(vcpu->vm, guest_data);
+	sync_global_to_guest(vcpu->vm, test_args);
+
 	vcpu_run(vcpu);
 	switch (get_ucall(vcpu, &uc)) {
 	case UCALL_ABORT:
@@ -1098,11 +1147,112 @@ static void run_kvm_evtype_filter_test(void)
 	destroy_vpmu_vm(vpmu_vm);
 }
 
+struct vcpu_migrate_data {
+	struct vpmu_vm *vpmu_vm;
+	pthread_t *pt_vcpu;
+	bool vcpu_done;
+};
+
+static void *run_vcpus_migrate_test_func(void *arg)
+{
+	struct vcpu_migrate_data *migrate_data = arg;
+	struct vpmu_vm *vpmu_vm = migrate_data->vpmu_vm;
+
+	run_vcpu(vpmu_vm->vcpu);
+	migrate_data->vcpu_done = true;
+
+	return NULL;
+}
+
+static uint32_t get_pcpu(void)
+{
+	uint32_t pcpu;
+	unsigned int nproc_conf;
+	cpu_set_t online_cpuset;
+
+	nproc_conf = get_nprocs_conf();
+	sched_getaffinity(0, sizeof(cpu_set_t), &online_cpuset);
+
+	/* Randomly find an available pCPU to place the vCPU on */
+	do {
+		pcpu = rand() % nproc_conf;
+	} while (!CPU_ISSET(pcpu, &online_cpuset));
+
+	return pcpu;
+}
+
+static int migrate_vcpu(struct vcpu_migrate_data *migrate_data)
+{
+	int ret;
+	cpu_set_t cpuset;
+	uint32_t new_pcpu = get_pcpu();
+
+	CPU_ZERO(&cpuset);
+	CPU_SET(new_pcpu, &cpuset);
+
+	pr_debug("Migrating vCPU to pCPU: %u\n", new_pcpu);
+
+	ret = pthread_setaffinity_np(*migrate_data->pt_vcpu, sizeof(cpuset), &cpuset);
+
+	/* Allow the error where the vCPU thread is already finished */
+	TEST_ASSERT(ret == 0 || ret == ESRCH,
+		    "Failed to migrate the vCPU to pCPU: %u; ret: %d\n", new_pcpu, ret);
+
+	return ret;
+}
+
+static void *vcpus_migrate_func(void *arg)
+{
+	struct vcpu_migrate_data *migrate_data = arg;
+
+	while (!migrate_data->vcpu_done) {
+		usleep(msecs_to_usecs(test_args.vcpu_migration_test_migrate_freq_ms));
+		migrate_vcpu(migrate_data);
+	}
+
+	return NULL;
+}
+
+static void run_vcpu_migration_test(uint64_t pmcr_n)
+{
+	int ret;
+	struct vpmu_vm *vpmu_vm;
+	pthread_t pt_vcpu, pt_sched;
+	struct vcpu_migrate_data migrate_data = {
+		.pt_vcpu = &pt_vcpu,
+		.vcpu_done = false,
+	};
+
+	__TEST_REQUIRE(get_nprocs() >= 2, "At least two pCPUs needed for vCPU migration test");
+
+	guest_data.test_stage = TEST_STAGE_VCPU_MIGRATION;
+	guest_data.expected_pmcr_n = pmcr_n;
+
+	migrate_data.vpmu_vm = vpmu_vm = create_vpmu_vm(guest_code, NULL);
+
+	/* Initialize random number generation for migrating vCPUs to random pCPUs */
+	srand(time(NULL));
+
+	/* Spawn a vCPU thread */
+	ret = pthread_create(&pt_vcpu, NULL, run_vcpus_migrate_test_func, &migrate_data);
+	TEST_ASSERT(!ret, "Failed to create the vCPU thread");
+
+	/* Spawn a scheduler thread to force-migrate vCPUs to various pCPUs */
+	ret = pthread_create(&pt_sched, NULL, vcpus_migrate_func, &migrate_data);
+	TEST_ASSERT(!ret, "Failed to create the scheduler thread for migrating the vCPUs");
+
+	pthread_join(pt_sched, NULL);
+	pthread_join(pt_vcpu, NULL);
+
+	destroy_vpmu_vm(vpmu_vm);
+}
+
 static void run_tests(uint64_t pmcr_n)
 {
 	run_counter_access_tests(pmcr_n);
 	run_kvm_event_filter_test();
 	run_kvm_evtype_filter_test();
+	run_vcpu_migration_test(pmcr_n);
 }
 
 /*
@@ -1121,12 +1271,53 @@ static uint64_t get_pmcr_n_limit(void)
 	return FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
 }
 
-int main(void)
+static void print_help(char *name)
+{
+	pr_info("Usage: %s [-h] [-i vcpu_migration_test_iterations] [-m vcpu_migration_freq_ms]\n",
+		name);
+	pr_info("\t-i: Number of iterations of vCPU migrations test (default: %u)\n",
+		VCPU_MIGRATIONS_TEST_ITERS_DEF);
+	pr_info("\t-m: Frequency (in ms) of vCPUs to migrate to different pCPU. (default: %u)\n",
+		VCPU_MIGRATIONS_TEST_MIGRATION_FREQ_MS);
+	pr_info("\t-h: print this help screen\n");
+}
+
+static bool parse_args(int argc, char *argv[])
+{
+	int opt;
+
+	while ((opt = getopt(argc, argv, "hi:m:")) != -1) {
+		switch (opt) {
+		case 'i':
+			test_args.vcpu_migration_test_iter =
+				atoi_positive("Nr vCPU migration iterations", optarg);
+			break;
+		case 'm':
+			test_args.vcpu_migration_test_migrate_freq_ms =
+				atoi_positive("vCPU migration frequency", optarg);
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
+	print_help(argv[0]);
+	return false;
+}
+
+int main(int argc, char *argv[])
 {
 	uint64_t pmcr_n;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
 
+	if (!parse_args(argc, argv))
+		exit(KSFT_SKIP);
+
 	pmcr_n = get_pmcr_n_limit();
 	run_tests(pmcr_n);
 
-- 
2.39.1.581.gbfd45094c4-goog

