From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 03/36] KVM: arm64: Move HCR_INT_OVERRIDE to default HCR_EL2
 guest flag
Date: Thu,  7 Dec 2017 18:05:57 +0100
Message-ID: <20171207170630.592-4-christoffer.dall@linaro.org>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F6E449D7D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:03:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WgZ89Wb9CGOC for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Dec 2017 12:03:28 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E834749D70
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:03:27 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id 64so14095985wme.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Dec 2017 09:06:44 -0800 (PST)
In-Reply-To: <20171207170630.592-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shih-Wei Li <shihwei@cs.columbia.edu>

We always set the IMO and FMO bits in the HCR_EL2 when running the
guest, regardless if we use the vgic or not.  By moving these flags to
HCR_GUEST_FLAGS we can avoid one of the extra save/restore operations of
HCR_EL2 in the world switch code, and we can also soon get rid of the
other one.

This is safe, because even though the IMO and FMO bits control both
taking the interrupts to EL2 and remapping ICC_*_EL1 to ICV_*_EL1
executed at EL1, as long as we ensure that these bits are clear when
running the EL1 host, as defined in the HCR_HOST_[VHE_]FLAGS, we're OK.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_arm.h | 4 ++--
 arch/arm64/kvm/hyp/switch.c      | 3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 715d395ef45b..656deeb17bf2 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -79,9 +79,9 @@
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
index 71700ecee308..f6189d08753e 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -167,8 +167,6 @@ static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
 		__vgic_v3_save_state(vcpu);
 	else
 		__vgic_v2_save_state(vcpu);
-
-	write_sysreg(read_sysreg(hcr_el2) & ~HCR_INT_OVERRIDE, hcr_el2);
 }
 
 static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
@@ -176,7 +174,6 @@ static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
 	u64 val;
 
 	val = read_sysreg(hcr_el2);
-	val |= 	HCR_INT_OVERRIDE;
 	val |= vcpu->arch.irq_lines;
 	write_sysreg(val, hcr_el2);
 
-- 
2.14.2
