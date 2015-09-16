From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] arm64: KVM: Fix user access for debug registers
Date: Wed, 16 Sep 2015 11:41:10 +0100
Message-ID: <1442400070-23316-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

When setting the debug register from userspace, make sure that
copy_from_user() is called with its parameters in the expected
order. It otherwise doesn't do what you think.

Reported-by: Peter Maydell <peter.maydell@linaro.org>
Cc: Alex Benn=C3=A9e <alex.bennee@linaro.org>
=46ixes: 84e690bfbed1 ("KVM: arm64: introduce vcpu->arch.debug_ptr")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b41607d..1d0463e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -272,7 +272,7 @@ static int set_bvr(struct kvm_vcpu *vcpu, const str=
uct sys_reg_desc *rd,
 {
 	__u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
=20
-	if (copy_from_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
+	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) !=3D 0)
 		return -EFAULT;
 	return 0;
 }
@@ -314,7 +314,7 @@ static int set_bcr(struct kvm_vcpu *vcpu, const str=
uct sys_reg_desc *rd,
 {
 	__u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
=20
-	if (copy_from_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
+	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) !=3D 0)
 		return -EFAULT;
=20
 	return 0;
@@ -358,7 +358,7 @@ static int set_wvr(struct kvm_vcpu *vcpu, const str=
uct sys_reg_desc *rd,
 {
 	__u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
=20
-	if (copy_from_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
+	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) !=3D 0)
 		return -EFAULT;
 	return 0;
 }
@@ -400,7 +400,7 @@ static int set_wcr(struct kvm_vcpu *vcpu, const str=
uct sys_reg_desc *rd,
 {
 	__u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
=20
-	if (copy_from_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
+	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) !=3D 0)
 		return -EFAULT;
 	return 0;
 }
--=20
2.1.4

