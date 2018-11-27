From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [RFC QEMU v2 2/2] arm/virt: Account for guest pause time
Date: Tue, 27 Nov 2018 13:07:17 -0800
Message-ID: <1543352837-21529-3-git-send-email-bijan.mottahedeh@oracle.com>
References: <1543352837-21529-1-git-send-email-bijan.mottahedeh@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27F044A354
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Nov 2018 16:07:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id frtOeOPgWcPc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Nov 2018 16:07:26 -0500 (EST)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 200604A34C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Nov 2018 16:07:26 -0500 (EST)
In-Reply-To: <1543352837-21529-1-git-send-email-bijan.mottahedeh@oracle.com>
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
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Accumulate the total guest pause time and update the virtual counter
offset register accordingly in order to account for that time before
resuming the guest.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 hw/intc/arm_gicv3_kvm.c | 39 +++++++++++++++++++++++++++++++++++++++
 target/arm/cpu.h        |  3 +++
 2 files changed, 42 insertions(+)

diff --git a/hw/intc/arm_gicv3_kvm.c b/hw/intc/arm_gicv3_kvm.c
index 1e11200..aabd508 100644
--- a/hw/intc/arm_gicv3_kvm.c
+++ b/hw/intc/arm_gicv3_kvm.c
@@ -30,6 +30,7 @@
 #include "gicv3_internal.h"
 #include "vgic_common.h"
 #include "migration/blocker.h"
+#include "target/arm/internals.h"
 
 #ifdef DEBUG_GICV3_KVM
 #define DPRINTF(fmt, ...) \
@@ -745,9 +746,38 @@ static void vm_change_state_handler(void *opaque, int running,
 {
     GICv3State *s = (GICv3State *)opaque;
     Error *err = NULL;
+    CPUState *cpu;
+    CPUARMState *env;
+    struct kvm_one_reg reg;
     int ret;
+    uint64_t cnt;
 
     if (running) {
+        CPU_FOREACH(cpu) {
+
+            env = (CPUARMState *)(cpu->env_ptr);
+
+            if (!env->pause_start) {
+                continue;
+            }
+
+            /*
+             * Accumulate the total pause time and set the
+             * counter virtual offset accordingly.
+             */
+            cnt = gt_get_countervalue(env);
+            env->pause_total += (cnt - env->pause_start);
+            env->cp15.cntvoff_el2 = cnt - env->pause_total;
+
+            env->pause_start = 0;   /* clear for next pause */
+            reg.id = KVM_REG_ARM_TIMER_CNT;
+            reg.addr = (uintptr_t) &env->cp15.cntvoff_el2;
+            ret = kvm_vcpu_ioctl(cpu, KVM_SET_ONE_REG, &reg);
+            if (ret) {
+                error_report("Set virtual counter offset failed: %d", ret);
+                abort();
+            }
+        }
         return;
     }
 
@@ -760,6 +790,15 @@ static void vm_change_state_handler(void *opaque, int running,
     if (ret < 0 && ret != -EFAULT) {
         abort();
     }
+
+    CPU_FOREACH(cpu) {
+        /*
+         * Record the current pause start time.
+         */
+        env = (CPUARMState *)(cpu->env_ptr);
+        cnt = gt_get_countervalue(env);
+        env->pause_start = cnt;
+    }
 }
 
 
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index e310ffc..bd0a56e 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -602,6 +602,9 @@ typedef struct CPUARMState {
     struct CPUBreakpoint *cpu_breakpoint[16];
     struct CPUWatchpoint *cpu_watchpoint[16];
 
+    uint64_t pause_start;   /* start time of last pause */
+    uint64_t pause_total;   /* total pause time */
+
     /* Fields up to this point are cleared by a CPU reset */
     struct {} end_reset_fields;
 
-- 
1.8.3.1
