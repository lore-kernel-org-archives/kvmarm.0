Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CAEC433E3
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 08:41:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D6855207DF
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 08:41:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6855207DF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46DBA4BF6D;
	Mon, 17 Aug 2020 04:41:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6-2FpQsbtiVt; Mon, 17 Aug 2020 04:41:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEE794BF87;
	Mon, 17 Aug 2020 04:41:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D05BF4BF74
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 04:41:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NLG+gKnKhEzC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 04:41:26 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8EBE94BF6D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 04:41:26 -0400 (EDT)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 6AFD1575E938EDF8A34A;
 Mon, 17 Aug 2020 16:41:22 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 17 Aug 2020 16:41:14 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
Subject: [RFC PATCH 3/5] KVM: arm64: Provide VM device attributes for LPT time
Date: Mon, 17 Aug 2020 16:41:08 +0800
Message-ID: <20200817084110.2672-4-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200817084110.2672-1-zhukeqian1@huawei.com>
References: <20200817084110.2672-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

Allow user space to inform the KVM host what the PV frequency is
and where in the physical memory map the paravirtualized LPT time
structures should be located. User space can set attributes on the
VM for that guest.

The address is given in terms of the physical address visible to
the guest and must be 64 byte aligned. The guest will discover the
address via a hypercall. PV frequency is 32 bits and must not be 0.

Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |  4 ++
 arch/arm64/include/uapi/asm/kvm.h |  5 +++
 arch/arm64/kvm/arm.c              | 64 ++++++++++++++++++++++++++++
 arch/arm64/kvm/pvtime.c           | 87 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 160 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0c6a564..cbe330c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -523,6 +523,10 @@ int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
 
+int kvm_arm_pvtime_lpt_set_attr(struct kvm *kvm, struct kvm_device_attr *attr);
+int kvm_arm_pvtime_lpt_get_attr(struct kvm *kvm, struct kvm_device_attr *attr);
+int kvm_arm_pvtime_lpt_has_attr(struct kvm *kvm, struct kvm_device_attr *attr);
+
 static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
 {
 	vcpu_arch->steal.base = GPA_INVALID;
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index ba85bb2..7b045c7 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -325,6 +325,11 @@ struct kvm_vcpu_events {
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
 
+/* Device Control API on kvm fd */
+#define KVM_ARM_VM_PVTIME_LPT_CTRL	0
+#define   KVM_ARM_VM_PVTIME_LPT_IPA	0
+#define   KVM_ARM_VM_PVTIME_LPT_FREQ	1
+
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
 #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 671f1461..4a867e5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1235,11 +1235,60 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 	}
 }
 
+static int kvm_arm_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->group) {
+	case KVM_ARM_VM_PVTIME_LPT_CTRL:
+		ret = kvm_arm_pvtime_lpt_set_attr(kvm, attr);
+		break;
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
+static int kvm_arm_vm_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->group) {
+	case KVM_ARM_VM_PVTIME_LPT_CTRL:
+		ret = kvm_arm_pvtime_lpt_get_attr(kvm, attr);
+		break;
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
+static int kvm_arm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->group) {
+	case KVM_ARM_VM_PVTIME_LPT_CTRL:
+		ret = kvm_arm_pvtime_lpt_has_attr(kvm, attr);
+		break;
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
 	void __user *argp = (void __user *)arg;
+	struct kvm_device_attr attr;
 
 	switch (ioctl) {
 	case KVM_CREATE_IRQCHIP: {
@@ -1271,6 +1320,21 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 		return 0;
 	}
+	case KVM_SET_DEVICE_ATTR: {
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			return -EFAULT;
+		return kvm_arm_vm_set_attr(kvm, &attr);
+	}
+	case KVM_GET_DEVICE_ATTR: {
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			return -EFAULT;
+		return kvm_arm_vm_get_attr(kvm, &attr);
+	}
+	case KVM_HAS_DEVICE_ATTR: {
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			return  -EFAULT;
+		return kvm_arm_vm_has_attr(kvm, &attr);
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 24131ca..3f93473 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -257,3 +257,90 @@ gpa_t kvm_init_lpt_time(struct kvm *kvm)
 {
 	return kvm->arch.lpt.base;
 }
+
+int kvm_arm_pvtime_lpt_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	u64 __user *user = (u64 __user *)attr->addr;
+	u64 ipa;
+	u32 freq;
+	int idx;
+	int ret = 0;
+
+	switch (attr->attr) {
+	case KVM_ARM_VM_PVTIME_LPT_IPA:
+		if (get_user(ipa, user)) {
+			ret = -EFAULT;
+			break;
+		}
+		if (!IS_ALIGNED(ipa, 64)) {
+			ret = -EINVAL;
+			break;
+		}
+		if (kvm->arch.lpt.base != GPA_INVALID) {
+			ret = -EEXIST;
+			break;
+		}
+		/* Check the address is in a valid memslot */
+		idx = srcu_read_lock(&kvm->srcu);
+		if (kvm_is_error_hva(gfn_to_hva(kvm, ipa >> PAGE_SHIFT)))
+			ret = -EINVAL;
+		srcu_read_unlock(&kvm->srcu, idx);
+		if (ret)
+			break;
+
+		kvm->arch.lpt.base = ipa;
+		break;
+	case KVM_ARM_VM_PVTIME_LPT_FREQ:
+		if (get_user(freq, user)) {
+			ret = -EFAULT;
+			break;
+		}
+		if (freq == 0) {
+			ret = -EINVAL;
+			break;
+		}
+		if (kvm->arch.lpt.fpv != 0) {
+			ret = -EEXIST;
+			break;
+		}
+		kvm->arch.lpt.fpv = freq;
+		break;
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
+int kvm_arm_pvtime_lpt_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	u64 __user *user = (u64 __user *)attr->addr;
+	int ret = 0;
+
+	switch (attr->attr) {
+	case KVM_ARM_VM_PVTIME_LPT_IPA:
+		if (put_user(kvm->arch.lpt.base, user))
+			ret = -EFAULT;
+		break;
+	case KVM_ARM_VM_PVTIME_LPT_FREQ:
+		if (put_user(kvm->arch.lpt.fpv, user))
+			ret = -EFAULT;
+		break;
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
+int kvm_arm_pvtime_lpt_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VM_PVTIME_LPT_IPA:
+	case KVM_ARM_VM_PVTIME_LPT_FREQ:
+		return 0;
+	}
+	return -ENXIO;
+}
-- 
1.8.3.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
