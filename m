Return-Path: <SRS0=HUCa=TW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C30E6C282CE
	for <kvmarm@archiver.kernel.org>; Wed, 22 May 2019 17:47:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4EEF520645
	for <kvmarm@archiver.kernel.org>; Wed, 22 May 2019 17:47:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4EEF520645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97ABC4A4E6;
	Wed, 22 May 2019 13:47:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 18Ag78H9xUOV; Wed, 22 May 2019 13:47:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 603E74A417;
	Wed, 22 May 2019 13:47:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C1294A417
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 May 2019 13:47:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l5JKX9XO7GnD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 May 2019 13:47:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B6904A3A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 May 2019 13:47:21 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 687B4341;
 Wed, 22 May 2019 10:47:20 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E1B4F3F5AF;
 Wed, 22 May 2019 10:47:18 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 0/2] Move __hyp_text code under no-asan Makefiles
Date: Wed, 22 May 2019 18:47:03 +0100
Message-Id: <20190522174705.236469-1-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Marc Zyngier <marc.zyngier@arm.com>
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

The fancy new pmu code added its __hyp_text code in part of the tree that
doesn't get covered by the no-asan/no-kcov kconfig decorations.
This shows up as a hyp-panic on v8.0 hardware when the host kernel is
built with debug options like kasan.

This same bug has been living happily in the aarch32 emulation code
since v4.9. (commit 8cebe750c4d9a "arm64: KVM: Make kvm_skip_instr32
available to HYP"). Patch 2 has the two relevant fixes tag, but won't
apply cleanly before v4.19 due to the churn.

Fix them both by shuffling the code around.

--
Changes since v1:
 * Made the two functions static in patch 1, removed the header entries.


Thanks,

James Morse (2):
  KVM: arm64: Move pmu hyp code under hyp's Makefile to avoid
    instrumentation
  KVM: arm/arm64: Move cc/it checks under hyp's Makefile to avoid
    instrumentation

 arch/arm/kvm/hyp/Makefile         |   1 +
 arch/arm64/include/asm/kvm_host.h |   3 -
 arch/arm64/kvm/hyp/Makefile       |   1 +
 arch/arm64/kvm/hyp/switch.c       |  39 +++++++++
 arch/arm64/kvm/pmu.c              |  38 ---------
 virt/kvm/arm/aarch32.c            | 121 --------------------------
 virt/kvm/arm/hyp/aarch32.c        | 136 ++++++++++++++++++++++++++++++
 7 files changed, 177 insertions(+), 162 deletions(-)
 create mode 100644 virt/kvm/arm/hyp/aarch32.c

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
