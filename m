From: Andrey Konovalov <andreyknvl@google.com>
Subject: [RFC PATCH v2 09/15] khwasan, kvm: untag pointers in kern_hyp_va
Date: Fri, 23 Mar 2018 19:05:45 +0100
Message-ID: <0e4b9cc6f99e2aabc8df77773c3d7e9649a6f2b7.1521828274.git.andreyknvl@google.com>
References: <cover.1521828273.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AACDC49FFE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Mar 2018 14:13:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Ydx5yyvMnsD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Mar 2018 14:13:33 -0400 (EDT)
Received: from mail-wr0-f194.google.com (mail-wr0-f194.google.com
 [209.85.128.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 398B44A00F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Mar 2018 13:58:20 -0400 (EDT)
Received: by mail-wr0-f194.google.com with SMTP id l8so13002124wrg.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Mar 2018 11:06:18 -0700 (PDT)
In-Reply-To: <cover.1521828273.git.andreyknvl@google.com>
In-Reply-To: <cover.1521828273.git.andreyknvl@google.com>
References: <cover.1521828273.git.andreyknvl@google.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Christopher Li <sparse@chrisli.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, "GitAuthor : Andrey Konovalov" <andreyknvl@google.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Yury Norov <ynorov@caviumnetworks.com>, Nick Desaulniers <ndesaulniers@google.com>, Suzuki K Poulose <suzuki.po>
Cc: Kees Cook <keescook@google.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Jann Horn <jannh@google.com>, Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>, Lee Smith <Lee.Smith@arm.com>, Kostya Serebryany <kcc@google.com>, Mark Brand <markbrand@google.com>, Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>, Evgeniy Stepanov <eugenis@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

kern_hyp_va that converts kernel VA into a HYP VA relies on the top byte
of kernel pointers being 0xff. Untag pointers passed to it with KHWASAN
enabled.

Also fix create_hyp_mappings() and create_hyp_io_mappings(), to use the
untagged kernel pointers for address computations.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  8 ++++++++
 virt/kvm/arm/mmu.c               | 20 +++++++++++++++-----
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 7faed6e48b46..5149ff83b4c4 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -97,6 +97,9 @@
  * Should be completely invisible on any viable CPU.
  */
 .macro kern_hyp_va	reg
+#ifdef CONFIG_KASAN_TAGS
+	orr	\reg, \reg, #KASAN_PTR_TAG_MASK
+#endif
 alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
 	and     \reg, \reg, #HYP_PAGE_OFFSET_HIGH_MASK
 alternative_else_nop_endif
@@ -115,6 +118,11 @@ alternative_else_nop_endif
 
 static inline unsigned long __kern_hyp_va(unsigned long v)
 {
+#ifdef CONFIG_KASAN_TAGS
+	asm volatile("orr %0, %0, %1"
+		     : "+r" (v)
+		     : "i" (KASAN_PTR_TAG_MASK));
+#endif
 	asm volatile(ALTERNATIVE("and %0, %0, %1",
 				 "nop",
 				 ARM64_HAS_VIRT_HOST_EXTN)
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index b960acdd0c05..3dba9b60e0a0 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -21,6 +21,7 @@
 #include <linux/io.h>
 #include <linux/hugetlb.h>
 #include <linux/sched/signal.h>
+#include <linux/kasan.h>
 #include <trace/events/kvm.h>
 #include <asm/pgalloc.h>
 #include <asm/cacheflush.h>
@@ -683,9 +684,13 @@ static phys_addr_t kvm_kaddr_to_phys(void *kaddr)
 int create_hyp_mappings(void *from, void *to, pgprot_t prot)
 {
 	phys_addr_t phys_addr;
-	unsigned long virt_addr;
-	unsigned long start = kern_hyp_va((unsigned long)from);
-	unsigned long end = kern_hyp_va((unsigned long)to);
+	unsigned long virt_addr, start, end;
+
+	from = khwasan_reset_tag(from);
+	to = khwasan_reset_tag(to);
+
+	start = kern_hyp_va((unsigned long)from);
+	end = kern_hyp_va((unsigned long)to);
 
 	if (is_kernel_in_hyp_mode())
 		return 0;
@@ -719,8 +724,13 @@ int create_hyp_mappings(void *from, void *to, pgprot_t prot)
  */
 int create_hyp_io_mappings(void *from, void *to, phys_addr_t phys_addr)
 {
-	unsigned long start = kern_hyp_va((unsigned long)from);
-	unsigned long end = kern_hyp_va((unsigned long)to);
+	unsigned long start, end;
+
+	from = khwasan_reset_tag(from);
+	to = khwasan_reset_tag(to);
+
+	start = kern_hyp_va((unsigned long)from);
+	end = kern_hyp_va((unsigned long)to);
 
 	if (is_kernel_in_hyp_mode())
 		return 0;
-- 
2.17.0.rc0.231.g781580f067-goog
