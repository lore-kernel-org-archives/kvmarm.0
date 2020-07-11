Return-Path: <SRS0=gvHH=AW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 418FDC433E3
	for <kvmarm@archiver.kernel.org>; Sat, 11 Jul 2020 00:28:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B224A207BB
	for <kvmarm@archiver.kernel.org>; Sat, 11 Jul 2020 00:28:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="rcoEfIMj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B224A207BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C6E94B0CA;
	Fri, 10 Jul 2020 20:28:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ly-6N23jG78H; Fri, 10 Jul 2020 20:28:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 194034B158;
	Fri, 10 Jul 2020 20:28:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DDDA4B152
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 20:28:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ruQ0slE+lShk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2020 20:28:04 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A2114B0CA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 20:28:04 -0400 (EDT)
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 928E32078B;
 Sat, 11 Jul 2020 00:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1594427282;
 bh=BRp8sZxnMGB3vpZ0E+ioDMibR1SlBT/gKwtr/pLNEYo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=rcoEfIMjSYOscAN4dOPiRCIwgHLNfsr7WG33Xmy4XgKSPX9fNs3pkh0AaMgqZdLtc
 LssjVDTYv0uJJtzW6DQThgD3hoW9QztI7ZtFZvf178SFjx1tBiMW5qHGFPnzn80fn4
 gl3ywItY31zXbbTGkHz3MQJEXwCvCnACTvLT8/rI=
Date: Fri, 10 Jul 2020 20:28:01 -0400
From: Sasha Levin <sashal@kernel.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH stable v4.9 v2] arm64: entry: Place an SB sequence
 following an ERET instruction
Message-ID: <20200711002801.GE2722994@sasha-vm>
References: <20200709195034.15185-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200709195034.15185-1-f.fainelli@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
 Fangrui Song <maskray@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>,
 stable@vger.kernel.org,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Mark Brown <broonie@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>, Marc Zyngier <maz@kernel.org>,
 Kristina Martsenko <kristina.martsenko@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org
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

On Thu, Jul 09, 2020 at 12:50:23PM -0700, Florian Fainelli wrote:
>From: Will Deacon <will.deacon@arm.com>
>
>commit 679db70801da9fda91d26caf13bf5b5ccc74e8e8 upstream
>
>Some CPUs can speculate past an ERET instruction and potentially perform
>speculative accesses to memory before processing the exception return.
>Since the register state is often controlled by a lower privilege level
>at the point of an ERET, this could potentially be used as part of a
>side-channel attack.
>
>This patch emits an SB sequence after each ERET so that speculation is
>held up on exception return.
>
>Signed-off-by: Will Deacon <will.deacon@arm.com>
>[florian: Adjust hyp-entry.S to account for the label
> added change to hyp/entry.S]
>Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

I've queued it up, thanks!

-- 
Thanks,
Sasha
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
