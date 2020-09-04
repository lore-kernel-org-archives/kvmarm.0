Return-Path: <SRS0=jshR=CN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5999C28E83
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 09:29:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 578E820770
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 09:29:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 578E820770
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 117124B166;
	Fri,  4 Sep 2020 05:29:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6VMtNpzELlWn; Fri,  4 Sep 2020 05:29:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE8FC4B33D;
	Fri,  4 Sep 2020 05:29:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3212C4B166
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 05:29:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jOSS8KuNKI2z for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2020 05:29:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 271CC4B341
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 05:29:17 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDA9512FC;
 Fri,  4 Sep 2020 02:29:16 -0700 (PDT)
Received: from localhost.localdomain (entos-thunderx2-desktop.shanghai.arm.com
 [10.169.212.215])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1E3EA3F66F;
 Fri,  4 Sep 2020 02:29:10 -0700 (PDT)
From: Jianyong Wu <jianyong.wu@arm.com>
To: netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
 tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com,
 maz@kernel.org, richardcochran@gmail.com, Mark.Rutland@arm.com,
 will@kernel.org, suzuki.poulose@arm.com, steven.price@arm.com
Subject: [PATCH v14 03/10] smccc: Export smccc conduit get helper.
Date: Fri,  4 Sep 2020 17:27:37 +0800
Message-Id: <20200904092744.167655-4-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200904092744.167655-1-jianyong.wu@arm.com>
References: <20200904092744.167655-1-jianyong.wu@arm.com>
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

Export arm_smccc_1_1_get_conduit then modules can use smccc helper which
adopts it.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 drivers/firmware/smccc/smccc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/smccc/smccc.c b/drivers/firmware/smccc/smccc.c
index 4e80921ee212..d26d3512b145 100644
--- a/drivers/firmware/smccc/smccc.c
+++ b/drivers/firmware/smccc/smccc.c
@@ -24,6 +24,7 @@ enum arm_smccc_conduit arm_smccc_1_1_get_conduit(void)
 
 	return smccc_conduit;
 }
+EXPORT_SYMBOL_GPL(arm_smccc_1_1_get_conduit);
 
 u32 arm_smccc_get_version(void)
 {
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
