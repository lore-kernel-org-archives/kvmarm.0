Return-Path: <SRS0=JLBt=LF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0718EC48BDF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 01:10:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8112C613B3
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 01:10:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8112C613B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3178A4B0BD;
	Thu, 10 Jun 2021 21:10:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8JzGrJZg5C8O; Thu, 10 Jun 2021 21:10:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 927784B0AD;
	Thu, 10 Jun 2021 21:10:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C30534B09F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 21:10:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nce2pZXebhzp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jun 2021 21:10:30 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6401A4B09C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 21:10:29 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 q3-20020aa784230000b02902ea311f25e2so2241632pfn.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 18:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=TYvOocfdGGEik5oZUAe7GQBrIevpGvdRMy9WY4nI218=;
 b=nJiRvBrw35+0e+bGUhSL73s0Hx6KBViDlQOEx2lufnpIp8rb+7F4TVjxSimCI21IaT
 gf65GmCFoRjdO3sMt19FwCyYyKMze/l4ZNpy155VJMv0I3Qusn9XPVyeivmGgI8Ei5Nv
 P3QviUCZNiaiXjjZ67VtOyunCLgJsB7VO9dO5q9N32cBGYk4oqLQXMkZXGn2uGthIbLp
 XjluerlLQa9RLg9DZMkoM0JjriEkldpHGApbJefIudAby1QNU+MvVOmCTX+QbjPJTHZo
 vUrcCT9k0ED5QM9hzhCI+jNqC9iAEV5SVSdv/e8dohRd+XcUPks0yh5nqy/gY/q4/RoP
 UxHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=TYvOocfdGGEik5oZUAe7GQBrIevpGvdRMy9WY4nI218=;
 b=rGkNTcWUwnQzWmPGOAxfGyIHDZKBoc89eKOFuvxopAKDfS25bYx9WFM9GrQRYfFElk
 DihhZnkDFudCjx1DRuuW22/XRSNvZEdCzQSXkKvwzQCBavriqINZMJuevOBiG/7YKEUR
 2dm39IDFIUxvpooBnuhpeADR0Oh4QZU7rzUf6a2nY0EmKy3fvgSlVyTeEUjlbEYZffxC
 yT0BMt5JhcTuRk15ZOX8lkkwADZAgzk/FZlCwyS61e7iU5fGI287K7kqilCbyO7Iavcl
 1+S+xL9ASubuBOG20eHLmDcK3xZTCnqG4iXoLi6JytenTJoj8WQNhyijOs2pZKTytlok
 YEsQ==
X-Gm-Message-State: AOAM532TQwbjI+cFuAXaXa5bOzgSFQy2EUGjSjfW45Uof5gOV//TfUOZ
 Z6EYYScAitqvqeSUHQK8xqZ4NUi4f0TPMg==
X-Google-Smtp-Source: ABdhPJycRe7gKvuKJjbcx7/YnZK2hdrk+Fowwdb5tNbq0e3YWn5ixMHsFSvSFp/tERi+LURVZLTQINtmCH9KPw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:720b:b029:113:19d7:2da7 with SMTP
 id ba11-20020a170902720bb029011319d72da7mr1419291plb.55.1623373828499; Thu,
 10 Jun 2021 18:10:28 -0700 (PDT)
Date: Thu, 10 Jun 2021 18:10:17 -0700
In-Reply-To: <20210611011020.3420067-1-ricarkol@google.com>
Message-Id: <20210611011020.3420067-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20210611011020.3420067-1-ricarkol@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v4 3/6] KVM: selftests: Introduce UCALL_UNHANDLED for
 unhandled vector reporting
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com
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
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 .../selftests/kvm/include/x86_64/processor.h  |  2 --
 .../selftests/kvm/lib/x86_64/processor.c      | 19 ++++++++-----------
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index fcd8e3855111..beb76d6deaa9 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -349,6 +349,7 @@ enum {
 	UCALL_SYNC,
 	UCALL_ABORT,
 	UCALL_DONE,
+	UCALL_UNHANDLED,
 };
 
 #define UCALL_MAX_ARGS 6
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index e9f584991332..92a62c6999bc 100644
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
index 257c5c33d04e..a217515a9bc2 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1201,7 +1201,7 @@ static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
 
 void kvm_exit_unexpected_vector(uint32_t value)
 {
-	outl(UNEXPECTED_VECTOR_PORT, value);
+	ucall(UCALL_UNHANDLED, 1, value);
 }
 
 void route_exception(struct ex_regs *regs)
@@ -1254,16 +1254,13 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 
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
+
+		TEST_FAIL("Unexpected vectored event in guest (vector:0x%lx)",
+			  vector);
 	}
 }
 
-- 
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
