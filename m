Return-Path: <SRS0=3Een=FN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0315C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:18:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8C04423340
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:18:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C04423340
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4052C4B242;
	Wed,  9 Dec 2020 08:18:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Nv0326mnQ4MU; Wed,  9 Dec 2020 08:18:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D6A84B310;
	Wed,  9 Dec 2020 08:18:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1B5F4B2F1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:18:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id voMSOfOKQLVi for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Dec 2020 08:18:07 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F59B4B290
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:18:06 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id x22so1443699wmc.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Dec 2020 05:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=Ka29+EvLzBVuz3fav1ANCIbzhqqYwi6Q4TnNct9LPkw=;
 b=GPfaJhmZTf789tZ6o4bBL5H00oWtl28s03PNuYmXtEC0DzS7vZ6fCi2db4iIw/YC+D
 r1dM6gMfsFzU6WDlWzCNMeBoWmQ6xEjz4kIgTDVNATNmHG75fJQfbXu4jdZRTiYfpq2H
 Dk7CPz33RuE6JEDrNdDlpREIanGgLVvYaQOeaOn7XWPvQhziehz3AmfI5oRiyyTn9dq3
 fp9/AM3vLnDDsyE4sfNiz56C2yhMp2bG0rme7rq1sxMIRb+AKEbJR/j4/FDFGAYqX6/s
 Ea/eQzy86guK9WGUt9pl73Ymd5MjC7fLdWmrNJ6fYcgqmjk/jIFL+8NHWrD6BljBKy/S
 kH8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=Ka29+EvLzBVuz3fav1ANCIbzhqqYwi6Q4TnNct9LPkw=;
 b=Pxyb4A8s0YRUoyJjv3cZXcsZZvIpHQFJB6kGw/oFjrfrL2kGWQX4L02RxGMybpsGsA
 XWNmfIPoYoAopiGMMLsuEUN2VL351e89d9TWZDZPlX0RNIkldwU/OJbbt7NWaq1WYgnA
 fCeZNVgqWq3LIJXwTsQhXDAggBlOy1kOSUmYkUspwxlt+UDtEut9PJPueiA84ul6Fg/c
 4GB3kavgc9wECDb+NV8dtzE3NtkFNdzuRE4PXUT9ElyMdoyRHxzaiX/J7T0eduu169ct
 4WamfXkWE/Y/8PdX6iL8HB+Dei3He2WVi7HuB4Y0YyGdSy/2x6PiJAE/WxA73p+qAtQn
 f/Rg==
X-Gm-Message-State: AOAM530vuUYfoqeGwGT01oMVGgWMF5stdwmHXGa3tpzBwCugkkyflv3/
 nBYHeZNkV2CrS5qMtDGun3zmVNyFfY1lcQ==
X-Google-Smtp-Source: ABdhPJxUH+7Om8LR7fdHJ1zEhtXybe8x1ZcwYnq6Mf5JFSkMDCTGF7hQ7t2De1RstIBLw7B9PuXGCg==
X-Received: by 2002:a1c:e1c6:: with SMTP id y189mr2689110wmg.172.1607519884763; 
 Wed, 09 Dec 2020 05:18:04 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:9d1b:d0eb:db43:6cd2])
 by smtp.gmail.com with ESMTPSA id z64sm3240255wme.10.2020.12.09.05.18.03
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Dec 2020 05:18:03 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 7/9] KVM: arm64: Fix constant-pool users in hyp
Date: Wed,  9 Dec 2020 13:17:44 +0000
Message-Id: <20201209131746.85622-8-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209131746.85622-1-dbrazdil@google.com>
References: <20201209131746.85622-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
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
2.29.2.576.ga3fc446d84-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
