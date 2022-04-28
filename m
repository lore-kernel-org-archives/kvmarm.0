Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94049C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 28 Apr 2022 19:59:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 217374B202;
	Thu, 28 Apr 2022 15:59:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DanRexsAQdHh; Thu, 28 Apr 2022 15:59:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1054440C52;
	Thu, 28 Apr 2022 15:59:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC3CD40B8D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 15:59:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qyP5OpqphAJN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2022 15:59:27 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB9844024F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 15:59:27 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 08E5661E52;
 Thu, 28 Apr 2022 19:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6EFC385B3;
 Thu, 28 Apr 2022 19:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651175965;
 bh=wejQBnwJLkXKTd0e9lLJndPjrZ/yapjG+CRPgT6UCtw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=B/0b/o2lNLwnwUzEOxUSGBZ6N3cTwl8tcebKfoPl0KkNVrGN8tPxS1+waNyWQaCyb
 ihQnjdFKGhoKIXXmRpDyCRuJYjqPWXl/yHWJlItNGAySoyyfARk4tzY3zeAdJOSBWJ
 6VTA17xlEBOU5nweqhwbci46D2CwI78ogXYnoBgIDuqjMpA/8f+PaO5QqeG1wWZQWO
 VFRvgOlzkOr5E0+N6qc4KDhSfMy1pg50kYZdkbfRhddoFxWtXs7YleG7A3vicNgeCJ
 a/kMkv2XntR6PE2BjlNj22+qtfbh4RKrByuvd27PeqPHzwDPIIlhBt8fnjKW8ekAMp
 vhDmKovf3I+rQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nkAIN-007lCM-BT; Thu, 28 Apr 2022 20:59:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Handle host stage-2 faults from 32-bit EL0
Date: Thu, 28 Apr 2022 20:59:20 +0100
Message-Id: <165117594912.3115603.17370789684170304130.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220427171332.13635-1-will@kernel.org>
References: <20220427171332.13635-1-will@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, will@kernel.org,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-arm-kernel@lists.infradead.org
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

On Wed, 27 Apr 2022 18:13:32 +0100, Will Deacon wrote:
> When pKVM is enabled, host memory accesses are translated by an identity
> mapping at stage-2, which is populated lazily in response to synchronous
> exceptions from 64-bit EL1 and EL0.
> 
> Extend this handling to cover exceptions originating from 32-bit EL0 as
> well. Although these are very unlikely to occur in practice, as the
> kernel typically ensures that user pages are initialised before mapping
> them in, drivers could still map previously untouched device pages into
> userspace and expect things to work rather than panic the system.

Applied to fixes, thanks!

[1/1] KVM: arm64: Handle host stage-2 faults from 32-bit EL0
      commit: 2a50fc5fd09798cc154b587acd4f4ee261ea19be

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
