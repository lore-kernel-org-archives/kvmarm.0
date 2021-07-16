Return-Path: <SRS0=U254=MI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35429C6377A
	for <kvmarm@archiver.kernel.org>; Fri, 16 Jul 2021 21:26:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E56BE61374
	for <kvmarm@archiver.kernel.org>; Fri, 16 Jul 2021 21:26:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E56BE61374
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A4CE4B103;
	Fri, 16 Jul 2021 17:26:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VzuqRb2R58Ex; Fri, 16 Jul 2021 17:26:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 524CF4B0F6;
	Fri, 16 Jul 2021 17:26:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A04C84B0CA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Jul 2021 17:26:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HIKv6Tf72W4g for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Jul 2021 17:26:49 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 327E04B0C7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Jul 2021 17:26:47 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 b8-20020a92c8480000b0290208fe58bd16so6224627ilq.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Jul 2021 14:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=OVtBdE4SEQDS3BmRMBT7w6wSDOiGdRy1W//HIPm5dvA=;
 b=cgzk324K1v7R+DKpdQKnHgNcpg0QSahm9RNMkfzeZIXYqvdLufpdVGQVnhsA8h2W08
 aqYqfeJrYItKrjLQsFUZ05S6awi79UtLQtC7PVjBao4J700xTfzZf7pPPHqqGv3aTFqd
 9tYa0Amc4BsJByVMkskqImEhx2c38g+UPLdIg/rU4Z3Jve5zfz6PJlMyC+sSLI/YJ7iT
 kv75jiQvbvdE9cXd1kuARt4v/2VTnTfqGBxbrpvW+EToGU4YhmtJfSikvx+8NvRKRYQx
 HM9n24a6wbGWbLnT9sVVPkxQpUbnMZ6qtT/z8+An2Da7KCKPIdKvN5gmp1dLEsDT6uuJ
 gnHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=OVtBdE4SEQDS3BmRMBT7w6wSDOiGdRy1W//HIPm5dvA=;
 b=LACeJ17FMB2jtd2lb8oonnYymXv8QWzbUh92qnbIXgx9ap+JULa9gCzZ94juVdKZzb
 qFb+30lELZEUG2Vuo05X+c32KAiY9CXPmsyFMp57IakWjuqAkoGESb67TcICnpm0hZkE
 Na07ELtXMRs34zyLe3TZe5yZQoioWFlZbg8Rlw/oONY1WiCqwyiYAB3W82Kn50SWk6Eb
 e6N2qkxXLzaIdgNfNt9ZAuqbXEzW4Hf+ZJOw17pRtPG8D+4dNGxMsbI7yxG362bmPcyW
 4LbbTiLS+xMsMwwKatolXj6Kt9kANQHE+Hh1L2ZI2aNAefWoPfj1QUgJN7+hsKEHwcfx
 NrXw==
X-Gm-Message-State: AOAM533Mpd+jeKyzfIgbw7y4fw+J5IjR4tKpIQL8gq+JSPZkZ3nJE1lD
 0ShSFYW0TAUqRt8s7rsBKBHrhi7s6YI=
X-Google-Smtp-Source: ABdhPJzeQHc0QgEIPcwVlL5lZjtbSRyhVTRWfkvF97k5EAXGW1xuRnrWr5R/FFJcyRWIivb5M1fiu+eetFg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:538:: with SMTP id
 j24mr1243426jar.59.1626470806702; Fri, 16 Jul 2021 14:26:46 -0700 (PDT)
Date: Fri, 16 Jul 2021 21:26:24 +0000
In-Reply-To: <20210716212629.2232756-1-oupton@google.com>
Message-Id: <20210716212629.2232756-8-oupton@google.com>
Mime-Version: 1.0
References: <20210716212629.2232756-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v2 07/12] selftests: KVM: Introduce system counter offset test
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

Introduce a KVM selftest to verify that userspace manipulation of the
TSC (via the new vCPU attribute) results in the correct behavior within
the guest.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/system_counter_offset_test.c          | 133 ++++++++++++++++++
 3 files changed, 135 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/system_counter_offset_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index d0877d01e771..2752813d5090 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -50,3 +50,4 @@
 /set_memory_region_test
 /steal_time
 /kvm_binary_stats_test
+/system_counter_offset_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index f7e24f334c6e..7bf2e5fb1d5a 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -83,6 +83,7 @@ TEST_GEN_PROGS_x86_64 += memslot_perf_test
 TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
+TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
new file mode 100644
index 000000000000..7e9015770759
--- /dev/null
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -0,0 +1,133 @@
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
+
+	GUEST_DONE();
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
+		case UCALL_DONE:
+			return;
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
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
