Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0ABC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 17:26:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A25684BDD5;
	Thu, 24 Feb 2022 12:26:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E9PnJwNymn-c; Thu, 24 Feb 2022 12:26:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C62B24BD72;
	Thu, 24 Feb 2022 12:26:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCC9F4BD7E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:26:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sajVoUZJNGDA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 12:26:12 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 031434BDDA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:26:11 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 p16-20020a170902a41000b0014992c5d56bso1418263plq.19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 09:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=zwE5cEiZetqja2vTCL0nln/ypguSZC8fkvH9hAsICEY=;
 b=LH+vDy+8ljzpicztnBAsbYWVN/aATE2Kmw8jVkRvb5AmwHm3Ky1fKJ4iIhhozC0xfN
 00nBusB/t7F5cZwHxAuierFsQrUSZ3rCPuoDVxm8QuFjcgWpF32iwuXO6dGgAKY+D4Nk
 FvKJRHLNE5tNX0D89rzPT/YTI4nLxoktj+rfcCckFSljNttUEvkXz9xJ5EhnyKA518Pj
 Dj0Yr70wBcWcRbOGY6FVpu2plko5nX7djwY45eKlfm2KgjR2xayqTAlhashQB/NxPCEY
 oPZM50Y73mowM3F4rMjiF4pcYJIRtPl4PjMaZ52lAMHvyDQC7K2GQNNn/+3C38/C9HEm
 Cw0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=zwE5cEiZetqja2vTCL0nln/ypguSZC8fkvH9hAsICEY=;
 b=ienWbm/xdY7kSnpA+s706UvNbZplqvZ6/e/FLg4Lz97MZcNb268YrGnxVk0q1XxUF8
 hEKbrQ49s1SOUY3RN2fkpuriBxKyAovPHoOzatt6o/zYKdOSeQpSrEzYaeydvvbSbSJa
 HJuIXPEG37X88XKHTPNH7Ursq18f2VMlSp6t4mr31c2urpYD1SOZmDKOlU1o8RZ3Pr05
 ifcyLfdrx5q0bI8Z3ycfmg0wUI4W8Oj2Mqjoos84uD3pfwKTEKhjt9e5clt5HuU0UI1X
 U8PLSyA+js7ScKIC1nqXsvfRz4q6d1kniGXkpiXuctQJbsmfxUoYgQL6GLceYAYQ/shN
 S5wA==
X-Gm-Message-State: AOAM530gA3oWh4v3QVEWPZMLQGdyB8xjY/xnCKHGQOAp3rY5hShc5JPi
 7dF6In0wUbjiIOyYOPKpIAlPai5NnNWn
X-Google-Smtp-Source: ABdhPJwfEvyME9PSudMtl/0BdcjrGMwthB+z29yBgicXmdecZAiSEcSau/lGG27t2U3spq2A4jebc9Q1/DXt
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:6902:b0:14d:6aa4:f3f5 with SMTP id
 j2-20020a170902690200b0014d6aa4f3f5mr3575116plk.20.1645723571006; Thu, 24 Feb
 2022 09:26:11 -0800 (PST)
Date: Thu, 24 Feb 2022 17:25:48 +0000
In-Reply-To: <20220224172559.4170192-1-rananta@google.com>
Message-Id: <20220224172559.4170192-3-rananta@google.com>
Mime-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 02/13] KVM: arm64: Introduce KVM_CAP_ARM_REG_SCOPE
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

KVM_[GET|SET]_ONE_REG act on per-vCPU basis. Currently certain
ARM64 registers, such as KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_[1|2],
are accessed via this interface even though the effect that
they have are really per-VM. As a result, userspace could just
waste cycles to read/write the same information for every vCPU
that it spawns, only to realize that there's absolutely no change
in the VM's state. The problem gets worse in proportion to the
number of vCPUs created.

As a result, to avoid this redundancy, introduce the capability
KVM_CAP_ARM_REG_SCOPE. If enabled, KVM_GET_REG_LIST will advertise
the registers that are VM-scoped by dynamically modifying the
register encoding. KVM_REG_ARM_SCOPE_* helper macros are introduced
to decode the same. By learning this, userspace can access such
registers only once.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 Documentation/virt/kvm/api.rst    | 16 ++++++++++++++++
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/include/uapi/asm/kvm.h |  6 ++++++
 arch/arm64/kvm/arm.c              | 13 +++++++------
 include/uapi/linux/kvm.h          |  1 +
 5 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a4267104db50..7e7b3439f540 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7561,3 +7561,19 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.34 KVM_CAP_ARM_REG_SCOPE
+--------------------------
+
+:Architectures: arm64
+
+The capability, if enabled, amends the existing register encoding
+with additional information to the userspace if a particular register
+is scoped per-vCPU or per-VM via KVM_GET_REG_LIST. KVM provides
+KVM_REG_ARM_SCOPE_* helper macros to decode the same. Userspace can
+use this information from the register encoding to access a VM-scopped
+regiser only once, as opposed to accessing it for every vCPU for the
+same effect.
+
+On the other hand, if the capability is disabled, all the registers
+remain vCPU-scopped by default, retaining backward compatibility.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5bc01e62c08a..8132de6bd718 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -136,6 +136,9 @@ struct kvm_arch {
 
 	/* Memory Tagging Extension enabled for the guest */
 	bool mte_enabled;
+
+	/* Register scoping enabled for KVM registers */
+	bool reg_scope_enabled;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index b3edde68bc3e..c35447cc0e0c 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -199,6 +199,12 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_COPROC_MASK		0x000000000FFF0000
 #define KVM_REG_ARM_COPROC_SHIFT	16
 
+/* Defines if a KVM register is one per-vCPU or one per-VM */
+#define KVM_REG_ARM_SCOPE_MASK		0x0000000010000000
+#define KVM_REG_ARM_SCOPE_SHIFT		28
+#define KVM_REG_ARM_SCOPE_VCPU		0
+#define KVM_REG_ARM_SCOPE_VM		1
+
 /* Normal registers are mapped as coprocessor 16. */
 #define KVM_REG_ARM_CORE		(0x0010 << KVM_REG_ARM_COPROC_SHIFT)
 #define KVM_REG_ARM_CORE_REG(name)	(offsetof(struct kvm_regs, name) / sizeof(__u32))
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ecc5958e27fe..107977c82c6c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -81,26 +81,26 @@ int kvm_arch_check_processor_compat(void *opaque)
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
-	int r;
+	int r = 0;
 
 	if (cap->flags)
 		return -EINVAL;
 
 	switch (cap->cap) {
 	case KVM_CAP_ARM_NISV_TO_USER:
-		r = 0;
 		kvm->arch.return_nisv_io_abort_to_user = true;
 		break;
 	case KVM_CAP_ARM_MTE:
 		mutex_lock(&kvm->lock);
-		if (!system_supports_mte() || kvm->created_vcpus) {
+		if (!system_supports_mte() || kvm->created_vcpus)
 			r = -EINVAL;
-		} else {
-			r = 0;
+		else
 			kvm->arch.mte_enabled = true;
-		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_ARM_REG_SCOPE:
+		WRITE_ONCE(kvm->arch.reg_scope_enabled, true);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -209,6 +209,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_REG_SCOPE:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5191b57e1562..c4fe81ed9ee6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1134,6 +1134,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_ARM_REG_SCOPE 210
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
