From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 4/8] KVM: arm/arm64: Fix guest external abort matching
Date: Tue,  5 Sep 2017 16:52:03 +0200
Message-ID: <20170905145207.18447-5-cdall@linaro.org>
References: <20170905145207.18447-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170905145207.18447-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: James Morse <james.morse@arm.com>

The ARM-ARM has two bits in the ESR/HSR relevant to external aborts.
A range of {I,D}FSC values (of which bit 5 is always set) and bit 9 'EA'
which provides:
> an IMPLEMENTATION DEFINED classification of External Aborts.

This bit is in addition to the {I,D}FSC range, and has an implementation
defined meaning. KVM should always ignore this bit when handling external
aborts from a guest.

Remove the ESR_ELx_EA definition and rewrite its helper
kvm_vcpu_dabt_isextabt() to check the {I,D}FSC range. This merges
kvm_vcpu_dabt_isextabt() and the recently added is_abort_sea() helper.

CC: Tyler Baicar <tbaicar@codeaurora.org>
Reported-by: gengdongjiu <gengdj.1984@gmail.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/include/asm/kvm_arm.h       |  1 -
 arch/arm/include/asm/kvm_emulate.h   | 24 +++++++++++++++++-----
 arch/arm64/include/asm/kvm_emulate.h | 24 +++++++++++++++++-----
 virt/kvm/arm/mmu.c                   | 40 ++++++++++--------------------------
 4 files changed, 49 insertions(+), 40 deletions(-)

diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
index ebf020b..c878145 100644
--- a/arch/arm/include/asm/kvm_arm.h
+++ b/arch/arm/include/asm/kvm_arm.h
@@ -227,7 +227,6 @@
 
 #define HSR_DABT_S1PTW		(_AC(1, UL) << 7)
 #define HSR_DABT_CM		(_AC(1, UL) << 8)
-#define HSR_DABT_EA		(_AC(1, UL) << 9)
 
 #define kvm_arm_exception_type	\
 	{0, "RESET" }, 		\
diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 9a8a45a..98089ff 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -149,11 +149,6 @@ static inline int kvm_vcpu_dabt_get_rd(struct kvm_vcpu *vcpu)
 	return (kvm_vcpu_get_hsr(vcpu) & HSR_SRT_MASK) >> HSR_SRT_SHIFT;
 }
 
-static inline bool kvm_vcpu_dabt_isextabt(struct kvm_vcpu *vcpu)
-{
-	return kvm_vcpu_get_hsr(vcpu) & HSR_DABT_EA;
-}
-
 static inline bool kvm_vcpu_dabt_iss1tw(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_get_hsr(vcpu) & HSR_DABT_S1PTW;
@@ -206,6 +201,25 @@ static inline u8 kvm_vcpu_trap_get_fault_type(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_get_hsr(vcpu) & HSR_FSC_TYPE;
 }
 
+static inline bool kvm_vcpu_dabt_isextabt(struct kvm_vcpu *vcpu)
+{
+	switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
+	case FSC_SEA:
+	case FSC_SEA_TTW0:
+	case FSC_SEA_TTW1:
+	case FSC_SEA_TTW2:
+	case FSC_SEA_TTW3:
+	case FSC_SECC:
+	case FSC_SECC_TTW0:
+	case FSC_SECC_TTW1:
+	case FSC_SECC_TTW2:
+	case FSC_SECC_TTW3:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static inline u32 kvm_vcpu_hvc_get_imm(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_get_hsr(vcpu) & HSR_HVC_IMM_MASK;
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index fe39e68..e5df3fc 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -188,11 +188,6 @@ static inline int kvm_vcpu_dabt_get_rd(const struct kvm_vcpu *vcpu)
 	return (kvm_vcpu_get_hsr(vcpu) & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
 }
 
-static inline bool kvm_vcpu_dabt_isextabt(const struct kvm_vcpu *vcpu)
-{
-	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_EA);
-}
-
 static inline bool kvm_vcpu_dabt_iss1tw(const struct kvm_vcpu *vcpu)
 {
 	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_S1PTW);
@@ -240,6 +235,25 @@ static inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vcpu)
 	return kvm_vcpu_get_hsr(vcpu) & ESR_ELx_FSC_TYPE;
 }
 
+static inline bool kvm_vcpu_dabt_isextabt(const struct kvm_vcpu *vcpu)
+{
+	switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
+	case FSC_SEA:
+	case FSC_SEA_TTW0:
+	case FSC_SEA_TTW1:
+	case FSC_SEA_TTW2:
+	case FSC_SEA_TTW3:
+	case FSC_SECC:
+	case FSC_SECC_TTW0:
+	case FSC_SECC_TTW1:
+	case FSC_SECC_TTW2:
+	case FSC_SECC_TTW3:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
 {
 	u32 esr = kvm_vcpu_get_hsr(vcpu);
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 2ea21da..b36945d 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1454,25 +1454,6 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 		kvm_set_pfn_accessed(pfn);
 }
 
-static bool is_abort_sea(unsigned long fault_status)
-{
-	switch (fault_status) {
-	case FSC_SEA:
-	case FSC_SEA_TTW0:
-	case FSC_SEA_TTW1:
-	case FSC_SEA_TTW2:
-	case FSC_SEA_TTW3:
-	case FSC_SECC:
-	case FSC_SECC_TTW0:
-	case FSC_SECC_TTW1:
-	case FSC_SECC_TTW2:
-	case FSC_SECC_TTW3:
-		return true;
-	default:
-		return false;
-	}
-}
-
 /**
  * kvm_handle_guest_abort - handles all 2nd stage aborts
  * @vcpu:	the VCPU pointer
@@ -1498,20 +1479,21 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
 
 	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
+	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
 
-	/*
-	 * The host kernel will handle the synchronous external abort. There
-	 * is no need to pass the error into the guest.
-	 */
-	if (is_abort_sea(fault_status)) {
+	/* Synchronous External Abort? */
+	if (kvm_vcpu_dabt_isextabt(vcpu)) {
+		/*
+		 * For RAS the host kernel may handle this abort.
+		 * There is no need to pass the error into the guest.
+		 */
 		if (!handle_guest_sea(fault_ipa, kvm_vcpu_get_hsr(vcpu)))
 			return 1;
-	}
 
-	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
-	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu))) {
-		kvm_inject_vabt(vcpu);
-		return 1;
+		if (unlikely(!is_iabt)) {
+			kvm_inject_vabt(vcpu);
+			return 1;
+		}
 	}
 
 	trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_hsr(vcpu),
-- 
2.9.0
