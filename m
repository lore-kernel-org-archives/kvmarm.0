Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC054C07E9B
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 18:50:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 823B56109E
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 18:50:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 823B56109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A54F4B0BE;
	Mon, 19 Jul 2021 14:50:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SiXGP8pK2yf1; Mon, 19 Jul 2021 14:50:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 385A54B0B5;
	Mon, 19 Jul 2021 14:50:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 883824B0B5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 14:50:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sNjKbQh3O+Vq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 14:50:18 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C0FB4B102
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 14:50:13 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 s83-20020a2545560000b029055ae952c336so26604704yba.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 11:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Pe/S/uzS2wg1+TTNiX12UiCpgPQMvxwQXCZew3HD/LI=;
 b=ocMj+e/O27vwdOyI3ks0SRsLt9P1PGSjN+lkyhm6Xi0I9EW/F9tBe56YW2aauHv/Kk
 asdYA/+37iI4AsZGz1imZNOcDWgyOfB/abk4bUclvgnjLc2/p8rpgMyJSSeIzlnX59qk
 nE4XFwmvrgk6eza4WcEm7P2XSYy6Qt8cUGm5Ijo6T1t6cfGS5mMbwjrElbU2/vUZ2COR
 Plv2rFVLHYsoimVkbc5C1Bn0AWAVrnuqmiIzlX9VG+8+qDJZqmLQR2BJ55lCiQAnDDTQ
 4rb6oKXqd5RjaabVBxL2+S3ZU3sH90YTMvmip0epx01EthkbyBHrfJi0uSwkHSTibclA
 mF6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Pe/S/uzS2wg1+TTNiX12UiCpgPQMvxwQXCZew3HD/LI=;
 b=B/O0xX27l+IXDTV50OPajNUJwgPhEklRTRbN5x8tZcSw7xbSdOnVlkxs/apW0v7H2S
 sONTFLLa9FwhLh/5IaAKK49/LSvTNwOJWSrSyMv1LmmJivYhRXCf4dfyZG6D8mUoM/PH
 t10afgtE0xpCu5y7pKUDtc4COEASvecSxuEUHhQ6Y5Yc8y9+gLnC2YjEvlRvnWEPBN4e
 Ebr+V2wNKBGJJfR8XW3XIE1+VAMiTKGGZTpir2fDqhMmHBY5WZL1oMRzcFpx6OJdCM/B
 LUkVGYCBzO7BxVvEkQIK2XWR2qDN6k1GxZtgSkLoOarZfXL2kXNA9ZRGjW9jKzn76l7c
 B3Rw==
X-Gm-Message-State: AOAM533owcMFokAjswR7/wODocxsPWTIZbjr1At9cTAyURdpqHsla3yX
 tSL0JqCS/VorJi4Y/c8BxESbTVrSxdI=
X-Google-Smtp-Source: ABdhPJwOGMEIRvFFqt4m9XOjAh0/RyRXczBLXg4UlT7iKp+B6qZBSv2yzkH6ubJXWFBBQD9c7DLGzCqD1jY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:208b:: with SMTP id
 g133mr32514132ybg.211.1626720613054; 
 Mon, 19 Jul 2021 11:50:13 -0700 (PDT)
Date: Mon, 19 Jul 2021 18:49:49 +0000
In-Reply-To: <20210719184949.1385910-1-oupton@google.com>
Message-Id: <20210719184949.1385910-13-oupton@google.com>
Mime-Version: 1.0
References: <20210719184949.1385910-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 12/12] selftests: KVM: Add counter emulation benchmark
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
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
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/counter_emulation_benchmark.c | 215 ++++++++++++++++++
 3 files changed, 217 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 2752813d5090..1d811c6a769b 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 /aarch64/debug-exceptions
+/aarch64/counter_emulation_benchmark
 /aarch64/get-reg-list
 /aarch64/vgic_init
 /s390x/memop
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index d89908108c97..e560a3e74bc2 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -86,6 +86,7 @@ TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
+TEST_GEN_PROGS_aarch64 += aarch64/counter_emulation_benchmark
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += demand_paging_test
diff --git a/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c b/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
new file mode 100644
index 000000000000..73aeb6cdebfe
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
@@ -0,0 +1,215 @@
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
+
+	GUEST_DONE();
+}
+
+static bool enter_guest(struct kvm_vm *vm)
+{
+	struct ucall uc;
+
+	vcpu_ioctl(vm, VCPU_ID, KVM_RUN, NULL);
+
+	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	case UCALL_DONE:
+		return true;
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
+
+	/* more work to do in the guest */
+	return false;
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
+		TEST_ASSERT(!enter_guest(vm), "guest exited unexpectedly");
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
+				KVM_ARM_VCPU_TIMER_OFFSET_PTIMER, &offset,
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
+	TEST_ASSERT(enter_guest(vm), "guest didn't run to completion");
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
+				  KVM_ARM_VCPU_TIMER_OFFSET_PTIMER)) {
+		print_skip("KVM_ARM_VCPU_TIMER_OFFSET_PTIMER not supported.");
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
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
