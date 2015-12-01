From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH] KVM: arm/arm64: Revert to old way of checking for device
 mapping in stage2_flush_ptes().
Date: Tue, 01 Dec 2015 16:03:52 +0300
Message-ID: <1448975032-7156-1-git-send-email-p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 852DD49954
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 08:02:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B7wVUoZlf8Y7 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2015 08:02:35 -0500 (EST)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BA4694993B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 08:02:35 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYO00MYWKAMHU90@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 01 Dec 2015 13:03:58 +0000 (GMT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This function takes stage-II physical addresses (A.K.A. IPA), on input, not
real physical addresses. This causes kvm_is_device_pfn() to return wrong
values, depending on how much guest and host memory maps match. This
results in completely broken KVM on some boards. The problem has been
caught on Samsung proprietary hardware.

Cc: stable@vger.kernel.org
Fixes: e6fab5442345 ("ARM/arm64: KVM: test properly for a PTE's uncachedness")

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 arch/arm/kvm/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 7dace90..51ad98f 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -310,7 +310,8 @@ static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
 
 	pte = pte_offset_kernel(pmd, addr);
 	do {
-		if (!pte_none(*pte) && !kvm_is_device_pfn(__phys_to_pfn(addr)))
+		if (!pte_none(*pte) &&
+		    (pte_val(*pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
 			kvm_flush_dcache_pte(*pte);
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 }
-- 
2.4.4
