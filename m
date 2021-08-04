Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B94C432BE
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:58:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6B33260F6F
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:58:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6B33260F6F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FAC94A51D;
	Wed,  4 Aug 2021 04:58:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B3cZFlVnOe6d; Wed,  4 Aug 2021 04:58:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8622D4AEDC;
	Wed,  4 Aug 2021 04:58:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D53224086C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mYH66C+SL3yd for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 04:58:48 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 287164B08E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:46 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 v71-20020a252f4a0000b029055b51419c7dso2184293ybv.23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 01:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=r41+4YYQSiRGA4d6k0mbGoII8JeQ9p3vNbErRM95pUY=;
 b=i1JP0767Kq2eMPERgaGvHbggJeZJvodxcSvZQy51OakaKa1Cbqy9xm+/eZdOHxqRmC
 fFh58lUBru2qfvCl38Gfb2VU/pDLhL4ITdf3Chejofn87Q6F7gqmswLQe0W3Vt2hSMrW
 StDqS5nb+AnvztxtI4rLhPA74xkiiidKtOVGH0ktlG8aZR1A1D+6MTGzGX7hQBqntekf
 kjPuEi+qTGrrP1iuuWD1IiSGwXiXiasHuZm5SuWHvrSnWVvB3PXsT5RFMcSUlvOuDllF
 U80KyR1DLEKtQ+pIyHVzZx/Fo3vjH8n1ZPMl4hKmqntonTmhWFeKx1hW1HoxYaHAQ3Fx
 4n8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=r41+4YYQSiRGA4d6k0mbGoII8JeQ9p3vNbErRM95pUY=;
 b=ecBv4RTsJPOwURu3WQnxuI77ilDKSNWqIDcpO5C+ETkYaMYDefhYIrJtq+RHL2v5Bt
 qO5j/wxyEHZUjhU8Q+E9U3Kz4X1Hp3V8rDGHn47rE74B7Y0l9PUn8Ys2S0f5pOqlZRGM
 fQzLQTpNCQdhENKK1wdkoM2XAmL1l7PqyMljlkBj4Z2oNl23OcwprySewbKuYr8etUhz
 NEkbl8Mk+UoBnSYEP/Q8Ehs2IbNZOfFTfgg4liezPXlyxyujMMf7d1RxEovp0kusWnIY
 j/CUotLeWthRJYSd0FBGY0/mPSHcpWO7leKhqwKARXrh4VI5s/7tfBWysCozeALnYmJ8
 lcdg==
X-Gm-Message-State: AOAM531jToQzmKqUgDK3lCyzZbLrMMYLdu4RcGj/p1vu8/evNncEBBSe
 dyY9i0Izxs7A/5a0K0/NFLGuwuq1pes=
X-Google-Smtp-Source: ABdhPJwYShJd9P6lwbF9fYm94Q4Zq6gEEsSqgevPCyNL1eua0sBPsWceQGemLO1QF+7+t0wmw+wsImgjHFE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6902:114c:: with SMTP id
 p12mr35133135ybu.282.1628067525755; Wed, 04 Aug 2021 01:58:45 -0700 (PDT)
Date: Wed,  4 Aug 2021 08:58:08 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-11-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 10/21] selftests: KVM: Introduce system counter offset test
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

Introduce a KVM selftest to verify that userspace manipulation of the
TSC (via the new vCPU attribute) results in the correct behavior within
the guest.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/system_counter_offset_test.c          | 132 ++++++++++++++++++
 3 files changed, 134 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/system_counter_offset_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 958a809c8de4..3d2585f0bffc 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -52,3 +52,4 @@
 /set_memory_region_test
 /steal_time
 /kvm_binary_stats_test
+/system_counter_offset_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0f94b18b33ce..9f7060c02668 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -85,6 +85,7 @@ TEST_GEN_PROGS_x86_64 += memslot_perf_test
 TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
+TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
new file mode 100644
index 000000000000..b337bbbfa41f
--- /dev/null
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -0,0 +1,132 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021, Google LLC.
+ *
+ * Tests for adjusting the system counter from userspace
+ */
+#include <asm/kvm_para.h>
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
+#ifdef __x86_64__
+
+struct test_case {
+	uint64_t tsc_offset;
+};
+
+static struct test_case test_cases[] = {
+	{ 0 },
+	{ 180 * NSEC_PER_SEC },
+	{ -180 * NSEC_PER_SEC },
+};
+
+static void check_preconditions(struct kvm_vm *vm)
+{
+	if (!_vcpu_has_device_attr(vm, VCPU_ID, KVM_VCPU_TSC_CTRL, KVM_VCPU_TSC_OFFSET))
+		return;
+
+	print_skip("KVM_VCPU_TSC_OFFSET not supported; skipping test");
+	exit(KSFT_SKIP);
+}
+
+static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
+{
+	vcpu_access_device_attr(vm, VCPU_ID, KVM_VCPU_TSC_CTRL,
+				KVM_VCPU_TSC_OFFSET, &test->tsc_offset, true);
+}
+
+static uint64_t guest_read_system_counter(struct test_case *test)
+{
+	return rdtsc();
+}
+
+static uint64_t host_read_guest_system_counter(struct test_case *test)
+{
+	return rdtsc() + test->tsc_offset;
+}
+
+#else /* __x86_64__ */
+
+#error test not implemented for this architecture!
+
+#endif
+
+#define GUEST_SYNC_CLOCK(__stage, __val)			\
+		GUEST_SYNC_ARGS(__stage, __val, 0, 0, 0)
+
+static void guest_main(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
+		struct test_case *test = &test_cases[i];
+
+		GUEST_SYNC_CLOCK(i, guest_read_system_counter(test));
+	}
+}
+
+static void handle_sync(struct ucall *uc, uint64_t start, uint64_t end)
+{
+	uint64_t obs = uc->args[2];
+
+	TEST_ASSERT(start <= obs && obs <= end,
+		    "unexpected system counter value: %"PRIu64" expected range: [%"PRIu64", %"PRIu64"]",
+		    obs, start, end);
+
+	pr_info("system counter value: %"PRIu64" expected range [%"PRIu64", %"PRIu64"]\n",
+		obs, start, end);
+}
+
+static void handle_abort(struct ucall *uc)
+{
+	TEST_FAIL("%s at %s:%ld", (const char *)uc->args[0],
+		  __FILE__, uc->args[1]);
+}
+
+static void enter_guest(struct kvm_vm *vm)
+{
+	uint64_t start, end;
+	struct ucall uc;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
+		struct test_case *test = &test_cases[i];
+
+		setup_system_counter(vm, test);
+		start = host_read_guest_system_counter(test);
+		vcpu_run(vm, VCPU_ID);
+		end = host_read_guest_system_counter(test);
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_SYNC:
+			handle_sync(&uc, start, end);
+			break;
+		case UCALL_ABORT:
+			handle_abort(&uc);
+			return;
+		default:
+			TEST_ASSERT(0, "unhandled ucall %ld\n",
+				    get_ucall(vm, VCPU_ID, &uc));
+		}
+	}
+}
+
+int main(void)
+{
+	struct kvm_vm *vm;
+
+	vm = vm_create_default(VCPU_ID, 0, guest_main);
+	check_preconditions(vm);
+	ucall_init(vm, NULL);
+
+	enter_guest(vm);
+	kvm_vm_free(vm);
+}
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
