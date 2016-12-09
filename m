From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 6/6] arm64: KVM: pmu: Reset PMSELR_EL0.SEL to a sane value before entering the guest
Date: Fri,  9 Dec 2016 15:53:31 +0000
Message-ID: <1481298811-30798-7-git-send-email-marc.zyngier@arm.com>
References: <1481298811-30798-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1481298811-30798-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, Will Deacon <will.deacon@arm.com>, Vladimir Murzin <vladimir.murzin@arm.com>, Andre Przywara <andre.przywara@arm.com>, Longpeng <longpeng2@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

The ARMv8 architecture allows the cycle counter to be configured
by setting PMSELR_EL0.SEL==0x1f and then accessing PMXEVTYPER_EL0,
hence accessing PMCCFILTR_EL0. But it disallows the use of
PMSELR_EL0.SEL==0x1f to access the cycle counter itself through
PMXEVCNTR_EL0.

Linux itself doesn't violate this rule, but we may end up with
PMSELR_EL0.SEL being set to 0x1f when we enter a guest. If that
guest accesses PMXEVCNTR_EL0, the access may UNDEF at EL1,
despite the guest not having done anything wrong.

In order to avoid this unfortunate course of events (haha!), let's
sanitize PMSELR_EL0 on guest entry. This ensures that the guest
won't explode unexpectedly.

Cc: stable@vger.kernel.org #4.6+
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/switch.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 83037cd..0c848c1 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -85,7 +85,13 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(val, hcr_el2);
 	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
-	/* Make sure we trap PMU access from EL0 to EL2 */
+	/*
+	 * Make sure we trap PMU access from EL0 to EL2. Also sanitize
+	 * PMSELR_EL0 to make sure it never contains the cycle
+	 * counter, which could make a PMXEVCNTR_EL0 access UNDEF at
+	 * EL1 instead of being trapped to EL2.
+	 */
+	write_sysreg(0, pmselr_el0);
 	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 	__activate_traps_arch()();
-- 
2.1.4

