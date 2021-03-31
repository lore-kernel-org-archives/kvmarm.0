Return-Path: <SRS0=69BX=I5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C2CC433C1
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 09:43:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E72BB619BB
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 09:43:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E72BB619BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55DF74B39C;
	Wed, 31 Mar 2021 05:43:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gU+B+qosMfTo; Wed, 31 Mar 2021 05:43:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 498C94B39F;
	Wed, 31 Mar 2021 05:43:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 943664B39A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 05:43:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3nDlaWm1hfJe for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 05:43:39 -0400 (EDT)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com
 [209.85.218.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73F2B4B38F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 05:43:39 -0400 (EDT)
Received: by mail-ej1-f50.google.com with SMTP id ce10so29112938ejb.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 02:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=YMiE+kC04pZeOxkIHTZ5n+tBWqrLCoxGcq+JX9IvLEo=;
 b=lwObbBzUMPtuNRTAfP+9LHPHy1w1N5WKNsRnTjJJGrzVo4LVAvJCNgNftqwGzM3PIH
 lIbKDnRu3gq1Nd5T2ch28v4b5Qkn/0b5UzaiiLkYDH1MCoSZ7kthlpc5G6RYMyyEsrQy
 O6Sa4pbZ2CsfpMZVY95ZulHz9ZbNa2cL4KVsXQWER+/xH1Lvr6KGD0tLpeDqkDdx5gKh
 4asJXZS1MvYwi574DOLJELleYJgFVTiYrTqtekDmOuvwHgtDRSGL/3K8eqW/FHipwU2p
 7KFj7xJJ7OfLBLnWkbLyQ8WCaUxXc9WD8zKn6ypNe6DQ/F3GtDUOEPEg3kc4m4ltT3ZF
 zbcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=YMiE+kC04pZeOxkIHTZ5n+tBWqrLCoxGcq+JX9IvLEo=;
 b=PkrwwTxpbXlELFAf9NYTMbvk85DjbgTxUA0XgkdNRGEKpfnhg7w/c+5D+j9RvYsOEO
 Rk2KgsS+t29TrqkaCoXCJlgDoFmWFGUdNFMpbs5UYwtuuMpMUUM2HyvBLbnWLaWy5NEs
 XDLGjXnBhx3yLuLbsLugvgtb5JT0aqNfjGIcDO+dBEwEZCiH51dGq/Y5dQsxuVcGfI2b
 wZaejkMdsHbcBRylLtDjPGSbZ69B0hsjgxQk6oQFjHDytZU81L5qXi+Gxm9MP+yddSDm
 qHV2KgR9JaiSuhSTGJ5AWlGV2Il/xvgvrOwv0bbj4r38La2/DX/WyzW4g7lW73+Qu4Zz
 KsUg==
X-Gm-Message-State: AOAM532ugohxChMTae3a5FCGWwno8zewQevMI8rh9GzwyQ9ta8DBiCSq
 O9l5j0bZxUzt/k6zTVHfkhYBnLqqcrOHIhQDvVNqiQ==
X-Google-Smtp-Source: ABdhPJxePNVOCJTxN2zlZTABC9hnir9T5tWDzXH8feCD2BHVtDpCs1F2rruAs6B0UY1WbwtbW2XXbLOlllYHasnaI5w=
X-Received: by 2002:a17:906:8a65:: with SMTP id
 hy5mr2641138ejc.250.1617183818442; 
 Wed, 31 Mar 2021 02:43:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210311165947.27470-1-peter.maydell@linaro.org>
 <431943c3-a603-7426-273f-b5a00f10ce41@huawei.com>
In-Reply-To: <431943c3-a603-7426-273f-b5a00f10ce41@huawei.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 31 Mar 2021 09:43:06 +0000
Message-ID: <CAFEAcA-tyxfiJ_BXOkm9SOApOnOh-hXi+dvjOP0-SqASjt5bhQ@mail.gmail.com>
Subject: Re: [PATCH] target/arm: Make number of counters in PMCR follow the CPU
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>, QEMU Developers <qemu-devel@nongnu.org>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 qemu-arm <qemu-arm@nongnu.org>, Leif Lindholm <leif@nuviainc.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Wed, 31 Mar 2021 at 09:59, Zenghui Yu <yuzenghui@huawei.com> wrote:
>
> [+kvmarm, Marc]
>
> On 2021/3/12 0:59, Peter Maydell wrote:
> > Currently we give all the v7-and-up CPUs a PMU with 4 counters.  This
> > means that we don't provide the 6 counters that are required by the
> > Arm BSA (Base System Architecture) specification if the CPU supports
> > the Virtualization extensions.

> So I've tested it with kvm and I get the following error before
> VM startup:
>
>    "qemu-system-aarch64: Failed to retrieve host CPU features"
>
> > ---
> >   target/arm/cpu.h     |  1 +
> >   target/arm/cpu64.c   |  3 +++
> >   target/arm/cpu_tcg.c |  5 +++++
> >   target/arm/helper.c  | 29 +++++++++++++++++------------
> >   target/arm/kvm64.c   |  2 ++
> >   5 files changed, 28 insertions(+), 12 deletions(-)
>
> [...]
>
> > diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> > index dff85f6db94..581335e49d3 100644
> > --- a/target/arm/kvm64.c
> > +++ b/target/arm/kvm64.c
> > @@ -566,6 +566,8 @@ bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
> >                                 ARM64_SYS_REG(3, 0, 0, 7, 1));
> >           err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64mmfr2,
> >                                 ARM64_SYS_REG(3, 0, 0, 7, 2));
> > +        err |= read_sys_reg64(fdarray[2], &ahcf->isar.reset_pmcr_el0,
> > +                              ARM64_SYS_REG(3, 3, 9, 12, 0));
>
> Looks like we tried to access PMCR_EL0 *before* telling kvm that
> KVM_ARM_VCPU_PMU_V3 feature should be supported, which is now
> refused by kvm [*].
>
> [*] https://git.kernel.org/torvalds/c/11663111cd49

Oops, that's embarrassing. I should have tested with KVM, and
I forgot the PMU needs special enablement :-(

I'm on holiday right now so I probably won't have time to
look at a fix for rc2. I might just revert this commit.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
