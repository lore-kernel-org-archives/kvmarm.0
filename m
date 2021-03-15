Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE3ABC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:23:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3F9A664F4B
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:23:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F9A664F4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BED6D4B52F;
	Mon, 15 Mar 2021 10:23:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JTlCCYgyCa5B; Mon, 15 Mar 2021 10:23:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C00E4B555;
	Mon, 15 Mar 2021 10:23:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 945494B52F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:23:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0ZNr7H+LagUB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:23:20 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 344A94B34C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:23:19 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34CDA64F4F;
 Mon, 15 Mar 2021 14:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1615818196;
 bh=Mfsk9xHSj2fZ0ODSAngoMCjKk3eFvyRGtizLQ1ab/J0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=B8yFMnNvAAzPUMcTXx5wUUMUE3JOH7AKclIc/o+fcU+msJB8Eo9ZUKJugXJcjT4+n
 4E6gi7rWZcN+NcoIEr2G6mVs0tyoWlfPxdEU6ao36ntlCOfyVwds6GEgpteFU2LFp5
 oHp/bDlLCcfnXE9vAl0HWvgLPPD9zZBkS5agHsE8=
From: gregkh@linuxfoundation.org
To: linux-kernel@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 5.10 289/290] KVM: arm64: Fix nVHE hyp panic host context
 restore
Date: Mon, 15 Mar 2021 15:22:39 +0100
Message-Id: <20210315135551.812754429@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135551.391322899@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
 <20210315135551.391322899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Andrew Scull <ascull@google.com>

Commit c4b000c3928d4f20acef79dccf3a65ae3795e0b0 upstream.

When panicking from the nVHE hyp and restoring the host context, x29 is
expected to hold a pointer to the host context. This wasn't being done
so fix it to make sure there's a valid pointer the host context being
used.

Rather than passing a boolean indicating whether or not the host context
should be restored, instead pass the pointer to the host context. NULL
is passed to indicate that no context should be restored.

Fixes: a2e102e20fd6 ("KVM: arm64: nVHE: Handle hyp panics")
Cc: stable@vger.kernel.org # 5.10.y only
Signed-off-by: Andrew Scull <ascull@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210219122406.1337626-1-ascull@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_hyp.h |    3 ++-
 arch/arm64/kvm/hyp/nvhe/host.S   |   20 ++++++++++----------
 arch/arm64/kvm/hyp/nvhe/switch.c |    3 +--
 3 files changed, 13 insertions(+), 13 deletions(-)

--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -99,7 +99,8 @@ u64 __guest_enter(struct kvm_vcpu *vcpu)
 
 void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
+void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
+			       u64 elr, u64 par);
 #endif
 
 #endif /* __ARM64_KVM_HYP_H__ */
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -64,10 +64,15 @@ __host_enter_without_restoring:
 SYM_FUNC_END(__host_exit)
 
 /*
- * void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
+ * void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
+ * 				  u64 elr, u64 par);
  */
 SYM_FUNC_START(__hyp_do_panic)
-	/* Load the format arguments into x1-7 */
+	mov	x29, x0
+
+	/* Load the format string into x0 and arguments into x1-7 */
+	ldr	x0, =__hyp_panic_string
+
 	mov	x6, x3
 	get_vcpu_ptr x7, x3
 
@@ -82,13 +87,8 @@ SYM_FUNC_START(__hyp_do_panic)
 	ldr	lr, =panic
 	msr	elr_el2, lr
 
-	/*
-	 * Set the panic format string and enter the host, conditionally
-	 * restoring the host context.
-	 */
-	cmp	x0, xzr
-	ldr	x0, =__hyp_panic_string
-	b.eq	__host_enter_without_restoring
+	/* Enter the host, conditionally restoring the host context. */
+	cbz	x29, __host_enter_without_restoring
 	b	__host_enter_for_panic
 SYM_FUNC_END(__hyp_do_panic)
 
@@ -144,7 +144,7 @@ SYM_FUNC_END(__hyp_do_panic)
 
 .macro invalid_host_el1_vect
 	.align 7
-	mov	x0, xzr		/* restore_host = false */
+	mov	x0, xzr		/* host_ctxt = NULL */
 	mrs	x1, spsr_el2
 	mrs	x2, elr_el2
 	mrs	x3, par_el1
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -260,7 +260,6 @@ void __noreturn hyp_panic(void)
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg_par();
-	bool restore_host = true;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
 
@@ -274,7 +273,7 @@ void __noreturn hyp_panic(void)
 		__sysreg_restore_state_nvhe(host_ctxt);
 	}
 
-	__hyp_do_panic(restore_host, spsr, elr, par);
+	__hyp_do_panic(host_ctxt, spsr, elr, par);
 	unreachable();
 }
 


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
