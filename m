Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B66120A5F7
	for <kvmarm@lists.linux.dev>; Fri, 11 Oct 2024 07:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728633142; cv=none; b=Kx8n/u3lH96r47vjyLYBJBvWwa8BcFQKmSgeGGucTMDti8oF7fhL9BWBu3uXC6qrnHnQ0kTcdCNau2x7MLDKg4Dp6v3jVdg1EuxIayKwOpOXPHE4pQ66MQjYLqVe5ykl3ssrKLdy3UWMgPTo1yqLdyxiJrBd9EFcU4DZj17+pr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728633142; c=relaxed/simple;
	bh=NRDzy+OS8jB/4dK6uSDchjJr8iMzlss9JZByfb1pOBY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tQ3csUmWURkHH8HLa7wUJqVkLPDYcO26NY8zqTxFIIH/App7o8pTPaXbon1Pa6JeJNwmkPucBUNypVAm1dY9bpUAOrNpIn9HVaUwM33b1LCkumHBGIIIVpYXrNyQGr11K/cW3xPu/Js73dV2VYU6YIysQlhixaixNQjofhLGOWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XPzNS51Jxz6JB4C;
	Fri, 11 Oct 2024 15:51:52 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 8EF461400D7;
	Fri, 11 Oct 2024 15:52:15 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 11 Oct 2024 09:52:08 +0200
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [RFC PATCH 2/6] KVM: arm64: Add support for VMM to set migration target
Date: Fri, 11 Oct 2024 08:50:49 +0100
Message-ID: <20241011075053.80540-3-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
References: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 frapeml500008.china.huawei.com (7.182.85.71)

Add a VM IOCTL to allow userspace(VMM) to set a number of migration
target CPUs. This can be used to tell KVM the list of targets this
VM will encounter in its lifetime. In subsequent patches, KVM will
use this information to enable errata associated with all the target
CPUs for this VM.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/include/uapi/asm/kvm.h | 12 ++++++++++
 arch/arm64/kvm/arm.c              | 38 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  2 ++
 4 files changed, 55 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 329619c6fa96..952af38729bf 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -375,6 +375,9 @@ struct kvm_arch {
 	 * the associated pKVM instance in the hypervisor.
 	 */
 	struct kvm_protected_vm pkvm;
+
+	u32 num_migrn_cpus;
+	struct migrn_target_cpu *migrn_cpu;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 964df31da975..321f86d747c8 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -540,6 +540,18 @@ struct reg_mask_range {
 	__u32 reserved[13];
 };
 
+struct migrn_target_cpu {
+	__u32 midr;
+	__u32 revidr;
+	__u32 aidr;
+	__u32 reserved;
+};
+
+struct kvm_arm_migrn_cpus {
+	__u32 ncpus;
+	struct migrn_target_cpu entries[] __counted_by(ncpus);
+};
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a0d01c46e408..a7eab4095683 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -48,6 +48,9 @@
 
 #include "sys_regs.h"
 
+/* For now set to 4 */
+#define MAX_MIGRN_TARGET_CPUS 4
+
 static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
 
 enum kvm_wfx_trap_policy {
@@ -267,6 +270,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_destroy_mpidr_data(kvm);
 
 	kfree(kvm->arch.sysreg_masks);
+	kfree(kvm->arch.migrn_cpu);
 	kvm_destroy_vcpus(kvm);
 
 	kvm_unshare_hyp(kvm, kvm + 1);
@@ -339,6 +343,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
+	case KVM_CAP_ARM_MIGRN_TARGET_CPUS:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -1904,6 +1909,39 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 			return -EFAULT;
 		return kvm_vm_ioctl_get_reg_writable_masks(kvm, &range);
 	}
+	case KVM_ARM_SET_MIGRN_TARGET_CPUS: {
+		struct kvm_arm_migrn_cpus __user *user_cpus = argp;
+		struct kvm_arm_migrn_cpus cpus;
+		struct migrn_target_cpu *entries;
+		u32 size;
+		int ret;
+
+		mutex_lock(&kvm->lock);
+		if (kvm->arch.num_migrn_cpus) {
+			ret = -EINVAL;
+			goto migrn_target_cpus_unlock;
+		}
+		if (copy_from_user(&cpus, user_cpus, sizeof(*user_cpus))) {
+			ret = -EFAULT;
+			goto migrn_target_cpus_unlock;
+		}
+		if (cpus.ncpus > MAX_MIGRN_TARGET_CPUS) {
+			ret = -E2BIG;
+			goto migrn_target_cpus_unlock;
+		}
+		size = sizeof(struct migrn_target_cpu) * cpus.ncpus;
+		entries = memdup_user(user_cpus->entries, size);
+		if (IS_ERR(entries)) {
+			ret = PTR_ERR(entries);
+			goto migrn_target_cpus_unlock;
+		}
+		kvm->arch.num_migrn_cpus = cpus.ncpus;
+		kvm->arch.migrn_cpu = entries;
+		ret = 0;
+migrn_target_cpus_unlock:
+		mutex_unlock(&kvm->lock);
+		return ret;
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 637efc055145..5ec035a7092a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -933,6 +933,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_ARM_MIGRN_TARGET_CPUS 239
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1250,6 +1251,7 @@ struct kvm_vfio_spapr_tce {
 /* Available with KVM_CAP_COUNTER_OFFSET */
 #define KVM_ARM_SET_COUNTER_OFFSET _IOW(KVMIO,  0xb5, struct kvm_arm_counter_offset)
 #define KVM_ARM_GET_REG_WRITABLE_MASKS _IOR(KVMIO,  0xb6, struct reg_mask_range)
+#define KVM_ARM_SET_MIGRN_TARGET_CPUS  _IOW(KVMIO,  0xb7, struct kvm_arm_migrn_cpus)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
-- 
2.45.2

