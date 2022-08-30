Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E37C0502A
	for <kvmarm@archiver.kernel.org>; Tue, 30 Aug 2022 23:48:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B57E4B7B6;
	Tue, 30 Aug 2022 19:48:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mVZD2PycoVeb; Tue, 30 Aug 2022 19:48:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 523294B7B0;
	Tue, 30 Aug 2022 19:48:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD3024B7B0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 19:48:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1f79avctyjGQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2022 19:48:50 -0400 (EDT)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com
 [209.85.128.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C3714B7A9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 19:48:50 -0400 (EDT)
Received: by mail-wm1-f43.google.com with SMTP id h1so6521227wmd.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 16:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=tGVEnlLMpBamjr5zlczXq7fmwaznwoQ3idHABhgUuYM=;
 b=KO+U0jA43GLZcwdXeyIX5nApqOewvbCN/kEwEioSXyjvoFoRRmxVAcOEse3v+CVhbj
 jLnHHxVADcF5HhHRpQWGwFrUyrKwk/ndVvQHr5H0dAMUG9zgcyZoOT4OnkbuHncsWNgp
 IkNnbqP9J0Dxp7txF3JCyMDpfIQ1B2h7kA+vEyRJqPQlMXi0WVQapPgKkZ3OF2ek4sMn
 p7/0r48ezijpvcOm73x2lrXy/ZNJIVDm0GMPqolOSYldXS2Sms+cdrIs9fxhD8wqcVvN
 GHItupLX5AYb2kO185XF6k+WC4V1D2cTOf9gvnN9lUQf3v7aPT+RAye8vYV/E7rrdfK6
 dVeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=tGVEnlLMpBamjr5zlczXq7fmwaznwoQ3idHABhgUuYM=;
 b=VXTW9Cc2vSKYigBMFocrFPvBZ9TqtcTW62G+/wj9SW3qPuTKZiRuNKCfMaL37mHp+Y
 /UCpzA5e6qWQ5BHsHpJCTR526AN/6FQ1Eh3u6kYdsEqj77Zw9jWGlQNhASuUVjN42URL
 GrxiXifqXJtEiu5SlPgj6G8YVPBau941MaG5/A6Ae+VjVHNDyZFC+CKz5s8T4rIlkGSC
 DokGfOjE2lqxj0SSsVJb3qDn9PuOgNU3mtYfSRp+961djPlZ1j0v6JIQEa1PR/y3OcnY
 7D3F+uqbCikdtD6VA+SMoNIqYWZk6zjqtScBRvl1H9mvROYc3LnWTuFtgHMpadt/K8IZ
 GSzA==
X-Gm-Message-State: ACgBeo2VUbybs4MbeRyZ0mgffwB4E10kBDPyNDN7q/VJREUGueVi2Z1n
 4J3YghHzPdgpDrBu6UoX6U1HnCZh3OaoTQOHMIyGxw==
X-Google-Smtp-Source: AA6agR7kuj8FMBlUqHe1KsZByANta0qdtZ6dMTJPpi0P8kKLcTUdSOfhQ26jHFWjNyun/bjf1Y0GHPcdkLlVKxphkH4=
X-Received: by 2002:a05:600c:1e05:b0:3a5:b441:e9c with SMTP id
 ay5-20020a05600c1e0500b003a5b4410e9cmr231944wmb.24.1661903329205; Tue, 30 Aug
 2022 16:48:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220823004639.2387269-1-yosryahmed@google.com>
 <20220823004639.2387269-4-yosryahmed@google.com> <Ywkq8HYyTI1eStSO@google.com>
 <Yw6GoWY411PrIRMx@google.com>
In-Reply-To: <Yw6GoWY411PrIRMx@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Tue, 30 Aug 2022 16:48:12 -0700
Message-ID: <CAJD7tkafp25jfH1cTQksMa-xt6bAu3LKEWT0pCNYqtijhvjRYQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
To: Sean Christopherson <seanjc@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Shaoqin <shaoqin.huang@intel.com>, Linux-MM <linux-mm@kvack.org>,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, Cgroups <cgroups@vger.kernel.org>,
 Huang@google.com, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Tue, Aug 30, 2022 at 2:52 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Aug 26, 2022, Sean Christopherson wrote:
> > On Tue, Aug 23, 2022, Yosry Ahmed wrote:
> > > Count the pages used by KVM mmu on x86 in memory stats under secondary
> > > pagetable stats (e.g. "SecPageTables" in /proc/meminfo) to give better
> > > visibility into the memory consumption of KVM mmu in a similar way to
> > > how normal user page tables are accounted.
> > >
> > > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c     | 16 ++++++++++++++--
> > >  arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++++++
> > >  2 files changed, 26 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index e418ef3ecfcb..4d38e4eba772 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -1665,6 +1665,18 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
> > >     percpu_counter_add(&kvm_total_used_mmu_pages, nr);
> > >  }
> > >
> > > +static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> > > +{
> > > +   kvm_mod_used_mmu_pages(kvm, +1);
> > > +   kvm_account_pgtable_pages((void *)sp->spt, +1);
> > > +}
> > > +
> > > +static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> > > +{
> > > +   kvm_mod_used_mmu_pages(kvm, -1);
> > > +   kvm_account_pgtable_pages((void *)sp->spt, -1);
> > > +}
> >
> > Hrm, this is causing build on x86 issues for me.  AFAICT, modpost doesn't detect
> > that this creates a new module dependency on __mod_lruvec_page_state() and so doesn't
> > refresh vmlinux.symvers.
> >
> >   ERROR: modpost: "__mod_lruvec_page_state" [arch/x86/kvm/kvm.ko] undefined!
> >   make[2]: *** [scripts/Makefile.modpost:128: modules-only.symvers] Error 1
> >   make[1]: *** [Makefile:1769: modules] Error 2
> >   make[1]: *** Waiting for unfinished jobs....
> >   Kernel: arch/x86/boot/bzImage is ready  (#128)
> >   make[1]: Leaving directory '/usr/local/google/home/seanjc/build/kernel/vm'
> >   make: *** [Makefile:222: __sub-make] Error 2
> >
> > Both gcc and clang yield the same behavior, so I doubt it's the compiler doing
> > something odd.  Cleaning the build makes the problem go away, but that's a poor
> > band-aid.
> >
> > If I squash this with the prior patch that adds kvm_account_pgtable_pages() to
> > kvm_host.h, modpost detects the need to refresh and all is well.
> >
> > Given that ARM doesn't support building KVM as a module, i.e. can't run afoul
> > of whatever modpost weirdness I'm hitting, I'm inclined to squash this with the
> > previous patch and punt on the modpost issue so that we can get this merged.
> >
> > Any objections?  Or thoughts on what's going wrong?
>
> Pushed the series with the squash to branch `for_paolo/6.1` at:
>

Thanks Sean!

>     https://github.com/sean-jc/linux.git
>
> Unless you hear otherwise, it will make its way to kvm/queue "soon".
>
> Please yell if there are objections.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
