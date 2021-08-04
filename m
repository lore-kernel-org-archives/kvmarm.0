Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02765C43216
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:59:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A74C260F6F
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:59:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A74C260F6F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D86A4A3A3;
	Wed,  4 Aug 2021 04:59:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J13-An-6OnFU; Wed,  4 Aug 2021 04:59:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C55BF4A3BF;
	Wed,  4 Aug 2021 04:59:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3376C4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:59:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2dnEca5-seeN for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 04:58:59 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F058D4B082
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:56 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 g2-20020a0cdf020000b029033bc8be6d4aso1292373qvl.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 01:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=P+wj7LgLjEuWRbpjKCXjEpBSkxsEIWcdrd+/OVNGjgQ=;
 b=U2RWOObCpS8DFZJ10Fp2o+XLbL0l1Du9Q2Q9GE9WrsZOYR4vwBJQlSHULYkGmuvObp
 qkHivooxec/DqyZKsQVcgoEPCJi+6nxBSJa++GLLq4UkYPeTO/PnhQU8BxXCanAd/n3b
 1VAAXmzHLRgzm8XB6suWss1/HgHWX8AsDQjtvEEKe6uBRGu5tM62spN1T/IizoXmP1ZL
 /bcqtSUX18eaq6JGBkF1Jl6CZbI9tnVwffM2msHBTiN69mXBBWf9eO+ZEhofwM/eDIVc
 AgUFDx/s8u2xV/CUIjyX8OpmxWHZj6alRmINi+u/RPuPYEpQrLqUs/YiaPtSGXJY1Ysc
 UVRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=P+wj7LgLjEuWRbpjKCXjEpBSkxsEIWcdrd+/OVNGjgQ=;
 b=OXLAeZ65aMGXMJ4K2n0uESSYH/ETUizmfzvv/k50+eRF0ehOYesDrOEcmT5g6Nxe0F
 Dm+QAIjdW3Zd7wfpHAG6DSJMp8mzLfsgElMv56kO/gseRJdVSEWYXedAzS4SajA5Fthl
 LaNCE6YWLLvDRXAws13TrPYvJdTfWNS7J2rCPTpDUX2wazn6hPn2YOWeD6O27xFBv14F
 vczoo6Va/C0Ypn4lobf9yTqMxHVsWoxOlTyWO6ctQ8XNjWHPzsue593PqNQVXJMGdCb9
 JhbpQeDsejzIe7O82NDclmfFDDOdtQr/XWL/jeQRUxqId50gilOg39r090OZb4sqHeR5
 Amig==
X-Gm-Message-State: AOAM530mURJgCX6xGNkTaSsLjsZ3QV4N+yaCFmsQqxndHEw+WmO69kwe
 M5rljsUspBZdjkLLtL6Rb4Sv3wsuy8Y=
X-Google-Smtp-Source: ABdhPJxwuRb6Dx8CoyJvkFTha9TsHjRjV9Svfskn24Ka80JcxAcKjGHT4By5V5+EQXZYVffGDUwuCZ/2cFY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:e67:: with SMTP id
 jz7mr23858033qvb.0.1628067536659; Wed, 04 Aug 2021 01:58:56 -0700 (PDT)
Date: Wed,  4 Aug 2021 08:58:18 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-21-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 20/21] selftests: KVM: Test physical counter offsetting
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

Test that userspace adjustment of the guest physical counter-timer
results in the correct view within the guest.

Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 12 +++++++
 .../kvm/system_counter_offset_test.c          | 31 +++++++++++++++++--
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 3168cdbae6ee..7f53d90e9512 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -141,4 +141,16 @@ static inline uint64_t read_cntvct_ordered(void)
 	return r;
 }
 
+static inline uint64_t read_cntpct_ordered(void)
+{
+	uint64_t r;
+
+	__asm__ __volatile__("isb\n\t"
+			     "mrs %0, cntpct_el0\n\t"
+			     "isb\n\t"
+			     : "=r"(r));
+
+	return r;
+}
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
index ac933db83d03..82d26a45cc48 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -57,6 +57,9 @@ static uint64_t host_read_guest_system_counter(struct test_case *test)
 
 enum arch_counter {
 	VIRTUAL,
+	PHYSICAL,
+	/* offset physical, read virtual */
+	PHYSICAL_READ_VIRTUAL,
 };
 
 struct test_case {
@@ -68,32 +71,54 @@ static struct test_case test_cases[] = {
 	{ .counter = VIRTUAL, .offset = 0 },
 	{ .counter = VIRTUAL, .offset = 180 * NSEC_PER_SEC },
 	{ .counter = VIRTUAL, .offset = -180 * NSEC_PER_SEC },
+	{ .counter = PHYSICAL, .offset = 0 },
+	{ .counter = PHYSICAL, .offset = 180 * NSEC_PER_SEC },
+	{ .counter = PHYSICAL, .offset = -180 * NSEC_PER_SEC },
+	{ .counter = PHYSICAL_READ_VIRTUAL, .offset = 0 },
+	{ .counter = PHYSICAL_READ_VIRTUAL, .offset = 180 * NSEC_PER_SEC },
+	{ .counter = PHYSICAL_READ_VIRTUAL, .offset = -180 * NSEC_PER_SEC },
 };
 
 static void check_preconditions(struct kvm_vm *vm)
 {
-	if (vcpu_has_reg(vm, VCPU_ID, KVM_REG_ARM_TIMER_OFFSET))
+	if (vcpu_has_reg(vm, VCPU_ID, KVM_REG_ARM_TIMER_OFFSET) &&
+	    !_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
+				   KVM_ARM_VCPU_TIMER_OFFSET))
 		return;
 
-	print_skip("KVM_REG_ARM_TIMER_OFFSET not supported; skipping test");
+	print_skip("KVM_REG_ARM_TIMER_OFFSET|KVM_ARM_VCPU_TIMER_OFFSET not supported; skipping test");
 	exit(KSFT_SKIP);
 }
 
 static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
 {
+	uint64_t cntvoff, cntpoff;
 	struct kvm_one_reg reg = {
 		.id = KVM_REG_ARM_TIMER_OFFSET,
-		.addr = (__u64)&test->offset,
+		.addr = (__u64)&cntvoff,
 	};
 
+	if (test->counter == VIRTUAL) {
+		cntvoff = test->offset;
+		cntpoff = 0;
+	} else {
+		cntvoff = 0;
+		cntpoff = test->offset;
+	}
+
 	vcpu_set_reg(vm, VCPU_ID, &reg);
+	vcpu_access_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
+				KVM_ARM_VCPU_TIMER_OFFSET, &cntpoff, true);
 }
 
 static uint64_t guest_read_system_counter(struct test_case *test)
 {
 	switch (test->counter) {
 	case VIRTUAL:
+	case PHYSICAL_READ_VIRTUAL:
 		return read_cntvct_ordered();
+	case PHYSICAL:
+		return read_cntpct_ordered();
 	default:
 		GUEST_ASSERT(0);
 	}
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
