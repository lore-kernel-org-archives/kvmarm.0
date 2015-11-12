From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v9 3/6] target-arm: kvm - support for single step
Date: Thu, 12 Nov 2015 16:20:48 +0000
Message-ID: <1447345251-22625-4-git-send-email-alex.bennee@linaro.org>
References: <1447345251-22625-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1447345251-22625-1-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, peter.maydell@linaro.org, christoffer.dall@linaro.org, zhichao.huang@linaro.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

This adds support for single-step. There isn't much to do on the QEMU
side as after we set-up the request for single step via the debug ioctl
it is all handled within the kernel.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

---
v2
  - convert to using HSR_EC
v3
  - use internals.h definitions
---
 target-arm/kvm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/target-arm/kvm.c b/target-arm/kvm.c
index 50f70ef..d505a7e 100644
--- a/target-arm/kvm.c
+++ b/target-arm/kvm.c
@@ -535,6 +535,13 @@ static int kvm_handle_debug(CPUState *cs, struct k=
vm_run *run)
     kvm_cpu_synchronize_state(cs);
=20
     switch (hsr_ec) {
+    case EC_SOFTWARESTEP:
+        if (cs->singlestep_enabled) {
+            return true;
+        } else {
+            error_report("Came out of SINGLE STEP when not enabled");
+        }
+        break;
     case EC_AA64_BKPT:
         if (kvm_find_sw_breakpoint(cs, env->pc)) {
             return true;
@@ -595,6 +602,9 @@ int kvm_arch_on_sigbus(int code, void *addr)
=20
 void kvm_arch_update_guest_debug(CPUState *cs, struct kvm_guest_debug =
*dbg)
 {
+    if (cs->singlestep_enabled) {
+        dbg->control |=3D KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_SINGLESTE=
P;
+    }
     if (kvm_sw_breakpoints_active(cs)) {
         dbg->control |=3D KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP=
;
     }
--=20
2.6.3

