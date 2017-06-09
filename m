From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 27/27] KVM: arm64: Log an error if trapping a
 write-to-read-only GICv3 access
Date: Fri,  9 Jun 2017 12:49:56 +0100
Message-ID: <20170609114956.25963-28-marc.zyngier@arm.com>
References: <20170609114956.25963-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7251740D38
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jun 2017 07:46:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3JYLxn4L9WX6 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Jun 2017 07:46:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA50340DEC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jun 2017 07:46:42 -0400 (EDT)
In-Reply-To: <20170609114956.25963-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

A write-to-read-only GICv3 access should UNDEF at EL1. But since
we're in complete paranoia-land with broken CPUs, let's assume the
worse and gracefully handle the case.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c     | 15 +++++++++++++++
 virt/kvm/arm/hyp/vgic-v3-sr.c |  6 ++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8d51c075966d..77862881ae86 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -65,6 +65,16 @@ static bool read_from_write_only(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+static bool write_to_read_only(struct kvm_vcpu *vcpu,
+			       struct sys_reg_params *params,
+			       const struct sys_reg_desc *r)
+{
+	WARN_ONCE(1, "Unexpected sys_reg write to read-only register\n");
+	print_sys_reg_instr(params);
+	kvm_inject_undefined(vcpu);
+	return false;
+}
+
 /* 3 bits per cache level, as per CLIDR, but non-existent caches always 0 */
 static u32 cache_levels;
 
@@ -954,10 +964,15 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_VBAR_EL1), NULL, reset_val, VBAR_EL1, 0 },
 
+	{ SYS_DESC(SYS_ICC_IAR0_EL1), write_to_read_only },
 	{ SYS_DESC(SYS_ICC_EOIR0_EL1), read_from_write_only },
+	{ SYS_DESC(SYS_ICC_HPPIR0_EL1), write_to_read_only },
 	{ SYS_DESC(SYS_ICC_DIR_EL1), read_from_write_only },
+	{ SYS_DESC(SYS_ICC_RPR_EL1), write_to_read_only },
 	{ SYS_DESC(SYS_ICC_SGI1R_EL1), access_gic_sgi },
+	{ SYS_DESC(SYS_ICC_IAR1_EL1), write_to_read_only },
 	{ SYS_DESC(SYS_ICC_EOIR1_EL1), read_from_write_only },
+	{ SYS_DESC(SYS_ICC_HPPIR1_EL1), write_to_read_only },
 	{ SYS_DESC(SYS_ICC_SRE_EL1), access_gic_sre },
 
 	{ SYS_DESC(SYS_CONTEXTIDR_EL1), access_vm_reg, reset_val, CONTEXTIDR_EL1, 0 },
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index b26ce58b012a..79e3c2d3b754 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -976,6 +976,8 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	switch (sysreg) {
 	case SYS_ICC_IAR0_EL1:
 	case SYS_ICC_IAR1_EL1:
+		if (unlikely(!is_read))
+			return 0;
 		fn = __vgic_v3_read_iar;
 		break;
 	case SYS_ICC_EOIR0_EL1:
@@ -1026,6 +1028,8 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		break;
 	case SYS_ICC_HPPIR0_EL1:
 	case SYS_ICC_HPPIR1_EL1:
+		if (unlikely(!is_read))
+			return 0;
 		fn = __vgic_v3_read_hppir;
 		break;
 	case SYS_ICC_GRPEN0_EL1:
@@ -1046,6 +1050,8 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		fn = __vgic_v3_write_dir;
 		break;
 	case SYS_ICC_RPR_EL1:
+		if (unlikely(!is_read))
+			return 0;
 		fn = __vgic_v3_read_rpr;
 		break;
 	case SYS_ICC_CTLR_EL1:
-- 
2.11.0
