Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F001CC433DB
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 18:06:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 987D422D50
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 18:06:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 987D422D50
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49FDA4B376;
	Tue,  5 Jan 2021 13:06:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tCPtGnrMeCX2; Tue,  5 Jan 2021 13:06:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEFD94B360;
	Tue,  5 Jan 2021 13:06:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A5504B367
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 13:06:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wgdS0nCZKzY3 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 13:06:06 -0500 (EST)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C34454B35B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 13:06:06 -0500 (EST)
Received: by mail-wr1-f48.google.com with SMTP id t16so108835wra.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Jan 2021 10:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=dix3bYmdBXfa2dvM/3epHm9UdTOsZAv1tziwrkIWTsM=;
 b=MW9ND0Ja8hBr3WKHYvWgOXqs8LFYBkvPI8vZTdbk3Nm29s6OJLTSBKKjxm/MY7MALb
 bqQaqBW3jkqxzruJJ8+II1DtC9U95dvBn/gZxGGJ9umtHE+8lZjA75LMJKiBKMi2BBDb
 lnbHao0KeI9kd3PXHq0P23AjPNKrdHrA+T89XvZFCnzgaZ08Ch9xvU7d15lRGIwyiSQl
 1hdJ77XMTj8FO2B+IDVJwml1ObYHR8NMQs8LW4C/ilzrhEOO5aF3c9VQhDaSzfWDb5q9
 aMFZL6Q+KCOLC5CM3SnjsYioKSuSqhfNuXtOF2wi2RZO71RXlyAFaEtY+yR5fGeHaFOg
 sRnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=dix3bYmdBXfa2dvM/3epHm9UdTOsZAv1tziwrkIWTsM=;
 b=qK8YhP9ehE3yIDau989seiOeMJ2rZAeuTAWUL0hTm94YQtscyIDaKVt7XCLb6EJymH
 4aJxHCvTszXXlwyEs1ka6nNpUqEsKd3F+O2OGXtvpfa66Ghvm9sN+fGdacVi9sx1+Sqn
 qjYJJ/hNaIGJVMdSl5gAWO1+SwH21D5dsXAY1UbKTSWbcMrNSFee8/K4cGtYuAfYO929
 p9gNO90KpwjqK0yVeBGgbpV138bLfA8wMs9WRl5/MQOm1ZvSpsE/c/SHufQPEsCNzqWp
 IBENdCYvPpgINqZz6mQeWg2ANNNXRpnlpwZ6Y8Ba61k9oBEViU/FyGqvH2C9CxAnQXdq
 AHzw==
X-Gm-Message-State: AOAM533/9QS6lkrKqyQUM0nKEXJPrQmXLNXx0sjli4XiVMbq1mJA+26y
 oaWDQBwoY8PL0F9vVF9y7lKncLl50sOr9A==
X-Google-Smtp-Source: ABdhPJydGN08iCmUa0phVLGrJ5kiEvZ039Q1do+c/mxRFjq5/twxkAf0qPoX/s9p98mPt7b7Ttw0kQ==
X-Received: by 2002:adf:fb05:: with SMTP id c5mr738228wrr.69.1609869965496;
 Tue, 05 Jan 2021 10:06:05 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:4957:71a5:7b5c:c94f])
 by smtp.gmail.com with ESMTPSA id q73sm326976wme.44.2021.01.05.10.06.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 05 Jan 2021 10:06:04 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 6/8] KVM: arm64: Fix constant-pool users in hyp
Date: Tue,  5 Jan 2021 18:05:39 +0000
Message-Id: <20210105180541.65031-7-dbrazdil@google.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210105180541.65031-1-dbrazdil@google.com>
References: <20210105180541.65031-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
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

Hyp code uses absolute addressing to obtain a kimg VA of a small number
of kernel symbols. Since the kernel now converts constant pool addresses
to hyp VAs, this trick does not work anymore.

Change the helpers to convert from hyp VA back to kimg VA or PA, as
needed and rework the callers accordingly.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h   | 42 ++++++++++++------------------
 arch/arm64/kvm/hyp/nvhe/host.S     | 29 +++++++++++----------
 arch/arm64/kvm/hyp/nvhe/hyp-init.S |  2 --
 3 files changed, 31 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6bbb44011c84..adadc468cc71 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -73,49 +73,39 @@ alternative_cb_end
 .endm
 
 /*
- * Convert a kernel image address to a PA
- * reg: kernel address to be converted in place
+ * Convert a hypervisor VA to a PA
+ * reg: hypervisor address to be converted in place
  * tmp: temporary register
- *
- * The actual code generation takes place in kvm_get_kimage_voffset, and
- * the instructions below are only there to reserve the space and
- * perform the register allocation (kvm_get_kimage_voffset uses the
- * specific registers encoded in the instructions).
  */
-.macro kimg_pa reg, tmp
-alternative_cb kvm_get_kimage_voffset
-	movz	\tmp, #0
-	movk	\tmp, #0, lsl #16
-	movk	\tmp, #0, lsl #32
-	movk	\tmp, #0, lsl #48
-alternative_cb_end
-
-	/* reg = __pa(reg) */
-	sub	\reg, \reg, \tmp
+.macro hyp_pa reg, tmp
+	ldr_l	\tmp, hyp_physvirt_offset
+	add	\reg, \reg, \tmp
 .endm
 
 /*
- * Convert a kernel image address to a hyp VA
- * reg: kernel address to be converted in place
+ * Convert a hypervisor VA to a kernel image address
+ * reg: hypervisor address to be converted in place
  * tmp: temporary register
  *
  * The actual code generation takes place in kvm_get_kimage_voffset, and
  * the instructions below are only there to reserve the space and
- * perform the register allocation (kvm_update_kimg_phys_offset uses the
+ * perform the register allocation (kvm_get_kimage_voffset uses the
  * specific registers encoded in the instructions).
  */
-.macro kimg_hyp_va reg, tmp
-alternative_cb kvm_update_kimg_phys_offset
+.macro hyp_kimg_va reg, tmp
+	/* Convert hyp VA -> PA. */
+	hyp_pa	\reg, \tmp
+
+	/* Load kimage_voffset. */
+alternative_cb kvm_get_kimage_voffset
 	movz	\tmp, #0
 	movk	\tmp, #0, lsl #16
 	movk	\tmp, #0, lsl #32
 	movk	\tmp, #0, lsl #48
 alternative_cb_end
 
-	sub	\reg, \reg, \tmp
-	mov_q	\tmp, PAGE_OFFSET
-	orr	\reg, \reg, \tmp
-	kern_hyp_va \reg
+	/* Convert PA -> kimg VA. */
+	add	\reg, \reg, \tmp
 .endm
 
 #else
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index a820dfdc9c25..6585a7cbbc56 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -74,27 +74,28 @@ SYM_FUNC_END(__host_enter)
  * void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
  */
 SYM_FUNC_START(__hyp_do_panic)
-	/* Load the format arguments into x1-7 */
-	mov	x6, x3
-	get_vcpu_ptr x7, x3
-
-	mrs	x3, esr_el2
-	mrs	x4, far_el2
-	mrs	x5, hpfar_el2
-
 	/* Prepare and exit to the host's panic funciton. */
 	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
 		      PSR_MODE_EL1h)
 	msr	spsr_el2, lr
 	ldr	lr, =panic
+	hyp_kimg_va lr, x6
 	msr	elr_el2, lr
 
-	/*
-	 * Set the panic format string and enter the host, conditionally
-	 * restoring the host context.
-	 */
+	/* Set the panic format string. Use the, now free, LR as scratch. */
+	ldr	lr, =__hyp_panic_string
+	hyp_kimg_va lr, x6
+
+	/* Load the format arguments into x1-7. */
+	mov	x6, x3
+	get_vcpu_ptr x7, x3
+	mrs	x3, esr_el2
+	mrs	x4, far_el2
+	mrs	x5, hpfar_el2
+
+	/* Enter the host, conditionally restoring the host context. */
 	cmp	x0, xzr
-	ldr	x0, =__hyp_panic_string
+	mov	x0, lr
 	b.eq	__host_enter_without_restoring
 	b	__host_enter_for_panic
 SYM_FUNC_END(__hyp_do_panic)
@@ -124,7 +125,7 @@ SYM_FUNC_END(__hyp_do_panic)
 	 * Preserve x0-x4, which may contain stub parameters.
 	 */
 	ldr	x5, =__kvm_handle_stub_hvc
-	kimg_pa x5, x6
+	hyp_pa	x5, x6
 	br	x5
 .L__vect_end\@:
 .if ((.L__vect_end\@ - .L__vect_start\@) > 0x80)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 68fd64f2313e..99b408fe09ee 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -139,7 +139,6 @@ alternative_else_nop_endif
 
 	/* Set the host vector */
 	ldr	x0, =__kvm_hyp_host_vector
-	kimg_hyp_va x0, x1
 	msr	vbar_el2, x0
 
 	ret
@@ -198,7 +197,6 @@ SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
 	/* Leave idmap. */
 	mov	x0, x29
 	ldr	x1, =kvm_host_psci_cpu_entry
-	kimg_hyp_va x1, x2
 	br	x1
 SYM_CODE_END(__kvm_hyp_init_cpu)
 
-- 
2.29.2.729.g45daf8777d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
