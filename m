From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 41/58] KVM: arm64: vgic-v3: Add misc Group-0 handlers
Date: Fri, 30 Jun 2017 09:44:57 +0100
Message-ID: <20170630084514.6779-42-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A089E40D17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:47:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cekojang037h for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:47:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50D0740D7F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:47:17 -0400 (EDT)
In-Reply-To: <20170630084514.6779-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, Stefan Traby <stefan@hello-penguin.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Hu Huajun <huhuajun@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

A number of Group-0 registers can be handled by the same accessors
as that of Group-1, so let's add the required system register encodings
and catch them in the dispatching function.

Tested-by: Alexander Graf <agraf@suse.de>
Acked-by: David Daney <david.daney@cavium.com>
Acked-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/include/asm/sysreg.h | 4 ++++
 virt/kvm/arm/hyp/vgic-v3-sr.c   | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 80b4e0a93574..670bf51d55e3 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -180,7 +180,11 @@
 
 #define SYS_VBAR_EL1			sys_reg(3, 0, 12, 0, 0)
 
+#define SYS_ICC_IAR0_EL1		sys_reg(3, 0, 12, 8, 0)
+#define SYS_ICC_EOIR0_EL1		sys_reg(3, 0, 12, 8, 1)
+#define SYS_ICC_HPPIR0_EL1		sys_reg(3, 0, 12, 8, 2)
 #define SYS_ICC_BPR0_EL1		sys_reg(3, 0, 12, 8, 3)
+#define SYS_ICC_AP0Rn_EL1(n)		sys_reg(3, 0, 12, 8, 4 | n)
 #define SYS_ICC_AP1Rn_EL1(n)		sys_reg(3, 0, 12, 9, n)
 #define SYS_ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
 #define SYS_ICC_SGI1R_EL1		sys_reg(3, 0, 12, 11, 5)
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 45927762bf14..08a5d76c82c7 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -882,9 +882,11 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
 
 	switch (sysreg) {
+	case SYS_ICC_IAR0_EL1:
 	case SYS_ICC_IAR1_EL1:
 		fn = __vgic_v3_read_iar;
 		break;
+	case SYS_ICC_EOIR0_EL1:
 	case SYS_ICC_EOIR1_EL1:
 		fn = __vgic_v3_write_eoir;
 		break;
@@ -900,30 +902,35 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		else
 			fn = __vgic_v3_write_bpr1;
 		break;
+	case SYS_ICC_AP0Rn_EL1(0):
 	case SYS_ICC_AP1Rn_EL1(0):
 		if (is_read)
 			fn = __vgic_v3_read_apxr0;
 		else
 			fn = __vgic_v3_write_apxr0;
 		break;
+	case SYS_ICC_AP0Rn_EL1(1):
 	case SYS_ICC_AP1Rn_EL1(1):
 		if (is_read)
 			fn = __vgic_v3_read_apxr1;
 		else
 			fn = __vgic_v3_write_apxr1;
 		break;
+	case SYS_ICC_AP0Rn_EL1(2):
 	case SYS_ICC_AP1Rn_EL1(2):
 		if (is_read)
 			fn = __vgic_v3_read_apxr2;
 		else
 			fn = __vgic_v3_write_apxr2;
 		break;
+	case SYS_ICC_AP0Rn_EL1(3):
 	case SYS_ICC_AP1Rn_EL1(3):
 		if (is_read)
 			fn = __vgic_v3_read_apxr3;
 		else
 			fn = __vgic_v3_write_apxr3;
 		break;
+	case SYS_ICC_HPPIR0_EL1:
 	case SYS_ICC_HPPIR1_EL1:
 		fn = __vgic_v3_read_hppir;
 		break;
-- 
2.11.0
