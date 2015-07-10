From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [RFC PATCH] target-arm: kvm: Differentiate registers based on
 write-back levels
Date: Fri, 10 Jul 2015 13:00:53 +0200
Message-ID: <1436526053-4516-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0A2D584DD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 06:49:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jRJO-4dHNLsA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2015 06:49:11 -0400 (EDT)
Received: from mail-lb0-f173.google.com (mail-lb0-f173.google.com
 [209.85.217.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3449584D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 06:49:11 -0400 (EDT)
Received: by lblf12 with SMTP id f12so20952634lbl.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 04:00:48 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel@nongnu.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Jan Kiszka <jan.kiszka@web.de>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Some registers like the CNTVCT register should only be written to the
kernel as part of machine initialization or on vmload operations, but
never during runtime, as this can potentially make time go backwards or
create inconsistent time observations between VCPUs.

Introduce a list of registers that should not be written back at runtime
and check this list on syncing the register state to the KVM state.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 target-arm/kvm.c     | 34 +++++++++++++++++++++++++++++++++-
 target-arm/kvm32.c   |  2 +-
 target-arm/kvm64.c   |  2 +-
 target-arm/kvm_arm.h |  3 ++-
 target-arm/machine.c |  2 +-
 5 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/target-arm/kvm.c b/target-arm/kvm.c
index 548bfd7..2e92699 100644
--- a/target-arm/kvm.c
+++ b/target-arm/kvm.c
@@ -409,7 +409,35 @@ bool write_kvmstate_to_list(ARMCPU *cpu)
     return ok;
 }
 
-bool write_list_to_kvmstate(ARMCPU *cpu)
+typedef struct cpreg_state_level {
+    uint64_t kvm_idx;
+    int level;
+} cpreg_state_level;
+
+/* All system registers not listed in the following table are assumed to be
+ * of the level KVM_PUT_RUNTIME_STATE, a register should be written less
+ * often, you must add it to this table with a state of either
+ * KVM_PUT_RESET_STATE or KVM_PUT_FULL_STATE.
+ */
+cpreg_state_level non_runtime_cpregs[] = {
+    { KVM_REG_ARM_TIMER_CNT, KVM_PUT_FULL_STATE },
+};
+
+static int cpreg_level(uint64_t kvm_idx)
+{
+    int i;
+
+    for (i = 0; i < ARRAY_SIZE(non_runtime_cpregs); i++) {
+        cpreg_state_level *l = &non_runtime_cpregs[i];
+        if (l->kvm_idx == kvm_idx) {
+            return l->level;
+        }
+    }
+
+    return KVM_PUT_RUNTIME_STATE;
+}
+
+bool write_list_to_kvmstate(ARMCPU *cpu, int level)
 {
     CPUState *cs = CPU(cpu);
     int i;
@@ -421,6 +449,10 @@ bool write_list_to_kvmstate(ARMCPU *cpu)
         uint32_t v32;
         int ret;
 
+        if (cpreg_level(regidx) > level) {
+            continue;
+        }
+
         r.id = regidx;
         switch (regidx & KVM_REG_SIZE_MASK) {
         case KVM_REG_SIZE_U32:
diff --git a/target-arm/kvm32.c b/target-arm/kvm32.c
index d7e7d68..9fbd5fd 100644
--- a/target-arm/kvm32.c
+++ b/target-arm/kvm32.c
@@ -367,7 +367,7 @@ int kvm_arch_put_registers(CPUState *cs, int level)
      * managed to update the CPUARMState with, and only allowing those
      * to be written back up into the kernel).
      */
-    if (!write_list_to_kvmstate(cpu)) {
+    if (!write_list_to_kvmstate(cpu, level)) {
         return EINVAL;
     }
 
diff --git a/target-arm/kvm64.c b/target-arm/kvm64.c
index ac34f51..2911679 100644
--- a/target-arm/kvm64.c
+++ b/target-arm/kvm64.c
@@ -280,7 +280,7 @@ int kvm_arch_put_registers(CPUState *cs, int level)
         return ret;
     }
 
-    if (!write_list_to_kvmstate(cpu)) {
+    if (!write_list_to_kvmstate(cpu, level)) {
         return EINVAL;
     }
 
diff --git a/target-arm/kvm_arm.h b/target-arm/kvm_arm.h
index 5abd591..ce03e97 100644
--- a/target-arm/kvm_arm.h
+++ b/target-arm/kvm_arm.h
@@ -71,6 +71,7 @@ bool kvm_arm_reg_syncs_via_cpreg_list(uint64_t regidx);
 /**
  * write_list_to_kvmstate:
  * @cpu: ARMCPU
+ * @level: the state level to sync
  *
  * For each register listed in the ARMCPU cpreg_indexes list, write
  * its value from the cpreg_values list into the kernel (via ioctl).
@@ -83,7 +84,7 @@ bool kvm_arm_reg_syncs_via_cpreg_list(uint64_t regidx);
  * Note that we do not stop early on failure -- we will attempt
  * writing all registers in the list.
  */
-bool write_list_to_kvmstate(ARMCPU *cpu);
+bool write_list_to_kvmstate(ARMCPU *cpu, int level);
 
 /**
  * write_kvmstate_to_list:
diff --git a/target-arm/machine.c b/target-arm/machine.c
index 9eb51df..32adfe7 100644
--- a/target-arm/machine.c
+++ b/target-arm/machine.c
@@ -251,7 +251,7 @@ static int cpu_post_load(void *opaque, int version_id)
     }
 
     if (kvm_enabled()) {
-        if (!write_list_to_kvmstate(cpu)) {
+        if (!write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE)) {
             return -1;
         }
         /* Note that it's OK for the TCG side not to know about
-- 
2.1.2.330.g565301e.dirty
