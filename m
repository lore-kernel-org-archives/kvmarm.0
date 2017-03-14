From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 1/3] kvm: arm/arm64: Take mmap_sem in stage2_unmap_vm
Date: Tue, 14 Mar 2017 14:52:32 +0000
Message-ID: <1489503154-20705-2-git-send-email-suzuki.poulose@arm.com>
References: <1489503154-20705-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 546E840BDE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Mar 2017 10:51:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SAEILp8kKFnc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Mar 2017 10:51:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8284D40296
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Mar 2017 10:51:57 -0400 (EDT)
In-Reply-To: <1489503154-20705-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, andreyknvl@google.com
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, ard.biesheuvel@linaro.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, kcc@google.com, syzkaller@googlegroups.com, dvyukov@google.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

We don't hold the mmap_sem while searching for the VMAs when
we try to unmap each memslot for a VM. Fix this properly to
avoid unexpected results.

Fixes: commit 957db105c997 ("arm/arm64: KVM: Introduce stage2_unmap_vm")
Cc: stable@vger.kernel.org # v3.19+
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/kvm/mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 962616f..f2e2e0c 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -803,6 +803,7 @@ void stage2_unmap_vm(struct kvm *kvm)
 	int idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
+	down_read(&current->mm->mmap_sem);
 	spin_lock(&kvm->mmu_lock);
 
 	slots = kvm_memslots(kvm);
@@ -810,6 +811,7 @@ void stage2_unmap_vm(struct kvm *kvm)
 		stage2_unmap_memslot(kvm, memslot);
 
 	spin_unlock(&kvm->mmu_lock);
+	up_read(&current->mm->mmap_sem);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
-- 
2.7.4
