Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C291B3947B3
	for <kvmarm@lists.linux.dev>; Tue,  3 Mar 2026 10:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772532392; cv=none; b=BNpiH30JUHTR+1M9VW9rUWHTyxlnqNVTThvYYWkSP4EZP8/MMMew3jv4dFSAd/jEWKdDM2Mi8M+6IsliTeqCMK7uxse4vBN8pYanmpvIx5t1eX24PFq5BkG2rcwiUafpzieX8cWQTOyMkF4bLUaw/dJEsCY5bOBDpiMbku2gN9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772532392; c=relaxed/simple;
	bh=Av6u6btJD8+jQWYCeDNUAFulpZzXi0zl5Rs5VlxxWtI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Dk4cU8PZaJGC7h06ZcF3rQLt6DyWl18CEk3TEN9L2oYL19mNWFPCHkBQYFvHjNjPGqwU7l4CTAMew8/dzaOaXxNwX7NaklSLnkl3eMlXLCWu1i4xb5JV40Ns/owbPYJhEduJ2EsVEWh5JgV9LMli7xV19DC0ifp2ekZHlZSbDRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ELuZYJaE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ELuZYJaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0904FC2BCAF;
	Tue,  3 Mar 2026 10:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772532392;
	bh=Av6u6btJD8+jQWYCeDNUAFulpZzXi0zl5Rs5VlxxWtI=;
	h=From:Date:Subject:To:Cc:From;
	b=ELuZYJaEIZb+5FqIPc54jh2cALV2s6QygkvaWTSmWxCwMnUmZRX79HX0Ny0yB3e7W
	 QLK33t7bNtFWIZM5zxK2Dkxc9MnoHjAatxkZ6tkRXJlM42NZ0AXtXySA8A8Cc6T28K
	 iXrJMafG/UldZFfuwUcX9l/hVXhkmW2sYvU6kAHM9huBUUqYrvMLFTbf674yh5KfZR
	 cmTYC1C6jMvzxt2W3Uf7/aqQ0SU448huNWZyF8r/FZaaoAg96G16/5p/E3KjpYsnnS
	 SA8blkaqfQRYE7aBa5wPLr6UfFfx/MuzAM3KmiUryW0Csh5/4/DAizB3XFTDbJgeiD
	 idgEnABvuDmPg==
From: Linus Walleij <linusw@kernel.org>
Date: Tue, 03 Mar 2026 11:06:13 +0100
Subject: [PATCH] arm64: Implement clear_pages()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260303-aarch64-clear-pages-v1-1-ad0c3ee9a555@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MzQpAUBBA4VfRrE0xfopXkcUYgymhuSV18+5ul
 t/inAhB3TRAn0VwvS3YeSSUeQay8bEq2pwMVFBbUEnI7LK1Ncqu7HjxqgG5rjohaRqaJkjl5br
 Y81+H8X0/tR9XmGUAAAA=
X-Change-ID: 20260212-aarch64-clear-pages-a439c2c552bb
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Ankur Arora <ankur.a.arora@oracle.com>, 
 David Hildenbrand <david@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 James Clark <james.clark2@arm.com>, Linus Walleij <linusw@kernel.org>
X-Mailer: b4 0.14.3

A recent patch introduced clear_pages() and made it possible to
provide assembly optimizations like for clear_page().

This augments the existing clear_page() optimization in arm64
to accept any number of pages the following way:

- Make clear_page() a static inline special case of clear_pages()

- Implement clear_pages() as a static inline that just calculate
  the number of total bytes in the page set and passes this number
  to the assembly routine clear_pages_asm.

- The old clear_pages assembly is rewritten to clear_pages_asm
  which will take a start address (at an even page) and a number
  of bytes to clear from that address.

This is similar to the optimization provided for x86.

Performance improvements:

The baseline is the current v7.0-rc1 which calls the existing
clear_page() assembly optimization in a loop, see <linux/mm.h>.
Any improvements are about avoiding the outer loop, in most cases
the clearing will be linear and the savings will be small and
only noticeable on really big clearing operations.

We boot the kernel with cmdline like this:
"default_hugepagesz=1G hugepagesz=1G hugepages=32" to make sure
we have ample hugepages. This was then tested with the same
cmdline as the original series:

perf bench mem mmap -p 1GB -f demand -s 32GB -l 5

The first run was discarded as the memory hierarchy is cold on
the first run. Then I ran the above command 5 times and averaged
the throughput, which sees a small but consistent improvement in
the throughput:

On QEMU:

Before this patch:     After this patch:
2.38 GB/s              2.41 GB/s

On hardware Radxa Orion O6 we see this on *some* cores and no
change on others:

Before this patch:     After this patch:
43.3 GB/s              45.3 GB/s

There is a small but consistent improvement in throughput, as
expected.

Tested-by: James Clark <james.clark2@arm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
---
 arch/arm64/include/asm/page.h                  | 13 ++++++++++++-
 arch/arm64/kernel/image-vars.h                 |  2 +-
 arch/arm64/kvm/hyp/nvhe/Makefile               |  2 +-
 arch/arm64/lib/Makefile                        |  2 +-
 arch/arm64/lib/{clear_page.S => clear_pages.S} | 18 +++++++++---------
 5 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index b39cc1127e1f..916a3e7c9a19 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -20,7 +20,18 @@ struct page;
 struct vm_area_struct;
 
 extern void copy_page(void *to, const void *from);
-extern void clear_page(void *to);
+extern void clear_pages_asm(void *addr, unsigned int nbytes);
+
+static inline void clear_pages(void *addr, unsigned int npages)
+{
+	clear_pages_asm(addr, npages * PAGE_SIZE);
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
index d7b0d12b1015..61232f9e1e68 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -117,7 +117,7 @@ KVM_NVHE_ALIAS(__start___kvm_ex_table);
 KVM_NVHE_ALIAS(__stop___kvm_ex_table);
 
 /* Position-independent library routines */
-KVM_NVHE_ALIAS_HYP(clear_page, __pi_clear_page);
+KVM_NVHE_ALIAS_HYP(clear_pages, __pi_clear_pages);
 KVM_NVHE_ALIAS_HYP(copy_page, __pi_copy_page);
 KVM_NVHE_ALIAS_HYP(memcpy, __pi_memcpy);
 KVM_NVHE_ALIAS_HYP(memset, __pi_memset);
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index a244ec25f8c5..f857dac82a88 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -17,7 +17,7 @@ ccflags-y += -fno-stack-protector	\
 hostprogs := gen-hyprel
 HOST_EXTRACFLAGS += -I$(objtree)/include
 
-lib-objs := clear_page.o copy_page.o memcpy.o memset.o
+lib-objs := clear_pages.o copy_page.o memcpy.o memset.o
 lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 CFLAGS_switch.nvhe.o += -Wno-override-init
diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
index 633e5223d944..86995e2e0807 100644
--- a/arch/arm64/lib/Makefile
+++ b/arch/arm64/lib/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 lib-y		:= clear_user.o delay.o copy_from_user.o		\
 		   copy_to_user.o copy_page.o				\
-		   clear_page.o csum.o insn.o memchr.o memcpy.o		\
+		   clear_pages.o csum.o insn.o memchr.o memcpy.o	\
 		   memset.o memcmp.o strcmp.o strncmp.o strlen.o	\
 		   strnlen.o strchr.o strrchr.o tishift.o
 
diff --git a/arch/arm64/lib/clear_page.S b/arch/arm64/lib/clear_pages.S
similarity index 70%
rename from arch/arm64/lib/clear_page.S
rename to arch/arm64/lib/clear_pages.S
index bd6f7d5eb6eb..2d3043c13791 100644
--- a/arch/arm64/lib/clear_page.S
+++ b/arch/arm64/lib/clear_pages.S
@@ -12,22 +12,22 @@
  * Clear page @dest
  *
  * Parameters:
- *	x0 - dest
+ *	x0 - dest - should be start of a page
+ *	x1 - number of bytes to clear, should be a multiple of PAGE_SIZE
  */
-SYM_FUNC_START(__pi_clear_page)
+SYM_FUNC_START(__pi_clear_pages)
 #ifdef CONFIG_AS_HAS_MOPS
 	.arch_extension mops
 alternative_if_not ARM64_HAS_MOPS
 	b	.Lno_mops
 alternative_else_nop_endif
-
-	mov	x1, #PAGE_SIZE
 	setpn	[x0]!, x1!, xzr
 	setmn	[x0]!, x1!, xzr
 	seten	[x0]!, x1!, xzr
 	ret
 .Lno_mops:
 #endif
+	add	x4, x0, x1	/* Find the end */
 	mrs	x1, dczid_el0
 	tbnz	x1, #4, 2f	/* Branch if DC ZVA is prohibited */
 	and	w1, w1, #0xf
@@ -36,7 +36,7 @@ alternative_else_nop_endif
 
 1:	dc	zva, x0
 	add	x0, x0, x1
-	tst	x0, #(PAGE_SIZE - 1)
+	cmp	x0, x4
 	b.ne	1b
 	ret
 
@@ -45,9 +45,9 @@ alternative_else_nop_endif
 	stnp	xzr, xzr, [x0, #32]
 	stnp	xzr, xzr, [x0, #48]
 	add	x0, x0, #64
-	tst	x0, #(PAGE_SIZE - 1)
+	cmp	x0, x4
 	b.ne	2b
 	ret
-SYM_FUNC_END(__pi_clear_page)
-SYM_FUNC_ALIAS(clear_page, __pi_clear_page)
-EXPORT_SYMBOL(clear_page)
+SYM_FUNC_END(__pi_clear_pages)
+SYM_FUNC_ALIAS(clear_pages_asm, __pi_clear_pages)
+EXPORT_SYMBOL(clear_pages_asm)

---
base-commit: dbe60c40b86ec4a1168552398b3b64c14c38b2d7
change-id: 20260212-aarch64-clear-pages-a439c2c552bb

Best regards,
-- 
Linus Walleij <linusw@kernel.org>

