From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm64: Count guest exit due to various reasons
Date: Mon, 26 Oct 2015 16:44:01 +0100
Message-ID: <20151026154401.GF20298@cbox>
References: <1445155482-12482-1-git-send-email-amittomer25@gmail.com>
 <20151022211601.GA25602@cbox>
 <CABHD4K_kJ0mVnX4yw2kAPYGCA0ZrjO_dCZdf3NLb3XxpxsLgUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F6E640FA2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2015 11:40:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JyQkWEsNsIhQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2015 11:40:34 -0400 (EDT)
Received: from mail-lf0-f50.google.com (mail-lf0-f50.google.com
 [209.85.215.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2B1140F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2015 11:40:32 -0400 (EDT)
Received: by lffv3 with SMTP id v3so153486784lff.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2015 08:43:20 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CABHD4K_kJ0mVnX4yw2kAPYGCA0ZrjO_dCZdf3NLb3XxpxsLgUA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Amit Tomer <amittomer25@gmail.com>
Cc: marc.zyngier@arm.com, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 26, 2015 at 05:44:42PM +0530, Amit Tomer wrote:
> Thanks for the Review.
> 
> 
> > I think it would be even more useful to distinguish between mmio exits
> > handled in the kernel vs. those going to userspace.
> 
> Ok, I would work on it.
> 
> 
> > why more exit stats on arm64 than on arm?
> 
> Intention is to just add these stats only for ARM64 but I had to do it for arm,
> so that things don't break.

please keep both architectures up to date as much as possible for these
kinds of changes.

> 
> > why u32?  Would it not make sense to make these u64 or just unsigned
> > long?
> 
> Ok, You mean to say, for ARM we should use u32 and for ARM64 we should
> u64, right?

loss of context here, so I'm not sure.  Is there a reason why you
cannot/shouldn't use u64?  I'm just thinking that overflows could happen
fairly easy on u32, but otoh. there are some existing defines using u32
for some reason...

> 
> > either you should use one called wfx_exit_stat or you should distinguish
> > between wfi and wfe; this is just a weird way of doing it.
> 
> Sorry, didn't just get your point here :(
> 
wfx means "either a wfi or wfe happened", so you either define two
separate trace points, one for wfi and one for wfe, or you define a
single tracepoint for wfx.

I'll look forward to v2.

-Christoffer
