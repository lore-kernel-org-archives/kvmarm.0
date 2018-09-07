From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PULL RESEND v2 2/4] arm64: KVM: Only force FPEXC32_EL2.EN if
 trapping FPSIMD
Date: Fri,  7 Sep 2018 15:12:54 +0200
Message-ID: <20180907131256.2412-3-christoffer.dall@arm.com>
References: <20180907131256.2412-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF28F4A213
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Sep 2018 09:13:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cX-1CrGX-Zao for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Sep 2018 09:13:05 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F2534A220
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Sep 2018 09:13:05 -0400 (EDT)
In-Reply-To: <20180907131256.2412-1-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, Dave Martin <dave.martin@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

If trapping FPSIMD in the context of an AArch32 guest, it is critical
to set FPEXC32_EL2.EN to 1 so that the trapping is taken to EL2 and
not EL1.

Conversely, it is just as critical *not* to set FPEXC32_EL2.EN to 1
if we're not going to trap FPSIMD, as we then corrupt the existing
VFP state.

Moving the call to __activate_traps_fpsimd32 to the point where we
know for sure that we are going to trap ensures that we don't set that
bit spuriously.

Fixes: e6b673b741ea ("KVM: arm64: Optimise FPSIMD handling to reduce guest/host thrashing")
Cc: stable@vger.kernel.org # v4.18
Cc: Dave Martin <dave.martin@arm.com>
Reported-by: Alexander Graf <agraf@suse.de>
Tested-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm64/kvm/hyp/switch.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index d496ef579859..ca46153d7915 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -98,8 +98,10 @@ static void activate_traps_vhe(struct kvm_vcpu *vcpu)
 	val = read_sysreg(cpacr_el1);
 	val |= CPACR_EL1_TTA;
 	val &= ~CPACR_EL1_ZEN;
-	if (!update_fp_enabled(vcpu))
+	if (!update_fp_enabled(vcpu)) {
 		val &= ~CPACR_EL1_FPEN;
+		__activate_traps_fpsimd32(vcpu);
+	}
 
 	write_sysreg(val, cpacr_el1);
 
@@ -114,8 +116,10 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
 
 	val = CPTR_EL2_DEFAULT;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
-	if (!update_fp_enabled(vcpu))
+	if (!update_fp_enabled(vcpu)) {
 		val |= CPTR_EL2_TFP;
+		__activate_traps_fpsimd32(vcpu);
+	}
 
 	write_sysreg(val, cptr_el2);
 }
@@ -129,7 +133,6 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
 		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
 
-	__activate_traps_fpsimd32(vcpu);
 	if (has_vhe())
 		activate_traps_vhe(vcpu);
 	else
-- 
2.18.0
