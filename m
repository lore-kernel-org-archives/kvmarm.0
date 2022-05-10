Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19962C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 06:46:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8547941071;
	Tue, 10 May 2022 02:46:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J1qWJUnJQRp1; Tue, 10 May 2022 02:46:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 716EF410BB;
	Tue, 10 May 2022 02:46:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF9F641049
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 02:46:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UkHLe8JR6fnV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 May 2022 02:46:04 -0400 (EDT)
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com
 [209.85.161.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E126241021
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 02:46:04 -0400 (EDT)
Received: by mail-oo1-f49.google.com with SMTP id
 v33-20020a4a9764000000b0035f814bb06eso793720ooi.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 23:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=/BBxfoM/3zykY2lZzu5SEgh0JrIqDrhLLe9Mply3YBk=;
 b=VEjLglVyhyL8cGGRw9BkHQhXEuNPntvbYwd7FvhZDC28FVyeTukt9m7nW1AZRvPiTl
 Be+94biYc4n38dEbZqLemrkLpxz4JmsP+KUbkFu4RXkYosmrPi6dqxtyToYEZJ3pKSqY
 vIb3Q+y0b/8BNIlHkMo9XllMmtLf01c7i7GevqMDYG2Q7u5jFagjQcFv4xcMQU3mTW0m
 eVSXJbYc388MTg7pti5R8gaZs5QTBQdgBxalKiz7ZkmN0l8nxH65zJ7pZ+iGFUaL+S4Q
 q6UT52knbhswhyw8DkLGMGWwAIyWWY6/BeA0kkiF63dbDNNZpuqi5aneKd8IpX7a965d
 PjsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=/BBxfoM/3zykY2lZzu5SEgh0JrIqDrhLLe9Mply3YBk=;
 b=y17SpnPZiPo7HjlT1vqOaeNM9Rb21sul/qxjnGPIWJlCTS21C8oXZzpP+AMKrT4G9Z
 j4s10wzRIyzXLe0oW60py3vfJtsSOcYdI3vc2J81iflfer3h1R8JhpPrjcC6zsI+UPgk
 +2wrtACT2LZrfyPtPRLQ8RuoK/ZD1U7PRLhQTLb/dA7Pp4c+pLre01OrF9ESvM/7ClzT
 +nMzdgDKKqcCdF5NmFWTMwBwEBagwt1NeiG1sUwgERZNf8Ip9Rl+BXzqLH6mk5Vu3pHP
 Spfi9as9rXIsYKIPyN4owQeoAsAnAmk4bZzOMsUML5OclHbe3yXki/fwwiqQ0BHFD4Bj
 uIkA==
X-Gm-Message-State: AOAM533nZvL0nbVf4qRbP3p6sXUUoAIYTlL4ufbu49oBZUi+hc5FIm6a
 Z0gr51OTE6TQZhFdK6GPM+koMqKjVL9Me/k+zFrkSQ==
X-Google-Smtp-Source: ABdhPJxCRTazxkmKzAAtHz8M7TrHpcUf4i0np4ylkDClH4qhaXYuVi3d7gQBcQF9ZM+bMYHZIZfrKezC+nzjRBy1fE0=
X-Received: by 2002:a4a:4a86:0:b0:35e:a2d3:763b with SMTP id
 k128-20020a4a4a86000000b0035ea2d3763bmr7380247oob.23.1652165164153; Mon, 09
 May 2022 23:46:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220509120330.3043773-1-tabba@google.com>
 <20220509120330.3043773-5-tabba@google.com>
 <YnmXULIsOO27g/8N@google.com>
In-Reply-To: <YnmXULIsOO27g/8N@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 May 2022 07:45:27 +0100
Message-ID: <CA+EHjTyd0noEpyOh0pNas3AO=0M6qTRO507uoxicqju16sw9Tg@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] KVM: arm64: Reenable pmu in Protected Mode
To: Oliver Upton <oupton@google.com>
Cc: will@kernel.org, maz@kernel.org, catalin.marinas@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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


On Mon, May 9, 2022 at 11:36 PM Oliver Upton <oupton@google.com> wrote:
>
> Hi Fuad,
>
> On Mon, May 09, 2022 at 12:03:30PM +0000, Fuad Tabba wrote:
> > Now that the pmu code does not access hyp data, reenable it in
> > protected mode.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/pmu-emul.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index 3dc990ac4f44..11c43bed5f97 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -774,8 +774,7 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
> >  {
> >       struct arm_pmu_entry *entry;
> >
> > -     if (pmu->pmuver == 0 || pmu->pmuver == ID_AA64DFR0_PMUVER_IMP_DEF ||
> > -         is_protected_kvm_enabled())
> > +     if (pmu->pmuver == 0 || pmu->pmuver == ID_AA64DFR0_PMUVER_IMP_DEF)
>
> IIUC, you intend to enable the PMU for non-pVM guests, right? Based on
> the pKVM feature registers + trap handlers I can see that pVM use of the
> PMU is in fact disabled. It'd be good to state in the commit message
> what is exactly intended for pVMs and non-pVMs.
>
> Since the PMU counters are disabled outright for pVMs, is there any
> value in context switching between host/guest in this case?

I will make this clearer in the commit message. PMU won't be supported
for protected VMs but should be for non-protected VMs in protected
mode.

Thanks,
/fuad

> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
