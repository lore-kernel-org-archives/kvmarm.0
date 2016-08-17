From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 08/12] KVM: arm/arm64: Change misleading use of is_error_pfn
Date: Wed, 17 Aug 2016 21:38:55 +0200
Message-ID: <20160817193859.15726-9-christoffer.dall@linaro.org>
References: <20160817193859.15726-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160817193859.15726-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

When converting a gfn to a pfn, we call gfn_to_pfn_prot, which returns
various kinds of error values.  It turns out that is_error_pfn() only
returns true when the gfn was found in a memory slot and could somehow
not be used, but it does not return true if the gfn does not belong to
any memory slot.

Change use to is_error_noslot_pfn() which covers both cases.

Note: Since we already check for kvm_is_error_hva(hva) explicitly in the
caller of this function while holding the kvm->srcu lock protecting the
memory slots, this should never be a problem, but nevertheless this
change is warranted as it shows the intention of the code.

Reported-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index bda27b6..29d0b23 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1309,7 +1309,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	smp_rmb();
 
 	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
-	if (is_error_pfn(pfn))
+	if (is_error_noslot_pfn(pfn))
 		return -EFAULT;
 
 	if (kvm_is_device_pfn(pfn)) {
-- 
2.9.0

