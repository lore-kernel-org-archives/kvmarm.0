From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2] target-arm: kvm: Differentiate registers based on
 write-back levels
Date: Thu, 16 Jul 2015 13:34:48 +0200
Message-ID: <1437046488-10773-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C738A58A57
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jul 2015 07:22:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NQzMN3p7yRqX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jul 2015 07:22:41 -0400 (EDT)
Received: from mail-la0-f44.google.com (mail-la0-f44.google.com
 [209.85.215.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9176E58A4F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jul 2015 07:22:41 -0400 (EDT)
Received: by laem6 with SMTP id m6so41693064lae.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jul 2015 04:34:33 -0700 (PDT)
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
Changes since RFC:
 - Move cpreg_level to kvm_arm_cpreg_level and into kvm32.c and kvm64.c
 - Changed struct name and declare as static const

 dtc                  |  2 +-
 target-arm/kvm.c     |  6 +++++-
 target-arm/kvm32.c   | 30 +++++++++++++++++++++++++++++-
 target-arm/kvm64.c   | 30 +++++++++++++++++++++++++++++-
 target-arm/kvm_arm.h | 12 +++++++++++-
 target-arm/machine.c |  2 +-
 6 files changed, 76 insertions(+), 6 deletions(-)

diff --git a/dtc b/dtc
index 65cc4d2..bc895d6 160000
--- a/dtc
+++ b/dtc
@@ -1 +1 @@
-Subproject commit 65cc4d2748a2c2e6f27f1cf39e07a5dbabd80ebf
+Subproject commit bc895d6d09695d05ceb8b52486ffe861d6cfbdde
diff --git a/target-arm/kvm.c b/target-arm/kvm.c
index 548bfd7..b278542 100644
--- a/target-arm/kvm.c
+++ b/target-arm/kvm.c
@@ -409,7 +409,7 @@ bool write_kvmstate_to_list(ARMCPU *cpu)
     return ok;
 }
 
-bool write_list_to_kvmstate(ARMCPU *cpu)
+bool write_list_to_kvmstate(ARMCPU *cpu, int level)
 {
     CPUState *cs = CPU(cpu);
     int i;
@@ -421,6 +421,10 @@ bool write_list_to_kvmstate(ARMCPU *cpu)
         uint32_t v32;
         int ret;
 
+        if (kvm_arm_cpreg_level(regidx) > level) {
+            continue;
+        }
+
         r.id = regidx;
         switch (regidx & KVM_REG_SIZE_MASK) {
         case KVM_REG_SIZE_U32:
diff --git a/target-arm/kvm32.c b/target-arm/kvm32.c
index d7e7d68..6769815 100644
--- a/target-arm/kvm32.c
+++ b/target-arm/kvm32.c
@@ -153,6 +153,34 @@ bool kvm_arm_reg_syncs_via_cpreg_list(uint64_t regidx)
     }
 }
 
+typedef struct CPRegStateLevel {
+    uint64_t regidx;
+    int level;
+} CPRegStateLevel;
+
+/* All coprocessor registers not listed in the following table are assumed to
+ * be of the level KVM_PUT_RUNTIME_STATE, a register should be written less
+ * often, you must add it to this table with a state of either
+ * KVM_PUT_RESET_STATE or KVM_PUT_FULL_STATE.
+ */
+static const CPRegStateLevel non_runtime_cpregs[] = {
+    { KVM_REG_ARM_TIMER_CNT, KVM_PUT_FULL_STATE },
+};
+
+int kvm_arm_cpreg_level(uint64_t regidx)
+{
+    int i;
+
+    for (i = 0; i < ARRAY_SIZE(non_runtime_cpregs); i++) {
+        const CPRegStateLevel *l = &non_runtime_cpregs[i];
+        if (l->regidx == regidx) {
+            return l->level;
+        }
+    }
+
+    return KVM_PUT_RUNTIME_STATE;
+}
+
 #define ARM_MPIDR_HWID_BITMASK 0xFFFFFF
 #define ARM_CPU_ID_MPIDR       0, 0, 0, 5
 
@@ -367,7 +395,7 @@ int kvm_arch_put_registers(CPUState *cs, int level)
      * managed to update the CPUARMState with, and only allowing those
      * to be written back up into the kernel).
      */
-    if (!write_list_to_kvmstate(cpu)) {
+    if (!write_list_to_kvmstate(cpu, level)) {
         return EINVAL;
     }
 
diff --git a/target-arm/kvm64.c b/target-arm/kvm64.c
index ac34f51..d59f41c 100644
--- a/target-arm/kvm64.c
+++ b/target-arm/kvm64.c
@@ -139,6 +139,34 @@ bool kvm_arm_reg_syncs_via_cpreg_list(uint64_t regidx)
     }
 }
 
+typedef struct CPRegStateLevel {
+    uint64_t regidx;
+    int level;
+} CPRegStateLevel;
+
+/* All system not listed in the following table are assumed to be of the level
+ * KVM_PUT_RUNTIME_STATE, a register should be written less often, you must
+ * add it to this table with a state of either KVM_PUT_RESET_STATE or
+ * KVM_PUT_FULL_STATE.
+ */
+static const CPRegStateLevel non_runtime_cpregs[] = {
+    { KVM_REG_ARM_TIMER_CNT, KVM_PUT_FULL_STATE },
+};
+
+int kvm_arm_cpreg_level(uint64_t regidx)
+{
+    int i;
+
+    for (i = 0; i < ARRAY_SIZE(non_runtime_cpregs); i++) {
+        const CPRegStateLevel *l = &non_runtime_cpregs[i];
+        if (l->regidx == regidx) {
+            return l->level;
+        }
+    }
+
+    return KVM_PUT_RUNTIME_STATE;
+}
+
 #define AARCH64_CORE_REG(x)   (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
                  KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
 
@@ -280,7 +308,7 @@ int kvm_arch_put_registers(CPUState *cs, int level)
         return ret;
     }
 
-    if (!write_list_to_kvmstate(cpu)) {
+    if (!write_list_to_kvmstate(cpu, level)) {
         return EINVAL;
     }
 
diff --git a/target-arm/kvm_arm.h b/target-arm/kvm_arm.h
index 5abd591..7912d74 100644
--- a/target-arm/kvm_arm.h
+++ b/target-arm/kvm_arm.h
@@ -69,8 +69,18 @@ int kvm_arm_init_cpreg_list(ARMCPU *cpu);
 bool kvm_arm_reg_syncs_via_cpreg_list(uint64_t regidx);
 
 /**
+ * kvm_arm_cpreg_level
+ * regidx: KVM register index
+ *
+ * Return the level of this coprocessor/system register.  Return value is
+ * either KVM_PUT_RUNTIME_STATE, KVM_PUT_RESET_STATE, or KVM_PUT_FULL_STATE.
+ */
+int kvm_arm_cpreg_level(uint64_t regidx);
+
+/**
  * write_list_to_kvmstate:
  * @cpu: ARMCPU
+ * @level: the state level to sync
  *
  * For each register listed in the ARMCPU cpreg_indexes list, write
  * its value from the cpreg_values list into the kernel (via ioctl).
@@ -83,7 +93,7 @@ bool kvm_arm_reg_syncs_via_cpreg_list(uint64_t regidx);
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
