From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 23/28] arm64: mm: Add additional parameter to uaccess_ttbr0_disable
Date: Wed, 31 Jan 2018 10:35:02 +0100
Message-ID: <20180131093507.22219-24-christoffer.dall@linaro.org>
References: <20180131093507.22219-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180131093507.22219-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Add an extra temporary register parameter to uaccess_ttbr0_disable which
is about to be required for arm64 PAN support.

This patch doesn't introduce any functional change but ensures that the
kernel compiles once the KVM/ARM tree is merged with the arm64 tree by
ensuring a trivially mergable conflict with commit
6b88a32c7af68895134872cdec3b6bfdb532d94e
("arm64: kpti: Fix the interaction between ASID switching and software PAN").

Cc: Will Deacon <will.deacon@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/asm-uaccess.h | 8 ++++----
 arch/arm64/lib/clear_user.S          | 2 +-
 arch/arm64/lib/copy_from_user.S      | 2 +-
 arch/arm64/lib/copy_in_user.S        | 2 +-
 arch/arm64/lib/copy_to_user.S        | 2 +-
 arch/arm64/mm/cache.S                | 4 ++--
 arch/arm64/xen/hypercall.S           | 2 +-
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/asm-uaccess.h b/arch/arm64/include/asm/asm-uaccess.h
index b67563d2024c..03064261ee0b 100644
--- a/arch/arm64/include/asm/asm-uaccess.h
+++ b/arch/arm64/include/asm/asm-uaccess.h
@@ -25,7 +25,7 @@
 	isb
 	.endm
 
-	.macro	uaccess_ttbr0_disable, tmp1
+	.macro	uaccess_ttbr0_disable, tmp1, tmp2
 alternative_if_not ARM64_HAS_PAN
 	__uaccess_ttbr0_disable \tmp1
 alternative_else_nop_endif
@@ -39,7 +39,7 @@ alternative_if_not ARM64_HAS_PAN
 alternative_else_nop_endif
 	.endm
 #else
-	.macro	uaccess_ttbr0_disable, tmp1
+	.macro	uaccess_ttbr0_disable, tmp1, tmp2
 	.endm
 
 	.macro	uaccess_ttbr0_enable, tmp1, tmp2, tmp3
@@ -49,8 +49,8 @@ alternative_else_nop_endif
 /*
  * These macros are no-ops when UAO is present.
  */
-	.macro	uaccess_disable_not_uao, tmp1
-	uaccess_ttbr0_disable \tmp1
+	.macro	uaccess_disable_not_uao, tmp1, tmp2
+	uaccess_ttbr0_disable \tmp1, \tmp2
 alternative_if ARM64_ALT_PAN_NOT_UAO
 	SET_PSTATE_PAN(1)
 alternative_else_nop_endif
diff --git a/arch/arm64/lib/clear_user.S b/arch/arm64/lib/clear_user.S
index e88fb99c1561..8932e5f7a6f3 100644
--- a/arch/arm64/lib/clear_user.S
+++ b/arch/arm64/lib/clear_user.S
@@ -50,7 +50,7 @@ uao_user_alternative 9f, strh, sttrh, wzr, x0, 2
 	b.mi	5f
 uao_user_alternative 9f, strb, sttrb, wzr, x0, 0
 5:	mov	x0, #0
-	uaccess_disable_not_uao x2
+	uaccess_disable_not_uao x2, x3
 	ret
 ENDPROC(__clear_user)
 
diff --git a/arch/arm64/lib/copy_from_user.S b/arch/arm64/lib/copy_from_user.S
index 4b5d826895ff..bc108634992c 100644
--- a/arch/arm64/lib/copy_from_user.S
+++ b/arch/arm64/lib/copy_from_user.S
@@ -67,7 +67,7 @@ ENTRY(__arch_copy_from_user)
 	uaccess_enable_not_uao x3, x4
 	add	end, x0, x2
 #include "copy_template.S"
-	uaccess_disable_not_uao x3
+	uaccess_disable_not_uao x3, x4
 	mov	x0, #0				// Nothing to copy
 	ret
 ENDPROC(__arch_copy_from_user)
diff --git a/arch/arm64/lib/copy_in_user.S b/arch/arm64/lib/copy_in_user.S
index b24a830419ad..e6dd59dd4053 100644
--- a/arch/arm64/lib/copy_in_user.S
+++ b/arch/arm64/lib/copy_in_user.S
@@ -68,7 +68,7 @@ ENTRY(raw_copy_in_user)
 	uaccess_enable_not_uao x3, x4
 	add	end, x0, x2
 #include "copy_template.S"
-	uaccess_disable_not_uao x3
+	uaccess_disable_not_uao x3, x4
 	mov	x0, #0
 	ret
 ENDPROC(raw_copy_in_user)
diff --git a/arch/arm64/lib/copy_to_user.S b/arch/arm64/lib/copy_to_user.S
index 351f0766f7a6..bd20f9f7dd84 100644
--- a/arch/arm64/lib/copy_to_user.S
+++ b/arch/arm64/lib/copy_to_user.S
@@ -66,7 +66,7 @@ ENTRY(__arch_copy_to_user)
 	uaccess_enable_not_uao x3, x4
 	add	end, x0, x2
 #include "copy_template.S"
-	uaccess_disable_not_uao x3
+	uaccess_disable_not_uao x3, x4
 	mov	x0, #0
 	ret
 ENDPROC(__arch_copy_to_user)
diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index 5a52811f47e9..758bde7e2fa6 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -63,7 +63,7 @@ user_alt 9f, "dc cvau, x4",  "dc civac, x4",  ARM64_WORKAROUND_CLEAN_CACHE
 	invalidate_icache_by_line x0, x1, x2, x3, 9f
 	mov	x0, #0
 1:
-	uaccess_ttbr0_disable x1
+	uaccess_ttbr0_disable x1, x2
 	ret
 9:
 	mov	x0, #-EFAULT
@@ -85,7 +85,7 @@ ENTRY(invalidate_icache_range)
 	invalidate_icache_by_line x0, x1, x2, x3, 2f
 	mov	x0, xzr
 1:
-	uaccess_ttbr0_disable x1
+	uaccess_ttbr0_disable x1, x2
 	ret
 2:
 	mov	x0, #-EFAULT
diff --git a/arch/arm64/xen/hypercall.S b/arch/arm64/xen/hypercall.S
index acdbd2c9e899..c5f05c4a4d00 100644
--- a/arch/arm64/xen/hypercall.S
+++ b/arch/arm64/xen/hypercall.S
@@ -107,6 +107,6 @@ ENTRY(privcmd_call)
 	/*
 	 * Disable userspace access from kernel once the hyp call completed.
 	 */
-	uaccess_ttbr0_disable x6
+	uaccess_ttbr0_disable x6, x7
 	ret
 ENDPROC(privcmd_call);
-- 
2.14.2
