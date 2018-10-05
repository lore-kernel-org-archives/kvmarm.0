From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: [PATCH v5 06/17] asm-generic: mm_hooks: allow hooks to be overridden individually
Date: Fri,  5 Oct 2018 09:47:43 +0100
Message-ID: <20181005084754.20950-7-kristina.martsenko@arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005084754.20950-1-kristina.martsenko@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <Amit.Kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, "Suzuki K . Poulose" <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

Currently, an architecture must either implement all of the mm hooks
itself, or use all of those provided by the asm-generic implementation.
When an architecture only needs to override a single hook, it must copy
the stub implementations from the asm-generic version.

To avoid this repetition, allow each hook to be overridden indiviually,
by placing each under an #ifndef block. As architectures providing their
own hooks can't include this file today, this shouldn't adversely affect
any existing hooks.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org
---
 include/asm-generic/mm_hooks.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/asm-generic/mm_hooks.h b/include/asm-generic/mm_hooks.h
index 8ac4e68a12f0..2b3ee15d3702 100644
--- a/include/asm-generic/mm_hooks.h
+++ b/include/asm-generic/mm_hooks.h
@@ -7,31 +7,42 @@
 #ifndef _ASM_GENERIC_MM_HOOKS_H
 #define _ASM_GENERIC_MM_HOOKS_H
 
+#ifndef arch_dup_mmap
 static inline int arch_dup_mmap(struct mm_struct *oldmm,
 				struct mm_struct *mm)
 {
 	return 0;
 }
+#endif
 
+#ifndef arch_exit_mmap
 static inline void arch_exit_mmap(struct mm_struct *mm)
 {
 }
+#endif
 
+#ifndef arch_unmap
 static inline void arch_unmap(struct mm_struct *mm,
 			struct vm_area_struct *vma,
 			unsigned long start, unsigned long end)
 {
 }
+#endif
 
+#ifndef arch_bprm_mm_init
 static inline void arch_bprm_mm_init(struct mm_struct *mm,
 				     struct vm_area_struct *vma)
 {
 }
+#endif
 
+#ifndef arch_vma_access_permitted
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
 	/* by default, allow everything */
 	return true;
 }
+#endif
+
 #endif	/* _ASM_GENERIC_MM_HOOKS_H */
-- 
2.11.0
