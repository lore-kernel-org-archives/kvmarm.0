From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] arm64: KVM: debug: Remove spurious inline attributes
Date: Wed, 16 Dec 2015 15:49:23 +0000
Message-ID: <1450280963-19985-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.bennee@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

The debug trapping code is pretty heavy on the "inline" attribute,
but most functions are actually referenced in the sysreg tables,
making the inlining imposible.

Removing the useless inline qualifier seems the right thing to do,
having verified that the output code is similar.

Cc: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 58 +++++++++++++++++++++++----------------=
--------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 88adebf..eec3598 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -220,9 +220,9 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
  * All writes will set the KVM_ARM64_DEBUG_DIRTY flag to ensure the
  * hyp.S code switches between host and guest values in future.
  */
-static inline void reg_to_dbg(struct kvm_vcpu *vcpu,
-			      struct sys_reg_params *p,
-			      u64 *dbg_reg)
+static void reg_to_dbg(struct kvm_vcpu *vcpu,
+		       struct sys_reg_params *p,
+		       u64 *dbg_reg)
 {
 	u64 val =3D p->regval;
=20
@@ -235,18 +235,18 @@ static inline void reg_to_dbg(struct kvm_vcpu *vc=
pu,
 	vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
 }
=20
-static inline void dbg_to_reg(struct kvm_vcpu *vcpu,
-			      struct sys_reg_params *p,
-			      u64 *dbg_reg)
+static void dbg_to_reg(struct kvm_vcpu *vcpu,
+		       struct sys_reg_params *p,
+		       u64 *dbg_reg)
 {
 	p->regval =3D *dbg_reg;
 	if (p->is_32bit)
 		p->regval &=3D 0xffffffffUL;
 }
=20
-static inline bool trap_bvr(struct kvm_vcpu *vcpu,
-			    struct sys_reg_params *p,
-			    const struct sys_reg_desc *rd)
+static bool trap_bvr(struct kvm_vcpu *vcpu,
+		     struct sys_reg_params *p,
+		     const struct sys_reg_desc *rd)
 {
 	u64 *dbg_reg =3D &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
=20
@@ -280,15 +280,15 @@ static int get_bvr(struct kvm_vcpu *vcpu, const s=
truct sys_reg_desc *rd,
 	return 0;
 }
=20
-static inline void reset_bvr(struct kvm_vcpu *vcpu,
-			     const struct sys_reg_desc *rd)
+static void reset_bvr(struct kvm_vcpu *vcpu,
+		      const struct sys_reg_desc *rd)
 {
 	vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg] =3D rd->val;
 }
=20
-static inline bool trap_bcr(struct kvm_vcpu *vcpu,
-			    struct sys_reg_params *p,
-			    const struct sys_reg_desc *rd)
+static bool trap_bcr(struct kvm_vcpu *vcpu,
+		     struct sys_reg_params *p,
+		     const struct sys_reg_desc *rd)
 {
 	u64 *dbg_reg =3D &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
=20
@@ -323,15 +323,15 @@ static int get_bcr(struct kvm_vcpu *vcpu, const s=
truct sys_reg_desc *rd,
 	return 0;
 }
=20
-static inline void reset_bcr(struct kvm_vcpu *vcpu,
-			     const struct sys_reg_desc *rd)
+static void reset_bcr(struct kvm_vcpu *vcpu,
+		      const struct sys_reg_desc *rd)
 {
 	vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg] =3D rd->val;
 }
=20
-static inline bool trap_wvr(struct kvm_vcpu *vcpu,
-			    struct sys_reg_params *p,
-			    const struct sys_reg_desc *rd)
+static bool trap_wvr(struct kvm_vcpu *vcpu,
+		     struct sys_reg_params *p,
+		     const struct sys_reg_desc *rd)
 {
 	u64 *dbg_reg =3D &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
=20
@@ -366,15 +366,15 @@ static int get_wvr(struct kvm_vcpu *vcpu, const s=
truct sys_reg_desc *rd,
 	return 0;
 }
=20
-static inline void reset_wvr(struct kvm_vcpu *vcpu,
-			     const struct sys_reg_desc *rd)
+static void reset_wvr(struct kvm_vcpu *vcpu,
+		      const struct sys_reg_desc *rd)
 {
 	vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg] =3D rd->val;
 }
=20
-static inline bool trap_wcr(struct kvm_vcpu *vcpu,
-			    struct sys_reg_params *p,
-			    const struct sys_reg_desc *rd)
+static bool trap_wcr(struct kvm_vcpu *vcpu,
+		     struct sys_reg_params *p,
+		     const struct sys_reg_desc *rd)
 {
 	u64 *dbg_reg =3D &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
=20
@@ -408,8 +408,8 @@ static int get_wcr(struct kvm_vcpu *vcpu, const str=
uct sys_reg_desc *rd,
 	return 0;
 }
=20
-static inline void reset_wcr(struct kvm_vcpu *vcpu,
-			     const struct sys_reg_desc *rd)
+static void reset_wcr(struct kvm_vcpu *vcpu,
+		      const struct sys_reg_desc *rd)
 {
 	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg] =3D rd->val;
 }
@@ -723,9 +723,9 @@ static bool trap_debug32(struct kvm_vcpu *vcpu,
  * system is in.
  */
=20
-static inline bool trap_xvr(struct kvm_vcpu *vcpu,
-			    struct sys_reg_params *p,
-			    const struct sys_reg_desc *rd)
+static bool trap_xvr(struct kvm_vcpu *vcpu,
+		     struct sys_reg_params *p,
+		     const struct sys_reg_desc *rd)
 {
 	u64 *dbg_reg =3D &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
=20
--=20
2.1.4

