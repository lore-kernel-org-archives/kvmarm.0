From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 4/6] target-arm: kvm64 sync FP register state
Date: Wed,  4 Mar 2015 14:35:51 +0000
Message-ID: <1425479753-18349-5-git-send-email-alex.bennee@linaro.org>
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

=46or migration to work we need to sync all of the register state. This=
 is
especially noticeable when GCC starts using FP registers as spill
registers even with integer programs.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

diff --git a/target-arm/kvm64.c b/target-arm/kvm64.c
index 8cf3a62..c60e989 100644
--- a/target-arm/kvm64.c
+++ b/target-arm/kvm64.c
@@ -126,9 +126,17 @@ bool kvm_arm_reg_syncs_via_cpreg_list(uint64_t reg=
idx)
 #define AARCH64_CORE_REG(x)   (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
                  KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
=20
+/* The linux headers don't define a 128 bit wide SIMD macro for us */
+#define AARCH64_SIMD_CORE_REG(x)   (KVM_REG_ARM64 | KVM_REG_SIZE_U128 =
| \
+                 KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
+
+#define AARCH64_SIMD_CTRL_REG(x)   (KVM_REG_ARM64 | KVM_REG_SIZE_U32 |=
 \
+                 KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
+
 int kvm_arch_put_registers(CPUState *cs, int level)
 {
     struct kvm_one_reg reg;
+    uint32_t fpr;
     uint64_t val;
     int i;
     int ret;
@@ -207,13 +215,36 @@ int kvm_arch_put_registers(CPUState *cs, int leve=
l)
         }
     }
=20
+    /* Advanced SIMD and FP registers */
+    for (i =3D 0; i < 32; i++) {
+        reg.id =3D AARCH64_SIMD_CORE_REG(fp_regs.vregs[i]);
+        reg.addr =3D (uintptr_t)(&env->vfp.regs[i]);
+        ret =3D kvm_vcpu_ioctl(cs, KVM_SET_ONE_REG, &reg);
+        if (ret) {
+            return ret;
+        }
+        reg.id++;
+    }
+
+    reg.addr =3D (uintptr_t)(&fpr);
+    fpr =3D vfp_get_fpsr(env);
+    reg.id =3D AARCH64_SIMD_CTRL_REG(fp_regs.fpsr);
+    ret =3D kvm_vcpu_ioctl(cs, KVM_SET_ONE_REG, &reg);
+    if (ret) {
+        return ret;
+    }
+
+    fpr =3D vfp_get_fpcr(env);
+    reg.id =3D AARCH64_SIMD_CTRL_REG(fp_regs.fpcr);
+    ret =3D kvm_vcpu_ioctl(cs, KVM_SET_ONE_REG, &reg);
+    if (ret) {
+        return ret;
+    }
+
     if (!write_list_to_kvmstate(cpu)) {
         return EINVAL;
     }
=20
-    /* TODO:
-     * FP state
-     */
     return ret;
 }
=20
@@ -221,6 +252,7 @@ int kvm_arch_get_registers(CPUState *cs)
 {
     struct kvm_one_reg reg;
     uint64_t val;
+    uint32_t fpr;
     int i;
     int ret;
=20
@@ -302,9 +334,36 @@ int kvm_arch_get_registers(CPUState *cs)
         }
     }
=20
+    /* Advanced SIMD and FP registers */
+    for (i =3D 0; i < 32; i++) {
+        reg.id =3D AARCH64_SIMD_CORE_REG(fp_regs.vregs[i]);
+        reg.addr =3D (uintptr_t)(&env->vfp.regs[i]);
+        ret =3D kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
+        if (ret) {
+            return ret;
+        }
+        reg.id++;
+    }
+
+    reg.addr =3D (uintptr_t)(&fpr);
+    reg.id =3D AARCH64_SIMD_CTRL_REG(fp_regs.fpsr);
+    ret =3D kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
+    if (ret) {
+        return ret;
+    }
+    vfp_set_fpsr(env, fpr);
+
+    reg.id =3D AARCH64_SIMD_CTRL_REG(fp_regs.fpcr);
+    ret =3D kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
+    if (ret) {
+        return ret;
+    }
+    vfp_set_fpcr(env, fpr);
+
     if (!write_kvmstate_to_list(cpu)) {
         return EINVAL;
     }
+
     /* Note that it's OK to have registers which aren't in CPUState,
      * so we can ignore a failure return here.
      */
--=20
2.3.1

