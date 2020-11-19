Return-Path: <SRS0=Ckwh=EZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 714A5C6369E
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 16:26:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D6E8822264
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 16:26:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="v5R/bPXr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6E8822264
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 555334B488;
	Thu, 19 Nov 2020 11:26:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8dtvOVyQVdaL; Thu, 19 Nov 2020 11:26:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0508C4B530;
	Thu, 19 Nov 2020 11:26:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA1664B53F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 11:26:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aLfvMKgG2fHH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2020 11:26:00 -0500 (EST)
Received: from mail-ed1-f66.google.com (mail-ed1-f66.google.com
 [209.85.208.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B13F94B536
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 11:26:00 -0500 (EST)
Received: by mail-ed1-f66.google.com with SMTP id cf17so2896775edb.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 08:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=5MlXwXUoGcLbD/WCygRzjYFVebEXnf5c/lUquykfRUk=;
 b=v5R/bPXr6yxIRC4TnJkHhfGPg52KN0BTKGKdHosqzHDrdjOBD3OoLCLlGpvJ9vpZw7
 FSXShWWfwIGiDhhnTl+oinATAyoscG+OFYVmfCCL7jzESU8qE2IxvVgkmVLPG+p7Bx3R
 UHN1++6yqap4jQ2jeBeVZGOXdQq7aM0yVjNTXgCuXg6gJvlN6rsVY29Lj4/EWjZiGus5
 N7pIT1izOm/VG9jeByFsBKDqO1z2FtKo53LfYREwOu7hPbTk42Ytd61KbHMnKl3nx/Lb
 jLDGaZD/BWTfhIwijj1lfSbsElbzU4oc3GfhlicRYmkGh04JSc+aoeChsMyHNNWmj+9n
 MbSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=5MlXwXUoGcLbD/WCygRzjYFVebEXnf5c/lUquykfRUk=;
 b=V8ELSH1NPd36lJ8Gp52h+zjcwYrZJZSCvJ0/zF422rB5yRfZUCHuq4EfayeDn9h0Pp
 7/AXQwXszyJ99gZJ2K8Kmf/p5gn1MTFpKZjcQAPFixtdbwf0C3QQk9AA3z+nO0TrRIPz
 9ZMGKqJXq9ax6O4L6ZWQQPPgk3kuw9a7trWVKZeSqcr1yuSGcKQ/9lTBbXMVefpKH/h1
 E6xIBKzosbaA+dA4oe66r4QiS6Fk870ZdViqyeRJ8rLDDGIXxuBIgi3pcETkIV/5CNX/
 5j4xFqo9lpSP0J1yPXBdr9fP4zLq1CwbRBvtclM9oTfRoFDJCgtO5IOK9d4j9c3XVnYs
 QA9w==
X-Gm-Message-State: AOAM532zfT0y/CFh2EdgmTJZYhKGa64KN+dEMYHovUHPUH0fiET/vZl0
 6fNR+WUZKMkc0NZj5mSvYU41mnaG0sQlFA==
X-Google-Smtp-Source: ABdhPJx9s7H/MTHz69bsGrNQ0l5Py2P1/7O779gADrD4sMkOQcjiC5QVePAr1gZhJn1q2f5rE9zzyA==
X-Received: by 2002:a05:6402:19b4:: with SMTP id
 o20mr7995752edz.103.1605803159276; 
 Thu, 19 Nov 2020 08:25:59 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:9843:cd3f:f36b:d55c])
 by smtp.gmail.com with ESMTPSA id g7sm15689057edl.5.2020.11.19.08.25.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 19 Nov 2020 08:25:58 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 5/6] kvm: arm64: Fix constant-pool users in hyp
Date: Thu, 19 Nov 2020 16:25:42 +0000
Message-Id: <20201119162543.78001-6-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119162543.78001-1-dbrazdil@google.com>
References: <20201119162543.78001-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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

Hyp code used to use absolute addressing via a constant pool to obtain
the kernel VA of 3 symbols - panic, __hyp_panic_string and
__kvm_handle_stub_hvc. This used to work because the kernel would
relocate the addresses in the constant pool to kernel VA at boot and hyp
would simply load them from there.

Now that relocations are fixed up to point to hyp VAs, this does not
work any longer. Rework the helpers to convert hyp VA to kernel VA / PA
as needed.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 29 +++++++++++++++++++----------
 arch/arm64/kvm/hyp/nvhe/host.S   | 29 +++++++++++++++--------------
 2 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 8cb8974ec9cc..0676ff2105bb 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -72,9 +72,14 @@ alternative_cb kvm_update_va_mask
 alternative_cb_end
 .endm
 
+.macro hyp_pa reg, tmp
+	ldr_l	\tmp, hyp_physvirt_offset
+	add	\reg, \reg, \tmp
+.endm
+
 /*
- * Convert a kernel image address to a PA
- * reg: kernel address to be converted in place
+ * Convert a hypervisor VA to a kernel image address
+ * reg: hypervisor address to be converted in place
  * tmp: temporary register
  *
  * The actual code generation takes place in kvm_get_kimage_voffset, and
@@ -82,18 +87,22 @@ alternative_cb_end
  * perform the register allocation (kvm_get_kimage_voffset uses the
  * specific registers encoded in the instructions).
  */
-.macro kimg_pa reg, tmp
+.macro hyp_kimg reg, tmp
+	/* Convert hyp VA -> PA. */
+	hyp_pa	\reg, \tmp
+
+	/* Load kimage_voffset. */
 alternative_cb kvm_get_kimage_voffset
-       movz    \tmp, #0
-       movk    \tmp, #0, lsl #16
-       movk    \tmp, #0, lsl #32
-       movk    \tmp, #0, lsl #48
+	movz	\tmp, #0
+	movk	\tmp, #0, lsl #16
+	movk	\tmp, #0, lsl #32
+	movk	\tmp, #0, lsl #48
 alternative_cb_end
 
-       /* reg = __pa(reg) */
-       sub     \reg, \reg, \tmp
+	/* Convert PA -> kimg VA. */
+	add	\reg, \reg, \tmp
 .endm
-	 
+
 #else
 
 #include <linux/pgtable.h>
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 596dd5ae8e77..bcb80d525d8c 100644
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
+	hyp_kimg lr, x6
 	msr	elr_el2, lr
 
-	/*
-	 * Set the panic format string and enter the host, conditionally
-	 * restoring the host context.
-	 */
+	/* Set the panic format string. Use the, now free, LR as scratch. */
+	ldr	lr, =__hyp_panic_string
+	hyp_kimg lr, x6
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
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
