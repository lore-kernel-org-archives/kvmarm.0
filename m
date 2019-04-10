Return-Path: <SRS0=4kLF=SM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 745ADC10F11
	for <kvmarm@archiver.kernel.org>; Wed, 10 Apr 2019 12:34:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E854C20674
	for <kvmarm@archiver.kernel.org>; Wed, 10 Apr 2019 12:34:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E854C20674
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 523204A48E;
	Wed, 10 Apr 2019 08:34:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id udV22VfuWHNQ; Wed, 10 Apr 2019 08:34:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CED1D4A47F;
	Wed, 10 Apr 2019 08:34:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C71CD4A47A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 08:34:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PEw6fywSbQFM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Apr 2019 08:34:12 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 259AD4A36D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 08:34:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5201AA78;
 Wed, 10 Apr 2019 05:34:11 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6194F3F59C;
 Wed, 10 Apr 2019 05:34:09 -0700 (PDT)
Date: Wed, 10 Apr 2019 13:34:06 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v7 27/27] KVM: arm64/sve: Document KVM API extensions for
 SVE
Message-ID: <20190410123405.GG3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-28-git-send-email-Dave.Martin@arm.com>
 <20190404210921.7xz6o56wietd77li@kamzik.brq.redhat.com>
 <20190405093617.GO3567@e103592.cambridge.arm.com>
 <20190405103937.quhaxxwkjjdxab6z@kamzik.brq.redhat.com>
 <20190405130007.GB3567@e103592.cambridge.arm.com>
 <20190405153804.qnw774e5bsudd2kn@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190405153804.qnw774e5bsudd2kn@kamzik.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>,
 Christoffer Dall <cdall@kernel.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190410123406.RaCyiUxDKQE74R8yw3o6NNlwB30JR8OjerGSriiruhk@z>

On Fri, Apr 05, 2019 at 05:38:04PM +0200, Andrew Jones wrote:
> On Fri, Apr 05, 2019 at 02:00:07PM +0100, Dave Martin wrote:
> > On Fri, Apr 05, 2019 at 12:39:37PM +0200, Andrew Jones wrote:
> > > On Fri, Apr 05, 2019 at 10:36:17AM +0100, Dave Martin wrote:
> > > > On Thu, Apr 04, 2019 at 11:09:21PM +0200, Andrew Jones wrote:

[...]

> > > > > I'm still not sure about EPERM vs. ENOEXEC.
> > > > 
> > > > There is no need to distinguish the two: this is just a generic "vcpu in
> > > > wrong state for this to work" error.  I can't think of another subsystem
> > > > that uses ENOEXEC for this meaning, but it's established in KVM.
> > > > 
> > > > If you can't see a reason why we would need these to be distinct
> > > > errors (?) then I'm happy for this to be ENOEXEC for all cases.
> > > > 
> > > 
> > > I do see some value in keeping them distinct. I think it's just the use
> > > of EPERM specifically that bothers me, but I don't have that strong of
> > > an opinion against its use either. So I'll just shut up :)
> > 
> > In an earlier incarnation I had EBADFD, which does kind of mean the
> > right thing.
> > 
> > If there's not a clear way forward, I may leave this all as-is for now
> > (but I'll remove the explicit documentation for KVM_{GET,SET}_ONE_REG
> > error codes to give us more flexibility about this in the future, as
> > discussed).
> > 
> > Any objection?
> 
> Nope. Let's do that. EBADFD doesn't sound good, because we're using the FD
> without trouble before and even after we attempt these ioctls. I think
> EBADFD would indicate that no future ioctl (or read,write) should be
> expected to work.

OK.  I may also keep some of the error code documentation, but water it
down a bit to make it clearer that the error codes are indicate and
arm64-specifc.

We can see how it looks when I have a series to post.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
