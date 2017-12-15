From: James Morse <james.morse@arm.com>
Subject: [PATCH v5 10/13] KVM: arm64: Save ESR_EL2 on guest SError
Date: Fri, 15 Dec 2017 15:50:58 +0000
Message-ID: <20171215155101.23505-11-james.morse@arm.com>
References: <20171215155101.23505-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A86749DBE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 10:50:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uqA424BYnC+k for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Dec 2017 10:50:13 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C49749DAB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 10:50:13 -0500 (EST)
In-Reply-To: <20171215155101.23505-1-james.morse@arm.com>
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When we exit a guest due to an SError the vcpu fault info isn't updated
with the ESR. Today this is only done for traps.

The v8.2 RAS Extensions define ISS values for SError. Update the vcpu's
fault_info with the ESR on SError so that handle_exit() can determine
if this was a RAS SError and decode its severity.

Signed-off-by: James Morse <james.morse@arm.com>
---
Changes since v4:
 * Switched to Marc's exit_code != irq version

(Christoffer gave Reviewed-by for v2, which I missed (sorry))

 arch/arm64/kvm/hyp/switch.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 51e65fc1b0cd..1ae349fe0568 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -238,11 +238,12 @@ static bool __hyp_text __translate_far_to_hpfar(u64 far, u64 *hpfar)
 
 static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
 {
-	u64 esr = read_sysreg_el2(esr);
-	u8 ec = ESR_ELx_EC(esr);
+	u8 ec;
+	u64 esr;
 	u64 hpfar, far;
 
-	vcpu->arch.fault.esr_el2 = esr;
+	esr = vcpu->arch.fault.esr_el2;
+	ec = ESR_ELx_EC(esr);
 
 	if (ec != ESR_ELx_EC_DABT_LOW && ec != ESR_ELx_EC_IABT_LOW)
 		return true;
@@ -335,6 +336,8 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	exit_code = __guest_enter(vcpu, host_ctxt);
 	/* And we're baaack! */
 
+	if (ARM_EXCEPTION_CODE(exit_code) != ARM_EXCEPTION_IRQ)
+		vcpu->arch.fault.esr_el2 = read_sysreg_el2(esr);
 	/*
 	 * We're using the raw exception code in order to only process
 	 * the trap if no SError is pending. We will come back to the
-- 
2.15.0
