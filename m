Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F37C43216
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 00:10:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB97A61040
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 00:10:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DB97A61040
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F5ED4B0F0;
	Wed, 28 Jul 2021 20:10:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qcKcpdisGKal; Wed, 28 Jul 2021 20:10:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E3CB4B0D2;
	Wed, 28 Jul 2021 20:10:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C7D64B0D3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 20:10:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R5JtCihdwwjo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jul 2021 20:10:37 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1FF54B0CC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 20:10:34 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 s24-20020a5d92980000b02905505ef33aedso2706404iom.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 17:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=cx+hmnxvQx6fJNB9wO22sOIoBGLy51IV+x/otIs+vCk=;
 b=Px1zlbyEAWBK8wPigjwJIHRv7fOGOmNXjNldEMUcRiDKtEJWggUs8YPUubCqx9ZtRa
 CAlomjMmf+CFaFW3Hpy+DdHEDyOCNZvGRxQE+z/5gnVYzoz848LIRJXyoHZzPugIyLF5
 +0YdrE81ozb4A1Bf/ISMYj0HP06wdRxxKHl40Tv/gjmtzkevsVBATiPhLFMbUvCMXg6m
 8VtKcYZIPbvk19LdeprJV6rmSoFjtvPSrnawd2yZT2KXY2VZWegLq95eaRfoBNNH34la
 PUQefCM81c6/9T0ekjgWP3FabJUqlbl1+YIiwxE5hbD63Ann5F4Mmdv6KIfEH+4xzI0s
 gTtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=cx+hmnxvQx6fJNB9wO22sOIoBGLy51IV+x/otIs+vCk=;
 b=LjlqY5KRoikeoWvjA92cirR+8Rz4qCOq3PBxt0s7jdrj5d1hoXjGtu3KQfmXbpv3xQ
 W4HBD0ydvUqhKOaRnmM0aP9mSAYYNmDSedGll4NSk6+NmSCC3HmnrC9finCQdg914YdK
 1v7Ey16w5QjbEAYqstBA3W+wKormAO9CloMuVziBaWH2JfZ+LC+1SQw0OJXhGi8VH8HA
 LIfjtDvEMUmYzF8ouDtLBhcVsguPG2QPassh9TLQNOzDntJjvlLbb0liG5dCjAoAMUzS
 mP7ivE9Iq8bSZhai/lNC1YdSVxBkyjSCOcuPO20gVwgzA21TDbP68rDMT6OT58NLha6e
 xttw==
X-Gm-Message-State: AOAM530hKhR52UAm29Stp0lpPO9ETNGLIzE3K25sHGuqgElASeo+wLdz
 aYsQqJ2oNIZMWJedmy1NYPt5SStmgOY=
X-Google-Smtp-Source: ABdhPJy9CFny5+3Gnv3Skzy09KeEENu6h17Em/oyTeuIHYsWAi21QRb1r0pNUbceauhVOSb2tH2fQp1pxpY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:418f:: with SMTP id
 az15mr2053577jab.8.1627517434399; Wed, 28 Jul 2021 17:10:34 -0700 (PDT)
Date: Thu, 29 Jul 2021 00:10:11 +0000
In-Reply-To: <20210729001012.70394-1-oupton@google.com>
Message-Id: <20210729001012.70394-13-oupton@google.com>
Mime-Version: 1.0
References: <20210729001012.70394-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v4 12/13] selftests: KVM: Test physical counter offsetting
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

Test that userpace adjustment of the guest physical counter-timer
results in the correct view of within the guest.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 12 ++++++++
 .../kvm/system_counter_offset_test.c          | 29 ++++++++++++++++---
 2 files changed, 37 insertions(+), 4 deletions(-)

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
index 25806cdd31ef..ef215fb43657 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -57,6 +57,7 @@ static uint64_t host_read_guest_system_counter(struct test_case *test)
 
 enum arch_counter {
 	VIRTUAL,
+	PHYSICAL,
 };
 
 struct test_case {
@@ -68,23 +69,41 @@ static struct test_case test_cases[] = {
 	{ .counter = VIRTUAL, .offset = 0 },
 	{ .counter = VIRTUAL, .offset = 180 * NSEC_PER_SEC },
 	{ .counter = VIRTUAL, .offset = -180 * NSEC_PER_SEC },
+	{ .counter = PHYSICAL, .offset = 0 },
+	{ .counter = PHYSICAL, .offset = 180 * NSEC_PER_SEC },
+	{ .counter = PHYSICAL, .offset = -180 * NSEC_PER_SEC },
 };
 
 static void check_preconditions(struct kvm_vm *vm)
 {
 	if (!_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
-				   KVM_ARM_VCPU_TIMER_OFFSET_VTIMER))
+				   KVM_ARM_VCPU_TIMER_OFFSET_VTIMER) &&
+	    !_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
+				   KVM_ARM_VCPU_TIMER_OFFSET_PTIMER))
 		return;
 
-	print_skip("KVM_ARM_VCPU_TIMER_OFFSET_VTIMER not supported; skipping test");
+	print_skip("KVM_ARM_VCPU_TIMER_OFFSET_{VTIMER,PTIMER} not supported; skipping test");
 	exit(KSFT_SKIP);
 }
 
 static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
 {
+	u64 attr = 0;
+
+	switch (test->counter) {
+	case VIRTUAL:
+		attr = KVM_ARM_VCPU_TIMER_OFFSET_VTIMER;
+		break;
+	case PHYSICAL:
+		attr = KVM_ARM_VCPU_TIMER_OFFSET_PTIMER;
+		break;
+	default:
+		TEST_ASSERT(false, "unrecognized counter index %u",
+			    test->counter);
+	}
+
 	vcpu_access_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
-				KVM_ARM_VCPU_TIMER_OFFSET_VTIMER, &test->offset,
-				true);
+				attr, &test->offset, true);
 }
 
 static uint64_t guest_read_system_counter(struct test_case *test)
@@ -92,6 +111,8 @@ static uint64_t guest_read_system_counter(struct test_case *test)
 	switch (test->counter) {
 	case VIRTUAL:
 		return read_cntvct_ordered();
+	case PHYSICAL:
+		return read_cntpct_ordered();
 	default:
 		GUEST_ASSERT(0);
 	}
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
