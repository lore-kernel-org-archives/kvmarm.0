From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v5 5/6] target-arm: kvm64 fix save/restore of SPSR regs
Date: Mon, 23 Mar 2015 17:05:43 +0000
Message-ID: <1427130344-27986-6-git-send-email-alex.bennee@linaro.org>
References: <1427130344-27986-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427130344-27986-1-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The current code was negatively indexing the cpu state array and not
synchronizing banked spsr register state with the current mode's spsr
state, causing occasional failures with migration.

Some munging is done to take care of the aarch64 mapping and also to
ensure the most current value of the spsr is updated to the banked
registers (relevant for KVM<->TCG migration).

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

---
v2 (ajb)
  - minor tweaks and clarifications
v3
  - Use the correct bank index function for setting/getting env->spsr
  - only deal with spsrs in elevated exception levels
v4
 - try and make commentary clearer
 - ensure env->banked_spsr[0] =3D env->spsr before we sync
v5
 - fix banking index now banking fixed
 - keep wide spacing on [ ] forms
 - claimed authorship

diff --git a/target-arm/kvm64.c b/target-arm/kvm64.c
index 857e970..5270fa7 100644
--- a/target-arm/kvm64.c
+++ b/target-arm/kvm64.c
@@ -139,6 +139,7 @@ int kvm_arch_put_registers(CPUState *cs, int level)
     uint64_t val;
     int i;
     int ret;
+    unsigned int el;
=20
     ARMCPU *cpu =3D ARM_CPU(cs);
     CPUARMState *env =3D &cpu->env;
@@ -205,9 +206,24 @@ int kvm_arch_put_registers(CPUState *cs, int level=
)
         return ret;
     }
=20
+    /* Saved Program State Registers
+     *
+     * Before we restore from the banked_spsr[] array we need to
+     * ensure that any modifications to env->spsr are correctly
+     * reflected in the banks.
+     */
+    el =3D arm_current_el(env);
+    if (el > 0) {
+        i =3D is_a64(env) ?
+            aarch64_banked_spsr_index(el) :
+            bank_number(env->uncached_cpsr & CPSR_M);
+        env->banked_spsr[i] =3D env->spsr;
+    }
+
+    /* KVM 0-4 map to QEMU banks 1-5 */
     for (i =3D 0; i < KVM_NR_SPSR; i++) {
         reg.id =3D AARCH64_CORE_REG(spsr[i]);
-        reg.addr =3D (uintptr_t) &env->banked_spsr[i - 1];
+        reg.addr =3D (uintptr_t) &env->banked_spsr[i + 1];
         ret =3D kvm_vcpu_ioctl(cs, KVM_SET_ONE_REG, &reg);
         if (ret) {
             return ret;
@@ -253,11 +269,13 @@ int kvm_arch_put_registers(CPUState *cs, int leve=
l)
     return ret;
 }
=20
+
 int kvm_arch_get_registers(CPUState *cs)
 {
     struct kvm_one_reg reg;
     uint64_t val;
     uint32_t fpr;
+    unsigned int el;
     int i;
     int ret;
=20
@@ -330,15 +348,27 @@ int kvm_arch_get_registers(CPUState *cs)
         return ret;
     }
=20
+    /* Fetch the SPSR registers
+     *
+     * KVM SPSRs 0-4 map to QEMU banks 1-5
+     */
     for (i =3D 0; i < KVM_NR_SPSR; i++) {
         reg.id =3D AARCH64_CORE_REG(spsr[i]);
-        reg.addr =3D (uintptr_t) &env->banked_spsr[i - 1];
+        reg.addr =3D (uintptr_t) &env->banked_spsr[i + 1];
         ret =3D kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
         if (ret) {
             return ret;
         }
     }
=20
+    el =3D arm_current_el(env);
+    if (el > 0) {
+        i =3D is_a64(env) ?
+            aarch64_banked_spsr_index(el) :
+            bank_number(env->uncached_cpsr & CPSR_M);
+        env->spsr =3D env->banked_spsr[i];
+    }
+
     /* Advanced SIMD and FP registers
      * We map Qn =3D regs[2n+1]:regs[2n]
      */
--=20
2.3.2

