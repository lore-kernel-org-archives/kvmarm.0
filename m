From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH] KVM: arm64: add esr_el2 and far_el2 to sysreg
Date: Tue, 8 Aug 2017 00:08:37 +0800
Message-ID: <1502122117-6276-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

For the firmware-first RAS solution, SEA and SEI is injected
by the user space, user space needs to know the esr_el2 and
far_el2's value, so add them to sysreg. user space uses
the IOCTL KVM_GET_ONE_REG can get their value.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Quanming Wu <wuquanming@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h | 6 ++++--
 arch/arm64/kvm/sys_regs.c         | 6 ++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b6242fb..6063eec 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -103,10 +103,12 @@ enum vcpu_sysreg {
 	TTBR0_EL1,	/* Translation Table Base Register 0 */
 	TTBR1_EL1,	/* Translation Table Base Register 1 */
 	TCR_EL1,	/* Translation Control Register */
-	ESR_EL1,	/* Exception Syndrome Register */
+	ESR_EL1,	/* Exception Syndrome Register for EL1 */
+	ESR_EL2,	/* Exception Syndrome Register for EL2 */
 	AFSR0_EL1,	/* Auxiliary Fault Status Register 0 */
 	AFSR1_EL1,	/* Auxiliary Fault Status Register 1 */
-	FAR_EL1,	/* Fault Address Register */
+	FAR_EL1,	/* Fault Address Register for EL1 */
+	FAR_EL2,	/* Fault Address Register for EL2 */
 	MAIR_EL1,	/* Memory Attribute Indirection Register */
 	VBAR_EL1,	/* Vector Base Address Register */
 	CONTEXTIDR_EL1,	/* Context ID Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0e26f8c..0c286bf 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -987,9 +987,15 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* ESR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0101), CRm(0b0010), Op2(0b000),
 	  access_vm_reg, reset_unknown, ESR_EL1 },
+	/* ESR_EL2 */
+	{ Op0(0b11), Op1(0b100), CRn(0b0101), CRm(0b0010), Op2(0b000),
+	  access_vm_reg, reset_unknown, ESR_EL2 },
 	/* FAR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0110), CRm(0b0000), Op2(0b000),
 	  access_vm_reg, reset_unknown, FAR_EL1 },
+	/* FAR_EL2 */
+	{ Op0(0b11), Op1(0b100), CRn(0b0110), CRm(0b0000), Op2(0b000),
+	  access_vm_reg, reset_unknown, FAR_EL2 },
 	/* PAR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0111), CRm(0b0100), Op2(0b000),
 	  NULL, reset_unknown, PAR_EL1 },
-- 
2.10.1
