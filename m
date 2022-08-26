Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB27ECAAA2
	for <kvmarm@archiver.kernel.org>; Fri, 26 Aug 2022 00:55:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6531A4E39F;
	Thu, 25 Aug 2022 20:55:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ROKx70OFcHoi; Thu, 25 Aug 2022 20:55:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CC9F4E397;
	Thu, 25 Aug 2022 20:55:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2FEB4E390
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 20:55:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yXrmTWl6Sj7s for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 20:55:56 -0400 (EDT)
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com
 [209.85.222.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 71B5A4E392
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 20:55:56 -0400 (EDT)
Received: by mail-ua1-f49.google.com with SMTP id ay32so44480uab.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 17:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=Q38MYI/tB7P48jbjK/kQHhk0xFiHLxsSEMIXEv+JO3E=;
 b=G29bWRtyZy9P6r9YlTl70KqH3ggLY3zlQqPBRcoeA0voBFlbmhd47e2ZWvohV8HbdG
 la2Uh74ZC6ob0r7IpH64PykIlZUaaiETr55+qePRw5lhUKFjYOJkCMLNNV31NnjSZTXy
 ZH1e2ErGcLkV/aAIh8ZoeWFyKExq+WlK7Isc+JRypZpraUMCVW9eEltzwXJHqR1a8uNq
 jyVMON3XmMnC570YlQSC+kLGa/PoP6k1mleG70uJLIcnsmej6R8zSv6hNdRmi4cG1iZD
 GZMsumg1aGNIMTkx/WwandlNlYS3El8MacRQTaaRArg+em172gdHXQIoE/ZgVkem1vGY
 oFPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=Q38MYI/tB7P48jbjK/kQHhk0xFiHLxsSEMIXEv+JO3E=;
 b=yhKX805H8yPBJ+Gz9oxN+yw3Zx8ON4+q6kZdf8MG3vkdIZ3NBEAPeODlcEsmz5PdUq
 kIeIYnfSLztuv+AW4aW17iDMtUvFHzGK/BFt6RXFPyrGSpmOkBmMuerYx8QlmubIzJAC
 87ZyDUylcE+pasPutNvfacYkoHH9x8Oob3GwvYNa1URCybCBHtC8b5StUTc1PcO+Y6c3
 PGYus9ltPbYWYR+nIo9zry0Y+ABlGhQT/N4XmiiJJLGGLWf0ls6HYfi0BwdoSkg+wdq6
 gKOZfFsfe/qYGdcy9V1+D+kM8r0LqQumQ/1CJagbrfpxKsIVeV6jILJubpc49gjOgjdR
 aRzg==
X-Gm-Message-State: ACgBeo0R/X98+Jo2pNwaOtENYNG83AuPy1ct6DGUTuI9J0rVTRwSc+j3
 J+nnA6jXQZNJym5scmV5wnsLJKL4g7jFqi3HINi7Ng==
X-Google-Smtp-Source: AA6agR5iIE3/MAgvpYVx+OGJVYtZB1InIPoWCx4I8Hf0SCLJ5xOMM0asaVq4yKS5esiQcKdpRXSN/VWSPQgHu7WnXaI=
X-Received: by 2002:ab0:23c9:0:b0:39b:52f0:810d with SMTP id
 c9-20020ab023c9000000b0039b52f0810dmr2477097uan.46.1661475356000; Thu, 25 Aug
 2022 17:55:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-5-reijiw@google.com>
 <YwevrW4YrHQQOyew@google.com>
In-Reply-To: <YwevrW4YrHQQOyew@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 25 Aug 2022 17:55:40 -0700
Message-ID: <CAAeT=FxcoKTtzX1SCffQTV=8XdcaU35dpP0YdjWR1G7BuRMBBA@mail.gmail.com>
Subject: Re: [PATCH 4/9] KVM: arm64: selftests: Add helpers to enable debug
 exceptions
To: Oliver Upton <oliver.upton@linux.dev>
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

Hi Oliver,

On Thu, Aug 25, 2022 at 10:22 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Wed, Aug 24, 2022 at 10:08:41PM -0700, Reiji Watanabe wrote:
> > Add helpers to enable breakpoint and watchpoint exceptions.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  .../selftests/kvm/aarch64/debug-exceptions.c  | 25 ++++++++++---------
> >  1 file changed, 13 insertions(+), 12 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > index 183ee16acb7d..713c7240b680 100644
> > --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > @@ -128,10 +128,20 @@ static void enable_os_lock(void)
> >       GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
> >  }
> >
> > +static void enable_debug_bwp_exception(void)
>
> uber-nit: enable_monitor_debug_exceptions()
>
> (more closely matches the definition of MDSCR_EL1.MDE)

Thank you for the proposal. Sounds better!


> With that:
>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thank you for the review!
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
