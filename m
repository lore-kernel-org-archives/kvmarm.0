Received: from out-136.mta1.migadu.com (out-136.mta1.migadu.com [95.215.58.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B045813
	for <kvmarm@lists.linux.dev>; Sat, 11 Feb 2023 01:57:25 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1676079503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=syiYntVIx4yEzUsRcb7fd+ST1Ff/5bk0NJqoAiJ5rq8=;
	b=pEMPYXZ/DCfYEl4kUIxJK6Haro9Pd+lRW9te4an9NTR6aHWQg+XP2afY1XNqARzoo19EUY
	fj4PHMXWz+AkNOvAJ4ULBzEDFdXRnYJT9xE3MUp9HsxQsD9ymv/mn99l5N4WahQ6Dkp7r+
	n8RPiuEO6IzeGG8r3ik5FR8RvhXqgk8=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvmarm@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	Salil Mehta <salil.mehta@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC PATCH v2 6/6] KVM: arm64: Indroduce support for userspace SMCCC filtering
Date: Sat, 11 Feb 2023 01:37:59 +0000
Message-Id: <20230211013759.3556016-7-oliver.upton@linux.dev>
In-Reply-To: <20230211013759.3556016-1-oliver.upton@linux.dev>
References: <20230211013759.3556016-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

As the SMCCC (and related specifications) march towards an 'everything
and the kitchen sink' interface for interacting with a system it becomes
less likely that KVM will support every related feature. We could do
better by letting userspace have a crack at it instead.

Allow userspace to define an 'SMCCC filter' that applies to both HVCs
and SMCs initiated by the guest. Supporting both conduits with this
interface is important for a couple of reasons. Guest SMC usage is table
stakes for a nested guest, as HVCs are always taken to the virtual EL2.
Additionally, guests may want to interact with a service on the secure
side which can now be proxied by userspace.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Documentation/virt/kvm/devices/vm.rst | 67 ++++++++++++++++++++
 arch/arm64/include/uapi/asm/kvm.h     | 18 ++++++
 arch/arm64/kvm/arm.c                  |  4 ++
 arch/arm64/kvm/hypercalls.c           | 88 +++++++++++++++++++++++++++
 include/kvm/arm_hypercalls.h          |  3 +
 5 files changed, 180 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
index 60acc39e0e93..564ecc7cff0d 100644
--- a/Documentation/virt/kvm/devices/vm.rst
+++ b/Documentation/virt/kvm/devices/vm.rst
@@ -317,3 +317,70 @@ Allows userspace to query the status of migration mode.
 	     if it is enabled
 :Returns:   -EFAULT if the given address is not accessible from kernel space;
 	    0 in case of success.
+
+6. GROUP: KVM_ARM_VM_SMCCC_CTRL
+===============================
+
+:Architectures: arm64
+
+6.1. ATTRIBUTE: KVM_ARM_VM_SMCCC_FILTER (w/o)
+---------------------------------------------
+
+:Parameters: Pointer to a ``struct kvm_smccc_filter``
+
+:Returns:
+
+        =======  ===========================================
+        -EEXIST  SMCCC filter already configured for the VM
+        -EBUSY   A vCPU in the VM has already run
+        -EINVAL  Invalid filter configuration
+        -ENOMEM  Failed to allocate memory for the in-kernel
+                 representation of the SMCCC filter
+        =======  ===========================================
+
+Request the installation of an SMCCC call filter described as follows::
+
+    enum kvm_smccc_filter_action {
+            KVM_SMCCC_FILTER_ALLOW = 0,
+            KVM_SMCCC_FILTER_DENY,
+            KVM_SMCCC_FILTER_FWD_TO_USER,
+    };
+
+    struct kvm_smccc_filter_range {
+            __u32 base;
+            __u32 nr_functions;
+            __u8 action;
+            __u8 pad[7];
+    };
+
+    struct kvm_smccc_filter {
+            __u32 nr_entries;
+            __u32 pad;
+
+            struct kvm_smccc_filter_range entries[];
+    };
+
+The filter is defined as a set of non-overlapping ranges. Each
+range defines an action to be applied to SMCCC calls within the range.
+The default configuration of KVM is such that all implemented SMCCC
+calls are allowed by default. Thus, the SMCCC filter can be defined
+sparsely by userspace, only describing ranges that modify the default
+behavior.
+
+The range expressed by ``struct kvm_smccc_filter_range`` is
+[@base, @base + @nr_functions).
+
+The SMCCC filter applies to both SMC and HVC calls initiated by the
+guest.
+
+Actions:
+
+ - ``KVM_SMCCC_FILTER_ALLOW``: Allows the guest SMCCC call to be
+   handled in-kernel. It is strongly recommended that userspace *not*
+   explicitly describe the allowed SMCCC call ranges.
+
+ - ``KVM_SMCCC_FILTER_DENY``: Rejects the guest SMCCC call in-kernel
+   and returns to the guest.
+
+ - ``KVM_SMCCC_FILTER_FWD_TO_USER``: The guest SMCCC call is forwarded
+   to userspace with an exit reason of ``KVM_EXIT_HYPERCALL``.
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 5c98e7c39ba1..5973031c959d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -371,6 +371,10 @@ enum {
 #endif
 };
 
+/* Device Control API on vm fd */
+#define KVM_ARM_VM_SMCCC_CTRL		0
+#define   KVM_ARM_VM_SMCCC_FILTER	0
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
@@ -478,6 +482,20 @@ enum kvm_smccc_filter_action {
 #endif
 };
 
+struct kvm_smccc_filter_range {
+	__u32 base;
+	__u32 nr_functions;
+	__u8 action;
+	__u8 pad[7];
+};
+
+struct kvm_smccc_filter {
+	__u32 nr_entries;
+	__u32 pad;
+
+	struct kvm_smccc_filter_range entries[];
+};
+
 /* arm64-specific KVM_EXIT_HYPERCALL flags */
 #define KVM_HYPERCALL_EXIT_SMC	(1U << 0)
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e04690caad77..3d64f025ccba 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1454,6 +1454,8 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	switch (attr->group) {
+	case KVM_ARM_VM_SMCCC_CTRL:
+		return kvm_vm_smccc_has_attr(kvm, attr);
 	default:
 		return -ENXIO;
 	}
@@ -1462,6 +1464,8 @@ static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 static int kvm_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	switch (attr->group) {
+	case KVM_ARM_VM_SMCCC_CTRL:
+		return kvm_vm_smccc_set_attr(kvm, attr);
 	default:
 		return -ENXIO;
 	}
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index f095c048730a..1984df78a307 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -126,6 +126,72 @@ static bool kvm_smccc_filter_configured(struct kvm *kvm)
 	return test_bit(KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED, &kvm->arch.flags);
 }
 
+static int kvm_smccc_filter_insert_range(struct kvm *kvm,
+					 struct kvm_smccc_filter_range *range)
+{
+	struct maple_tree *mt = &kvm->arch.smccc_filter;
+	unsigned long start = range->base;
+	unsigned long end = start + range->nr_functions - 1;
+	int r;
+
+	if (!range->nr_functions || range->action >= NR_SMCCC_FILTER_ACTIONS)
+		return -EINVAL;
+
+	r = mtree_insert_range(mt, start, end, xa_mk_value(range->action), GFP_KERNEL_ACCOUNT);
+	if (r == -EEXIST)
+		return -EINVAL;
+
+	return r;
+}
+
+static int kvm_smccc_set_filter(struct kvm *kvm, struct kvm_smccc_filter __user *uaddr)
+{
+	struct kvm_smccc_filter_range *entries;
+	struct kvm_smccc_filter filter;
+	int i, r;
+
+	if (copy_from_user(&filter, uaddr, sizeof(filter)))
+		return -EFAULT;
+
+	entries = memdup_user(&uaddr->entries, sizeof(*entries) * filter.nr_entries);
+	if (IS_ERR(entries))
+		return PTR_ERR(entries);
+
+	mutex_lock(&kvm->lock);
+
+	if (kvm_vm_has_ran_once(kvm)) {
+		r = -EBUSY;
+		goto out;
+	}
+
+	if (kvm_smccc_filter_configured(kvm)) {
+		r = -EEXIST;
+		goto out;
+	}
+
+	for (i = 0; i < filter.nr_entries; i++) {
+		struct kvm_smccc_filter_range *range = &entries[i];
+
+		r = kvm_smccc_filter_insert_range(kvm, range);
+		if (r)
+			goto out_reset_mt;
+	}
+
+	set_bit(KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED, &kvm->arch.flags);
+
+	mutex_unlock(&kvm->lock);
+	kfree(entries);
+	return 0;
+
+out_reset_mt:
+	mtree_destroy(&kvm->arch.smccc_filter);
+	mt_init(&kvm->arch.smccc_filter);
+out:
+	kfree(entries);
+	mutex_unlock(&kvm->lock);
+	return r;
+}
+
 static u8 kvm_smccc_filter_get_action(struct kvm *kvm, u32 func_id)
 {
 	unsigned long index = func_id;
@@ -559,3 +625,25 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 	return -EINVAL;
 }
+
+int kvm_vm_smccc_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VM_SMCCC_FILTER:
+		return 0;
+	default:
+		return -ENXIO;
+	}
+}
+
+int kvm_vm_smccc_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	void __user *uaddr = (void __user *)attr->addr;
+
+	switch (attr->attr) {
+	case KVM_ARM_VM_SMCCC_FILTER:
+		return kvm_smccc_set_filter(kvm, uaddr);
+	default:
+		return -ENXIO;
+	}
+}
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 4707aa206c4e..d01cef2983ee 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -50,4 +50,7 @@ int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
 int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 
+int kvm_vm_smccc_has_attr(struct kvm *kvm, struct kvm_device_attr *attr);
+int kvm_vm_smccc_set_attr(struct kvm *kvm, struct kvm_device_attr *attr);
+
 #endif
-- 
2.39.1.581.gbfd45094c4-goog

