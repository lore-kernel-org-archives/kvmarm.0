Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA57C432BE
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 06:59:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB36E60C41
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 06:59:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CB36E60C41
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4319A4A195;
	Wed,  4 Aug 2021 02:59:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N5onrKdgCGid; Wed,  4 Aug 2021 02:59:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44EBC40825;
	Wed,  4 Aug 2021 02:59:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E6A740825
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 02:59:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WDFSnL2et0hC for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 02:59:50 -0400 (EDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com
 [209.85.167.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5771F407F1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 02:59:50 -0400 (EDT)
Received: by mail-lf1-f49.google.com with SMTP id h2so2773676lfu.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Aug 2021 23:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=FyMnszXXyHK4JDa0x/iclyGuG1G0X7e/HsoyPTG9034=;
 b=O4ScIbiiu9dQgWr9MYBsJ7D7L5y53rgIr6rBY0Al0x6bLaD/QC54vpgVaAnYS29zlG
 wkTjmNUfxliTIQ0aQU0OZEKx3pSAgIwaYbrBd1b1EdRvMIRH/oScbeKx6KYqu9swRn2z
 AZxgEa8Lx7vQXXGr8x6tIAiHo+Z7DH/t638EfZLab02YuiXMkqPWdCqWjfTQi3GF7qc2
 2aPloOXQpeBfUEMuah/ScHkmRqOGL7yVTNpRmH80JSlRIDGcHGk3W53rikKcZOO4W5AF
 BrdYfrxYYa6MBdMuPOubwecXugERvoLpUwVVLNrk/9pAsbsWG8GIQ1HzzXBMUjA62zoJ
 RdMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=FyMnszXXyHK4JDa0x/iclyGuG1G0X7e/HsoyPTG9034=;
 b=kUvraHDxkSh1USQBajqEYGwLLGPyeg09aqlEiOov2bkxHYeaXf7wAOPNAVErVUK+74
 XgnOj0San5/uUmLsFTvqb1a8K2H3htrPG9jxueQYy8ar9Y7nmz7U1g2QQ5NAh8ivNBiH
 CUeizsugsjd86VuLJpgqLsmmPVxn6KKn/vy89IJXRq7p3Pl9AeLCS9EnHd4L1s93hN26
 FY5FESqOlWFmrqw5kX/Kv4uAEVX+GFSLwTUUbNRdpauACI/2MyVeDLnYfeXufS3VK+CQ
 WJggwSytbG9cNnBTVzshUE5mvltVdM6ZTtMEGnJ+4S7WCf7lCHkbcyhtl/H+CbdHHtFe
 aKUg==
X-Gm-Message-State: AOAM5338sPrFING1IqMNiL0NGkjBgUcGmTTsqJKzF0EqKPyg+zSQ3jZg
 nXIgqOrnpBFrhXsNdjH5n/QhBO3Fzjpqw43+AglNhw==
X-Google-Smtp-Source: ABdhPJw2rUXELmIWFkaMKtzqgTKfHrd105kgYzO8xlzBjLxsLAtt/jBBP3NH6qpDRWX+ZhCBAP9JdOZwYa8M2d7kCpc=
X-Received: by 2002:a05:6512:314a:: with SMTP id
 s10mr1127161lfi.57.1628060388794; 
 Tue, 03 Aug 2021 23:59:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com>
 <20210729173300.181775-12-oupton@google.com>
 <875yws2h5w.wl-maz@kernel.org>
 <CAOQ_QsgCrEWQqakicR3Peu_c8oCMeq8Cok+CK8vJVURUwAdG0A@mail.gmail.com>
 <87wnp722tm.wl-maz@kernel.org>
 <CAOQ_QsiwuancUsFEVr3TBeP6yLZMfAqNRv3ww2H+hcUGfxs9LA@mail.gmail.com>
In-Reply-To: <CAOQ_QsiwuancUsFEVr3TBeP6yLZMfAqNRv3ww2H+hcUGfxs9LA@mail.gmail.com>
From: Oliver Upton <oupton@google.com>
Date: Tue, 3 Aug 2021 23:59:37 -0700
Message-ID: <CAOQ_QsiChO1mGGOFL96d35bbLaUBXyYf9cZw1h-Cf3G4P=1YXg@mail.gmail.com>
Subject: Re: [PATCH v5 11/13] KVM: arm64: Provide userspace access to the
 physical counter offset
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Peter Shier <pshier@google.com>, Raghavendra Rao Anata <rananta@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

Hi Marc,

On Fri, Jul 30, 2021 at 9:48 AM Oliver Upton <oupton@google.com> wrote:
>
> On Fri, Jul 30, 2021 at 9:18 AM Marc Zyngier <maz@kernel.org> wrote:
> > You want the ARM FVP model, or maybe even the Foundation model. It has
> > support all the way to ARMv8.7 apparently. I personally use the FVP,
> > get in touch offline and I'll help you with the setup.
> >
> > In general, I tend to trust the ARM models a lot more than QEMU for
> > the quality of the emulation. You can tune it in some bizarre way
> > (the cache modelling is terrifying), and it will definitely do all
> > kind of crazy reordering and speculation.
>
> Awesome, thanks. I'll give this a try.
>

I have another spin of this series ready to kick out the door that
implements ECV support but ran into some issues testing it... Seems
that the ARM Foundation model only implements ECV=0x01, when we need
ECV=0x02 for CNTPOFF_EL2 to be valid. Any thoughts, or shall I just
send out the series and stare at it long enough to make sure the ECV
parts look right ;-)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
