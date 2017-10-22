From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2] KVM: arm/arm64: Allow usercopy to vcpu->arch.ctxt and arm64 debug
Date: Sun, 22 Oct 2017 09:48:36 +0200
Message-ID: <20171022074836.17728-1-christoffer.dall@linaro.org>
References: <20171020232525.7387-1-pbonzini@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171020232525.7387-1-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We do direct useraccess copying to the kvm_cpu_context structure
embedded in the kvm_vcpu_arch structure, and to the vcpu debug register
state.  Everything else (timer, PMU, vgic) goes through a temporary
indirection.

Fixing all accesses to kvm_cpu_context is massively invasive, and we'd
like to avoid that, so we tell kvm_init_usercopy to whitelist accesses
to out context structure.

The debug system register accesses on arm64 are modified to work through
an indirection instead.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
Changes since v1:
  - Use get_user() and put_user() instead of the implicit understanding
    that these will always be 64-bit values.

 arch/arm64/kvm/sys_regs.c | 44 ++++++++++++++++++++++++++++----------------
 virt/kvm/arm/arm.c        |  5 ++++-
 2 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2e070d3baf9f..34b9e1734a3f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -293,19 +293,22 @@ static bool trap_bvr(struct kvm_vcpu *vcpu,
 static int set_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
+	__u64 __user *uval = uaddr;
+	__u64 r;
 
-	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
+	if (get_user(r, uval))
 		return -EFAULT;
+	vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg] = r;
 	return 0;
 }
 
 static int get_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
+	__u64 r = vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
+	__u64 __user *uval = uaddr;
 
-	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
+	if (put_user(r, uval))
 		return -EFAULT;
 	return 0;
 }
@@ -335,10 +338,12 @@ static bool trap_bcr(struct kvm_vcpu *vcpu,
 static int set_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
+	__u64 __user *uval = uaddr;
+	__u64 r;
 
-	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
+	if (get_user(r, uval))
 		return -EFAULT;
+	vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg] = r;
 
 	return 0;
 }
@@ -346,9 +351,10 @@ static int set_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static int get_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
+	__u64 r = vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
+	__u64 __user *uval = uaddr;
 
-	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
+	if (put_user(r, uval))
 		return -EFAULT;
 	return 0;
 }
@@ -379,19 +385,22 @@ static bool trap_wvr(struct kvm_vcpu *vcpu,
 static int set_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
+	__u64 __user *uval = uaddr;
+	__u64 r;
 
-	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
+	if (get_user(r, uval))
 		return -EFAULT;
+	vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg] = r;
 	return 0;
 }
 
 static int get_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
+	__u64 r = vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
+	__u64 __user *uval = uaddr;
 
-	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
+	if (put_user(r, uval))
 		return -EFAULT;
 	return 0;
 }
@@ -421,19 +430,22 @@ static bool trap_wcr(struct kvm_vcpu *vcpu,
 static int set_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
+	__u64 __user *uval = uaddr;
+	__u64 r;
 
-	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
+	if (get_user(r, uval))
 		return -EFAULT;
+	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg] = r;
 	return 0;
 }
 
 static int get_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
+	__u64 r = vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
+	__u64 __user *uval = uaddr;
 
-	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
+	if (put_user(r, uval))
 		return -EFAULT;
 	return 0;
 }
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index b9f68e4add71..639e388678ff 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1502,7 +1502,10 @@ void kvm_arch_exit(void)
 
 static int arm_init(void)
 {
-	int rc = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+	int rc = kvm_init_usercopy(NULL, sizeof(struct kvm_vcpu), 0,
+				   offsetof(struct kvm_vcpu_arch, ctxt),
+				   sizeof_field(struct kvm_vcpu_arch, ctxt),
+				   THIS_MODULE);
 	return rc;
 }
 
-- 
2.14.2
