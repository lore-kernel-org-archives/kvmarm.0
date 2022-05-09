Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2E1C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 10:49:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE39D4B20F;
	Mon,  9 May 2022 06:49:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ln1vrwFCCG8h; Mon,  9 May 2022 06:49:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A74904B2B3;
	Mon,  9 May 2022 06:49:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBDC24B20F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 06:49:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vazClS99KlUV for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 06:49:21 -0400 (EDT)
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com
 [209.85.160.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6E944B1F3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 06:49:21 -0400 (EDT)
Received: by mail-oa1-f50.google.com with SMTP id
 586e51a60fabf-edf3b6b0f2so13831069fac.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 03:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=GRgB/1+0u+Xr9qad7Avl5sf1aDRmus7sk/+Fw2MV1T0=;
 b=RS1RIE8tprnTy+q/KDrsOEIr3x0BGFEIBZegdiJJfLlS/HAeKNseM3pMHwTAWtGQNb
 JgPKtlZrIoCyf7qYC4rL2V3GR6C4d82JH676If1c6DhtiJ2+x1MHi4PkAMonXJzYD+dA
 jbMKBN1/M7WokpzkFDDXgi0u+9AL2yIMu1zWo8P1Ozqny+eRGW9MiUNkjWcatVW08jkz
 6tphtLyDlLeNTqrDFXyVPHNdx2mIy8gz1HHwybMgYHn33meAyA/QWsT3xCd1OoIQZI8E
 IBTlcZQ2jV49j6NYMw2S5VONzj+swb/ZccCzJcKn225MuEcEDhovRIx5OrC0Sl2yCdKw
 WPjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=GRgB/1+0u+Xr9qad7Avl5sf1aDRmus7sk/+Fw2MV1T0=;
 b=1icjxjlvP3B2Sx63vRjuILUvBKo8sBGvcZ4w5NJ+XjI1ZDw3AECbhoUKWZ5he05gPg
 oSo0FCdu1Q2yRJy63VcSD/B1KlBsTgOBbf8wi3A+O7hAXcQq3aguAjyVsjHEDbVpPjTC
 scZ1rLHTljyxVBjilJlZ+T6c4Ep3CTKS/yC98BR62nRRoYK++/WM37yhhssivjUgNeOq
 mcdVWrFSi5rE8sEBEbqIvgrUGiShCsByIgHry+H8DHDIMZfCPphQ6Z5O+eh9ruFysuNr
 NT2hyC7Q4cDFPpHrdX+Wq/ydNMKZZqe1y+dlg1WqFTyqB/fURQSLmznw4h73DUKGxhXq
 5Usg==
X-Gm-Message-State: AOAM530gc1cKicprUUKG6Lh/g08nQ5QVzXKqYf4YpaCjbYYEyCpyaPtn
 kFbOdeA+7dhBqQhDGxuyUF+jDmacbwCz1+X/TR3ehA==
X-Google-Smtp-Source: ABdhPJxzcSJ92jiUUmHEMNnlwwyvI8/a/Pnq1oupVQedU5g2TtHI8rFJTLHono68N5bDlKF2eAGK4jcaGz2vju6ftYk=
X-Received: by 2002:a05:6870:961b:b0:e2:ffb9:f526 with SMTP id
 d27-20020a056870961b00b000e2ffb9f526mr10075358oaq.146.1652093360970; Mon, 09
 May 2022 03:49:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220509095500.2408785-1-tabba@google.com>
 <20220509095500.2408785-4-tabba@google.com>
 <87ee136l9p.wl-maz@kernel.org>
In-Reply-To: <87ee136l9p.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 9 May 2022 11:48:45 +0100
Message-ID: <CA+EHjTxftKcH5juPdg4cFN+jaiEkmhKUbREj6gf3m9L6tCGAXw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] KVM: arm64: Pass pmu events to hyp via vcpu
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, catalin.marinas@arm.com, will@kernel.org,
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

Hi Marc,


On Mon, May 9, 2022 at 11:41 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 09 May 2022 10:54:59 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Instead of the host accessing hyp data directly, pass the pmu
> > events of the current cpu to hyp via the vcpu.
> >
> > This adds 64 bits (in two fields) to the vcpu that need to be
> > synced before every vcpu run in nvhe and protected modes.
> > However, it isolates the hypervisor from the host, which allows
> > us to use pmu in protected mode in a subsequent patch.
> >
> > No functional change intended.
>
> BTW, there *are* plenty of functional changes, even if there was no
> issue with the patch. The lifetime of the data structure changes, its
> sharing changes, and its memory footprint is different.
>
> I guess what you are trying to say is that there shouldn't be any
> visible side effect of this patch. But I don't think these are the
> same things.

Always thought that in this context functional == functionality. Will
make it clearer in the next commit message that there should be no
visible side effect changes instead.

Thanks,
/fuad
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
