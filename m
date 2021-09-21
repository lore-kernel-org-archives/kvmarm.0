Return-Path: <SRS0=fzUG=OL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2608AC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 17:43:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A34161166
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 17:42:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8A34161166
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19CFC4A19A;
	Tue, 21 Sep 2021 13:42:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OsIOY1wsrsdL; Tue, 21 Sep 2021 13:42:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 162E54A00B;
	Tue, 21 Sep 2021 13:42:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5B7D4079D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 13:42:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3eKp4cbBndJb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 13:42:55 -0400 (EDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com
 [209.85.167.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 45F2E40191
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 13:42:55 -0400 (EDT)
Received: by mail-lf1-f49.google.com with SMTP id e15so572182lfr.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 10:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=x1n9q3vbepQtsoN7gIbjiMfEKFVaYsnFrh4UdZ590q4=;
 b=gQ4YOC5JIZpP+oRfrOy7fTkK+PIvcU0eOLvMtinsTsNE/Q0NMHbRsMTWdE7u/x2v3l
 ApckSD+kd0l+BB+KI3plO0FTdGIQW3FSf4YUg4ZLgu/T7Y+ISYawC2G5xICi/4tGCYv9
 m2UYrhVrKhGSdoRbjmlzWEEBpn5L5Ko5S77BhDW3AdZF3keWwXzmxCGXMcwqSqiyT95r
 K1jO9t9Ji6jVFntgKSH5XAgfXxpB8RW2mo+PlvHLCXhqYUM+EVx0baT7mvD08pZ5tX6O
 8HBjqB7O0BsXvq8b5DG85Ol43wGigt6TuFkn/cDV5JQ82+GBPC74Gup85mrUBilZbztx
 1nYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=x1n9q3vbepQtsoN7gIbjiMfEKFVaYsnFrh4UdZ590q4=;
 b=YOOLEsJWKIvhkFhAKSqk5MP8HSPsWUqVQ7+qfonRmgTJMvTjecFNuxYGza2Cxw4OW7
 KukZTodtsjIssEi4jOnYZlzS0CnIcPRPwhW9wP0XRSfYqkmIAW+1ief2sOKt0j301qXa
 HeLWe8o5I9FzEptI13K02g7xHMK5qN73jMlbO64fgvjgvXzEEM9QIYdFLr07NcmvhcY6
 BjNUDvwZGsv8kedcMRqGoF1yIcK+IEdaQQz52NSaDL3X9QhzLquKXSrGeMQG77U66cB8
 WO0wFmlUX9UvgYZrgbLrbROqrL2yUqbnRGSy2M+r2qTtv7yPnGNBedP/98X0qhsKHOwi
 D9Zg==
X-Gm-Message-State: AOAM532qktwh670iIcRfeROmvYgKzO4TILli88vWSYS86sqYGOaHh9Qh
 t0GPhI2xWoF3P0kUSCHshWCBz0FcqVza3+H/kLqyTA==
X-Google-Smtp-Source: ABdhPJzta0UHM2xo/JOt/RXafPSRUTqAzaLV6K6nYr9EJEx3X7wLpaDYUsi/AFu1dosOcGYxchuIVMoNQyUEuGJRMiI=
X-Received: by 2002:ac2:4a6e:: with SMTP id q14mr24881198lfp.685.1632246173682; 
 Tue, 21 Sep 2021 10:42:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210921010120.1256762-1-oupton@google.com>
 <20210921010120.1256762-2-oupton@google.com>
 <1fcd4084-c1fe-0689-da46-5d81191eeae7@redhat.com>
In-Reply-To: <1fcd4084-c1fe-0689-da46-5d81191eeae7@redhat.com>
From: Oliver Upton <oupton@google.com>
Date: Tue, 21 Sep 2021 10:42:42 -0700
Message-ID: <CAOQ_QshcN-wcQy9Dv8V6OEKk5OTm5165A3k4tA56KeqfgC2iug@mail.gmail.com>
Subject: Re: [PATCH 1/2] selftests: KVM: Fix compiler warning in
 demand_paging_test
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Sean Christopherson <seanjc@google.com>, kvmarm@lists.cs.columbia.edu,
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

Hi Paolo,

On Tue, Sep 21, 2021 at 10:38 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 21/09/21 03:01, Oliver Upton wrote:
> > Building demand_paging_test.c with clang throws the following warning:
> >
> >>> demand_paging_test.c:182:7: error: logical not is only applied to the left hand side of this bitwise operator [-Werror,-Wlogical-not-parentheses]
> >                    if (!pollfd[0].revents & POLLIN)
> >
> > Silence the warning by placing the bitwise operation within parentheses.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >   tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> > index e79c1b64977f..10edae425ab3 100644
> > --- a/tools/testing/selftests/kvm/demand_paging_test.c
> > +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> > @@ -179,7 +179,7 @@ static void *uffd_handler_thread_fn(void *arg)
> >                       return NULL;
> >               }
> >
> > -             if (!pollfd[0].revents & POLLIN)
> > +             if (!(pollfd[0].revents & POLLIN))
> >                       continue;
> >
> >               r = read(uffd, &msg, sizeof(msg));
> >
>
> Queued (with small adjustments to the commit message and Cc: stable),
> thanks.

I sent out a v2 of this series that addressed Drew's comments here and
picked up his suggested fix for 2/2. Would you like to queue that
version instead?

http://lore.kernel.org/kvm/20210921171121.2148982-1-oupton@google.com

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
