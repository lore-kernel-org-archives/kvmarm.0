Return-Path: <SRS0=jhc2=NN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F21C432BE
	for <kvmarm@archiver.kernel.org>; Sun, 22 Aug 2021 14:45:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5F36861246
	for <kvmarm@archiver.kernel.org>; Sun, 22 Aug 2021 14:45:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5F36861246
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05BA74B1AF;
	Sun, 22 Aug 2021 10:45:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hq13ZOWxinlw; Sun, 22 Aug 2021 10:45:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 238E44B1FD;
	Sun, 22 Aug 2021 10:45:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D0C14B1A9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Aug 2021 10:45:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aoGIQfycbEoi for <kvmarm@lists.cs.columbia.edu>;
 Sun, 22 Aug 2021 10:45:02 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F6E74B1ED
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Aug 2021 10:45:02 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B277A61284;
 Sun, 22 Aug 2021 14:45:01 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mHoia-006VES-4P; Sun, 22 Aug 2021 15:45:00 +0100
From: Marc Zyngier <maz@kernel.org>
To: qemu-devel@nongnu.org
Subject: [PATCH 3/3] docs/system/arm/virt: Fix documentation for the 'highmem'
 option
Date: Sun, 22 Aug 2021 15:44:41 +0100
Message-Id: <20210822144441.1290891-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210822144441.1290891-1-maz@kernel.org>
References: <20210822144441.1290891-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: qemu-devel@nongnu.org, drjones@redhat.com,
 eric.auger@redhat.com, peter.maydell@linaro.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

The documentation for the 'highmem' option indicates that it controls
the placement of both devices and RAM. The actual behaviour of QEMU
seems to be that RAM is allowed to go beyond the 4GiB limit, and
that only devices are constraint by this option.

Align the documentation with the actual behaviour.

Cc: Andrew Jones <drjones@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 docs/system/arm/virt.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/docs/system/arm/virt.rst b/docs/system/arm/virt.rst
index 59acf0eeaf..e206e7565d 100644
--- a/docs/system/arm/virt.rst
+++ b/docs/system/arm/virt.rst
@@ -86,9 +86,9 @@ mte
   Arm Memory Tagging Extensions. The default is ``off``.
 
 highmem
-  Set ``on``/``off`` to enable/disable placing devices and RAM in physical
-  address space above 32 bits. The default is ``on`` for machine types
-  later than ``virt-2.12``.
+  Set ``on``/``off`` to enable/disable placing devices in physical address
+  space above 32 bits. RAM in excess of 3GiB will always be placed above
+  32 bits. The default is ``on`` for machine types later than ``virt-2.12``.
 
 gic-version
   Specify the version of the Generic Interrupt Controller (GIC) to provide.
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
