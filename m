From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 18/85] KVM: arm64: Move HCR_INT_OVERRIDE to default HCR_EL2
 guest flag
Date: Wed, 28 Mar 2018 13:51:47 +0100
Message-ID: <20180328125254.31380-19-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEDFD4029E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:48:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h4jaSMDXe3j5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:48:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3030940170
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:46:09 -0400 (EDT)
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
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
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
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h | 4 ++--
 arch/arm64/kvm/hyp/switch.c      | 3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1b438c334463..6dd285e979c9 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -83,9 +83,9 @@
  */
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
 			 HCR_TVM | HCR_BSU_IS | HCR_FB | HCR_TAC | \
-			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR)
+			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
+			 HCR_FMO | HCR_IMO)
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
-#define HCR_INT_OVERRIDE   (HCR_FMO | HCR_IMO)
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
 /* TCR_EL2 Registers bits */
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 579d9a263853..4117717548b0 100644
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
