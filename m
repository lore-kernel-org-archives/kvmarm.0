From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH v2 9/9] KVM: arm/arm64: avoid race by caching MPIDR
Date: Fri, 31 Mar 2017 18:06:58 +0200
Message-ID: <20170331160658.4331-10-drjones@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170331160658.4331-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: cdall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Cache the MPIDR in the vcpu structure to fix potential races that
can arise between vcpu reset and the extraction of the MPIDR from
the sys-reg array.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/include/asm/kvm_emulate.h   |  2 +-
 arch/arm/include/asm/kvm_host.h      |  3 +++
 arch/arm/kvm/coproc.c                | 20 ++++++++++++--------
 arch/arm64/include/asm/kvm_emulate.h |  2 +-
 arch/arm64/include/asm/kvm_host.h    |  3 +++
 arch/arm64/kvm/sys_regs.c            | 27 ++++++++++++++-------------
 6 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 9a8a45aaf19a..1b922de46785 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -213,7 +213,7 @@ static inline u32 kvm_vcpu_hvc_get_imm(struct kvm_vcpu *vcpu)
 
 static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
 {
-	return vcpu_cp15(vcpu, c0_MPIDR) & MPIDR_HWID_BITMASK;
+	return vcpu->arch.vmpidr & MPIDR_HWID_BITMASK;
 }
 
 static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 0b8a6d6b3cb3..e0f461f0af67 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -151,6 +151,9 @@ struct kvm_vcpu_arch {
 	/* The CPU type we expose to the VM */
 	u32 midr;
 
+	/* vcpu MPIDR */
+	u32 vmpidr;
+
 	/* HYP trapping configuration */
 	u32 hcr;
 
diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 3e5e4194ef86..c4df7c9c8ddb 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -101,14 +101,18 @@ int kvm_handle_cp14_access(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 static void reset_mpidr(struct kvm_vcpu *vcpu, const struct coproc_reg *r)
 {
-	/*
-	 * Compute guest MPIDR. We build a virtual cluster out of the
-	 * vcpu_id, but we read the 'U' bit from the underlying
-	 * hardware directly.
-	 */
-	vcpu_cp15(vcpu, c0_MPIDR) = ((read_cpuid_mpidr() & MPIDR_SMP_BITMASK) |
-				     ((vcpu->vcpu_id >> 2) << MPIDR_LEVEL_BITS) |
-				     (vcpu->vcpu_id & 3));
+	if (!vcpu->arch.vmpidr) {
+		/*
+		 * Compute guest MPIDR. We build a virtual cluster out of the
+		 * vcpu_id, but we read the 'U' bit from the underlying
+		 * hardware directly.
+		 */
+		u32 mpidr = ((read_cpuid_mpidr() & MPIDR_SMP_BITMASK) |
+			     ((vcpu->vcpu_id >> 2) << MPIDR_LEVEL_BITS) |
+			     (vcpu->vcpu_id & 3));
+		vcpu->arch.vmpidr = mpidr;
+	}
+	vcpu_cp15(vcpu, c0_MPIDR) = vcpu->arch.vmpidr;
 }
 
 /* TRM entries A7:4.3.31 A15:4.3.28 - RO WI */
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f5ea0ba70f07..c138bb15b507 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -242,7 +242,7 @@ static inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vcpu)
 
 static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
 {
-	return vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
+	return vcpu->arch.vmpidr_el2 & MPIDR_HWID_BITMASK;
 }
 
 static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7057512b3474..268c10d95a79 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -198,6 +198,9 @@ typedef struct kvm_cpu_context kvm_cpu_context_t;
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 
+	/* vcpu MPIDR */
+	u64 vmpidr_el2;
+
 	/* HYP configuration */
 	u64 hcr_el2;
 	u32 mdcr_el2;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0e26f8c2b56f..517aed6d8016 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -431,19 +431,20 @@ static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 
 static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	u64 mpidr;
-
-	/*
-	 * Map the vcpu_id into the first three affinity level fields of
-	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
-	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
-	 * of the GICv3 to be able to address each CPU directly when
-	 * sending IPIs.
-	 */
-	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
-	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
-	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
-	vcpu_sys_reg(vcpu, MPIDR_EL1) = (1ULL << 31) | mpidr;
+	if (!vcpu->arch.vmpidr_el2) {
+		/*
+		 * Map the vcpu_id into the first three affinity level fields
+		 * of the MPIDR. We limit the number of VCPUs in level 0 due to
+		 * a limitation of 16 CPUs in that level in the ICC_SGIxR
+		 * registers of the GICv3, which are used to address each CPU
+		 * directly when sending IPIs.
+		 */
+		u64 mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
+		mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
+		mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
+		vcpu->arch.vmpidr_el2 = (1ULL << 31) | mpidr;
+	}
+	vcpu_sys_reg(vcpu, MPIDR_EL1) = vcpu->arch.vmpidr_el2;
 }
 
 static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
-- 
2.9.3
