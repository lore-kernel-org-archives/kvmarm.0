From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 02/11] asm-generic: mm_hooks: allow hooks to be overridden
 individually
Date: Wed, 19 Jul 2017 17:01:23 +0100
Message-ID: <1500480092-28480-3-git-send-email-mark.rutland@arm.com>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CFB349C01
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jul 2017 12:01:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9TPX7H7tXala for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Jul 2017 12:01:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAE8541260
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jul 2017 12:01:53 -0400 (EDT)
In-Reply-To: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arch@vger.kernel.org, arnd@arndb.de, jiong.wang@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, yao.qi@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, Dave.Martin@arm.com, kernel-hardening@lists.openwall.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Currently, an architecture must either implement all of the mm hooks
itself, or use all of those provided by the asm-generic implementation.
When an architecture only needs to override a single hook, it must copy
the stub implementations from the asm-generic version.

To avoid this repetition, allow each hook to be overridden indiviually,
by placing each under an #ifndef block. As architectures providing their
own hooks can't include this file today, this shouldn't adversely affect
any existing hooks.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org
---
 include/asm-generic/mm_hooks.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/asm-generic/mm_hooks.h b/include/asm-generic/mm_hooks.h
index 41e5b67..b4bf1b8 100644
--- a/include/asm-generic/mm_hooks.h
+++ b/include/asm-generic/mm_hooks.h
@@ -6,30 +6,41 @@
 #ifndef _ASM_GENERIC_MM_HOOKS_H
 #define _ASM_GENERIC_MM_HOOKS_H
 
+#ifndef arch_dup_mmap
 static inline void arch_dup_mmap(struct mm_struct *oldmm,
 				 struct mm_struct *mm)
 {
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
1.9.1
