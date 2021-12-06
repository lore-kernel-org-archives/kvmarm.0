Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C645BC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  6 Dec 2021 00:27:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E27E49E5F;
	Sun,  5 Dec 2021 19:27:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QuzekzV5tD+K; Sun,  5 Dec 2021 19:27:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03C0D4A534;
	Sun,  5 Dec 2021 19:27:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBA6249E5F
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Dec 2021 19:27:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9Yk6Fu65wvLd for <kvmarm@lists.cs.columbia.edu>;
 Sun,  5 Dec 2021 19:27:51 -0500 (EST)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com
 [209.85.214.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 72C564079A
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Dec 2021 19:27:51 -0500 (EST)
Received: by mail-pl1-f178.google.com with SMTP id v19so5958225plo.7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 05 Dec 2021 16:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=XH9zAA4/zHBGhFLStgpHPbOeTSD/lmboLAC+Bisui4M=;
 b=kxXEYPGKHOuAz/SBJJSj8ALEyzO/UbtVTx/J7yQhY7ogEHQTUIEGTaFdcwLrnmJuLx
 7ofTCMO/nEGtf8Rk8nN2UyA596euNb8rJYY/J0s/ruwsBrQzhyje45fwfhDDStJX4x93
 z/2spAAYDOauVV7Q4fUZnLWLJ0I1U2ysAI8e6ViemWAQs1XKcNrg8ojunZn80qaSFINV
 k+ttlc57+dEP0h75rnwZ4eQt0xDTcKdUKZpZo4SO1F6k60Lk2m/gQlcAKu6LyclOmWcJ
 Nf8GHXPDyFjWJkWIRUbOLRswOa6F3WcmkCb6Jb6av7gVkiMwNXVOzhPZyi4g9h4kc2mj
 nM+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=XH9zAA4/zHBGhFLStgpHPbOeTSD/lmboLAC+Bisui4M=;
 b=eGVgWumrYqsnlTdtOCTtYaot1d4hXzBMjP5cCNZgcWZNMFM8D/oNz05HXKUR3p86ru
 tGWdTHAy/6afGloNFa+gWVbf4JkLaXhpvLq0Mq941Okp0xaj+1EYQJQbxkRMf67YKMFC
 NXNd50fmn9izre+VtO3bo8iEcWesGvMv6fxdoDsbFVu/aY9PvN7FuOFTqvSg/BetSRNH
 sSpsnI4YNbS95NADWeBw+0YMQ83rGNNn3FeTni8vqW/1Qxwk8xCnylYjLdNBecJl8VOy
 1rWSojVAl/1mC7jLQQvuhOdJNXsbTK10vomDuXQ6whZp582iXNeqdJl2G9v5/kRARIg9
 7axw==
X-Gm-Message-State: AOAM532XuVFDx4qpbPcpSWuZuyUBW8J/5NUXS4dN6q3NUoeccYzqBynN
 LSajlAlBWwQgZpCrCoqCyFgr5MNd+hrlD3eEtLqVog==
X-Google-Smtp-Source: ABdhPJwtfJ8rStZX+AKgdVQSxCJFq32p9mcQytMoHyO5Lrparr/yPuIUYHpi1AQCGcvY4g64a2FhuyyHar1vfUMjS1Q=
X-Received: by 2002:a17:90b:380d:: with SMTP id
 mq13mr33138599pjb.110.1638750470434; 
 Sun, 05 Dec 2021 16:27:50 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-10-reijiw@google.com>
 <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com>
 <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
 <5bd01c9c-6ac8-4034-6f49-be636a3b287c@redhat.com>
 <CAAeT=FwEogskDQVwwTkZSstYX7-X0r1B+hUUHbZOE5T5o9V=ww@mail.gmail.com>
 <2ed3072b-f83d-1b17-0949-ca38267ba94e@redhat.com>
 <CAAeT=Fy7JuCQKgy-ZaS9wPe6h93_WRMYmhihovYDjyg2a+BqNw@mail.gmail.com>
 <CANW9uythbRWo6_oWeS8o8gD7FZqo6hapmSgPX69CqhV4VJTHVQ@mail.gmail.com>
In-Reply-To: <CANW9uythbRWo6_oWeS8o8gD7FZqo6hapmSgPX69CqhV4VJTHVQ@mail.gmail.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Sun, 5 Dec 2021 16:27:34 -0800
Message-ID: <CAAeT=FxTrEnsQWP-DVg8A=X3E=2H9AQ8CKwGLntYbjUWryDiBQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
To: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Eric Auger <eauger@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Itaru,

No, I have no idea...
(I just noticed that I also had a lot of kvmarm emails that were
treated as spam...)

Thanks,
Reiji




On Sat, Dec 4, 2021 at 3:38 PM Itaru Kitayama <itaru.kitayama@gmail.com> wrote:
>
> Reiji,
> GMail keeps marking your email as spam, any ideas?
>
> On Sun, Dec 5, 2021 at 2:43 AM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Eric,
> >
> > On Sat, Dec 4, 2021 at 6:14 AM Eric Auger <eauger@redhat.com> wrote:
> > >
> > > Hi Reiji,
> > >
> > > On 12/4/21 2:04 AM, Reiji Watanabe wrote:
> > > > Hi Eric,
> > > >
> > > > On Thu, Dec 2, 2021 at 2:57 AM Eric Auger <eauger@redhat.com> wrote:
> > > >>
> > > >> Hi Reiji,
> > > >>
> > > >> On 11/30/21 6:32 AM, Reiji Watanabe wrote:
> > > >>> Hi Eric,
> > > >>>
> > > >>> On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
> > > >>>>
> > > >>>> Hi Reiji,
> > > >>>>
> > > >>>> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> > > >>>>> When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> > > >>>>> means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> > > >>>>> expose the value for the guest as it is.  Since KVM doesn't support
> > > >>>>> IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> > > >>>>> exopse 0x0 (PMU is not implemented) instead.
> > > >>>> s/exopse/expose
> > > >>>>>
> > > >>>>> Change cpuid_feature_cap_perfmon_field() to update the field value
> > > >>>>> to 0x0 when it is 0xf.
> > > >>>> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> > > >>>> guest should not use it as a PMUv3?
> > > >>>
> > > >>>> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> > > >>>> guest should not use it as a PMUv3?
> > > >>>
> > > >>> For the value 0xf in ID_AA64DFR0_EL1.PMUVER and ID_DFR0_EL1.PERFMON,
> > > >>> Arm ARM says:
> > > >>>   "IMPLEMENTATION DEFINED form of performance monitors supported,
> > > >>>    PMUv3 not supported."
> > > >>>
> > > >>> Since the PMU that KVM supports for guests is PMUv3, 0xf shouldn't
> > > >>> be exposed to guests (And this patch series doesn't allow userspace
> > > >>> to set the fields to 0xf for guests).
> > > >> What I don't get is why this isn't detected before (in kvm_reset_vcpu).
> > > >> if the VCPU was initialized with KVM_ARM_VCPU_PMU_V3 can we honor this
> > > >> init request if the host pmu is implementation defined?
> > > >
> > > > KVM_ARM_VCPU_INIT with KVM_ARM_VCPU_PMU_V3 will fail in
> > > > kvm_reset_vcpu() if the host PMU is implementation defined.
> > >
> > > OK. This was not obvsious to me.
> > >
> > >                 if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
> > >                         ret = -EINVAL;
> > >                         goto out;
> > >                 }
> > >
> > > kvm_perf_init
> > > +       if (perf_num_counters() > 0)
> > > +               static_branch_enable(&kvm_arm_pmu_available);
> > >
> > > But I believe you ;-), sorry for the noise
> >
> > Thank you for the review !
> >
> > I didn't find the code above in v5.16-rc3, which is the base code of
> > this series.  So, I'm not sure where the code came from (any kvmarm
> > repository branch ??).
> >
> > What I see in v5.16-rc3 is:
> > ----
> > int kvm_perf_init(void)
> > {
> >         return perf_register_guest_info_callbacks(&kvm_guest_cbs);
> > }
> >
> > void kvm_host_pmu_init(struct arm_pmu *pmu)
> > {
> >         if (pmu->pmuver != 0 && pmu->pmuver != ID_AA64DFR0_PMUVER_IMP_DEF &&
> >             !kvm_arm_support_pmu_v3() && !is_protected_kvm_enabled())
> >                 static_branch_enable(&kvm_arm_pmu_available);
> > }
> > ----
> >
> > And I don't find any other code that enables kvm_arm_pmu_available.
> >
> > Looking at the KVM's PMUV3 support code for guests in v5.16-rc3,
> > if KVM allows userspace to configure KVM_ARM_VCPU_PMU_V3 even with
> > ID_AA64DFR0_PMUVER_IMP_DEF on the host (, which I don't think it does),
> > I think we should fix that to not allow that.
> > (I'm not sure how KVM's PMUV3 support code is implemented in the
> > code that you are looking at though)
> >
> > Thanks,
> > Reiji
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
