Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DBF3644CD
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 08:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772787475; cv=none; b=YeCAf1TLhkvAf0qVkyp2xv8MQJbwxIjEmXtIBkjxzuQDHkuu4hlA8dA0kbl4kcVbMo9xKcd+bqcapCqVd0QCa18SUzkguAnP+dlPTstKE0wPccMhgKUaPpg4PQWtQPBg58FB64uIvTkSbJTObcoL3cqoHiqEVStwPOGR4EhIjnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772787475; c=relaxed/simple;
	bh=83o4Me6So3lEG2vi0PcYD2aOl1HkS7WlUbaRJqiwFSQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=HJ3DyaM0zK/SUwbmD+BxmREAjr5XKVcwsiZdG2UmghstrDLzpILajhesrohdWTdq8nJAo51JgAbjZcVIAcwoEZqEyiYHQU34LaBCUTrvZUeYOSf1mZ5+AANaFPCnG+5GP5JF6NaggCEBEdZucCOIZt8gdo7eTA9e55PPB6bNZtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uNW7PKwm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uNW7PKwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6518CC19425;
	Fri,  6 Mar 2026 08:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772787475;
	bh=83o4Me6So3lEG2vi0PcYD2aOl1HkS7WlUbaRJqiwFSQ=;
	h=From:Date:Subject:To:Cc:From;
	b=uNW7PKwmWVRqMZd6RyvLsNnIT9RzDevJHKWNCSdl33+BrawmO3jMy4BiQYbCkOgot
	 6F23u5QB3NSr8X5VwJz1tgP2QCBMuEq6mJwHwQMYbAMyvMamBQhQe/fAu/rzXzHdJp
	 fLVWmg7L8AxlLlO3tKJ8aPe14nr99OMux3DNxl1PYQrsKkf0WOfxmX0hlXvh3RzwCA
	 +DW6PVT4iXVH3CcPAl3tqwJL7UDryV5UcXQvUKx4aZM0ch5iwLzAyxV5+GssxSYPfX
	 9K4IZyT3BQOzQHZ1Uc1suB7HeHYvF9668BnMQKl5oBEbw0J0Mh9wAoL2pyCx6R7lwP
	 BqgQkXyW4QyMA==
From: Linus Walleij <linusw@kernel.org>
Date: Fri, 06 Mar 2026 09:57:50 +0100
Subject: [PATCH] arm64: clear_page[s] using memset
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-aarch64-clear-pages-c-v1-1-77c1bb0f1c21@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MwQpAQBCA4VfRnE0ti/AqcpjG2J0Smi0peXeb4
 3f4/weSmEqCsXjA5NKkx55RlQVwpD0I6pINtas7512LRMaxa5A3IcOTgiRkbAe3kAw9e+8ht6f
 Jqvf/neb3/QBDeSyuZwAAAA==
X-Change-ID: 20260305-aarch64-clear-pages-c-590dae98c333
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 Linus Walleij <linusw@kernel.org>
X-Mailer: b4 0.14.3

There is no need to try to second-guess the compiler when
clearing memory. Just call memset() like everyone else.

Since memset() already has an architecture-local MOPS
optimization, we do not need to do anything else to preserve
the MOPS optimization.

While at it, implement the shorthand for directly calling
the new prototype clear_pages() for larger page chunks.

No performance regressions can be seen, the fastpath
benchmarks differences are in the noise.

Suggested-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/linux-arm-kernel/20260303-aarch64-clear-pages-v1-1-ad0c3ee9a555@kernel.org/
Signed-off-by: Linus Walleij <linusw@kernel.org>
---
 arch/arm64/include/asm/page.h    | 13 +++++++++-
 arch/arm64/kernel/image-vars.h   |  1 -
 arch/arm64/kvm/hyp/nvhe/Makefile |  2 +-
 arch/arm64/lib/Makefile          |  2 +-
 arch/arm64/lib/clear_page.S      | 53 ----------------------------------------
 5 files changed, 14 insertions(+), 57 deletions(-)

diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index b39cc1127e1f..d6ae2e53bf4a 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -13,6 +13,7 @@
 #ifndef __ASSEMBLER__
 
 #include <linux/personality.h> /* for READ_IMPLIES_EXEC */
+#include <linux/string.h> /* for memset() */
 #include <linux/types.h> /* for gfp_t */
 #include <asm/pgtable-types.h>
 
@@ -20,7 +21,17 @@ struct page;
 struct vm_area_struct;
 
 extern void copy_page(void *to, const void *from);
-extern void clear_page(void *to);
+
+static inline void clear_pages(void *addr, unsigned int npages)
+{
+	memset(addr, 0, npages * PAGE_SIZE);
+}
+#define clear_pages clear_pages
+
+static inline void clear_page(void *addr)
+{
+	clear_pages(addr, 1);
+}
 
 void copy_user_highpage(struct page *to, struct page *from,
 			unsigned long vaddr, struct vm_area_struct *vma);
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index d7b0d12b1015..7890454d595d 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -117,7 +117,6 @@ KVM_NVHE_ALIAS(__start___kvm_ex_table);
 KVM_NVHE_ALIAS(__stop___kvm_ex_table);
 
 /* Position-independent library routines */
-KVM_NVHE_ALIAS_HYP(clear_page, __pi_clear_page);
 KVM_NVHE_ALIAS_HYP(copy_page, __pi_copy_page);
 KVM_NVHE_ALIAS_HYP(memcpy, __pi_memcpy);
 KVM_NVHE_ALIAS_HYP(memset, __pi_memset);
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index a244ec25f8c5..4d7f3faf1da2 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -17,7 +17,7 @@ ccflags-y += -fno-stack-protector	\
 hostprogs := gen-hyprel
 HOST_EXTRACFLAGS += -I$(objtree)/include
 
-lib-objs := clear_page.o copy_page.o memcpy.o memset.o
+lib-objs := copy_page.o memcpy.o memset.o
 lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 CFLAGS_switch.nvhe.o += -Wno-override-init
diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
index 633e5223d944..1840e417dd9a 100644
--- a/arch/arm64/lib/Makefile
+++ b/arch/arm64/lib/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 lib-y		:= clear_user.o delay.o copy_from_user.o		\
 		   copy_to_user.o copy_page.o				\
-		   clear_page.o csum.o insn.o memchr.o memcpy.o		\
+		   csum.o insn.o memchr.o memcpy.o			\
 		   memset.o memcmp.o strcmp.o strncmp.o strlen.o	\
 		   strnlen.o strchr.o strrchr.o tishift.o
 
diff --git a/arch/arm64/lib/clear_page.S b/arch/arm64/lib/clear_page.S
deleted file mode 100644
index bd6f7d5eb6eb..000000000000
--- a/arch/arm64/lib/clear_page.S
+++ /dev/null
@@ -1,53 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2012 ARM Ltd.
- */
-
-#include <linux/linkage.h>
-#include <linux/const.h>
-#include <asm/assembler.h>
-#include <asm/page.h>
-
-/*
- * Clear page @dest
- *
- * Parameters:
- *	x0 - dest
- */
-SYM_FUNC_START(__pi_clear_page)
-#ifdef CONFIG_AS_HAS_MOPS
-	.arch_extension mops
-alternative_if_not ARM64_HAS_MOPS
-	b	.Lno_mops
-alternative_else_nop_endif
-
-	mov	x1, #PAGE_SIZE
-	setpn	[x0]!, x1!, xzr
-	setmn	[x0]!, x1!, xzr
-	seten	[x0]!, x1!, xzr
-	ret
-.Lno_mops:
-#endif
-	mrs	x1, dczid_el0
-	tbnz	x1, #4, 2f	/* Branch if DC ZVA is prohibited */
-	and	w1, w1, #0xf
-	mov	x2, #4
-	lsl	x1, x2, x1
-
-1:	dc	zva, x0
-	add	x0, x0, x1
-	tst	x0, #(PAGE_SIZE - 1)
-	b.ne	1b
-	ret
-
-2:	stnp	xzr, xzr, [x0]
-	stnp	xzr, xzr, [x0, #16]
-	stnp	xzr, xzr, [x0, #32]
-	stnp	xzr, xzr, [x0, #48]
-	add	x0, x0, #64
-	tst	x0, #(PAGE_SIZE - 1)
-	b.ne	2b
-	ret
-SYM_FUNC_END(__pi_clear_page)
-SYM_FUNC_ALIAS(clear_page, __pi_clear_page)
-EXPORT_SYMBOL(clear_page)

---
base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
change-id: 20260305-aarch64-clear-pages-c-590dae98c333

Best regards,
-- 
Linus Walleij <linusw@kernel.org>

