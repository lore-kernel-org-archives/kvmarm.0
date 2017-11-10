From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v8 2/7] KVM: arm64: Save ESR_EL2 on guest SError
Date: Sat, 11 Nov 2017 03:54:05 +0800
Message-ID: <1510343650-23659-3-git-send-email-gengdongjiu@huawei.com>
References: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C1C249D6C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Nov 2017 06:48:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v8v4DDJHn3q4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Nov 2017 06:48:07 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F9C049D4F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Nov 2017 06:48:05 -0500 (EST)
In-Reply-To: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, bp@alien8.de, rjw@rjwysocki.net, james.morse@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net, catalin.marinas@arm.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org, gengdongjiu@huawei.com, huangshaoyu@huawei.com, wuquanming@huawei.com, linuxarm@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: James Morse <james.morse@arm.com>

When we exit a guest due to an SError the vcpu fault info isn't updated
with the ESR. Today this is only done for traps.

The v8.2 RAS Extensions define ISS values for SError. Update the vcpu's
fault_info with the ESR on SError so that handle_exit() can determine
if this was a RAS SError and decode its severity.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 arch/arm64/kvm/hyp/switch.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 945e79c..c6f17c7 100644
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
1.9.1
