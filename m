From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 05/25] KVM: arm64: guest debug, add SW break point support
Date: Thu, 20 Aug 2015 17:28:43 +0100
Message-ID: <1440088143-4722-6-git-send-email-marc.zyngier@arm.com>
References: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Mario Smarduch <m.smarduch@samsung.com>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>, Vladimir Murzin <vladimir.murzin@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

=46rom: Alex Benn=C3=A9e <alex.bennee@linaro.org>

This adds support for SW breakpoints inserted by userspace.

We do this by trapping all guest software debug exceptions to the
hypervisor (MDCR_EL2.TDE). The exit handler sets an exit reason of
KVM_EXIT_DEBUG with the kvm_debug_exit_arch structure holding the
exception syndrome information.

It will be up to userspace to extract the PC (via GET_ONE_REG) and
determine if the debug event was for a breakpoint it inserted. If not
userspace will need to re-inject the correct exception restart the
hypervisor to deliver the debug exception to the guest.

Any other guest software debug exception (e.g. single step or HW
assisted breakpoints) will cause an error and the VM to be killed. This
is addressed by later patches which add support for the other debug
types.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/api.txt |  2 +-
 arch/arm64/kvm/debug.c            |  3 +++
 arch/arm64/kvm/guest.c            |  2 +-
 arch/arm64/kvm/handle_exit.c      | 36 +++++++++++++++++++++++++++++++=
+++++
 4 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/=
kvm/api.txt
index 19adfd3..0f498da 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2693,7 +2693,7 @@ when running. Common control bits are:
 The top 16 bits of the control field are architecture specific control
 flags which can include the following:
=20
-  - KVM_GUESTDBG_USE_SW_BP:     using software breakpoints [x86]
+  - KVM_GUESTDBG_USE_SW_BP:     using software breakpoints [x86, arm64=
]
   - KVM_GUESTDBG_USE_HW_BP:     using hardware breakpoints [x86, s390]
   - KVM_GUESTDBG_INJECT_DB:     inject DB type exception [x86]
   - KVM_GUESTDBG_INJECT_BP:     inject BP type exception [x86]
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index faf0e1f..8d1bfa4 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -73,6 +73,9 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	if (trap_debug)
 		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
=20
+	/* Trap breakpoints? */
+	if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
+		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDE;
 }
=20
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 0ba8677..22d22c5 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -332,7 +332,7 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *=
vcpu,
 	return -EINVAL;
 }
=20
-#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE)
+#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_US=
E_SW_BP)
=20
 /**
  * kvm_arch_vcpu_ioctl_set_guest_debug - set up guest debugging
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.=
c
index 524fa25..27f38a9 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -82,6 +82,40 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, str=
uct kvm_run *run)
 	return 1;
 }
=20
+/**
+ * kvm_handle_guest_debug - handle a debug exception instruction
+ *
+ * @vcpu:	the vcpu pointer
+ * @run:	access to the kvm_run structure for results
+ *
+ * We route all debug exceptions through the same handler. If both the
+ * guest and host are using the same debug facilities it will be up to
+ * userspace to re-inject the correct exception for guest delivery.
+ *
+ * @return: 0 (while setting run->exit_reason), -1 for error
+ */
+static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu, struct kvm_ru=
n *run)
+{
+	u32 hsr =3D kvm_vcpu_get_hsr(vcpu);
+	int ret =3D 0;
+
+	run->exit_reason =3D KVM_EXIT_DEBUG;
+	run->debug.arch.hsr =3D hsr;
+
+	switch (hsr >> ESR_ELx_EC_SHIFT) {
+	case ESR_ELx_EC_BKPT32:
+	case ESR_ELx_EC_BRK64:
+		break;
+	default:
+		kvm_err("%s: un-handled case hsr: %#08x\n",
+			__func__, (unsigned int) hsr);
+		ret =3D -1;
+		break;
+	}
+
+	return ret;
+}
+
 static exit_handle_fn arm_exit_handlers[] =3D {
 	[ESR_ELx_EC_WFx]	=3D kvm_handle_wfx,
 	[ESR_ELx_EC_CP15_32]	=3D kvm_handle_cp15_32,
@@ -96,6 +130,8 @@ static exit_handle_fn arm_exit_handlers[] =3D {
 	[ESR_ELx_EC_SYS64]	=3D kvm_handle_sys_reg,
 	[ESR_ELx_EC_IABT_LOW]	=3D kvm_handle_guest_abort,
 	[ESR_ELx_EC_DABT_LOW]	=3D kvm_handle_guest_abort,
+	[ESR_ELx_EC_BKPT32]	=3D kvm_handle_guest_debug,
+	[ESR_ELx_EC_BRK64]	=3D kvm_handle_guest_debug,
 };
=20
 static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
--=20
2.1.4

