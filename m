From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 03/37] KVM: arm64: Move HCR_INT_OVERRIDE to default HCR_EL2
 guest flag
Date: Thu, 12 Oct 2017 12:41:07 +0200
Message-ID: <20171012104141.26902-4-christoffer.dall@linaro.org>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8CC749D7B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OTZaNDlaVIZ3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 06:41:03 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3527349D65
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:02 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id q124so11978446wmb.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 03:41:46 -0700 (PDT)
In-Reply-To: <20171012104141.26902-1-christoffer.dall@linaro.org>
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

Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_arm.h | 4 ++--
 arch/arm64/kvm/hyp/switch.c      | 3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 61d694c..e67e279 100644
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
index a50ddf3..bcf1a79 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -164,8 +164,6 @@ static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
 		__vgic_v3_save_state(vcpu);
 	else
 		__vgic_v2_save_state(vcpu);
-
-	write_sysreg(read_sysreg(hcr_el2) & ~HCR_INT_OVERRIDE, hcr_el2);
 }
 
 static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
@@ -173,7 +171,6 @@ static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
 	u64 val;
 
 	val = read_sysreg(hcr_el2);
-	val |= 	HCR_INT_OVERRIDE;
 	val |= vcpu->arch.irq_lines;
 	write_sysreg(val, hcr_el2);
 
-- 
2.9.0
