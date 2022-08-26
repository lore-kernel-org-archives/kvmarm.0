Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B13AECAAD8
	for <kvmarm@archiver.kernel.org>; Fri, 26 Aug 2022 21:26:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B1FD4DC2D;
	Fri, 26 Aug 2022 17:26:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KC+Fwucuep1p; Fri, 26 Aug 2022 17:26:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 661B54DC27;
	Fri, 26 Aug 2022 17:26:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EEAE4DC0E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 17:26:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5BwcrgNONeC4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Aug 2022 17:26:10 -0400 (EDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
 [209.85.221.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 30B6B4DC02
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 17:26:10 -0400 (EDT)
Received: by mail-wr1-f53.google.com with SMTP id bu22so2851230wrb.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 14:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=6UsE1Ljxz5h0xq3FFSdwmgCBOa2/vJlV8vw/uQpbLSQ=;
 b=SWFjPL7/UKZ4cZdo+JI7Bm2LG8Zc5kFuduxCLX8+HwW0QibBTetn/y2E41mk+x5paO
 JIzNbPVmE/Ekp/CzgnD2lphM56nu+cGQgvXiZ7OsW7wiDezSmmZwBWSBekAXujhOa0V0
 A/+blidel2lSXN57C4fj+Mly1CkPB7JfH8fuOLQhwEdLJ5xIgzgdP41dV/v/Oq6fs9v0
 LJnhM8cgZlGCe5bOOQ2JX0Rjt2uG1lGNw0/ekwO8fuwTjSJ6hE1BnAi1yzYcJ9yAPRpa
 cvbehGZsoN5xor3oKmd+C683+iy9LUhdk3WtP7wGbPJfzVQ4Bu4/vzWsAhyUKcA6bwn9
 MK+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=6UsE1Ljxz5h0xq3FFSdwmgCBOa2/vJlV8vw/uQpbLSQ=;
 b=iZ6nW4e9LX5UsSicMSeaSsO+f9lJ4S8Ph1Op33+3SpX0LNMrd0zm78Gu1F2RseX8Xr
 Cj6EUo6XZ/7V06kyEs+sW72TsqiyLDxkHBA2Hw7M+VrlXVEi6YNnwiRm/6b2Nb7d3xmh
 j5VHiLl9lwZiFr3zcC/xt0ekT1p2P7N0pjFbLpYSWl8n1DXjrurigC/+NRm42QWYzsY+
 CAQAHvajGIQoDg98tH9XHtmdhyyIVDmpiQ5+mr0IeOTaB8FiUrxQkX+UGPmvmtmNxhSo
 xqzR/3qbySeqKwFhloRy5SVnJ9zTs+nN2CyBH3+VxskmQCmybX1NWPKGD9e7k2xdXK7q
 o79g==
X-Gm-Message-State: ACgBeo0JgOmHDpvsCVXpyC2LV0siniHEbOuWpYBypgKbU14pQc0Atd3P
 1UlafJCFpMQC9f1PxUW9FyZjkYKsufuYjO1HhyWs3w==
X-Google-Smtp-Source: AA6agR4Hp1hENOCVVKgBgmda4N9xAiLK7ePDAp+2BKobakE/3YgGIHlFS8hcVYDNGA2YUpMSmk/d68XvTzxr+wDrl7o=
X-Received: by 2002:a5d:6d0c:0:b0:225:4ff9:7e67 with SMTP id
 e12-20020a5d6d0c000000b002254ff97e67mr776077wrq.534.1661549168831; Fri, 26
 Aug 2022 14:26:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220823004639.2387269-1-yosryahmed@google.com>
 <20220823004639.2387269-4-yosryahmed@google.com> <Ywkq8HYyTI1eStSO@google.com>
In-Reply-To: <Ywkq8HYyTI1eStSO@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Fri, 26 Aug 2022 14:25:32 -0700
Message-ID: <CAJD7tka4w059gZOJJnZj2zodQ7CGCFzKGbKEtt9cE2XP5GF73A@mail.gmail.com>
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

On Fri, Aug 26, 2022 at 1:20 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Aug 23, 2022, Yosry Ahmed wrote:
> > Count the pages used by KVM mmu on x86 in memory stats under secondary
> > pagetable stats (e.g. "SecPageTables" in /proc/meminfo) to give better
> > visibility into the memory consumption of KVM mmu in a similar way to
> > how normal user page tables are accounted.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c     | 16 ++++++++++++++--
> >  arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++++++
> >  2 files changed, 26 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index e418ef3ecfcb..4d38e4eba772 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1665,6 +1665,18 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
> >       percpu_counter_add(&kvm_total_used_mmu_pages, nr);
> >  }
> >
> > +static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> > +{
> > +     kvm_mod_used_mmu_pages(kvm, +1);
> > +     kvm_account_pgtable_pages((void *)sp->spt, +1);
> > +}
> > +
> > +static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> > +{
> > +     kvm_mod_used_mmu_pages(kvm, -1);
> > +     kvm_account_pgtable_pages((void *)sp->spt, -1);
> > +}
>
> Hrm, this is causing build on x86 issues for me.  AFAICT, modpost doesn't detect
> that this creates a new module dependency on __mod_lruvec_page_state() and so doesn't
> refresh vmlinux.symvers.
>
>   ERROR: modpost: "__mod_lruvec_page_state" [arch/x86/kvm/kvm.ko] undefined!
>   make[2]: *** [scripts/Makefile.modpost:128: modules-only.symvers] Error 1
>   make[1]: *** [Makefile:1769: modules] Error 2
>   make[1]: *** Waiting for unfinished jobs....
>   Kernel: arch/x86/boot/bzImage is ready  (#128)
>   make[1]: Leaving directory '/usr/local/google/home/seanjc/build/kernel/vm'
>   make: *** [Makefile:222: __sub-make] Error 2
>
> Both gcc and clang yield the same behavior, so I doubt it's the compiler doing
> something odd.  Cleaning the build makes the problem go away, but that's a poor
> band-aid.
>
> If I squash this with the prior patch that adds kvm_account_pgtable_pages() to
> kvm_host.h, modpost detects the need to refresh and all is well.
>
> Given that ARM doesn't support building KVM as a module, i.e. can't run afoul
> of whatever modpost weirdness I'm hitting, I'm inclined to squash this with the
> previous patch and punt on the modpost issue so that we can get this merged.
>
> Any objections?  Or thoughts on what's going wrong?

I am not familiar at all with modpost so I have no idea what's going
wrong, but I have no problem with squashing the patches if you think
this works best.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
