From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 10/29] kvm-arm: arm64: Introduce hyp page table empty checks
Date: Wed, 11 May 2016 15:30:03 +0200
Message-ID: <1462973422-10021-11-git-send-email-christoffer.dall@linaro.org>
References: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F47649B65
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:29:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CJxi55xJRGHe for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 09:29:09 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60D6249B42
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:29:02 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id a17so83058962wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 06:32:00 -0700 (PDT)
In-Reply-To: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Introduce hyp_pxx_table_empty helpers for checking whether
a given table entry is empty. This will be used explicitly
once we switch to explicit routines for hyp page table walk.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e3f53e3..edf3c62 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -249,6 +249,20 @@ static inline bool kvm_page_empty(void *ptr)
 #endif
 
 
+#define hyp_pte_table_empty(ptep) kvm_page_empty(ptep)
+
+#ifdef __PAGETABLE_PMD_FOLDED
+#define hyp_pmd_table_empty(pmdp) (0)
+#else
+#define hyp_pmd_table_empty(pmdp) kvm_page_empty(pmdp)
+#endif
+
+#ifdef __PAGETABLE_PUD_FOLDED
+#define hyp_pud_table_empty(pudp) (0)
+#else
+#define hyp_pud_table_empty(pudp) kvm_page_empty(pudp)
+#endif
+
 struct kvm;
 
 #define kvm_flush_dcache_to_poc(a,l)	__flush_dcache_area((a), (l))
-- 
2.1.2.330.g565301e.dirty
