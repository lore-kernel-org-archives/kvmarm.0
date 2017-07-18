From: James Morse <james.morse@arm.com>
Subject: [PATCH] KVM: arm/arm64: Fix guest external abort matching
Date: Tue, 18 Jul 2017 13:37:41 +0100
Message-ID: <20170718123741.11537-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B375940D14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 08:38:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3fonAr-w2p1A for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 08:38:11 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AD4340C5A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 08:38:10 -0400 (EDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

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

Reported-by: gengdongjiu <gengdj.1984@gmail.com>
Signed-off-by: James Morse <james.morse@arm.com>
CC: gengdongjiu <gengdj.1984@gmail.com>
CC: Tyler Baicar <tbaicar@codeaurora.org>

---
Keep the name kvm_vcpu_dabt_isextabt() instead of is_abort_sea() as
this is the least noisy option.
The function definition needs moving down in kvm_emulate.h to make
use of kvm_vcpu_trap_get_fault_type(). This has to stay in the headers
as arm64 uses the helper from EL2.

 arch/arm/include/asm/kvm_arm.h       |  1 -
 arch/arm/include/asm/kvm_emulate.h   | 24 +++++++++++++++++-----
 arch/arm64/include/asm/esr.h         |  1 -
 arch/arm64/include/asm/kvm_emulate.h | 24 +++++++++++++++++-----
 virt/kvm/arm/mmu.c                   | 40 ++++++++++--------------------------
 5 files changed, 49 insertions(+), 41 deletions(-)

diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
index ebf020b02bc8..c8781450905b 100644
--- a/arch/arm/include/asm/kvm_arm.h
+++ b/arch/arm/include/asm/kvm_arm.h
@@ -227,7 +227,6 @@
 
 #define HSR_DABT_S1PTW		(_AC(1, UL) << 7)
 #define HSR_DABT_CM		(_AC(1, UL) << 8)
-#define HSR_DABT_EA		(_AC(1, UL) << 9)
 
 #define kvm_arm_exception_type	\
 	{0, "RESET" }, 		\
diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 9a8a45aaf19a..98089ffd91bb 100644
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
diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 8cabd57b6348..f569c88ceed4 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -85,7 +85,6 @@
 
 /* Shared ISS field definitions for Data/Instruction aborts */
 #define ESR_ELx_FnV		(UL(1) << 10)
-#define ESR_ELx_EA		(UL(1) << 9)
 #define ESR_ELx_S1PTW		(UL(1) << 7)
 
 /* Shared ISS fault status code(IFSC/DFSC) for Data/Instruction aborts */
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index fe39e6841326..e5df3fce0008 100644
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
index 0e1fc75f3585..6838ddede162 100644
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
2.13.2
