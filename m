Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12968C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 20:06:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B29C64B24E;
	Fri,  8 Apr 2022 16:06:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OvUPzZ-YxarA; Fri,  8 Apr 2022 16:06:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95B1A4B230;
	Fri,  8 Apr 2022 16:06:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78E3B4B215
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 16:06:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Iw9y9KZ8wqrO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 16:06:21 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6BB584B0D0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 16:06:21 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b65-20020a25e444000000b0063dd00480f8so7562159ybh.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2022 13:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=x93NDMtIcx2idQMr+unDlcAPSW8WF5PhRWgttKX+iKU=;
 b=lkbCS6nMzD5l/NcfUbqdzOcFcXYuIbONUYKihkgTAKdwgS6qEgzrB//n/sVPVjQVBN
 4TuMybTXOq6SdpwsF6dxtvqZOYY7VvHb9RTVpMl14NmmXLDuS9Dy8/EpGpgazblTzo5Z
 iQ+S2yTm9lt6slO4knFUusXLB7ckzd1OY/0OGn5uGk9NNTCRe156PiP5ijiUOlzaZ5hQ
 nyY+d8/52jbYZdGa6mc7lFI2yrIVD7FeRIerU6SyqoC6BJPdBNgLEHi8rjdHRnAaOGfD
 LGxR5ljbg2jbzimVVHo0ksIW0CZd/TUsw3MA82vloWJI8+3bX3PFOJFnr0lYDtKXywhm
 Horg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=x93NDMtIcx2idQMr+unDlcAPSW8WF5PhRWgttKX+iKU=;
 b=qbAFFnLkVc2j+qxhuX+wJcQ0qkSe+9psH+HedllsVPf8/M16y7t9gEgBYMkpfalSN5
 1RlcwitJVhkeDT+Ew4FdToglTwPYC5BMsXpknQe1G3VRyuHib5QjA0LumEqKruBGgJkm
 4we/4T90STA3s3PJ3ye/Pu6HOJ1gfN9Mx/DPPOUO8TKxXAtf0SAqRTCGJAkpGqQw6EoK
 nNcbNVkACLDfNF7qs0pgIwTAqGu3qCKe/SrhKpe1+FuWBLFIChGjd096kIQYcRds3qQH
 TOCY6JDwuUxFdYl2TydeBOrcsBIboCdOEzxSxC6OyvL+jgVm4zwB5Ya7LLL+W9RWgH6R
 izgA==
X-Gm-Message-State: AOAM533K1HXgKj+8KpnfM6pL9RysumUekNPphhH8viwu5aH496Qemprq
 XqmO0urbCAwM/JWqtEOW/TnsLptJmB7cmINw1Q==
X-Google-Smtp-Source: ABdhPJznbHjSSh4+bEaUognEJWHkByuTOiqR2U6CXPMcOP7Ibq65oUjuo1XwZfsOSWyX8z1IEKsec19wpvjz1Bp34A==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f0ed:c8a:dab7:ecc2])
 (user=kaleshsingh job=sendgmr) by 2002:a5b:982:0:b0:63e:7d7e:e2f2 with SMTP
 id c2-20020a5b0982000000b0063e7d7ee2f2mr5160129ybq.549.1649448380890; Fri, 08
 Apr 2022 13:06:20 -0700 (PDT)
Date: Fri,  8 Apr 2022 13:03:28 -0700
In-Reply-To: <20220408200349.1529080-1-kaleshsingh@google.com>
Message-Id: <20220408200349.1529080-6-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220408200349.1529080-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v7 5/6] KVM: arm64: Detect and handle hypervisor stack
 overflows
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 maz@kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
 kernel-team@android.com, Nathan Chancellor <nathan@kernel.org>,
 linux-arm-kernel@lists.infradead.org, surenb@google.com,
 linux-kernel@vger.kernel.org, Changbin Du <changbin.du@intel.com>
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

The hypervisor stacks (for both nVHE Hyp mode and nVHE protected mode)
are aligned such  that any valid stack address has PAGE_SHIFT bit as 1.
This allows us to conveniently check for overflow in the exception entry
without corrupting any GPRs. We won't recover from a stack overflow so
panic the hypervisor.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
---

Changes in v7:
  - Add Fuad's Reviewed-by and Tested-by tags.

Changes in v5:
  - Valid stack addresses now have PAGE_SHIFT bit as 1 instead of 0

Changes in v3:
  - Remove test_sp_overflow macro, per Mark
  - Add asmlinkage attribute for hyp_panic, hyp_panic_bad_stack, per Ard


 arch/arm64/kvm/hyp/nvhe/host.S   | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c |  7 ++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 3d613e721a75..be6d844279b1 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -153,6 +153,18 @@ SYM_FUNC_END(__host_hvc)
 
 .macro invalid_host_el2_vect
 	.align 7
+
+	/*
+	 * Test whether the SP has overflowed, without corrupting a GPR.
+	 * nVHE hypervisor stacks are aligned so that the PAGE_SHIFT bit
+	 * of SP should always be 1.
+	 */
+	add	sp, sp, x0			// sp' = sp + x0
+	sub	x0, sp, x0			// x0' = sp' - x0 = (sp + x0) - x0 = sp
+	tbz	x0, #PAGE_SHIFT, .L__hyp_sp_overflow\@
+	sub	x0, sp, x0			// x0'' = sp' - x0' = (sp + x0) - sp = x0
+	sub	sp, sp, x0			// sp'' = sp' - x0 = (sp + x0) - x0 = sp
+
 	/* If a guest is loaded, panic out of it. */
 	stp	x0, x1, [sp, #-16]!
 	get_loaded_vcpu x0, x1
@@ -165,6 +177,18 @@ SYM_FUNC_END(__host_hvc)
 	 * been partially clobbered by __host_enter.
 	 */
 	b	hyp_panic
+
+.L__hyp_sp_overflow\@:
+	/*
+	 * Reset SP to the top of the stack, to allow handling the hyp_panic.
+	 * This corrupts the stack but is ok, since we won't be attempting
+	 * any unwinding here.
+	 */
+	ldr_this_cpu	x0, kvm_init_params + NVHE_INIT_STACK_HYP_VA, x1
+	mov	sp, x0
+
+	bl	hyp_panic_bad_stack
+	ASM_BUG()
 .endm
 
 .macro invalid_host_el1_vect
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6410d21d8695..703a5d3f611b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -347,7 +347,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return exit_code;
 }
 
-void __noreturn hyp_panic(void)
+asmlinkage void __noreturn hyp_panic(void)
 {
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
@@ -369,6 +369,11 @@ void __noreturn hyp_panic(void)
 	unreachable();
 }
 
+asmlinkage void __noreturn hyp_panic_bad_stack(void)
+{
+	hyp_panic();
+}
+
 asmlinkage void kvm_unexpected_el2_exception(void)
 {
 	return __kvm_unexpected_el2_exception();
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
