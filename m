Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC4DC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 30 May 2022 08:28:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7F504B338;
	Mon, 30 May 2022 04:28:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2HAovkQduKql; Mon, 30 May 2022 04:28:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E72D94B332;
	Mon, 30 May 2022 04:28:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5DC54B332
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 May 2022 04:28:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1abYmfvYJbvC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 May 2022 04:28:11 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D5FBE4B32C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 May 2022 04:28:11 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 2C9DF60F0D;
 Mon, 30 May 2022 08:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECF6C385B8;
 Mon, 30 May 2022 08:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1653899290;
 bh=y17OzcpGc1HlzyJqlHd0DQWHrq/L+rJUWQeAvCz7OHk=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=jJGu3IxfKiPlT8olJ8xkAAJuP8UrK/fjPv6JcqwiR0C1oINxhqDjhSocktkccQNaL
 KcJJZedhd13HQMKgv/VobBGKYJDqd6nnUCTrQltTvp1AkL3exevofOGKqpeXNJoXau
 lWiKVCT4y0alnAQy2BgFTUJi0awQMWIQJwgJql1E7bAqUcxMVRm9CthFapHgP66YQ0
 DBXWdSrSEcQ8Zd+0FI69r78FFWm6a0M1eQvcY6Iz4h2rkJqRWqHdkRLaVQH6X1hTp4
 MRPSrTh/va2ghWlRUDo5xc6KCMY6hny84ZNS2Ju/x34uVDbKDDhdCrKeGyTSeKWLCW
 zJIel+MeGNUeQ==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nvaky-00ESs1-16; Mon, 30 May 2022 09:28:08 +0100
MIME-Version: 1.0
Date: Mon, 30 May 2022 09:28:07 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/18] KVM/arm64: Refactoring the vcpu flags
In-Reply-To: <20220528113829.1043361-1-maz@kernel.org>
References: <20220528113829.1043361-1-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <e29e8f7a2bfa3cd099c58c9a9ab8a518@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com,
 will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>
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

On 2022-05-28 12:38, Marc Zyngier wrote:

[...]

> This has been lightly tested on both VHE and nVHE systems, but not
> with pKVM itself (there is a bit of work to rebase it on top of this
> infrastructure). Patches on top of kvmarm-4.19 (there is a minor
> conflict with Linus' current tree).

As Will just pointed out to me in private, this should really read
kvmarm-5.19, as that's what the patches are actually based on.

I guess I'm still suffering from a form of Stockholm syndrome...

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
