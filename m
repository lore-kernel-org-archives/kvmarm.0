From: Alexander Graf <agraf@suse.de>
Subject: [RFC 2/2] ARM: KVM: Enable in-kernel timers with user space gic
Date: Sat, 29 Oct 2016 23:10:49 +0200
Message-ID: <1477775449-115472-2-git-send-email-agraf@suse.de>
References: <1477775449-115472-1-git-send-email-agraf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF44B405BA
 for <kvmarm@lists.cs.columbia.edu>; Sat, 29 Oct 2016 17:10:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id quKC-ginK-Bu for <kvmarm@lists.cs.columbia.edu>;
 Sat, 29 Oct 2016 17:10:37 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E57D40541
 for <kvmarm@lists.cs.columbia.edu>; Sat, 29 Oct 2016 17:10:37 -0400 (EDT)
In-Reply-To: <1477775449-115472-1-git-send-email-agraf@suse.de>
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
Cc: qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

When running with KVM enabled, you can choose between emulating the
gic in kernel or user space. If the kernel supports in-kernel virtualization
of the interrupt controller, it will default to that. If not, if will
default to user space emulation.

Unfortunately when running in user mode gic emulation, we miss out on
timer events which are only available from kernel space. This patch leverages
the new kernel/user space pending line synchronization for those timer events.

Signed-off-by: Alexander Graf <agraf@suse.de>
---
 hw/arm/virt.c    | 10 ++++++++++
 target-arm/cpu.h |  3 +++
 target-arm/kvm.c | 19 +++++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 070bbf8..8ac81e3 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -622,6 +622,16 @@ static void create_gic(VirtBoardInfo *vbi, qemu_irq *pic, int type,
     } else if (type == 2) {
         create_v2m(vbi, pic);
     }
+
+#ifdef CONFIG_KVM
+    if (kvm_enabled() && !kvm_irqchip_in_kernel()) {
+        if (!kvm_check_extension(kvm_state, KVM_CAP_ARM_TIMER)) {
+            error_report("KVM with user space irqchip only works when the "
+                         "host kernel supports KVM_CAP_ARM_TIMER");
+            exit(1);
+        }
+    }
+#endif
 }
 
 static void create_uart(const VirtBoardInfo *vbi, qemu_irq *pic, int uart,
diff --git a/target-arm/cpu.h b/target-arm/cpu.h
index 19d967b..7686082 100644
--- a/target-arm/cpu.h
+++ b/target-arm/cpu.h
@@ -659,6 +659,9 @@ struct ARMCPU {
 
     ARMELChangeHook *el_change_hook;
     void *el_change_hook_opaque;
+
+    /* Used to synchronize KVM and QEMU timer levels */
+    uint8_t timer_irq_level;
 };
 
 static inline ARMCPU *arm_env_get_cpu(CPUARMState *env)
diff --git a/target-arm/kvm.c b/target-arm/kvm.c
index c00b94e..0d8b642 100644
--- a/target-arm/kvm.c
+++ b/target-arm/kvm.c
@@ -527,6 +527,25 @@ void kvm_arch_pre_run(CPUState *cs, struct kvm_run *run)
 
 MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
 {
+    ARMCPU *cpu;
+
+    if (kvm_irqchip_in_kernel()) {
+        /*
+         * We only need to sync timer states with user-space interrupt
+         * controllers, so return early and save cycles if we don't.
+         */
+        return MEMTXATTRS_UNSPECIFIED;
+    }
+
+    cpu = ARM_CPU(cs);
+
+    /* Synchronize our internal vtimer irq line with the kvm one */
+    if (run->s.regs.timer_irq_level != cpu->timer_irq_level) {
+        qemu_set_irq(ARM_CPU(cs)->gt_timer_outputs[GTIMER_VIRT],
+                     run->s.regs.timer_irq_level & KVM_ARM_TIMER_VTIMER);
+        cpu->timer_irq_level = run->s.regs.timer_irq_level;
+    }
+
     return MEMTXATTRS_UNSPECIFIED;
 }
 
-- 
1.8.5.6
