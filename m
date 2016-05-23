From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 5/7] arm64: KVM: Make ICC_SRE_EL1 access return the configured SRE value
Date: Mon, 23 May 2016 13:37:01 +0100
Message-ID: <1464007023-11736-6-git-send-email-marc.zyngier@arm.com>
References: <1464007023-11736-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464007023-11736-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When we trap ICC_SRE_EL1, we handle it as RAZ/WI. It would be
more correct to actual make it RO, and return the configured
value when read.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7bbe3ff..a57d650 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -134,6 +134,17 @@ static bool access_gic_sgi(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_gic_sre(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return ignore_write(vcpu, p);
+
+	p->regval = vcpu->arch.vgic_cpu.vgic_v3.vgic_sre;
+	return true;
+}
+
 static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -958,7 +969,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_gic_sgi },
 	/* ICC_SRE_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1100), Op2(0b101),
-	  trap_raz_wi },
+	  access_gic_sre },
 
 	/* CONTEXTIDR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b1101), CRm(0b0000), Op2(0b001),
-- 
2.1.4

