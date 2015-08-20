From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 06/25] KVM: arm64: guest debug, add support for single-step
Date: Thu, 20 Aug 2015 17:28:44 +0100
Message-ID: <1440088143-4722-7-git-send-email-marc.zyngier@arm.com>
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

This adds support for single-stepping the guest. To do this we need to
manipulate the guests PSTATE.SS and MDSCR_EL1.SS bits to trigger
stepping. We take care to preserve MDSCR_EL1 and trap access to it to
ensure we don't affect the apparent state of the guest.

As we have to enable trapping of all software debug exceptions we
suppress the ability of the guest to single-step itself. If we didn't w=
e
would have to deal with the exception arriving while the guest was in
kernelspace when the guest is expecting to single-step userspace. This
is something we don't want to unwind in the kernel. Once the host is no
longer debugging the guest its ability to single-step userspace is
restored.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 11 +++++++
 arch/arm64/kvm/debug.c            | 68 +++++++++++++++++++++++++++++++=
+++++---
 arch/arm64/kvm/guest.c            |  4 ++-
 arch/arm64/kvm/handle_exit.c      |  2 ++
 4 files changed, 80 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
index c90c6a4..cfb6754 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -123,6 +123,17 @@ struct kvm_vcpu_arch {
 	 * here.
 	 */
=20
+	/*
+	 * Guest registers we preserve during guest debugging.
+	 *
+	 * These shadow registers are updated by the kvm_handle_sys_reg
+	 * trap handler if the guest accesses or updates them while we
+	 * are using guest debug.
+	 */
+	struct {
+		u32	mdscr_el1;
+	} guest_debug_preserved;
+
 	/* Don't run the guest */
 	bool pause;
=20
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 8d1bfa4..d439eb8 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -19,11 +19,39 @@
=20
 #include <linux/kvm_host.h>
=20
+#include <asm/debug-monitors.h>
+#include <asm/kvm_asm.h>
 #include <asm/kvm_arm.h>
+#include <asm/kvm_emulate.h>
+
+/* These are the bits of MDSCR_EL1 we may manipulate */
+#define MDSCR_EL1_DEBUG_MASK	(DBG_MDSCR_SS | \
+				DBG_MDSCR_KDE | \
+				DBG_MDSCR_MDE)
=20
 static DEFINE_PER_CPU(u32, mdcr_el2);
=20
 /**
+ * save/restore_guest_debug_regs
+ *
+ * For some debug operations we need to tweak some guest registers. As
+ * a result we need to save the state of those registers before we
+ * make those modifications.
+ *
+ * Guest access to MDSCR_EL1 is trapped by the hypervisor and handled
+ * after we have restored the preserved value to the main context.
+ */
+static void save_guest_debug_regs(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.guest_debug_preserved.mdscr_el1 =3D vcpu_sys_reg(vcpu, MDS=
CR_EL1);
+}
+
+static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
+{
+	vcpu_sys_reg(vcpu, MDSCR_EL1) =3D vcpu->arch.guest_debug_preserved.md=
scr_el1;
+}
+
+/**
  * kvm_arm_init_debug - grab what we need for debug
  *
  * Currently the sole task of this function is to retrieve the initial
@@ -38,7 +66,6 @@ void kvm_arm_init_debug(void)
 	__this_cpu_write(mdcr_el2, kvm_call_hyp(__kvm_get_mdcr_el2));
 }
=20
-
 /**
  * kvm_arm_setup_debug - set up debug related stuff
  *
@@ -73,12 +100,45 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	if (trap_debug)
 		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
=20
-	/* Trap breakpoints? */
-	if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
+	/* Is Guest debugging in effect? */
+	if (vcpu->guest_debug) {
+		/* Route all software debug exceptions to EL2 */
 		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDE;
+
+		/* Save guest debug state */
+		save_guest_debug_regs(vcpu);
+
+		/*
+		 * Single Step (ARM ARM D2.12.3 The software step state
+		 * machine)
+		 *
+		 * If we are doing Single Step we need to manipulate
+		 * the guest's MDSCR_EL1.SS and PSTATE.SS. Once the
+		 * step has occurred the hypervisor will trap the
+		 * debug exception and we return to userspace.
+		 *
+		 * If the guest attempts to single step its userspace
+		 * we would have to deal with a trapped exception
+		 * while in the guest kernel. Because this would be
+		 * hard to unwind we suppress the guest's ability to
+		 * do so by masking MDSCR_EL.SS.
+		 *
+		 * This confuses guest debuggers which use
+		 * single-step behind the scenes but everything
+		 * returns to normal once the host is no longer
+		 * debugging the system.
+		 */
+		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
+			*vcpu_cpsr(vcpu) |=3D  DBG_SPSR_SS;
+			vcpu_sys_reg(vcpu, MDSCR_EL1) |=3D DBG_MDSCR_SS;
+		} else {
+			vcpu_sys_reg(vcpu, MDSCR_EL1) &=3D ~DBG_MDSCR_SS;
+		}
+	}
 }
=20
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 {
-	/* Nothing to do yet */
+	if (vcpu->guest_debug)
+		restore_guest_debug_regs(vcpu);
 }
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 22d22c5..48de4f4 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -332,7 +332,9 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *=
vcpu,
 	return -EINVAL;
 }
=20
-#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_US=
E_SW_BP)
+#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE |    \
+			    KVM_GUESTDBG_USE_SW_BP | \
+			    KVM_GUESTDBG_SINGLESTEP)
=20
 /**
  * kvm_arch_vcpu_ioctl_set_guest_debug - set up guest debugging
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.=
c
index 27f38a9..e9de13e 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -103,6 +103,7 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *=
vcpu, struct kvm_run *run)
 	run->debug.arch.hsr =3D hsr;
=20
 	switch (hsr >> ESR_ELx_EC_SHIFT) {
+	case ESR_ELx_EC_SOFTSTP_LOW:
 	case ESR_ELx_EC_BKPT32:
 	case ESR_ELx_EC_BRK64:
 		break;
@@ -130,6 +131,7 @@ static exit_handle_fn arm_exit_handlers[] =3D {
 	[ESR_ELx_EC_SYS64]	=3D kvm_handle_sys_reg,
 	[ESR_ELx_EC_IABT_LOW]	=3D kvm_handle_guest_abort,
 	[ESR_ELx_EC_DABT_LOW]	=3D kvm_handle_guest_abort,
+	[ESR_ELx_EC_SOFTSTP_LOW]=3D kvm_handle_guest_debug,
 	[ESR_ELx_EC_BKPT32]	=3D kvm_handle_guest_debug,
 	[ESR_ELx_EC_BRK64]	=3D kvm_handle_guest_debug,
 };
--=20
2.1.4

