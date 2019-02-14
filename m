From: Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] kvm: arm64: Fix comment for KVM_PHYS_SHIFT
Date: Thu, 14 Feb 2019 01:45:46 +0000
Message-ID: <1550108746-14704-1-git-send-email-yuzenghui@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 288434A2D3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Feb 2019 20:46:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U3NkYVmyrWo2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Feb 2019 20:46:38 -0500 (EST)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC40540493
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Feb 2019 20:46:37 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@arm.com, marc.zyngier@arm.com
Cc: Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Since Suzuki K Poulose's work on Dynamic IPA support, KVM_PHYS_SHIFT will
be used only when machine_type's bits[7:0] equal to 0 (by default). Thus
the outdated comment should be fixed.

Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 8af4b1b..a12bf48 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -138,7 +138,8 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
 	})
 
 /*
- * We currently only support a 40bit IPA.
+ * We currently support using a VM-specified IPA size. For backward
+ * compatibility, the default IPA size is fixed to 40bits.
  */
 #define KVM_PHYS_SHIFT	(40)
 
-- 
1.8.3.1
