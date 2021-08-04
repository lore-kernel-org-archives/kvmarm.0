Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3105C4338F
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:59:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 77CE560F02
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:59:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 77CE560F02
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B6A64A523;
	Wed,  4 Aug 2021 04:59:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kZ-LYyjtzzKE; Wed,  4 Aug 2021 04:58:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22F2D4A4E1;
	Wed,  4 Aug 2021 04:58:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75D544B093
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XuOOOgtIH8A8 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 04:58:54 -0400 (EDT)
Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com
 [209.85.167.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E7774A483
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:52 -0400 (EDT)
Received: by mail-oi1-f202.google.com with SMTP id
 d205-20020aca36d60000b02902241b7398a8so809789oia.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 01:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Wr2QUWPIrNr02r9ZSQ6a6WvFSF+P+rF7IWMFJFIeT5Q=;
 b=A2eaQevcuk1kE8kH+hNfVeiJGxQGIsvPPXH7dwJX1I1bqzmceDdLvtt3vtZsSlfHgS
 6uk2fnUUV1bWg9ui/diKwA4nuUWGnCfjSPratLEZd7BP/7MO8akAcoc9w+EQ/wtsAXAp
 ZyNGkKQCPzWCb6fjuunbxbUeHNOvYwMVhCRqWRcU2+VYhha6puKXBjme8zME+4pwl6Bk
 TcuhrWi5b2xsYj1XFDIS6BErZBNJ2MwSHwcl0Oh6rDaqMeEyEhpsccRugDvMtCKPZdV8
 RqjprVlUgFZUxBZHsKv+zbjtLGxLp/H0em+JFSda46mXMaNqevbjZdwKZHvUvVK5VorB
 lOwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Wr2QUWPIrNr02r9ZSQ6a6WvFSF+P+rF7IWMFJFIeT5Q=;
 b=PLz/h035tUjEfbyS2UaYXf3dDfpNPHc9upHTMmLgX4CJSRXaRCtVr4R50KGQAGi+oR
 xwKyZ87g2MYwPgKM5s5ZsnQvgu2SLdZ1mWIrRUryw68fqo+GqJSCwOhCELyBjWMYQISF
 pn8G06iNJhdJ10858av/DSnSJSMcKaR3DyPCQoXS7gVAFUgEHwdI00Y7cKa5oT/bE0s5
 TnMu9VG5/VxSzP2IAVsBlUu/x22myYQX+IMBQBVnLepoveMR5LH6Ezqzrwif+xk8y1mn
 1cWNk8LUhhjmdqUcxx5SB/VlKsi5l7KtXqzYO4laHj9ppCJ9zWqYH5IND1ga1vQHxUqP
 ooUA==
X-Gm-Message-State: AOAM530w/7FAn1LLISFEHQB/v7bWHLgoB/4EesyJa75fuI0J6r2TscPs
 8Z5QefFpR7usXT4fT4UFInOAznVShHI=
X-Google-Smtp-Source: ABdhPJwV6z5/wOQcC6ysoCIBRHVz7QoiKO1NC+BeHz63h1lYVDEtDeBmgg3mO02si6II7kJcePnt4XlEnxs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a9d:6d16:: with SMTP id
 o22mr5444656otp.336.1628067531365; 
 Wed, 04 Aug 2021 01:58:51 -0700 (PDT)
Date: Wed,  4 Aug 2021 08:58:13 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-16-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 15/21] selftests: KVM: Add support for aarch64 to
 system_counter_offset_test
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

KVM/arm64 now allows userspace to adjust the guest virtual counter-timer
via a vCPU register. Test that changes to the virtual counter-timer
offset result in the correct view being presented to the guest.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/include/aarch64/processor.h | 12 ++++
 .../kvm/system_counter_offset_test.c          | 56 ++++++++++++++++++-
 3 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 9f7060c02668..fab42e7c23ee 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -98,6 +98,7 @@ TEST_GEN_PROGS_aarch64 += kvm_page_table_test
 TEST_GEN_PROGS_aarch64 += set_memory_region_test
 TEST_GEN_PROGS_aarch64 += steal_time
 TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
+TEST_GEN_PROGS_aarch64 += system_counter_offset_test
 
 TEST_GEN_PROGS_s390x = s390x/memop
 TEST_GEN_PROGS_s390x += s390x/resets
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 27dc5c2e56b9..3168cdbae6ee 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -129,4 +129,16 @@ void vm_install_sync_handler(struct kvm_vm *vm,
 
 #define isb()	asm volatile("isb" : : : "memory")
 
+static inline uint64_t read_cntvct_ordered(void)
+{
+	uint64_t r;
+
+	__asm__ __volatile__("isb\n\t"
+			     "mrs %0, cntvct_el0\n\t"
+			     "isb\n\t"
+			     : "=r"(r));
+
+	return r;
+}
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
index b337bbbfa41f..ac933db83d03 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -53,7 +53,61 @@ static uint64_t host_read_guest_system_counter(struct test_case *test)
 	return rdtsc() + test->tsc_offset;
 }
 
-#else /* __x86_64__ */
+#elif __aarch64__ /* __x86_64__ */
+
+enum arch_counter {
+	VIRTUAL,
+};
+
+struct test_case {
+	enum arch_counter counter;
+	uint64_t offset;
+};
+
+static struct test_case test_cases[] = {
+	{ .counter = VIRTUAL, .offset = 0 },
+	{ .counter = VIRTUAL, .offset = 180 * NSEC_PER_SEC },
+	{ .counter = VIRTUAL, .offset = -180 * NSEC_PER_SEC },
+};
+
+static void check_preconditions(struct kvm_vm *vm)
+{
+	if (vcpu_has_reg(vm, VCPU_ID, KVM_REG_ARM_TIMER_OFFSET))
+		return;
+
+	print_skip("KVM_REG_ARM_TIMER_OFFSET not supported; skipping test");
+	exit(KSFT_SKIP);
+}
+
+static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
+{
+	struct kvm_one_reg reg = {
+		.id = KVM_REG_ARM_TIMER_OFFSET,
+		.addr = (__u64)&test->offset,
+	};
+
+	vcpu_set_reg(vm, VCPU_ID, &reg);
+}
+
+static uint64_t guest_read_system_counter(struct test_case *test)
+{
+	switch (test->counter) {
+	case VIRTUAL:
+		return read_cntvct_ordered();
+	default:
+		GUEST_ASSERT(0);
+	}
+
+	/* unreachable */
+	return 0;
+}
+
+static uint64_t host_read_guest_system_counter(struct test_case *test)
+{
+	return read_cntvct_ordered() - test->offset;
+}
+
+#else /* __aarch64__ */
 
 #error test not implemented for this architecture!
 
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
