From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v3 1/2] kvm: arm/arm64: Force reading uncached stage2 PGD
Date: Tue, 16 May 2017 10:34:54 +0100
Message-ID: <1494927295-29369-2-git-send-email-suzuki.poulose@arm.com>
References: <1494927295-29369-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAC1640187
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 05:31:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hw-A6uGsn4BW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 May 2017 05:31:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99E41400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 05:31:45 -0400 (EDT)
In-Reply-To: <1494927295-29369-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, marc.zyngier@arm.com, andreyknvl@google.com, linux-kernel@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Make sure we don't use a cached value of the KVM stage2 PGD while
resetting the PGD.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 virt/kvm/arm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 909a1a7..704e35f 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -837,7 +837,7 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
 	spin_lock(&kvm->mmu_lock);
 	if (kvm->arch.pgd) {
 		unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
-		pgd = kvm->arch.pgd;
+		pgd = READ_ONCE(kvm->arch.pgd);
 		kvm->arch.pgd = NULL;
 	}
 	spin_unlock(&kvm->mmu_lock);
-- 
2.7.4
