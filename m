From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v10 3/5] arm/arm64: KVM: Introduce set and get per-vcpu event
Date: Sun, 4 Mar 2018 00:09:38 +0800
Message-ID: <1520093380-42577-4-git-send-email-gengdongjiu@huawei.com>
References: <1520093380-42577-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520093380-42577-1-git-send-email-gengdongjiu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rkrcmar@redhat.com, corbet@lwn.net, christoffer.dall@linaro.org, marc.zyngier@arm.com, james.morse@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, bp@alien8.de, lenb@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org
Cc: gengdongjiu@huawei.com, huangshaoyu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

RAS Extension provides VSESR_EL2 register to specify
virtual SError syndrome value, this patch adds a new
IOCTL to export user-invisible states related to
SError exceptions. User space can setup the
kvm_vcpu_events to inject specified SError, also it
can support live migration.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 Documentation/virtual/kvm/api.txt | 26 ++++++++++++++++++++++++--
 arch/arm/include/asm/kvm_host.h   |  6 ++++++
 arch/arm/kvm/guest.c              | 12 ++++++++++++
 arch/arm64/include/asm/kvm_host.h |  5 +++++
 arch/arm64/include/uapi/asm/kvm.h | 10 ++++++++++
 arch/arm64/kvm/guest.c            | 26 ++++++++++++++++++++++++++
 arch/arm64/kvm/reset.c            |  1 +
 virt/kvm/arm/arm.c                | 18 ++++++++++++++++++
 8 files changed, 102 insertions(+), 2 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 8a3d708..26ae151 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -819,11 +819,13 @@ struct kvm_clock_data {
 
 Capability: KVM_CAP_VCPU_EVENTS
 Extended by: KVM_CAP_INTR_SHADOW
-Architectures: x86
+Architectures: x86, arm, arm64
 Type: vm ioctl
 Parameters: struct kvm_vcpu_event (out)
 Returns: 0 on success, -1 on error
 
+X86:
+
 Gets currently pending exceptions, interrupts, and NMIs as well as related
 states of the vcpu.
 
@@ -865,15 +867,29 @@ Only two fields are defined in the flags field:
 - KVM_VCPUEVENT_VALID_SMM may be set in the flags field to signal that
   smi contains a valid state.
 
+ARM, ARM64:
+
+Gets currently pending SError exceptions as well as related states of the vcpu.
+
+struct kvm_vcpu_events {
+       struct {
+               bool serror_pending;
+               bool serror_has_esr;
+               u64 serror_esr;
+       } exception;
+};
+
 4.32 KVM_SET_VCPU_EVENTS
 
 Capability: KVM_CAP_VCPU_EVENTS
 Extended by: KVM_CAP_INTR_SHADOW
-Architectures: x86
+Architectures: x86, arm, arm64
 Type: vm ioctl
 Parameters: struct kvm_vcpu_event (in)
 Returns: 0 on success, -1 on error
 
+X86:
+
 Set pending exceptions, interrupts, and NMIs as well as related states of the
 vcpu.
 
@@ -894,6 +910,12 @@ shall be written into the VCPU.
 
 KVM_VCPUEVENT_VALID_SMM can only be set if KVM_CAP_X86_SMM is available.
 
+ARM, ARM64:
+
+Set pending SError exceptions as well as related states of the vcpu.
+
+See KVM_GET_VCPU_EVENTS for the data structure.
+
 
 4.33 KVM_GET_DEBUGREGS
 
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index ef54013..d81621e 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -211,6 +211,12 @@ struct kvm_vcpu_stat {
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
 int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
+int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
+			struct kvm_vcpu_events *events);
+
+int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
+			struct kvm_vcpu_events *events);
+
 unsigned long kvm_call_hyp(void *hypfn, ...);
 void force_vm_exit(const cpumask_t *mask);
 
diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index 1e0784e..39f895d 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -248,6 +248,18 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	return -EINVAL;
 }
 
+int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
+			struct kvm_vcpu_events *events)
+{
+	return -EINVAL;
+}
+
+int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
+			struct kvm_vcpu_events *events)
+{
+	return -EINVAL;
+}
+
 int __attribute_const__ kvm_target_cpu(void)
 {
 	switch (read_cpuid_part()) {
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3dc49b7..1125540 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -326,6 +326,11 @@ struct kvm_vcpu_stat {
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
 int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
+int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
+			struct kvm_vcpu_events *events);
+
+int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
+			struct kvm_vcpu_events *events);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 9abbf30..32c0eae 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -39,6 +39,7 @@
 #define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_READONLY_MEM
+#define __KVM_HAVE_VCPU_EVENTS
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
@@ -153,6 +154,15 @@ struct kvm_sync_regs {
 struct kvm_arch_memory_slot {
 };
 
+/* for KVM_GET/SET_VCPU_EVENTS */
+struct kvm_vcpu_events {
+	struct {
+		bool serror_pending;
+		bool serror_has_esr;
+		u64 serror_esr;
+	} exception;
+};
+
 /* If you need to interpret the index values, here is the key: */
 #define KVM_REG_ARM_COPROC_MASK		0x000000000FFF0000
 #define KVM_REG_ARM_COPROC_SHIFT	16
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5c7f657..62d49c2 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -277,6 +277,32 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	return -EINVAL;
 }
 
+int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
+			struct kvm_vcpu_events *events)
+{
+	events->exception.serror_pending = (vcpu_get_hcr(vcpu) & HCR_VSE);
+	events->exception.serror_has_esr =
+			cpus_have_const_cap(ARM64_HAS_RAS_EXTN) &&
+					(!!vcpu_get_vsesr(vcpu));
+	events->exception.serror_esr = vcpu_get_vsesr(vcpu);
+
+	return 0;
+}
+
+int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
+			struct kvm_vcpu_events *events)
+{
+	bool injected = events->exception.serror_pending;
+	bool has_esr = events->exception.serror_has_esr;
+
+	if (injected && has_esr)
+		kvm_set_sei_esr(vcpu, events->exception.serror_esr);
+	else if (injected)
+		kvm_inject_vabt(vcpu);
+
+	return 0;
+}
+
 int __attribute_const__ kvm_target_cpu(void)
 {
 	unsigned long implementor = read_cpuid_implementor();
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 38c8a64..20e919a 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -82,6 +82,7 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
+	case KVM_CAP_VCPU_EVENTS:
 		r = 1;
 		break;
 	default:
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 7e3941f..30c56e0 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1051,6 +1051,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			return -EFAULT;
 		return kvm_arm_vcpu_has_attr(vcpu, &attr);
 	}
+	case KVM_GET_VCPU_EVENTS: {
+		struct kvm_vcpu_events events;
+
+		kvm_arm_vcpu_get_events(vcpu, &events);
+
+		if (copy_to_user(argp, &events, sizeof(struct kvm_vcpu_events)))
+			return -EFAULT;
+
+		return 0;
+	}
+	case KVM_SET_VCPU_EVENTS: {
+		struct kvm_vcpu_events events;
+
+		if (copy_from_user(&events, argp, sizeof(struct kvm_vcpu_events)))
+			return -EFAULT;
+
+		return kvm_arm_vcpu_set_events(vcpu, &events);
+	}
 	default:
 		return -EINVAL;
 	}
-- 
1.9.1
