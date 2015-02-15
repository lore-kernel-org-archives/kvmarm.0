From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [GIT PULL 1/2] ARM: KVM: Fix size check in __coherent_cache_guest_page
Date: Sun, 15 Feb 2015 21:22:42 +0100
Message-ID: <1424031763-9534-2-git-send-email-christoffer.dall@linaro.org>
References: <1424031763-9534-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1424031763-9534-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Jan Kiszka <jan.kiszka@siemens.com>

The check is supposed to catch page-unaligned sizes, not the inverse.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_mmu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 1bca8f8..90052de 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -186,7 +186,7 @@ static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu, pfn_t pfn,
 
 	bool need_flush = !vcpu_has_cache_enabled(vcpu) || ipa_uncached;
 
-	VM_BUG_ON(size & PAGE_MASK);
+	VM_BUG_ON(size & ~PAGE_MASK);
 
 	if (!need_flush && !icache_is_pipt())
 		goto vipt_cache;
-- 
2.1.2.330.g565301e.dirty

