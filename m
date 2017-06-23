From: Alexander Graf <agraf@suse.de>
Subject: [PATCH] KVM: arm/arm64: Handle hva aging while destroying the vm
Date: Fri, 23 Jun 2017 17:21:59 +0200
Message-ID: <1498231319-199734-1-git-send-email-agraf@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

If we want to age an HVA while the VM is getting destroyed, we have a
tiny race window during which we may end up dereferencing an invalid
kvm->arch.pgd value.

   CPU0               CPU1

   kvm_age_hva()
                      kvm_mmu_notifier_release()
                      kvm_arch_flush_shadow_all()
                      kvm_free_stage2_pgd()
                      <grab mmu_lock>
   stage2_get_pmd()
   <wait for mmu_lock>
                      set kvm->arch.pgd = 0
                      <free mmu_lock>
   <grab mmu_lock>
   stage2_get_pud()
   <access kvm->arch.pgd>
   <use incorrect value>

This patch adds a check for that case.

Signed-off-by: Alexander Graf <agraf@suse.de>
---
 virt/kvm/arm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index f2d5b6c..227931f 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -861,6 +861,10 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	pgd_t *pgd;
 	pud_t *pud;
 
+	/* Do we clash with kvm_free_stage2_pgd()? */
+	if (!kvm->arch.pgd)
+		return NULL;
+
 	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
 	if (WARN_ON(stage2_pgd_none(*pgd))) {
 		if (!cache)
-- 
1.8.5.6
