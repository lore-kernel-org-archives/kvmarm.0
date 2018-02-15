From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 05/40] KVM: arm64: Move HCR_INT_OVERRIDE to default HCR_EL2 guest flag
Date: Thu, 15 Feb 2018 22:02:57 +0100
Message-ID: <20180215210332.8648-6-christoffer.dall@linaro.org>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180215210332.8648-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Dave Martin <Dave.Martin@arm.com>, Julien Grall <julien.grall@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Yury Norov <ynorov@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Shih-Wei Li <shihwei@cs.columbia.edu>

We always set the IMO and FMO bits in the HCR_EL2 when running the
guest, regardless if we use the vgic or not.  By moving these flags to
HCR_GUEST_FLAGS we can avoid one of the extra save/restore operations of
HCR_EL2 in the world switch code, and we can also soon get rid of the
other one.

This is safe, because even though the IMO and FMO bits control both
taking the interrupts to EL2 and remapping ICC_*_EL1 to ICV_*_EL1 when
executed at EL1, as long as we ensure that these bits are clear when
running the EL1 host, we're OK, because we reset the HCR_EL2 to only
have the HCR_RW bit set when returning to EL1 on non-VHE systems.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Notes:
    Changes since v3:
     - Slightly reworded the commit message

 arch/arm64/include/asm/kvm_arm.h | 4 ++--
 arch/arm64/kvm/hyp/switch.c      | 3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index b0c84171e6a3..f055be241f4d 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -81,9 +81,9 @@
  */
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
 			 HCR_TVM | HCR_BSU_IS | HCR_FB | HCR_TAC | \
-			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW)
+			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | \
+			 HCR_FMO | HCR_IMO)
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
-#define HCR_INT_OVERRIDE   (HCR_FMO | HCR_IMO)
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
 /* TCR_EL2 Registers bits */
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 079bb5243f0c..53f3e3486a19 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -174,8 +174,6 @@ static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
 		__vgic_v3_save_state(vcpu);
 	else
 		__vgic_v2_save_state(vcpu);
-
-	write_sysreg(read_sysreg(hcr_el2) & ~HCR_INT_OVERRIDE, hcr_el2);
 }
 
 static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
@@ -183,7 +181,6 @@ static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
 	u64 val;
 
 	val = read_sysreg(hcr_el2);
-	val |= 	HCR_INT_OVERRIDE;
 	val |= vcpu->arch.irq_lines;
 	write_sysreg(val, hcr_el2);
 
-- 
2.14.2
