Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C5AC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:38:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5960861BFA
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:38:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5960861BFA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA5114B1EC;
	Wed, 17 Nov 2021 10:38:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VAzKK96bU7RE; Wed, 17 Nov 2021 10:38:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 451504B1DD;
	Wed, 17 Nov 2021 10:38:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD4784B1E9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:38:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WblNWdNcGCbZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:38:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 903884B1D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:38:04 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4193D1FB;
 Wed, 17 Nov 2021 07:38:04 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A49873F5A1;
 Wed, 17 Nov 2021 07:38:02 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 34/38] KVM: arm64: Add an userspace API to stop a VCPU
 profiling
Date: Wed, 17 Nov 2021 15:38:38 +0000
Message-Id: <20211117153842.302159-35-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117153842.302159-1-alexandru.elisei@arm.com>
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

Add the KVM_ARM_VCPU_SPE_CTRL(KVM_ARM_VCPU_SPE_STOP) VCPU attribute to
allow userspace to request that KVM disables profiling for that VCPU. The
ioctl does nothing yet.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst | 36 +++++++++++++++++++++++++
 arch/arm64/include/uapi/asm/kvm.h       |  4 +++
 arch/arm64/kvm/spe.c                    | 23 +++++++++++++---
 3 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 0ed852315664..2e41928c50b1 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -271,3 +271,39 @@ Returns:
 Request initialization of the Statistical Profiling Extension for this VCPU.
 Must be done after initializaing the in-kernel irqchip and after setting the
 Profiling Buffer management interrupt number for the VCPU.
+
+5.3 ATTRIBUTE: KVM_ARM_VCPU_SPE_STOP
+------------------------------------
+
+:Parameters: in kvm_device_attr.addr the address to the flag that specifies
+             what KVM should do when the guest enables profiling
+
+The flag must be exactly one of:
+
+- KVM_ARM_VCPU_SPE_STOP_TRAP: trap all register accesses and ignore the guest
+  trying to enable profiling.
+- KVM_ARM_VCPU_SPE_STOP_EXIT: exit to userspace when the guest tries to enable
+  profiling.
+- KVM_ARM_VCPU_SPE_RESUME: resume profiling, if it was previously stopped using
+  this attribute.
+
+If KVM detects that a vcpu is trying to run with SPE enabled when
+KVM_ARM_VCPU_STOP_EXIT is set, KVM_RUN will return without entering the guest
+with kvm_run.exit_reason equal to KVM_EXIT_FAIL_ENTRY, and the fail_entry struct
+will be zeroed.
+
+Returns:
+
+	 =======  ============================================
+	 -EAGAIN  SPE not initialized
+	 -EFAULT  Error accessing the flag
+	 -EINVAL  Invalid flag
+	 -ENXIO   SPE not supported or not properly configured
+	 =======  ============================================
+
+Request that KVM disables SPE for the given vcpu. This can be useful for
+migration, which relies on tracking dirty pages by write-protecting memory, but
+breaks SPE in the guest as KVM does not handle buffer stage 2 faults.
+
+The attribute must be set after SPE has been initialized successfully. It can be
+set multiple times, with the latest value overwritting the previous one.
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index d4c0b53a5fb2..75a5113f610e 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -371,6 +371,10 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_ARM_VCPU_SPE_CTRL		3
 #define   KVM_ARM_VCPU_SPE_IRQ		0
 #define   KVM_ARM_VCPU_SPE_INIT		1
+#define   KVM_ARM_VCPU_SPE_STOP		2
+#define     KVM_ARM_VCPU_SPE_STOP_TRAP		(1 << 0)
+#define     KVM_ARM_VCPU_SPE_STOP_EXIT		(1 << 1)
+#define     KVM_ARM_VCPU_SPE_RESUME		(1 << 2)
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_VCPU2_SHIFT		28
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index e856554039a1..95d00d8f4faf 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -222,14 +222,14 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	if (!kvm_vcpu_supports_spe(vcpu))
 		return -ENXIO;
 
-	if (vcpu->arch.spe.initialized)
-		return -EBUSY;
-
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_SPE_IRQ: {
 		int __user *uaddr = (int __user *)(long)attr->addr;
 		int irq;
 
+		if (vcpu->arch.spe.initialized)
+			return -EBUSY;
+
 		if (vcpu->arch.spe.irq_num)
 			return -EBUSY;
 
@@ -250,11 +250,27 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		if (!vgic_initialized(vcpu->kvm))
 			return -ENXIO;
 
+		if (vcpu->arch.spe.initialized)
+			return -EBUSY;
+
 		if (kvm_vgic_set_owner(vcpu, vcpu->arch.spe.irq_num, &vcpu->arch.spe))
 			return -ENXIO;
 
 		vcpu->arch.spe.initialized = true;
 		return 0;
+	case KVM_ARM_VCPU_SPE_STOP: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int flags;
+
+		if (!vcpu->arch.spe.initialized)
+			return -EAGAIN;
+
+		if (get_user(flags, uaddr))
+			return -EFAULT;
+
+		if (!flags)
+			return -EINVAL;
+	}
 	}
 
 	return -ENXIO;
@@ -292,6 +308,7 @@ int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	switch(attr->attr) {
 	case KVM_ARM_VCPU_SPE_IRQ:
 	case KVM_ARM_VCPU_SPE_INIT:
+	case KVM_ARM_VCPU_SPE_STOP:
 		return 0;
 	}
 
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
