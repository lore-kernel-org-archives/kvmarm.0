Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E972ECAAA1
	for <kvmarm@archiver.kernel.org>; Tue, 30 Aug 2022 21:52:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 555BA4B931;
	Tue, 30 Aug 2022 17:52:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tAaBSPQ1p92t; Tue, 30 Aug 2022 17:52:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A0D24B8B7;
	Tue, 30 Aug 2022 17:52:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9732D4B8B5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 17:52:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G+Hu6S-Gw7f3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2022 17:52:39 -0400 (EDT)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
 [209.85.215.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FC984B8AE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 17:52:39 -0400 (EDT)
Received: by mail-pg1-f171.google.com with SMTP id r22so11843474pgm.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 14:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc;
 bh=kmi765rhdWrzQirlOzDuA6v2AsLs7icy29dLcvjyZaY=;
 b=hWJ7zNlkecdEXTrVZ6wmkEknTN/2exZUrz57/hU7W4XRQNtZqa+j7DxnleUp3IhKBb
 sPjQfJCIpekxST95aTOvA6LRmjGl/9uM3t36fhzVjmgsHhFGbG/O8T0o1vgEyeLA5C0I
 EFGHin0OUfFk0fiXENOHWlBqiA7nVmwWjwoJSedO1iB8vWSr7VHZW2nPJIXqSCBO/+pl
 sOwVvJuTcV0RbXyJlpScwEsj8aMQTbBVhWXan+gXoZK5KecfX5JTb9nvfZqtbC+UjDPf
 k0jWJ+//LY8Te/xXhINDpZFf2p1eG1WkkfXxk1m7qr7C9e/izZw1Pye0n6Us513YUn22
 Sv0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=kmi765rhdWrzQirlOzDuA6v2AsLs7icy29dLcvjyZaY=;
 b=k2Q62d2pfHx5EQ07JjYhAuxm+1/5I/rLyzGm4XmtOD+C7hPXIUc+mQr7UdQgEqYRjo
 Y+YqHm0Rs+gLEpUMvAIUuRoAqj59bXnbleRVPJSc3G9TrpwHeVn+cZDJYAl0G4tPMjcI
 le/VYoeSS5ZP3rDIZWYTq4uwjI1q7w2PgyDNVFLDwzLEMW6/L8iYiW4vnacDVmuKLCVI
 1Qme64vTa9IYUiVb+WyOP9CoEeZxVUsadCwHLlj/F79cdCN3wn9YvecEUrRNlzuNqlFD
 wN5zLhyF5WXAGmIVdg29I+AMmcBs7IDPBXc/K6yAx4Wb5T6Z4HkvokxsMPiBqh5h8CLz
 Vykg==
X-Gm-Message-State: ACgBeo2YtaPfsfV3vKefJ8dVGskia5lDanMMThdqU0E/9m0z3ASQ3Gfx
 zHKnHYIQuojtgCawVkTCtyHRMQ==
X-Google-Smtp-Source: AA6agR6asL5tWEMD9qdeUkMoP6zzYNAqZvPkbIyCF6qv1uEQUKWXuBujKh4awFSCPYR/F9Y2M19nxA==
X-Received: by 2002:aa7:8742:0:b0:537:ee75:601a with SMTP id
 g2-20020aa78742000000b00537ee75601amr17381844pfo.37.1661896357847; 
 Tue, 30 Aug 2022 14:52:37 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 k6-20020a170902ce0600b0015e8d4eb1dbsm10181118plg.37.2022.08.30.14.52.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 30 Aug 2022 14:52:37 -0700 (PDT)
Date: Tue, 30 Aug 2022 21:52:33 +0000
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v7 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
Message-ID: <Yw6GoWY411PrIRMx@google.com>
References: <20220823004639.2387269-1-yosryahmed@google.com>
 <20220823004639.2387269-4-yosryahmed@google.com>
 <Ywkq8HYyTI1eStSO@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Ywkq8HYyTI1eStSO@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Shaoqin <shaoqin.huang@intel.com>, linux-mm@kvack.org,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org, Huang@google.com,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
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

On Fri, Aug 26, 2022, Sean Christopherson wrote:
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
> >  	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
> >  }
> >  
> > +static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> > +{
> > +	kvm_mod_used_mmu_pages(kvm, +1);
> > +	kvm_account_pgtable_pages((void *)sp->spt, +1);
> > +}
> > +
> > +static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> > +{
> > +	kvm_mod_used_mmu_pages(kvm, -1);
> > +	kvm_account_pgtable_pages((void *)sp->spt, -1);
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

Pushed the series with the squash to branch `for_paolo/6.1` at:

    https://github.com/sean-jc/linux.git

Unless you hear otherwise, it will make its way to kvm/queue "soon".

Please yell if there are objections.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
