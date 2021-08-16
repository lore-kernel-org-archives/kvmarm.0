Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6296DC4338F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:13:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 14CCD6138F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:13:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 14CCD6138F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC2EB4B0FE;
	Sun, 15 Aug 2021 20:13:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6K+AKxWMytLz; Sun, 15 Aug 2021 20:13:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 385964B131;
	Sun, 15 Aug 2021 20:13:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD88E4B0B6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:13:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a7URbe1I4PAR for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Aug 2021 20:13:09 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C20934B140
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:13:00 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 n14-20020a0c9d4e0000b0290354a5f8c800so11768406qvf.17
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 17:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=1lYvkLvXMkZOW0Omv5DbnXGOEluFv2cT8dCWAkq6vrY=;
 b=ucoXmLaWopVhB4jndrMR345quHVgr2BI7iLJWrHy29tE2EOZcJZyRCkaNYoq+cCb1s
 nOS6S8Mo5cgsX5YvhwHLiVQNh3/pP6tRaAztg6MMwEkUJ1ZfqzukhcDfDdQS0bsR99la
 N6N3itdIeBBf1CxU4aoxMwyGoHsFUeqWmfTwzyXGX1ALxhANxsreVkv4GiHivCkAgMzv
 IBc87KPLN/5IsJt4WkC+P9dw4aVfsGiEqo3A6OIborROOWqmCBJoZTCYMX2+F0FZWQl1
 2hhsiQB4JVMYGPOFoaDPb34qTUO4z2df1RFV6BjoSiz6O6JsgLNHuFsrFiFyDJFtkLch
 zg3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=1lYvkLvXMkZOW0Omv5DbnXGOEluFv2cT8dCWAkq6vrY=;
 b=srmWvi2Fzvhg3t5XNd2qjI0ZMjNLMu55N2ACENPvPa4rR6yDj6BcvELhW3X1LmkTFA
 j6cITpJLsYrh4Gksa632gjTY0MnBtjONvqDVoG6tNQmccSTEKcsJNF8KMagqmIuvMbDR
 2LePXgktzNQFe59Oa61r0SFZ36ZW3KtGgvQBMHpb7Sn3CDl7YxOBegg6B1pDeDkBPLAC
 gMSKjaRGSVd90xDGLmpnFfM2prT4a0AiOnFIYkqQL2jQkiCsXCRGRqZstzf5xoZglLHE
 rzQns7Q1SSq11gB6xXDhIR8KYVF+bHfneMD9AgRHVxV/ick9bbld3ZBllpSRgpPRkXD7
 VbOg==
X-Gm-Message-State: AOAM532tq/ufqNgmm+m1VL5Pbte3tFXI6xSo+JlL+Wg5SUJreeQ3LmKc
 NhgXlo5JlIjSpFk/8DB+qK39LJGlx2w=
X-Google-Smtp-Source: ABdhPJx2WNiG5Xm9EOAshaEpB0QvoPQw0RzciABjW2FV+0QygZ9dWPd5OcyKOs52q3Nfg8WF270Sk4LNSTM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a0c:e609:: with SMTP id
 z9mr13684667qvm.37.1629072780405; 
 Sun, 15 Aug 2021 17:13:00 -0700 (PDT)
Date: Mon, 16 Aug 2021 00:12:45 +0000
In-Reply-To: <20210816001246.3067312-1-oupton@google.com>
Message-Id: <20210816001246.3067312-9-oupton@google.com>
Mime-Version: 1.0
References: <20210816001246.3067312-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 8/9] selftests: KVM: Test physical counter offsetting
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
Reviewed-by: Andrew Jones <drjones@redhat.com>
Change-Id: I8a26e88df5c5bc03740c7f980c405b4d21b28be8
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
index ac933db83d03..2b8b4b84a273 100644
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
+				   KVM_ARM_VCPU_TIMER_PHYS_OFFSET))
 		return;
 
-	print_skip("KVM_REG_ARM_TIMER_OFFSET not supported; skipping test");
+	print_skip("KVM_REG_ARM_TIMER_OFFSET|KVM_ARM_VCPU_TIMER_PHYS_OFFSET not supported; skipping test");
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
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
