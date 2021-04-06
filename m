Return-Path: <SRS0=ghsx=JD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34832C433ED
	for <kvmarm@archiver.kernel.org>; Tue,  6 Apr 2021 17:58:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8DA29613D5
	for <kvmarm@archiver.kernel.org>; Tue,  6 Apr 2021 17:58:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DA29613D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC8A64B783;
	Tue,  6 Apr 2021 13:58:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CtmRPuIpjk0R; Tue,  6 Apr 2021 13:58:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD0114B7B3;
	Tue,  6 Apr 2021 13:58:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CAFD4B783
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Apr 2021 13:58:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2foZiOV+IHAP for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Apr 2021 13:58:18 -0400 (EDT)
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com
 [209.85.166.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53DBC4B76E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Apr 2021 13:58:18 -0400 (EDT)
Received: by mail-il1-f175.google.com with SMTP id 6so4225965ilt.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Apr 2021 10:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=vGkQibEhIMdD/p8ZIvDkxPOyyzWAR6ElrjD/hXxlZ+o=;
 b=pwdcqtcQFLyaOUfrHtEFFwBrCsuNVSW0ieW/zjYyIO9wwYBCcLDmcRMoHi3L9Ml8gy
 ieV8caoK32xe2eFZpQRBihOKHKGREk6/9Bbgfl4lLevVQx44IaKplPquArQBONPzI6PC
 jVfarE6LPmYu0+RaTod/zz9pDa9QI+6Tr23RCLWNsH9YvvXCGSe450uPgLQo2HiNP+QY
 kEeQdq5pyPp3RjdHdKersgHHDhwtwO8Af5r9B4zlFzRYRrHTEBMwQiyTM2QnuK31s4X8
 RAnsMexNXGckLopIEYjKuk5NBqShLGWu+M7Aw+hh5Tw8KzmFsvkcnMzbibk4GKoOWg+5
 hKkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=vGkQibEhIMdD/p8ZIvDkxPOyyzWAR6ElrjD/hXxlZ+o=;
 b=kFwlc2VxG73Vm7ipsBLNdwcIA9mpylu3hzhTKy+zaD6Ykh7k87c0vWPvnIz/ErHJM/
 Vo8ud7Ftp2AGyyri0FKT31yzDPLeg2S7C2zatPr6Fgtpb9R6jvvAVJNPCHP8AnYm7A2m
 ce0qxAxC2w43JVjOGJf1yGExG6X7iMYGGpR8OjViePpFbv/5GNjCPUEm4i3kIKkQ7HZW
 ZBMRwJx8Jhvb82M9MyqzhX3nOX9B7NQ6MnZD9NpUDJ4xo6EIoWhJQ43+UqTDwMHcFQVX
 JrJ9ieSz6K3lCJe+FTrKoD1O5IJLjpnFOW5m4tKV64vw/xSH5ouCQUknh69M/9ZVEQqG
 PypQ==
X-Gm-Message-State: AOAM5324xZpKJQwXb4MZ2D2ntU/5H6lXvsuobVOfCu6Ag6l0fWu0xBfF
 yqg6v5cEGAQpJNzKFGsz0o7iLYy0sINrzsrehCD21Q==
X-Google-Smtp-Source: ABdhPJycK7EacZ6QGGyp+/k0L/DeJEDPQRgAo3sYB0F8iOgth4YzomZToeNqcXEFJ+iqVdf4//lb4Ni5JFtSIjdFgnE=
X-Received: by 2002:a05:6e02:1b0e:: with SMTP id
 i14mr24439552ilv.58.1617731897753; 
 Tue, 06 Apr 2021 10:58:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210405191757.283122-1-mathieu.poirier@linaro.org>
 <87o8erq0u2.wl-maz@kernel.org>
In-Reply-To: <87o8erq0u2.wl-maz@kernel.org>
From: Mathieu Poirier <mathieu.poirier@linaro.org>
Date: Tue, 6 Apr 2021 11:58:07 -0600
Message-ID: <CANLsYkwijvqGv-EdSSC-F727LczXS0gjBbY-YwJ-0OZkKGTZsg@mail.gmail.com>
Subject: Re: [GIT PULL] coresight: Add support for ETE and TRBE
To: Marc Zyngier <maz@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Greg KH <gregkh@linuxfoundation.org>,
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

On Tue, 6 Apr 2021 at 02:22, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Mathieu,
>
> On Mon, 05 Apr 2021 20:17:57 +0100,
> Mathieu Poirier <mathieu.poirier@linaro.org> wrote:
> >
> > The following changes since commit a354a64d91eec3e0f8ef0eed575b480fd75b999c:
> >
> >   KVM: arm64: Disable guest access to trace filter controls (2021-03-24 17:26:38 +0000)
> >
> > are available in the Git repository at:
> >
> >   git@gitolite.kernel.org:pub/scm/linux/kernel/git/coresight/linux.git next-ETE-TRBE
> >
> > for you to fetch changes up to 7885b4e43231048654c5a80c0a18844ce3185e64:
> >
> >   dts: bindings: Document device tree bindings for Arm TRBE (2021-04-05 11:38:04 -0600)
> >
> > ----------------------------------------------------------------
> > Hi Marc,
> >
> > As previously agreed, here are the changes to support CoreSight
> > ETE and TRBE components submitted here[1].
> >
> > I draw your attention to these:
> >
> > [PATCH v6 05/20] kvm: arm64: Handle access to TRFCR_EL1
> > [PATCH v6 06/20] kvm: arm64: Move SPE availability check to VCPU load
> > [PATCH v6 07/20] arm64: kvm: Enable access to TRBE support for host
> >
> > They are KVM specific and will need an SoB tag.
>
> There seem to be a disconnect here, because it works the other way
> around.
>
> If I pull this, I obviously cannot add anything to the patches that
> are merged (changing stuff would result in changing the commit IDs,
> which is exactly the opposite of what we are trying to achieve).
>
> This isn't a problem, as the act of pulling the branch means that I am
> happy with that, and the git merge makes it traceable.
>
> However, some of the patches (the KVM ones) do not carry your own SoB,
> which is a problem (if you are picking stuff off the list, you need to
> add your own SoB). So for the couple of KVM patches, please add my
>

I wasn't clear on how to handle the KVM patches and as such decided to
proceed conservatively...

>         Acked-by: Marc Zyngier <maz@kernel.org>
>
> together with your SoB, resend the PR and I'll gladly merge it.
>

And I didn't want to SoB those patches because I am not in a position
to cast judgement on them, but with your Ack it changes everything.

> And if you can make sure the subject lines are formatted as:
>
>         "KVM: arm64: Super Duper feature enablement"

No problem.

>
> that'd be absolutely awesome (but that's just me being annoying...).
>

I'll do a respin of this in a couple hours.

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
