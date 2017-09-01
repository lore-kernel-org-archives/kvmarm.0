From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 2/2][stable] kvm: arm/arm64: Force reading uncached stage2 PGD
Date: Fri,  1 Sep 2017 10:31:10 +0100
Message-ID: <1504258270-11076-2-git-send-email-suzuki.poulose@arm.com>
References: <1504258270-11076-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A3F649C30
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Sep 2017 05:29:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mmU501xJ90LC for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Sep 2017 05:29:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4482A49C35
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Sep 2017 05:29:05 -0400 (EDT)
In-Reply-To: <1504258270-11076-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: stable@vger.kernel.org
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

commit 2952a6070e07ebdd5896f1f5b861acad677caded upstream.

Make sure we don't use a cached value of the KVM stage2 PGD while
resetting the PGD.

Cc: stable@vger.kernel.org # v4.4 and earlier
Cc: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 9b8a0ba..e8835d4 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -833,7 +833,7 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
 	spin_lock(&kvm->mmu_lock);
 	if (kvm->arch.pgd) {
 		unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
-		pgd = kvm->arch.pgd;
+		pgd = READ_ONCE(kvm->arch.pgd);
 		hwpgd = kvm_get_hwpgd(kvm);
 		kvm->arch.pgd = NULL;
 	}
-- 
2.7.5
