From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 1/6] target-arm: kvm: save/restore mp state
Date: Wed,  4 Mar 2015 14:35:48 +0000
Message-ID: <1425479753-18349-2-git-send-email-alex.bennee@linaro.org>
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

This adds the saving and restore of the current Multi-Processing state
of the machine. While the KVM_GET/SET_MP_STATE API exposes a number of
potential states for x86 we only use two for ARM. Either the process is
running or not. We then save this state into the cpu_powered TCG state
to avoid changing the serialisation format.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

---
v2
  - make mpstate field runtime dependant (kvm_enabled())
  - drop initial KVM_CAP_MP_STATE requirement
  - re-use cpu_powered instead of new field

diff --git a/target-arm/machine.c b/target-arm/machine.c
index 9446e5a..185f9a2 100644
--- a/target-arm/machine.c
+++ b/target-arm/machine.c
@@ -161,6 +161,7 @@ static const VMStateInfo vmstate_cpsr =3D {
     .put =3D put_cpsr,
 };
=20
+
 static void cpu_pre_save(void *opaque)
 {
     ARMCPU *cpu =3D opaque;
@@ -170,6 +171,20 @@ static void cpu_pre_save(void *opaque)
             /* This should never fail */
             abort();
         }
+#if defined CONFIG_KVM
+        if (kvm_check_extension(CPU(cpu)->kvm_state, KVM_CAP_MP_STATE)=
) {
+            struct kvm_mp_state mp_state;
+            int ret =3D kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MP_STATE, &mp=
_state);
+            if (ret) {
+                fprintf(stderr, "%s: failed to get MP_STATE %d/%s\n",
+                        __func__, ret, strerror(ret));
+                abort();
+            }
+            cpu->powered_off =3D
+                (mp_state.mp_state =3D=3D KVM_MP_STATE_RUNNABLE)
+                ? false : true;
+        }
+#endif
     } else {
         if (!write_cpustate_to_list(cpu)) {
             /* This should never fail. */
@@ -222,6 +237,20 @@ static int cpu_post_load(void *opaque, int version=
_id)
          * we're using it.
          */
         write_list_to_cpustate(cpu);
+#if defined CONFIG_KVM
+        if (kvm_check_extension(CPU(cpu)->kvm_state, KVM_CAP_MP_STATE)=
) {
+            struct kvm_mp_state mp_state =3D {
+                .mp_state =3D
+                cpu->powered_off ? KVM_MP_STATE_HALTED : KVM_MP_STATE_=
RUNNABLE
+            };
+            int ret =3D kvm_vcpu_ioctl(CPU(cpu), KVM_SET_MP_STATE, &mp=
_state);
+            if (ret) {
+                fprintf(stderr, "%s: failed to set MP_STATE %d/%s\n",
+                        __func__, ret, strerror(ret));
+                return -1;
+            }
+        }
+#endif
     } else {
         if (!write_list_to_cpustate(cpu)) {
             return -1;
--=20
2.3.1

