Return-Path: <SRS0=RYKq=DB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B79EC2D0E2
	for <kvmarm@archiver.kernel.org>; Thu, 24 Sep 2020 12:36:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E13B3221EB
	for <kvmarm@archiver.kernel.org>; Thu, 24 Sep 2020 12:36:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E13B3221EB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 742294B346;
	Thu, 24 Sep 2020 08:36:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QSwcIosHFUbo; Thu, 24 Sep 2020 08:36:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DF554B361;
	Thu, 24 Sep 2020 08:36:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAD5C4B2D7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Sep 2020 08:36:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DqLE2qrUQL+z for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Sep 2020 08:36:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3EC04B230
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Sep 2020 08:36:36 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4876F152B;
 Thu, 24 Sep 2020 05:36:36 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4032D3F73B;
 Thu, 24 Sep 2020 05:36:35 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 2/2] KVM: arm64: Match PMU error code descriptions with
 error conditions
Date: Thu, 24 Sep 2020 13:37:31 +0100
Message-Id: <20200924123731.268177-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200924123731.268177-1-alexandru.elisei@arm.com>
References: <20200924123731.268177-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: maz@kernel.org
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

Update the description of the PMU KVM_{GET, SET}_DEVICE_ATTR error codes
to be a better match for the code that returns them.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 96d6cf77cb1e..8c24411ece2e 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -26,8 +26,9 @@ Returns:
 	 =======  ========================================================
 	 -EBUSY   The PMU overflow interrupt is already set
 	 -EFAULT  Error reading interrupt number
-	 -ENXIO   The overflow interrupt not set when attempting to get it
-	 -ENODEV  PMUv3 not supported
+	 -ENXIO   PMUv3 not supported or the overflow interrupt not set
+		  when attempting to get it
+	 -ENODEV  KVM_ARM_VCPU_PMU_V3 feature missing from VCPU
 	 -EINVAL  Invalid PMU overflow interrupt number supplied or
 		  trying to set the IRQ number without using an in-kernel
 		  irqchip.
@@ -48,8 +49,8 @@ Returns:
 	 =======  ======================================================
 	 -EEXIST  Interrupt number already used
 	 -ENODEV  PMUv3 not supported or GIC not initialized
-	 -ENXIO   PMUv3 not properly configured or in-kernel irqchip not
-		  configured as required prior to calling this attribute
+	 -ENXIO   PMUv3 not supported, missing VCPU feature or interrupt
+		  number not set
 	 -EBUSY   PMUv3 already initialized
 	 =======  ======================================================
 
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
