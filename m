From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v2] KVM: arm64: pass vcpu esr_el2 and far_el2 sysre to user space
Date: Tue, 8 Aug 2017 03:17:34 +0800
Message-ID: <1502133454-5905-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

For the firmware-first RAS solution, SEA and SEI is injected
by the user space, user space needs to know the vcpu's esr_el2 and
far_el2 value, so add them to sysreg. user space uses
the IOCTL KVM_GET_ONE_REG can get their value.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h | 6 ++++--
 arch/arm64/include/asm/sysreg.h   | 2 ++
 arch/arm64/kvm/hyp/switch.c       | 2 ++
 arch/arm64/kvm/sys_regs.c         | 2 ++
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d68630007b14..075ff9fba0af 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -104,10 +104,12 @@ enum vcpu_sysreg {
 	TTBR0_EL1,	/* Translation Table Base Register 0 */
 	TTBR1_EL1,	/* Translation Table Base Register 1 */
 	TCR_EL1,	/* Translation Control Register */
-	ESR_EL1,	/* Exception Syndrome Register */
+	ESR_EL1,	/* Exception Syndrome Register for EL1 */
+	ESR_EL2,        /* Exception Syndrome Register for EL2 */
 	AFSR0_EL1,	/* Auxiliary Fault Status Register 0 */
 	AFSR1_EL1,	/* Auxiliary Fault Status Register 1 */
-	FAR_EL1,	/* Fault Address Register */
+	FAR_EL1,	/* Fault Address Register for EL1 */
+	FAR_EL2,        /* Fault Address Register for EL2 */
 	MAIR_EL1,	/* Memory Attribute Indirection Register */
 	VBAR_EL1,	/* Vector Base Address Register */
 	CONTEXTIDR_EL1,	/* Context ID Register */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 248339e4aaf5..b019141a8c29 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -252,7 +252,9 @@
 
 #define SYS_DACR32_EL2			sys_reg(3, 4, 3, 0, 0)
 #define SYS_IFSR32_EL2			sys_reg(3, 4, 5, 0, 1)
+#define SYS_ESR_EL2			sys_reg(3, 4, 5, 2, 0)
 #define SYS_FPEXC32_EL2			sys_reg(3, 4, 5, 3, 0)
+#define SYS_FAR_EL2			sys_reg(3, 4, 6, 0, 0)
 
 #define __SYS__AP0Rx_EL2(x)		sys_reg(3, 4, 12, 8, x)
 #define SYS_ICH_AP0R0_EL2		__SYS__AP0Rx_EL2(0)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index c6f17c7675ad..6ec9ecd68d20 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -229,6 +229,7 @@ static bool __hyp_text __translate_far_to_hpfar(u64 far, u64 *hpfar)
 static void __hyp_text __populate_fault_info_esr(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.fault.esr_el2 = read_sysreg_el2(esr);
+	vcpu_sys_reg(vcpu,ESR_EL2) = read_sysreg_el2(esr);
 }
 
 static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
@@ -267,6 +268,7 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.fault.far_el2 = far;
 	vcpu->arch.fault.hpfar_el2 = hpfar;
+	vcpu_sys_reg(vcpu,FAR_EL2) = far;
 	return true;
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2e070d3baf9f..c730d593efbb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1079,7 +1079,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
 	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
+	{ SYS_DESC(SYS_ESR_EL2), access_vm_reg, reset_unknown, ESR_EL2 },
 	{ SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x70 },
+	{ SYS_DESC(SYS_FAR_EL2), access_vm_reg, reset_unknown, FAR_EL2 },
 };
 
 static bool trap_dbgidr(struct kvm_vcpu *vcpu,
-- 
2.13.4
