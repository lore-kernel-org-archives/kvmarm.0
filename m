From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 2/3] KVM: arm/arm64: Add ARM arch timer interrupts ABI
Date: Tue, 27 Sep 2016 21:08:05 +0200
Message-ID: <20160927190806.22988-3-christoffer.dall@linaro.org>
References: <20160927190806.22988-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160927190806.22988-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alexander Graf <agraf@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Alexander Graf <agraf@suse.de>

We have 2 modes for dealing with interrupts in the ARM world. We can
either handle them all using hardware acceleration through the vgic or
we can emulate a gic in user space and only drive CPU IRQ pins from
there.

Unfortunately, when driving IRQs from user space, we never tell user
space about timer events that may result in interrupt line state
changes, so we lose out on timer events if we run with user space gic
emulation.

Define an ABI to publish the timer output level to userspace.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/api.txt | 29 +++++++++++++++++++++++++++++
 arch/arm/include/uapi/asm/kvm.h   |  2 ++
 arch/arm64/include/uapi/asm/kvm.h |  2 ++
 include/uapi/linux/kvm.h          |  6 ++++++
 4 files changed, 39 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 739db9a..2adf600 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -3928,3 +3928,32 @@ In order to use SynIC, it has to be activated by setting this
 capability via KVM_ENABLE_CAP ioctl on the vcpu fd. Note that this
 will disable the use of APIC hardware virtualization even if supported
 by the CPU, as it's incompatible with SynIC auto-EOI behavior.
+
+8.3 KVM_CAP_ARM_TIMER
+
+Architectures: arm, arm64
+This capability, if KVM_CHECK_EXTENSION indicates that it is available, means
+that if userspace creates a VM without an in-kernel interrupt controller, it
+will be notified of changes to the output level of ARM architected timers
+presented to the VM.  For such VMs, on every return to userspace, the kernel
+updates the vcpu's run->s.regs.timer_irq_level field to represent the actual
+output level of the timers.
+
+Whenever kvm detects a change in the timer output level, kvm guarantees at
+least one return to userspace before running the VM.  This exit could either
+be a KVM_EXIT_INTR or any other exit event, like KVM_EXIT_MMIO. This way,
+userspace can always sample the timer output level and re-compute the state of
+the userspace interrupt controller.  Userspace should always check the state
+of run->s.regs.timer_irq_level on every kvm exit.  The value in
+run->s.regs.timer_irq_level should be considered a level triggered interrupt
+signal.
+
+The field run->s.regs.timer_irq_level is available independent of
+run->kvm_valid_regs or run->kvm_dirty_regs bits.
+
+Currently the following bits are defined for the timer_irq_level bitmap:
+
+    KVM_ARM_TIMER_VTIMER  -  virtual timer
+
+Future versions of kvm may implement additional timer events. These will get
+indicated by additional KVM_CAP extensions.
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index b38c10c..23c2e77 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -112,6 +112,8 @@ struct kvm_debug_exit_arch {
 };
 
 struct kvm_sync_regs {
+	/* Used with KVM_CAP_ARM_TIMER */
+	u8 timer_irq_level;
 };
 
 struct kvm_arch_memory_slot {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 3051f86..411d62a 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -143,6 +143,8 @@ struct kvm_debug_exit_arch {
 #define KVM_GUESTDBG_USE_HW		(1 << 17)
 
 struct kvm_sync_regs {
+	/* Used with KVM_CAP_ARM_TIMER */
+	u8 timer_irq_level;
 };
 
 struct kvm_arch_memory_slot {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 300ef25..c293fc9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
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
+/* Bits for run->s.regs.timer_irq_level */
+#define KVM_ARM_TIMER_VTIMER		(1 << 0)
+
 #endif /* __LINUX_KVM_H */
-- 
2.9.0

