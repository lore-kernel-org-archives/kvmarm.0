Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BFE7FA373D
	for <kvmarm@archiver.kernel.org>; Fri, 28 Oct 2022 00:36:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BC8E405C1;
	Thu, 27 Oct 2022 20:36:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B2bAgHQ-w1Q0; Thu, 27 Oct 2022 20:36:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE6BD40FD3;
	Thu, 27 Oct 2022 20:36:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0773340755
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 20:36:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7u0AYKvB+udj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Oct 2022 20:36:51 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E0F0405C1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 20:36:51 -0400 (EDT)
Date: Fri, 28 Oct 2022 00:36:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1666917409;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=bmRIVhsrDv0rvlbSQbr/B1PSKAuul63UicKwKG0IWiw=;
 b=ePtwZ+ZnerVj+HcsfIEObf4tGKamDGYH/lW5eWzlL7bNuzeV9l+rG3OiKqdUJpwNi2xKer
 9gCOxzGTSEL4UR/VnCTG8+kIimrGWU/dUjyfMZoqXfMFypRT8HD7AMJwPMOouy8DXpyQOI
 FbuVfCQdUbmxgZ9qOItyBLg5MtrBTmY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [REPOST][URGENT] kvmarm mailing list migration
Message-ID: <Y1skH3k6SIV0hEMZ@google.com>
References: <86edvbg3q7.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86edvbg3q7.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Oct 13, 2022 at 04:09:20PM +0100, Marc Zyngier wrote:
> [Reposting this, as it has been almost two weeks since the initial
>  announcement and we're still at sub-10% of the users having
>  subscribed to the new list]
>  
> Hi all,
> 
> As you probably all know, the kvmarm mailing has been hosted on
> Columbia's machines for as long as the project existed (over 13
> years). After all this time, the university has decided to retire the
> list infrastructure and asked us to find a new hosting.
> 
> A new mailing list has been created on lists.linux.dev[1], and I'm
> kindly asking everyone interested in following the KVM/arm64
> developments to start subscribing to it (and start posting your
> patches there). I hope that people will move over to it quickly enough
> that we can soon give Columbia the green light to turn their systems
> off.
> 
> Note that the new list will only get archived automatically once we
> fully switch over, but I'll make sure we fill any gap and not lose any
> message. In the meantime, please Cc both lists.

Just wanted to explicitly highlight this point... can folks please
continue to Cc the old list until we migrate to the new one?
lore.kernel.org archives *only* contain mail sent to the columbia.edu
address right now.

Fortunately, the series I'm aware of that didn't do this still hit
another archived list so I could find it with a bit more digging.

Marc -- any idea when we're going to finally switch to the new world?

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
