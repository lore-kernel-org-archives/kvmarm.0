From: Amit Tomer <amittomer25@gmail.com>
Subject: Re: [PATCH] KVM: arm64: Count guest exit due to various reasons
Date: Mon, 26 Oct 2015 17:44:42 +0530
Message-ID: <CABHD4K_kJ0mVnX4yw2kAPYGCA0ZrjO_dCZdf3NLb3XxpxsLgUA@mail.gmail.com>
References: <1445155482-12482-1-git-send-email-amittomer25@gmail.com>
 <20151022211601.GA25602@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A351541145
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2015 08:11:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OoOqcJI5-LEO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2015 08:11:54 -0400 (EDT)
Received: from mail-yk0-f196.google.com (mail-yk0-f196.google.com
 [209.85.160.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4956540FA6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2015 08:11:53 -0400 (EDT)
Received: by ykba4 with SMTP id a4so15251454ykb.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2015 05:14:42 -0700 (PDT)
In-Reply-To: <20151022211601.GA25602@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: marc.zyngier@arm.com, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Thanks for the Review.


> I think it would be even more useful to distinguish between mmio exits
> handled in the kernel vs. those going to userspace.

Ok, I would work on it.


> why more exit stats on arm64 than on arm?

Intention is to just add these stats only for ARM64 but I had to do it for arm,
so that things don't break.

> why u32?  Would it not make sense to make these u64 or just unsigned
> long?

Ok, You mean to say, for ARM we should use u32 and for ARM64 we should
u64, right?

> either you should use one called wfx_exit_stat or you should distinguish
> between wfi and wfe; this is just a weird way of doing it.

Sorry, didn't just get your point here :(

Thanks
Amit.
