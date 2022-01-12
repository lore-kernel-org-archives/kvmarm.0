Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2591C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jan 2022 17:40:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34E6B4B25D;
	Wed, 12 Jan 2022 12:40:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JDBhrVglK-Mj; Wed, 12 Jan 2022 12:40:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17F794B15B;
	Wed, 12 Jan 2022 12:40:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 789CB4B15B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 12:40:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S+n-gWGU10T6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jan 2022 12:40:37 -0500 (EST)
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com
 [209.85.222.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C2BC4B154
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 12:40:37 -0500 (EST)
Received: by mail-ua1-f45.google.com with SMTP id c36so6183440uae.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 09:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=dhM+RzO3xwFuopgokIVID6/QrF7tTW5/nX5Pew1Lc9Q=;
 b=SyYG7uLNTiZjxR2Z3l5y/XfsC4VwQmx/UbAni3zFA3TB6pm/1c6YxrYZDtGXRXOue3
 vp85vFta7lXTLdNX3DwyJzg/Galc+7SpOPngJOvXjApn+XU9otKCpQwKrhrq8lfTuH7S
 jLUzDBOP/aRViiStBjGc8A9bsYPSFxLUkwij+iHPmrA5hHMUf1ZOmm77v7LlVwYYqzai
 tmejXr0Z4PQgq1eSBhkvniR4NaOUk85CrQWQDZisE0bMXFJbHXuZ1jMe7w4elzyFiWlS
 fw4GLWFeuImOaNMtjVUdla30ieN/R+c+CbK2ZFuVZR6bWmTUI6BvzsfpryFoeF6KTuhu
 QMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=dhM+RzO3xwFuopgokIVID6/QrF7tTW5/nX5Pew1Lc9Q=;
 b=VRKW2wyWVR1vkN9WBf2lHHCuhL9psTH6A968Pw1KF+T03s2cBsvcoMBTFmYIMukD2T
 UNOTYoz1qPo+KOmBkbxZO1m6ipFTwG3qIBQWeJvpFzOek2tpxWrmBApNBU0MtsBoyqkB
 71Ih4KcKld4/qxxZFSCu3xy4kV/XFx6xvLv3VHO5huC2i5lMKReYKcDTh1KmxesoLeY0
 LCXaTiqQ1KoFhABmbItb5XpHkESbsrpWCHu3rAVA7JCKpxlXd0jHsAlWwYP9ln7Yh1EZ
 t0hicvnMDV93xgtNL5JuurKhLIjnLBupxZWetgN6TXGeuxZPFXBQr1J5ncoTdYGjduWo
 STVA==
X-Gm-Message-State: AOAM532g+FLWi+8OeuTlqDqrlVF23mvjgnHkUa76Pd6dd8sebeD61kaK
 L8FKvwLgzST+Vb0dZ1hcYeG7knaPsbCRUIUI6rRtkg==
X-Google-Smtp-Source: ABdhPJwznL0hfPfcEMsiGVpmV5gcIpAD+uBmDTfAurrv7pJYzgxnie/RNnSPOLQWD3kNNt+AL8yF8iQh0VtaIh070hU=
X-Received: by 2002:ab0:13c3:: with SMTP id n3mr499265uae.39.1642009236785;
 Wed, 12 Jan 2022 09:40:36 -0800 (PST)
MIME-Version: 1.0
References: <20220110210441.2074798-1-jingzhangos@google.com>
 <20220110210441.2074798-4-jingzhangos@google.com>
 <87a6g2tvia.wl-maz@kernel.org>
 <CAAdAUthmAMy3UE3_C_CitW9MWWMGcOPHu0x9aV72YEUL2kpO=g@mail.gmail.com>
 <87sfttrxqv.wl-maz@kernel.org>
In-Reply-To: <87sfttrxqv.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 12 Jan 2022 09:40:25 -0800
Message-ID: <CAAdAUthNCgihBVoJS1BFCzT=nxc6i7ceC_SDhUdKajhvXu3v9g@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] KVM: selftests: Add vgic initialization for dirty
 log perf test for ARM
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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

On Wed, Jan 12, 2022 at 3:37 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 11 Jan 2022 22:16:01 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > On Tue, Jan 11, 2022 at 2:30 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Mon, 10 Jan 2022 21:04:41 +0000,
> > > Jing Zhang <jingzhangos@google.com> wrote:
> > > >
> > > > For ARM64, if no vgic is setup before the dirty log perf test, the
> > > > userspace irqchip would be used, which would affect the dirty log perf
> > > > test result.
> > >
> > > Doesn't it affect *all* performance tests? How much does this change
> > > contributes to the performance numbers you give in the cover letter?
> > >
> > This bottleneck showed up after adding the fast path patch. I didn't
> > try other performance tests with this, but I think it is a good idea
> > to add a vgic setup for all performance tests. I can post another
> > patch later to make it available for all performance tests after
> > finishing this one and verifying all other performance tests.
> > Below is the test result without adding the vgic setup. It shows
> > 20~30% improvement for the different number of vCPUs.
> > +-------+------------------------+
> >     | #vCPU | dirty memory time (ms) |
> >     +-------+------------------------+
> >     | 1     | 965                    |
> >     +-------+------------------------+
> >     | 2     | 1006                    |
> >     +-------+------------------------+
> >     | 4     | 1128                    |
> >     +-------+------------------------+
> >     | 8     | 2005                   |
> >     +-------+------------------------+
> >     | 16    | 3903                   |
> >     +-------+------------------------+
> >     | 32    | 7595                   |
> >     +-------+------------------------+
> >     | 64    | 15783                  |
> >     +-------+------------------------+
>
> So please use these numbers in your cover letter when you repost your
> series, as the improvement you'd observe on actual workloads is likely
> to be less than what you claim due to this change in the test itself
> (in other words, if you are going to benchamark something, don't
> change the benchmark halfway).
Sure. Will clarify this in the cover letter in future posts.
Thanks,
Jing
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
