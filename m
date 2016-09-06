From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 17/19] arm/arm64: KVM: Inject virtual abort when guest exits on external abort
Date: Tue,  6 Sep 2016 14:02:15 +0100
Message-ID: <1473166937-15271-18-git-send-email-marc.zyngier@arm.com>
References: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

If we spot a data abort bearing the ESR_EL2.EA bit set, we know that
this is an external abort, and that should be punished by a the injection
of an abort.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/mmu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index bda27b6..6827b54 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1434,6 +1434,11 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	int ret, idx;
 
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
+	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu))) {
+		kvm_inject_vabt(vcpu);
+		return 1;
+	}
+
 	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
 
 	trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_hsr(vcpu),
-- 
2.1.4

