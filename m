From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 5/6] target-arm: kvm64 fix save/restore of SPSR regs
Date: Wed,  4 Mar 2015 14:35:52 +0000
Message-ID: <1425479753-18349-6-git-send-email-alex.bennee@linaro.org>
References: <1425479753-18349-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1425479753-18349-1-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

=46rom: Christoffer Dall <christoffer.dall@linaro.org>

The current code was negatively indexing the cpu state array and not
synchronizing banked spsr register state with the current mode's spsr
state, causing occasional failures with migration.

Some munging is done to take care of the aarch64 mapping and also to
ensure the most current value of the spsr is updated to the banked
registers (relevant for KVM<->TCG migration).

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

---
v2 (ajb)
  - minor tweaks and clarifications
v3
  - Use the correct bank index function for setting/getting env->spsr
  - only deal with spsrs in elevated exception levels

diff --git a/target-arm/kvm64.c b/target-arm/kvm64.c
index c60e989..45e5c3f 100644
--- a/target-arm/kvm64.c
+++ b/target-arm/kvm64.c
@@ -140,6 +140,7 @@ int kvm_arch_put_registers(CPUState *cs, int level)
     uint64_t val;
     int i;
     int ret;
+    unsigned int el;
=20
     ARMCPU *cpu =3D ARM_CPU(cs);
     CPUARMState *env =3D &cpu->env;
@@ -206,9 +207,27 @@ int kvm_arch_put_registers(CPUState *cs, int level=
)
         return ret;
     }
=20
+    /* Saved Program State Registers
+     *
+     * Before we restore from the banked_spsr[] array we need to
+     * ensure that any modifications to env->spsr are correctly
+     * reflected and map aarch64 exception levels if required.
+     */
+    el =3D arm_current_el(env);
+    if (el > 0) {
+        if (is_a64(env)) {
+            g_assert(el =3D=3D 1);
+            /* KVM only maps KVM_SPSR_SVC to KVM_SPSR_EL1 for aarch64 =
ATM */
+            env->banked_spsr[1] =3D env->banked_spsr[0];
+        } else {
+            i =3D bank_number(env->uncached_cpsr & CPSR_M);
+            env->banked_spsr[i] =3D env->spsr;
+        }
+    }
+
     for (i =3D 0; i < KVM_NR_SPSR; i++) {
         reg.id =3D AARCH64_CORE_REG(spsr[i]);
-        reg.addr =3D (uintptr_t) &env->banked_spsr[i - 1];
+        reg.addr =3D (uintptr_t) &env->banked_spsr[i+1];
         ret =3D kvm_vcpu_ioctl(cs, KVM_SET_ONE_REG, &reg);
         if (ret) {
             return ret;
@@ -253,6 +272,7 @@ int kvm_arch_get_registers(CPUState *cs)
     struct kvm_one_reg reg;
     uint64_t val;
     uint32_t fpr;
+    unsigned int el;
     int i;
     int ret;
=20
@@ -325,15 +345,35 @@ int kvm_arch_get_registers(CPUState *cs)
         return ret;
     }
=20
+    /* Fetch the SPSR registers
+     *
+     * KVM has an array of state indexed for all the possible aarch32
+     * privilage levels. Although not all are valid at all points
+     * there are some transitions possible which can access old state
+     * so it is worth keeping them all.
+     */
     for (i =3D 0; i < KVM_NR_SPSR; i++) {
         reg.id =3D AARCH64_CORE_REG(spsr[i]);
-        reg.addr =3D (uintptr_t) &env->banked_spsr[i - 1];
+        reg.addr =3D (uintptr_t) &env->banked_spsr[i+1];
         ret =3D kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
         if (ret) {
             return ret;
         }
     }
=20
+    el =3D arm_current_el(env);
+    if (el > 0) {
+        if (is_a64(env)) {
+            g_assert(el =3D=3D 1);
+            /* KVM maps KVM_SPSR_SVC to KVM_SPSR_EL1 for aarch64 */
+            env->banked_spsr[0] =3D env->banked_spsr[1];
+            i =3D aarch64_banked_spsr_index(el);
+        } else {
+            i =3D bank_number(env->uncached_cpsr & CPSR_M);
+        }
+        env->spsr =3D env->banked_spsr[i];
+    }
+
     /* Advanced SIMD and FP registers */
     for (i =3D 0; i < 32; i++) {
         reg.id =3D AARCH64_SIMD_CORE_REG(fp_regs.vregs[i]);
--=20
2.3.1

