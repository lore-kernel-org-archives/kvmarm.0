Return-Path: <SRS0=3mia=ND=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A37C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 09:29:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 036C860EB9
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 09:29:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 036C860EB9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74B474086F;
	Thu, 12 Aug 2021 05:29:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V6tHaLXd6cTN; Thu, 12 Aug 2021 05:29:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85D5849DE7;
	Thu, 12 Aug 2021 05:29:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E6AB40874
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 05:29:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c3kxWX17NIvF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Aug 2021 05:29:27 -0400 (EDT)
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com
 [209.85.167.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 712944086F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 05:29:27 -0400 (EDT)
Received: by mail-oi1-f169.google.com with SMTP id h11so9461652oie.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 02:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=U79XFkLmbTn8yZV9qpDrY5ksUSwcFQWwCLlxy1S3ZCM=;
 b=XrAlKvRO3IhvRdo1OfWHbg5fICmE2y0uYSwhfVvs4rYQN5CsIicsYYx6Bs4fvQnjgZ
 1/hpL5TdfGpaLaNtdcGvPBeWvKk9rEqJGgPOYiuE8PeSQq/Bp+L6vzIUH7vP8RS5UiCD
 S446ike5fw0AnQivnWAK1804te/Ob8vIu1CzthWvfbYZVJMEOzyP8sKTFKNHq5j0HqpT
 a8El6dzjZNsuBOljCrPy+L/RGS8k7Uk+j+BCtfS+Nr5DfOg9ETkSRCRT42zKL+wSYKs+
 QZgYYQ+Q7DRIRJjmSg3t5RF45otrrW1S3LT5N++xJgdcQ9882GV8NuvDQdqM26arapJ9
 OXZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=U79XFkLmbTn8yZV9qpDrY5ksUSwcFQWwCLlxy1S3ZCM=;
 b=prQDy1JBvcl0tqiOh8F/0MqYCsJkFCKpEaby/n/K6NnFxeDu8aQstoyTJ5zad0Qla2
 lRI6nFYNvc22vdyGYnWBjTGkqzTRfTf8Qazxz7Q+1xc976wMnQPKdO4Ls48NK7f071Yf
 oiOeasaJCDWtem4MbE8ZTI/43M4y4aLOha8NRlgwWjItF18lsaH++ziSY+AQ+ZHZN84e
 rdJZkXn5Q88Psk15HI9d0xMgRjV8iBDTCvmuSGj1G/Wuu0zaJGcdJ/rVLbda9ga6K9xd
 RZujlveGzblruGy+6WopL2M5j1GmZrGOtoh6Tytv5+UsV99djLO90ObtB0rpwF2EBbCL
 eVUw==
X-Gm-Message-State: AOAM530V2AT9Eef4c7XwItlBfoBUBIz+Ua6xmpCu3tnUy8QcFl21Gjpt
 PDROwr9pe67FIpXOkKlim6lcEXipInjRka4KOdg4TA==
X-Google-Smtp-Source: ABdhPJy/aFf9zz0FkODqeQLUSWtM0BsR7RoSxRgsEV4qM8uv4EK7odLD7bTl7wQy0/py2mv9baEX0r2aaorTwAPxZfU=
X-Received: by 2002:aca:220a:: with SMTP id b10mr10630360oic.8.1628760566696; 
 Thu, 12 Aug 2021 02:29:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-7-tabba@google.com>
 <20210720145258.axhqog3abdvtpqhw@gator>
 <CA+EHjTweLPu+DQ8hR9kEW0LrawtaoAoXR_+HmSEZpP-XOEm2qg@mail.gmail.com>
 <20210812084600.GA5912@willie-the-truck>
In-Reply-To: <20210812084600.GA5912@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 12 Aug 2021 11:28:50 +0200
Message-ID: <CA+EHjTx7q+DeR2dNL9X6jLcqtr=ZZ5YN4WsnnbOUPvtQZP1dSQ@mail.gmail.com>
Subject: Re: [PATCH v3 06/15] KVM: arm64: Restore mdcr_el2 from vcpu
To: Will Deacon <will@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Will,

On Thu, Aug 12, 2021 at 10:46 AM Will Deacon <will@kernel.org> wrote:
>
> On Wed, Jul 21, 2021 at 08:37:21AM +0100, Fuad Tabba wrote:
> > On Tue, Jul 20, 2021 at 3:53 PM Andrew Jones <drjones@redhat.com> wrote:
> > >
> > > On Mon, Jul 19, 2021 at 05:03:37PM +0100, Fuad Tabba wrote:
> > > > On deactivating traps, restore the value of mdcr_el2 from the
> > > > newly created and preserved host value vcpu context, rather than
> > > > directly reading the hardware register.
> > > >
> > > > Up until and including this patch the two values are the same,
> > > > i.e., the hardware register and the vcpu one. A future patch will
> > > > be changing the value of mdcr_el2 on activating traps, and this
> > > > ensures that its value will be restored.
> > > >
> > > > No functional change intended.
> > >
> > > I'm probably missing something, but I can't convince myself that the host
> > > will end up with the same mdcr_el2 value after deactivating traps after
> > > this patch as before. We clearly now restore whatever we had when
> > > activating traps (presumably whatever we configured at init_el2_state
> > > time), but is that equivalent to what we had before with the masking and
> > > ORing that this patch drops?
> >
> > You're right. I thought that these were actually being initialized to
> > the same values, but having a closer look at the code the mdcr values
> > are not the same as pre-patch. I will fix this.
>
> Can you elaborate on the issue here, please? I was just looking at this
> but aren't you now relying on __init_el2_debug to configure this, which
> should be fine?

I *think* that it should be fine, but as Drew pointed out, the host
does not end up with the same mdcr_el2 value after the deactivation in
this patch as it did after deactivation before this patch. In my v4
(not sent out yet), I have fixed it to ensure that the host does end
up with the same value as the one before this patch. That should make
it easier to check that there's no functional change.

I'll look into it further, and if I can convince myself that there
aren't any issues and that this patch makes the code cleaner, I will
add it as a separate patch instead to make reviewing easier.

Thanks,
/fuad

> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
