Return-Path: <SRS0=+Nyp=G4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4CDC433E9
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 12:26:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 587402310D
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 12:26:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 587402310D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D62F34B619;
	Mon, 25 Jan 2021 07:26:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MS6wsyXvEMB4; Mon, 25 Jan 2021 07:26:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFB1F4B629;
	Mon, 25 Jan 2021 07:26:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDBF64B613
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 07:26:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xCatcBtbsq0g for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2021 07:26:45 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F09404B60E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 07:26:44 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B2D6D22597;
 Mon, 25 Jan 2021 12:26:43 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l40x7-009sBu-G0; Mon, 25 Jan 2021 12:26:41 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 0/7] KVM: arm64: More PMU/debug ID register fixes
Date: Mon, 25 Jan 2021 12:26:31 +0000
Message-Id: <20210125122638.2947058-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, eric.auger@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

This is a respin of a series I posted in the 5.7 time frame, and
completely forgot about it until I noticed again that a few things
where not what I remembered... Given how long it has been, I'm
pretending this is all new work.

Anyway, this covers a few gaps in our ID register handling for PMU and
Debug, plus the upgrade of the PMU support to 8.4 when possible.

I don't plan to take this into 5.11, but this is a likely candidate
for 5.12. Note that this conflicts with fixes that are on their way to
5.11. I'll probably end-up dragging the fixes into 5.12 to solve it.

* From v1 [1]:
  - Upgrade AArch32 to PMUv8.4 if possible
  - Don't advertise STALL_SLOT when advertising PMU 8.4
  - Add an extra patch replacing raw values for the PMU version with
    the already existing symbolaic values

[1] https://lore.kernel.org/r/20210114105633.2558739-1-maz@kernel.org

Marc Zyngier (7):
  KVM: arm64: Fix missing RES1 in emulation of DBGBIDR
  KVM: arm64: Fix AArch32 PMUv3 capping
  KVM: arm64: Add handling of AArch32 PCMEID{2,3} PMUv3 registers
  KVM: arm64: Refactor filtering of ID registers
  KVM: arm64: Limit the debug architecture to ARMv8.0
  KVM: arm64: Upgrade PMU support to ARMv8.4
  KVM: arm64: Use symbolic names for the PMU versions

 arch/arm64/include/asm/sysreg.h |  3 ++
 arch/arm64/kvm/pmu-emul.c       | 14 ++++--
 arch/arm64/kvm/sys_regs.c       | 79 ++++++++++++++++++++-------------
 3 files changed, 61 insertions(+), 35 deletions(-)

-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
