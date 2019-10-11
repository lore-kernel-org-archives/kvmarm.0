Return-Path: <SRS0=GvsF=YE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B0F5C47404
	for <kvmarm@archiver.kernel.org>; Fri, 11 Oct 2019 11:07:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 485EB206CD
	for <kvmarm@archiver.kernel.org>; Fri, 11 Oct 2019 11:07:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 485EB206CD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01E264A8C2;
	Fri, 11 Oct 2019 07:07:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xzN1LvLHNFXg; Fri, 11 Oct 2019 07:07:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23AE14A8CF;
	Fri, 11 Oct 2019 07:07:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7C024A86B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Oct 2019 07:07:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pv3S-Emq3oR4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Oct 2019 07:07:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72D3C4A7FC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Oct 2019 07:07:19 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B0041570;
 Fri, 11 Oct 2019 04:07:19 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B2D8F3F703;
 Fri, 11 Oct 2019 04:07:18 -0700 (PDT)
From: Christoffer Dall <christoffer.dall@arm.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 2/2] KVM: arm/arm64: Allow user injection of external data
 aborts
Date: Fri, 11 Oct 2019 13:07:06 +0200
Message-Id: <20191011110709.2764-3-christoffer.dall@arm.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20191011110709.2764-1-christoffer.dall@arm.com>
References: <20191011110709.2764-1-christoffer.dall@arm.com>
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

In some scenarios, such as buggy guest or incorrect configuration of the
VMM and firmware description data, userspace will detect a memory access
to a portion of the IPA, which is not mapped to any MMIO region.

For this purpose, the appropriate action is to inject an external abort
to the guest.  The kernel already has functionality to inject an
external abort, but we need to wire up a signal from user space that
lets user space tell the kernel to do this.

It turns out, we already have the set event functionality which we can
perfectly reuse for this.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 Documentation/virt/kvm/api.txt    | 22 +++++++++++++++++++++-
 arch/arm/include/uapi/asm/kvm.h   |  3 ++-
 arch/arm/kvm/guest.c              | 10 ++++++++++
 arch/arm64/include/uapi/asm/kvm.h |  3 ++-
 arch/arm64/kvm/guest.c            | 10 ++++++++++
 arch/arm64/kvm/inject_fault.c     |  4 ++--
 include/uapi/linux/kvm.h          |  1 +
 virt/kvm/arm/arm.c                |  1 +
 8 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 7403f15657c2..bd29d44af32b 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -1002,12 +1002,18 @@ Specifying exception.has_esr on a system that does not support it will return
 -EINVAL. Setting anything other than the lower 24bits of exception.serror_esr
 will return -EINVAL.
 
+It is not possible to read back a pending external abort (injected via
+KVM_SET_VCPU_EVENTS or otherwise) because such an exception is always delivered
+directly to the virtual CPU).
+
+
 struct kvm_vcpu_events {
 	struct {
 		__u8 serror_pending;
 		__u8 serror_has_esr;
+		__u8 ext_dabt_pending;
 		/* Align it to 8 bytes */
-		__u8 pad[6];
+		__u8 pad[5];
 		__u64 serror_esr;
 	} exception;
 	__u32 reserved[12];
@@ -1051,9 +1057,23 @@ contain a valid state and shall be written into the VCPU.
 
 ARM/ARM64:
 
+User space may need to inject several types of events to the guest.
+
 Set the pending SError exception state for this VCPU. It is not possible to
 'cancel' an Serror that has been made pending.
 
+If the guest performed an access to I/O memory which could not be handled by
+userspace, for example because of missing instruction syndrome decode
+information or because there is no device mapped at the accessed IPA, then
+userspace can ask the kernel to inject an external abort using the address
+from the exiting fault on the VCPU. It is a programming error to set
+ext_dabt_pending after an exit which was not either KVM_EXIT_MMIO or
+KVM_EXIT_ARM_NISV. This feature is only available if the system supports
+KVM_CAP_ARM_INJECT_EXT_DABT. This is a helper which provides commonality in
+how userspace reports accesses for the above cases to guests, across different
+userspace implementations. Nevertheless, userspace can still emulate all Arm
+exceptions by manipulating individual registers using the KVM_SET_ONE_REG API.
+
 See KVM_GET_VCPU_EVENTS for the data structure.
 
 
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 2769360f195c..03cd7c19a683 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -131,8 +131,9 @@ struct kvm_vcpu_events {
 	struct {
 		__u8 serror_pending;
 		__u8 serror_has_esr;
+		__u8 ext_dabt_pending;
 		/* Align it to 8 bytes */
-		__u8 pad[6];
+		__u8 pad[5];
 		__u64 serror_esr;
 	} exception;
 	__u32 reserved[12];
diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index 684cf64b4033..735f9b007e58 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -255,6 +255,12 @@ int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 {
 	events->exception.serror_pending = !!(*vcpu_hcr(vcpu) & HCR_VA);
 
+	/*
+	 * We never return a pending ext_dabt here because we deliver it to
+	 * the virtual CPU directly when setting the event and it's no longer
+	 * 'pending' at this point.
+	 */
+
 	return 0;
 }
 
@@ -263,12 +269,16 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 {
 	bool serror_pending = events->exception.serror_pending;
 	bool has_esr = events->exception.serror_has_esr;
+	bool ext_dabt_pending = events->exception.ext_dabt_pending;
 
 	if (serror_pending && has_esr)
 		return -EINVAL;
 	else if (serror_pending)
 		kvm_inject_vabt(vcpu);
 
+	if (ext_dabt_pending)
+		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+
 	return 0;
 }
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 67c21f9bdbad..d49c17a80491 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -164,8 +164,9 @@ struct kvm_vcpu_events {
 	struct {
 		__u8 serror_pending;
 		__u8 serror_has_esr;
+		__u8 ext_dabt_pending;
 		/* Align it to 8 bytes */
-		__u8 pad[6];
+		__u8 pad[5];
 		__u64 serror_esr;
 	} exception;
 	__u32 reserved[12];
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dfd626447482..ca613a44c6ec 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -712,6 +712,12 @@ int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 	if (events->exception.serror_pending && events->exception.serror_has_esr)
 		events->exception.serror_esr = vcpu_get_vsesr(vcpu);
 
+	/*
+	 * We never return a pending ext_dabt here because we deliver it to
+	 * the virtual CPU directly when setting the event and it's no longer
+	 * 'pending' at this point.
+	 */
+
 	return 0;
 }
 
@@ -720,6 +726,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 {
 	bool serror_pending = events->exception.serror_pending;
 	bool has_esr = events->exception.serror_has_esr;
+	bool ext_dabt_pending = events->exception.ext_dabt_pending;
 
 	if (serror_pending && has_esr) {
 		if (!cpus_have_const_cap(ARM64_HAS_RAS_EXTN))
@@ -733,6 +740,9 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 		kvm_inject_vabt(vcpu);
 	}
 
+	if (ext_dabt_pending)
+		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index a9d25a305af5..ccdb6a051ab2 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -109,7 +109,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 
 /**
  * kvm_inject_dabt - inject a data abort into the guest
- * @vcpu: The VCPU to receive the undefined exception
+ * @vcpu: The VCPU to receive the data abort
  * @addr: The address to report in the DFAR
  *
  * It is assumed that this code is called from the VCPU thread and that the
@@ -125,7 +125,7 @@ void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr)
 
 /**
  * kvm_inject_pabt - inject a prefetch abort into the guest
- * @vcpu: The VCPU to receive the undefined exception
+ * @vcpu: The VCPU to receive the prefetch abort
  * @addr: The address to report in the DFAR
  *
  * It is assumed that this code is called from the VCPU thread and that the
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7336ee8d98d7..65db5a4257ec 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1007,6 +1007,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
 #define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
 #define KVM_CAP_ARM_NISV_TO_USER 176
+#define KVM_CAP_ARM_INJECT_EXT_DABT 177
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index e6d56f60e4b6..12064780f1d8 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -218,6 +218,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_EVENTS:
 	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
 	case KVM_CAP_ARM_NISV_TO_USER:
+	case KVM_CAP_ARM_INJECT_EXT_DABT:
 		r = 1;
 		break;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
-- 
2.18.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
