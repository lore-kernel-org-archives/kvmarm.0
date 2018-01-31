From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 22/28] arm64: mm: Add additional parameter to uaccess_ttbr0_enable
Date: Wed, 31 Jan 2018 10:35:01 +0100
Message-ID: <20180131093507.22219-23-christoffer.dall@linaro.org>
References: <20180131093507.22219-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180131093507.22219-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Add an extra temporary register parameter to uaccess_ttbr0_enable which
is about to be required for arm64 PAN support.

This patch doesn't introduce any functional change but ensures that the
kernel compiles once the KVM/ARM tree is merged with the arm64 tree by
ensuring a trivially mergable conflict with commit
27a921e75711d924617269e0ba4adb8bae9fd0d1
("arm64: mm: Fix and re-enable ARM64_SW_TTBR0_PAN").

Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/asm-uaccess.h | 4 ++--
 arch/arm64/mm/cache.S                | 4 ++--
 arch/arm64/xen/hypercall.S           | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/asm-uaccess.h b/arch/arm64/include/asm/asm-uaccess.h
index b3da6c886835..b67563d2024c 100644
--- a/arch/arm64/include/asm/asm-uaccess.h
+++ b/arch/arm64/include/asm/asm-uaccess.h
@@ -31,7 +31,7 @@ alternative_if_not ARM64_HAS_PAN
 alternative_else_nop_endif
 	.endm
 
-	.macro	uaccess_ttbr0_enable, tmp1, tmp2
+	.macro	uaccess_ttbr0_enable, tmp1, tmp2, tmp3
 alternative_if_not ARM64_HAS_PAN
 	save_and_disable_irq \tmp2		// avoid preemption
 	__uaccess_ttbr0_enable \tmp1
@@ -42,7 +42,7 @@ alternative_else_nop_endif
 	.macro	uaccess_ttbr0_disable, tmp1
 	.endm
 
-	.macro	uaccess_ttbr0_enable, tmp1, tmp2
+	.macro	uaccess_ttbr0_enable, tmp1, tmp2, tmp3
 	.endm
 #endif
 
diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index bedd23da83f4..5a52811f47e9 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -49,7 +49,7 @@ ENTRY(flush_icache_range)
  *	- end     - virtual end address of region
  */
 ENTRY(__flush_cache_user_range)
-	uaccess_ttbr0_enable x2, x3
+	uaccess_ttbr0_enable x2, x3, x4
 	dcache_line_size x2, x3
 	sub	x3, x2, #1
 	bic	x4, x0, x3
@@ -80,7 +80,7 @@ ENDPROC(__flush_cache_user_range)
  *	- end     - virtual end address of region
  */
 ENTRY(invalidate_icache_range)
-	uaccess_ttbr0_enable x2, x3
+	uaccess_ttbr0_enable x2, x3, x4
 
 	invalidate_icache_by_line x0, x1, x2, x3, 2f
 	mov	x0, xzr
diff --git a/arch/arm64/xen/hypercall.S b/arch/arm64/xen/hypercall.S
index 401ceb71540c..acdbd2c9e899 100644
--- a/arch/arm64/xen/hypercall.S
+++ b/arch/arm64/xen/hypercall.S
@@ -101,7 +101,7 @@ ENTRY(privcmd_call)
 	 * need the explicit uaccess_enable/disable if the TTBR0 PAN emulation
 	 * is enabled (it implies that hardware UAO and PAN disabled).
 	 */
-	uaccess_ttbr0_enable x6, x7
+	uaccess_ttbr0_enable x6, x7, x8
 	hvc XEN_IMM
 
 	/*
-- 
2.14.2
