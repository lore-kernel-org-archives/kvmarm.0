Return-Path: <SRS0=QphI=J3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9252DC433B4
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 23:24:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2BA8E61420
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 23:24:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BA8E61420
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA1A84B47F;
	Fri, 30 Apr 2021 19:24:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Os3O8ICvw+vJ; Fri, 30 Apr 2021 19:24:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77B8A4B4A0;
	Fri, 30 Apr 2021 19:24:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB3974B49B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 19:24:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QZvSqNR6wr0K for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Apr 2021 19:24:14 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89DDB4B47F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 19:24:14 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 m1-20020a2526010000b02904f4d04c0f14so3463078ybm.19
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 16:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=DrtIzoZNc79OT7R03r+6Yhv7XXgWtVPXBdQ8gE5Za50=;
 b=hrA93mrfNvMtPI4VgsoEAfSKtto6rMPg+XTcD8MyoMUgLaj5o9tLH3AwvT5hgfwWoZ
 etFwv7KD1vg1aRcGGpw5PRSmKq0tE7WHqERR0XauYivNrLYKmOMuupUwQSfEtWMh08r7
 cihPWH3QFt9w3b/V5DeidqkD26w13mLIzcyk41Ym+dhZEgIB0D9x5VVCS+lVeGLOkMhD
 gaP8C7S9g51MowvglkvRjiDYjSssCj4VTPEz6dLV2SIIkDSRr6L80gCz1m98goVOv9hq
 bem2O7Q/hq4UwAFPSw7yjYDMgsjtpCd+KOA/kjvaSRPKIuZorYXLQ7D3DugljqjU1d5q
 96Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=DrtIzoZNc79OT7R03r+6Yhv7XXgWtVPXBdQ8gE5Za50=;
 b=uJcd1v/qrUmQpNoFjOqoMJYFAu0raRxpQfzVXP1ihvw6unhHowfthpFIy7hI1aLgkI
 MLYwUmYDiwxuR7r3tj+Ohy42RiJFLsypWJnUM3bBD5qhHu5gr5riX321IP4ypzfco5Nl
 xRASYsHABOfWnEK5ybGFKS0waIi6f0A7/dPug+5LC+MT8AhGU7dJwyNHfsxPyK1NpeUU
 HG4VKAFb8DuoMVYbeazNJhhDa/CpfX8ckz4IenOVXi/SCDp2muV0Y6FaVMNcTRi75ALQ
 EmpxidR+tpw6OkniJhjcfJMe2KUm/XoMK2S2NolTgETG26+T0BjwS9+96DtpsAHx47KS
 pzjA==
X-Gm-Message-State: AOAM530KegnUe+I2UdDmVSxFkK1kD1Ya+d0JXGONZlkl7yCEBfBsVjy9
 7QKgYghC31xALikxaR47pp/PCGNs+RI7Ww==
X-Google-Smtp-Source: ABdhPJxCH47qwg6o/sPFrCh0eBsljgWhHVIlR+rd2tL+C+5G+0C/awiKqu15PVkzt+chVmExB8oH4/OW2Cw2GQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:6d82:: with SMTP id
 i124mr10969252ybc.78.1619825053901; Fri, 30 Apr 2021 16:24:13 -0700 (PDT)
Date: Fri, 30 Apr 2021 16:24:04 -0700
In-Reply-To: <20210430232408.2707420-1-ricarkol@google.com>
Message-Id: <20210430232408.2707420-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210430232408.2707420-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v2 2/5] KVM: selftests: Introduce UCALL_UNHANDLED for
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

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h    |  1 +
 .../selftests/kvm/include/x86_64/processor.h      |  2 --
 .../testing/selftests/kvm/lib/x86_64/processor.c  | 15 ++++++---------
 3 files changed, 7 insertions(+), 11 deletions(-)

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
index e156061263a6..96e2bd9d66eb 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1207,7 +1207,7 @@ static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
 
 void kvm_exit_unexpected_vector(uint32_t value)
 {
-	outl(UNEXPECTED_VECTOR_PORT, value);
+	ucall(UCALL_UNHANDLED, 1, value);
 }
 
 void route_exception(struct ex_regs *regs)
@@ -1260,16 +1260,13 @@ void vm_install_vector_handler(struct kvm_vm *vm, int vector,
 
 void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	if (vcpu_state(vm, vcpuid)->exit_reason == KVM_EXIT_IO
-		&& vcpu_state(vm, vcpuid)->io.port == UNEXPECTED_VECTOR_PORT
-		&& vcpu_state(vm, vcpuid)->io.size == 4) {
-		/* Grab pointer to io data */
-		uint32_t *data = (void *)vcpu_state(vm, vcpuid)
-			+ vcpu_state(vm, vcpuid)->io.data_offset;
+	struct ucall uc;
 
+	if (get_ucall(vm, vcpuid, &uc) == UCALL_UNHANDLED) {
+		uint64_t vector = uc.args[0];
 		TEST_ASSERT(false,
-			    "Unexpected vectored event in guest (vector:0x%x)",
-			    *data);
+			    "Unexpected vectored event in guest (vector:0x%lx)",
+			    vector);
 	}
 }
 
-- 
2.31.1.527.g47e6f16901-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
