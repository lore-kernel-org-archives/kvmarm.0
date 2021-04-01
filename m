Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60CC6C433B4
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 09:26:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A3709610C7
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 09:26:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A3709610C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C4884B611;
	Thu,  1 Apr 2021 05:26:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IE45tEZsHouy; Thu,  1 Apr 2021 05:26:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 233374B602;
	Thu,  1 Apr 2021 05:26:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA5FC4B5F7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 05:26:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AqsZZ4XMjRaV for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Apr 2021 05:26:18 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 00AB44B602
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 05:26:17 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DAC93610C7;
 Thu,  1 Apr 2021 09:26:15 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lRtaf-0054Xq-J8; Thu, 01 Apr 2021 10:26:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Scull <ascull@google.com>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v3 0/5] Debug info for nVHE hyp panics
Date: Thu,  1 Apr 2021 10:26:10 +0100
Message-Id: <161726915832.4086905.3828966333080829088.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210318143311.839894-1-ascull@google.com>
References: <20210318143311.839894-1-ascull@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: ascull@google.com, kvmarm@lists.cs.columbia.edu,
 kernel-team@android.com, catalin.marinas@arm.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: catalin.marinas@arm.com, kernel-team@android.com, will@kernel.org
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

On Thu, 18 Mar 2021 14:33:06 +0000, Andrew Scull wrote:
> Panics from arm64's nVHE hyp mode are hard to interpret. This series
> adds some more debug info to help with diagnosis.
> 
> Using BUG() in nVHE hyp gives a meaningful address to locate invariants
> that fail to hold. The host can also look up the bug to provide the file
> and line, if the debug configs are enabled. Otherwise a kimg address is
> much more useful than a hyp VA since it can be looked up in vmlinux.
> 
> [...]

Applied to kvm-arm64/nvhe-panic-info, thanks!

[1/5] bug: Remove redundant condition check in report_bug
      commit: 3ad1a6cb0abc63d036fc866bd7c2c5983516dec5
[2/5] bug: Factor out a getter for a bug's file line
      commit: 26dbc7e299c7ebbb6a95e2c620b21b5280b37c57
[3/5] bug: Assign values once in bug_get_file_line()
      commit: 5b8be5d875a996776708ba174fcd08c8bcd721a5
[4/5] KVM: arm64: Use BUG and BUG_ON in nVHE hyp
      commit: f79e616f27ab6cd74deb0995a8eead3d1c9d65af
[5/5] KVM: arm64: Log source when panicking from nVHE hyp
      commit: aec0fae62e47050019474936248a311a0ab08705

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
