Return-Path: <SRS0=8Q7i=JU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA2CEC433B4
	for <kvmarm@archiver.kernel.org>; Fri, 23 Apr 2021 04:04:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 566A261422
	for <kvmarm@archiver.kernel.org>; Fri, 23 Apr 2021 04:04:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 566A261422
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED5CD4B404;
	Fri, 23 Apr 2021 00:04:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8EinspyeO0KI; Fri, 23 Apr 2021 00:04:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52AE54B4FD;
	Fri, 23 Apr 2021 00:04:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 775F04B4DF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 00:04:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MVuvlzXyzTBC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Apr 2021 00:04:06 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19E5E4B4E8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 00:04:05 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 d8-20020a25eb080000b02904e6f038cad5so22540649ybs.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 21:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=pLr79XnV8jmiBhfuyZ12keZz7+PeIzV/RdJo7lz5a20=;
 b=TDeHItoYGUinQ5QfVFpTL9KILDA55Eqn4P65h4cPvtOkm4/Hmqrls8C4Slk0v6F4IT
 NqJ9cYJ2KSsFs1KHdlBIPWaV8rmRK4hrMa6Y/a1MYl7ey3n9kLbbbTM0q1nTAmx4ScLs
 bIdv46WvetYgzKQ4j7cVx4LDhLZZ0lGm2vypeBBIXERpx31lAA7DitsO3LB+IehHp2Fb
 CLp8sB8rxT38ZjW5CwKCZ1azBOXZ3YrFckKxETy1NBIheZJPE2zsEZGQM18srrJ1yF6F
 Z3Akj1ATZnFuOu7DXPqdyAeuxC636MRHtXxDfsv5LnAKcA1PibKrADuGZwSbdH5hWb+v
 5r1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=pLr79XnV8jmiBhfuyZ12keZz7+PeIzV/RdJo7lz5a20=;
 b=Z12pWU+1gyOJsS0eCL5lYUzMgBTNzj3bYFq4zzUkjKSwV3dOEoow3yacz4XMoCiw48
 nEF2WuwFI2O2wCn4HGSE8IdTXPjfDRIKAMuBvdKR+L2Ve0YxB3w9PcC7KkV2NoymmLnw
 Ya0fzRocDkjUxbaYrLssGefXvbuWe7GgW5B7sxXG5gBS/uy3zA0ruWih0NFZGzpfRqPh
 EMzolbUxtOp4Pxw38YROyUQJkCd0SGj6Em4GcHtDNqiYGWce9j+f+fg5xZCSIqfuKYFy
 ewdNGYPjw4MvWJG3ITibVTXQy4EPOnSGWodI0UozRx1o5Hl3vDq5xCIoUMNygLcKgCIR
 wCUA==
X-Gm-Message-State: AOAM533byI2Uh1adGrPPBbSb6UBTdrCOC8W1D7gA06HE+ZEzrjYrLC0Z
 RmLf8pT3l3Xm0Zp4D4reLgRtQSDyVOxJTA==
X-Google-Smtp-Source: ABdhPJzhqbqtTQPQkUA/D6mJDIS4i1hcyAOurGPF5ymBCTAppBaYCTEgyxXu+iOrn6eJPsYb2pQgCNtory3+JQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:bad0:: with SMTP id
 a16mr2733788ybk.441.1619150644548; Thu, 22 Apr 2021 21:04:04 -0700 (PDT)
Date: Thu, 22 Apr 2021 21:03:51 -0700
In-Reply-To: <20210423040351.1132218-1-ricarkol@google.com>
Message-Id: <20210423040351.1132218-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20210423040351.1132218-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 3/3] KVM: selftests: Use a ucall for x86 unhandled vector
 reporting
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

x86 reports unhandled vectors using port IO at a specific port number,
which is replicating what ucall already does for x86.  Aarch64, on the
other hand, reports unhandled vector exceptions with a ucall using a
recently added UCALL_UNHANDLED ucall type.

Replace the x86 unhandled vector exception handling to use ucall
UCALL_UNHANDLED instead of port IO.

Tested: Forcing a page fault in the ./x86_64/xapic_ipi_test
	halter_guest_code() shows this:

	$ ./x86_64/xapic_ipi_test
	...
	  Unexpected vectored event in guest (vector:0xe)

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h      |  2 --
 .../testing/selftests/kvm/lib/x86_64/processor.c  | 15 ++++++---------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0b30b4e15c38..379f12cbdc06 100644
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
index a8906e60a108..284d26a25cd3 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1207,7 +1207,7 @@ static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
 
 void kvm_exit_unexpected_vector(uint32_t value)
 {
-	outl(UNEXPECTED_VECTOR_PORT, value);
+	ucall(UCALL_UNHANDLED, 1, value);
 }
 
 void route_exception(struct ex_regs *regs)
@@ -1260,16 +1260,13 @@ void vm_handle_exception(struct kvm_vm *vm, int vector,
 
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
2.31.1.498.g6c1eba8ee3d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
