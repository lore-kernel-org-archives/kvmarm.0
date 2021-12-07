Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C11E5C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  7 Dec 2021 08:10:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E6EA4B0B9;
	Tue,  7 Dec 2021 03:10:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qnpe1KTQO-ne; Tue,  7 Dec 2021 03:10:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA35C4A98B;
	Tue,  7 Dec 2021 03:10:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8D2A4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 03:10:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WJggNsjlKloa for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Dec 2021 03:10:55 -0500 (EST)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB51C4A49C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 03:10:54 -0500 (EST)
Received: by mail-pj1-f51.google.com with SMTP id
 fv9-20020a17090b0e8900b001a6a5ab1392so1997923pjb.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Dec 2021 00:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=kw180PlZm49P4EPCW2Fkk5Cc6NuxVYiIeRmKk9+4sDw=;
 b=e3toeNpChZlvg+QWvmXtYC1DYZUZ6o4jwHITasU8lv9Di1mHWtdAkz/x29pbbsAfN9
 Vo/U4vxKnjRVwlghM41B1dynnyifYBDzbqRhJtWnSvFdSG+a77S0CN5AvDWQYnTBiVdn
 tMZA1Wimx+WnS2yCLqfPFd0clwVdHZm8JNKpmoeJRBHNDS59OPR9EcKJ7UbyZJNNvuXG
 pSHW7YLDdlA+ADkKfIsgH3K8c16JGA9413zVBTnVW6NlC2EFQFkpfthpfsarNPTgrIUx
 DmLQMVQlj8ns/JEm4nJRioEh+0Irp2ZR97gUdaz0q8jiLRAkljhlgZT1L1oUykQPARAu
 ndRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=kw180PlZm49P4EPCW2Fkk5Cc6NuxVYiIeRmKk9+4sDw=;
 b=2vjPgUSv0ahLFNFq04MEts5wWV/dXDvfsLIJ3UxM4QeV4HQ1JbfxHFKcdlnnXdn2f2
 ptNaDmaFJt/CdZZkRicWxelDD7ISnb6HO/VKoPUPo+yuJqNFVXJYLvkztLPZN2OMb9Gs
 5Bz7Idwigog63t5MISwmJ4nQXq1AYYCxMJvGmi1XbZv2qzq0dn3YPAWZ6wa3c8emtePs
 5/50W+tOHHY8vP6RzTIEVAq3lI5ZOXlg9Kja9Pq5syc947Vr/OcTY7do6dCgXDPsGv3n
 CKXFXYKWg2NUkOWj/ApiZfshNvPWg/HFCFuZeNdrIDkpW0yFGbu1JllX66GEx9IRbmlh
 rSWQ==
X-Gm-Message-State: AOAM533Wvhp8nI2vSR4WcOU3KwTmFcDufCynp70aY30m2mu8TSkzJ/qM
 xjh+MdrNzB1w07GRL3Jw23IF+kfO7lcAReld+xmqPQ==
X-Google-Smtp-Source: ABdhPJxwj8S+xE14NCZvmFndNf8YkjU5XEOXBG3g6u7YNHZDkHAouVhacZUsFavr+AD7MnjDkuwYLc5RCekiD4fMyuA=
X-Received: by 2002:a17:902:d703:b0:144:e012:d550 with SMTP id
 w3-20020a170902d70300b00144e012d550mr48891341ply.38.1638864653767; Tue, 07
 Dec 2021 00:10:53 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-10-reijiw@google.com>
 <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com>
 <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
 <5bd01c9c-6ac8-4034-6f49-be636a3b287c@redhat.com>
 <CAAeT=FwEogskDQVwwTkZSstYX7-X0r1B+hUUHbZOE5T5o9V=ww@mail.gmail.com>
 <2ed3072b-f83d-1b17-0949-ca38267ba94e@redhat.com>
 <CAAeT=Fy7JuCQKgy-ZaS9wPe6h93_WRMYmhihovYDjyg2a+BqNw@mail.gmail.com>
 <Ya3dQeXjUxAG8cCJ@monolith.localdoman>
In-Reply-To: <Ya3dQeXjUxAG8cCJ@monolith.localdoman>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 7 Dec 2021 00:10:37 -0800
Message-ID: <CAAeT=FxnjQw=zdYJzM4sB3zgs+7fE9KXV-wT_cDMGTXeVfqSvA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Eric Auger <eauger@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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

Hi Alex,

On Mon, Dec 6, 2021 at 1:52 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On Sat, Dec 04, 2021 at 09:39:59AM -0800, Reiji Watanabe wrote:
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
>
> The code was recently changed (in v5.15 I think), I think Eric is looking
> at an older version.
>
> >
> > Looking at the KVM's PMUV3 support code for guests in v5.16-rc3,
> > if KVM allows userspace to configure KVM_ARM_VCPU_PMU_V3 even with
> > ID_AA64DFR0_PMUVER_IMP_DEF on the host (, which I don't think it does),
> > I think we should fix that to not allow that.
>
> I recently started looking into that too. If there's only one PMU, then the
> guest won't see the value IMP DEF for PMUVer (userspace cannot set the PMU
> feature because !kvm_arm_support_pmu_v3()).
>
> On heterogeneous systems with multiple PMUs, it gets complicated. I don't
> have any such hardware, but what I think will happen is that KVM will
> enable the static branch if there is at least one PMU with
> PMUVer != IMP_DEF, even if there are other PMUs with PMUVer = IMP_DEF. But
> read_sanitised_ftr_reg() will always return 0 for the
> PMUVer field because the field is defined as FTR_EXACT with a safe value of
> 0 in cpufeature.c. So the guest ends up seeing PMUVer = 0.
>
> I'm not sure if this is the case because I'm not familiar with the cpu
> features code, but I planning to investigate further.

Thank you for the comment !

Yes, it looks like that KVM will enable the static branch if there
is at least one PMU with PMUVer != 0 && PMUVer != IMP_DEF.
(then, yes, AA64DFR0.PMUVER will be 0 even for a vCPU that
 KVM_ARM_VCPU_PMU_V3 is successfully configured for in the case)

I will look into it some more.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
