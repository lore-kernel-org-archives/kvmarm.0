From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v10 5/6] target-arm: kvm - re-inject guest debug exceptions
Date: Tue,  8 Dec 2015 18:32:32 +0000
Message-ID: <1449599553-24713-6-git-send-email-alex.bennee@linaro.org>
References: <1449599553-24713-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1449599553-24713-1-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, peter.maydell@linaro.org, christoffer.dall@linaro.org, zhichao.huang@linaro.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

If we can't find details for the debug exception in our debug state
then we can assume the exception is due to debugging inside the guest.
To inject the exception into the guest state we re-use the TCG exceptio=
n
code (do_interrupt).

However while guest debugging is in effect we currently can't handle th=
e
guest using single step as we will keep trapping to back to userspace.
GDB makes heavy use of single-step behind the scenes which effectively
means the guests ability to debug itself is disabled while it is being
debugged.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

---
v5:
  - new for v5
v10:
  - fix arm32 compile
  - add full stop at end of sentance
  - attempted to expand on limitations in commit msg
---
 target-arm/helper-a64.c | 12 ++++++++++--
 target-arm/kvm64.c      | 24 +++++++++++++++++-------
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/target-arm/helper-a64.c b/target-arm/helper-a64.c
index deb8dbe..fc3ccdf 100644
--- a/target-arm/helper-a64.c
+++ b/target-arm/helper-a64.c
@@ -25,6 +25,7 @@
 #include "qemu/bitops.h"
 #include "internals.h"
 #include "qemu/crc32c.h"
+#include "sysemu/kvm.h"
 #include <zlib.h> /* For crc32 */
=20
 /* C2.4.7 Multiply and divide */
@@ -469,7 +470,8 @@ void aarch64_cpu_do_interrupt(CPUState *cs)
                   new_el);
     if (qemu_loglevel_mask(CPU_LOG_INT)
         && !excp_is_internal(cs->exception_index)) {
-        qemu_log_mask(CPU_LOG_INT, "...with ESR 0x%" PRIx32 "\n",
+        qemu_log_mask(CPU_LOG_INT, "...with ESR %x/0x%" PRIx32 "\n",
+                      env->exception.syndrome >> ARM_EL_EC_SHIFT,
                       env->exception.syndrome);
     }
=20
@@ -535,6 +537,12 @@ void aarch64_cpu_do_interrupt(CPUState *cs)
     aarch64_restore_sp(env, new_el);
=20
     env->pc =3D addr;
-    cs->interrupt_request |=3D CPU_INTERRUPT_EXITTB;
+
+    qemu_log_mask(CPU_LOG_INT, "...to EL%d PC 0x%" PRIx64 " PSTATE 0x%=
x\n",
+                  new_el, env->pc, pstate_read(env));
+
+    if (!kvm_enabled()) {
+        cs->interrupt_request |=3D CPU_INTERRUPT_EXITTB;
+    }
 }
 #endif
diff --git a/target-arm/kvm64.c b/target-arm/kvm64.c
index 771ecdb..8e6d044 100644
--- a/target-arm/kvm64.c
+++ b/target-arm/kvm64.c
@@ -871,6 +871,7 @@ bool kvm_arm_handle_debug(CPUState *cs, struct kvm_=
debug_exit_arch *debug_exit)
 {
     int hsr_ec =3D debug_exit->hsr >> ARM_EL_EC_SHIFT;
     ARMCPU *cpu =3D ARM_CPU(cs);
+    CPUClass *cc =3D CPU_GET_CLASS(cs);
     CPUARMState *env =3D &cpu->env;
=20
     /* Ensure PC is synchronised */
@@ -881,7 +882,14 @@ bool kvm_arm_handle_debug(CPUState *cs, struct kvm=
_debug_exit_arch *debug_exit)
         if (cs->singlestep_enabled) {
             return true;
         } else {
-            error_report("Came out of SINGLE STEP when not enabled");
+            /*
+             * The kernel should have supressed the guests ability to
+             * single step at this point so something has gone wrong.
+             */
+            error_report("%s: guest single-step while debugging unsupp=
orted"
+                         " (%"PRIx64", %"PRIx32")\n",
+                         __func__, env->pc, debug_exit->hsr);
+            return false;
         }
         break;
     case EC_AA64_BKPT:
@@ -908,12 +916,14 @@ bool kvm_arm_handle_debug(CPUState *cs, struct kv=
m_debug_exit_arch *debug_exit)
                      __func__, debug_exit->hsr, env->pc);
     }
=20
-    /* If we don't handle this it could be it really is for the
-       guest to handle */
-    qemu_log_mask(LOG_UNIMP,
-                  "%s: re-injecting exception not yet implemented"
-                  " (0x%"PRIx32", %"PRIx64")\n",
-                  __func__, hsr_ec, env->pc);
+    /* If we are not handling the debug exception it must belong to
+     * the guest. Let's re-use the existing TCG interrupt code to set
+     * everything up properly.
+     */
+    cs->exception_index =3D EXCP_BKPT;
+    env->exception.syndrome =3D debug_exit->hsr;
+    env->exception.vaddress =3D debug_exit->far;
+    cc->do_interrupt(cs);
=20
     return false;
 }
--=20
2.6.3

