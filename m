Return-Path: <SRS0=vP85=YS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44982CA9EA0
	for <kvmarm@archiver.kernel.org>; Fri, 25 Oct 2019 14:52:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C292721872
	for <kvmarm@archiver.kernel.org>; Fri, 25 Oct 2019 14:52:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C292721872
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E9F74A52F;
	Fri, 25 Oct 2019 10:52:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id axOEMFlGxz3h; Fri, 25 Oct 2019 10:52:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32BD84A5A1;
	Fri, 25 Oct 2019 10:52:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AD4A4A52F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Oct 2019 10:52:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GQOp2EPHMw-L for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Oct 2019 10:52:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 601774A51C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Oct 2019 10:52:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 128AA28;
 Fri, 25 Oct 2019 07:52:25 -0700 (PDT)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B1CC53F71A;
 Fri, 25 Oct 2019 07:52:23 -0700 (PDT)
From: Andrew Murray <andrew.murray@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v1 0/3] arm64: perf: Add support for ARMv8.5-PMU 64-bit
 counters
Date: Fri, 25 Oct 2019 15:52:16 +0100
Message-Id: <20191025145219.28350-1-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

At present ARMv8 event counters are limited to 32-bits, though by
using the CHAIN event it's possible to combine adjacent counters to
achieve 64-bits. The perf config1:0 bit can be set to use such a
configuration.

With the introduction of ARMv8.5-PMU support, all event counters can
now be used as 64-bit counters. Let's add support for 64-bit event
counters.

As KVM doesn't yet support 64-bit event counters, we also trap
and emulate the Debug Feature Registers to limit the PMU version a
guest sees to PMUv3 for ARMv8.4.

Tested by running the following perf command on both guest and host
and ensuring that the figures are very similar:

perf stat -e armv8_pmuv3/inst_retired,long=1/ \
          -e armv8_pmuv3/inst_retired,long=0/ -e cycles


Andrew Murray (3):
  arm64: cpufeature: Extract capped fields
  KVM: arm64: limit PMU version to ARMv8.4
  arm64: perf: Add support for ARMv8.5-PMU 64-bit counters

 arch/arm64/include/asm/cpufeature.h | 15 +++++
 arch/arm64/include/asm/perf_event.h |  3 +-
 arch/arm64/include/asm/sysreg.h     |  4 ++
 arch/arm64/kernel/perf_event.c      | 86 +++++++++++++++++++++++------
 arch/arm64/kvm/sys_regs.c           | 36 +++++++++++-
 include/linux/perf/arm_pmu.h        |  1 +
 6 files changed, 125 insertions(+), 20 deletions(-)

-- 
2.21.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
