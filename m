Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EA1C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 13:41:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69CE120739
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 13:41:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="RnP+HYGe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69CE120739
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 134074B0D2;
	Mon, 22 Jun 2020 09:41:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B5MfNN6ijtjU; Mon, 22 Jun 2020 09:41:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E404D4B0E8;
	Mon, 22 Jun 2020 09:41:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAAF94B0C1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 09:41:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YXUdqLi5N458 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 09:41:35 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C474F4A531
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 09:41:35 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9894620679;
 Mon, 22 Jun 2020 13:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1592833294;
 bh=fkXQsaOSzx4yB37RUmOsulqQkA6onP56sqW6f4bDFLM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=RnP+HYGe6cMUYj1jWv5mhPgK2qpJKRJ8rreJIKC7anLxC9JfhBKu2TXOan5mRHkxq
 7VYB/drLVp103R0n5XR02uuBUzDm9n8mmD8RoosF769dYeoOYR4ZN0qpQ2AdM+pQSM
 7IwmSQrtbbvtKR2UEdh1D8jxvHbOyxviqTru1pCI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jnMhZ-005KkL-2j; Mon, 22 Jun 2020 14:41:33 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64: kvm: Annotate hyp NMI-related functions as
 __always_inline
Date: Mon, 22 Jun 2020 14:41:26 +0100
Message-Id: <159283326373.239821.1231019851371158870.b4-ty@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200618171254.1596055-1-alexandru.elisei@arm.com>
References: <20200618171254.1596055-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: will@kernel.org, catalin.marinas@arm.com
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

On Thu, 18 Jun 2020 18:12:54 +0100, Alexandru Elisei wrote:
> The "inline" keyword is a hint for the compiler to inline a function.  The
> functions system_uses_irq_prio_masking() and gic_write_pmr() are used by
> the code running at EL2 on a non-VHE system, so mark them as
> __always_inline to make sure they'll always be part of the .hyp.text
> section.
> 
> This fixes the following splat when trying to run a VM:
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Annotate hyp NMI-related functions as __always_inline
      commit: 7733306bd593c737c63110175da6c35b4b8bb32c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
