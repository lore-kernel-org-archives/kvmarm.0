Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9782BC6FA83
	for <kvmarm@archiver.kernel.org>; Sat, 10 Sep 2022 05:23:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F23F4BEB7;
	Sat, 10 Sep 2022 01:23:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jYcw8iigvIsA; Sat, 10 Sep 2022 01:23:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 052794BF0B;
	Sat, 10 Sep 2022 01:23:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F5F14BE98
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Sep 2022 01:23:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AKfg+mTpfnPX for <kvmarm@lists.cs.columbia.edu>;
 Sat, 10 Sep 2022 01:23:11 -0400 (EDT)
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com
 [209.85.217.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 320EA4BE8E
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Sep 2022 01:23:11 -0400 (EDT)
Received: by mail-vs1-f47.google.com with SMTP id m65so3743574vsc.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Sep 2022 22:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=m3/TehbQGopN0M9TyC9OJc2nnGFxBuSLpVkEhsafx4k=;
 b=BupYcGJg9AgPWkfyysBwwMLg4S4djndS4b8GNGkuCLJJ18z25OJ2w+frXS7k4fBl4G
 aPvUrfbdQ6VdMEmPhE/0agab9DcDmlHIis6nZJ71sNgWyPfG7fPrgtxEa5j0D2aRaVP1
 yhzoRbYAdFEJQ13hQZ6Hg3kKiSNzhVsSyLr9YTM0iqwivIOMftowbZCozbMEy0Pqh6tj
 yJZLL47OgGmE0h2sK+SC+l6HgviJ0nFjlChUQSN45auJlO9t51yheC917e4yFRFCkh98
 U8iOUdEaLjhbWckM0UdWSzSBn57oIaVaTuVWq2kUBf3wL88j+1CdehSP+/ya1uhAkfkZ
 Hj4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=m3/TehbQGopN0M9TyC9OJc2nnGFxBuSLpVkEhsafx4k=;
 b=LLyxi1MXEFoh/bYcWnoPGhLG7DXbLGznQqW9UYIcXYgQw2MWkwvZ2/3AjkpanI8UM1
 IlfRAdEvEzyxnxS/LRWTvdGsIrc8YxLqpwzm7fBvTImQhXf+tP7CQ5hhljfm7IvJu5ng
 /SFFJaTClCtKylHj+I6BDqJQ6sGZoQ7YF75Al3p3gI/EyS1OoNErr1UcU2cUJ3sUaHIQ
 nyGlvJb9bJHSG+aRviqy/ISMwGFTuZ2uOJ4FLMMTRxDyxVM2/HPbWdl72cCTIYJMjt4M
 8Ih/PIoKWJn/aoW+F8ueMQjd9HIPwLwF1yHTCx7YnsTCypXC3KQ/oiMnPg9RyaPewac7
 tlSQ==
X-Gm-Message-State: ACgBeo0iVQlZBvxi3FtCwSi2A2NsZbUYUjc55a3rtsogwrIHrqr0K+7B
 Wi/pDBW8qEiAy/t2fg5OzwsKjjUSKRYEQOht46eVJQ==
X-Google-Smtp-Source: AA6agR4DtbZYwWcmEOuomvY/UVjB1Qrj8H1jJ1/4wFImXOy8qch167gdgjlubbth+u7yjOIg+R1jIwbAIfws9wKDpNg=
X-Received: by 2002:a05:6102:3fa0:b0:392:b32a:2a99 with SMTP id
 o32-20020a0561023fa000b00392b32a2a99mr6404945vsv.63.1662787390687; Fri, 09
 Sep 2022 22:23:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-8-reijiw@google.com>
 <CAAeT=FxJLykbrgKSC6DNFr+hWr-=TOq60ODFZ7r+jGOV3a=KWg@mail.gmail.com>
 <YxuflDM6utJbdZa1@google.com> <YxuhkvMh5cAtONKe@google.com>
In-Reply-To: <YxuhkvMh5cAtONKe@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 9 Sep 2022 22:22:54 -0700
Message-ID: <CAAeT=Fw774cEEPwQ7Brb0x2jhMxn625ms_814cNaGoXY29A9hw@mail.gmail.com>
Subject: Re: [PATCH 7/9] KVM: arm64: selftests: Add a test case for a linked
 breakpoint
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Ricardo,

> > > > -static void guest_code(uint8_t bpn, uint8_t wpn)
> > > > +static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
> > > >  {
> > > > +       uint64_t ctx = 0x1;     /* a random context number */
> > > > +
> > > >         GUEST_SYNC(0);
> > > >
> > > >         /* Software-breakpoint */
> > > > @@ -281,6 +310,19 @@ static void guest_code(uint8_t bpn, uint8_t wpn)
> > > >                      : : : "x0");
> > > >         GUEST_ASSERT_EQ(ss_addr[0], 0);
> > > >
> > >
> > > I've just noticed that I should add GUEST_SYNC(10) here, use
> > > GUEST_SYNC(11) for the following test case, and update the
> > > stage limit value in the loop in userspace code.
> > >
> > > Or I might consider removing the stage management code itself.
> > > It doesn't appear to be very useful to me, and I would think
> > > we could easily forget to update it :-)
> > >
> > > Thank you,
> > > Reiji
> > >
> >
> > Yes, it's better to remove it. The intention was to make sure the guest
> > generates the expected sequence of exits. In this case for example,
> > "1, .., 11, DONE" would be correct, but "1, .., 11, 12, DONE" would not.
>
> Sorry, the correct sequence should be "1, .., 10, DONE". And also, what
> I meant to say is that *original* intention was to check that, which
> wasn't actually completed as the incorrect sequence would also succeed.

Thank you for the comments and explaining the original intention.
I will remove that.

Thank you,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
