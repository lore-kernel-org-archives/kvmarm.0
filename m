Return-Path: <SRS0=sbHD=OG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF095C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:16:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9CFE061248
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:16:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9CFE061248
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BE454B1AC;
	Thu, 16 Sep 2021 14:16:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id twxfL2FCZcTW; Thu, 16 Sep 2021 14:16:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7BD04B199;
	Thu, 16 Sep 2021 14:16:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02AA34B15D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:16:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bANS-m6f2B09 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Sep 2021 14:16:00 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C64E34B0B8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:16:00 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 k12-20020a05620a0b8c00b003d5c8646ec2so44803700qkh.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 11:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=8hwcEJHqqbleK2q5f0fxT+gCTiuJIDnqJ/WMYEHLAVo=;
 b=asi7q4GVc4ugGoEOJPY7JkUr5Ekx5zAnLtsBgfljrtz1r2yP2SheAoo8avJtMz2gHV
 5KKv13LRBvrhQy258V7nVJcsziRzYsUlnqTBxi41nowjyA5QP8kufy0zpL9NdA1EwR6R
 6mf2cSimFD7S7EOx+Xw9EJoOncHRmdSTbYLn0DxB3BcYO/kRztd9bwnrhczufwGApTSy
 jGTcoXQF7x17dFB6Zx+PxZRqbCqBjmsEwTfnxNImoRK50t01+Rt+v/c7HMbLaEGJw4cR
 zTl4ANdeibSv5/4unBjx6j+yHVR2Lido9De+UPkHXUJ+YV3+D2aLHvg9x/nbCEuVcNfn
 lwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=8hwcEJHqqbleK2q5f0fxT+gCTiuJIDnqJ/WMYEHLAVo=;
 b=bMi9ucy4b67Hd/JjvNbWKuZm721fLkplXoV+hPCP/vqQ5rjPYnBSLXTkgFYtDPabmK
 UldGwjYvZTqC67jVqrZKNrS81FL22Dw0fVut/fecKD3+he6DTdNMde5ut1PRgYHNMQGX
 vJzD4f7rhbk27YIL05kPhQiKrLpMT8vbr9FtMR7xgUcfpaLWXkCwoWWDmqZfI3bSI1NY
 JBYfF/PeJCwfEi1L9qsimukQqOBjWsBxlDiiX50LfIe9W9WDDe9FU4xwEcikSLyzsyCk
 77gthDh51njI0faYiP0U47v+/q+jDwPvQKerT4poSF4T+U14hJPxnwLIW7Q0m1yz4wok
 WW1Q==
X-Gm-Message-State: AOAM531nZffVJiuiI68sK68IWaFCac11IgNtB6ePZY130VIXmMseZkWF
 jIoSgXAjq7KKuJirVT9WRitQ5DxwhbI=
X-Google-Smtp-Source: ABdhPJy3jL77qYtBUKKnxIe+VvWNRdA1nJDNgwdjh9SJ7OcSuPBR0J08eguS6Zh+JtzbrCSmFUH78KJSPPw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:1271:: with SMTP id
 r17mr6872494qvv.48.1631816160428; Thu, 16 Sep 2021 11:16:00 -0700 (PDT)
Date: Thu, 16 Sep 2021 18:15:48 +0000
In-Reply-To: <20210916181555.973085-1-oupton@google.com>
Message-Id: <20210916181555.973085-3-oupton@google.com>
Mime-Version: 1.0
References: <20210916181555.973085-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 2/9] selftests: KVM: Add test for KVM_{GET,SET}_CLOCK
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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
index 98053d3afbda..86a063d1cd3e 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -12,6 +12,7 @@
 /x86_64/emulator_error_test
 /x86_64/get_cpuid_test
 /x86_64/get_msr_index_features
+/x86_64/kvm_clock_test
 /x86_64/kvm_pv_test
 /x86_64/hyperv_clock
 /x86_64/hyperv_cpuid
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 5d05801ab816..1f969b0192f6 100644
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
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
