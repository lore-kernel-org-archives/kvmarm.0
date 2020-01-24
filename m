Return-Path: <SRS0=41R7=3N=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E802AC2D0DB
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jan 2020 13:34:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6BF65214DB
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jan 2020 13:34:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="0C+Q1CJK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6BF65214DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8F354AF2A;
	Fri, 24 Jan 2020 08:34:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8n+wMLiFNimy; Fri, 24 Jan 2020 08:34:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCB6E4AF0F;
	Fri, 24 Jan 2020 08:34:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90FB34AEEF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jan 2020 08:34:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ocsIxTNVsGJa for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jan 2020 08:34:38 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 891834ACC9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jan 2020 08:34:38 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 45D6A2087E;
 Fri, 24 Jan 2020 13:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579872877;
 bh=7L3LQxwcMn0sL99Kg9Iw/6y7YYRrD0myNYQr201fsnk=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=0C+Q1CJKCYngonwYHsFw0cvUJaGwCYR31GdsPpHgLdcp/LB8OLUFNNDmAHxHHGpIS
 SWhInojOa2FB8a+OAO/a+YkLO9er7YMVTdy13fyo6MxGzveKs+gGtIqazSMn7xXyHh
 jGcMTIIkXJyvx5FXhwLAP8xmJPXwPSNy6dpASKT4=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1iuz6Z-001Bnc-HH; Fri, 24 Jan 2020 13:34:35 +0000
MIME-Version: 1.0
Date: Fri, 24 Jan 2020 13:34:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v2 0/1] arm/arm64: add support for folded p4d page tables
In-Reply-To: <20200124122053.GA150292@google.com>
References: <20200113111323.10463-1-rppt@kernel.org>
 <20200122185017.GA17321@willie-the-truck>
 <cb6357040bd5d9fa061a8d3bd96fb571@kernel.org>
 <20200124122053.GA150292@google.com>
Message-ID: <af9e7292f723f808406510f437d5b0eb@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: qperret@google.com, will@kernel.org, rppt@kernel.org,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, linux@armlinux.org.uk,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, rppt@linux.ibm.com,
 kvmarm@lists.cs.columbia.edu, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, Mike Rapoport <rppt@linux.ibm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Mike Rapoport <rppt@kernel.org>
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

Hi Quentin,

On 2020-01-24 12:20, Quentin Perret wrote:
> Hi Marc,
> 
> On Wednesday 22 Jan 2020 at 18:56:38 (+0000), Marc Zyngier wrote:
>> But maybe this is the reason we've all been waiting for, for which we
>> sacrifice 32bit KVM host on the altar of progress, and finally move 
>> along.
>> 
>> Will and I are the only known users, and that'd be a good incentive to
>> experience some if this 64bit goodness... ;-)

[future work for which 32bit support gets in the way]

> This would a be perfectly reasonable and acceptable overhead if this 
> had
> to be done to keep 32bit KVM host support for a real user community, 
> but
> since it doesn't seem to exist (?), fighting with the above options
> feels like a lot of wasted efforts. (Note: I am not implying that Will
> and you are not real persons, but well, you see what I mean ;-)).

I don't disagree at all. To be honest, I've been on the cusp of getting
rid of it for a while, for multiple reasons:

- It has no users (as you noticed)
- It is hardly tested (a consequence of the above)
- It isn't feature complete (no debug, no PMU)
- It doesn't follow any of the evolution of the architecture (a more
   generic feature of the 32bit port, probably because people run their
   64bit-capable cores in 64bit mode)
- It is becoming a mess of empty stubs

The maintenance aspect hasn't been a real problem so far. Even the NV
support is only about 200 lines of stubs. But what you have in mind is
going to be much more invasive, and I wouldn't want an unused feature to
get in the way.

What I may end-up doing is to send a RFC series to remove the 32bit host
support from the tree during in the 5.6 cycle, targeting 5.7. If someone
shouts loudly during that time frame, we keep it and you'll have to work
around it. If nobody cares, then dropping it is the right thing to do.

Would that be OK with you?

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
