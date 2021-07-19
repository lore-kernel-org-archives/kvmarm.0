Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC58CC07E9D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 18:50:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 62A566112D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 18:50:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62A566112D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F3064B0DA;
	Mon, 19 Jul 2021 14:50:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TWnhnA3ltkB0; Mon, 19 Jul 2021 14:50:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 653374B0F7;
	Mon, 19 Jul 2021 14:50:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C63F4B0D9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 14:50:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dMN8qICIY43L for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 14:50:08 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C9D74B0E6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 14:50:06 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 k32-20020a25b2a00000b0290557cf3415f8so26952764ybj.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 11:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ZEDpe0ZAYcWsHrWESPLkcNChmXiD12rNhu+z9ayPSoQ=;
 b=S0k8GE9+Lo3g9spaUJzMaUW6So0qalo1Tt9AzLmD9/JTLzFb6q6AJ3uavSnWQCl2Xr
 UqWC2xfR/zu832YC8mBVbk0e5ZQ62hosKP28atf2GrszWnykGHHSgrwifPQ2V3wwuX5V
 nI1bZzZ7dRtAxMgvjJElL3+y673sRoITR9rw1aAVBORIVXma3FBOmArqwNpAyvCOhwCL
 EQ/XuIaCKd2wsEEgerw33BORLh3axtcFxydWnVY1aWNTyMWFQdSJF4UcU7X5he7iRBgU
 eLvIPrm61KFUV+P+6flpNv0qJASukinJr0WXDQAPYtKH78RdMkGY6PD9ahg22noP589L
 qEZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ZEDpe0ZAYcWsHrWESPLkcNChmXiD12rNhu+z9ayPSoQ=;
 b=ZNTS3zU7qY1fNzqOMGUNiNUVCCY4fppKRBhC0tDHShJL21Qf2KaLPg9uGGpnzLmULl
 hu6oD23lf9jm+Ru4wVHPfdvAQxydruP6Zw2/RkxS0Cq1s6qgBIWgJXJikW7Fdxlwyc4T
 f0CpifRt6dSrlNLJ5/71sR3J21D9/o/zLgPjdYm36XbjcwabP8yv2t/hIpjuBqdiAIQw
 0i8Dv5iC2zZCzBBe4V1+zOeydcT+mOOvA5EmQUQsXupenuS10HZ2mu7IB/1860kTOkXw
 dO+eOxSXWh2y5AkynJMETZejZex1Nvvkua1QG9jLBv/w8HLKUxfi+migM4rzUahYlzgO
 tLJA==
X-Gm-Message-State: AOAM531CEkvF+elmBZFQSu8tdUc62QCNipQs0bgh3kmCHkePNIrYVwLh
 hVdgIxRt/9tBp/laHXSlAgl7Xa+xSNQ=
X-Google-Smtp-Source: ABdhPJwPasorex0+a8JIBXajWIF3mFLthX7cLl02P10sAgrqBmaZhhOEmDRRXkUQJgo5VByslpl71DdSvnI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6902:136e:: with SMTP id
 bt14mr14483392ybb.384.1626720605605; Mon, 19 Jul 2021 11:50:05 -0700 (PDT)
Date: Mon, 19 Jul 2021 18:49:42 +0000
In-Reply-To: <20210719184949.1385910-1-oupton@google.com>
Message-Id: <20210719184949.1385910-6-oupton@google.com>
Mime-Version: 1.0
References: <20210719184949.1385910-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 05/12] selftests: KVM: Add test for KVM_{GET,SET}_CLOCK
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

Add a selftest for the new KVM clock UAPI that was introduced. Ensure
that the KVM clock is consistent between userspace and the guest, and
that the difference in realtime will only ever cause the KVM clock to
advance forward.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 .../selftests/kvm/x86_64/kvm_clock_test.c     | 210 ++++++++++++++++++
 4 files changed, 214 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_clock_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 06a351b4f93b..d0877d01e771 100644
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
index b853be2ae3c6..f7e24f334c6e 100644
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
index 000000000000..12aef5725dc4
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
@@ -0,0 +1,210 @@
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
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
+		GUEST_SYNC_CLOCK(i, __pvclock_read_cycles(pvti, rdtsc()));
+	}
+
+	GUEST_DONE();
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
+		case UCALL_DONE:
+			return;
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
+	struct kvm_cpuid2 *best;
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
+	best = kvm_get_supported_cpuid();
+	vcpu_set_cpuid(vm, VCPU_ID, best);
+
+	pvti_gva = vm_vaddr_alloc(vm, getpagesize(), 0x10000);
+	pvti_gpa = addr_gva2gpa(vm, pvti_gva);
+	vcpu_args_set(vm, VCPU_ID, 2, pvti_gpa, pvti_gva);
+
+	enter_guest(vm);
+	kvm_vm_free(vm);
+}
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
