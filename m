Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB10C46467
	for <kvmarm@archiver.kernel.org>; Thu,  5 Jan 2023 03:00:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03B264B9F6;
	Wed,  4 Jan 2023 22:00:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p0tZdPFk5uQn; Wed,  4 Jan 2023 22:00:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43B2A4B9FB;
	Wed,  4 Jan 2023 22:00:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0336F4B9F9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Jan 2023 22:00:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CWlhQfxrDDrA for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Jan 2023 22:00:11 -0500 (EST)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D56B04B9F6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Jan 2023 22:00:11 -0500 (EST)
Received: by mail-pj1-f42.google.com with SMTP id n12so25590887pjp.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Jan 2023 19:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=Bu6yuaCwskYNHXwEqcn9yeZ5SPgG6rLyg1H7QYQGX4Y=;
 b=HgswJJvy2Ss68DpGymvgLT2S5MWmEX6pIAzXCVl4As7J46jR7cQBfnlzki4qipoxgO
 W49ExsatZLCUlkltiVEb42URQDXPefBuGloLErK5SDc1D2hbeoGakC/Iqra5qqZzIHf2
 G3Tw+7UoSnEHVVJsbFxecMDB/SefrzBnNfecU2g6d7hx/ved1y85N/HBLhqrVTSNWM7O
 gE6R03OgWIehc0i1SpKAqqY/XLtNBs+r90q4X5iIVI4qGuSGAc5q45/eeBozeXPSSags
 /z+LqjpVXvzMZgzvzVUor1iM4hL2fjZgc4plf0p/J2tfhJWqNioymszGWTEQr3tDHCoI
 qEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Bu6yuaCwskYNHXwEqcn9yeZ5SPgG6rLyg1H7QYQGX4Y=;
 b=i4xty8Uiv/fCNoTaS162fVAioO9MP+MYYKSb0cAlwZewJiX0NuuAak4aoKsJ4McPm7
 4NWj58KJouU+gGBx9t08mCMMiSmLdCf+aFEavGIkJpZIUPu9/zBROgjm3jj8W/6YKXVa
 aIvA1wzg5awEYzAiTbdrxlGTCwypESDd7Qdxdtjtz+F78Em05M5XVxjwv4H/qwDtSM34
 Kyl8mVNPKvfCzg6gJDlgWcv/ksfyJtXGy0fwK8O27Ca4Xv45/7PnJAd5SQdAMQmdaxjU
 vQY8mYCrv7xIWU212sB5KclOWKCqT8z81Zv1jqNLEv6JNW1My4FxTjwZUh7azJUa8MWj
 gJGQ==
X-Gm-Message-State: AFqh2kpEtZHIWaVmLcV5x8vv5pVs+ggmL/Fwq/hST+WcsyPrTGTu4vhP
 EMOenRhNPRdQNYt0xSOgMaK25B1n+nyQNJlsgor0/g==
X-Google-Smtp-Source: AMrXdXv7WnKXFndu0n03X9Zi+Ep0aPm3EPNqQPJF+S/hHnu9Lo5DKcOHN20h2Cyfap+CocmSz39Ue0lxJMXJJJUgzSk=
X-Received: by 2002:a17:902:f80c:b0:189:9a36:a5a1 with SMTP id
 ix12-20020a170902f80c00b001899a36a5a1mr4263932plb.154.1672887610625; Wed, 04
 Jan 2023 19:00:10 -0800 (PST)
MIME-Version: 1.0
References: <20221230035928.3423990-1-reijiw@google.com>
 <20230103124034.000027aa@Huawei.com> <86y1qj7pk9.wl-maz@kernel.org>
In-Reply-To: <86y1qj7pk9.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 4 Jan 2023 18:59:54 -0800
Message-ID: <CAAeT=FyuEuRZn7J5d3gdKGm7G1oEfh1C0heJp6HM7QhHoMid7g@mail.gmail.com>
Subject: Re: [PATCH 0/7] KVM: arm64: PMU: Allow userspace to limit the number
 of PMCs on vCPU
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Jonathan,

On Tue, Jan 3, 2023 at 4:47 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 03 Jan 2023 12:40:34 +0000,
> Jonathan Cameron <Jonathan.Cameron@Huawei.com> wrote:
> >
> > On Thu, 29 Dec 2022 19:59:21 -0800
> > Reiji Watanabe <reijiw@google.com> wrote:
> >
> > > The goal of this series is to allow userspace to limit the number
> > > of PMU event counters on the vCPU.
> >
> > Hi Rieji,
> >
> > Why do you want to do this?
> >
> > I can conjecture a bunch of possible reasons, but they may not
> > match up with your use case. It would be useful to have that information
> > in the cover letter.
>
> The most obvious use case is to support migration across systems that
> implement different numbers of counters. Similar reasoning could also
> apply to the debug infrastructure (watchpoints, breakpoints).

Exactly, this is to unblock migration support between systems
that implement different numbers of counters.
I will include this information in the cover letter when I update
the series for the v2.

Thanks,
Reiji



>
> In any case, being able to decouple the VM from the underlying HW
> within the extent that the architecture permits it seems like a
> valuable goal.
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
