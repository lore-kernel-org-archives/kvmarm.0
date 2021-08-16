Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41BAEC4338F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:13:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E77F161378
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:13:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E77F161378
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BECE4B10F;
	Sun, 15 Aug 2021 20:13:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LkNN+kTnGstl; Sun, 15 Aug 2021 20:13:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5067A4B13A;
	Sun, 15 Aug 2021 20:13:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AF2A4B11D
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:13:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pZURU58yt+K6 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Aug 2021 20:13:12 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB6104B0FE
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:13:01 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 o3-20020a2541030000b0290557cf3415f8so15203196yba.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 17:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=q/e6QF13PbPmzNyeEHftd6LeZ3rm+y0LrpmmQX2iAWM=;
 b=mZQUuekC/Wn8aj3bTX5IwP8Q/uxfw7bpTRbmkVO6crVko3MYwmMop1um7jNsOuIA5G
 2l7IQBaS8rZb2aP3GDppVo/kxpeMHSTowDCLmcOSVWFYG+toZyWpfqzwYMEkPGoP+GAr
 Vxxxe3eGGIT7KZ0BNLxroWGMHSDl8kEndxmKA5kojcb3OHcvNu6CfqYeSHjFzwrMaDdv
 jyncHkHfIGUoOx1Xj5edz3qHxQgIOwIjNbXpAMqnCMKInrbkgoGw5hCj0W+RstgOFWIg
 zL5Zd8JpDIXTsZB/uIGX8V0zRfma8YgV2qFMPNv8+dKZetTlsvcSiBYSxv8SoZGL5DQD
 JdPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=q/e6QF13PbPmzNyeEHftd6LeZ3rm+y0LrpmmQX2iAWM=;
 b=LZHqcfZptz24T3ySd70cStZvgBfsYWyKfKKdtB1a/9sWOjANtpVzhNXkv5pHMyozPJ
 hJHAN7bNM2E5OOTqJCaTYlnckdcgNm9aUKMuImbhszroRmutXRvP0iMJKGWAiFp3VLR/
 AK+n0ODmO2CSxWJzV27NsNDOdYIJS0R9pJlMVogbomWFTuqtPqKH31MrQKRwBlys//Zp
 Sfh33xEkyX+9Fs6sDhGDRdzEhcojo6Vm2/hgF8aRTwBDWa8NAFc4B3iUfWmApyM1XZS5
 04G8gW4KxbxggoGfzx5Aa2QUK6EWyPdVfrcN1Zq6PZuBy5AGwRTZf3MFfbmTArpVqPok
 zbhA==
X-Gm-Message-State: AOAM533oHpCUJJDPKyAlTOIxH1JOV2UVp24+LOgrhKKjhj2tSgb0T63O
 z2P9ShwQpSMMnJec3rVmMxwrc/lL4A4=
X-Google-Smtp-Source: ABdhPJxqohNtoShnC6CGm0BF0rD3zR+u+wedYLYQEXcm4ORB58buXd3rRAuCc1dYfmncyVSTVuHAktSHhpg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:810b:: with SMTP id
 o11mr18944380ybk.495.1629072781457; 
 Sun, 15 Aug 2021 17:13:01 -0700 (PDT)
Date: Mon, 16 Aug 2021 00:12:46 +0000
In-Reply-To: <20210816001246.3067312-1-oupton@google.com>
Message-Id: <20210816001246.3067312-10-oupton@google.com>
Mime-Version: 1.0
References: <20210816001246.3067312-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 9/9] selftests: KVM: Add counter emulation benchmark
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

Add a test case for counter emulation on arm64. A side effect of how KVM
handles physical counter offsetting on non-ECV systems is that the
virtual counter will always hit hardware and the physical could be
emulated. Force emulation by writing a nonzero offset to the physical
counter and compare the elapsed cycles to a direct read of the hardware
register.

Reviewed-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Change-Id: Iec9ed89346c3f65b7f9067a7e96a9d94afbab526
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/counter_emulation_benchmark.c | 207 ++++++++++++++++++
 3 files changed, 209 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 9a73befbd8d6..0f3d842b82d6 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
+/aarch64/counter_emulation_benchmark
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
 /aarch64/vgic_init
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a74d4876c69c..3652b39e02b8 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -86,6 +86,7 @@ TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 
+TEST_GEN_PROGS_aarch64 += aarch64/counter_emulation_benchmark
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
diff --git a/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c b/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
new file mode 100644
index 000000000000..48dbd9459102
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
@@ -0,0 +1,207 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * counter_emulation_benchmark.c -- test to measure the effects of counter
+ * emulation on guest reads of the physical counter.
+ *
+ * Copyright (c) 2021, Google LLC.
+ */
+
+#define _GNU_SOURCE
+#include <asm/kvm.h>
+#include <linux/kvm.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <unistd.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+
+#define VCPU_ID 0
+
+static struct counter_values {
+	uint64_t cntvct_start;
+	uint64_t cntpct;
+	uint64_t cntvct_end;
+} counter_values;
+
+static uint64_t nr_iterations = 1000;
+
+static void do_test(void)
+{
+	/*
+	 * Open-coded approach instead of using helper methods to keep a tight
+	 * interval around the physical counter read.
+	 */
+	asm volatile("isb\n\t"
+		     "mrs %[cntvct_start], cntvct_el0\n\t"
+		     "isb\n\t"
+		     "mrs %[cntpct], cntpct_el0\n\t"
+		     "isb\n\t"
+		     "mrs %[cntvct_end], cntvct_el0\n\t"
+		     "isb\n\t"
+		     : [cntvct_start] "=r"(counter_values.cntvct_start),
+		     [cntpct] "=r"(counter_values.cntpct),
+		     [cntvct_end] "=r"(counter_values.cntvct_end));
+}
+
+static void guest_main(void)
+{
+	int i;
+
+	for (i = 0; i < nr_iterations; i++) {
+		do_test();
+		GUEST_SYNC(i);
+	}
+
+	for (i = 0; i < nr_iterations; i++) {
+		do_test();
+		GUEST_SYNC(i);
+	}
+}
+
+static void enter_guest(struct kvm_vm *vm)
+{
+	struct ucall uc;
+
+	vcpu_ioctl(vm, VCPU_ID, KVM_RUN, NULL);
+
+	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	case UCALL_SYNC:
+		break;
+	case UCALL_ABORT:
+		TEST_ASSERT(false, "%s at %s:%ld", (const char *)uc.args[0],
+			    __FILE__, uc.args[1]);
+		break;
+	default:
+		TEST_ASSERT(false, "unexpected exit: %s",
+			    exit_reason_str(vcpu_state(vm, VCPU_ID)->exit_reason));
+		break;
+	}
+}
+
+static double counter_frequency(void)
+{
+	uint32_t freq;
+
+	asm volatile("mrs %0, cntfrq_el0"
+		     : "=r" (freq));
+
+	return freq / 1000000.0;
+}
+
+static void log_csv(FILE *csv, bool trapped)
+{
+	double freq = counter_frequency();
+
+	fprintf(csv, "%s,%.02f,%lu,%lu,%lu\n",
+		trapped ? "true" : "false", freq,
+		counter_values.cntvct_start,
+		counter_values.cntpct,
+		counter_values.cntvct_end);
+}
+
+static double run_loop(struct kvm_vm *vm, FILE *csv, bool trapped)
+{
+	double avg = 0;
+	int i;
+
+	for (i = 0; i < nr_iterations; i++) {
+		uint64_t delta;
+
+		enter_guest(vm);
+		sync_global_from_guest(vm, counter_values);
+
+		if (csv)
+			log_csv(csv, trapped);
+
+		delta = counter_values.cntvct_end - counter_values.cntvct_start;
+		avg = ((avg * i) + delta) / (i + 1);
+	}
+
+	return avg;
+}
+
+static void setup_counter(struct kvm_vm *vm, uint64_t offset)
+{
+	vcpu_access_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
+				KVM_ARM_VCPU_TIMER_PHYS_OFFSET, &offset,
+				true);
+}
+
+static void run_tests(struct kvm_vm *vm, FILE *csv)
+{
+	double avg_trapped, avg_native, freq;
+
+	freq = counter_frequency();
+
+	if (csv)
+		fputs("trapped,freq_mhz,cntvct_start,cntpct,cntvct_end\n", csv);
+
+	/* no physical offsetting; kvm allows reads of cntpct_el0 */
+	setup_counter(vm, 0);
+	avg_native = run_loop(vm, csv, false);
+
+	/* force emulation of the physical counter */
+	setup_counter(vm, 1);
+	avg_trapped = run_loop(vm, csv, true);
+
+	pr_info("%lu iterations: average cycles (@%.02fMHz) native: %.02f, trapped: %.02f\n",
+		nr_iterations, freq, avg_native, avg_trapped);
+}
+
+static void usage(const char *program_name)
+{
+	fprintf(stderr,
+		"Usage: %s [-h] [-o csv_file] [-n iterations]\n"
+		"  -h prints this message\n"
+		"  -n number of test iterations (default: %lu)\n"
+		"  -o csv file to write data\n",
+		program_name, nr_iterations);
+}
+
+int main(int argc, char **argv)
+{
+	struct kvm_vm *vm;
+	FILE *csv = NULL;
+	int opt;
+
+	while ((opt = getopt(argc, argv, "hn:o:")) != -1) {
+		switch (opt) {
+		case 'o':
+			csv = fopen(optarg, "w");
+			if (!csv) {
+				fprintf(stderr, "failed to open file '%s': %d\n",
+					optarg, errno);
+				exit(1);
+			}
+			break;
+		case 'n':
+			nr_iterations = strtoul(optarg, NULL, 0);
+			break;
+		default:
+			fprintf(stderr, "unrecognized option: '-%c'\n", opt);
+			/* fallthrough */
+		case 'h':
+			usage(argv[0]);
+			exit(1);
+		}
+	}
+
+	vm = vm_create_default(VCPU_ID, 0, guest_main);
+	sync_global_to_guest(vm, nr_iterations);
+	ucall_init(vm, NULL);
+
+	if (_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
+				  KVM_ARM_VCPU_TIMER_PHYS_OFFSET)) {
+		print_skip("KVM_ARM_VCPU_TIMER_PHYS_OFFSET not supported.");
+		exit(KSFT_SKIP);
+	}
+
+	run_tests(vm, csv);
+	kvm_vm_free(vm);
+
+	if (csv)
+		fclose(csv);
+}
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
