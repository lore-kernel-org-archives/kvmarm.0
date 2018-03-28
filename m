From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 45/85] KVM: arm64: Directly call VHE and non-VHE FPSIMD
 enabled functions
Date: Wed, 28 Mar 2018 13:52:14 +0100
Message-ID: <20180328125254.31380-46-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22D6049FC8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:52:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aAggKukEnJes for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:52:12 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED6FE49DAB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:48:02 -0400 (EDT)
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

There is no longer a need for an alternative to choose the right
function to tell us whether or not FPSIMD was enabled for the VM,
because we can simply can the appropriate functions directly from within
the _vhe and _nvhe run functions.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/switch.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 9d90bda3c2cc..5fbb77bd4e90 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -33,20 +33,11 @@ static bool __hyp_text __fpsimd_enabled_nvhe(void)
 	return !(read_sysreg(cptr_el2) & CPTR_EL2_TFP);
 }
 
-static bool __hyp_text __fpsimd_enabled_vhe(void)
+static bool fpsimd_enabled_vhe(void)
 {
 	return !!(read_sysreg(cpacr_el1) & CPACR_EL1_FPEN);
 }
 
-static hyp_alternate_select(__fpsimd_is_enabled,
-			    __fpsimd_enabled_nvhe, __fpsimd_enabled_vhe,
-			    ARM64_HAS_VIRT_HOST_EXTN);
-
-bool __hyp_text __fpsimd_enabled(void)
-{
-	return __fpsimd_is_enabled()();
-}
-
 /* Save the 32-bit only FPSIMD system register state */
 static void __hyp_text __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
 {
@@ -414,7 +405,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
-	fp_enabled = __fpsimd_enabled();
+	fp_enabled = fpsimd_enabled_vhe();
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
 	__vgic_save_state(vcpu);
@@ -481,7 +472,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	fp_enabled = __fpsimd_enabled();
+	fp_enabled = __fpsimd_enabled_nvhe();
 
 	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
-- 
2.14.2
