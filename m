Return-Path: <SRS0=F5E6=BK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D348DC433DF
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 10:21:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4DAED2245C
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 10:21:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="BNpQV+Z3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DAED2245C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78CCD4B31E;
	Fri, 31 Jul 2020 06:21:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CHTQ1FU71tnC; Fri, 31 Jul 2020 06:21:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B8484B315;
	Fri, 31 Jul 2020 06:21:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCB354B314
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 06:21:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 84+JvfKU636h for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jul 2020 06:21:02 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B49DE4B30E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 06:21:02 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id r2so22416313wrs.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 03:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=tlyYYf/Awn2T38hBnmjK6jzNxCNHc/2ikQvsgtHicG0=;
 b=BNpQV+Z3S1XPedR/OfLQJCv/YgfZxOKnLWtssDaKzT8mAP5LpnGk1kdHh+9uHgkYvG
 QXlipzP1W22vSvhfPeORPo1UmZjDZu9du7NDWOyUImdiCneKI9BtH9zJxQx4Qc+uG4Wx
 uKlSNdBoq+3iS26imAp2t8QNwxy8EY7Aqs/WWuJ/2h4IIM8soR8KGo6B4eys83HAjzqZ
 UeB5iYmZaSPx3eUjEEeZ8Faxgsk9EUpDpDuBvQatj0qfdC3BNSPL6IUu3+Gh7GpWv0Gy
 HDVVE12kzIlnebfrk6oThLRvQktTyzfHHTJAqMUjJmYey1AaiEMTruJMVkV4/pYp3LQY
 aOzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=tlyYYf/Awn2T38hBnmjK6jzNxCNHc/2ikQvsgtHicG0=;
 b=BorwjadncEcpR814ftGlNEBlGakH89gpVnwe8HdEGISVWY/w6Q/GjjS6oM0F2kWPdr
 D/JEF99kf9Q4V/sxy7LJf4vQ0PsfrFh+xRcBEKTRfT9wWS0KiNIWBShOBGaTBtkKGCSm
 s7YQTGXeUcZblDNfLaPDT77NMs14fx0VEXv4F23NA6Cqy/qwQWmNYdVNmtKHW0P26BV6
 CYOLw2rkASCazIKTX4VzR1rVlVKTtwvNLYo8UE6dtcfEut2j6kCibyl4NKJ7V2mmwSDV
 wsAeXu2QyoldXEvLG/33oEd2iYd2MzSV/YXH4EaPokTow5oyLqum1sibgDcriIK+mGoK
 oHrQ==
X-Gm-Message-State: AOAM531RSM/nJEuSTNYvrJuL03lEYC6otqlJLK3G3Oh0BWXVBkRPdY9+
 y+QcONFQvBI4js33UrMvwiMN7w==
X-Google-Smtp-Source: ABdhPJxfpNt8qWSwrcd3jCfr2Huys8T1Q7h7GZsQClNi1SPjvvaAcaVT6+1ZBIJVxLflpawQJ1ONUg==
X-Received: by 2002:a5d:4e8c:: with SMTP id e12mr2881170wru.19.1596190861510; 
 Fri, 31 Jul 2020 03:21:01 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id g145sm19131790wmg.23.2020.07.31.03.21.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 31 Jul 2020 03:21:00 -0700 (PDT)
Date: Fri, 31 Jul 2020 11:20:56 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/2] KVM: arm64: nVHE: Don't consume host SErrors with RAS
Message-ID: <20200731102056.GA2547274@google.com>
References: <20200730151823.1414808-1-ascull@google.com>
 <20200730151823.1414808-2-ascull@google.com>
 <20200730223144.GA2022880@google.com>
 <8d469be9de5ce825ffeacdb530731591@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8d469be9de5ce825ffeacdb530731591@kernel.org>
Cc: kernel-team@android.com, catalin.marinas@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

On Fri, Jul 31, 2020 at 09:00:03AM +0100, Marc Zyngier wrote:
> Hi Andrew,
> 
> On 2020-07-30 23:31, Andrew Scull wrote:
> > On Thu, Jul 30, 2020 at 04:18:23PM +0100, Andrew Scull wrote:
> > > The ESB at the start of the vectors causes any SErrors to be
> > > consumed to
> > > DISR_EL1. If the exception came from the host and the ESB caught an
> > > SError, it would not be noticed until a guest exits and DISR_EL1 is
> > > checked. Further, the SError would be attributed to the guest and not
> > > the host.
> > > 
> > > To avoid these problems, use a different exception vector for the host
> > > that does not use an ESB but instead leaves any host SError pending. A
> > > guest will not be entered if an SError is pending so it will always be
> > > the host that will receive and handle it.
> > 
> > Thinking further, I'm not sure this actually solves all of the problem.
> > It does prevent hyp from causing a host SError to be consumed but, IIUC,
> > there could be an SError already deferred by the host and logged in
> > DISR_EL1 that hyp would not preserve if a guest is run.
> > 
> > I think the host's DISR_EL1 would need to be saved and restored in the
> > vcpu context switch which, from a cursory read of the ARM, is possible
> > without having to virtualize SErrors for the host.
> 
> The question is what do you if you have something pending in DISR_EL1
> at the point where you enter EL2? Context switching it is not going to
> help. One problem is that you'd need to do an ESB, corrupting DISR_EL1,
> before any memory access (I'm assuming you can get traps where all
> registers are live). I can't see how we square this circle.

I'll expand on what I understand (or think I do) about RAS at the
moment. It should hopefully highlight anything wrong with my reasoning
for your questions.

DISR_EL1.A being set means a pending physical SError has been
consumed/cleared. The host has already deferred an SError so saving and
restoring (i.e. preserving) DISR_EL1 for the host would mean the
deferred SError is as it was on return to the host.

If there is a pending physical SError, we'd have to keep it pending so
the host can consume it. __guest_enter has the dsb-isb for RAS so
SErrors will become pending, but it doesn't consume them. I can't
remember now whether this was reliable or not; I assumed it was as it is
gated on the RAS config.

The above didn't need an ESB for the host but incorrect assumptions
might change that.

> Furthermore, assuming you find a way to do it, what do you do with it?
> 
> (a) Either there was something pending already and it is still pending,

If a physical SError is pending, you leave it pending and go back to the
host so it can consume it.

> (b) Or there was nothing pending and you now have an error that you
>     don't know how to report (the host EL1 never issued an ESB)

If there isn't a physical SError pending, either there is no SError at
all (easy) or the SError has already been consumed to DISR_EL1 by a host
ESB and we'd preserve DISR_EL1 for the host to handle however it chooses.

> We could just error out on hypercalls if DISR_EL1 is non-zero, but
> I don't see how we do that for traps, as it would just confuse the host
> EL1.

Traps would need to be left pending. Detected but not consumed with the
dsb-isb in __guest_enter.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
