From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 40/85] KVM: arm64: Prepare to handle deferred save/restore of
 ELR_EL1
Date: Wed, 28 Mar 2018 13:52:09 +0100
Message-ID: <20180328125254.31380-41-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54FE44A0FB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:50:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4ZdLhPdLn-zK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:50:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF5F34A044
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:47:41 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

ELR_EL1 is not used by a VHE host kernel and can be deferred, but we
need to rework the accesses to this register to access the latest value
depending on whether or not guest system registers are loaded on the CPU
or only reside in memory.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 18 +++++++++++++++++-
 arch/arm64/kvm/inject_fault.c        |  4 ++--
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f32640132e26..6ed18ce0d638 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -90,11 +90,27 @@ static inline unsigned long *vcpu_pc(const struct kvm_vcpu *vcpu)
 	return (unsigned long *)&vcpu_gp_regs(vcpu)->regs.pc;
 }
 
-static inline unsigned long *vcpu_elr_el1(const struct kvm_vcpu *vcpu)
+static inline unsigned long *__vcpu_elr_el1(const struct kvm_vcpu *vcpu)
 {
 	return (unsigned long *)&vcpu_gp_regs(vcpu)->elr_el1;
 }
 
+static inline unsigned long vcpu_read_elr_el1(const struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.sysregs_loaded_on_cpu)
+		return read_sysreg_el1(elr);
+	else
+		return *__vcpu_elr_el1(vcpu);
+}
+
+static inline void vcpu_write_elr_el1(const struct kvm_vcpu *vcpu, unsigned long v)
+{
+	if (vcpu->arch.sysregs_loaded_on_cpu)
+		write_sysreg_el1(v, elr);
+	else
+		*__vcpu_elr_el1(vcpu) = v;
+}
+
 static inline unsigned long *vcpu_cpsr(const struct kvm_vcpu *vcpu)
 {
 	return (unsigned long *)&vcpu_gp_regs(vcpu)->regs.pstate;
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 7f8d2a4e420f..d8e71659ba7e 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -67,7 +67,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
 	u32 esr = 0;
 
-	*vcpu_elr_el1(vcpu) = *vcpu_pc(vcpu);
+	vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
 	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
 
 	*vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
@@ -102,7 +102,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
 
-	*vcpu_elr_el1(vcpu) = *vcpu_pc(vcpu);
+	vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
 	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
 
 	*vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
-- 
2.14.2
