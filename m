Return-Path: <SRS0=Ht+8=K5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A42C47096
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 18:34:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 83D6D613B8
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 18:34:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83D6D613B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F6AA4B0CB;
	Thu,  3 Jun 2021 14:34:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3IXwUGxlBNlI; Thu,  3 Jun 2021 14:34:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ACF24B11C;
	Thu,  3 Jun 2021 14:34:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1439B4B0E7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 14:34:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RpTfGhOegTW7 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Jun 2021 14:34:09 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E0914B0B6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 14:34:09 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FE1A613F3;
 Thu,  3 Jun 2021 18:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1622745248;
 bh=xvTd7Eh6umCswsc6DntHBSUyT9ZXtV7p9wb3U520Nms=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=YbmolTxsINqDJRKpXnKvaan3EZOi0N0pFb/5O+IK+bS73V05Bny1/Oy1f4uLzaRGN
 gX3ndoG3PLWnw5aASPq+xY02dNNUUvnFuW7rZ9i8w3qbucWQjA6SNS5uoXBEJg5g1r
 nJP6CqdgpJ8bLv2Yv9PSDZnapB/wUyMB9zZxkHOFWe/TOM5+gS+VudZqbZ/orjfy8t
 vKFkxnkTN6UvSFHdocjTCsdb+aVoAcscwyw/Dmrw9QJXxEPiBDoVpPMBEL1VABSoQL
 2zheck0pvOUTlJH8SEiZenpBfdAOk7o0Qgi/X5/Q/dZJ7rLdHFC+GOOvKpG6EiD44C
 GS0QqYVWvXrKg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 4/4] KVM: arm64: Introduce KVM_CAP_ARM_PROTECTED_VM
Date: Thu,  3 Jun 2021 19:33:47 +0100
Message-Id: <20210603183347.1695-5-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210603183347.1695-1-will@kernel.org>
References: <20210603183347.1695-1-will@kernel.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Introduce a new VM capability, KVM_CAP_ARM_PROTECTED_VM, which can be
used to isolate guest memory from the host. For now, the EL2 portion is
missing, so this documents and exposes the user ABI for the host.

Signed-off-by: Will Deacon <will@kernel.org>
---
 Documentation/virt/kvm/api.rst    |  69 ++++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h |  10 +++
 arch/arm64/include/uapi/asm/kvm.h |   9 +++
 arch/arm64/kvm/arm.c              |  18 +++---
 arch/arm64/kvm/mmu.c              |   3 +
 arch/arm64/kvm/pkvm.c             | 104 ++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |   1 +
 7 files changed, 205 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7fcb2fd38f42..dfbaf905c435 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6362,6 +6362,75 @@ default.
 
 See Documentation/x86/sgx/2.Kernel-internals.rst for more details.
 
+7.26 KVM_CAP_ARM_PROTECTED_VM
+-----------------------------
+
+:Architectures: arm64
+:Target: VM
+:Parameters: flags is a single KVM_CAP_ARM_PROTECTED_VM_FLAGS_* value
+
+The presence of this capability indicates that KVM supports running in a
+configuration where the host Linux kernel does not have access to guest memory.
+On such a system, a small hypervisor layer at EL2 can configure the stage-2
+page tables for both the CPU and any DMA-capable devices to protect guest
+memory pages so that they are inaccessible to the host unless access is granted
+explicitly by the guest.
+
+The 'flags' parameter is defined as follows:
+
+7.26.1 KVM_CAP_ARM_PROTECTED_VM_FLAGS_ENABLE
+--------------------------------------------
+
+:Capability: 'flag' parameter to KVM_CAP_ARM_PROTECTED_VM
+:Architectures: arm64
+:Target: VM
+:Parameters: args[0] contains memory slot ID to hold guest firmware
+:Returns: 0 on success; negative error code on failure
+
+Enabling this capability causes all memory slots of the specified VM to be
+unmapped from the host system and put into a state where they are no longer
+configurable. The memory slot corresponding to the ID passed in args[0] is
+populated with the guest firmware image provided by the host firmware.
+
+The first vCPU to enter the guest is defined to be the primary vCPU. All other
+vCPUs belonging to the VM are secondary vCPUs.
+
+All vCPUs belonging to a VM with this capability enabled are initialised to a
+pre-determined reset state irrespective of any prior configuration according to
+the KVM_ARM_VCPU_INIT ioctl, with the following exceptions for the primary
+vCPU:
+
+	===========	===========
+	Register(s)	Reset value
+	===========	===========
+	X0-X14:		Preserved (see KVM_SET_ONE_REG)
+	X15:		Boot protocol version (0)
+	X16-X30:	Reserved (0)
+	PC:		IPA base of firmware memory slot
+	SP:		IPA end of firmware memory slot
+	===========	===========
+
+Secondary vCPUs belonging to a VM with this capability enabled will return
+-EPERM in response to a KVM_RUN ioctl() if the vCPU was not initialised with
+the KVM_ARM_VCPU_POWER_OFF feature.
+
+There is no support for AArch32 at any exception level.
+
+It is an error to enable this capability on a VM after issuing a KVM_RUN
+ioctl() on one of its vCPUs.
+
+7.26.2 KVM_CAP_ARM_PROTECTED_VM_FLAGS_INFO
+------------------------------------------
+
+:Capability: 'flag' parameter to KVM_CAP_ARM_PROTECTED_VM
+:Architectures: arm64
+:Target: VM
+:Parameters: args[0] contains pointer to 'struct kvm_protected_vm_info'
+:Returns: 0 on success; negative error code on failure
+
+Populates the 'struct kvm_protected_vm_info' pointed to by args[0] with
+information about the protected environment for the VM.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cd7d5c8c4bc..5645af2a1431 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -100,6 +100,11 @@ struct kvm_s2_mmu {
 struct kvm_arch_memory_slot {
 };
 
+struct kvm_protected_vm {
+	bool enabled;
+	struct kvm_memory_slot *firmware_slot;
+};
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
@@ -132,6 +137,8 @@ struct kvm_arch {
 
 	u8 pfr0_csv2;
 	u8 pfr0_csv3;
+
+	struct kvm_protected_vm pkvm;
 };
 
 struct kvm_vcpu_fault_info {
@@ -763,6 +770,9 @@ void kvm_arch_free_vm(struct kvm *kvm);
 
 int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
 
+int kvm_arm_vm_ioctl_pkvm(struct kvm *kvm, struct kvm_enable_cap *cap);
+#define kvm_vm_is_protected(kvm) (kvm->arch.pkvm.enabled)
+
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 24223adae150..cdb3298ba8ae 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -402,6 +402,15 @@ struct kvm_vcpu_events {
 #define KVM_PSCI_RET_INVAL		PSCI_RET_INVALID_PARAMS
 #define KVM_PSCI_RET_DENIED		PSCI_RET_DENIED
 
+/* Protected KVM */
+#define KVM_CAP_ARM_PROTECTED_VM_FLAGS_ENABLE	0
+#define KVM_CAP_ARM_PROTECTED_VM_FLAGS_INFO	1
+
+struct kvm_protected_vm_info {
+	__u64 firmware_size;
+	__u64 __reserved[7];
+};
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8d5e23198dfd..186a0adf6391 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -83,22 +83,19 @@ int kvm_arch_check_processor_compat(void *opaque)
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
-	int r;
-
-	if (cap->flags)
-		return -EINVAL;
-
 	switch (cap->cap) {
 	case KVM_CAP_ARM_NISV_TO_USER:
-		r = 0;
+		if (cap->flags)
+			return -EINVAL;
 		kvm->arch.return_nisv_io_abort_to_user = true;
 		break;
+	case KVM_CAP_ARM_PROTECTED_VM:
+		return kvm_arm_vm_ioctl_pkvm(kvm, cap);
 	default:
-		r = -EINVAL;
-		break;
+		return -EINVAL;
 	}
 
-	return r;
+	return 0;
 }
 
 static int kvm_arm_default_max_vcpus(void)
@@ -265,6 +262,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		r = system_has_full_ptr_auth();
 		break;
+	case KVM_CAP_ARM_PROTECTED_VM:
+		r = is_protected_kvm_enabled();
+		break;
 	default:
 		r = 0;
 	}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c5d1f3c87dbd..e1d4a87d18e4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1349,6 +1349,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	bool writable = !(mem->flags & KVM_MEM_READONLY);
 	int ret = 0;
 
+	if (kvm_vm_is_protected(kvm))
+		return -EPERM;
+
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
 			change != KVM_MR_FLAGS_ONLY)
 		return 0;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 7af5d03a3941..cf624350fb27 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -50,3 +50,107 @@ static int __init pkvm_firmware_rmem_init(struct reserved_mem *rmem)
 }
 RESERVEDMEM_OF_DECLARE(pkvm_firmware, "linux,pkvm-guest-firmware-memory",
 		       pkvm_firmware_rmem_init);
+
+static int pkvm_init_el2_context(struct kvm *kvm)
+{
+	kvm_pr_unimpl("Stage-2 protection is not yet implemented\n");
+	return -EINVAL;
+}
+
+static int pkvm_init_firmware_slot(struct kvm *kvm, u64 slotid)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *slot;
+
+	if (slotid >= KVM_MEM_SLOTS_NUM || !pkvm_firmware_mem)
+		return -EINVAL;
+
+	slots = kvm_memslots(kvm);
+	if (!slots)
+		return -ENOENT;
+
+	slot = id_to_memslot(slots, slotid);
+	if (!slot)
+		return -ENOENT;
+
+	if (slot->flags)
+		return -EINVAL;
+
+	if ((slot->npages << PAGE_SHIFT) < pkvm_firmware_mem->size)
+		return -ENOMEM;
+
+	kvm->arch.pkvm.firmware_slot = slot;
+	return 0;
+}
+
+static void pkvm_teardown_firmware_slot(struct kvm *kvm)
+{
+	kvm->arch.pkvm.firmware_slot = NULL;
+}
+
+static int pkvm_enable(struct kvm *kvm, u64 slotid)
+{
+	int ret;
+
+	ret = pkvm_init_firmware_slot(kvm, slotid);
+	if (ret)
+		return ret;
+
+	ret = pkvm_init_el2_context(kvm);
+	if (ret)
+		pkvm_teardown_firmware_slot(kvm);
+
+	return ret;
+}
+
+static int pkvm_vm_ioctl_enable(struct kvm *kvm, u64 slotid)
+{
+	int ret = 0;
+
+	mutex_lock(&kvm->lock);
+	if (kvm_vm_is_protected(kvm)) {
+		ret = -EPERM;
+		goto out_kvm_unlock;
+	}
+
+	mutex_lock(&kvm->slots_lock);
+	ret = pkvm_enable(kvm, slotid);
+	if (ret)
+		goto out_slots_unlock;
+
+	kvm->arch.pkvm.enabled = true;
+out_slots_unlock:
+	mutex_unlock(&kvm->slots_lock);
+out_kvm_unlock:
+	mutex_unlock(&kvm->lock);
+	return ret;
+}
+
+static int pkvm_vm_ioctl_info(struct kvm *kvm,
+			      struct kvm_protected_vm_info __user *info)
+{
+	struct kvm_protected_vm_info kinfo = {
+		.firmware_size = pkvm_firmware_mem ?
+				 pkvm_firmware_mem->size :
+				 0,
+	};
+
+	return copy_to_user(info, &kinfo, sizeof(kinfo)) ? -EFAULT : 0;
+}
+
+int kvm_arm_vm_ioctl_pkvm(struct kvm *kvm, struct kvm_enable_cap *cap)
+{
+	if (cap->args[1] || cap->args[2] || cap->args[3])
+		return -EINVAL;
+
+	switch (cap->flags) {
+	case KVM_CAP_ARM_PROTECTED_VM_FLAGS_ENABLE:
+		return pkvm_vm_ioctl_enable(kvm, cap->args[0]);
+	case KVM_CAP_ARM_PROTECTED_VM_FLAGS_INFO:
+		return pkvm_vm_ioctl_info(kvm, (void __user *)cap->args[0]);
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3fd9a7e9d90c..58ab8508be5e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1082,6 +1082,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SGX_ATTRIBUTE 196
 #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
 #define KVM_CAP_PTP_KVM 198
+#define KVM_CAP_ARM_PROTECTED_VM 199
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
