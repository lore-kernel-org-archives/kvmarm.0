From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 28/58] KVM: arm/arm64: vgic-v3: Add accessors for the
 ICH_APxRn_EL2 registers
Date: Fri, 30 Jun 2017 09:44:44 +0100
Message-ID: <20170630084514.6779-29-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A27340D55
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t4U09DwtOoDA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:46:44 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFC8F40D16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:44 -0400 (EDT)
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

As we're about to access the Active Priority registers a lot more,
let's define accessors that take the register number as a parameter.

Tested-by: Alexander Graf <agraf@suse.de>
Acked-by: David Daney <david.daney@cavium.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 116 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 100 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 87940364570b..3dd8f0c4419e 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -118,6 +118,90 @@ static void __hyp_text __gic_v3_set_lr(u64 val, int lr)
 	}
 }
 
+static void __hyp_text __vgic_v3_write_ap0rn(u32 val, int n)
+{
+	switch (n) {
+	case 0:
+		write_gicreg(val, ICH_AP0R0_EL2);
+		break;
+	case 1:
+		write_gicreg(val, ICH_AP0R1_EL2);
+		break;
+	case 2:
+		write_gicreg(val, ICH_AP0R2_EL2);
+		break;
+	case 3:
+		write_gicreg(val, ICH_AP0R3_EL2);
+		break;
+	}
+}
+
+static void __hyp_text __vgic_v3_write_ap1rn(u32 val, int n)
+{
+	switch (n) {
+	case 0:
+		write_gicreg(val, ICH_AP1R0_EL2);
+		break;
+	case 1:
+		write_gicreg(val, ICH_AP1R1_EL2);
+		break;
+	case 2:
+		write_gicreg(val, ICH_AP1R2_EL2);
+		break;
+	case 3:
+		write_gicreg(val, ICH_AP1R3_EL2);
+		break;
+	}
+}
+
+static u32 __hyp_text __vgic_v3_read_ap0rn(int n)
+{
+	u32 val;
+
+	switch (n) {
+	case 0:
+		val = read_gicreg(ICH_AP0R0_EL2);
+		break;
+	case 1:
+		val = read_gicreg(ICH_AP0R1_EL2);
+		break;
+	case 2:
+		val = read_gicreg(ICH_AP0R2_EL2);
+		break;
+	case 3:
+		val = read_gicreg(ICH_AP0R3_EL2);
+		break;
+	default:
+		unreachable();
+	}
+
+	return val;
+}
+
+static u32 __hyp_text __vgic_v3_read_ap1rn(int n)
+{
+	u32 val;
+
+	switch (n) {
+	case 0:
+		val = read_gicreg(ICH_AP1R0_EL2);
+		break;
+	case 1:
+		val = read_gicreg(ICH_AP1R1_EL2);
+		break;
+	case 2:
+		val = read_gicreg(ICH_AP1R2_EL2);
+		break;
+	case 3:
+		val = read_gicreg(ICH_AP1R3_EL2);
+		break;
+	default:
+		unreachable();
+	}
+
+	return val;
+}
+
 void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
@@ -154,22 +238,22 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 
 		switch (nr_pre_bits) {
 		case 7:
-			cpu_if->vgic_ap0r[3] = read_gicreg(ICH_AP0R3_EL2);
-			cpu_if->vgic_ap0r[2] = read_gicreg(ICH_AP0R2_EL2);
+			cpu_if->vgic_ap0r[3] = __vgic_v3_read_ap0rn(3);
+			cpu_if->vgic_ap0r[2] = __vgic_v3_read_ap0rn(2);
 		case 6:
-			cpu_if->vgic_ap0r[1] = read_gicreg(ICH_AP0R1_EL2);
+			cpu_if->vgic_ap0r[1] = __vgic_v3_read_ap0rn(1);
 		default:
-			cpu_if->vgic_ap0r[0] = read_gicreg(ICH_AP0R0_EL2);
+			cpu_if->vgic_ap0r[0] = __vgic_v3_read_ap0rn(0);
 		}
 
 		switch (nr_pre_bits) {
 		case 7:
-			cpu_if->vgic_ap1r[3] = read_gicreg(ICH_AP1R3_EL2);
-			cpu_if->vgic_ap1r[2] = read_gicreg(ICH_AP1R2_EL2);
+			cpu_if->vgic_ap1r[3] = __vgic_v3_read_ap1rn(3);
+			cpu_if->vgic_ap1r[2] = __vgic_v3_read_ap1rn(2);
 		case 6:
-			cpu_if->vgic_ap1r[1] = read_gicreg(ICH_AP1R1_EL2);
+			cpu_if->vgic_ap1r[1] = __vgic_v3_read_ap1rn(1);
 		default:
-			cpu_if->vgic_ap1r[0] = read_gicreg(ICH_AP1R0_EL2);
+			cpu_if->vgic_ap1r[0] = __vgic_v3_read_ap1rn(0);
 		}
 	} else {
 		cpu_if->vgic_elrsr = 0xffff;
@@ -224,22 +308,22 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 
 		switch (nr_pre_bits) {
 		case 7:
-			write_gicreg(cpu_if->vgic_ap0r[3], ICH_AP0R3_EL2);
-			write_gicreg(cpu_if->vgic_ap0r[2], ICH_AP0R2_EL2);
+			__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[3], 3);
+			__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[2], 2);
 		case 6:
-			write_gicreg(cpu_if->vgic_ap0r[1], ICH_AP0R1_EL2);
+			__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[1], 1);
 		default:
-			write_gicreg(cpu_if->vgic_ap0r[0], ICH_AP0R0_EL2);
+			__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[0], 0);
 		}
 
 		switch (nr_pre_bits) {
 		case 7:
-			write_gicreg(cpu_if->vgic_ap1r[3], ICH_AP1R3_EL2);
-			write_gicreg(cpu_if->vgic_ap1r[2], ICH_AP1R2_EL2);
+			__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[3], 3);
+			__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[2], 2);
 		case 6:
-			write_gicreg(cpu_if->vgic_ap1r[1], ICH_AP1R1_EL2);
+			__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[1], 1);
 		default:
-			write_gicreg(cpu_if->vgic_ap1r[0], ICH_AP1R0_EL2);
+			__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[0], 0);
 		}
 
 		for (i = 0; i < used_lrs; i++)
-- 
2.11.0
