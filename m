Return-Path: <SRS0=fGD+=OV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E37C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 15:38:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D65761A56
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 15:38:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4D65761A56
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6BB64B0D9;
	Fri,  1 Oct 2021 11:38:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Kepa-ywPnFbU; Fri,  1 Oct 2021 11:38:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6426F4B0A3;
	Fri,  1 Oct 2021 11:38:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA4C549FE6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 11:38:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I6U-3BZOLQ7i for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Oct 2021 11:38:48 -0400 (EDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com
 [209.85.167.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DA57407E7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 11:38:48 -0400 (EDT)
Received: by mail-lf1-f48.google.com with SMTP id i25so40286405lfg.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Oct 2021 08:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=caDxly+TDg5GzXq8rhIFgWm2KHSBFQbAt3cPO0aQ+jQ=;
 b=RXCgo3jcLnJ39FiTHCfHTdVYahi5odm2B84SoHXN17WiY57B5UdEFaKyH/D+Ajgj0O
 M/Lr1fZOMW/KOvaMaPn7TbpvoAIOD2/XcrJY1z9Q91fd/baKA4vlr76/UPGS9gKy6jtO
 QxmcKWjkliAUmxiz41cbqPhzSize17LKGbH8hpf2wirkGVf1kAim/5hlHYXxrFZ3ewWl
 E22rCstiDejoueilAf2/0B0W7u5s/NpLS1+cnc0fRDcZezV8N7LBh4FDnz8XDBS2vNFR
 MC6X0qtpiVf+duHH5DqsIuYOeUqyMmlq6JbOe+lB5h/ZLHbiFqvl5awppSPdaLBUt7h4
 0XIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=caDxly+TDg5GzXq8rhIFgWm2KHSBFQbAt3cPO0aQ+jQ=;
 b=zOpFxE+6iwvuva7DafCU+4Tu0NexWWNkYJrrF3ODnN2DaNNfCM2PICE4SoZAzh9xlD
 OQi44R2dhKo6heLWlOWP6scf7f0K84qx0d1N+X9UWOLprmYaDa1eH9+wLdzDf3vnlHKd
 8EiM6R8q/9AbjXL9qwXqctKRpedwEypQEjV1Gaggg8FTIdgLLAKDg0ZNaw4aw1oiSc71
 vQuObZfxpA1yAmg1g5B6L+5aObzbAQJ9TawtCQy+NToliISwdoIn6hWrH2GtID3Web6t
 2chy6IMbPRFPBOK6qOTy+ObNvvLXMdB+3OZ2ccyl2fouuhaiY7nN7DqROBp1hUjmn8+J
 K99g==
X-Gm-Message-State: AOAM532g8eMuOUPoEi9SPD313HGDVTIADTM/0Tf+N8yS/fs/rEkfYegz
 pwBHjvq/25q+0EXeE8jLvwYHthoX8rryPnpkFYilNg==
X-Google-Smtp-Source: ABdhPJw8nB4dkJ+kFhDR8bcfgS2uOXJXL4vm8BM/whq82kReOofwAMMvIocOR1ZzBz2SuaPtCZ/tuNIZZraVQHQA6Ek=
X-Received: by 2002:ac2:4217:: with SMTP id y23mr5976320lfh.361.1633102726741; 
 Fri, 01 Oct 2021 08:38:46 -0700 (PDT)
MIME-Version: 1.0
References: <YSVhV+UIMY12u2PW@google.com> <87mtp5q3gx.wl-maz@kernel.org>
 <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
 <87fsuxq049.wl-maz@kernel.org> <20210825150713.5rpwzm4grfn7akcw@gator.home>
 <CAOQ_QsgWiw9-BuGTUFpHqBw3simUaM4Tweb9y5_oz1UHdr4ELg@mail.gmail.com>
 <877dg8ppnt.wl-maz@kernel.org> <YSfiN3Xq1vUzHeap@google.com>
 <20210827074011.ci2kzo4cnlp3qz7h@gator.home>
 <CAOQ_Qsg2dKLLanSx6nMbC1Er9DSO3peLVEAJNvU1ZcRVmwaXgQ@mail.gmail.com>
 <87ilyitt6e.wl-maz@kernel.org>
 <CAOQ_QshfXEGL691_MOJn0YbL94fchrngP8vuFReCW-=5UQtNKQ@mail.gmail.com>
 <87lf3drmvp.wl-maz@kernel.org>
In-Reply-To: <87lf3drmvp.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Fri, 1 Oct 2021 08:38:35 -0700
Message-ID: <CAOQ_QsjVk9n7X9E76ycWBNguydPE0sVvywvKW0jJ_O58A0NJHg@mail.gmail.com>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, pshier@google.com, kvmarm@lists.cs.columbia.edu,
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

On Fri, Oct 1, 2021 at 4:43 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 30 Sep 2021 18:24:23 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > Hey Marc,
> >
> > On Thu, Sep 30, 2021 at 12:32 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > Hi Oliver,
> > >
> > > On Wed, 29 Sep 2021 19:22:05 +0100,
> > > Oliver Upton <oupton@google.com> wrote:
> > > >
> > > > I have some lingering thoughts on this subject since we last spoke and
> > > > wanted to discuss.
> > > >
> > > > I'm having a hard time figuring out how a VMM should handle a new
> > > > hypercall identity register introduced on a newer kernel. In order to
> > > > maintain guest ABI, the VMM would need to know about that register and
> > > > zero it when restoring an older guest.
> > >
> > > Just as it would need to be able to discover any new system register
> > > exposed by default, as it happens at all times. Which is why we have a
> > > way to discover all the registers, architected or not.
> > >
> > > > Perhaps instead we could reserve a range of firmware registers as the
> > > > 'hypercall identity' registers. Implement all of them as RAZ/WI by
> > > > default, encouraging userspace to zero these registers away for older
> > > > VMs but still allowing an old userspace to pick up new KVM features.
> > > > Doing so would align the hypercall identity registers with the feature
> > > > ID registers from the architecture.
> > >
> > > The range already exists in the form of the "coprocessor" 0x14. I
> > > don't see the need to expose it as RAZ/WI, however. If userspace
> > > doesn't know about how this pseudo-register works, it won't be able to
> > > program it anyway.
> > >
> > > I don't buy the parallel with the ID-regs either. They are RAZ/WI by
> > > default so that they don't UNDEF at runtime. The meaning of a RAZ
> > > id-register is also well defined (feature not implemented), and the
> > > CPU cannot write to them. In a way, the ID-regs *are* the enumeration
> > > mechanism.
> > >
> > > Our firmware registers don't follow the same rules. Userspace can
> > > write to them, and there is no such "not implemented" rule (case in
> > > point, PSCI). We also have a separate enumeration mechanism
> > > (GET_ONE_REG), which is (more or less) designed for userspace to find
> > > what is implemented.
> > >
> > > For these reasons, I don't immediately see the point of advertising a
> > > set of registers ahead of time, before userspace grows an
> > > understanding of what these registers mean.
> >
> > Supposing we don't preallocate some hypercall ID registers, how can we
> > safely migrate a guest from an older kernel to newer kernel? Ideally,
> > we would preserve the hypercall feature set across the migration which
> > could work for a while with the first set of registers that get
> > defined, but whenever a new hypercall firmware register comes along
> > then the VMM will be clueless to the new ABI.
>
> My expectations were that whenever userspace writes a set of firmware
> register, all the defaults are invalidated. For example say that
> host-A know about a single hypercall register, while host-B knows
> about two. Upon writing to the first register, the host would clear
> the set of available services in the second one. If userspace
> eventually writes there, the value would stick if valid.
>
> Also, remember that pseudo-registers don't have to be 64bit. We could
> define a new class of hypercall-specific registers that would be much
> wider, and thus have a larger write granularity (KVM supports anything
> from 8 to 2048 bits). This would make it pretty easy to implement the
> above.
>
> > Fundamentally, I don't think userspace should need a patch to preserve
> > ABI on a newer kernel. Despite that, it would seem that userspace will
> > need to learn of any firmware registers that control hypercall
> > features which come after the initial set that gets proposed. If
> > KVM_GET_REG_LIST were to disambiguate between ID registers (hypercall,
> > architectural feature ID registers) from other parts of the vCPU
> > state, it would be clear to what registers to zero on a newer kernel.
> > Apologies if it is distracting to mention the feature ID registers
> > here, but both are on my mind currently and want to make sure there is
> > some consistency in how features get handled on newer kernels,
> > architected or not.
>
> The problem I see is that we will always need to grow the HC register
> space one way or another, no matter how many we reserve. Your approach
> only works if we don't exceed that particular range. Maybe it will
> never be a problem, but it remains that this is not scalable.
>
> If we wanted to be safe, we'd reserve the whole of the possible space
> as defined by the SMCCC spec. Given that we currently have two HC
> spaces (the ARM-controlled one, and the KVM-specific one), the
> function space being 16bits in each case, that's 16kB worth of zeroes
> that userspace has to save/restore at all times... I'm not overly
> enthusiastic.

Yeah, that's definitely overkill.

I agree with your position; we can solve the issue altogether by
enforcing ordering on the hypercall registers. Userspace should read
all hypercall registers to discover features, then write them. Given
your suggestion, I don't know if there is much need for the guesswork
to conclude on an appropriate register size for the hypercall bitmaps.
64 bits seems fine to me..

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
