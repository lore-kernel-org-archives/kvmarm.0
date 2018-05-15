From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v12 2/4] arm/arm64: KVM: Add KVM_GET/SET_VCPU_EVENTS
Date: Wed, 16 May 2018 04:58:05 +0800
Message-ID: <1526417887-25843-3-git-send-email-gengdongjiu@huawei.com>
References: <1526417887-25843-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526417887-25843-1-git-send-email-gengdongjiu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rkrcmar@redhat.com, corbet@lwn.net, christoffer.dall@arm.com, marc.zyngier@arm.com, james.morse@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, bp@alien8.de, lenb@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org
Cc: gengdongjiu@huawei.com, huangshaoyu@huawei.com, zhengxiang9@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

For the migrating VMs, user space may need to know the exception
state. For example, in the machine A, KVM make an SError pending,
when migrate to B, KVM also needs to pend an SError.

This new IOCTL exports user-invisible states related to SError.
Together with appropriate user space changes, user space can get/set
the SError exception state to do migrate/snapshot/suspend.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>

Change since V11:
Address James's comments, thanks James
1. Align the struct of kvm_vcpu_events to 64 bytes
2. Avoid exposing the stale ESR value in the kvm_arm_vcpu_get_events()
3. Change variables 'injected' name to 'serror_pending' in the kvm_arm_vcpu_set_events()
4. change to sizeof(events) from sizeof(struct kvm_vcpu_events) in kvm_arch_vcpu_ioctl()

Change since V10:
Address James's comments, thanks James
1. Merge the helper function with the user.
2. Move the ISS_MASK into pend_guest_serror() to clear top bits
3. Make kvm_vcpu_events struct align to 4 bytes
4. Add something check in the kvm_arm_vcpu_set_events()
5. Check kvm_arm_vcpu_get/set_events()'s return value.
6. Initialise kvm_vcpu_events to 0 so that padding transferred to user-space doesn't
contain kernel stack.
---
 Documentation/virtual/kvm/api.txt    | 31 ++++++++++++++++++++++++++++---
 arch/arm/include/asm/kvm_host.h      |  6 ++++++
 arch/arm/kvm/guest.c                 | 12 ++++++++++++
 arch/arm64/include/asm/kvm_emulate.h |  5 +++++
 arch/arm64/include/asm/kvm_host.h    |  7 +++++++
 arch/arm64/include/uapi/asm/kvm.h    | 13 +++++++++++++
 arch/arm64/kvm/guest.c               | 36 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/inject_fault.c        |  7 ++++++-
 arch/arm64/kvm/reset.c               |  1 +
 virt/kvm/arm/arm.c                   | 21 +++++++++++++++++++++
 10 files changed, 135 insertions(+), 4 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 66494a5..36a9dc3 100644
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
 
@@ -865,15 +867,32 @@ Only two fields are defined in the flags field:
 - KVM_VCPUEVENT_VALID_SMM may be set in the flags field to signal that
   smi contains a valid state.
 
+ARM, ARM64:
+
+Gets currently pending SError exceptions as well as related states of the vcpu.
+
+struct kvm_vcpu_events {
+	struct {
+		__u8 serror_pending;
+		__u8 serror_has_esr;
+		/* Align it to 8 bytes */
+		__u8 pad[6];
+		__u64 serror_esr;
+	} exception;
+	__u32 reserved[12];
+};
+
 4.32 KVM_SET_VCPU_EVENTS
 
-Capability: KVM_CAP_VCPU_EVENTS
+Capebility: KVM_CAP_VCPU_EVENTS
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
 
@@ -894,6 +913,12 @@ shall be written into the VCPU.
 
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
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 413dc82..3294885 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -71,6 +71,11 @@ static inline void vcpu_set_hcr(struct kvm_vcpu *vcpu, unsigned long hcr)
 	vcpu->arch.hcr_el2 = hcr;
 }
 
+static inline unsigned long vcpu_get_vsesr(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.vsesr_el2;
+}
+
 static inline void vcpu_set_vsesr(struct kvm_vcpu *vcpu, u64 vsesr)
 {
 	vcpu->arch.vsesr_el2 = vsesr;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a73f63a..1125540 100644
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
@@ -354,6 +359,8 @@ void handle_exit_early(struct kvm_vcpu *vcpu, struct kvm_run *run,
 int kvm_perf_init(void);
 int kvm_perf_teardown(void);
 
+void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
+
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
 static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 9abbf30..d815b67 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -39,6 +39,7 @@
 #define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_READONLY_MEM
+#define __KVM_HAVE_VCPU_EVENTS
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
@@ -153,6 +154,18 @@ struct kvm_sync_regs {
 struct kvm_arch_memory_slot {
 };
 
+/* for KVM_GET/SET_VCPU_EVENTS */
+struct kvm_vcpu_events {
+	struct {
+		__u8 serror_pending;
+		__u8 serror_has_esr;
+		/* Align it to 8 bytes */
+		__u8 pad[6];
+		__u64 serror_esr;
+	} exception;
+	__u32 reserved[12];
+};
+
 /* If you need to interpret the index values, here is the key: */
 #define KVM_REG_ARM_COPROC_MASK		0x000000000FFF0000
 #define KVM_REG_ARM_COPROC_SHIFT	16
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5c7f657..f9b7e8f 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -277,6 +277,42 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	return -EINVAL;
 }
 
+int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
+			struct kvm_vcpu_events *events)
+{
+	events->exception.serror_pending = (vcpu_get_hcr(vcpu) & HCR_VSE);
+	events->exception.serror_has_esr =
+			cpus_have_const_cap(ARM64_HAS_RAS_EXTN) &&
+					(!!vcpu_get_vsesr(vcpu));
+
+	if (events->exception.serror_pending &&
+		events->exception.serror_has_esr)
+		events->exception.serror_esr = vcpu_get_vsesr(vcpu);
+	else
+		events->exception.serror_esr = 0;
+
+	return 0;
+}
+
+int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
+			struct kvm_vcpu_events *events)
+{
+	bool serror_pending = events->exception.serror_pending;
+	bool has_esr = events->exception.serror_has_esr;
+
+	if (serror_pending && has_esr) {
+		if (!cpus_have_const_cap(ARM64_HAS_RAS_EXTN))
+			return -EINVAL;
+
+		kvm_set_sei_esr(vcpu, events->exception.serror_esr);
+
+	} else if (serror_pending) {
+		kvm_inject_vabt(vcpu);
+	}
+
+	return 0;
+}
+
 int __attribute_const__ kvm_target_cpu(void)
 {
 	unsigned long implementor = read_cpuid_implementor();
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 60666a0..aa0358a 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -166,7 +166,7 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 
 static void pend_guest_serror(struct kvm_vcpu *vcpu, u64 esr)
 {
-	vcpu_set_vsesr(vcpu, esr);
+	vcpu_set_vsesr(vcpu, esr & ESR_ELx_ISS_MASK);
 	vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) | HCR_VSE);
 }
 
@@ -186,3 +186,8 @@ void kvm_inject_vabt(struct kvm_vcpu *vcpu)
 {
 	pend_guest_serror(vcpu, ESR_ELx_ISV);
 }
+
+void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome)
+{
+	pend_guest_serror(vcpu, syndrome);
+}
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
index 7e3941f..e466f5d 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1051,6 +1051,27 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			return -EFAULT;
 		return kvm_arm_vcpu_has_attr(vcpu, &attr);
 	}
+	case KVM_GET_VCPU_EVENTS: {
+		struct kvm_vcpu_events events;
+
+		memset(&events, 0, sizeof(events));
+		if (kvm_arm_vcpu_get_events(vcpu, &events))
+			return -EINVAL;
+
+		if (copy_to_user(argp, &events, sizeof(events)))
+			return -EFAULT;
+
+		return 0;
+	}
+	case KVM_SET_VCPU_EVENTS: {
+		struct kvm_vcpu_events events;
+
+		if (copy_from_user(&events, argp,
+				sizeof(struct kvm_vcpu_events)))
+			return -EFAULT;
+
+		return kvm_arm_vcpu_set_events(vcpu, &events);
+	}
 	default:
 		return -EINVAL;
 	}
-- 
1.9.1
