From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [RFC QEMU 2/2] arm/virt: Account for guest pause time
Date: Tue,  6 Nov 2018 16:32:29 -0800
Message-ID: <1541550749-62397-3-git-send-email-bijan.mottahedeh@oracle.com>
References: <1541550749-62397-1-git-send-email-bijan.mottahedeh@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 374B34A30E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Nov 2018 19:32:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PcBXX1n5pMhN for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Nov 2018 19:32:46 -0500 (EST)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EEE7C4A31E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Nov 2018 19:32:45 -0500 (EST)
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
 by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA70SdPS007050
 for <kvmarm@lists.cs.columbia.edu>; Wed, 7 Nov 2018 00:32:45 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
 by userp2120.oracle.com with ESMTP id 2nh4aqrhdw-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Nov 2018 00:32:44 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
 by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wA70WiHu003465
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
 for <kvmarm@lists.cs.columbia.edu>; Wed, 7 Nov 2018 00:32:44 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
 by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wA70WhUE002241
 for <kvmarm@lists.cs.columbia.edu>; Wed, 7 Nov 2018 00:32:44 GMT
In-Reply-To: <1541550749-62397-1-git-send-email-bijan.mottahedeh@oracle.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
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
