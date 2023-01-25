Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3ED10ED
	for <kvmarm@lists.linux.dev>; Wed, 25 Jan 2023 04:11:25 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id 20so12593553pfu.13
        for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 20:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CJabib5NbUBwMrm5oU+0ZoPWuUCQhccu6rUbctVZbq8=;
        b=MJ66DxyKI49VCwmPR+axwQH0y85wmlFVSq9TUPPAnHXRAV8vX851P4gtGWmxNHNDeq
         bS1amqDX26pXVTiqFrtxNIi6hdGKcq4/VehjRISxME7zSA4XdJ2dZH3n3SveQF1AQSw1
         nCFDJQxzVRihLQeUEuYWkPr/F3BM0PM9YKvOwAypAhcLPv1jzJ6WxjrHtlINRIbmcb49
         uJMegsDmsI04npoSPRMONp2QbUbn1cLrDxZH1LXLMpH21OvyfPCJ3B4h1h1Jzs7z/cCx
         wMVoW3whFO+aQY+/rJUtzcaMn4RV3qA0S9RObUkkkVf65euA2kBuCb8i/N9yg2a0B9NX
         z8ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CJabib5NbUBwMrm5oU+0ZoPWuUCQhccu6rUbctVZbq8=;
        b=dnM5xwB2J1W3OZcyYXYpsh3Cz3l88LcO0FE6hOPBH9OXvnBF14dXmRkAKtwreGffPQ
         xBkAxAU47hn7XFPNteGr3yTabZWbozZkvyJJTomjMbBjowo6iN5tiYhuMgkDWgwFU1rf
         FZF5eDYE1LwVslRmFBCPFGbR5+675Rtgko3g5sHpi/cDVFa2r31RVPVFPYPNfhIwxk3j
         gsQMKBdWCqb8nAzWz1clCHX8f4FyE9l7ZtTFWX+VHaxCZcxGeA519ZybVZHidDf+GD04
         QeHmhTwKS1pa4br6+mfPbThk0H0DqnhkN976+vMuwq3pHNZ/ym1hzBWBO8bWddvWORar
         djcQ==
X-Gm-Message-State: AFqh2kp4C4H7JWIqmALxM+BSaTOYmirIoA4TiXWRJP81GXOvWHlMQaLl
	HSsigGRkb+yIMn5XrsDM6sF6BRrV0MVqmzA+g7pdxQ==
X-Google-Smtp-Source: AMrXdXs3GPep6mt4hQqbDAb5KAIILk+feJKO4chYHRNTzVLCZFDczi5HHfp9XecXGhiiD5HVLbFbgqOWgKYeDjxV8f0=
X-Received: by 2002:a05:6a00:2992:b0:58d:b26a:6238 with SMTP id
 cj18-20020a056a00299200b0058db26a6238mr3885279pfb.84.1674619884776; Tue, 24
 Jan 2023 20:11:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109211754.67144-1-ricarkol@google.com> <20230109211754.67144-4-ricarkol@google.com>
 <CAAeT=FxoS2-cmMe-3FeXPXcvE4wNosZeZy2RGPXz5xisq5fj7A@mail.gmail.com> <Y9CRxb2YvPtX340D@google.com>
In-Reply-To: <Y9CRxb2YvPtX340D@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 24 Jan 2023 20:11:08 -0800
Message-ID: <CAAeT=FyP0658CNXT6csZpvMvZ4n+X5igLw4W9z0jQTs12y3aCQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/4] arm: pmu: Add tests for 64-bit overflows
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev, 
	maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	oliver.upton@linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 24, 2023 at 6:19 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Wed, Jan 18, 2023 at 09:58:38PM -0800, Reiji Watanabe wrote:
> > Hi Ricardo,
> >
> > On Mon, Jan 9, 2023 at 1:18 PM Ricardo Koller <ricarkol@google.com> wrote:
> > > @@ -898,12 +913,12 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> > >
> > >         pmu_reset_stats();
> >
> > This isn't directly related to the patch.
> > But, as bits of pmovsclr_el0 are already set (although interrupts
> > are disabled), I would think it's good to clear pmovsclr_el0 here.
> >
> > Thank you,
> > Reiji
> >
>
> There's no need in this case as there's this immediately before the
> pmu_reset_stats();
>
>         report(expect_interrupts(0), "no overflow interrupt after counting");
>
> so pmovsclr_el0 should be clear.

In my understanding, it means that no overflow *interrupt* was reported,
as the interrupt is not enabled yet (pmintenset_el1 is not set).
But, (as far as I checked the test case,) the both counters should be
overflowing here. So, pmovsclr_el0 must be 0x3.

Or am I misunderstanding something?

Thank you,
Reiji


>
> >
> > >
> > > -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > > -       write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> > > +       write_regn_el0(pmevcntr, 0, pre_overflow);
> > > +       write_regn_el0(pmevcntr, 1, pre_overflow);
> > >         write_sysreg(ALL_SET, pmintenset_el1);
> > >         isb();
> > >
>
