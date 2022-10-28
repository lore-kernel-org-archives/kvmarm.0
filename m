Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0671EC38A02
	for <kvmarm@archiver.kernel.org>; Fri, 28 Oct 2022 11:20:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BD81401CB;
	Fri, 28 Oct 2022 07:20:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pJyvcpXRwqTr; Fri, 28 Oct 2022 07:20:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5714E40BB3;
	Fri, 28 Oct 2022 07:20:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D50B340B8D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 07:20:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aMOqFOQT0QxQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Oct 2022 07:20:23 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 77B7D401CB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 07:20:23 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 902066275F;
 Fri, 28 Oct 2022 11:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E56C433C1;
 Fri, 28 Oct 2022 11:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666956022;
 bh=pL3H279MhLQcgUKud1LmxlhphCcUDPiJcZn2X4jLPvk=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=FWj6ooDezhD/j+4qVNEkYcUxz7XMaBO1pcbj4z0nmFyfRz1+RV7+m7QpSv/x+/5V5
 smAUv6tXBR+8ZyUXKZG/vHs8t183Wc+6Mxtcyty2kf3eW1Jmf16/AA8ODQa0kauWiv
 nkVZyh7Uo3xDOgWuomibHSz7lURlRUJyL9PXoutQqbREAgQvYYUUB6IBTLXLgCIO7X
 SU1IUen4qg2CRa8okecKndBEjIwrNPr5Xmk2RFt1mOinDBmGWHqopAWe+DMl7tC13G
 qtEdDHDouqdaAWb9P1sq0GD1gfh8m5ix6t+1UK9TNiPohU4KNDNuf4gPTs1q8XrhGv
 z0xl5+XImIMTg==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ooNPQ-002EYW-6H;
 Fri, 28 Oct 2022 12:20:20 +0100
MIME-Version: 1.0
Date: Fri, 28 Oct 2022 12:20:20 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [REPOST][URGENT] kvmarm mailing list migration
In-Reply-To: <Y1skH3k6SIV0hEMZ@google.com>
References: <86edvbg3q7.wl-maz@kernel.org> <Y1skH3k6SIV0hEMZ@google.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <364100e884023234e4ab9e525774d427@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm <kvmarm@lists.cs.columbia.edu>
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

On 2022-10-28 01:36, Oliver Upton wrote:
> On Thu, Oct 13, 2022 at 04:09:20PM +0100, Marc Zyngier wrote:
>> [Reposting this, as it has been almost two weeks since the initial
>>  announcement and we're still at sub-10% of the users having
>>  subscribed to the new list]
>> 
>> Hi all,
>> 
>> As you probably all know, the kvmarm mailing has been hosted on
>> Columbia's machines for as long as the project existed (over 13
>> years). After all this time, the university has decided to retire the
>> list infrastructure and asked us to find a new hosting.
>> 
>> A new mailing list has been created on lists.linux.dev[1], and I'm
>> kindly asking everyone interested in following the KVM/arm64
>> developments to start subscribing to it (and start posting your
>> patches there). I hope that people will move over to it quickly enough
>> that we can soon give Columbia the green light to turn their systems
>> off.
>> 
>> Note that the new list will only get archived automatically once we
>> fully switch over, but I'll make sure we fill any gap and not lose any
>> message. In the meantime, please Cc both lists.
> 
> Just wanted to explicitly highlight this point... can folks please
> continue to Cc the old list until we migrate to the new one?
> lore.kernel.org archives *only* contain mail sent to the columbia.edu
> address right now.
> 
> Fortunately, the series I'm aware of that didn't do this still hit
> another archived list so I could find it with a bit more digging.
> 
> Marc -- any idea when we're going to finally switch to the new world?

Given the amount of spam I'm dealing with on the Columbia list,
I'm tempted to say "real soon now".

I'll repeat my call for migration again next week, give it another
week, then ask Konstantin to switch the archives over to the new
list. This can take up to a week, but as soon as it is done,
I'll place the list under full moderation and ask Columbia to
kill it.

So it looks like we're looking at a ~2 week deadline. Should anyone
object to this plan, shout now!

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
