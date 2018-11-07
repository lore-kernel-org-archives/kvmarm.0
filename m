From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [RFC QEMU 1/2] arm/virt: Initialize generic timer scale factor
 dynamically
Date: Tue,  6 Nov 2018 16:32:28 -0800
Message-ID: <1541550749-62397-2-git-send-email-bijan.mottahedeh@oracle.com>
References: <1541550749-62397-1-git-send-email-bijan.mottahedeh@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE7F54A332
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Nov 2018 19:32:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FheMaGwSCCoy for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Nov 2018 19:32:45 -0500 (EST)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F7034A30E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Nov 2018 19:32:45 -0500 (EST)
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
 by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA70TRev008131
 for <kvmarm@lists.cs.columbia.edu>; Wed, 7 Nov 2018 00:32:44 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
 by userp2120.oracle.com with ESMTP id 2nh4aqrhdv-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Nov 2018 00:32:44 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
 by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wA70WinI027013
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
 for <kvmarm@lists.cs.columbia.edu>; Wed, 7 Nov 2018 00:32:44 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
 by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wA70WhQs003335
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

Initialize the generic timer scale factor based on the counter frequency
register cntfrq_el0, and default to the current static value if necessary.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 hw/arm/virt.c          | 15 +++++++++++++++
 target/arm/helper.c    | 19 ++++++++++++++++---
 target/arm/internals.h |  8 ++++++--
 target/arm/kvm64.c     |  1 +
 4 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 281ddcd..200a601 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -59,6 +59,7 @@
 #include "qapi/visitor.h"
 #include "standard-headers/linux/input.h"
 #include "hw/arm/smmuv3.h"
+#include "target/arm/internals.h"
 
 #define DEFINE_VIRT_MACHINE_LATEST(major, minor, latest) \
     static void virt_##major##_##minor##_class_init(ObjectClass *oc, \
@@ -1710,6 +1711,19 @@ static HotplugHandler *virt_machine_get_hotplug_handler(MachineState *machine,
     return NULL;
 }
 
+static void set_system_clock_scale(void)
+{
+    unsigned long cntfrq_el0;
+
+    asm volatile("mrs %0, cntfrq_el0" : "=r"(cntfrq_el0));
+
+    if (cntfrq_el0 == 0) {
+        cntfrq_el0 = GTIMER_SCALE_DEF;
+    }
+
+    system_clock_scale = NANOSECONDS_PER_SECOND / (int)cntfrq_el0;
+}
+
 static void virt_machine_class_init(ObjectClass *oc, void *data)
 {
     MachineClass *mc = MACHINE_CLASS(oc);
@@ -1736,6 +1750,7 @@ static void virt_machine_class_init(ObjectClass *oc, void *data)
     assert(!mc->get_hotplug_handler);
     mc->get_hotplug_handler = virt_machine_get_hotplug_handler;
     hc->plug = virt_machine_device_plug_cb;
+    set_system_clock_scale();
 }
 
 static const TypeInfo virt_machine_info = {
diff --git a/target/arm/helper.c b/target/arm/helper.c
index 66afb08..6330586 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -18,6 +18,7 @@
 #include "sysemu/kvm.h"
 #include "fpu/softfloat.h"
 #include "qemu/range.h"
+#include "hw/arm/arm.h"
 
 #define ARM_CPU_FREQ 1000000000 /* FIXME: 1 GHz, should be configurable */
 
@@ -1614,6 +1615,18 @@ static CPAccessResult gt_cntfrq_access(CPUARMState *env, const ARMCPRegInfo *ri,
     return CP_ACCESS_OK;
 }
 
+static void gt_cntfrq_reset(CPUARMState *env, const ARMCPRegInfo *ri)
+{
+    assert(GTIMER_SCALE);
+    assert(ri->fieldoffset);
+
+    if (cpreg_field_is_64bit(ri)) {
+        CPREG_FIELD64(env, ri) = NANOSECONDS_PER_SECOND / GTIMER_SCALE;
+    } else {
+        CPREG_FIELD32(env, ri) = NANOSECONDS_PER_SECOND / GTIMER_SCALE;
+    }
+}
+
 static CPAccessResult gt_counter_access(CPUARMState *env, int timeridx,
                                         bool isread)
 {
@@ -1709,7 +1722,7 @@ static CPAccessResult gt_stimer_access(CPUARMState *env,
     }
 }
 
-static uint64_t gt_get_countervalue(CPUARMState *env)
+uint64_t gt_get_countervalue(CPUARMState *env)
 {
     return qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL) / GTIMER_SCALE;
 }
@@ -1996,7 +2009,7 @@ static const ARMCPRegInfo generic_timer_cp_reginfo[] = {
       .opc0 = 3, .opc1 = 3, .crn = 14, .crm = 0, .opc2 = 0,
       .access = PL1_RW | PL0_R, .accessfn = gt_cntfrq_access,
       .fieldoffset = offsetof(CPUARMState, cp15.c14_cntfrq),
-      .resetvalue = (1000 * 1000 * 1000) / GTIMER_SCALE,
+      .resetfn = gt_cntfrq_reset,
     },
     /* overall control: mostly access permissions */
     { .name = "CNTKCTL", .state = ARM_CP_STATE_BOTH,
@@ -2187,7 +2200,7 @@ static const ARMCPRegInfo generic_timer_cp_reginfo[] = {
       .opc0 = 3, .opc1 = 3, .crn = 14, .crm = 0, .opc2 = 0,
       .type = ARM_CP_CONST, .access = PL0_R /* no PL1_RW in linux-user */,
       .fieldoffset = offsetof(CPUARMState, cp15.c14_cntfrq),
-      .resetvalue = NANOSECONDS_PER_SECOND / GTIMER_SCALE,
+      .resetfn = gt_cntfrq_reset,
     },
     { .name = "CNTVCT_EL0", .state = ARM_CP_STATE_AA64,
       .opc0 = 3, .opc1 = 3, .crn = 14, .crm = 0, .opc2 = 2,
diff --git a/target/arm/internals.h b/target/arm/internals.h
index dc93577..b66a1fa 100644
--- a/target/arm/internals.h
+++ b/target/arm/internals.h
@@ -52,9 +52,13 @@ static inline bool excp_is_internal(int excp)
 }
 
 /* Scale factor for generic timers, ie number of ns per tick.
- * This gives a 62.5MHz timer.
+ * Calculated dynamically based on CNTFRQ with a default value
+ * that gives a 62.5MHZ timer.
  */
-#define GTIMER_SCALE 16
+#define GTIMER_SCALE        system_clock_scale
+#define GTIMER_SCALE_DEF    16
+
+uint64_t gt_get_countervalue(CPUARMState *);
 
 /* Bit definitions for the v7M CONTROL register */
 FIELD(V7M_CONTROL, NPRIV, 0, 1)
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index e0b8246..5d1c394 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -485,6 +485,7 @@ bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     set_feature(&features, ARM_FEATURE_NEON);
     set_feature(&features, ARM_FEATURE_AARCH64);
     set_feature(&features, ARM_FEATURE_PMU);
+    set_feature(&features, ARM_FEATURE_GENERIC_TIMER);
 
     ahcf->features = features;
 
-- 
1.8.3.1
