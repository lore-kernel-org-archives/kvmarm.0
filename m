Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC0B2C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 15 Dec 2021 06:47:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 400EC4086C;
	Wed, 15 Dec 2021 01:47:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mMskgPsaanwJ; Wed, 15 Dec 2021 01:47:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E7F44B0F7;
	Wed, 15 Dec 2021 01:47:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 859E64B0A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 01:47:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LoywYVn5TbUz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Dec 2021 01:47:17 -0500 (EST)
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com
 [209.85.215.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8FFF34086C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 01:47:17 -0500 (EST)
Received: by mail-pg1-f182.google.com with SMTP id r5so19389867pgi.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 22:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=bPTB6jvRZdafGIG6g7Bp2azNofD6bHKXlWBx9mN4yu0=;
 b=Axf/QhyJFPX4Z5mZ3yn5Blqj774En5qiyhKq2INSjaUabJ3OU/NQz5Q6ba8pPdk4Sg
 M2qfmKZE3+af8T+Lt2+CdQ5rI2m/WTBvMSlK4i5hfNO2BNx1zcW0quem/6oni6WRUAiM
 uWGNOp0Ss3oi7sIuZsdBMeK/Oyg6U7X/b8ypzC7Ak6rx5po8RYlT5RHnUsGt6L+x/4Cd
 lmtB6/IXAVjHEDEmvQiGuV0roUscXVWkkDqsS00MXyDrioSnsVIsSe64rg7PwCyfJgMo
 BFLqmVSDXaBBGxT+9+xUhuwGP8eSlkIb3ajtot2eue30WH7SQiE92r67+1AIo+cdAJC0
 q6VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=bPTB6jvRZdafGIG6g7Bp2azNofD6bHKXlWBx9mN4yu0=;
 b=tzt2/dTp6rlxeex6xjzf+tRhPje0bBkKiGw+irzO6jG/JqO0byvygYUTCP9TmFct3o
 a92ghw5rOhdR9O0CizVOgl56uY5M9xJonMxUbAy7lvT66Oah12bZ+8ZEybtQdPUNARU6
 oEoK4YZ1t7l77vzVbdSujp8dYbfSuEVuXFKLFn8NHp0mccVR+Wq0+rmLe+S/zpznM+GS
 +ATc6JJjrQESh/daNmp3jZRVyc6/Je/JgTeA3ByjxlpVEprxixD4y28idI/YLcz1KJFa
 aeYYJPzNQkM1eO7Kxa7KcY2KchwZhgGi7nJbYkWfPaV7FdAy9B+9vrvI62iEy4Cp3Lj3
 HLyA==
X-Gm-Message-State: AOAM530GdXtzr/YG214Y4jDGRXmnHgiCB84VjDsYM8qvt4NVkqaFCTUU
 WFe1AceeaZnomqLbCqkWnZvv6td2MoT15TBNnrCpsQ==
X-Google-Smtp-Source: ABdhPJwvcliz0HLD350tQYrlN+3bhh+GwVzvtmCasOQZn0abwUxaylid8KVly3QA7BvPpinRWdJsqN5L5N0vUbJ34bQ=
X-Received: by 2002:a05:6a00:bcd:b0:4b0:62ef:c6af with SMTP id
 x13-20020a056a000bcd00b004b062efc6afmr7675788pfu.39.1639550836416; Tue, 14
 Dec 2021 22:47:16 -0800 (PST)
MIME-Version: 1.0
References: <20211206170223.309789-1-alexandru.elisei@arm.com>
 <CAAeT=FygprcS3YxbVaW+4yUjHBm8=MxZ+j4_iVjq7ie-ppRKRg@mail.gmail.com>
 <addac215bddf0b86bf6850093d500785@kernel.org>
 <CAAeT=Fzz2UGQAWGx_4piJGng5BKpX3FQrZDA7u2PHFcTRD4G4w@mail.gmail.com>
 <YbcrKAE35GMzPQBt@monolith.localdoman>
 <CAAeT=FxK2F+GUdJ_0z6rb4F5ttjW5ZyD7Sa_eyiaKc=xxDdMkg@mail.gmail.com>
 <874k7bjt6e.wl-maz@kernel.org>
In-Reply-To: <874k7bjt6e.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 14 Dec 2021 22:47:00 -0800
Message-ID: <CAAeT=FyUhu=J7VVMc47APy4v_JN7S+OZm=qy0c+A7cowpSogCg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: Improve PMU support on heterogeneous
 systems
To: Marc Zyngier <maz@kernel.org>
Cc: will@kernel.org, mingo@redhat.com, tglx@linutronix.de,
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

On Tue, Dec 14, 2021 at 3:57 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 14 Dec 2021 06:24:38 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Alex,
> >
> > On Mon, Dec 13, 2021 at 3:14 AM Alexandru Elisei
> > <alexandru.elisei@arm.com> wrote:
> > >
> > > Also, as VCPUs get migrated from one physical CPU to the other, the
> > > semantics of the microarchitectural events change, even if the event ID is
> > > the same.
> >
> > Yes, I understand.  As mentioned, this can work only when the
> > CPU affinity is set for vCPU threads appropriately (, which could
> > be done even without changing userspace).
>
> Implicit bindings to random PMUs based on the scheduling seems a
> pretty fragile API to me,

Yes, I understand that. I was just looking into the possibility
of improving the default behavior in some way rather than keeping
the unpredictable default behavior.

> and presents no real incentive for userspace
> to start doing the right thing.

I see... It makes sense.
I didn't think about that aspect.

> I'd prefer not counting events at all when on the wrong CPU (for some
> definition of 'wrong'), rather than accumulating unrelated events.
> Both are admittedly wrong, but between two evils, I'd rather stick
> with the one I know (and that doesn't require any change)...
>
> Alex's series brings a way to solve this by allowing userspace to pick
> a PMU and make sure userspace is aware of the consequences. It puts
> userspace in charge, and doesn't leave space for ambiguous behaviours.
>
> I definitely find value in this approach.

Yes, I agree with that.
It wasn't meant to replace Alex's approach.  It was only about the
default behavior (i.e. when userspace does not specify a PMUID with
the new API).

Anyway, thank you so much for sharing your thoughts on it !

Regards,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
