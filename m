Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25040C4320A
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 17:33:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BBBA060F42
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 17:33:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BBBA060F42
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E41E4B09B;
	Thu, 29 Jul 2021 13:33:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KH1L1UITlUe9; Thu, 29 Jul 2021 13:33:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7EE84B102;
	Thu, 29 Jul 2021 13:33:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A4E34B104
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 13:33:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2EwwEAqz+VxU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 13:33:16 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F2DC4B125
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 13:33:14 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 j21-20020a25d2150000b029057ac4b4e78fso7446141ybg.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 10:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=e1bCoHWm27rhJDUQhB5Prsjt54mG72fssvd6s+HeReo=;
 b=ZYiQMy2QUUUiYdFMlBX6Pio4UgtsJ6xu6RFaU5UKRLsd+S4bwQCbYC9LfKHzKWSxW6
 4QnHktxEnw+3/J9aFrixPIfJN4WycWEUj+JII3KiMhLRvr4z4Fg5dIolfj3uQ7VKe5WK
 /6eqJ4+rkbHJv9YYPKpVPZyDw7gaVf0JegyCyksSUBjesTLciv70VjSUpoFicizqsL89
 c3sAi8hrRA357ijTB+Gi0iX2qqsO5Q1QY8oJbBR12aVTOv3xtAUEOyYpiEYIVyrfP6UC
 BOo1yFrczuUwSGm/H/nVsVPbM5So8b0SPhEg0X8pNGyh1oImXyn2x0d/Njg8Mb9l0mb+
 puHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=e1bCoHWm27rhJDUQhB5Prsjt54mG72fssvd6s+HeReo=;
 b=kJLLcSUI8l6o0N2xcIbqkSfawTnG/1p4YVBGNndFzpRvTwppS4Yq3jHv1VPgxgA0py
 mM3pVThq9AuBSEiqj54n0Rfa+E+ccVRgIRGySiC7g/WTeN7VACosqmV+kOAkJpWm3Y9u
 mIYl0Hx+QMbYIx49nXsFH57sNXlLwIlPusIW6HuSYfcGtSAbsxp9FQOkgL3PnPyI+9K4
 nJKTV6ZRZOtwd1qUQixnxVTFcxrKXWQRVgaYf2I1XQiJ7wdFyao+7Z5/7ZQLdHu907si
 pEj6L2F1WS0R207/bdyKaw8FTTIaV00HvryeZIqnNUth6OsGWVd5Ck+elr1bAVS1tfF4
 SFsQ==
X-Gm-Message-State: AOAM531Hjr+WdfoHEEir1/ev27gyrnmoRFrvQxEtQgI15vF9qnzcYwTe
 7fxnnuDBvKn/QtS6BapilSomgDhpdfc=
X-Google-Smtp-Source: ABdhPJxlvLpmRwOOOs661OCWJ/9eeDqMd8dMMjoVPFyQlHQ5eZC2j+Bab+BXWQYlGr8hDaoDXKOjKn9LTOM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6902:703:: with SMTP id
 k3mr8030922ybt.47.1627579994021; Thu, 29 Jul 2021 10:33:14 -0700 (PDT)
Date: Thu, 29 Jul 2021 17:32:57 +0000
In-Reply-To: <20210729173300.181775-1-oupton@google.com>
Message-Id: <20210729173300.181775-11-oupton@google.com>
Mime-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v5 10/13] selftests: KVM: Add support for aarch64 to
 system_counter_offset_test
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

KVM/arm64 now allows userspace to adjust the guest virtual counter-timer
via a vCPU device attribute. Test that changes to the virtual
counter-timer offset result in the correct view being presented to the
guest.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/include/aarch64/processor.h | 12 +++++
 .../kvm/system_counter_offset_test.c          | 54 ++++++++++++++++++-
 3 files changed, 66 insertions(+), 1 deletion(-)

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
index b337bbbfa41f..25806cdd31ef 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -53,7 +53,59 @@ static uint64_t host_read_guest_system_counter(struct test_case *test)
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
+	if (!_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
+				   KVM_ARM_VCPU_TIMER_OFFSET_VTIMER))
+		return;
+
+	print_skip("KVM_ARM_VCPU_TIMER_OFFSET_VTIMER not supported; skipping test");
+	exit(KSFT_SKIP);
+}
+
+static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
+{
+	vcpu_access_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
+				KVM_ARM_VCPU_TIMER_OFFSET_VTIMER, &test->offset,
+				true);
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
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
