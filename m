From: Alexander Graf <agraf@suse.de>
Subject: [PATCH v2] KVM: arm/arm64: Handle hva aging while destroying the vm
Date: Wed,  5 Jul 2017 08:20:31 +0200
Message-ID: <1499235631-141725-1-git-send-email-agraf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41B5F40A80
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jul 2017 02:19:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jcBCLJ5+tyyV for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jul 2017 02:19:47 -0400 (EDT)
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3DB3D40427
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jul 2017 02:19:47 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The kvm_age_hva callback may be called all the way concurrently while
kvm_mmu_notifier_release() is running.

The release function sets kvm->arch.pgd = NULL which the aging function
however implicitly relies on in stage2_get_pud(). That means they can
race and the aging function may dereference a NULL pgd pointer.

This patch adds a check for that case, so that we leave the aging
function silently.

Cc: stable@vger.kernel.org
Fixes: 293f29363 ("kvm-arm: Unmap shadow pagetables properly")
Signed-off-by: Alexander Graf <agraf@suse.de>

---

v1 -> v2:

  - Fix commit message
  - Add Fixes and stable tags
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
