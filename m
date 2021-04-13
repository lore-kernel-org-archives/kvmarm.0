Return-Path: <SRS0=w1us=JK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F15DC433ED
	for <kvmarm@archiver.kernel.org>; Tue, 13 Apr 2021 19:45:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F4A6613CB
	for <kvmarm@archiver.kernel.org>; Tue, 13 Apr 2021 19:45:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F4A6613CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1D7F4B529;
	Tue, 13 Apr 2021 15:45:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DotRExiS5H-G; Tue, 13 Apr 2021 15:45:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9C5A4B52B;
	Tue, 13 Apr 2021 15:45:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B70B54B505
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Apr 2021 15:45:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZULH7gmNlxYU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Apr 2021 15:45:11 -0400 (EDT)
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com
 [209.85.166.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A34CC4B4F2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Apr 2021 15:45:11 -0400 (EDT)
Received: by mail-io1-f44.google.com with SMTP id d5so8852382iof.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Apr 2021 12:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=upcJOzSdtmyTTQX1IXdafKF32BVsYJ7uv7HZcWzthW0=;
 b=MN9kHN7HuY6efFva11rZAeslcmoDAXpDz2MGjIPjeV9bb603YPTe+MCIwP7i6AOLl2
 z+JOkSxnmyu7qI3WTNPjR0lrhJ37w4S44bTA0xVYnQ43d0sYI6R1WyhDxOtJG8TRTsoT
 gaTfwWI0gIfuzH5Iqp1zIz5mlyBK9oXdesmzyfjkaHrGmBDTLD+LNYqRcg4ehYIzNAr1
 jZBdmiUtLMmHd4UlQV7aewF/VmRUkYwilQRXnHBePOJUy/nQ3RLwlVFoR+UfFDwDG1iJ
 ITTmEjfI0H9mOcUpwOBKJulSfLg+CW93RddQr7JFq3WuMGIyN/VgFOulnxm4k/njKwgV
 +c9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=upcJOzSdtmyTTQX1IXdafKF32BVsYJ7uv7HZcWzthW0=;
 b=M5w4AjJMx8KcH9UKL7I4xt+vp85xpC0To9CgGfp7Az9XyVhSvDYvq92/ViFv1Su9cK
 mx3RVAj3ortcsgtIiwfcjvBCdjfSiY7havKn9YsiO+q+UnrWSAeFZ2F5wXWITesNnVRf
 ppW8G0M6JDe2FL4BIcmjwPMZ/WX+ayGGobsHcYRk+BZshdY9IdbahvbzpWSwwuFKcDtR
 TBx1jQ/t8YmNBQmDjn2JJoeYhJT+DHUasR5TYB3z5Cps9XNTVUIovqvVj4N1tiYgxBTQ
 qpDQA3tOfxYy+gbo/SXObY026/xhAnHaPup0Tg4X1rOdJ53Fu3+VB2/2bmBv6E0nDdZa
 9mag==
X-Gm-Message-State: AOAM5330eDu7abJvbDhqa7MrIBFdjERnXVmIJ13tfLxAWpYGIuu8YXoh
 /jdY4QU9KgcwCFpvx8zsXDxXpxlOucBNgjjwUtJzng==
X-Google-Smtp-Source: ABdhPJwbV8V06+saspZNqcwJyMAx5dOf3XUcNeGYjvdvGRErS6Zn3bUKmYLqizNeL1jLpDjx6JynHdRlOTfMwHzKh+s=
X-Received: by 2002:a05:6602:2089:: with SMTP id
 a9mr11754595ioa.90.1618343110996; 
 Tue, 13 Apr 2021 12:45:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210413161952.750262-1-mathieu.poirier@linaro.org>
 <87sg3um8j1.wl-maz@kernel.org>
In-Reply-To: <87sg3um8j1.wl-maz@kernel.org>
From: Mathieu Poirier <mathieu.poirier@linaro.org>
Date: Tue, 13 Apr 2021 13:45:00 -0600
Message-ID: <CANLsYkyyqSAe=9O2MyeX0z0sS501uD2+7NuDVv5V9LeAbbMDoQ@mail.gmail.com>
Subject: Re: [GIT PULL] coresight: Fixes for ETE and TRBE
To: Marc Zyngier <maz@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Greg KH <gregkh@linuxfoundation.org>,
 Coresight ML <coresight@lists.linaro.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

On Tue, 13 Apr 2021 at 10:52, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Mathieu,
>
> On Tue, 13 Apr 2021 17:19:52 +0100,
> Mathieu Poirier <mathieu.poirier@linaro.org> wrote:
> >
> > The following changes since commit 4fb13790417a7bf726f3867a5d2b9723efde488b:
> >
> >   dts: bindings: Document device tree bindings for Arm TRBE (2021-04-06 16:05:38 -0600)
> >
> > are available in the Git repository at:
> >
> >   git@gitolite.kernel.org:pub/scm/linux/kernel/git/coresight/linux.git next-ETE-TRBE
> >
> > for you to fetch changes up to 68d400c079978f649e7f63aba966d219743edd64:
> >
> >   coresight: trbe: Fix return value check in arm_trbe_register_coresight_cpu() (2021-04-13 09:46:27 -0600)
> >
> > ----------------------------------------------------------------
> > Hi Marc,
> >
> > Please consider these two patches, they are ETE/TRBE fixes found by bots.
> >
> > Let me know if you want me to rebase on your next branch and send the
> > pull request from that.
>
> I've now pulled this into kvmarm/next. If you have additional fixes,
> just stick them on top of your next-ETE-TRBE branch like you did with
> these two patches.
>

Much appreciated - I owe you a beer.

> The kvmarm/next branch gets rebuilt every other day, so it isn't a
> stable branch on its own. Only the non-merge commits are stable, which
> is why I keep everything on topic branches.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
