From: Alexander Graf <agraf@suse.de>
Subject: [RFC 1/2] linux-headers: update
Date: Sat, 29 Oct 2016 23:10:48 +0200
Message-ID: <1477775449-115472-1-git-send-email-agraf@suse.de>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: qemu-devel@nongnu.org
Cc: peter.maydell@linaro.org, pbonzini@redhat.com, kvm@vger.kernel.org, qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This patch updates the Linux headers to include the in-progress user
space ARM timer patches. It is explicitly RFC, as the patches are not
merged yet.
---
 linux-headers/asm-arm/kvm.h   | 1 +
 linux-headers/asm-arm64/kvm.h | 1 +
 linux-headers/linux/kvm.h     | 6 ++++++
 3 files changed, 8 insertions(+)

diff --git a/linux-headers/asm-arm/kvm.h b/linux-headers/asm-arm/kvm.h
index 541268c..5d58ec2 100644
--- a/linux-headers/asm-arm/kvm.h
+++ b/linux-headers/asm-arm/kvm.h
@@ -105,6 +105,7 @@ struct kvm_debug_exit_arch {
 };
 
 struct kvm_sync_regs {
+	__u8 timer_irq_level;
 };
 
 struct kvm_arch_memory_slot {
diff --git a/linux-headers/asm-arm64/kvm.h b/linux-headers/asm-arm64/kvm.h
index fd5a276..0e1cbd1 100644
--- a/linux-headers/asm-arm64/kvm.h
+++ b/linux-headers/asm-arm64/kvm.h
@@ -143,6 +143,7 @@ struct kvm_debug_exit_arch {
 #define KVM_GUESTDBG_USE_HW		(1 << 17)
 
 struct kvm_sync_regs {
+	__u8 timer_irq_level;
 };
 
 struct kvm_arch_memory_slot {
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 4806e06..737113c 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -870,6 +870,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_S390_USER_INSTR0 130
 #define KVM_CAP_MSI_DEVID 131
 #define KVM_CAP_PPC_HTM 132
+#define KVM_CAP_ARM_TIMER 133
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1327,4 +1328,9 @@ struct kvm_assigned_msix_entry {
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
 
+/* Available with KVM_CAP_ARM_TIMER */
+
+/* Bits for run->arm_timer.timesource */
+#define KVM_ARM_TIMER_VTIMER           (1 << 0)
+
 #endif /* __LINUX_KVM_H */
-- 
1.8.5.6

