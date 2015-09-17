From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/8] arm64: KVM: Fix user access for debug registers
Date: Thu, 17 Sep 2015 15:46:05 +0100
Message-ID: <1442501171-24484-3-git-send-email-marc.zyngier@arm.com>
References: <1442501171-24484-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1442501171-24484-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Will Deacon <will.deacon@arm.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Marek Majtyka <marek.majtyka@tieto.com>, Pavel Fedin <p.fedin@samsung.com>, Ming Lei <ming.lei@canonical.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

When setting the debug register from userspace, make sure that
copy_from_user() is called with its parameters in the expected
order. It otherwise doesn't do what you think.

=46ixes: 84e690bfbed1 ("KVM: arm64: introduce vcpu->arch.debug_ptr")
Reported-by: Peter Maydell <peter.maydell@linaro.org>
Cc: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
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

