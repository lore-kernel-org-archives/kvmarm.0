Return-Path: <SRS0=sbHD=OG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F7D9C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:16:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 03376611C4
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:16:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 03376611C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A53CD4B19F;
	Thu, 16 Sep 2021 14:16:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IEDSLbrv9sQ6; Thu, 16 Sep 2021 14:16:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 29F5C4B1F1;
	Thu, 16 Sep 2021 14:16:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90ACA4B177
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:16:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bao8IrK4UUdv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Sep 2021 14:16:07 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 053454B187
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:16:05 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 h18-20020a0cffd2000000b0037e78fb2552so22315911qvv.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 11:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=7QjavrqBsU/MBAzScH1BwocaUHGDPl4uPFd2XGsDMvE=;
 b=W/jxVPF8UGJYGASTGhfD4cpXvhCNOyq5w8JBfeqZqbNuG2vNR362VcSh4btOMHC1y9
 oe1hix7aUqYGFOC3TNRTgzpgDaE5P6+YXpaqXLPSNjDqHsnvt9peNLYPYcADPy5/5A8M
 6/S6umn1c5cSrAwWCHmoXEJpZ+FFfmtfHxUkebqIeKunLfOkdsQrhKCrPTEVRxU1FP9u
 j9w/2KyUMMYxsVy1tPyjkjJUB3Z1Z/Yn1zxDe2WZVfzMGr0NPLDYcgDwzevUsCalGGIF
 TNCF2vYHowEZKwbqoQ7CrRFk3Tc+XYvTlRTUBFbC4oNn/h/fpePvNxmQWhlOK15PqtXr
 vRRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=7QjavrqBsU/MBAzScH1BwocaUHGDPl4uPFd2XGsDMvE=;
 b=qoSo5U518M1rugTTI3PjC19IMD3g0rHB6kN9//0c8HLze/avcvunqDMiMX7SlXw2/X
 x+alX4mFwarfBUD5BLiJ0M9KVY8sIfmFrF/h3ceu5U1wGwDe9z5A7ev5fgwLu9qhrrf8
 YJ7fsnC0tLZvORbq9FdM1Q9M4Uv8UlblpgYwv3gHYnXZ0ibshsYCsqZl1smOJ776kDHh
 Gj9uI4zXePWSBm2DYxFY0saL2XcqYTekihL2829iOGFl0xpk4SgQHA7xe0O5ErUGlFdT
 VnKagaeDYYWM18JZ7C5paucoD78ZiK0UV8bHAlKHV4kxqxV8eENjTWiiadi/EP+vmZfr
 vpIQ==
X-Gm-Message-State: AOAM533d7DDJUFxY+xtUbb1tO4SNOVQltfggVxAEVaAMDrnTz7/ktaw7
 VxRMhYKYy4kThn21ALe5NtAGbcBMjtk=
X-Google-Smtp-Source: ABdhPJyEbuPS+wYh6ttOuY6erGnCSv4WLRJ1npvavUrNwz7P3JruTT8DOF+7Y2BrFtjDW2ZEfJYAF+ysuwg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:7b4:: with SMTP id
 v20mr7057215qvz.0.1631816164628; Thu, 16 Sep 2021 11:16:04 -0700 (PDT)
Date: Thu, 16 Sep 2021 18:15:52 +0000
In-Reply-To: <20210916181555.973085-1-oupton@google.com>
Message-Id: <20210916181555.973085-7-oupton@google.com>
Mime-Version: 1.0
References: <20210916181555.973085-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 6/9] selftests: KVM: Add support for aarch64 to
 system_counter_offset_test
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

KVM/arm64 now allows userspace to adjust the guest virtual counter-timer
via a vCPU register. Test that changes to the virtual counter-timer
offset result in the correct view being presented to the guest.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/include/aarch64/processor.h | 12 ++++
 .../kvm/system_counter_offset_test.c          | 64 ++++++++++++++++++-
 3 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 225803ac95bb..fd61d0063c50 100644
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
index c0273aefa63d..4c7472823df3 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -132,4 +132,16 @@ void vm_install_sync_handler(struct kvm_vm *vm,
 
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
index b337bbbfa41f..7ea406fdd56f 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -53,7 +53,69 @@ static uint64_t host_read_guest_system_counter(struct test_case *test)
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
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_ARM_VTIMER_OFFSET,
+	};
+
+	if (vcpu_has_reg(vm, VCPU_ID, KVM_REG_ARM_TIMER_OFFSET))
+		return;
+
+	if (!kvm_check_cap(KVM_CAP_ARM_VTIMER_OFFSET)) {
+		print_skip("KVM_REG_ARM_TIMER_OFFSET not supported");
+		exit(KSFT_SKIP);
+	}
+
+	vm_enable_cap(vm, &cap);
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
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
