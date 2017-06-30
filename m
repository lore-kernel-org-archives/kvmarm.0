From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 35/58] KVM: arm64: vgic-v3: Add ICV_AP1Rn_EL1 handler
Date: Fri, 30 Jun 2017 09:44:51 +0100
Message-ID: <20170630084514.6779-36-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9552E40D55
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:47:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aSt+ODiQZ6vh for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:47:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CB7F4122C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:47:02 -0400 (EDT)
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

Add a handler for reading/writing the guest's view of the ICV_AP1Rn_EL1
registers. We just map them to the corresponding ICH_AP1Rn_EL2 registers.

Tested-by: Alexander Graf <agraf@suse.de>
Acked-by: David Daney <david.daney@cavium.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/include/asm/sysreg.h |  1 +
 virt/kvm/arm/hyp/vgic-v3-sr.c   | 94 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b4d13d9267ff..563bba108442 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -180,6 +180,7 @@
 
 #define SYS_VBAR_EL1			sys_reg(3, 0, 12, 0, 0)
 
+#define SYS_ICC_AP1Rn_EL1(n)		sys_reg(3, 0, 12, 9, n)
 #define SYS_ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
 #define SYS_ICC_SGI1R_EL1		sys_reg(3, 0, 12, 11, 5)
 #define SYS_ICC_IAR1_EL1		sys_reg(3, 0, 12, 12, 0)
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index e9ff99112c4d..1c85a6df22d9 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -720,6 +720,76 @@ static void __hyp_text __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int
 	__vgic_v3_write_vmcr(vmcr);
 }
 
+static void __hyp_text __vgic_v3_read_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
+{
+	u32 val;
+
+	if (!__vgic_v3_get_group(vcpu))
+		val = __vgic_v3_read_ap0rn(n);
+	else
+		val = __vgic_v3_read_ap1rn(n);
+
+	vcpu_set_reg(vcpu, rt, val);
+}
+
+static void __hyp_text __vgic_v3_write_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
+{
+	u32 val = vcpu_get_reg(vcpu, rt);
+
+	if (!__vgic_v3_get_group(vcpu))
+		__vgic_v3_write_ap0rn(val, n);
+	else
+		__vgic_v3_write_ap1rn(val, n);
+}
+
+static void __hyp_text __vgic_v3_read_apxr0(struct kvm_vcpu *vcpu,
+					    u32 vmcr, int rt)
+{
+	__vgic_v3_read_apxrn(vcpu, rt, 0);
+}
+
+static void __hyp_text __vgic_v3_read_apxr1(struct kvm_vcpu *vcpu,
+					    u32 vmcr, int rt)
+{
+	__vgic_v3_read_apxrn(vcpu, rt, 1);
+}
+
+static void __hyp_text __vgic_v3_read_apxr2(struct kvm_vcpu *vcpu,
+					    u32 vmcr, int rt)
+{
+	__vgic_v3_read_apxrn(vcpu, rt, 2);
+}
+
+static void __hyp_text __vgic_v3_read_apxr3(struct kvm_vcpu *vcpu,
+					    u32 vmcr, int rt)
+{
+	__vgic_v3_read_apxrn(vcpu, rt, 3);
+}
+
+static void __hyp_text __vgic_v3_write_apxr0(struct kvm_vcpu *vcpu,
+					     u32 vmcr, int rt)
+{
+	__vgic_v3_write_apxrn(vcpu, rt, 0);
+}
+
+static void __hyp_text __vgic_v3_write_apxr1(struct kvm_vcpu *vcpu,
+					     u32 vmcr, int rt)
+{
+	__vgic_v3_write_apxrn(vcpu, rt, 1);
+}
+
+static void __hyp_text __vgic_v3_write_apxr2(struct kvm_vcpu *vcpu,
+					     u32 vmcr, int rt)
+{
+	__vgic_v3_write_apxrn(vcpu, rt, 2);
+}
+
+static void __hyp_text __vgic_v3_write_apxr3(struct kvm_vcpu *vcpu,
+					     u32 vmcr, int rt)
+{
+	__vgic_v3_write_apxrn(vcpu, rt, 3);
+}
+
 int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
 	int rt;
@@ -760,6 +830,30 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		else
 			fn = __vgic_v3_write_bpr1;
 		break;
+	case SYS_ICC_AP1Rn_EL1(0):
+		if (is_read)
+			fn = __vgic_v3_read_apxr0;
+		else
+			fn = __vgic_v3_write_apxr0;
+		break;
+	case SYS_ICC_AP1Rn_EL1(1):
+		if (is_read)
+			fn = __vgic_v3_read_apxr1;
+		else
+			fn = __vgic_v3_write_apxr1;
+		break;
+	case SYS_ICC_AP1Rn_EL1(2):
+		if (is_read)
+			fn = __vgic_v3_read_apxr2;
+		else
+			fn = __vgic_v3_write_apxr2;
+		break;
+	case SYS_ICC_AP1Rn_EL1(3):
+		if (is_read)
+			fn = __vgic_v3_read_apxr3;
+		else
+			fn = __vgic_v3_write_apxr3;
+		break;
 	default:
 		return 0;
 	}
-- 
2.11.0
