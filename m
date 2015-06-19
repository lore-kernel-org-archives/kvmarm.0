From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 01/12] ARM: KVM: Remove pointless void pointer cast
Date: Fri, 19 Jun 2015 13:53:05 +0100
Message-ID: <1434718396-13110-2-git-send-email-marc.zyngier@arm.com>
References: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Firo Yang <firogm@gmail.com>, Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Tiejun Chen <tiejun.chen@intel.com>, Eric Auger <eric.auger@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Firo Yang <firogm@gmail.com>

No need to cast the void pointer returned by kmalloc() in
arch/arm/kvm/mmu.c::kvm_alloc_stage2_pgd().

Signed-off-by: Firo Yang <firogm@gmail.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 1d5accb..ce0bce4 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -691,8 +691,8 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
 		 * work.  This is not used by the hardware and we have no
 		 * alignment requirement for this allocation.
 		 */
-		pgd = (pgd_t *)kmalloc(PTRS_PER_S2_PGD * sizeof(pgd_t),
-				       GFP_KERNEL | __GFP_ZERO);
+		pgd = kmalloc(PTRS_PER_S2_PGD * sizeof(pgd_t),
+				GFP_KERNEL | __GFP_ZERO);
 
 		if (!pgd) {
 			kvm_free_hwpgd(hwpgd);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe kvm" in
