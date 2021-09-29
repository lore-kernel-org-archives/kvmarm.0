Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C78E0C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 15:56:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 373DA60FA0
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 15:56:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 373DA60FA0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B73A24B135;
	Wed, 29 Sep 2021 11:56:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QybR9tu-uz-t; Wed, 29 Sep 2021 11:56:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAFE34B12C;
	Wed, 29 Sep 2021 11:56:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94A854B0EC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 11:56:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jZ7s8nythmh7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 11:56:18 -0400 (EDT)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
 [209.85.214.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 636BF4B0DF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 11:56:18 -0400 (EDT)
Received: by mail-pl1-f175.google.com with SMTP id j4so364514plx.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 08:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=QXqhrOe99SMkwy7xOUQxSfO26TmAo7lLUFFlJf608N0=;
 b=Tv8zIpJ1xnCFM6xhqdlL4/vIvDrFT70hpY7YZvbNRnBVFOG4552p58wruczMQgdZKK
 eeSXc9vgKvRWFa2wZKncJtuoLccB/SQD0lZb373whHXgP0hN/syk+1YESmAJ6Ckzumcc
 NhvyhMJ3gxZLYVgkzClSHDzRrlf9ZGze6PJb4Rjp/jG+ril8oNOXTXLsWT1pRrkPtmqL
 4PUV0yFNHSQKSen8HonJ/GYpFyC1hMu/UjTjUXDwstRpbzIuCAqm2crgOGwYwr7WvZkG
 XmVQ1BpAVbDup/q/pmVYh+eI2ZnBlN5C050/HolusT4O+D/tiDJeb9Jde5hqcWLG1a89
 ivNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=QXqhrOe99SMkwy7xOUQxSfO26TmAo7lLUFFlJf608N0=;
 b=qSynkPJb2lGp0iLOpCna6R/Qzd+TmyqMPNCC6yJpDyLBuq/4ZUq5QFaAbie7ax1CqX
 TJNRbRNWO3HPXEphzKS2ya+bZYbaYZKm3OFBIRqeckvDUYUUqkSkHWLSH5sAGcTP+HXt
 VN+h8G5XD8/pgiVlf7cvPMklF3tf/K9TwxunYCZgf1j9uo/aAj7CGsWtPo88JSPVRnXg
 4PG0GmzlyLiYoSxcmUjAgYIjHMckCDylrwqD+VteQ7TJ9axueEN47Gb+prus6TpUJVrW
 E8iL2YrVZG9sXPt4FWJypEFN0Jd1l1rZy6IwobjLJjDmouvGPN+S7Xq34Gq5qtJR6mmJ
 t+Ww==
X-Gm-Message-State: AOAM530cAUQRykzLZPBvd+VAAi0Sy3TFYGaizGlVkHdQq1ZAMwZyEgaJ
 mfE+vebuVB6+99Ls3i8bFS9skw==
X-Google-Smtp-Source: ABdhPJyyJ63l3Jgn/wkbO4utLpV1s4Zsct68SOclwmSTKlsnuKe6K74rJe7GIbs8jNqvwhk7Zjw+fQ==
X-Received: by 2002:a17:90a:8b82:: with SMTP id
 z2mr423618pjn.216.1632930977189; 
 Wed, 29 Sep 2021 08:56:17 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id p16sm242556pfq.95.2021.09.29.08.56.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Sep 2021 08:56:16 -0700 (PDT)
Date: Wed, 29 Sep 2021 15:56:12 +0000
From: Sean Christopherson <seanjc@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 2/2] KVM: arm64: Depend on HAVE_KVM => OF instead of
 directly on OF
Message-ID: <YVSMnE8vJFdj7J+N@google.com>
References: <20210921222231.518092-1-seanjc@google.com>
 <20210921222231.518092-3-seanjc@google.com>
 <20210929155328.GD22029@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210929155328.GD22029@willie-the-truck>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Wed, Sep 29, 2021, Will Deacon wrote:
> On Tue, Sep 21, 2021 at 03:22:31PM -0700, Sean Christopherson wrote:
> > Select HAVE_KVM if the KVM dependency is met (OF / Open Firmware), and
> > make KVM depend on HAVE_KVM instead of directly on OF.  This fixes the
> > oddity where arm64 configs can end up with KVM=y and HAVE_KVM=n, and will
> > hopefully prevent breakage if there are future users of HAVE_KVM.
> > 
> > Note, arm64 unconditionally selects OF, and has always done so (see
> > commit 8c2c3df31e3b ("arm64: Build infrastructure").  Keep the somewhat
> > pointless HAVE_KVM dependency on OF to document that KVM requires Open
> > Firmware support.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/arm64/Kconfig     | 1 +
> >  arch/arm64/kvm/Kconfig | 2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index b5b13a932561..38c0f36a5ed4 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -187,6 +187,7 @@ config ARM64
> >  	select HAVE_GCC_PLUGINS
> >  	select HAVE_HW_BREAKPOINT if PERF_EVENTS
> >  	select HAVE_IRQ_TIME_ACCOUNTING
> > +	select HAVE_KVM if OF
> 
> Honestly, I'd just drop the 'if OF' here. We select it unconditionally a
> few lines below and so I think it's more confusing to have the check.

Work for me.  I all but flipped a coin when deciding whether or not to keep the
OF dependency.

Thanks!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
