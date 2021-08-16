Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD0BC43214
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:13:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 413D46139F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:13:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 413D46139F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E87AC4B0E0;
	Sun, 15 Aug 2021 20:13:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id juOguPuTjFmg; Sun, 15 Aug 2021 20:13:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 814C54B133;
	Sun, 15 Aug 2021 20:12:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A7384B10A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mAOfxIYRp3-U for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Aug 2021 20:12:56 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 45EA44B11D
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:54 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 f8-20020a2585480000b02905937897e3daso14958264ybn.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 17:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=YHweAsH98SN0OsCurZXAoHNg0K7fgg4+yA3M4swKOxM=;
 b=vJqFQI8UoCqLoeq87yRka6H66iNJlscNgwbv1Q2M1aK/7k176CFZWdkyI9ri+r6aDE
 /LfJ0n+fvvj7+ykU2bq+tEdxoCf33nmTojIua6QCSusL9G4p7gsFMPVV7zj9Uh3Gp9cD
 C7pEvBcMIfUKPHmrU8iMaJYWCtLLfL0xnn0UeuAy+h/sm4Kj7Ug5jq9CCSHk2YjaH8E3
 XJy2+OK/0qFDoiIVqN1sMMnqWz7fmRQt6mw3lSL8v/jD+1mrykR+X9lxbNTWmb+cVWWW
 td6zmDoDQl1NRow6PHijT5+ABaFFoAhiO00bRzXUjzRvo9GN6vxOZyMQ1eL1ijKrVZK3
 GAMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=YHweAsH98SN0OsCurZXAoHNg0K7fgg4+yA3M4swKOxM=;
 b=VzQDpHj61P5bXZZGxdwz31vAERpv9xboWRTy9Tj68RVwUrZPpPqEhRPbOi3Ez1FWdE
 Oftc1ixrMwYM6BbWmkW+imEgawoSWv8E7bYULYpoKj0fsTxbLLl97pdzaNWtfyJHcntr
 M4N9NjqSr/MsIiJsOpLl1DOb7slQfuQN+uLtotoisG8XrtyxRNuYSAH+z7sp4jnJXEtR
 0dKUAZQrclIwYB93E4kN5A/Uvjmm+R69+9UIoil+UmI9evaimTTkV+G+gbw5vIUS7ztE
 /JeQaMgIfagfEZffmJ3Du89bSqlOwUYAatQCmt+QDovp7CIWDAQrgnk/zcocm5YRPPP0
 D2PA==
X-Gm-Message-State: AOAM532r9Ts7rWcxfaLCU7ZcntSNHcCFk+XvA5Le0Z95fPt0rnenop0U
 qSBCaLmQ6Zn/ZxV115JpHWaIhsAg/4o=
X-Google-Smtp-Source: ABdhPJySTvZCEKowSqty9guXsEBhDROpk1CWGr9OKWKMFcqQctz6iGxdx2gpJGaaWY382kH1XOfcQV5FUh4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:b782:: with SMTP id
 n2mr18104381ybh.159.1629072773868; 
 Sun, 15 Aug 2021 17:12:53 -0700 (PDT)
Date: Mon, 16 Aug 2021 00:12:39 +0000
In-Reply-To: <20210816001246.3067312-1-oupton@google.com>
Message-Id: <20210816001246.3067312-3-oupton@google.com>
Mime-Version: 1.0
References: <20210816001246.3067312-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 2/9] selftests: KVM: Add test for KVM_{GET,SET}_CLOCK
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

Add a selftest for the new KVM clock UAPI that was introduced. Ensure
that the KVM clock is consistent between userspace and the guest, and
that the difference in realtime will only ever cause the KVM clock to
advance forward.

Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 .../selftests/kvm/x86_64/kvm_clock_test.c     | 204 ++++++++++++++++++
 4 files changed, 208 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_clock_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 0709af0144c8..06268d6b9aca 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -11,6 +11,7 @@
 /x86_64/emulator_error_test
 /x86_64/get_cpuid_test
 /x86_64/get_msr_index_features
+/x86_64/kvm_clock_test
 /x86_64/kvm_pv_test
 /x86_64/hyperv_clock
 /x86_64/hyperv_cpuid
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 5832f510a16c..3b09133e84a4 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -46,6 +46,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/get_cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
+TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmu_role_test
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 010b59b13917..a8ac5d52e17b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -19,6 +19,8 @@
 #define KVM_DEV_PATH "/dev/kvm"
 #define KVM_MAX_VCPUS 512
 
+#define NSEC_PER_SEC 1000000000L
+
 /*
  * Callers of kvm_util only have an incomplete/opaque description of the
  * structure kvm_util is using to maintain the state of a VM.
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
new file mode 100644
index 000000000000..e0dcc27ae9f1
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
@@ -0,0 +1,204 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021, Google LLC.
+ *
+ * Tests for adjusting the KVM clock from userspace
+ */
+#include <asm/kvm_para.h>
+#include <asm/pvclock.h>
+#include <asm/pvclock-abi.h>
+#include <stdint.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <time.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+#define VCPU_ID 0
+
+struct test_case {
+	uint64_t kvmclock_base;
+	int64_t realtime_offset;
+};
+
+static struct test_case test_cases[] = {
+	{ .kvmclock_base = 0 },
+	{ .kvmclock_base = 180 * NSEC_PER_SEC },
+	{ .kvmclock_base = 0, .realtime_offset = -180 * NSEC_PER_SEC },
+	{ .kvmclock_base = 0, .realtime_offset = 180 * NSEC_PER_SEC },
+};
+
+#define GUEST_SYNC_CLOCK(__stage, __val)			\
+		GUEST_SYNC_ARGS(__stage, __val, 0, 0, 0)
+
+static void guest_main(vm_paddr_t pvti_pa, struct pvclock_vcpu_time_info *pvti)
+{
+	int i;
+
+	wrmsr(MSR_KVM_SYSTEM_TIME_NEW, pvti_pa | KVM_MSR_ENABLED);
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
+		GUEST_SYNC_CLOCK(i, __pvclock_read_cycles(pvti, rdtsc()));
+}
+
+#define EXPECTED_FLAGS (KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC)
+
+static inline void assert_flags(struct kvm_clock_data *data)
+{
+	TEST_ASSERT((data->flags & EXPECTED_FLAGS) == EXPECTED_FLAGS,
+		    "unexpected clock data flags: %x (want set: %x)",
+		    data->flags, EXPECTED_FLAGS);
+}
+
+static void handle_sync(struct ucall *uc, struct kvm_clock_data *start,
+			struct kvm_clock_data *end)
+{
+	uint64_t obs, exp_lo, exp_hi;
+
+	obs = uc->args[2];
+	exp_lo = start->clock;
+	exp_hi = end->clock;
+
+	assert_flags(start);
+	assert_flags(end);
+
+	TEST_ASSERT(exp_lo <= obs && obs <= exp_hi,
+		    "unexpected kvm-clock value: %"PRIu64" expected range: [%"PRIu64", %"PRIu64"]",
+		    obs, exp_lo, exp_hi);
+
+	pr_info("kvm-clock value: %"PRIu64" expected range [%"PRIu64", %"PRIu64"]\n",
+		obs, exp_lo, exp_hi);
+}
+
+static void handle_abort(struct ucall *uc)
+{
+	TEST_FAIL("%s at %s:%ld", (const char *)uc->args[0],
+		  __FILE__, uc->args[1]);
+}
+
+static void setup_clock(struct kvm_vm *vm, struct test_case *test_case)
+{
+	struct kvm_clock_data data;
+
+	memset(&data, 0, sizeof(data));
+
+	data.clock = test_case->kvmclock_base;
+	if (test_case->realtime_offset) {
+		struct timespec ts;
+		int r;
+
+		data.flags |= KVM_CLOCK_REALTIME;
+		do {
+			r = clock_gettime(CLOCK_REALTIME, &ts);
+			if (!r)
+				break;
+		} while (errno == EINTR);
+
+		TEST_ASSERT(!r, "clock_gettime() failed: %d\n", r);
+
+		data.realtime = ts.tv_sec * NSEC_PER_SEC;
+		data.realtime += ts.tv_nsec;
+		data.realtime += test_case->realtime_offset;
+	}
+
+	vm_ioctl(vm, KVM_SET_CLOCK, &data);
+}
+
+static void enter_guest(struct kvm_vm *vm)
+{
+	struct kvm_clock_data start, end;
+	struct kvm_run *run;
+	struct ucall uc;
+	int i, r;
+
+	run = vcpu_state(vm, VCPU_ID);
+
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
+		setup_clock(vm, &test_cases[i]);
+
+		vm_ioctl(vm, KVM_GET_CLOCK, &start);
+
+		r = _vcpu_run(vm, VCPU_ID);
+		vm_ioctl(vm, KVM_GET_CLOCK, &end);
+
+		TEST_ASSERT(!r, "vcpu_run failed: %d\n", r);
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "unexpected exit reason: %u (%s)",
+			    run->exit_reason, exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_SYNC:
+			handle_sync(&uc, &start, &end);
+			break;
+		case UCALL_ABORT:
+			handle_abort(&uc);
+			return;
+		default:
+			TEST_ASSERT(0, "unhandled ucall: %ld\n",
+				    get_ucall(vm, VCPU_ID, &uc));
+		}
+	}
+}
+
+#define CLOCKSOURCE_PATH "/sys/devices/system/clocksource/clocksource0/current_clocksource"
+
+static void check_clocksource(void)
+{
+	char *clk_name;
+	struct stat st;
+	FILE *fp;
+
+	fp = fopen(CLOCKSOURCE_PATH, "r");
+	if (!fp) {
+		pr_info("failed to open clocksource file: %d; assuming TSC.\n",
+			errno);
+		return;
+	}
+
+	if (fstat(fileno(fp), &st)) {
+		pr_info("failed to stat clocksource file: %d; assuming TSC.\n",
+			errno);
+		goto out;
+	}
+
+	clk_name = malloc(st.st_size);
+	TEST_ASSERT(clk_name, "failed to allocate buffer to read file\n");
+
+	if (!fgets(clk_name, st.st_size, fp)) {
+		pr_info("failed to read clocksource file: %d; assuming TSC.\n",
+			ferror(fp));
+		goto out;
+	}
+
+	TEST_ASSERT(!strncmp(clk_name, "tsc\n", st.st_size),
+		    "clocksource not supported: %s", clk_name);
+out:
+	fclose(fp);
+}
+
+int main(void)
+{
+	vm_vaddr_t pvti_gva;
+	vm_paddr_t pvti_gpa;
+	struct kvm_vm *vm;
+	int flags;
+
+	flags = kvm_check_cap(KVM_CAP_ADJUST_CLOCK);
+	if (!(flags & KVM_CLOCK_REALTIME)) {
+		print_skip("KVM_CLOCK_REALTIME not supported; flags: %x",
+			   flags);
+		exit(KSFT_SKIP);
+	}
+
+	check_clocksource();
+
+	vm = vm_create_default(VCPU_ID, 0, guest_main);
+
+	pvti_gva = vm_vaddr_alloc(vm, getpagesize(), 0x10000);
+	pvti_gpa = addr_gva2gpa(vm, pvti_gva);
+	vcpu_args_set(vm, VCPU_ID, 2, pvti_gpa, pvti_gva);
+
+	enter_guest(vm);
+	kvm_vm_free(vm);
+}
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
