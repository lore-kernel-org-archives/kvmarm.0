Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FCC3C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 16:09:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF33A61181
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 16:09:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AF33A61181
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 29F094005D;
	Wed, 22 Sep 2021 12:09:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Iij8uhkSXh-p; Wed, 22 Sep 2021 12:09:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A1314B092;
	Wed, 22 Sep 2021 12:09:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 927874B092
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 12:09:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ldnq5oxtkXmL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 12:09:50 -0400 (EDT)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com
 [209.85.217.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88D8649F8F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 12:09:50 -0400 (EDT)
Received: by mail-vs1-f43.google.com with SMTP id y141so3513017vsy.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 09:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Y71TE4uaFkkTCgI01yco6eKbyLn5X7egv/SHBqUCbDo=;
 b=Fp/svNRP11jh2RubcRL/Oc5832VjhwFnu+3VYEPFZpoUrp6FXwgf1FTjEPy+r804Q7
 s4wZd9opxkvaMwWLrEqKHDLVVgvxKog9BQZEVYERP208JtmrYUDflBcm9CeUnT539XVY
 6Tza5j1HEKMC8ezxC2K4WYRan/BUBy5wEdjbldIyB9k4YGA6y20qQlfIN8oAEmfqCXSp
 P+a50/IeOvLuBpy9+nnYCFtLQSlTMrXupzHEWIyyjVoCQXw6IxMF9hjgcz7TqXNTfyJW
 cwLNpkKiswqF3h6yXa78a6Vg124snU6YXOmO3ccHHKhtVMfZw9eAROHxjp6LFJTUnpIm
 6x5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Y71TE4uaFkkTCgI01yco6eKbyLn5X7egv/SHBqUCbDo=;
 b=z4kFFHP9569vZps1wVtGyTSbfYx8biqETw4sjYwAB+vjWGBWyF2GVvS4G8syIs7ztY
 lvpp7ARlPxHSCRhT2oa2mzDUGpuptXhP48jarbU1SUmpjzx6/2vkmRIii42t4BWebPmx
 R4kY+AahIZMRiL4BIwQu8jQjEZroSpOrSDrNeOENjd+Ll/f/0DC/bZrwNqB+H/ogtF2V
 nyDFQMxfPygOPw2ejoftQtpPmqOm6NflpW5psJngjG0bX8ZmNFvs74nCJBWhjejfBYzg
 lrSLcITOHqFbfH7YpaPAA3IqEvPOVe5Y2H1mjadFSiOkeYcqz9dv5NSxw5SAWLEVqDNH
 evyg==
X-Gm-Message-State: AOAM531338SSOhcs5MRRHSNMgIjBq78vgZUgiutn1vXoqkYRo+XgmBi3
 v8Pyo9e+8TA4DHVwDSZH9XUWtrrjFFxfs4+sVrrgBQ==
X-Google-Smtp-Source: ABdhPJznyi7GhP02meVTv0+DMN8SZQNTAeHvGStQfXfgJg4o8a31GfYpx1CXw7Kxs7dzh7LBST/hYW3FOzdLEJAMlFI=
X-Received: by 2002:a05:6102:819:: with SMTP id g25mr85488vsb.21.1632326989748; 
 Wed, 22 Sep 2021 09:09:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210922010851.2312845-1-jingzhangos@google.com>
 <20210922010851.2312845-3-jingzhangos@google.com>
 <87czp0voqg.wl-maz@kernel.org>
 <d16ecbd2-2bc9-2691-a21d-aef4e6f007b9@redhat.com>
In-Reply-To: <d16ecbd2-2bc9-2691-a21d-aef4e6f007b9@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 22 Sep 2021 09:09:37 -0700
Message-ID: <CAAdAUtgrwswfX=YDgNSSOVZDQ8n91LdpL5V_80+NL2Gu9X2Vfw@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] KVM: arm64: Add histogram stats for handling time
 of arch specific exit reasons
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>
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

Hi Marc, Paolo,

On Wed, Sep 22, 2021 at 8:37 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 22/09/21 13:22, Marc Zyngier wrote:
> > Frankly, this is a job for BPF and the tracing subsystem, not for some
> > hardcoded syndrome accounting. It would allow to extract meaningful
> > information, prevent bloat, and crucially make it optional. Even empty
> > trace points like the ones used in the scheduler would be infinitely
> > better than this (load your own module that hooks into these trace
> > points, expose the data you want, any way you want).
>
> I agree.  I had left out for later the similar series you had for x86,
> but I felt the same as Marc; even just counting the number of
> occurrences of each exit reason is a nontrivial amount of memory to
> spend on each vCPU.
>
> Paolo
>
Thanks for the feedback about this. It is actually kind of what I
expected. The correct way is to add valuable h/w exit reasons which
have been verified useful for debugging and monitoring purposes
instead of exposing all of them blindly.
Will have an internal discussion about the historical reason why those
are needed in the first place and to see if the reason still exists.

Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
