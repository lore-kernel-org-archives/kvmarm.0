Return-Path: <SRS0=dNnP=JG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3E9C433ED
	for <kvmarm@archiver.kernel.org>; Fri,  9 Apr 2021 15:21:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F22D0610D1
	for <kvmarm@archiver.kernel.org>; Fri,  9 Apr 2021 15:21:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F22D0610D1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CEDB4BB90;
	Fri,  9 Apr 2021 11:21:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QHLYv-pfEUEn; Fri,  9 Apr 2021 11:21:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F92D4BB93;
	Fri,  9 Apr 2021 11:21:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D56E4BB8E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Apr 2021 11:21:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SfsZx3fvY4XA for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Apr 2021 11:21:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EEA44BC9A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Apr 2021 11:21:36 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 264A51FB;
 Fri,  9 Apr 2021 08:21:31 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 21E773F694;
 Fri,  9 Apr 2021 08:21:30 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/2] KVM: arm64: Hide SPE from guests
Date: Fri,  9 Apr 2021 16:21:52 +0100
Message-Id: <20210409152154.198566-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
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

This was part of the KVM SPE series that I posted some time ago [1]. The
series didn't get too much attention, so I've decided to send this
fix/cleanup/improvement separately, to make it easier to review.

I've split the original patch into two because it makes more sense to me
this way, but I'm not opposed to squashing the series back into a single
patch if that is preferred.

Based on v5.12-rc6.

[1] https://www.spinics.net/lists/kvm-arm/msg42962.html

Alexandru Elisei (2):
  KVM: arm64: Don't print warning when trapping SPE registers
  KVM: arm64: Don't advertise FEAT_SPE to guests

 arch/arm64/include/asm/sysreg.h |  2 ++
 arch/arm64/kvm/sys_regs.c       | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
