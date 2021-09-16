Return-Path: <SRS0=sbHD=OG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36127C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:16:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DD5A16120C
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:16:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DD5A16120C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 914DF4B1C7;
	Thu, 16 Sep 2021 14:16:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AW-h656lOgox; Thu, 16 Sep 2021 14:16:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62F944B1F0;
	Thu, 16 Sep 2021 14:16:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3273D4B09C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:16:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RP6XZwaLADu7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Sep 2021 14:16:10 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FACA4B1CB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:16:06 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 g73-20020a379d4c000000b003d3ed03ca28so44713318qke.23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 11:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=BQXd3Nk8LB8EegwpdynLlvWKL/Dc9feqpx1d4DPqITg=;
 b=YbtLMWiwVDR1FwoRZkkH3agBSZD6yFHazXXArNyT0cxXrYta0wqypu1LN+cZSMM8NW
 jW7uPn5jW+QM5fp3xMG2CEU0Xs9YrQ5AMvvwrIj92KZqf2S79zNhY4JyUUuGfobpyINN
 daSQmUZITVjQ6Eq6eJwqhjvukYDoLsEKA+CFKX2wkSjVtB49CJLDiyVlsbmYbTo/Mmxq
 xizlfzC3fGmjwn1YiYKaklStfI0tKm4WeSbGKnbWu+gb4Btpo2ELxWp2OFy0xkO+5Om2
 mLxwXGIj4EcbOUjkuX6tVcwJ6QE2E43ckqQ1HS+svgBMni2yvdCV8ivbwuOElk7wJvZv
 8qIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=BQXd3Nk8LB8EegwpdynLlvWKL/Dc9feqpx1d4DPqITg=;
 b=sn5Zy4NLtTSilAlW/iDiz96DWQsibqwQjjF1Kw9V943YP9d8HOwKZiIiNql+eoTxGf
 ZAWXJk06ccKlt65+O80iBVvmPNwRiWdw4XIiePWKRkM/siLBvhtSqbBzKCshWyE8xrv6
 M+lqzIrO3zSMsXzLnrbcHpq4Pm0gpk1BDqjWqcYZmMQtnTORXD9y2nPmEg6J54vR2gGq
 dZLR+uAjkGezBMdvPt6kfI+BnngU6J5Z5opSNlr5yuGwme1eH/Ek7E5jA/+5E24n8llV
 cxetAbCzpHWuJs9cVyQr1QUs3PJiR2rSI9zL4mIMnNyu/AcxoYF26pXNLdI0v5/z42RP
 2gzA==
X-Gm-Message-State: AOAM533TBnrnXEULxEArrL6iCRiS/PzuygtuQdaIkjZn0+ntEndfJBdJ
 EWDh0LbF+aqZjjyiuTW3/YDrOtm6FRM=
X-Google-Smtp-Source: ABdhPJzCpZqCRtF7Y9hBqtO2vjOxdiXuQnImjvuqW2/v2+k/6ic5Q04lFEhj2CGgxRj2QOIjvU7Igaov4Wg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:44a:: with SMTP id
 cc10mr6940242qvb.58.1631816165810; Thu, 16 Sep 2021 11:16:05 -0700 (PDT)
Date: Thu, 16 Sep 2021 18:15:53 +0000
In-Reply-To: <20210916181555.973085-1-oupton@google.com>
Message-Id: <20210916181555.973085-8-oupton@google.com>
Mime-Version: 1.0
References: <20210916181555.973085-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 7/9] selftests: KVM: Test physical counter offsetting
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

Test that userspace adjustment of the guest physical counter-timer
results in the correct view within the guest.

Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 12 +++++++
 .../kvm/system_counter_offset_test.c          | 34 ++++++++++++++++---
 2 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 4c7472823df3..57b7802cf9e2 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -144,4 +144,16 @@ static inline uint64_t read_cntvct_ordered(void)
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
index 7ea406fdd56f..757b5b2e960e 100644
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
@@ -68,6 +71,12 @@ static struct test_case test_cases[] = {
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
@@ -76,32 +85,49 @@ static void check_preconditions(struct kvm_vm *vm)
 		.cap = KVM_CAP_ARM_VTIMER_OFFSET,
 	};
 
-	if (vcpu_has_reg(vm, VCPU_ID, KVM_REG_ARM_TIMER_OFFSET))
-		return;
-
 	if (!kvm_check_cap(KVM_CAP_ARM_VTIMER_OFFSET)) {
 		print_skip("KVM_REG_ARM_TIMER_OFFSET not supported");
 		exit(KSFT_SKIP);
 	}
 
 	vm_enable_cap(vm, &cap);
+
+	if (_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
+				  KVM_ARM_VCPU_TIMER_PHYS_OFFSET)) {
+		print_skip("KVM_ARM_VCPU_TIMER_PHYS_OFFSET not supported");
+		exit(KSFT_SKIP);
+	}
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
+				KVM_ARM_VCPU_TIMER_PHYS_OFFSET, &cntpoff, true);
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
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
