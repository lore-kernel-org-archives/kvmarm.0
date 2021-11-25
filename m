Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2268C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 25 Nov 2021 02:23:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 636434B177;
	Wed, 24 Nov 2021 21:23:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5tc4aH1Eglc2; Wed, 24 Nov 2021 21:23:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F8854B15C;
	Wed, 24 Nov 2021 21:23:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CD914B12E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 21:23:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GAblsf9PmDWc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Nov 2021 21:23:48 -0500 (EST)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 45D924B129
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 21:23:48 -0500 (EST)
Received: by mail-pj1-f43.google.com with SMTP id
 fv9-20020a17090b0e8900b001a6a5ab1392so4443568pjb.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 18:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=xFLS5Osf0Yq9hrh1R+jPqQbxrd4QeHBJiKo15Rlwxss=;
 b=gt+CnbIhXSWZFRXO+JyoFnk7WgmjKBbkUkhF9Hto5JtuBqgdv4VEkkEN7LTIMqcNo3
 fJa3lV7sl7T6tVrE5Qxf/hDkbDePK91LPbOxfpI8k9AvkVK5KzLK/K1Weiax6SB0wkdF
 3n14xLxD1mBRl6dFCKL6GdrGNaTItauZtatK0NnbKxrMw/oyNH8TWvWdSL2IQuAI5IhY
 roZLPPRcMD3QsruezRFnclk5QhgurJim6oRq3veff6G+nYO6JhYAURzFW3Xf4kb8ylz5
 KvfgIDali36j+6mqKA/FEpC+Lltqm0xWo0zxvRLD4yPKz8Brr0r8j62VYQoWqHsL4RAv
 j4Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xFLS5Osf0Yq9hrh1R+jPqQbxrd4QeHBJiKo15Rlwxss=;
 b=TaZrvi1X7K+oEfaqE5DKDU1gNIDzlUP15/EnsfaooC1X8ZpOrPO6c8HgBP4hHlxCHw
 BLltN9U5Qb7jDk8JGD10ICaG/WSTtK5XkPD0qu4flM3FiKnFtqOTvqatHsnhM4VvvNK1
 cbdw+yGZLtgzD2IHLBglZ6+QonMvt45mYMX1Pvk+RT5PuA+QlQ6/fdwNRhmdpOS6fNLj
 BHZFlLcdWNN7SJSaPXT9eJRIw02AZ+sGVr2ip2TeoebSEQ7l9WocS3cGbs6PZrgZpALQ
 842yvnFVpO0wkZwNp4ddSxWpVGl+C9DMXcpKu3x904ocUT/EZjUWH0LjXUIsQq/BFlPQ
 SYOg==
X-Gm-Message-State: AOAM532/mcJCcTgZl3yErlOXs5Wn27KWJyowMMViCZzlJNcLscN4+io7
 DnNWZ9WnMIpz0gGNK1PSM2p6Ww==
X-Google-Smtp-Source: ABdhPJyFZuUHjsN9HP6H4qPfFRhjwow47Wx9NzNMHdvs7iUWMDG4eO/Sk4e4+s2lEUImw4f5MDk9ww==
X-Received: by 2002:a17:90b:1e49:: with SMTP id
 pi9mr2597640pjb.232.1637807026679; 
 Wed, 24 Nov 2021 18:23:46 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id z19sm1032446pfe.181.2021.11.24.18.23.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 24 Nov 2021 18:23:46 -0800 (PST)
Date: Wed, 24 Nov 2021 18:23:42 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 00/17] KVM: selftests: aarch64: Test userspace IRQ
 injection
Message-ID: <YZ7zruK4ox/Qge90@google.com>
References: <20211109023906.1091208-1-ricarkol@google.com>
 <20211123142524.4bjhdvw5pkx3g5ct@gator.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211123142524.4bjhdvw5pkx3g5ct@gator.home>
Cc: shuah@kernel.org, kvm@vger.kernel.org, maz@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On Tue, Nov 23, 2021 at 03:25:24PM +0100, Andrew Jones wrote:
> On Mon, Nov 08, 2021 at 06:38:49PM -0800, Ricardo Koller wrote:
> > This series adds a new test, aarch64/vgic-irq, that validates the injection of
> > different types of IRQs from userspace using various methods and configurations
> > (when applicable):
> > 
> >     Intid        Method     |       |          Configuration
> >                             |       |
> >                IRQ_LINE     |       |
> >     SGI        LEVEL_INFO   |       |
> >     PPI    x   IRQFD        |   x   | level-sensitive  x  EOIR + DIR
> >     SPI        ISPENDR      |       | edge-triggered      EOIR only
> >     bogus      ISACTIVER    |       |
> >                             |       |
> > 
> > vgic-irq is implemented by having a single vcpu started in any of the 4 (2x2)
> > configurations above.  The guest then "asks" userspace to inject all intids of
> > a given IRQ type using each applicable method via a GUEST_SYNC call.  The
> > applicable methods and intids for a given configuration are specified in tables
> > like this one:
> > 
> >     /* edge-triggered */
> >     static struct kvm_inject_desc inject_edge_fns[] = {
> >             /*                            sgi    ppi    spi */
> >             { KVM_IRQ_LINE,               false, false, true },
> >             { IRQFD,                      false, false, true },
> >             { ISPENDR,                    true,  false, true },
> >     };
> > 
> > Based on the (example) table above, a guest running in an edge-triggered
> > configuration will try injecting SGIs and SPIs.  The specific methods are also
> > given in the table, e.g.: SGIs are injected from userspace by writing into the
> > ISPENDR register.
> > 
> > This test also adds some extra edge tests like: IRQ preemption, restoring
> > active IRQs, trying to inject bogus intid's (e.g., above the configured KVM
> > nr_irqs).
> > 
> > Note that vgic-irq is currently limited to a single vcpu, GICv3, and does not
> > test the vITS (no MSIs).
> > 
> > - Commits 1-3 add some GICv3 library functions on the guest side, e.g.: set the
> >   priority of an IRQ.
> > - Commits 4-5 add some vGICv3 library functions on the userspace side, e.g.: a
> >   wrapper for KVM_IRQ_LINE.
> > - Commit 6 adds the basic version of this test: inject an SPI using
> >   KVM_IRQ_LINE.
> > - Commits 7-17 add other IRQs types, methods and configurations.
> >
> 
> Hi Ricardo,
> 
> I didn't review this in detail, but it looks good and quite thorough.

Thanks Andrew!

> Out
> of curiosity did thoroughness come from attempting to get coverage on KVM
> code?

Yes, that was the main reason. Although, keep in mind that there are a
lot of features not covered, like routing and the ITS.

> I.e were you running some sort of code coverage tool on KVM with
> these tests?

No, not really. It would be nice to know how much coverage (and
distribution) we are getting from all tests (selftests and KUT) at the
moment and maybe use that to decide on future tests.

> 
> Unfortunately I probably won't have a chance to look much closer than the
> scan I just did, so FWIW
> 
> For the series
> 
> Acked-by: Andrew Jones <drjones@redhat.com>
> 
> Thanks,
> drew
> 

Thanks,
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
