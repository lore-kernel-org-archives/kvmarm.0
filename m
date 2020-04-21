Return-Path: <SRS0=wisL=6F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA38C54FCC
	for <kvmarm@archiver.kernel.org>; Tue, 21 Apr 2020 03:24:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8995E2084D
	for <kvmarm@archiver.kernel.org>; Tue, 21 Apr 2020 03:24:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8995E2084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4306F4B106;
	Mon, 20 Apr 2020 23:24:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vrjDDOpmrGbn; Mon, 20 Apr 2020 23:24:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C386F4B14D;
	Mon, 20 Apr 2020 23:24:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 258884B106
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2020 23:24:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nJUqNe+O5TBi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Apr 2020 23:24:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E506F4B149
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2020 23:24:21 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96733C14;
 Mon, 20 Apr 2020 20:24:21 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com
 [10.169.40.35])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6A4193F6CF;
 Mon, 20 Apr 2020 20:24:15 -0700 (PDT)
From: Jianyong Wu <jianyong.wu@arm.com>
To: netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
 tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com,
 maz@kernel.org, richardcochran@gmail.com, Mark.Rutland@arm.com,
 will@kernel.org, suzuki.poulose@arm.com, steven.price@arm.com
Subject: [RFC PATCH v11 8/9] arm64: add mechanism to let user choose which
 counter to return
Date: Tue, 21 Apr 2020 11:23:03 +0800
Message-Id: <20200421032304.26300-9-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200421032304.26300-1-jianyong.wu@arm.com>
References: <20200421032304.26300-1-jianyong.wu@arm.com>
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

In general, vm inside will use virtual counter compered with host use
phyical counter. But in some special scenarios, like nested virtualization,
phyical counter maybe used by vm. A interface added in ptp_kvm driver to
offer a mechanism to let user choose which counter should be return from
host.
To use this feature, you should call PTP_EXTTS_REQUEST(2) ioctl with flag
set bit PTP_KVM_ARM_PHY_COUNTER in its argument then call
PTP_SYS_OFFSET_PRECISE(2) ioctl to get the cross timestamp and phyical
counter will return. If the bit not set or no call for PTP_EXTTS_REQUEST2,
virtual counter will return by default.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
---
 drivers/clocksource/arm_arch_timer.c | 11 ++++++++++-
 drivers/ptp/ptp_chardev.c            |  8 +++++++-
 drivers/ptp/ptp_kvm_common.c         |  7 ++++---
 include/uapi/linux/ptp_clock.h       |  4 +++-
 4 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 47d69b3f2d9a..52f629d9c561 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -1650,7 +1650,16 @@ int kvm_arch_ptp_get_crosststamp(unsigned long *cycle, struct timespec64 *ts,
 	struct arm_smccc_res hvc_res;
 	ktime_t ktime_overall;
 
-	arm_smccc_1_1_invoke(ARM_SMCCC_HYP_KVM_PTP_FUNC_ID, &hvc_res);
+	/*
+	 * an argument will be passed by a0 to determine weather virtual
+	 * counter or phyical counter should be passed back.
+	 */
+	if (*ctx)
+		arm_smccc_1_1_invoke(ARM_SMCCC_HYP_KVM_PTP_FUNC_ID,
+				     ARM_SMCCC_HYP_KVM_PTP_PHY, &hvc_res);
+	else
+		arm_smccc_1_1_invoke(ARM_SMCCC_HYP_KVM_PTP_FUNC_ID,
+				     ARM_SMCCC_HYP_KVM_PTP_VIRT, &hvc_res);
 	if ((int)(hvc_res.a0) < 0)
 		return -EOPNOTSUPP;
 
diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index fef72f29f3c8..505ed7eb0ca5 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -122,6 +122,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 	struct ptp_pin_desc pd;
 	struct timespec64 ts;
 	int enable, err = 0;
+	static long flag;
 
 	switch (cmd) {
 
@@ -149,6 +150,11 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 			err = -EFAULT;
 			break;
 		}
+		/*
+		 * Tell driver to call for physical counter.
+		 * This is only for arm.
+		 */
+		flag = req.extts.flags & PTP_KVM_ARM_PHY_COUNTER;
 		if (cmd == PTP_EXTTS_REQUEST2) {
 			/* Tell the drivers to check the flags carefully. */
 			req.extts.flags |= PTP_STRICT_FLAGS;
@@ -235,7 +241,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 			err = -EOPNOTSUPP;
 			break;
 		}
-		err = ptp->info->getcrosststamp(ptp->info, &xtstamp, NULL);
+		err = ptp->info->getcrosststamp(ptp->info, &xtstamp, &flag);
 		if (err)
 			break;
 
diff --git a/drivers/ptp/ptp_kvm_common.c b/drivers/ptp/ptp_kvm_common.c
index 4fdd8ab11a28..39367e230176 100644
--- a/drivers/ptp/ptp_kvm_common.c
+++ b/drivers/ptp/ptp_kvm_common.c
@@ -36,7 +36,7 @@ static int ptp_kvm_get_time_fn(ktime_t *device_time,
 	spin_lock(&kvm_ptp_lock);
 
 	preempt_disable_notrace();
-	ret = kvm_arch_ptp_get_crosststamp(&cycle, &tspec, &cs);
+	ret = kvm_arch_ptp_get_crosststamp(&cycle, &tspec, &cs, ctx);
 	if (ret != 0) {
 		pr_err_ratelimited("clock pairing hypercall ret %lu\n", ret);
 		spin_unlock(&kvm_ptp_lock);
@@ -57,9 +57,10 @@ static int ptp_kvm_get_time_fn(ktime_t *device_time,
 }
 
 static int ptp_kvm_getcrosststamp(struct ptp_clock_info *ptp,
-				  struct system_device_crosststamp *xtstamp)
+				  struct system_device_crosststamp *xtstamp,
+				  long *flag)
 {
-	return get_device_system_crosststamp(ptp_kvm_get_time_fn, NULL,
+	return get_device_system_crosststamp(ptp_kvm_get_time_fn, flag,
 					     NULL, xtstamp);
 }
 
diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index 9dc9d0079e98..71e388a82244 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -32,6 +32,7 @@
 #define PTP_RISING_EDGE    (1<<1)
 #define PTP_FALLING_EDGE   (1<<2)
 #define PTP_STRICT_FLAGS   (1<<3)
+#define PTP_KVM_ARM_PHY_COUNTER (1<<4)
 #define PTP_EXTTS_EDGES    (PTP_RISING_EDGE | PTP_FALLING_EDGE)
 
 /*
@@ -40,7 +41,8 @@
 #define PTP_EXTTS_VALID_FLAGS	(PTP_ENABLE_FEATURE |	\
 				 PTP_RISING_EDGE |	\
 				 PTP_FALLING_EDGE |	\
-				 PTP_STRICT_FLAGS)
+				 PTP_STRICT_FLAGS |	\
+				 PTP_KVM_ARM_PHY_COUNTER)
 
 /*
  * flag fields valid for the original PTP_EXTTS_REQUEST ioctl.
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
