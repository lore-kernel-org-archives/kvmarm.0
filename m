Return-Path: <SRS0=tvNx=YR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E667CA9EAF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 11:03:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 37B3B2166E
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 11:03:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37B3B2166E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E391B4A529;
	Thu, 24 Oct 2019 07:03:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nHMpO+Z2twXQ; Thu, 24 Oct 2019 07:03:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDF6F4A64A;
	Thu, 24 Oct 2019 07:03:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 214C94A5EE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 07:03:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sjbxEkGkrrT7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Oct 2019 07:03:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C85634A618
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 07:03:01 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8926C8E6;
 Thu, 24 Oct 2019 04:03:01 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com
 [10.169.40.35])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6B6363F71A;
 Thu, 24 Oct 2019 04:02:56 -0700 (PDT)
From: Jianyong Wu <jianyong.wu@arm.com>
To: netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
 tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com,
 maz@kernel.org, richardcochran@gmail.com, Mark.Rutland@arm.com,
 will@kernel.org, suzuki.poulose@arm.com
Subject: [RFC PATCH v6 7/7] kvm: arm64: Add capability check extension for
 ptp_kvm
Date: Thu, 24 Oct 2019 19:02:09 +0800
Message-Id: <20191024110209.21328-8-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191024110209.21328-1-jianyong.wu@arm.com>
References: <20191024110209.21328-1-jianyong.wu@arm.com>
Cc: justin.he@arm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 nd@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Let userspace check if there is kvm ptp service in host.
before VMs migrate to a another host, VMM may check if this
cap is available to determine the migration behaviour.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
---
 drivers/clocksource/arm_arch_timer.c | 4 ++--
 drivers/ptp/ptp_kvm_arm64.c          | 1 -
 include/uapi/linux/kvm.h             | 1 +
 virt/kvm/arm/arm.c                   | 1 +
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index fe0ed8acfa33..0ae673193bee 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -1639,7 +1639,7 @@ TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_timer_acpi_init);
 
 #if IS_ENABLED(CONFIG_PTP_1588_CLOCK_KVM)
 #include <linux/arm-smccc.h>
-int kvm_arch_ptp_get_clock_fn(unsigned long *cycle, struct timespec64 *ts,
+int kvm_arch_ptp_get_crosststamp(unsigned long *cycle, struct timespec64 *ts,
 			      struct clocksource **cs)
 {
 	struct arm_smccc_res hvc_res;
@@ -1656,5 +1656,5 @@ int kvm_arch_ptp_get_clock_fn(unsigned long *cycle, struct timespec64 *ts,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_arch_ptp_get_clock_fn);
+EXPORT_SYMBOL_GPL(kvm_arch_ptp_get_crosststamp);
 #endif
diff --git a/drivers/ptp/ptp_kvm_arm64.c b/drivers/ptp/ptp_kvm_arm64.c
index 7c697f20904f..f3f957117865 100644
--- a/drivers/ptp/ptp_kvm_arm64.c
+++ b/drivers/ptp/ptp_kvm_arm64.c
@@ -30,7 +30,6 @@ int kvm_arch_ptp_init(void)
 int kvm_arch_ptp_get_clock_generic(struct timespec64 *ts,
 				   struct arm_smccc_res *hvc_res)
 {
-	u64 ns;
 	ktime_t ktime_overall;
 
 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2fe12b40d503..a0bff6002bd9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -993,6 +993,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_SVE 170
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
+#define KVM_CAP_ARM_KVM_PTP 173
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index bd5c55916d0d..80999985160b 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -201,6 +201,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MP_STATE:
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_VCPU_EVENTS:
+	case KVM_CAP_ARM_KVM_PTP:
 		r = 1;
 		break;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
