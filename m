Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD99C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 11:27:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DDF2864FB9
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 11:27:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDF2864FB9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 671B84B5C0;
	Fri, 12 Mar 2021 06:27:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8fIv6zbhh-VF; Fri, 12 Mar 2021 06:27:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DA634B604;
	Fri, 12 Mar 2021 06:27:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E846E4B5C0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 06:27:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id arNIwKdQMzrw for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 06:27:32 -0500 (EST)
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com
 [209.85.222.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6C0D4B485
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 06:27:32 -0500 (EST)
Received: by mail-qk1-f181.google.com with SMTP id d20so23854969qkc.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 03:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=u1EhHKdwPPCUVSAkwuWb0B3B3ynF3dq6RDy3mVLuPFU=;
 b=Ki/1lAeKoSKsR98gQV1MLVLDNzSTTRckhdjHvuljR8TiSwRtXnYqf5HDZQ/qCC2mVu
 O5bcnUE1Z7d/WaXrCHqpbuRVqwsUW2X4q+DSnE5H3sZRApauDyWf/KpFSnCkKyY/6HMx
 bghOsZuUAyhlsWoJDysUDRG/3PKvLPIpMYXC3Q7vkKlVUPByL/fYofayijzJ0wHHK0O8
 IuEBPsl3dZETQTKyMDaG8qaTuUj6d+KW/FOFvaigCD+//DRiLBD2G5HYKOqCMLzTz+0c
 wyq6VlEDaaEEJsmIaTSoTfcSrgeVN3ekQxMYH5zj1/QBHG/1fpFgYamuCmJYIdGwMhVU
 i1/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=u1EhHKdwPPCUVSAkwuWb0B3B3ynF3dq6RDy3mVLuPFU=;
 b=UpeANEKFTZG82cFoLBvpjzWicqv12T0HQZgM4CoDvflpav1qCN9gMXmfWBakYEaWdh
 aNPofHJuYzE7Vkq7QCaUCQJFWQ6+q/4heTEXHbQQ/qdZB0ulMErifrw5IbG+H/UhOEkN
 6QNUTBVeNC3Hler6iVAwH5/3Qun55M1VTdJ06G+sGCr5qbkAPlJ0lWKc7gFUspd/qQzS
 sd4cWhi6fQwf86O2MV0fhpNA99JZZtqD9Zs6wiWdxWfaTJBqMAeKPHfCGQNcfodXopMZ
 hdgM7fhwjjHntFwEEBToRfPpUbSs5ws7ZSNKxPPL9BXF3s0cpKUIFzHsME/WrHe+mNna
 KOmA==
X-Gm-Message-State: AOAM533HlaWn678CfoWCrx1szjsdo2/gEH+09rndIBq6CkdTAh1WRO8U
 b0rsbeuRUs/vmvwU507aWS8bawJJXrUBExvwWF2slmak7Tq17w==
X-Google-Smtp-Source: ABdhPJzfQaFh0M85P02bSGJYZS2wXmDyqCQjY9rcLMZQBjnc4MakY05tayJS752XLUs1SE4A3G0OxdxH5jhgAS+ntj0=
X-Received: by 2002:a37:4d09:: with SMTP id a9mr12017983qkb.256.1615548452241; 
 Fri, 12 Mar 2021 03:27:32 -0800 (PST)
MIME-Version: 1.0
References: <20210304115454.3597879-1-ascull@google.com>
 <20210304115454.3597879-5-ascull@google.com>
 <YEnyds3LmQBWSeO4@google.com>
 <CADcWuH2QrnFzQ9NTf_oa+Tw8hZZqf5qOAw3zw5pdG-4Rbrq8ZQ@mail.gmail.com>
In-Reply-To: <CADcWuH2QrnFzQ9NTf_oa+Tw8hZZqf5qOAw3zw5pdG-4Rbrq8ZQ@mail.gmail.com>
From: Andrew Scull <ascull@google.com>
Date: Fri, 12 Mar 2021 11:27:20 +0000
Message-ID: <CADcWuH14sqUhhjh+6dC+7FqRr3bf6Y-fHMxjBc_gmeViz0gO4g@mail.gmail.com>
Subject: Re: [PATCH 04/10] KVM: arm64: Support smp_processor_id() in nVHE hyp
To: Quentin Perret <qperret@google.com>
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On Fri, 12 Mar 2021 at 11:20, Andrew Scull <ascull@google.com> wrote:
>
> On Thu, 11 Mar 2021 at 10:35, Quentin Perret <qperret@google.com> wrote:
> >
> > On Thursday 04 Mar 2021 at 11:54:47 (+0000), 'Andrew Scull' via kernel-team wrote:
> > > smp_procesor_id() works off of the cpu_number per-cpu variable. Create
> > > an nVHE hyp version of cpu_number and initialize it to the same value as
> > > the host when creating the hyp per-cpu regions.
> > >
> > > Signed-off-by: Andrew Scull <ascull@google.com>
> > > ---
> > >  arch/arm64/kvm/arm.c              | 2 ++
> > >  arch/arm64/kvm/hyp/nvhe/hyp-smp.c | 2 ++
> > >  2 files changed, 4 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 26ccc369cf11..e3edea8379f3 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -54,6 +54,7 @@ DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
> > >  static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
> > >  unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
> > >  DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
> > > +DECLARE_KVM_NVHE_PER_CPU(int, cpu_number);
> > >
> > >  /* The VMID used in the VTTBR */
> > >  static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
> > > @@ -1740,6 +1741,7 @@ static int init_hyp_mode(void)
> > >               page_addr = page_address(page);
> > >               memcpy(page_addr, CHOOSE_NVHE_SYM(__per_cpu_start), nvhe_percpu_size());
> > >               kvm_arm_hyp_percpu_base[cpu] = (unsigned long)page_addr;
> > > +             *per_cpu_ptr_nvhe_sym(cpu_number, cpu) = cpu;
> > >       }
> > >
> > >       /*
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
> > > index 879559057dee..86f952b1de18 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
> > > @@ -8,6 +8,8 @@
> > >  #include <asm/kvm_hyp.h>
> > >  #include <asm/kvm_mmu.h>
> > >
> > > +DEFINE_PER_CPU_READ_MOSTLY(int, cpu_number);
> >
> > Is smp_processor_id() going to work at EL2 with CONFIG_DEBUG_PREEMPT=y ?
> > If not, then maybe we should have out own hyp_smp_processor_id() macro?
>
> It's not, preempt_count() won't work,= at a minimum. I got far too
> drawn into the other branch of that #ifdef.
>
> We only use __smp_processor_id() in hyp, but that might not play too
> nicely with VHE and forgetting the leading underscores will just lead
> to nVHE issues that might not be caught in the build.
>
> So you might be right that this is a case where we need to break from
> standard APIs. And we can define `raw_smp_processor_id()` to something
> that will give a compile time error when used in hyp to try and
> prevent accidental misuse.

Having just read the build error again:

    :236: undefined reference to `__kvm_nvhe_debug_smp_processor_id'

Another option could be to define `debug_smp_processor_id()` for nvhe,
which is easy since preemption is always disabled, IIRC.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
