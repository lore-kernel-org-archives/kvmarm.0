Return-Path: <SRS0=T8IC=NR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE241C432BE
	for <kvmarm@archiver.kernel.org>; Thu, 26 Aug 2021 10:38:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3355B6109E
	for <kvmarm@archiver.kernel.org>; Thu, 26 Aug 2021 10:38:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3355B6109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADF594B0C2;
	Thu, 26 Aug 2021 06:38:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Hxv51ZkDrMqV; Thu, 26 Aug 2021 06:37:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC4644B153;
	Thu, 26 Aug 2021 06:37:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8BE54B0CB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 06:37:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m8CtvvMDEXNC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Aug 2021 06:37:55 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0AEE84B0C2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 06:37:55 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6F0A06108F;
 Thu, 26 Aug 2021 10:37:52 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mJCla-007KET-3u; Thu, 26 Aug 2021 11:37:50 +0100
From: Marc Zyngier <maz@kernel.org>
To: Raghavendra Rao Ananta <rananta@google.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm64: Trim guest debug exception handling
Date: Thu, 26 Aug 2021 11:37:46 +0100
Message-Id: <162997424183.1640651.9657746284386330796.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823223940.1878930-1-rananta@google.com>
References: <20210823223940.1878930-1-rananta@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: rananta@google.com, alexandru.elisei@arm.com,
 suzuki.poulose@arm.com, james.morse@arm.com, jingzhangos@google.com,
 catalin.marinas@arm.com, reijiw@google.com, kvmarm@lists.cs.columbia.edu,
 pshier@google.com, oupton@google.com, linux-kernel@vger.kernel.org,
 will@kernel.org, ricarkol@google.com, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, 23 Aug 2021 22:39:40 +0000, Raghavendra Rao Ananta wrote:
> The switch-case for handling guest debug exception covers
> all the debug exception classes, but functionally, doesn't
> do anything with them other than ESR_ELx_EC_WATCHPT_LOW.
> Moreover, even though handled well, the 'default' case
> could be confusing from a security point of view, stating
> that the guests' actions can potentially flood the syslog.
> But in reality, the code is unreachable.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Trim guest debug exception handling
      commit: 8ce8a6fce9bfd3fcabe230ad104e2caf08b2e58d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
