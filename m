Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 794A2C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Dec 2021 12:31:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 396E04B289;
	Thu, 16 Dec 2021 07:31:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S6QJdAQhn+Ro; Thu, 16 Dec 2021 07:31:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18F714B27C;
	Thu, 16 Dec 2021 07:31:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0DFA4B262
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 07:31:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w8o4ydTfh5hi for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Dec 2021 07:31:42 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88E004B24B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 07:31:42 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9027CB823F9;
 Thu, 16 Dec 2021 12:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42ECFC36AE6;
 Thu, 16 Dec 2021 12:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639657900;
 bh=h/noBSTKUFuqmhi7qyo/unRbyRzvrUetwWTTm+z/504=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=JMcXXQ//G/fszpoUagJ42IXWrsLtij4FRlKtCGjOUvLSA8A85ifwDw9MPX/uURMnk
 3zCRU+anfpZNeAhpA2Yy7GVDX0AeIa7H8wDlf5ov1sA4zss3GJYCa8pCwUlFtzRRyK
 1iGsffLU+9IqM5gCO9IyGDLWg02+kGcuZnvN/g6t9wzWpxnYosBKlBtkCWVgw0Odrj
 DDhi8MQZyGkEjEmMjNLVAF8YYkJVeaD+5UkM+fBEO9bB7+FCUZErizh48qYmzFXLSn
 WOq8n08YLhSOTHGFWCLCalE2sSsXzjCVCFrDP8q4QGClca9Yu2Er6j7aaaBoCteib9
 Sk1j0QFPeTVWg==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mxpv8-00CWIB-Dj; Thu, 16 Dec 2021 12:31:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Andrew Jones <drjones@redhat.com>
Subject: [PATCH 2/5] KVM: selftests: Initialise default mode in each test
Date: Thu, 16 Dec 2021 12:31:32 +0000
Message-Id: <20211216123135.754114-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211216123135.754114-1-maz@kernel.org>
References: <20211216123135.754114-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

As we are going to add support for a variable default mode on arm64,
let's make sure it is setup first by sprinkling a number of calls
to get_modes_append_default() when the test starts.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/aarch64/arch_timer.c       | 3 +++
 tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 3 +++
 tools/testing/selftests/kvm/aarch64/get-reg-list.c     | 3 +++
 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c | 3 +++
 tools/testing/selftests/kvm/aarch64/vgic_init.c        | 3 +++
 tools/testing/selftests/kvm/kvm_binary_stats_test.c    | 3 +++
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c     | 3 +++
 tools/testing/selftests/kvm/memslot_perf_test.c        | 4 ++++
 tools/testing/selftests/kvm/rseq_test.c                | 3 +++
 tools/testing/selftests/kvm/set_memory_region_test.c   | 4 ++++
 tools/testing/selftests/kvm/steal_time.c               | 3 +++
 11 files changed, 35 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index bf6a45b0b8dc..22f5b1d85135 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -35,6 +35,7 @@
 #include "arch_timer.h"
 #include "gic.h"
 #include "vgic.h"
+#include "guest_modes.h"
 
 #define NR_VCPUS_DEF			4
 #define NR_TEST_ITERS_DEF		5
@@ -460,6 +461,8 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
 
+	guest_modes_append_default();
+
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index ea189d83abf7..26fd0a87a5dc 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -2,6 +2,7 @@
 #include <test_util.h>
 #include <kvm_util.h>
 #include <processor.h>
+#include <guest_modes.h>
 
 #define VCPU_ID 0
 
@@ -200,6 +201,8 @@ int main(int argc, char *argv[])
 	struct ucall uc;
 	int stage;
 
+	guest_modes_append_default();
+
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	ucall_init(vm, NULL);
 
diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index cc898181faab..f97932439f90 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -33,6 +33,7 @@
 #include "kvm_util.h"
 #include "test_util.h"
 #include "processor.h"
+#include "guest_modes.h"
 
 static struct kvm_reg_list *reg_list;
 static __u64 *blessed_reg, blessed_n;
@@ -588,6 +589,8 @@ int main(int ac, char **av)
 	int i, ret = 0;
 	pid_t pid;
 
+	guest_modes_append_default();
+
 	for (i = 1; i < ac; ++i) {
 		if (strcmp(av[i], "--core-reg-fixup") == 0)
 			fixup_core_regs = true;
diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
index 4c5f6814030f..94f951b0edcb 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
@@ -16,6 +16,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "test_util.h"
+#include "guest_modes.h"
 
 #define VCPU_ID_SOURCE 0
 #define VCPU_ID_TARGET 1
@@ -76,6 +77,8 @@ int main(void)
 	struct kvm_vm *vm;
 	struct ucall uc;
 
+	guest_modes_append_default();
+
 	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
 	kvm_vm_elf_load(vm, program_invocation_name);
 	ucall_init(vm, NULL);
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 34379c98d2f4..f2c235453aa9 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -14,6 +14,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "vgic.h"
+#include "guest_modes.h"
 
 #define NR_VCPUS		4
 
@@ -699,6 +700,8 @@ int main(int ac, char **av)
 	int ret;
 	int pa_bits;
 
+	guest_modes_append_default();
+
 	pa_bits = vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
 	max_phys_size = 1ULL << pa_bits;
 
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 17f65d514915..0dc30a7ba0b3 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -17,6 +17,7 @@
 #include "test_util.h"
 
 #include "kvm_util.h"
+#include "guest_modes.h"
 #include "asm/kvm.h"
 #include "linux/kvm.h"
 
@@ -207,6 +208,8 @@ int main(int argc, char *argv[])
 	int max_vm = DEFAULT_NUM_VM;
 	int max_vcpu = DEFAULT_NUM_VCPU;
 
+	guest_modes_append_default();
+
 	/* Get the number of VMs and VCPUs that would be created for testing. */
 	if (argc > 1) {
 		max_vm = strtol(argv[1], NULL, 0);
diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
index aed9dc3ca1e9..7068a9f14d0c 100644
--- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
@@ -17,6 +17,7 @@
 #include "test_util.h"
 
 #include "kvm_util.h"
+#include "guest_modes.h"
 #include "asm/kvm.h"
 #include "linux/kvm.h"
 
@@ -51,6 +52,8 @@ int main(int argc, char *argv[])
 	pr_info("KVM_CAP_MAX_VCPU_ID: %d\n", kvm_max_vcpu_id);
 	pr_info("KVM_CAP_MAX_VCPUS: %d\n", kvm_max_vcpus);
 
+	guest_modes_append_default();
+
 	/*
 	 * Check that we're allowed to open nr_fds_wanted file descriptors and
 	 * try raising the limits if needed.
diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 1727f75e0c2c..ef4ffce5d170 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -25,6 +25,8 @@
 #include <kvm_util.h>
 #include <processor.h>
 
+#include "guest_modes.h"
+
 #define VCPU_ID 0
 
 #define MEM_SIZE		((512U << 20) + 4096)
@@ -1015,6 +1017,8 @@ int main(int argc, char *argv[])
 	if (!parse_args(argc, argv, &targs))
 		return -1;
 
+	guest_modes_append_default();
+
 	rbestslottime.slottimens = 0;
 	for (tctr = targs.tfirst; tctr <= targs.tlast; tctr++) {
 		const struct test_data *data = &tests[tctr];
diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 4158da0da2bb..d2440fc72f0d 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -19,6 +19,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "test_util.h"
+#include "guest_modes.h"
 
 #define VCPU_ID 0
 
@@ -223,6 +224,8 @@ int main(int argc, char *argv[])
 
 	sys_rseq(0);
 
+	guest_modes_append_default();
+
 	/*
 	 * Create and run a dummy VM that immediately exits to userspace via
 	 * GUEST_SYNC, while concurrently migrating the process by setting its
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 72a1c9b4882c..ff4cc7e796e7 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -17,6 +17,8 @@
 #include <kvm_util.h>
 #include <processor.h>
 
+#include "guest_modes.h"
+
 #define VCPU_ID 0
 
 /*
@@ -413,6 +415,8 @@ int main(int argc, char *argv[])
 	int i, loops;
 #endif
 
+	guest_modes_append_default();
+
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 62f2eb9ee3d5..5200044f572d 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -16,6 +16,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include "guest_modes.h"
 
 #define NR_VCPUS		4
 #define ST_GPA_BASE		(1 << 30)
@@ -273,6 +274,8 @@ int main(int ac, char **av)
 	pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), &cpuset);
 	pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset);
 
+	guest_modes_append_default();
+
 	/* Create a one VCPU guest and an identity mapped memslot for the steal time structure */
 	vm = vm_create_default(0, 0, guest_code);
 	gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE * NR_VCPUS);
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
