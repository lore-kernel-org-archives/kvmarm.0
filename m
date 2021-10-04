Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C21C43217
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 17:49:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 258B3611EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 17:49:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 258B3611EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF9C94B2A0;
	Mon,  4 Oct 2021 13:49:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8r8UZt8TVGqa; Mon,  4 Oct 2021 13:49:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 629494B2BC;
	Mon,  4 Oct 2021 13:49:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F0374B29B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 13:49:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1PHhANvE+jgG for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 13:49:03 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 530E94B22E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 13:49:03 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 23135611EF;
 Mon,  4 Oct 2021 17:49:03 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mXS5F-00EhBv-IC; Mon, 04 Oct 2021 18:49:01 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/16] KVM: arm64: Wire MMIO guard hypercalls
Date: Mon,  4 Oct 2021 18:48:40 +0100
Message-Id: <20211004174849.2831548-8-maz@kernel.org>
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

Plumb in the hypercall interface to allow a guest to discover,
enroll, map and unmap MMIO regions.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hypercalls.c | 28 ++++++++++++++++++++++++++++
 include/linux/arm-smccc.h   | 28 ++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 30da78f72b3b..c39aab55ecae 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -5,6 +5,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
 
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_psci.h>
@@ -129,10 +130,37 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
 		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
+		/* Only advertise MMIO guard to 64bit guests */
+		if (!vcpu_mode_is_32bit(vcpu)) {
+			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO);
+			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL);
+			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP);
+			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP);
+		}
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		kvm_ptp_get_time(vcpu, val);
 		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_INFO_FUNC_ID:
+		if (!vcpu_mode_is_32bit(vcpu))
+			val[0] = PAGE_SIZE;
+		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_ENROLL_FUNC_ID:
+		if (!vcpu_mode_is_32bit(vcpu)) {
+			set_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags);
+			val[0] = SMCCC_RET_SUCCESS;
+		}
+		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_MAP_FUNC_ID:
+		if (!vcpu_mode_is_32bit(vcpu) &&
+		    kvm_install_ioguard_page(vcpu, vcpu_get_reg(vcpu, 1)))
+			val[0] = SMCCC_RET_SUCCESS;
+		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_UNMAP_FUNC_ID:
+		if (!vcpu_mode_is_32bit(vcpu) &&
+		    kvm_remove_ioguard_page(vcpu, vcpu_get_reg(vcpu, 1)))
+			val[0] = SMCCC_RET_SUCCESS;
+		break;
 	case ARM_SMCCC_TRNG_VERSION:
 	case ARM_SMCCC_TRNG_FEATURES:
 	case ARM_SMCCC_TRNG_GET_UUID:
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 7d1cabe15262..4aab2078d8d3 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -107,6 +107,10 @@
 /* KVM "vendor specific" services */
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
 #define ARM_SMCCC_KVM_FUNC_PTP			1
+#define ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO	2
+#define ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL	3
+#define ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP	4
+#define ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP	5
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -133,6 +137,30 @@
 #define KVM_PTP_VIRT_COUNTER			0
 #define KVM_PTP_PHYS_COUNTER			1
 
+#define ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_INFO_FUNC_ID		\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_ENROLL_FUNC_ID		\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_MAP_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_UNMAP_FUNC_ID		\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP)
+
 /* Paravirtualised time calls (defined by ARM DEN0057A) */
 #define ARM_SMCCC_HV_PV_TIME_FEATURES				\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
