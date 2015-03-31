From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 2/4] target-arm: kvm - implement software breakpoints
Date: Tue, 31 Mar 2015 16:40:44 +0100
Message-ID: <1427816446-31586-3-git-send-email-alex.bennee@linaro.org>
References: <1427816446-31586-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427816446-31586-1-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: qemu-devel@nongnu.org, peter.maydell@linaro.org, christoffer.dall@linaro.org, zhichao.huang@linaro.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

These don't involve messing around with debug registers, just setting
the breakpoint instruction in memory. GDB will not use this mechanism i=
f
it can't access the memory to write the breakpoint.

All the kernel has to do is ensure the hypervisor traps the breakpoint
exceptions and returns to userspace.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--
v2
  - handle debug exit with new hsr exception info
  - add verbosity to UNIMP message

diff --git a/target-arm/kvm.c b/target-arm/kvm.c
index 72c1fa1..290c1fe 100644
--- a/target-arm/kvm.c
+++ b/target-arm/kvm.c
@@ -25,6 +25,7 @@
 #include "hw/arm/arm.h"
=20
 const KVMCapabilityInfo kvm_arch_required_capabilities[] =3D {
+    KVM_CAP_INFO(SET_GUEST_DEBUG),
     KVM_CAP_LAST_INFO
 };
=20
@@ -466,9 +467,57 @@ void kvm_arch_post_run(CPUState *cs, struct kvm_ru=
n *run)
 {
 }
=20
+/* See ARM ARM D7.2.27 ESR_ELx, Exception Syndrome Register
+**
+** To minimise translating between kernel and user-space the kernel
+** ABI just provides user-space with the full exception syndrome
+** register value to be decoded in QEMU.
+*/
+
+#define HSR_EC_SHIFT            26
+#define HSR_EC_SW_BKPT          0x3c
+
+static int kvm_handle_debug(CPUState *cs, struct kvm_run *run)
+{
+    struct kvm_debug_exit_arch *arch_info =3D &run->debug.arch;
+    int hsr_ec =3D arch_info->hsr >> HSR_EC_SHIFT;
+
+    switch (hsr_ec) {
+    case HSR_EC_SW_BKPT:
+        if (kvm_find_sw_breakpoint(cs, arch_info->pc)) {
+            return true;
+        }
+        break;
+    default:
+        error_report("%s: unhandled debug exit (%x, %llx)\n",
+                     __func__, arch_info->hsr, arch_info->pc);
+    }
+
+    /* If we don't handle this it could be it really is for the
+       guest to handle */
+    qemu_log_mask(LOG_UNIMP,
+                  "%s: re-injecting exception not yet implemented (0x%=
x, %llx)\n",
+                  __func__, hsr_ec, arch_info->pc);
+
+    return false;
+}
+
 int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
 {
-    return 0;
+    int ret =3D 0;
+
+    switch (run->exit_reason) {
+    case KVM_EXIT_DEBUG:
+        if (kvm_handle_debug(cs, run)) {
+            ret =3D EXCP_DEBUG;
+        } /* otherwise return to guest */
+        break;
+    default:
+        qemu_log_mask(LOG_UNIMP, "%s: un-handled exit reason %d\n",
+                      __func__, run->exit_reason);
+        break;
+    }
+    return ret;
 }
=20
 bool kvm_arch_stop_on_emulation_error(CPUState *cs)
@@ -493,14 +542,33 @@ int kvm_arch_on_sigbus(int code, void *addr)
=20
 void kvm_arch_update_guest_debug(CPUState *cs, struct kvm_guest_debug =
*dbg)
 {
-    qemu_log_mask(LOG_UNIMP, "%s: not implemented\n", __func__);
+    if (kvm_sw_breakpoints_active(cs)) {
+        dbg->control |=3D KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP=
;
+    }
 }
=20
-int kvm_arch_insert_sw_breakpoint(CPUState *cs,
-                                  struct kvm_sw_breakpoint *bp)
+/* C6.6.29 BRK instruction */
+int kvm_arch_insert_sw_breakpoint(CPUState *cs, struct kvm_sw_breakpoi=
nt *bp)
 {
-    qemu_log_mask(LOG_UNIMP, "%s: not implemented\n", __func__);
-    return -EINVAL;
+    static const uint32_t brk =3D 0xd4200000;
+
+    if (cpu_memory_rw_debug(cs, bp->pc, (uint8_t *)&bp->saved_insn, 4,=
 0) ||
+        cpu_memory_rw_debug(cs, bp->pc, (uint8_t *)&brk, 4, 1)) {
+        return -EINVAL;
+    }
+    return 0;
+}
+
+int kvm_arch_remove_sw_breakpoint(CPUState *cs, struct kvm_sw_breakpoi=
nt *bp)
+{
+    static uint32_t brk;
+
+    if (cpu_memory_rw_debug(cs, bp->pc, (uint8_t *)&brk, 4, 0) ||
+        brk !=3D 0xd4200000 ||
+        cpu_memory_rw_debug(cs, bp->pc, (uint8_t *)&bp->saved_insn, 4,=
 1)) {
+        return -EINVAL;
+    }
+    return 0;
 }
=20
 int kvm_arch_insert_hw_breakpoint(target_ulong addr,
@@ -517,12 +585,6 @@ int kvm_arch_remove_hw_breakpoint(target_ulong add=
r,
     return -EINVAL;
 }
=20
-int kvm_arch_remove_sw_breakpoint(CPUState *cs,
-                                  struct kvm_sw_breakpoint *bp)
-{
-    qemu_log_mask(LOG_UNIMP, "%s: not implemented\n", __func__);
-    return -EINVAL;
-}
=20
 void kvm_arch_remove_all_hw_breakpoints(void)
 {
--=20
2.3.4

