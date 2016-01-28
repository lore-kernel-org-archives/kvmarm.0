From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/5] arm64: KVM: Fix wrong use of the CPSR MODE mask for 32bit guests
Date: Thu, 28 Jan 2016 10:30:36 +0000
Message-ID: <1453977038-13516-4-git-send-email-marc.zyngier@arm.com>
References: <1453977038-13516-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1453977038-13516-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Shannon Zhao <shannon.zhao@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Gleb Natapov <gleb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

The values of CPSR MODE mask are different between aarch32 and aarch64.
It should use the right one according to the execution state.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 3066328..779a587 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -127,10 +127,14 @@ static inline unsigned long *vcpu_spsr(const struct kvm_vcpu *vcpu)
 
 static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
 {
-	u32 mode = *vcpu_cpsr(vcpu) & PSR_MODE_MASK;
+	u32 mode;
 
-	if (vcpu_mode_is_32bit(vcpu))
+	if (vcpu_mode_is_32bit(vcpu)) {
+		mode = *vcpu_cpsr(vcpu) & COMPAT_PSR_MODE_MASK;
 		return mode > COMPAT_PSR_MODE_USR;
+	}
+
+	mode = *vcpu_cpsr(vcpu) & PSR_MODE_MASK;
 
 	return mode != PSR_MODE_EL0t;
 }
-- 
2.1.4

