From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH 3/5] KVM: arm64: vgic: Rename vgic_v3_cpu to vgic_cpu
Date: Tue, 21 Mar 2017 12:05:28 +0100
Message-ID: <20170321110530.15857-4-cdall@linaro.org>
References: <20170321110530.15857-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C893440C92
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 07:03:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gvRD8DpfxBTF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 07:03:53 -0400 (EDT)
Received: from mail-wr0-f182.google.com (mail-wr0-f182.google.com
 [209.85.128.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5AB0B40C47
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 07:03:51 -0400 (EDT)
Received: by mail-wr0-f182.google.com with SMTP id u48so109614756wrc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 04:05:37 -0700 (PDT)
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

We have a temporary variable that points to the vgic_cpu structure, and
not the GICv3 specific part, which is a bit misleading compared to the
convention in the rest of the code.

As we are about to mess with the logic of userspace access, let's rename
this.

No functional change.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/kvm/vgic-sys-reg-v3.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 48848db..33f111c 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -20,7 +20,7 @@
 
 static bool write_gic_ctlr(struct kvm_vcpu *vcpu, u32 val)
 {
-	struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	u32 host_pri_bits, host_id_bits, host_seis, host_a3v, seis, a3v;
 	struct vgic_vmcr vmcr;
 
@@ -32,17 +32,17 @@ static bool write_gic_ctlr(struct kvm_vcpu *vcpu, u32 val)
 	 */
 	host_pri_bits = ((val & ICC_CTLR_EL1_PRI_BITS_MASK) >>
 			 ICC_CTLR_EL1_PRI_BITS_SHIFT) + 1;
-	if (host_pri_bits > vgic_v3_cpu->num_pri_bits)
+	if (host_pri_bits > vgic_cpu->num_pri_bits)
 		return false;
 
-	vgic_v3_cpu->num_pri_bits = host_pri_bits;
+	vgic_cpu->num_pri_bits = host_pri_bits;
 
 	host_id_bits = (val & ICC_CTLR_EL1_ID_BITS_MASK) >>
 			ICC_CTLR_EL1_ID_BITS_SHIFT;
-	if (host_id_bits > vgic_v3_cpu->num_id_bits)
+	if (host_id_bits > vgic_cpu->num_id_bits)
 		return false;
 
-	vgic_v3_cpu->num_id_bits = host_id_bits;
+	vgic_cpu->num_id_bits = host_id_bits;
 
 	host_seis = ((kvm_vgic_global_state.ich_vtr_el2 &
 		     ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT);
@@ -70,15 +70,15 @@ static bool write_gic_ctlr(struct kvm_vcpu *vcpu, u32 val)
 
 static u32 read_gic_ctlr(struct kvm_vcpu *vcpu)
 {
-	struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	u32 val = 0;
 	struct vgic_vmcr vmcr;
 
 	vgic_get_vmcr(vcpu, &vmcr);
 
-	val |= (vgic_v3_cpu->num_pri_bits - 1) <<
+	val |= (vgic_cpu->num_pri_bits - 1) <<
 		ICC_CTLR_EL1_PRI_BITS_SHIFT;
-	val |= vgic_v3_cpu->num_id_bits << ICC_CTLR_EL1_ID_BITS_SHIFT;
+	val |= vgic_cpu->num_id_bits << ICC_CTLR_EL1_ID_BITS_SHIFT;
 	val |= ((kvm_vgic_global_state.ich_vtr_el2 &
 		ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT) <<
 		ICC_CTLR_EL1_SEIS_SHIFT;
-- 
2.9.0
