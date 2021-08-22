Return-Path: <SRS0=jhc2=NN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA60C4338F
	for <kvmarm@archiver.kernel.org>; Sun, 22 Aug 2021 15:25:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9C27061262
	for <kvmarm@archiver.kernel.org>; Sun, 22 Aug 2021 15:25:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9C27061262
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EBE74B1F7;
	Sun, 22 Aug 2021 11:25:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Fa5zzb8aPQOf; Sun, 22 Aug 2021 11:25:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D760D4B1F9;
	Sun, 22 Aug 2021 11:25:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 793CB4B1F7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Aug 2021 11:25:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ihq-h+sd2NUV for <kvmarm@lists.cs.columbia.edu>;
 Sun, 22 Aug 2021 11:25:36 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7FF584B1B6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Aug 2021 11:25:36 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B399561261;
 Sun, 22 Aug 2021 15:25:35 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mHpLq-006VTo-3A; Sun, 22 Aug 2021 16:25:34 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 3/3] kvmtool: arm64: Configure VM with the minimal required
 IPA space
Date: Sun, 22 Aug 2021 16:25:26 +0100
Message-Id: <20210822152526.1291918-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210822152526.1291918-1-maz@kernel.org>
References: <20210822152526.1291918-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
 alexandru.elisei@arm.com, will@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Andre Przywara <andre.przywara@arm.com>, kernel-team@android.com,
 Will Deacon <will@kernel.org>
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

There is some value in keeping the IPA space small, as it reduces
the size of the stage-2 page tables.

Let's compute the required space at VM creation time, and inform
the kernel of our requirements.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arm/aarch64/kvm.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index d03a27f2..4e66a22e 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -3,6 +3,7 @@
 #include <asm/image.h>
 
 #include <linux/byteorder.h>
+#include <kvm/util.h>
 
 /*
  * Return the TEXT_OFFSET value that the guest kernel expects. Note
@@ -59,5 +60,22 @@ int kvm__arch_get_ipa_limit(struct kvm *kvm)
 
 int kvm__get_vm_type(struct kvm *kvm)
 {
-	return KVM_VM_TYPE_ARM_IPA_SIZE(kvm__arch_get_ipa_limit(kvm));
+	unsigned int ipa_bits, max_ipa_bits;
+	unsigned long max_ipa;
+
+	/* If we're running on an old kernel, use 0 as the VM type */
+	max_ipa_bits = kvm__arch_get_ipa_limit(kvm);
+	if (!max_ipa_bits)
+		return 0;
+
+	/* Otherwise, compute the minimal required IPA size */
+	max_ipa = ARM_MEMORY_AREA + kvm->cfg.ram_size - 1;
+	ipa_bits = max(32, fls_long(max_ipa));
+	pr_debug("max_ipa %lx ipa_bits %d max_ipa_bits %d",
+		 max_ipa, ipa_bits, max_ipa_bits);
+
+	if (ipa_bits > max_ipa_bits)
+		die("Memory too large for this system (needs %d bits, %d available)", ipa_bits, max_ipa_bits);
+
+	return KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
 }
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
