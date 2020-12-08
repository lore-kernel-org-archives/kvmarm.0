Return-Path: <SRS0=0wdR=FM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 781F6C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 10:11:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B44A23A9D
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 10:11:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B44A23A9D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2ED24B254;
	Tue,  8 Dec 2020 05:11:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wXVEVsMRFgEn; Tue,  8 Dec 2020 05:11:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 891F14B1DC;
	Tue,  8 Dec 2020 05:11:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E3644B0ED
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 05:11:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0s0LssTWgTr8 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2020 05:11:04 -0500 (EST)
Received: from mail-io1-f68.google.com (mail-io1-f68.google.com
 [209.85.166.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E6A834B0C1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 05:11:03 -0500 (EST)
Received: by mail-io1-f68.google.com with SMTP id 81so16322463ioc.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Dec 2020 02:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=rI1cpmvfLJH6kTfoQBqKr4p1uRHaWCiCfbric7yc3oU=;
 b=dNIn3iZoh8mC1iMR2GHayG7Dmsey5468YPYG+bQp3mApwT3AV55v0utWeiH+FyfOPR
 xMzkRjQWCES+3urWzSrFaYw3Wb6CLk5ZYExO6M73Lcy3/BC+b6jefT8+jvqDEii1lF2x
 vLurTuwD53UxyuzGI1GPvxsdl68S2a/LtEPPN7Gs/868QIsRj0XslCX+xuiE+nbV5Tla
 mTC7TIWsxh8cmM/gR8PwhCMnjYpfVmc8R4cgbR0llcidfH9fN949wv7Mw6p/CPkvu8Xn
 nzfXCWhuaFRIpnfL7YveIUN2mlKKVclIhlKIkbtMa1MTRZqAb8Aj0Jw0eqyfvg3BgYtd
 xQmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=rI1cpmvfLJH6kTfoQBqKr4p1uRHaWCiCfbric7yc3oU=;
 b=gkGXMRFDtxgj4174CIfTmMsoQFVAAWBvInwdJvMwEva1ApSX0MiRppDZl3rW6pkiMi
 brz1hC32pLjjv9glA0EZmQGEQJAfvhActQINNaVcNd3jQdujrmaOisswXTYUTfJX6tx4
 1wh7+XLSqVdV+o4+RLa8fpSKJxqAZvJjICqgJkNXpI7tZcEBx0qbcKcUMLNhvcae9atQ
 fC3CRLisQzHeIvRQtTtjAkhO6BC0hGY1wG0ukuBgdw9FOu+r0/Y9PpNupiJpqxkaUu9v
 3DXAOC9ok35BN3Aw25gwKlH/tcTQ4cX0IfzNeiusSbexRqDB3n2RYANKu4xzW8VidPGU
 7/AA==
X-Gm-Message-State: AOAM531y3f1WKthBOrurz2w+A/NkD76dYip6oCMCE6Isy4JSDQ/M86bo
 2+qnu0WVzoBEMCjj7uEzpi9Bg/4yvpugA9rzCbY6
X-Google-Smtp-Source: ABdhPJzzChXpGASUFHrcW55NeZaQFkmopErMJ5BvtCk7RK4Qi9bfAbL4Z4qf2qaNh1ATuEArKZuiqRpucQGGwd3Fp0s=
X-Received: by 2002:a02:c608:: with SMTP id i8mr25590358jan.125.1607422263337; 
 Tue, 08 Dec 2020 02:11:03 -0800 (PST)
MIME-Version: 1.0
References: <20201119153901.53705-1-steven.price@arm.com>
 <CAFEAcA85fiqA206FuFANKbV_3GkfY1F8Gv7MP58BgTT81bs9kA@mail.gmail.com>
 <20201119184248.4bycy6ouvaxqdiiy@kamzik.brq.redhat.com>
 <db5ad775fa7cfe7defbd78d9ca6ccfd8@kernel.org>
 <c25c297e-e9b5-ab3f-e401-c21ddd4d2ad1@arm.com>
 <CAJc+Z1H7akXwDtVvQLiGVVyZ0DfmsxyJQhE7Sno6aAO9GaafEA@mail.gmail.com>
 <46fd98a2-ee39-0086-9159-b38c406935ab@arm.com>
 <CAJc+Z1FRJR5LHw-xZvPpeYF6+v+ZOcLt99X41xOMAbFmB2DJ2A@mail.gmail.com>
 <b77efceaec433dd98fdf2cd535a9cf40@kernel.org>
In-Reply-To: <b77efceaec433dd98fdf2cd535a9cf40@kernel.org>
From: Haibo Xu <haibo.xu@linaro.org>
Date: Tue, 8 Dec 2020 18:10:51 +0800
Message-ID: <CAJc+Z1EafkLezXv=+1aPbaXo9uWpcB77iM32M70oyP6zEzacjw@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] MTE support for KVM guest
To: Marc Zyngier <maz@kernel.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Juan Quintela <quintela@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 QEMU Developers <qemu-devel@nongnu.org>, Steven Price <steven.price@arm.com>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Dave Martin <Dave.Martin@arm.com>
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

On Tue, 8 Dec 2020 at 18:01, Marc Zyngier <maz@kernel.org> wrote:
>
> On 2020-12-08 09:51, Haibo Xu wrote:
> > On Mon, 7 Dec 2020 at 22:48, Steven Price <steven.price@arm.com> wrote:
> >>
>
> [...]
>
> >> Sounds like you are making good progress - thanks for the update. Have
> >> you thought about how the PROT_MTE mappings might work if QEMU itself
> >> were to use MTE? My worry is that we end up with MTE in a guest
> >> preventing QEMU from using MTE itself (because of the PROT_MTE
> >> mappings). I'm hoping QEMU can wrap its use of guest memory in a
> >> sequence which disables tag checking (something similar will be needed
> >> for the "protected VM" use case anyway), but this isn't something I've
> >> looked into.
> >
> > As far as I can see, to map all the guest memory with PROT_MTE in VMM
> > is a little weird, and lots of APIs have to be changed to include this
> > flag.
> > IMHO, it would be better if the KVM can provide new APIs to load/store
> > the
> > guest memory tag which may make it easier to enable the Qemu migration
> > support.
>
> On what granularity? To what storage? How do you plan to synchronise
> this
> with the dirty-log interface?

The Qemu would migrate page by page, and if one page has been migrated but
becomes dirty again, the migration process would re-send this dirty page.
The current MTE migration POC codes would try to send the page tags just after
the page data, if one page becomes dirty again, the page data and the tags would
be re-sent.

>
> Thanks,
>
>          M.
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
