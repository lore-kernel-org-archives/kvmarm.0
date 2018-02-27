From: Christoffer Dall <cdall@kernel.org>
Subject: [PATCH v5 32/40] KVM: arm64: Directly call VHE and non-VHE FPSIMD
 enabled functions
Date: Tue, 27 Feb 2018 12:34:21 +0100
Message-ID: <20180227113429.637-33-cdall@kernel.org>
References: <20180227113429.637-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CFED49E7D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 06:31:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EZU1kE4WV7NH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Feb 2018 06:30:41 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6C9449EDB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 06:28:24 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id z9so23019994wmb.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 03:35:18 -0800 (PST)
In-Reply-To: <20180227113429.637-1-cdall@kernel.org>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

There is no longer a need for an alternative to choose the right
function to tell us whether or not FPSIMD was enabled for the VM,
because we can simply can the appropriate functions directly from within
the _vhe and _nvhe run functions.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Notes:
    Changes since v3:
     - New patch since we no longer defer FPSIMD handling to load/put

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
