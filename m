From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 11/25] KVM: arm64: add trace points for guest_debug debug
Date: Thu, 20 Aug 2015 17:28:49 +0100
Message-ID: <1440088143-4722-12-git-send-email-marc.zyngier@arm.com>
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

This includes trace points for:
  kvm_arch_setup_guest_debug
  kvm_arch_clear_guest_debug

I've also added some generic register setting trace events and also a
trace point to dump the array of hardware registers.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/debug.c    |  36 +++++++++++++-
 arch/arm64/kvm/guest.c    |   4 ++
 arch/arm64/kvm/sys_regs.c |  17 +++++++
 arch/arm64/kvm/trace.h    | 123 ++++++++++++++++++++++++++++++++++++++=
++++++++
 4 files changed, 179 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 4a99e54..47e5f0f 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -18,12 +18,15 @@
  */
=20
 #include <linux/kvm_host.h>
+#include <linux/hw_breakpoint.h>
=20
 #include <asm/debug-monitors.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_emulate.h>
=20
+#include "trace.h"
+
 /* These are the bits of MDSCR_EL1 we may manipulate */
 #define MDSCR_EL1_DEBUG_MASK	(DBG_MDSCR_SS | \
 				DBG_MDSCR_KDE | \
@@ -44,11 +47,17 @@ static DEFINE_PER_CPU(u32, mdcr_el2);
 static void save_guest_debug_regs(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.guest_debug_preserved.mdscr_el1 =3D vcpu_sys_reg(vcpu, MDS=
CR_EL1);
+
+	trace_kvm_arm_set_dreg32("Saved MDSCR_EL1",
+				vcpu->arch.guest_debug_preserved.mdscr_el1);
 }
=20
 static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
 {
 	vcpu_sys_reg(vcpu, MDSCR_EL1) =3D vcpu->arch.guest_debug_preserved.md=
scr_el1;
+
+	trace_kvm_arm_set_dreg32("Restored MDSCR_EL1",
+				vcpu_sys_reg(vcpu, MDSCR_EL1));
 }
=20
 /**
@@ -99,6 +108,8 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 {
 	bool trap_debug =3D !(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)=
;
=20
+	trace_kvm_arm_setup_debug(vcpu, vcpu->guest_debug);
+
 	vcpu->arch.mdcr_el2 =3D __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MAS=
K;
 	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TPM |
 				MDCR_EL2_TPMCR |
@@ -140,6 +151,8 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 			vcpu_sys_reg(vcpu, MDSCR_EL1) &=3D ~DBG_MDSCR_SS;
 		}
=20
+		trace_kvm_arm_set_dreg32("SPSR_EL2", *vcpu_cpsr(vcpu));
+
 		/*
 		 * HW Breakpoints and watchpoints
 		 *
@@ -156,6 +169,14 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 			vcpu->arch.debug_ptr =3D &vcpu->arch.external_debug_state;
 			vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
 			trap_debug =3D true;
+
+			trace_kvm_arm_set_regset("BKPTS", get_num_brps(),
+						&vcpu->arch.debug_ptr->dbg_bcr[0],
+						&vcpu->arch.debug_ptr->dbg_bvr[0]);
+
+			trace_kvm_arm_set_regset("WAPTS", get_num_wrps(),
+						&vcpu->arch.debug_ptr->dbg_wcr[0],
+						&vcpu->arch.debug_ptr->dbg_wvr[0]);
 		}
 	}
=20
@@ -165,10 +186,15 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	/* Trap debug register access */
 	if (trap_debug)
 		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
+
+	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
+	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_sys_reg(vcpu, MDSCR_EL1));
 }
=20
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 {
+	trace_kvm_arm_clear_debug(vcpu->guest_debug);
+
 	if (vcpu->guest_debug) {
 		restore_guest_debug_regs(vcpu);
=20
@@ -176,8 +202,16 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 		 * If we were using HW debug we need to restore the
 		 * debug_ptr to the guest debug state.
 		 */
-		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW)
+		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW) {
 			kvm_arm_reset_debug_ptr(vcpu);
=20
+			trace_kvm_arm_set_regset("BKPTS", get_num_brps(),
+						&vcpu->arch.debug_ptr->dbg_bcr[0],
+						&vcpu->arch.debug_ptr->dbg_bvr[0]);
+
+			trace_kvm_arm_set_regset("WAPTS", get_num_wrps(),
+						&vcpu->arch.debug_ptr->dbg_wcr[0],
+						&vcpu->arch.debug_ptr->dbg_wvr[0]);
+		}
 	}
 }
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 6f1b249..48868d8 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -32,6 +32,8 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
=20
+#include "trace.h"
+
 struct kvm_stats_debugfs_item debugfs_entries[] =3D {
 	{ NULL }
 };
@@ -350,6 +352,8 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *=
vcpu,
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg)
 {
+	trace_kvm_set_guest_debug(vcpu, dbg->control);
+
 	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK)
 		return -EINVAL;
=20
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 158bae7..b41607d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -38,6 +38,8 @@
=20
 #include "sys_regs.h"
=20
+#include "trace.h"
+
 /*
  * All of this file is extremly similar to the ARM coproc.c, but the
  * types are different. My gut feeling is that it should be pretty
@@ -208,6 +210,8 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
 		*vcpu_reg(vcpu, p->Rt) =3D vcpu_sys_reg(vcpu, r->reg);
 	}
=20
+	trace_trap_reg(__func__, r->reg, p->is_write, *vcpu_reg(vcpu, p->Rt))=
;
+
 	return true;
 }
=20
@@ -258,6 +262,8 @@ static inline bool trap_bvr(struct kvm_vcpu *vcpu,
 	else
 		dbg_to_reg(vcpu, p, dbg_reg);
=20
+	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
+
 	return true;
 }
=20
@@ -298,6 +304,8 @@ static inline bool trap_bcr(struct kvm_vcpu *vcpu,
 	else
 		dbg_to_reg(vcpu, p, dbg_reg);
=20
+	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
+
 	return true;
 }
=20
@@ -339,6 +347,9 @@ static inline bool trap_wvr(struct kvm_vcpu *vcpu,
 	else
 		dbg_to_reg(vcpu, p, dbg_reg);
=20
+	trace_trap_reg(__func__, rd->reg, p->is_write,
+		vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg]);
+
 	return true;
 }
=20
@@ -379,6 +390,8 @@ static inline bool trap_wcr(struct kvm_vcpu *vcpu,
 	else
 		dbg_to_reg(vcpu, p, dbg_reg);
=20
+	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
+
 	return true;
 }
=20
@@ -742,6 +755,8 @@ static inline bool trap_xvr(struct kvm_vcpu *vcpu,
 		*vcpu_reg(vcpu, p->Rt) =3D *dbg_reg >> 32;
 	}
=20
+	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
+
 	return true;
 }
=20
@@ -1223,6 +1238,8 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, str=
uct kvm_run *run)
 	struct sys_reg_params params;
 	unsigned long esr =3D kvm_vcpu_get_hsr(vcpu);
=20
+	trace_kvm_handle_sys_reg(esr);
+
 	params.is_aarch32 =3D false;
 	params.is_32bit =3D false;
 	params.Op0 =3D (esr >> 20) & 3;
diff --git a/arch/arm64/kvm/trace.h b/arch/arm64/kvm/trace.h
index 157416e9..7fb0008 100644
--- a/arch/arm64/kvm/trace.h
+++ b/arch/arm64/kvm/trace.h
@@ -44,6 +44,129 @@ TRACE_EVENT(kvm_hvc_arm64,
 		  __entry->vcpu_pc, __entry->r0, __entry->imm)
 );
=20
+TRACE_EVENT(kvm_arm_setup_debug,
+	TP_PROTO(struct kvm_vcpu *vcpu, __u32 guest_debug),
+	TP_ARGS(vcpu, guest_debug),
+
+	TP_STRUCT__entry(
+		__field(struct kvm_vcpu *, vcpu)
+		__field(__u32, guest_debug)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu =3D vcpu;
+		__entry->guest_debug =3D guest_debug;
+	),
+
+	TP_printk("vcpu: %p, flags: 0x%08x", __entry->vcpu, __entry->guest_de=
bug)
+);
+
+TRACE_EVENT(kvm_arm_clear_debug,
+	TP_PROTO(__u32 guest_debug),
+	TP_ARGS(guest_debug),
+
+	TP_STRUCT__entry(
+		__field(__u32, guest_debug)
+	),
+
+	TP_fast_assign(
+		__entry->guest_debug =3D guest_debug;
+	),
+
+	TP_printk("flags: 0x%08x", __entry->guest_debug)
+);
+
+TRACE_EVENT(kvm_arm_set_dreg32,
+	TP_PROTO(const char *name, __u32 value),
+	TP_ARGS(name, value),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(__u32, value)
+	),
+
+	TP_fast_assign(
+		__entry->name =3D name;
+		__entry->value =3D value;
+	),
+
+	TP_printk("%s: 0x%08x", __entry->name, __entry->value)
+);
+
+TRACE_EVENT(kvm_arm_set_regset,
+	TP_PROTO(const char *type, int len, __u64 *control, __u64 *value),
+	TP_ARGS(type, len, control, value),
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(int, len)
+		__array(u64, ctrls, 16)
+		__array(u64, values, 16)
+	),
+	TP_fast_assign(
+		__entry->name =3D type;
+		__entry->len =3D len;
+		memcpy(__entry->ctrls, control, len << 3);
+		memcpy(__entry->values, value, len << 3);
+	),
+	TP_printk("%d %s CTRL:%s VALUE:%s", __entry->len, __entry->name,
+		__print_array(__entry->ctrls, __entry->len, sizeof(__u64)),
+		__print_array(__entry->values, __entry->len, sizeof(__u64)))
+);
+
+TRACE_EVENT(trap_reg,
+	TP_PROTO(const char *fn, int reg, bool is_write, u64 write_value),
+	TP_ARGS(fn, reg, is_write, write_value),
+
+	TP_STRUCT__entry(
+		__field(const char *, fn)
+		__field(int, reg)
+		__field(bool, is_write)
+		__field(u64, write_value)
+	),
+
+	TP_fast_assign(
+		__entry->fn =3D fn;
+		__entry->reg =3D reg;
+		__entry->is_write =3D is_write;
+		__entry->write_value =3D write_value;
+	),
+
+	TP_printk("%s %s reg %d (0x%08llx)", __entry->fn,  __entry->is_write?=
"write to":"read from", __entry->reg, __entry->write_value)
+);
+
+TRACE_EVENT(kvm_handle_sys_reg,
+	TP_PROTO(unsigned long hsr),
+	TP_ARGS(hsr),
+
+	TP_STRUCT__entry(
+		__field(unsigned long,	hsr)
+	),
+
+	TP_fast_assign(
+		__entry->hsr =3D hsr;
+	),
+
+	TP_printk("HSR 0x%08lx", __entry->hsr)
+);
+
+TRACE_EVENT(kvm_set_guest_debug,
+	TP_PROTO(struct kvm_vcpu *vcpu, __u32 guest_debug),
+	TP_ARGS(vcpu, guest_debug),
+
+	TP_STRUCT__entry(
+		__field(struct kvm_vcpu *, vcpu)
+		__field(__u32, guest_debug)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu =3D vcpu;
+		__entry->guest_debug =3D guest_debug;
+	),
+
+	TP_printk("vcpu: %p, flags: 0x%08x", __entry->vcpu, __entry->guest_de=
bug)
+);
+
+
 #endif /* _TRACE_ARM64_KVM_H */
=20
 #undef TRACE_INCLUDE_PATH
--=20
2.1.4

