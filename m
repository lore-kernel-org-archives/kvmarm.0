From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH 2/3] KVM: arm64: Allow to use accessors in KVM_SET_ONE_REG and
 KVM_GET_ONE_REG
Date: Fri, 28 Aug 2015 15:56:11 +0300
Message-ID: <246163c963936234bd9e8091cc676ba260e5a293.1440766141.git.p.fedin@samsung.com>
References: <cover.1440766141.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1440766141.git.p.fedin@samsung.com>
In-reply-to: <cover.1440766141.git.p.fedin@samsung.com>
References: <cover.1440766141.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Call accessor functions if the register is defined in the list but does
not have accociated cell in CPU context.

This allows to implement accessors for vGIC CPU interface, necessary for
live migration.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 arch/arm64/kvm/sys_regs.c | 47 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b41607d..8cc4a5e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1306,10 +1306,6 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 	if (!r)
 		r = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 
-	/* Not saved in the sys_reg array? */
-	if (r && !r->reg)
-		r = NULL;
-
 	return r;
 }
 
@@ -1533,6 +1529,7 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 {
 	const struct sys_reg_desc *r;
 	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
+	u64 val;
 
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
 		return demux_c15_get(reg->id, uaddr);
@@ -1547,13 +1544,31 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (r->get_user)
 		return (r->get_user)(vcpu, r, reg, uaddr);
 
-	return reg_to_user(uaddr, &vcpu_sys_reg(vcpu, r->reg), reg->id);
+	if (r->reg) {
+		val = vcpu_sys_reg(vcpu, r->reg);
+	} else {
+		struct sys_reg_params params;
+
+		if (!index_to_params(reg->id, &params))
+			return -ENOENT;
+
+		params.is_write = false;
+		params.is_aarch32 = false;
+		params.is_32bit = false;
+
+		if (!r->access(vcpu, &params, r))
+			return -EINVAL;
+	}
+
+	return reg_to_user(uaddr, &val, reg->id);
 }
 
 int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	const struct sys_reg_desc *r;
 	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
+	u64 val;
+	int ret;
 
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
 		return demux_c15_set(reg->id, uaddr);
@@ -1568,7 +1583,27 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (r->set_user)
 		return (r->set_user)(vcpu, r, reg, uaddr);
 
-	return reg_from_user(&vcpu_sys_reg(vcpu, r->reg), uaddr, reg->id);
+	ret = reg_from_user(&val, uaddr, reg->id);
+	if (ret)
+		return ret;
+
+	if (r->reg) {
+		vcpu_sys_reg(vcpu, r->reg) = val;
+	} else {
+		struct sys_reg_params params;
+
+		if (!index_to_params(reg->id, &params))
+			return -ENOENT;
+
+		params.is_write = true;
+		params.is_aarch32 = false;
+		params.is_32bit = false;
+
+		if (!r->access(vcpu, &params, r))
+			return -EINVAL;
+	}
+
+	return 0;
 }
 
 static unsigned int num_demux_regs(void)
-- 
2.4.4

