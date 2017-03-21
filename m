From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH 2/5] KVM: arm64: vgic: Factor out access_gic_ctlr into
 separate r/w functions
Date: Tue, 21 Mar 2017 12:05:27 +0100
Message-ID: <20170321110530.15857-3-cdall@linaro.org>
References: <20170321110530.15857-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DD1040C5D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 07:03:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vbMv0zmxph93 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 07:03:50 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 26AFD40C2F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 07:03:50 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id u132so9293740wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 04:05:36 -0700 (PDT)
In-Reply-To: <20170321110530.15857-1-cdall@linaro.org>
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
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Vijaya.Kumar@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

We currently have one large function to deal with accesses to the
virtual ICC_CTLR_EL1 from userspace.  But the read and write paths don't
share much logic, and as we're about to mess with this implementaiton,
factor the two paths out into separate functions.

No functional change.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/kvm/vgic-sys-reg-v3.c | 134 ++++++++++++++++++++++-----------------
 1 file changed, 75 insertions(+), 59 deletions(-)

diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 79f37e3..48848db 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -18,80 +18,96 @@
 #include "vgic.h"
 #include "sys_regs.h"
 
-static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
-			    const struct sys_reg_desc *r)
+static bool write_gic_ctlr(struct kvm_vcpu *vcpu, u32 val)
 {
-	u32 host_pri_bits, host_id_bits, host_seis, host_a3v, seis, a3v;
 	struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
+	u32 host_pri_bits, host_id_bits, host_seis, host_a3v, seis, a3v;
 	struct vgic_vmcr vmcr;
-	u64 val;
 
 	vgic_get_vmcr(vcpu, &vmcr);
-	if (p->is_write) {
-		val = p->regval;
-
-		/*
-		 * Disallow restoring VM state if not supported by this
-		 * hardware.
-		 */
-		host_pri_bits = ((val & ICC_CTLR_EL1_PRI_BITS_MASK) >>
-				 ICC_CTLR_EL1_PRI_BITS_SHIFT) + 1;
-		if (host_pri_bits > vgic_v3_cpu->num_pri_bits)
-			return false;
 
-		vgic_v3_cpu->num_pri_bits = host_pri_bits;
+	/*
+	 * Disallow restoring VM state if not supported by this
+	 * hardware.
+	 */
+	host_pri_bits = ((val & ICC_CTLR_EL1_PRI_BITS_MASK) >>
+			 ICC_CTLR_EL1_PRI_BITS_SHIFT) + 1;
+	if (host_pri_bits > vgic_v3_cpu->num_pri_bits)
+		return false;
 
-		host_id_bits = (val & ICC_CTLR_EL1_ID_BITS_MASK) >>
-				ICC_CTLR_EL1_ID_BITS_SHIFT;
-		if (host_id_bits > vgic_v3_cpu->num_id_bits)
-			return false;
+	vgic_v3_cpu->num_pri_bits = host_pri_bits;
 
-		vgic_v3_cpu->num_id_bits = host_id_bits;
+	host_id_bits = (val & ICC_CTLR_EL1_ID_BITS_MASK) >>
+			ICC_CTLR_EL1_ID_BITS_SHIFT;
+	if (host_id_bits > vgic_v3_cpu->num_id_bits)
+		return false;
 
-		host_seis = ((kvm_vgic_global_state.ich_vtr_el2 &
-			     ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT);
-		seis = (val & ICC_CTLR_EL1_SEIS_MASK) >>
-			ICC_CTLR_EL1_SEIS_SHIFT;
-		if (host_seis != seis)
-			return false;
+	vgic_v3_cpu->num_id_bits = host_id_bits;
 
-		host_a3v = ((kvm_vgic_global_state.ich_vtr_el2 &
-			    ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT);
-		a3v = (val & ICC_CTLR_EL1_A3V_MASK) >> ICC_CTLR_EL1_A3V_SHIFT;
-		if (host_a3v != a3v)
-			return false;
+	host_seis = ((kvm_vgic_global_state.ich_vtr_el2 &
+		     ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT);
+	seis = (val & ICC_CTLR_EL1_SEIS_MASK) >>
+		ICC_CTLR_EL1_SEIS_SHIFT;
+	if (host_seis != seis)
+		return false;
 
-		/*
-		 * Here set VMCR.CTLR in ICC_CTLR_EL1 layout.
-		 * The vgic_set_vmcr() will convert to ICH_VMCR layout.
-		 */
-		vmcr.ctlr = val & ICC_CTLR_EL1_CBPR_MASK;
-		vmcr.ctlr |= val & ICC_CTLR_EL1_EOImode_MASK;
-		vgic_set_vmcr(vcpu, &vmcr);
-	} else {
-		val = 0;
-		val |= (vgic_v3_cpu->num_pri_bits - 1) <<
-			ICC_CTLR_EL1_PRI_BITS_SHIFT;
-		val |= vgic_v3_cpu->num_id_bits << ICC_CTLR_EL1_ID_BITS_SHIFT;
-		val |= ((kvm_vgic_global_state.ich_vtr_el2 &
-			ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT) <<
-			ICC_CTLR_EL1_SEIS_SHIFT;
-		val |= ((kvm_vgic_global_state.ich_vtr_el2 &
-			ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT) <<
-			ICC_CTLR_EL1_A3V_SHIFT;
-		/*
-		 * The VMCR.CTLR value is in ICC_CTLR_EL1 layout.
-		 * Extract it directly using ICC_CTLR_EL1 reg definitions.
-		 */
-		val |= vmcr.ctlr & ICC_CTLR_EL1_CBPR_MASK;
-		val |= vmcr.ctlr & ICC_CTLR_EL1_EOImode_MASK;
-
-		p->regval = val;
-	}
+	host_a3v = ((kvm_vgic_global_state.ich_vtr_el2 &
+		    ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT);
+	a3v = (val & ICC_CTLR_EL1_A3V_MASK) >> ICC_CTLR_EL1_A3V_SHIFT;
+	if (host_a3v != a3v)
+		return false;
 
+	/*
+	 * Here set VMCR.CTLR in ICC_CTLR_EL1 layout.
+	 * The vgic_set_vmcr() will convert to ICH_VMCR layout.
+	 */
+	vmcr.ctlr = val & ICC_CTLR_EL1_CBPR_MASK;
+	vmcr.ctlr |= val & ICC_CTLR_EL1_EOImode_MASK;
+
+	vgic_set_vmcr(vcpu, &vmcr);
 	return true;
 }
 
+static u32 read_gic_ctlr(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
+	u32 val = 0;
+	struct vgic_vmcr vmcr;
+
+	vgic_get_vmcr(vcpu, &vmcr);
+
+	val |= (vgic_v3_cpu->num_pri_bits - 1) <<
+		ICC_CTLR_EL1_PRI_BITS_SHIFT;
+	val |= vgic_v3_cpu->num_id_bits << ICC_CTLR_EL1_ID_BITS_SHIFT;
+	val |= ((kvm_vgic_global_state.ich_vtr_el2 &
+		ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT) <<
+		ICC_CTLR_EL1_SEIS_SHIFT;
+	val |= ((kvm_vgic_global_state.ich_vtr_el2 &
+		ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT) <<
+		ICC_CTLR_EL1_A3V_SHIFT;
+	/*
+	 * The VMCR.CTLR value is in ICC_CTLR_EL1 layout.
+	 * Extract it directly using ICC_CTLR_EL1 reg definitions.
+	 */
+	val |= vmcr.ctlr & ICC_CTLR_EL1_CBPR_MASK;
+	val |= vmcr.ctlr & ICC_CTLR_EL1_EOImode_MASK;
+
+	return val;
+}
+
+static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	bool ret = true;
+
+	if (p->is_write)
+		ret = write_gic_ctlr(vcpu, p->regval);
+	else
+		p->regval = read_gic_ctlr(vcpu);
+
+	return ret;
+}
+
 static bool access_gic_pmr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-- 
2.9.0
