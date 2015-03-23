From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v5 4/6] target-arm: kvm64 sync FP register state
Date: Mon, 23 Mar 2015 17:05:42 +0000
Message-ID: <1427130344-27986-5-git-send-email-alex.bennee@linaro.org>
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

=46or migration to work we need to sync all of the register state. This=
 is
especially noticeable when GCC starts using FP registers as spill
registers even with integer programs.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

---

v4:
  - fixed merge conflicts
  - rm superfluous reg.id++
v5:
  - use interim float128 to deal with endianess
  - correctly map into vfp.regs[]
  - fix spacing around []s

diff --git a/target-arm/kvm64.c b/target-arm/kvm64.c
index fed03f2..857e970 100644
--- a/target-arm/kvm64.c
+++ b/target-arm/kvm64.c
@@ -126,9 +126,16 @@ bool kvm_arm_reg_syncs_via_cpreg_list(uint64_t reg=
idx)
 #define AARCH64_CORE_REG(x)   (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
                  KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
=20
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
@@ -207,15 +214,42 @@ int kvm_arch_put_registers(CPUState *cs, int leve=
l)
         }
     }
=20
+    /* Advanced SIMD and FP registers
+     * We map Qn =3D regs[2n+1]:regs[2n]
+     */
+    for (i =3D 0; i < 32; i++) {
+        int rd =3D i << 1;
+        float128 fp_val =3D make_float128(env->vfp.regs[rd + 1],
+                                        env->vfp.regs[rd]);
+        reg.id =3D AARCH64_SIMD_CORE_REG(fp_regs.vregs[i]);
+        reg.addr =3D (uintptr_t)(&fp_val);
+        ret =3D kvm_vcpu_ioctl(cs, KVM_SET_ONE_REG, &reg);
+        if (ret) {
+            return ret;
+        }
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
     kvm_arm_sync_mpstate_to_kvm(cpu);
=20
-    /* TODO:
-     * FP state
-     */
     return ret;
 }
=20
@@ -223,6 +257,7 @@ int kvm_arch_get_registers(CPUState *cs)
 {
     struct kvm_one_reg reg;
     uint64_t val;
+    uint32_t fpr;
     int i;
     int ret;
=20
@@ -304,6 +339,38 @@ int kvm_arch_get_registers(CPUState *cs)
         }
     }
=20
+    /* Advanced SIMD and FP registers
+     * We map Qn =3D regs[2n+1]:regs[2n]
+     */
+    for (i =3D 0; i < 32; i++) {
+        float128 fp_val;
+        reg.id =3D AARCH64_SIMD_CORE_REG(fp_regs.vregs[i]);
+        reg.addr =3D (uintptr_t)(&fp_val);
+        ret =3D kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
+        if (ret) {
+            return ret;
+        } else {
+            int rd =3D i << 1;
+            env->vfp.regs[rd + 1] =3D fp_val.high;
+            env->vfp.regs[rd] =3D fp_val.low;
+        }
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
--=20
2.3.2

