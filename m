Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4BCCC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 17:24:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 30325617E5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 17:24:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 30325617E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A52774B105;
	Thu, 30 Sep 2021 13:24:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9zGl5r4sQsyQ; Thu, 30 Sep 2021 13:24:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 329B64B0ED;
	Thu, 30 Sep 2021 13:24:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2323D4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 13:24:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6c2ezzX04BAc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 13:24:36 -0400 (EDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com
 [209.85.167.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF7D74B0E2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 13:24:36 -0400 (EDT)
Received: by mail-lf1-f44.google.com with SMTP id y26so28591598lfa.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 10:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=IOus6RZAODeflkitNKNtNRm/hVuYigDJWYb8TVA+haU=;
 b=D2uC1NpXnCez3Ytp4VABnJkvuhi+0CS1VaFTV4avogW3x4OrLuLLvWQMiRKr1WKS4j
 PTcaPWmLAuGANDqHrTiVVzKCY9yfkwlb8WF6Tf+gfa3rZe5IEYkji7+xmGl3rOEYvXJW
 b5Sk2IDU4tM0PNkXD2K9uOT9iGAlVWXGtu/xvJUhdVEf1oEVw79VV3xiqTZJ6GPco5Hj
 qI41SIPc3djWuAzkAyNJtK2/wFu3txyPfUazgTIrYiidLHB31U5f7cuCCV1DDN0mNPyT
 Ayftn5S5JLoPEABEMCy6hvZqZX0QfyiS0qtlyoTlroaVcP740VEQqqWnj8H9ezw/JFos
 Z8IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=IOus6RZAODeflkitNKNtNRm/hVuYigDJWYb8TVA+haU=;
 b=oJDgJojW+SqEUYWlnbTQds8gsAkQvNN6vNHp4EFrhUN2UReo0lA2AKInljE4AduP8x
 MErImWm/kkA4E4Xx2hC86hDbgVkITbxJPjOf5W/36q93AjBNEnIhxR42cozK0V9ydFg8
 LHAzJIv3R6kKj10JsuB4SMMrjVq5kSvpFQ5k+DbdOSaKsnEIi/mtd778OyPpQspT+kg2
 MkjyOSflUM8ubAyb9+Bxexnfc6tXesL6o2UJVDvbJLhQ+7l/dnEz/h1a66l6yqVtgbkB
 h8RoNLqDdNKI/yrzPYDeJJsdBRpZcElP2V4qai1zFvzHf/iq2by4eobEWBu89xjeQFur
 URdA==
X-Gm-Message-State: AOAM5331OOZqAr0WJqG9xNncLUQrJv2kyXb7cGMP7KGy6TK9FOj0xVlJ
 mgkl/5jEgvPhrWItn3NPeicigv76tdeKrAz31StCOA==
X-Google-Smtp-Source: ABdhPJwfSVC7//d6/e+fZoayLkD2H1zJPhp0sz/K7FbaHBHjYfcsEHPJ7CByH+JJAViNtjzQ2spoMMRGnDDx4TU0YSE=
X-Received: by 2002:a2e:95cc:: with SMTP id y12mr7165903ljh.337.1633022674911; 
 Thu, 30 Sep 2021 10:24:34 -0700 (PDT)
MIME-Version: 1.0
References: <YSVhV+UIMY12u2PW@google.com> <87mtp5q3gx.wl-maz@kernel.org>
 <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
 <87fsuxq049.wl-maz@kernel.org> <20210825150713.5rpwzm4grfn7akcw@gator.home>
 <CAOQ_QsgWiw9-BuGTUFpHqBw3simUaM4Tweb9y5_oz1UHdr4ELg@mail.gmail.com>
 <877dg8ppnt.wl-maz@kernel.org> <YSfiN3Xq1vUzHeap@google.com>
 <20210827074011.ci2kzo4cnlp3qz7h@gator.home>
 <CAOQ_Qsg2dKLLanSx6nMbC1Er9DSO3peLVEAJNvU1ZcRVmwaXgQ@mail.gmail.com>
 <87ilyitt6e.wl-maz@kernel.org>
In-Reply-To: <87ilyitt6e.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Thu, 30 Sep 2021 10:24:23 -0700
Message-ID: <CAOQ_QshfXEGL691_MOJn0YbL94fchrngP8vuFReCW-=5UQtNKQ@mail.gmail.com>
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

Hey Marc,

On Thu, Sep 30, 2021 at 12:32 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Oliver,
>
> On Wed, 29 Sep 2021 19:22:05 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > I have some lingering thoughts on this subject since we last spoke and
> > wanted to discuss.
> >
> > I'm having a hard time figuring out how a VMM should handle a new
> > hypercall identity register introduced on a newer kernel. In order to
> > maintain guest ABI, the VMM would need to know about that register and
> > zero it when restoring an older guest.
>
> Just as it would need to be able to discover any new system register
> exposed by default, as it happens at all times. Which is why we have a
> way to discover all the registers, architected or not.
>
> > Perhaps instead we could reserve a range of firmware registers as the
> > 'hypercall identity' registers. Implement all of them as RAZ/WI by
> > default, encouraging userspace to zero these registers away for older
> > VMs but still allowing an old userspace to pick up new KVM features.
> > Doing so would align the hypercall identity registers with the feature
> > ID registers from the architecture.
>
> The range already exists in the form of the "coprocessor" 0x14. I
> don't see the need to expose it as RAZ/WI, however. If userspace
> doesn't know about how this pseudo-register works, it won't be able to
> program it anyway.
>
> I don't buy the parallel with the ID-regs either. They are RAZ/WI by
> default so that they don't UNDEF at runtime. The meaning of a RAZ
> id-register is also well defined (feature not implemented), and the
> CPU cannot write to them. In a way, the ID-regs *are* the enumeration
> mechanism.
>
> Our firmware registers don't follow the same rules. Userspace can
> write to them, and there is no such "not implemented" rule (case in
> point, PSCI). We also have a separate enumeration mechanism
> (GET_ONE_REG), which is (more or less) designed for userspace to find
> what is implemented.
>
> For these reasons, I don't immediately see the point of advertising a
> set of registers ahead of time, before userspace grows an
> understanding of what these registers mean.

Supposing we don't preallocate some hypercall ID registers, how can we
safely migrate a guest from an older kernel to newer kernel? Ideally,
we would preserve the hypercall feature set across the migration which
could work for a while with the first set of registers that get
defined, but whenever a new hypercall firmware register comes along
then the VMM will be clueless to the new ABI.

Fundamentally, I don't think userspace should need a patch to preserve
ABI on a newer kernel. Despite that, it would seem that userspace will
need to learn of any firmware registers that control hypercall
features which come after the initial set that gets proposed. If
KVM_GET_REG_LIST were to disambiguate between ID registers (hypercall,
architectural feature ID registers) from other parts of the vCPU
state, it would be clear to what registers to zero on a newer kernel.
Apologies if it is distracting to mention the feature ID registers
here, but both are on my mind currently and want to make sure there is
some consistency in how features get handled on newer kernels,
architected or not.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
