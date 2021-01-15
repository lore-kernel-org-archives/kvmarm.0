Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A065CC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 14:03:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B509238A0
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 14:03:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B509238A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97C9C4B1BF;
	Fri, 15 Jan 2021 09:03:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bAYrzh6SP92U; Fri, 15 Jan 2021 09:03:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FF8A4B169;
	Fri, 15 Jan 2021 09:03:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D63AB4B15F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 09:03:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id apRL6KMIgBQl for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 09:03:29 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D84C84B145
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 09:03:29 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A4AD42388E;
 Fri, 15 Jan 2021 14:03:28 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l0PhG-007m8M-Pg; Fri, 15 Jan 2021 14:03:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 0/2] KVM: arm64: Work around firmware wongly advertising
 GICv2 compatibility
Date: Fri, 15 Jan 2021 14:03:21 +0000
Message-Id: <20210115140323.2682634-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, shameerali.kolothum.thodi@huawei.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 ardb@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>
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

It appears that there is firmware out there that advertises GICv2
compatibility on GICv3, despite the CPUs not being able to actually do
it. That's a bummer, and at best creates unexpected behaviours for the
users. At worse, it will crash the machine. Awesome!

In order to mitigate this issue, try and validate whether we can
actually flip the CPU into supporting MMIO accesses instead of system
registers. If we can't, ignore the compatibility information and
shout. It's not completely foolproof, but it should cover the existing
broken platforms...

The workaround is much more invasive than Shameer's initial proposal,
as I wanted to keep it localised to KVM instead of spreading the
horror at every level (after all, only KVM is concerned with v2
compatibility).

Tested on a deliberately misconfigured FVP (DT advertising the MMIO
regions with cluster*.gicv3.cpuintf-mmap-access-level=2).

* From v1:
  - Fixed silly thinko when computing the configuration state

Marc Zyngier (2):
  KVM: arm64: Rename __vgic_v3_get_ich_vtr_el2() to
    __vgic_v3_get_gic_config()
  KVM: arm64: Workaround firmware wrongly advertising GICv2-on-v3
    compatibility

 arch/arm64/include/asm/kvm_asm.h   |  4 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  6 ++---
 arch/arm64/kvm/hyp/vgic-v3-sr.c    | 40 ++++++++++++++++++++++++++++--
 arch/arm64/kvm/vgic/vgic-v3.c      | 12 ++++++---
 4 files changed, 52 insertions(+), 10 deletions(-)

-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
