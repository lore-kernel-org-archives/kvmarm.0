From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 08/29] kvm-arm: arm: Introduce hyp page table empty checks
Date: Wed, 11 May 2016 15:30:01 +0200
Message-ID: <1462973422-10021-9-git-send-email-christoffer.dall@linaro.org>
References: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B015849B5A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:29:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NYlI1NhU807O for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 09:29:04 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB46E49B47
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:29:00 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id a17so83057220wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 06:31:58 -0700 (PDT)
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Introduce hyp_pxx_table_empty helpers for checking whether
a given table entry is empty. This will be used explicitly
once we switch to explicit routines for hyp page table walk.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_mmu.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 7d207b4..5522cdd 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -160,7 +160,11 @@ static inline bool kvm_page_empty(void *ptr)
 
 #define kvm_pte_table_empty(kvm, ptep) kvm_page_empty(ptep)
 #define kvm_pmd_table_empty(kvm, pmdp) kvm_page_empty(pmdp)
-#define kvm_pud_table_empty(kvm, pudp) (0)
+#define kvm_pud_table_empty(kvm, pudp) false
+
+#define hyp_pte_table_empty(ptep) kvm_page_empty(ptep)
+#define hyp_pmd_table_empty(pmdp) kvm_page_empty(pmdp)
+#define hyp_pud_table_empty(pudp) false
 
 static inline void *kvm_get_hwpgd(struct kvm *kvm)
 {
-- 
2.1.2.330.g565301e.dirty
