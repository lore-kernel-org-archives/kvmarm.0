Return-Path: <SRS0=3K2b=XE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73F8C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 12:13:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9AFA52067B
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 12:13:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9AFA52067B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 538A84A5D5;
	Mon,  9 Sep 2019 08:13:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wbc9-ubgxrTR; Mon,  9 Sep 2019 08:13:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A98D24A533;
	Mon,  9 Sep 2019 08:13:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B2084A4EA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 08:13:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kRPgdEnh95Ao for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Sep 2019 08:13:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 968914A52C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 08:13:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4DABC1570;
 Mon,  9 Sep 2019 05:13:47 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9BDB53F59C;
 Mon,  9 Sep 2019 05:13:44 -0700 (PDT)
From: Christoffer Dall <christoffer.dall@arm.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/2] KVM: arm/arm64: Allow reporting non-ISV data aborts to
 userspace
Date: Mon,  9 Sep 2019 14:13:33 +0200
Message-Id: <20190909121337.27287-2-christoffer.dall@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190909121337.27287-1-christoffer.dall@arm.com>
References: <20190909121337.27287-1-christoffer.dall@arm.com>
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>,
 Heinrich Schuchardt <xypron.glpk@gmx.de>, linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

For a long time, if a guest accessed memory outside of a memslot using
any of the load/store instructions in the architecture which doesn't
supply decoding information in the ESR_EL2 (the ISV bit is not set), the
kernel would print the following message and terminate the VM as a
result of returning -ENOSYS to userspace:

  load/store instruction decoding not implemented

The reason behind this message is that KVM assumes that all accesses
outside a memslot is an MMIO access which should be handled by
userspace, and we originally expected to eventually implement some sort
of decoding of load/store instructions where the ISV bit was not set.

However, it turns out that many of the instructions which don't provide
decoding information on abort are not safe to use for MMIO accesses, and
the remaining few that would potentially make sense to use on MMIO
accesses, such as those with register writeback, are not used in
practice.  It also turns out that fetching an instruction from guest
memory can be a pretty horrible affair, involving stopping all CPUs on
SMP systems, handling multiple corner cases of address translation in
software, and more.  It doesn't appear likely that we'll ever implement
this in the kernel.

What is much more common is that a user has misconfigured his/her guest
and is actually not accessing an MMIO region, but just hitting some
random hole in the IPA space.  In this scenario, the error message above
is almost misleading and has led to a great deal of confusion over the
years.

It is, nevertheless, ABI to userspace, and we therefore need to
introduce a new capability that userspace explicitly enables to change
behavior.

This patch introduces KVM_CAP_ARM_NISV_TO_USER (NISV meaning Non-ISV)
which does exactly that, and introduces a new exit reason to report the
event to userspace.  User space can then emulate an exception to the
guest, restart the guest, suspend the guest, or take any other
appropriate action as per the policy of the running system.

Reported-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 Documentation/virt/kvm/api.txt       | 29 ++++++++++++++++++++++++++++
 arch/arm/include/asm/kvm_arm.h       |  2 ++
 arch/arm/include/asm/kvm_emulate.h   |  5 +++++
 arch/arm/include/asm/kvm_host.h      |  8 ++++++++
 arch/arm64/include/asm/kvm_emulate.h |  5 +++++
 arch/arm64/include/asm/kvm_host.h    |  8 ++++++++
 include/uapi/linux/kvm.h             |  7 +++++++
 virt/kvm/arm/arm.c                   | 21 ++++++++++++++++++++
 virt/kvm/arm/mmio.c                  | 11 +++++++++--
 9 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 2d067767b617..02501333f746 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -4453,6 +4453,35 @@ Hyper-V SynIC state change. Notification is used to remap SynIC
 event/message pages and to enable/disable SynIC messages/events processing
 in userspace.
 
+		/* KVM_EXIT_ARM_NISV */
+		struct {
+			__u64 esr_iss;
+			__u64 fault_ipa;
+		} arm_nisv;
+
+Used on arm and arm64 systems. If a guest accesses memory not in a memslot,
+KVM will typically return to userspace and ask it to do MMIO emulation on its
+behalf. However, for certain classes of instructions, no instruction decode
+(direction, length of memory access) is provided, and fetching and decoding
+the instruction from the VM is overly complicated to live in the kernel.
+
+Historically, when this situation occurred, KVM would print a warning and kill
+the VM. KVM assumed that if the guest accessed non-memslot memory, it was
+trying to do I/O, which just couldn't be emulated, and the warning message was
+phrased accordingly. However, what happened more often was that a guest bug
+caused access outside the guest memory areas which should lead to a more
+mearningful warning message and an external abort in the guest, if the access
+did not fall within an I/O window.
+
+Userspace implementations can query for KVM_CAP_ARM_NISV_TO_USER, and enable
+this capability at VM creation. Once this is done, these types of errors will
+instead return to userspace with KVM_EXIT_ARM_NISV, with the valid bits from
+the HSR (arm) and ESR_EL2 (arm64) in the esr_iss field, and the faulting IPA
+in the fault_ipa field. Userspace can either fix up the access if it's
+actually an I/O access by decoding the instruction from guest memory (if it's
+very brave) and continue executing the guest, or it can decide to suspend,
+dump, or restart the guest.
+
 		/* Fix the size of the union. */
 		char padding[256];
 	};
diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
index 0125aa059d5b..ce61b3b0058d 100644
--- a/arch/arm/include/asm/kvm_arm.h
+++ b/arch/arm/include/asm/kvm_arm.h
@@ -162,6 +162,8 @@
 #define HSR_ISV		(_AC(1, UL) << HSR_ISV_SHIFT)
 #define HSR_SRT_SHIFT	(16)
 #define HSR_SRT_MASK	(0xf << HSR_SRT_SHIFT)
+#define HSR_CM		(1 << 8)
+#define HSR_WNR		(1 << 6)
 #define HSR_FSC		(0x3f)
 #define HSR_FSC_TYPE	(0x3c)
 #define HSR_SSE		(1 << 21)
diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 40002416efec..e8ef349c04b4 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -167,6 +167,11 @@ static inline bool kvm_vcpu_dabt_isvalid(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_get_hsr(vcpu) & HSR_ISV;
 }
 
+static inline unsigned long kvm_vcpu_dabt_iss_nisv_sanitized(const struct kvm_vcpu *vcpu)
+{
+	return kvm_vcpu_get_hsr(vcpu) & (HSR_CM | HSR_WNR | HSR_FSC);
+}
+
 static inline bool kvm_vcpu_dabt_iswrite(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_get_hsr(vcpu) & HSR_WNR;
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 8a37c8e89777..19a92c49039c 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -76,6 +76,14 @@ struct kvm_arch {
 
 	/* Mandated version of PSCI */
 	u32 psci_version;
+
+	/*
+	 * If we encounter a data abort without valid instruction syndrome
+	 * information, report this to user space.  User space can (and
+	 * should) opt in to this feature if KVM_CAP_ARM_NISV_TO_USER is
+	 * supported.
+	 */
+	bool return_nisv_io_abort_to_user;
 };
 
 #define KVM_NR_MEM_OBJS     40
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d69c1efc63e7..a3c967988e1d 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -258,6 +258,11 @@ static inline bool kvm_vcpu_dabt_isvalid(const struct kvm_vcpu *vcpu)
 	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_ISV);
 }
 
+static inline unsigned long kvm_vcpu_dabt_iss_nisv_sanitized(const struct kvm_vcpu *vcpu)
+{
+	return kvm_vcpu_get_hsr(vcpu) & (ESR_ELx_CM | ESR_ELx_WNR | ESR_ELx_FSC);
+}
+
 static inline bool kvm_vcpu_dabt_issext(const struct kvm_vcpu *vcpu)
 {
 	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_SSE);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f656169db8c3..019bc560edc1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -83,6 +83,14 @@ struct kvm_arch {
 
 	/* Mandated version of PSCI */
 	u32 psci_version;
+
+	/*
+	 * If we encounter a data abort without valid instruction syndrome
+	 * information, report this to user space.  User space can (and
+	 * should) opt in to this feature if KVM_CAP_ARM_NISV_TO_USER is
+	 * supported.
+	 */
+	bool return_nisv_io_abort_to_user;
 };
 
 #define KVM_NR_MEM_OBJS     40
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5e3f12d5359e..dd79235b6435 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -235,6 +235,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_S390_STSI        25
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
+#define KVM_EXIT_ARM_NISV         28
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -392,6 +393,11 @@ struct kvm_run {
 		} eoi;
 		/* KVM_EXIT_HYPERV */
 		struct kvm_hyperv_exit hyperv;
+		/* KVM_EXIT_ARM_NISV */
+		struct {
+			__u64 esr_iss;
+			__u64 fault_ipa;
+		} arm_nisv;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -996,6 +1002,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
 #define KVM_CAP_PMU_EVENT_FILTER 173
+#define KVM_CAP_ARM_NISV_TO_USER 174
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 35a069815baf..7153504bb106 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -98,6 +98,26 @@ int kvm_arch_check_processor_compat(void)
 	return 0;
 }
 
+int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
+			    struct kvm_enable_cap *cap)
+{
+	int r;
+
+	if (cap->flags)
+		return -EINVAL;
+
+	switch (cap->cap) {
+	case KVM_CAP_ARM_NISV_TO_USER:
+		r = 0;
+		kvm->arch.return_nisv_io_abort_to_user = true;
+		break;
+	default:
+		r = -EINVAL;
+		break;
+	}
+
+	return r;
+}
 
 /**
  * kvm_arch_init_vm - initializes a VM data structure
@@ -196,6 +216,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MP_STATE:
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_VCPU_EVENTS:
+	case KVM_CAP_ARM_NISV_TO_USER:
 		r = 1;
 		break;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
index 6af5c91337f2..7b92e2744fa7 100644
--- a/virt/kvm/arm/mmio.c
+++ b/virt/kvm/arm/mmio.c
@@ -167,8 +167,15 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		if (ret)
 			return ret;
 	} else {
-		kvm_err("load/store instruction decoding not implemented\n");
-		return -ENOSYS;
+		if (vcpu->kvm->arch.return_nisv_io_abort_to_user) {
+			run->exit_reason = KVM_EXIT_ARM_NISV;
+			run->arm_nisv.esr_iss = kvm_vcpu_dabt_iss_nisv_sanitized(vcpu);
+			run->arm_nisv.fault_ipa = fault_ipa;
+			return 0;
+		} else {
+			kvm_info("Encountered data abort outside memslots with no valid syndrome info\n");
+			return -ENOSYS;
+		}
 	}
 
 	rt = vcpu->arch.mmio_decode.rt;
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
