Return-Path: <SRS0=1Ej7=XV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7039CC4360C
	for <kvmarm@archiver.kernel.org>; Thu, 26 Sep 2019 13:06:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C252222BE
	for <kvmarm@archiver.kernel.org>; Thu, 26 Sep 2019 13:06:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C252222BE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D98A24A5A3;
	Thu, 26 Sep 2019 09:06:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GiiKSFGAb0EL; Thu, 26 Sep 2019 09:06:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A70F34A73C;
	Thu, 26 Sep 2019 09:06:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F08B44A657
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Sep 2019 07:42:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VKm5H-AW1jao for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Sep 2019 07:42:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4AF84A64D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Sep 2019 07:42:28 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FBDD1570;
 Thu, 26 Sep 2019 04:42:28 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com
 [10.169.40.35])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 06BB93F67D;
 Thu, 26 Sep 2019 04:42:23 -0700 (PDT)
From: Jianyong Wu <jianyong.wu@arm.com>
To: netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
 tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com,
 maz@kernel.org, richardcochran@gmail.com, Mark.Rutland@arm.com,
 Will.Deacon@arm.com, suzuki.poulose@arm.com
Subject: [RFC PATCH v4 1/5] psci: Export psci_ops.conduit symbol as modules
 will use it.
Date: Thu, 26 Sep 2019 19:42:08 +0800
Message-Id: <20190926114212.5322-2-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190926114212.5322-1-jianyong.wu@arm.com>
References: <20190926114212.5322-1-jianyong.wu@arm.com>
X-Mailman-Approved-At: Thu, 26 Sep 2019 09:06:20 -0400
Cc: justin.he@arm.com, kvm@vger.kernel.org, jianyong.wu@arm.com,
 linux-kernel@vger.kernel.org, nd@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

If arm_smccc_1_1_invoke used in modules, psci_ops.conduit should
be export.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 drivers/firmware/psci/psci.c | 6 ++++++
 include/linux/arm-smccc.h    | 2 +-
 include/linux/psci.h         | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index f82ccd39a913..35c4eaab1451 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -212,6 +212,12 @@ static unsigned long psci_migrate_info_up_cpu(void)
 			      0, 0, 0);
 }
 
+enum psci_conduit psci_get_conduit(void)
+{
+	return psci_ops.conduit;
+}
+EXPORT_SYMBOL(psci_get_conduit);
+
 static void set_conduit(enum psci_conduit conduit)
 {
 	switch (conduit) {
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 552cbd49abe8..a6e4d3e3d10a 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -357,7 +357,7 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
  * The return value also provides the conduit that was used.
  */
 #define arm_smccc_1_1_invoke(...) ({					\
-		int method = psci_ops.conduit;				\
+		int method = psci_get_conduit();			\
 		switch (method) {					\
 		case PSCI_CONDUIT_HVC:					\
 			arm_smccc_1_1_hvc(__VA_ARGS__);			\
diff --git a/include/linux/psci.h b/include/linux/psci.h
index a8a15613c157..e5cedc986049 100644
--- a/include/linux/psci.h
+++ b/include/linux/psci.h
@@ -42,6 +42,7 @@ struct psci_operations {
 	enum smccc_version smccc_version;
 };
 
+extern enum psci_conduit psci_get_conduit(void);
 extern struct psci_operations psci_ops;
 
 #if defined(CONFIG_ARM_PSCI_FW)
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
