Return-Path: <SRS0=C/bf=LA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FACC47096
	for <kvmarm@archiver.kernel.org>; Sun,  6 Jun 2021 10:31:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 306AF6141E
	for <kvmarm@archiver.kernel.org>; Sun,  6 Jun 2021 10:31:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 306AF6141E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF8A0405A9;
	Sun,  6 Jun 2021 06:31:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z-B9Hzug2s3G; Sun,  6 Jun 2021 06:31:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFB4749F5D;
	Sun,  6 Jun 2021 06:31:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1390740799
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Jun 2021 06:31:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dL2TQ+U8dHbQ for <kvmarm@lists.cs.columbia.edu>;
 Sun,  6 Jun 2021 06:31:24 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 08D3B405A9
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Jun 2021 06:31:24 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 01CE4613EF;
 Sun,  6 Jun 2021 10:31:23 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lpq3s-005kHi-V4; Sun, 06 Jun 2021 11:31:21 +0100
MIME-Version: 1.0
Date: Sun, 06 Jun 2021 11:31:20 +0100
From: Marc Zyngier <maz@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v2 4/7] KVM: arm64: Unify MMIO and mem host stage-2 pools
In-Reply-To: <20210602094347.3730846-5-qperret@google.com>
References: <20210602094347.3730846-1-qperret@google.com>
 <20210602094347.3730846-5-qperret@google.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <b4e4647166447d8fd22b360369de4acb@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: qperret@google.com, will@kernel.org, james.morse@arm.com,
 alexandru.elisei@arm.com, catalin.marinas@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kernel-team@android.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-06-02 10:43, Quentin Perret wrote:
> We currently maintain two separate memory pools for the host stage-2,
> one for pages used in the page-table when mapping memory regions, and
> the other to map MMIO regions. The former is large enough to map all of
> memory with page granularity and the latter can cover an arbitrary
> portion of IPA space, but allows to 'recycle' pages.
> 
> However, this split makes accounting difficult to manage as pages at
> intermediate levels of the page-table may be used to map both memory 
> and
> MMIO regions. Simplify the scheme by merging both pools into one. This
> means we can now hit the -ENOMEM case in the memory abort path, but
> we're still guaranteed forward-progress in the worst case by unmapping
> MMIO regions. On the plus side this also means we can usually map a lot
> more MMIO space at once if memory ranges happen to be mapped with block
> mappings.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>

This patch fails to apply on top of -rc4. Did you use some more exotic
base or, as I suspect, a development tree?

Please check and respin the series if necessary.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
