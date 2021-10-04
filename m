Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC9DC4332F
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 17:49:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D81D6124D
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 17:49:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6D81D6124D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 229B94B26D;
	Mon,  4 Oct 2021 13:49:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wr1PL5-xNphD; Mon,  4 Oct 2021 13:49:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 774BE4B2E1;
	Mon,  4 Oct 2021 13:49:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 639934B267
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 13:49:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yZcwER8jkYCh for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 13:49:06 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA5D84B2B0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 13:49:04 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id F0DD96120C;
 Mon,  4 Oct 2021 17:49:03 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mXS5G-00EhBv-AV; Mon, 04 Oct 2021 18:49:02 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/16] KVM: arm64: Advertise a capability for MMIO guard
Date: Mon,  4 Oct 2021 18:48:42 +0100
Message-Id: <20211004174849.2831548-10-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211004174849.2831548-1-maz@kernel.org>
References: <20211004174849.2831548-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com,
 dbrazdil@google.com, steven.price@arm.com, drjones@redhat.com,
 tabba@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
 Steven Price <steven.price@arm.com>,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org
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

In order for userspace to find out whether the MMIO guard is
exposed to a guest, expose a capability that says so.

We take this opportunity to make it incompatible with the NISV
option, as that would be rather counter-productive!

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c        | 29 ++++++++++++++++++-----------
 arch/arm64/kvm/hypercalls.c | 14 ++++++++++++--
 include/uapi/linux/kvm.h    |  1 +
 3 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ed9c89ec0b4f..1c9a7abe2728 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -81,32 +81,33 @@ int kvm_arch_check_processor_compat(void *opaque)
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
-	int r;
+	int r = -EINVAL;
 
 	if (cap->flags)
 		return -EINVAL;
 
+	mutex_lock(&kvm->lock);
+
 	switch (cap->cap) {
 	case KVM_CAP_ARM_NISV_TO_USER:
-		r = 0;
-		set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
-			&kvm->arch.flags);
+		/* This is incompatible with MMIO guard */
+		if (!test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &kvm->arch.flags)) {
+			r = 0;
+			set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
+				&kvm->arch.flags);
+		}
 		break;
 	case KVM_CAP_ARM_MTE:
-		mutex_lock(&kvm->lock);
-		if (!system_supports_mte() || kvm->created_vcpus) {
-			r = -EINVAL;
-		} else {
+		if (system_supports_mte() && !kvm->created_vcpus) {
 			r = 0;
 			set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
 		}
-		mutex_unlock(&kvm->lock);
 		break;
 	default:
-		r = -EINVAL;
 		break;
 	}
 
+	mutex_unlock(&kvm->lock);
 	return r;
 }
 
@@ -211,13 +212,19 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_VCPU_EVENTS:
 	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
-	case KVM_CAP_ARM_NISV_TO_USER:
 	case KVM_CAP_ARM_INJECT_EXT_DABT:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
 		r = 1;
 		break;
+	case KVM_CAP_ARM_NISV_TO_USER:
+		r = !test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &kvm->arch.flags);
+		break;
+	case KVM_CAP_ARM_MMIO_GUARD:
+		r = !test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
+			      &kvm->arch.flags);
+		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
 		return KVM_GUESTDBG_VALID_MASK;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index c39aab55ecae..e4fade6a96f6 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -59,6 +59,14 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 	val[3] = lower_32_bits(cycles);
 }
 
+static bool mmio_guard_allowed(struct kvm_vcpu *vcpu)
+{
+	return (!test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
+			  &vcpu->kvm->arch.flags) &&
+		!vcpu_mode_is_32bit(vcpu));
+
+}
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
 	u32 func_id = smccc_get_function(vcpu);
@@ -131,7 +139,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
 		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
 		/* Only advertise MMIO guard to 64bit guests */
-		if (!vcpu_mode_is_32bit(vcpu)) {
+		if (mmio_guard_allowed(vcpu)) {
 			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO);
 			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL);
 			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP);
@@ -146,10 +154,12 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 			val[0] = PAGE_SIZE;
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_ENROLL_FUNC_ID:
-		if (!vcpu_mode_is_32bit(vcpu)) {
+		mutex_lock(&vcpu->kvm->lock);
+		if (mmio_guard_allowed(vcpu)) {
 			set_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags);
 			val[0] = SMCCC_RET_SUCCESS;
 		}
+		mutex_unlock(&vcpu->kvm->lock);
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_MAP_FUNC_ID:
 		if (!vcpu_mode_is_32bit(vcpu) &&
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a067410ebea5..ef171186e7be 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_BINARY_STATS_FD 203
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
+#define KVM_CAP_ARM_MMIO_GUARD 206
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
