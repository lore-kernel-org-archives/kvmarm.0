Return-Path: <SRS0=SKDP=2A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FDFFC43603
	for <kvmarm@archiver.kernel.org>; Tue, 10 Dec 2019 03:40:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BFCCF2077B
	for <kvmarm@archiver.kernel.org>; Tue, 10 Dec 2019 03:40:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFCCF2077B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 740FD4AF1D;
	Mon,  9 Dec 2019 22:40:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wl-Z8KVvZnCR; Mon,  9 Dec 2019 22:40:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AC804AF24;
	Mon,  9 Dec 2019 22:40:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B5CA4AF24
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Dec 2019 22:40:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f7Ob1c1qMN4p for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Dec 2019 22:40:46 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC1A74AF0E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Dec 2019 22:40:45 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 848601045;
 Mon,  9 Dec 2019 19:40:45 -0800 (PST)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com
 [10.169.40.35])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C032A3F52E;
 Mon,  9 Dec 2019 19:40:39 -0800 (PST)
From: Jianyong Wu <jianyong.wu@arm.com>
To: netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
 tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com,
 maz@kernel.org, richardcochran@gmail.com, Mark.Rutland@arm.com,
 will@kernel.org, suzuki.poulose@arm.com, steven.price@arm.com
Subject: [RFC PATCH v9 1/8] arm/arm64: smccc/psci: add
 arm_smccc_1_1_get_conduit()
Date: Tue, 10 Dec 2019 11:40:19 +0800
Message-Id: <20191210034026.45229-2-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191210034026.45229-1-jianyong.wu@arm.com>
References: <20191210034026.45229-1-jianyong.wu@arm.com>
Cc: justin.he@arm.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
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

From: Mark Rutland <mark.rutland@arm.com>

SMCCC callers are currently amassing a collection of enums for the SMCCC
conduit, and are having to dig into the PSCI driver's internals in order
to figure out what to do.

Let's clean this up, with common SMCCC_CONDUIT_* definitions, and an
arm_smccc_1_1_get_conduit() helper that abstracts the PSCI driver's
internal state.

We can kill off the PSCI_CONDUIT_* definitions once we've migrated users
over to the new interface.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 drivers/firmware/psci/psci.c | 15 +++++++++++++++
 include/linux/arm-smccc.h    | 16 ++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index f82ccd39a913..5f31f1bea1af 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -57,6 +57,21 @@ struct psci_operations psci_ops = {
 	.smccc_version = SMCCC_VERSION_1_0,
 };
 
+enum arm_smccc_conduit arm_smccc_1_1_get_conduit(void)
+{
+	if (psci_ops.smccc_version < SMCCC_VERSION_1_1)
+		return SMCCC_CONDUIT_NONE;
+
+	switch (psci_ops.conduit) {
+	case PSCI_CONDUIT_SMC:
+		return SMCCC_CONDUIT_SMC;
+	case PSCI_CONDUIT_HVC:
+		return SMCCC_CONDUIT_HVC;
+	default:
+		return SMCCC_CONDUIT_NONE;
+	}
+}
+
 typedef unsigned long (psci_fn)(unsigned long, unsigned long,
 				unsigned long, unsigned long);
 static psci_fn *invoke_psci_fn;
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 552cbd49abe8..701fa1da6b4a 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -107,6 +107,22 @@
 
 #include <linux/linkage.h>
 #include <linux/types.h>
+
+enum arm_smccc_conduit {
+	SMCCC_CONDUIT_NONE,
+	SMCCC_CONDUIT_SMC,
+	SMCCC_CONDUIT_HVC,
+};
+
+/**
+ * arm_smccc_1_1_get_conduit()
+ *
+ * Returns the conduit to be used for SMCCCv1.1 or later.
+ *
+ * When SMCCCv1.1 is not present, returns SMCCC_CONDUIT_NONE.
+ */
+enum arm_smccc_conduit arm_smccc_1_1_get_conduit(void);
+
 /**
  * struct arm_smccc_res - Result from SMC/HVC call
  * @a0-a3 result values from registers 0 to 3
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
