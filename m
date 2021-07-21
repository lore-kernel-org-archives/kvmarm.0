Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36756C12002
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 09:20:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A9FA06120E
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 09:20:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9FA06120E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27D114A534;
	Wed, 21 Jul 2021 05:20:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aY99Z7n6fyg1; Wed, 21 Jul 2021 05:20:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E81A94B0A3;
	Wed, 21 Jul 2021 05:20:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7CA64A534
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 05:20:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id njd0WXPVS3-Z for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 05:20:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E2D84A32E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 05:20:31 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3679731B;
 Wed, 21 Jul 2021 02:20:31 -0700 (PDT)
Received: from entos-thunderx2-desktop.shanghai.arm.com
 (entos-thunderx2-desktop.shanghai.arm.com [10.169.212.208])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 12F7A3F694;
 Wed, 21 Jul 2021 02:20:27 -0700 (PDT)
From: Jianyong Wu <jianyong.wu@arm.com>
To: maz@kernel.org, james.morse@arm.com, andre.przywara@arm.com,
 lushenming@huawei.com
Subject: [PATCH] doc/arm: take care restore order of GICR_* in ITS restore
Date: Wed, 21 Jul 2021 17:20:19 +0800
Message-Id: <20210721092019.144088-1-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
Cc: justin.he@arm.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

When restore GIC/ITS, GICR_CTLR must be restored after GICR_PROPBASER
and GICR_PENDBASER. That is important, as both of GICR_PROPBASER and
GICR_PENDBASER will fail to be loaded when lpi has enabled yet in
GICR_CTLR. Keep the restore order above will avoid that issue.
Shout it out at the doc is very helpful that may avoid lots of debug work.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 Documentation/virt/kvm/devices/arm-vgic-its.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-its.rst b/Documentation/virt/kvm/devices/arm-vgic-its.rst
index d257eddbae29..6b36de6937f8 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-its.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-its.rst
@@ -126,7 +126,8 @@ ITS Restore Sequence:
 The following ordering must be followed when restoring the GIC and the ITS:
 
 a) restore all guest memory and create vcpus
-b) restore all redistributors
+b) restore all redistributors:
+   make sure restore GICR_CTLR after GICR_PROPBASER and GICR_PENDBASER
 c) provide the ITS base address
    (KVM_DEV_ARM_VGIC_GRP_ADDR)
 d) restore the ITS in the following order:
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
