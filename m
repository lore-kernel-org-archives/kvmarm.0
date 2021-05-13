Return-Path: <SRS0=4nKG=KI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FCA5C433B4
	for <kvmarm@archiver.kernel.org>; Thu, 13 May 2021 00:28:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 24A2C613CA
	for <kvmarm@archiver.kernel.org>; Thu, 13 May 2021 00:28:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24A2C613CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C582A4B84E;
	Wed, 12 May 2021 20:28:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id toPusM7EazSY; Wed, 12 May 2021 20:28:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B85074B853;
	Wed, 12 May 2021 20:28:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A87474B552
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 20:28:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id faRgrUrB-MHc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 20:28:17 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 29AE54B85D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 20:28:16 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 d18-20020a05620a2052b02902eabc6fa35eso12709258qka.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 17:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=v+v7lxe4WlcHH5qrWKNitEm44ROd/TrmyyIntoQFZSQ=;
 b=MgO+hRdgNusWw0X6oTyPfwT0qVeJwDZZTQyY7h9Ntg3CRab7m62wAfWI5Yr2ui9r+Q
 Ff1ISOwvRyrp4mHRxt7XI7sQTVxyuyQxVzS4yRq1goD31X3ilD722VBrJS/P9VvYyN1M
 wQqueGA0hE8Edj2TWZTfACDGNbTAFsW3eTXGwnTFF84dsVJjuU+0hFVaZrc9LGQUXzZK
 ulQjJ5R2I/1xyVXA642FliIr66g2bwK+3A31AJfU34ENfRo2flV1EQ3KSWddgJ38pBnJ
 BRolmS+o7mKlbeNKt6yHex8JW3JWNyZi1HwFpusVmHb+OjEYndY3H+u1NLxZE4sMQ1UT
 KN0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=v+v7lxe4WlcHH5qrWKNitEm44ROd/TrmyyIntoQFZSQ=;
 b=jIqLZ2IK5ugLhiFzL2x1Q9jywMw1iy/e+GoqRFImpLylFCt6iXg1WTk1XibhKJIT09
 qIA2Af3frWh3EMQWPpFMpiu6pV+2yR92GS5r3Jw1UnWHZv7KHIsECKniP0Szb3HOQOTJ
 fXL6pLNITafyirQHHJc14UXY6mmTo98+6b0Ak5bslm8kRn7JPZid4Dmf/jQLFTOUAgzE
 5gbiWxrNiVFN4hfMjOSCiet16H+w+BPg/FjDQploHWvuAn1twaaoakLc/HjG/uHdLlIG
 mdwScIR9OuO34AGhHseffJCQOLqaS082R24WugC6Twm4Xah87q5r5Wuxa9MGvbYr15EN
 NeGw==
X-Gm-Message-State: AOAM531UZKaKkuGGQODpIXKNq1SEnT7Mca8UZn5L3r82SlrlfsOOGrhW
 Uu1DgiRPaclnxVN3SQoTD5k22IzRAcNDPw==
X-Google-Smtp-Source: ABdhPJxXjjcZr8CNIZJnomdYGWC+gztPAf88F8UD2shglQJhf5+t1KFDX5YI9pcZ6rvqnCIxDlFK7m/zQ6guEA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:ad4:5aa1:: with SMTP id
 u1mr37879334qvg.23.1620865688188; Wed, 12 May 2021 17:28:08 -0700 (PDT)
Date: Wed, 12 May 2021 17:27:59 -0700
In-Reply-To: <20210513002802.3671838-1-ricarkol@google.com>
Message-Id: <20210513002802.3671838-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210513002802.3671838-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v3 2/5] KVM: selftests: Introduce UCALL_UNHANDLED for
 unhandled vector reporting
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, pbonzini@redhat.com
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

x86, the only arch implementing exception handling, reports unhandled
vectors using port IO at a specific port number. This replicates what
ucall already does.

Introduce a new ucall type, UCALL_UNHANDLED, for guests to report
unhandled exceptions. Then replace the x86 unhandled vector exception
reporting to use it instead of port IO.  This new ucall type will be
used in the next commits by arm64 to report unhandled vectors as well.

Tested: Forcing a page fault in the ./x86_64/xapic_ipi_test
	halter_guest_code() shows this:

	$ ./x86_64/xapic_ipi_test
	...
	  Unexpected vectored event in guest (vector:0xe)

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h |  1 +
 .../selftests/kvm/include/x86_64/processor.h   |  2 --
 .../selftests/kvm/lib/x86_64/processor.c       | 18 +++++++-----------
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index bea4644d645d..7880929ea548 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -347,6 +347,7 @@ enum {
 	UCALL_SYNC,
 	UCALL_ABORT,
 	UCALL_DONE,
+	UCALL_UNHANDLED,
 };
 
 #define UCALL_MAX_ARGS 6
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 12889d3e8948..ff4da2f95b13 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -53,8 +53,6 @@
 #define CPUID_PKU		(1ul << 3)
 #define CPUID_LA57		(1ul << 16)
 
-#define UNEXPECTED_VECTOR_PORT 0xfff0u
-
 /* General Registers in 64-Bit Mode */
 struct gpr64_regs {
 	u64 rax;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index e156061263a6..814bb695d803 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1207,7 +1207,7 @@ static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
 
 void kvm_exit_unexpected_vector(uint32_t value)
 {
-	outl(UNEXPECTED_VECTOR_PORT, value);
+	ucall(UCALL_UNHANDLED, 1, value);
 }
 
 void route_exception(struct ex_regs *regs)
@@ -1260,16 +1260,12 @@ void vm_install_vector_handler(struct kvm_vm *vm, int vector,
 
 void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	if (vcpu_state(vm, vcpuid)->exit_reason == KVM_EXIT_IO
-		&& vcpu_state(vm, vcpuid)->io.port == UNEXPECTED_VECTOR_PORT
-		&& vcpu_state(vm, vcpuid)->io.size == 4) {
-		/* Grab pointer to io data */
-		uint32_t *data = (void *)vcpu_state(vm, vcpuid)
-			+ vcpu_state(vm, vcpuid)->io.data_offset;
-
-		TEST_ASSERT(false,
-			    "Unexpected vectored event in guest (vector:0x%x)",
-			    *data);
+	struct ucall uc;
+
+	if (get_ucall(vm, vcpuid, &uc) == UCALL_UNHANDLED) {
+		uint64_t vector = uc.args[0];
+		TEST_FAIL("Unexpected vectored event in guest (vector:0x%lx)",
+			  vector);
 	}
 }
 
-- 
2.31.1.607.g51e8a6a459-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
