Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E6A3C4321E
	for <kvmarm@archiver.kernel.org>; Tue,  1 Feb 2022 18:17:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABB4E40C31;
	Tue,  1 Feb 2022 13:17:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zGZXPXXVygz7; Tue,  1 Feb 2022 13:17:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78CAD49E10;
	Tue,  1 Feb 2022 13:17:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDEED48F9C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 13:17:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WoPhrmdkbNlF for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Feb 2022 13:17:19 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9FB5140C31
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 13:17:19 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8348861422;
 Tue,  1 Feb 2022 18:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FF6C340EC;
 Tue,  1 Feb 2022 18:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643739438;
 bh=Yo9eGjjqXm3djBj1msZWDv/57nkLaX6CCklZJLeSN0Y=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=D6JWr8iJGxf7rSZvpvFOkbdW/av+WQy1Q13DkYa+0HHk3mFGnUQuWmjumPVyyE6Kw
 C+IuECUjY9a1VVfJwGCe4+Dm/etkwsQZyDWfZA0KH54hxvgAeAWaFvaofxhSiddn46
 BLqf5vY+r5IrmqIKZjYbFxPRHZ5n2d9DCaZcw5yRGyAa/Gf65uj4EfnXmAKEepRT2S
 1pnCQtxkE2IXUBJy7fmDZqWezMxfKeynHQpMrEk9KblmlLBwaZPkgkrkfcqF5mdfyu
 yIVeXnO2Bzb6C+v8spsiIfAp7BvbB6T1uiNh6E95yigmMZV8VhYV2Pa15nHUuBqhYt
 G7652lbWzNe2A==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nExiN-004iJL-3f; Tue, 01 Feb 2022 18:17:16 +0000
MIME-Version: 1.0
Date: Tue, 01 Feb 2022 18:17:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Subject: Re: [PATCH v6 15/64] KVM: arm64: nv: Handle HCR_EL2.E2H specially
In-Reply-To: <YfllJ9WPx45nzeCZ@shell.armlinux.org.uk>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-16-maz@kernel.org>
 <YfllJ9WPx45nzeCZ@shell.armlinux.org.uk>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <67494ba2e12cbb9a4eba469dd45c2752@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com,
 mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>, kvmarm@lists.cs.columbia.edu,
 mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
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

On 2022-02-01 16:51, Russell King (Oracle) wrote:
> On Fri, Jan 28, 2022 at 12:18:23PM +0000, Marc Zyngier wrote:
>> HCR_EL2.E2H is nasty, as a flip of this bit completely changes the way
>> we deal with a lot of the state. So when the guest flips this bit
>> (sysregs are live), do the put/load dance so that we have a consistent
>> state.
>> 
>> Yes, this is slow. Don't do it.
> 
> I'd hope this is very unlikely!

A guest OS would probably do it once per CPU bring-up. So I'm
not too bothered about the speed. But that's only one of the
many cases where we need to do this put/load game.

At this stage, we don't care too much. But the last two patches
give you a glimpse of what sort of fine-grained optimisation
we will eventually want to do for this not to suck too much.

But again, this is NV, and it gives a whole new sense to "being
slow".

> 
>> 
>> Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
