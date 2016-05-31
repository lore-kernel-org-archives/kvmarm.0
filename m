From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 2/3] arm64/kvm: use ESR_ELx_EC to extract EC
Date: Tue, 31 May 2016 12:33:02 +0100
Message-ID: <1464694383-31700-3-git-send-email-mark.rutland@arm.com>
References: <1464694383-31700-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D2D649B1A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2016 07:29:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u-pyNxWdcrit for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 May 2016 07:29:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28D664113E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2016 07:29:37 -0400 (EDT)
In-Reply-To: <1464694383-31700-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, shijie.huang@arm.com, dave.martin@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Now that we have a helper to extract the EC from an ESR_ELx value, make
use of this in the arm64 KVM code for simplicity and consistency. There
should be no functional changes as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Dave P Martin <dave.martin@arm.com>
Cc: Huang Shijie <shijie.huang@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/include/asm/kvm_emulate.h | 2 +-
 arch/arm64/kvm/handle_exit.c         | 4 ++--
 arch/arm64/kvm/hyp/switch.c          | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 40bc168..4cdeae3 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -210,7 +210,7 @@ static inline bool kvm_vcpu_trap_il_is32bit(const struct kvm_vcpu *vcpu)
 
 static inline u8 kvm_vcpu_trap_get_class(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_get_hsr(vcpu) >> ESR_ELx_EC_SHIFT;
+	return ESR_ELx_EC(kvm_vcpu_get_hsr(vcpu));
 }
 
 static inline bool kvm_vcpu_trap_is_iabt(const struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 3246c4a..fa96fe2 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -106,7 +106,7 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	run->exit_reason = KVM_EXIT_DEBUG;
 	run->debug.arch.hsr = hsr;
 
-	switch (hsr >> ESR_ELx_EC_SHIFT) {
+	switch (ESR_ELx_EC(hsr)) {
 	case ESR_ELx_EC_WATCHPT_LOW:
 		run->debug.arch.far = vcpu->arch.fault.far_el2;
 		/* fall through */
@@ -149,7 +149,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
 {
 	u32 hsr = kvm_vcpu_get_hsr(vcpu);
-	u8 hsr_ec = hsr >> ESR_ELx_EC_SHIFT;
+	u8 hsr_ec = ESR_ELx_EC(hsr);
 
 	if (hsr_ec >= ARRAY_SIZE(arm_exit_handlers) ||
 	    !arm_exit_handlers[hsr_ec]) {
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 437cfad..4373997 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -198,7 +198,7 @@ static bool __hyp_text __translate_far_to_hpfar(u64 far, u64 *hpfar)
 static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
 {
 	u64 esr = read_sysreg_el2(esr);
-	u8 ec = esr >> ESR_ELx_EC_SHIFT;
+	u8 ec = ESR_ELx_EC(esr);
 	u64 hpfar, far;
 
 	vcpu->arch.fault.esr_el2 = esr;
-- 
1.9.1
