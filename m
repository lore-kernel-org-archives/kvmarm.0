From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/2] arm64: KVM: Fix AArch32 to AArch64 register mapping
Date: Mon, 16 Nov 2015 10:28:17 +0000
Message-ID: <1447669698-15939-2-git-send-email-marc.zyngier@arm.com>
References: <1447669698-15939-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 283184972F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2015 05:27:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W7DJX1oJor16 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2015 05:27:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56278496EC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2015 05:27:58 -0500 (EST)
In-Reply-To: <1447669698-15939-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: Robin Murphy <robin.murphy@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When running a 32bit guest under a 64bit hypervisor, the ARMv8
architecture defines a mapping of the 32bit registers in the 64bit
space. This includes banked registers that are being demultiplexed
over the 64bit ones.

On exception caused by an operation involving a 32bit register, the
HW exposes the register number in the ESR_EL2 register. It was so
far understood that SW had to compute which register was AArch64
register was used (based on the current AArch32 mode and register
number).

It turns out that I misinterpreted the ARM ARM, and the clue is in
D1.20.1: "For some exceptions, the exception syndrome given in the
ESR_ELx identifies one or more register numbers from the issued
instruction that generated the exception. Where the exception is
taken from an Exception level using AArch32 these register numbers
give the AArch64 view of the register."

Which means that the HW is already giving us the translated version,
and that we shouldn't try to interpret it at all (for example, doing
an MMIO operation from the IRQ mode using the LR register leads to
very unexpected behaviours).

The fix is thus not to perform a call to vcpu_reg32() at all from
vcpu_reg(), and use whatever register number is supplied directly.
The only case we need to find out about the mapping is when we
actively generate a register access, which only occurs when injecting
a fault in a guest.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 8 +++++---
 arch/arm64/kvm/inject_fault.c        | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 17e92f0..3ca894e 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -99,11 +99,13 @@ static inline void vcpu_set_thumb(struct kvm_vcpu *vcpu)
 	*vcpu_cpsr(vcpu) |= COMPAT_PSR_T_BIT;
 }
 
+/*
+ * vcpu_reg should always be passed a register number coming from a
+ * read of ESR_EL2. Otherwise, it may give the wrong result on AArch32
+ * with banked registers.
+ */
 static inline unsigned long *vcpu_reg(const struct kvm_vcpu *vcpu, u8 reg_num)
 {
-	if (vcpu_mode_is_32bit(vcpu))
-		return vcpu_reg32(vcpu, reg_num);
-
 	return (unsigned long *)&vcpu_gp_regs(vcpu)->regs.regs[reg_num];
 }
 
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 85c5715..648112e 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -48,7 +48,7 @@ static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 
 	/* Note: These now point to the banked copies */
 	*vcpu_spsr(vcpu) = new_spsr_value;
-	*vcpu_reg(vcpu, 14) = *vcpu_pc(vcpu) + return_offset;
+	*vcpu_reg32(vcpu, 14) = *vcpu_pc(vcpu) + return_offset;
 
 	/* Branch to exception vector */
 	if (sctlr & (1 << 13))
-- 
2.1.4
