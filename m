From: Andrew Jones <drjones@redhat.com>
Subject: [RFC/RFT PATCH v2 1/3] arm/arm64: pageattr: add set_memory_nc
Date: Wed, 13 May 2015 13:31:52 +0200
Message-ID: <1431516714-25816-2-git-send-email-drjones@redhat.com>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3249512DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2015 07:23:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 17xJQ9VAk-vQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 May 2015 07:23:07 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42965512E3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2015 07:23:06 -0400 (EDT)
In-Reply-To: <1431516714-25816-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, agraf@suse.de
Cc: catalin.marinas@arm.com, lersek@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Provide a method to change normal, cacheable memory to non-cacheable.
KVM will make use of this to keep emulated device memory regions
coherent with the guest.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/include/asm/cacheflush.h   | 1 +
 arch/arm/mm/pageattr.c              | 7 +++++++
 arch/arm64/include/asm/cacheflush.h | 1 +
 arch/arm64/mm/pageattr.c            | 8 ++++++++
 4 files changed, 17 insertions(+)

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index 2d46862e7bef7..682a8b13d6019 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -486,6 +486,7 @@ int set_memory_ro(unsigned long addr, int numpages);
 int set_memory_rw(unsigned long addr, int numpages);
 int set_memory_x(unsigned long addr, int numpages);
 int set_memory_nx(unsigned long addr, int numpages);
+int set_memory_nc(unsigned long addr, int numpages);
 
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
diff --git a/arch/arm/mm/pageattr.c b/arch/arm/mm/pageattr.c
index cf30daff89325..9f9f752cab871 100644
--- a/arch/arm/mm/pageattr.c
+++ b/arch/arm/mm/pageattr.c
@@ -92,3 +92,10 @@ int set_memory_x(unsigned long addr, int numpages)
 					__pgprot(0),
 					__pgprot(L_PTE_XN));
 }
+
+int set_memory_nc(unsigned long addr, int numpages)
+{
+	return change_memory_common(addr, numpages,
+					__pgprot(L_PTE_MT_BUFFERABLE),
+					__pgprot(L_PTE_MT_MASK));
+}
diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
index 67d309cc3b6b8..ef671f38c19ad 100644
--- a/arch/arm64/include/asm/cacheflush.h
+++ b/arch/arm64/include/asm/cacheflush.h
@@ -152,6 +152,7 @@ int set_memory_ro(unsigned long addr, int numpages);
 int set_memory_rw(unsigned long addr, int numpages);
 int set_memory_x(unsigned long addr, int numpages);
 int set_memory_nx(unsigned long addr, int numpages);
+int set_memory_nc(unsigned long addr, int numpages);
 
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index e47ed1c5dce1b..c837adcf26fc6 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -96,3 +96,11 @@ int set_memory_x(unsigned long addr, int numpages)
 					__pgprot(PTE_PXN));
 }
 EXPORT_SYMBOL_GPL(set_memory_x);
+
+int set_memory_nc(unsigned long addr, int numpages)
+{
+	return change_memory_common(addr, numpages,
+					__pgprot(PTE_ATTRINDX(MT_NORMAL_NC)),
+					__pgprot(PTE_ATTRINDX_MASK));
+}
+EXPORT_SYMBOL_GPL(set_memory_nc);
-- 
2.1.0
