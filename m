Return-Path: <SRS0=U254=MI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A57C636CE
	for <kvmarm@archiver.kernel.org>; Fri, 16 Jul 2021 21:27:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 126F1613F1
	for <kvmarm@archiver.kernel.org>; Fri, 16 Jul 2021 21:27:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 126F1613F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB20D4B0E3;
	Fri, 16 Jul 2021 17:26:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aTNLG-MN8aTk; Fri, 16 Jul 2021 17:26:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0B7C4B0D9;
	Fri, 16 Jul 2021 17:26:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FB2B4B0F0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Jul 2021 17:26:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UA3d8gkbIBkz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Jul 2021 17:26:53 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C0694B0C9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Jul 2021 17:26:51 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 o14-20020a05620a0d4eb02903a5eee61155so2415355qkl.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Jul 2021 14:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Js1tkzh0InHJDinhDdW8poSOxRWAClAIrtKK55u0+PE=;
 b=b8t9DdgCqPuR2UnoT0GWSzOZJJBPUdIz3hog5NHSzQX1KdgyIEve3UuQk8NWg7PeYT
 0hcHxEpdXateqVQ5BsKRkc5DGtoKoHKtmtT0MZ59LV8jIOIEmz0jcaIbngWtkh1j2sO6
 3S3JvEIrkJl41Ofh0pH6MI1ylz24x3UtG+PqDzk/SqD7enT7oT8KmEXAClybzSHNcXN/
 iA61C6x08Zk9Nvhfip/WHFAnqsO1d/iWWFxGWRH8gTISa77H1Q4L4DeJYfZK6vcQsjT6
 a1+8oJhLQb8hm9AmAHPvebrBTnniCHXm/YF2UPIcv1+wPRcN0U801VrTR2NRbtNzKxw6
 uq8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Js1tkzh0InHJDinhDdW8poSOxRWAClAIrtKK55u0+PE=;
 b=NRA0Ydl5qkHFp783ejy2NJkoTbaLVoTm15MxT77lX/2xLrz2i/Zbrg0HznmoQTtQlM
 eXPGrtqPq2o0+UewMqwnMTCVqSRLxJPfC6KP6Kjo3CLEP26V1Iq1rT7+sLHlsIFnz3Cf
 UP2vTObLO8bfKLv3akFRQf5or8WYZ3B2JBgyEEJju8TkuPHgZpYc1gCCXEhHQTVLNHV9
 vyDySkOURhjaIdpDh1BHC5wfECi9+2UFwbBRK/UgSTQzpTPaX80uBlZx8Ei8GianGhsj
 0D09zDy6GIvS4JLtch7f35Wli4zTCYpsZv5TtxlD/Ndb2jKGovt25+PirjJRWKWSF0p4
 k3IA==
X-Gm-Message-State: AOAM5332vnrhxCeBzZYMXRHhBg7bsGWPxz+eWtohH0F0MxISWdw0FmBw
 n+n8hiyqq89yuJeVxgPwYxsM3bSlc1A=
X-Google-Smtp-Source: ABdhPJxdMMzj7m+DdM5IVuhVT668UYH1N0CU9KNbCaCSt1Cpr238O4n9eAy/PFAJlugWekgTuAx0IJRNPPk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:7cf:: with SMTP id
 bb15mr12249569qvb.29.1626470810648; Fri, 16 Jul 2021 14:26:50 -0700 (PDT)
Date: Fri, 16 Jul 2021 21:26:28 +0000
In-Reply-To: <20210716212629.2232756-1-oupton@google.com>
Message-Id: <20210716212629.2232756-12-oupton@google.com>
Mime-Version: 1.0
References: <20210716212629.2232756-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v2 11/12] selftests: KVM: Test physical counter offsetting
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
index 88ad997f5b69..3eed9dcb7693 100644
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
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
