Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B42C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 16:20:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 014F44B130;
	Thu, 27 Jan 2022 11:20:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DPxh25DmO8mj; Thu, 27 Jan 2022 11:20:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0BB64A369;
	Thu, 27 Jan 2022 11:20:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1C2049F2A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:20:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U5puvN7LQG-M for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 11:20:43 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E5454B0ED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:20:43 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 619EF11D4;
 Thu, 27 Jan 2022 08:20:43 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C78033F766;
 Thu, 27 Jan 2022 08:20:41 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com, andre.przywara@arm.com
Subject: [PATCH v2 kvmtool 08/10] update_headers.sh: Sync headers with Linux
 v5.17-rc1 + SET_PMU attribute
Date: Thu, 27 Jan 2022 16:20:31 +0000
Message-Id: <20220127162033.54290-9-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127162033.54290-1-alexandru.elisei@arm.com>
References: <20220127162033.54290-1-alexandru.elisei@arm.com>
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

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch64/include/asm/kvm.h |  4 ++++
 include/linux/kvm.h           | 16 ++++++++++++++++
 x86/include/asm/kvm.h         | 16 +++++++++++++++-
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index b3edde68bc3e..d49f714f48e6 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -362,6 +362,7 @@ struct kvm_arm_copy_mte_tags {
 #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
 #define   KVM_ARM_VCPU_PMU_V3_INIT	1
 #define   KVM_ARM_VCPU_PMU_V3_FILTER	2
+#define   KVM_ARM_VCPU_PMU_V3_SET_PMU	3
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
@@ -413,6 +414,9 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_PSCI_RET_INVAL		PSCI_RET_INVALID_PARAMS
 #define KVM_PSCI_RET_DENIED		PSCI_RET_DENIED
 
+/* run->fail_entry.hardware_entry_failure_reason codes. */
+#define KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED	(1ULL << 0)
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 1daa45268de2..9563d294f181 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -1131,6 +1131,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
+#define KVM_CAP_VM_GPA_BITS 207
+#define KVM_CAP_XSAVE2 208
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1162,11 +1164,20 @@ struct kvm_irq_routing_hv_sint {
 	__u32 sint;
 };
 
+struct kvm_irq_routing_xen_evtchn {
+	__u32 port;
+	__u32 vcpu;
+	__u32 priority;
+};
+
+#define KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL ((__u32)(-1))
+
 /* gsi routing entry types */
 #define KVM_IRQ_ROUTING_IRQCHIP 1
 #define KVM_IRQ_ROUTING_MSI 2
 #define KVM_IRQ_ROUTING_S390_ADAPTER 3
 #define KVM_IRQ_ROUTING_HV_SINT 4
+#define KVM_IRQ_ROUTING_XEN_EVTCHN 5
 
 struct kvm_irq_routing_entry {
 	__u32 gsi;
@@ -1178,6 +1189,7 @@ struct kvm_irq_routing_entry {
 		struct kvm_irq_routing_msi msi;
 		struct kvm_irq_routing_s390_adapter adapter;
 		struct kvm_irq_routing_hv_sint hv_sint;
+		struct kvm_irq_routing_xen_evtchn xen_evtchn;
 		__u32 pad[8];
 	} u;
 };
@@ -1208,6 +1220,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
 #define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
 #define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
+#define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;
@@ -1610,6 +1623,9 @@ struct kvm_enc_region {
 #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
+/* Available with KVM_CAP_XSAVE2 */
+#define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
+
 struct kvm_s390_pv_sec_parm {
 	__u64 origin;
 	__u64 length;
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index 5a776a08f78c..2da3316bb559 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -373,9 +373,23 @@ struct kvm_debugregs {
 	__u64 reserved[9];
 };
 
-/* for KVM_CAP_XSAVE */
+/* for KVM_CAP_XSAVE and KVM_CAP_XSAVE2 */
 struct kvm_xsave {
+	/*
+	 * KVM_GET_XSAVE2 and KVM_SET_XSAVE write and read as many bytes
+	 * as are returned by KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2)
+	 * respectively, when invoked on the vm file descriptor.
+	 *
+	 * The size value returned by KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2)
+	 * will always be at least 4096. Currently, it is only greater
+	 * than 4096 if a dynamic feature has been enabled with
+	 * ``arch_prctl()``, but this may change in the future.
+	 *
+	 * The offsets of the state save areas in struct kvm_xsave follow
+	 * the contents of CPUID leaf 0xD on the host.
+	 */
 	__u32 region[1024];
+	__u32 extra[0];
 };
 
 #define KVM_MAX_XCRS	16
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
