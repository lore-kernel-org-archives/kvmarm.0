From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v3 3/4] target-arm: kvm64: handle SIGBUS signal for
 synchronous External Abort
Date: Sun, 30 Apr 2017 13:35:05 +0800
Message-ID: <1493530506-26833-3-git-send-email-gengdongjiu@huawei.com>
References: <1493530506-26833-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 996254122C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Apr 2017 01:25:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id igbDu3541e0N for <kvmarm@lists.cs.columbia.edu>;
 Sun, 30 Apr 2017 01:25:17 -0400 (EDT)
Received: from dggrg01-dlp.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6117D40F8A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Apr 2017 01:25:15 -0400 (EDT)
In-Reply-To: <1493530506-26833-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: james.morse@arm.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, rkrcmar@redhat.com, linux@armlinux.org.uk, tbaicar@codeaurora.org, imammedo@redhat.com, zhaoshenglong@huawei.com, peter.maydell@linaro.org, pbonzini@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, lersek@redhat.com, ard.biesheuvel@linaro.org, mtsirkin@redhat.com, drjones@redhat.com, ben@skyportsystems.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: songwenjun@huawei.com, wuquanming@huawei.com, gengdongjiu@huawei.com, huangshaoyu@huawei.com, wangxiongfeng2@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

If RAS extension feature exists, when guest OS happen synchronous
External Abort, a SIGBUS signal will be delivered from the kvm.
so handle this signal, generate GHES record and inject this
abort to notify guest. then guest can handle this abort

The Synchronous External Abort mainly includes below two types:
1. Error on memory access, such as hwpoison. the SIGBUS si_code is
   BUS_MCEERR_AR or BUS_MCEERR_OR
2. Error on translation table walk or hardware update of translation table.
   The SIGBUS si_code is 0

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 include/sysemu/kvm.h      |  2 +-
 linux-headers/linux/kvm.h |  3 +++
 target/arm/kvm.c          | 34 +++++++++++++++++++++++++++
 target/arm/kvm64.c        | 60 +++++++++++++++++++++++++++++++++++++++++++++++
 target/arm/kvm_arm.h      |  1 +
 5 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 24281fc..feef990 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -354,7 +354,7 @@ bool kvm_vcpu_id_is_valid(int vcpu_id);
 /* Returns VCPU ID to be used on KVM_CREATE_VCPU ioctl() */
 unsigned long kvm_arch_vcpu_id(CPUState *cpu);
 
-#ifdef TARGET_I386
+#if defined(TARGET_I386) || defined(TARGET_AARCH64)
 #define KVM_HAVE_MCE_INJECTION 1
 void kvm_arch_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
 #endif
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index e0fa5b8..c985e10 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1301,6 +1301,9 @@ struct kvm_s390_ucas_mapping {
 #define KVM_S390_GET_IRQ_STATE	  _IOW(KVMIO, 0xb6, struct kvm_s390_irq_state)
 /* Available with KVM_CAP_X86_SMM */
 #define KVM_SMI                   _IO(KVMIO,   0xb7)
+/* Available with KVM_CAP_ARM_RAS_EXTENSION */
+#define KVM_ARM_SEA                 _IO(KVMIO,   0xb8)
+
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 4555468..bf6ee4c 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -129,6 +129,39 @@ void kvm_arm_destroy_scratch_host_vcpu(int *fdarray)
     }
 }
 
+typedef struct HWPoisonPage {
+    ram_addr_t ram_addr;
+    QLIST_ENTRY(HWPoisonPage) list;
+} HWPoisonPage;
+
+static QLIST_HEAD(, HWPoisonPage) hwpoison_page_list =
+    QLIST_HEAD_INITIALIZER(hwpoison_page_list);
+
+static void kvm_unpoison_all(void *param)
+{
+    HWPoisonPage *page, *next_page;
+
+    QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
+        QLIST_REMOVE(page, list);
+        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
+        g_free(page);
+    }
+}
+
+void kvm_hwpoison_page_add(ram_addr_t ram_addr)
+{
+    HWPoisonPage *page;
+
+    QLIST_FOREACH(page, &hwpoison_page_list, list) {
+        if (page->ram_addr == ram_addr) {
+            return;
+        }
+    }
+    page = g_new(HWPoisonPage, 1);
+    page->ram_addr = ram_addr;
+    QLIST_INSERT_HEAD(&hwpoison_page_list, page, list);
+}
+
 static void kvm_arm_host_cpu_class_init(ObjectClass *oc, void *data)
 {
     ARMHostCPUClass *ahcc = ARM_HOST_CPU_CLASS(oc);
@@ -176,6 +209,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
 
     cap_has_mp_state = kvm_check_extension(s, KVM_CAP_MP_STATE);
 
+    qemu_register_reset(kvm_unpoison_all, NULL);
     type_register_static(&host_arm_cpu_type_info);
 
     return 0;
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index fd30a5a..5eee6f4 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -27,6 +27,8 @@
 #include "kvm_arm.h"
 #include "internals.h"
 #include "hw/arm/arm.h"
+#include "hw/acpi/acpi-defs.h"
+#include "hw/acpi/hest_ghes.h"
 
 static bool have_guest_debug;
 
@@ -590,6 +592,21 @@ int kvm_arm_cpreg_level(uint64_t regidx)
     return KVM_PUT_RUNTIME_STATE;
 }
 
+static int kvm_inject_arm_sea(ARMCPU *cpu)
+{
+    CPUState *cs = CPU(cpu);
+    if (cs->exception_index == EXCP_DATA_ABORT) {
+        cs->exception_index = -1;
+        /* Here use a new ioctl KVM_ARM_SEA instead of KVM_SET_ONE_REG,
+         * Becuase kernel has direct injection interface, so simplify
+         * the logic to use kernel interface
+         */
+        return  kvm_vcpu_ioctl(CPU(cpu), KVM_ARM_SEA);
+    }
+
+    return 0;
+}
+
 #define AARCH64_CORE_REG(x)   (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
                  KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
 
@@ -735,6 +752,13 @@ int kvm_arch_put_registers(CPUState *cs, int level)
         return EINVAL;
     }
 
+    if (arm_feature(env, ARM_FEATURE_RAS_EXTENSION)) {
+        ret = kvm_inject_arm_sea(cpu);
+        if (ret < 0) {
+            return ret;
+        }
+    }
+
     kvm_arm_sync_mpstate_to_kvm(cpu);
 
     return ret;
@@ -887,6 +911,42 @@ int kvm_arch_get_registers(CPUState *cs)
     return ret;
 }
 
+void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
+{
+    ARMCPU *cpu = ARM_CPU(c);
+    CPUARMState *env = &cpu->env;
+
+    ram_addr_t ram_addr;
+    hwaddr paddr;
+
+    if (arm_feature(env, ARM_FEATURE_RAS_EXTENSION) && addr) {
+        ram_addr = qemu_ram_addr_from_host(addr);
+        if (ram_addr != RAM_ADDR_INVALID &&
+            kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
+            /* For the hardware error, some are hwpoison errors, some
+             * are other errors, such as translation table walk or hardware
+             * update of translation table. For the hwpoison, the si_code
+             * is BUS_MCEERR_AR or BUS_MCEERR_AO, other errors are 0
+             */
+            if (code == BUS_MCEERR_AR || code == BUS_MCEERR_AO) {
+                kvm_hwpoison_page_add(ram_addr);
+            }
+            ghes_update_guest(ACPI_HEST_NOTIFY_SEA, paddr);
+            c->exception_index = EXCP_DATA_ABORT;
+            kvm_cpu_synchronize_state(c);
+            return;
+        }
+
+        fprintf(stderr, "Hardware memory error for memory used by "
+                "QEMU itself instead of guest system!\n");
+    }
+
+    if (code == BUS_MCEERR_AR) {
+        fprintf(stderr, "Hardware memory error!\n");
+        exit(1);
+    }
+}
+
 /* C6.6.29 BRK instruction */
 static const uint32_t brk_insn = 0xd4200000;
 
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 633d088..7cdde97 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -288,4 +288,5 @@ static inline const char *its_class_name(void)
     }
 }
 
+void kvm_hwpoison_page_add(ram_addr_t ram_addr);
 #endif
-- 
1.8.3.1
