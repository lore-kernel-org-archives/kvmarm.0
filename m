From: Tushar Jagad <tushar.jagad@linaro.org>
Subject: [PATCH RFC 3/3] arm64: pass breakpoint/watchpoint info for target cpu
Date: Wed,  9 Sep 2015 08:42:12 +0000
Message-ID: <1441788132-6286-4-git-send-email-tushar.jagad@linaro.org>
References: <1441788132-6286-1-git-send-email-tushar.jagad@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EA5C41145
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2015 04:42:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JqYAQm+7KUh9 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2015 04:42:02 -0400 (EDT)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com
 [209.85.220.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53A0D41022
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2015 04:42:02 -0400 (EDT)
Received: by padhk3 with SMTP id hk3so3865070pad.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Sep 2015 01:42:41 -0700 (PDT)
In-Reply-To: <1441788132-6286-1-git-send-email-tushar.jagad@linaro.org>
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
Cc: marc.zyngier@arm.com, patches@apm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds support for passing user defined hardware properties to the
host kernel for cross cpu environment.

ARM cpu has a lot of implementation specific hardware features which
differ from vendor to vendor. This pose a hurdle to run guests in a cross
cpu type environment (for example: running cortex-a57 guests on x-gene and
vice-versa).

The implementation specific hardware properties like number of hardware
breakpoints, watchpoints, etc needs to be defined for guest for the Cross CPU
execution. This is specifically useful in an environment where a mix of
hardware platforms are available and the guest cpu needs to be different
from the host cpu.

Qemu passes this information to the host kernel which reflects these
properties accordingly in the guest vcpu.

Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
---
 hw/arm/virt.c        | 23 ++++++++++++++++++++++-
 target-arm/cpu-qom.h |  6 ++++++
 target-arm/kvm64.c   |  8 ++++++++
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 4846892..23ca35f 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -828,6 +828,8 @@ static void machvirt_init(MachineState *machine)
         ObjectClass *oc = cpu_class_by_name(TYPE_ARM_CPU, cpustr[0]);
         CPUClass *cc = CPU_CLASS(oc);
         Object *cpuobj;
+        CPUState *cs;
+        ARMCPU *cpu;
         Error *err = NULL;
         char *cpuopts = g_strdup(cpustr[1]);
 
@@ -837,8 +839,11 @@ static void machvirt_init(MachineState *machine)
         }
         cpuobj = object_new(object_class_get_name(oc));
 
+        cs = CPU(cpuobj);
+        cpu = ARM_CPU(cs);
+
         /* Handle any CPU options specified by the user */
-        cc->parse_features(CPU(cpuobj), cpuopts, &err);
+        cc->parse_features(cs, cpuopts, &err);
         g_free(cpuopts);
         if (err) {
             error_report_err(err);
@@ -863,6 +868,22 @@ static void machvirt_init(MachineState *machine)
         }
 
         object_property_set_bool(cpuobj, true, "realized", NULL);
+
+        if (object_property_find(cpuobj, "bpts", NULL)) {
+            cpu->bpts = object_property_get_int(cpuobj, "bpts", &error_abort);
+            if (cpu->bpts && cpu->bpts < 2) {
+                printf("Minimum number of breakpoints > 2\n");
+                exit(1);
+            }
+        }
+
+        if (object_property_find(cpuobj, "wpts", NULL)) {
+            cpu->wpts = object_property_get_int(cpuobj, "wpts", &error_abort);
+            if (cpu->wpts && cpu->wpts < 2) {
+                printf("Minimum number of watchpoints > 2\n");
+                exit(1);
+            }
+        }
     }
     g_strfreev(cpustr);
     fdt_add_timer_nodes(vbi);
diff --git a/target-arm/cpu-qom.h b/target-arm/cpu-qom.h
index 3cbc4a0..aceaaab 100644
--- a/target-arm/cpu-qom.h
+++ b/target-arm/cpu-qom.h
@@ -121,6 +121,12 @@ typedef struct ARMCPU {
     /* KVM init features for this CPU */
     uint32_t kvm_init_features[7];
 
+    /* Number of h/w breakpoints supported by the guest */
+    uint32_t bpts;
+
+    /* Number of h/w watchpoints supported by the guest */
+    uint32_t wpts;
+
     /* Uniprocessor system with MP extensions */
     bool mp_is_up;
 
diff --git a/target-arm/kvm64.c b/target-arm/kvm64.c
index bd60889..39ff54b 100644
--- a/target-arm/kvm64.c
+++ b/target-arm/kvm64.c
@@ -105,6 +105,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_EL1_32BIT;
     }
 
+    if (cpu->bpts)
+        cpu->kvm_init_features[KVM_ARM_VCPU_BPTS_FEATURES_IDX] |=
+            (cpu->bpts << KVM_ARM_VCPU_NUM_BPTS) & KVM_ARM_VCPU_BPTS_MASK;
+
+    if (cpu->wpts)
+        cpu->kvm_init_features[KVM_ARM_VCPU_WPTS_FEATURES_IDX] |=
+            (cpu->wpts << KVM_ARM_VCPU_NUM_WPTS) & KVM_ARM_VCPU_WPTS_MASK;
+
     /* Do KVM_ARM_VCPU_INIT ioctl */
     ret = kvm_arm_vcpu_init(cs);
     if (ret) {
-- 
2.4.3
