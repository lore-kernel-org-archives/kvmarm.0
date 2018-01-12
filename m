From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 28/41] KVM: arm64: Prepare to handle deferred save/restore
 of ELR_EL1
Date: Fri, 12 Jan 2018 13:07:34 +0100
Message-ID: <20180112120747.27999-29-christoffer.dall@linaro.org>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF9DE49DD8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vZ1aJRtTRQlU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jan 2018 07:03:46 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7DD2249E04
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:44 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id v123so2213096wmd.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 04:08:35 -0800 (PST)
In-Reply-To: <20180112120747.27999-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

ELR_EL1 is not used by a VHE host kernel and can be deferred, but we
need to rework the accesses to this register to access the latest value
depending on whether or not guest system registers are loaded on the CPU
or only reside in memory.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 18 +++++++++++++++++-
 arch/arm64/kvm/inject_fault.c        |  4 ++--
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f0bc7c096fdc..c9ca2dc579c7 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -78,11 +78,27 @@ static inline unsigned long *vcpu_pc(const struct kvm_vcpu *vcpu)
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
index c638593d305d..8425e20f1cc9 100644
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
