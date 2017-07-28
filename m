From: James Morse <james.morse@arm.com>
Subject: [PATCH v2 15/16] KVM: arm64: Save ESR_EL2 on guest SError
Date: Fri, 28 Jul 2017 15:10:18 +0100
Message-ID: <20170728141019.9084-16-james.morse@arm.com>
References: <20170728141019.9084-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D652340D1D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:11:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hYwOQScplgnp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jul 2017 10:11:07 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D89D449C24
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:11:07 -0400 (EDT)
In-Reply-To: <20170728141019.9084-1-james.morse@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Wang Xiongfeng <wangxiongfeng2@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When we exit a guest due to an SError the vcpu fault info isn't updated
with the ESR. Today this is only done for traps.

The v8.2 RAS Extensions define ISS values for SError. Update the vcpu's
fault_info with the ESR on SError so that handle_exit() can determine
if this was a RAS SError and decode its severity.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kvm/hyp/switch.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 945e79c641c4..c6f17c7675ad 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -226,13 +226,20 @@ static bool __hyp_text __translate_far_to_hpfar(u64 far, u64 *hpfar)
 	return true;
 }
 
+static void __hyp_text __populate_fault_info_esr(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.fault.esr_el2 = read_sysreg_el2(esr);
+}
+
 static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
 {
-	u64 esr = read_sysreg_el2(esr);
-	u8 ec = ESR_ELx_EC(esr);
+	u8 ec;
+	u64 esr;
 	u64 hpfar, far;
 
-	vcpu->arch.fault.esr_el2 = esr;
+	__populate_fault_info_esr(vcpu);
+	esr = vcpu->arch.fault.esr_el2;
+	ec = ESR_ELx_EC(esr);
 
 	if (ec != ESR_ELx_EC_DABT_LOW && ec != ESR_ELx_EC_IABT_LOW)
 		return true;
@@ -321,6 +328,8 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	if (exit_code == ARM_EXCEPTION_TRAP && !__populate_fault_info(vcpu))
 		goto again;
+	else if (ARM_EXCEPTION_CODE(exit_code) == ARM_EXCEPTION_EL1_SERROR)
+		__populate_fault_info_esr(vcpu);
 
 	if (static_branch_unlikely(&vgic_v2_cpuif_trap) &&
 	    exit_code == ARM_EXCEPTION_TRAP) {
-- 
2.13.2
