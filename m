Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5B9ECAAD6
	for <kvmarm@archiver.kernel.org>; Fri, 26 Aug 2022 20:20:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BD7A4D954;
	Fri, 26 Aug 2022 16:20:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bIYUgc39JKVW; Fri, 26 Aug 2022 16:20:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A5634DC23;
	Fri, 26 Aug 2022 16:20:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22F3A4DB80
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 16:20:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i+ovF9mkytJS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Aug 2022 16:20:05 -0400 (EDT)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
 [209.85.210.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C312E4D954
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 16:20:05 -0400 (EDT)
Received: by mail-pf1-f177.google.com with SMTP id 72so2546205pfx.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 13:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc;
 bh=Yy3h91/LZL0yMN3Y+gPnYCc8uzqqu6+PEMw/uYOkvrQ=;
 b=QI2iqRq9/94E6zl7r9mZw4F+7Daqhq8WErAzs7MCXRZvrz4GpEbY7Dstc+ZZ2JEyb2
 q0xcA8xKqPk01eYmQLRlBIm9I9enL9gle1pvxTgv3hEVqdUw5C4cSi7lwuKtIjcxf5KZ
 MNemfeMqo0zzfRvxEdPkaXJq+V0CXBJoNhrKZhmH2a/6fEvyddf2Pci6F7c3hz5Uh2KZ
 p9XfmAZB3QDZNhI51WLuUsrX5a34H43X0h0MgNESMM7lb3mZRO5lRiW8QfXtTjK0Iio8
 Bx/faeNKIHAHpdLZt2Qt47/Jnw19TxwGoB6eZJ5V4qbulyod0s+zhEZ6nWzqexbUBQl1
 6MGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=Yy3h91/LZL0yMN3Y+gPnYCc8uzqqu6+PEMw/uYOkvrQ=;
 b=ldUwj2n4HuvQNYAqWRiP2yHeo6HW+8CNvXDQav+f9MWgksULeOmLO1Dw2VTSloOOKH
 +Oa8ifoZEyD73sAqsCnfoKWJ1b+RX90j50eWldtY/hV9vauHZ3O9W9L7U5vt9CTTa/yL
 D+jNAsARKDq3lSofxlQqSKpyVupGh1EdM1BJ+QdyaGeJs6Pe+nkNKNSDpWaDlpkgByby
 53jlZKCJ4fjsVGTgsgmBT9hETR2+MsaEdIAcXESDX4Ka9HWVVuovsinzCX1HNJifEEXH
 eQ1l4BvJ1ug6z6mtE+dXuyW1v8JKGSW7EZzDPekq38mjdMdKLAdlM5sGCCY/wkGSOlxN
 tu7A==
X-Gm-Message-State: ACgBeo0PsDpdpLaa4B5w8XHXLc47SJcBog1iJ8w9VL1Kd5Uj+Z3Gc5j4
 ZHEv9M66p5i6UK+AdEq23VrqEw==
X-Google-Smtp-Source: AA6agR5n02jhbK1nhPu/jZhpJFX2d1euSOaYUkGIxcjNNi+QlVmGNtQ1h1+3uTxVaQGYEwd8dNh3mw==
X-Received: by 2002:a05:6a00:4147:b0:52e:2d56:17c8 with SMTP id
 bv7-20020a056a00414700b0052e2d5617c8mr5478964pfb.51.1661545204289; 
 Fri, 26 Aug 2022 13:20:04 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 x21-20020a63f715000000b0042b117e8bf8sm1843703pgh.23.2022.08.26.13.20.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 26 Aug 2022 13:20:03 -0700 (PDT)
Date: Fri, 26 Aug 2022 20:20:00 +0000
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v7 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
Message-ID: <Ywkq8HYyTI1eStSO@google.com>
References: <20220823004639.2387269-1-yosryahmed@google.com>
 <20220823004639.2387269-4-yosryahmed@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220823004639.2387269-4-yosryahmed@google.com>
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

On Tue, Aug 23, 2022, Yosry Ahmed wrote:
> Count the pages used by KVM mmu on x86 in memory stats under secondary
> pagetable stats (e.g. "SecPageTables" in /proc/meminfo) to give better
> visibility into the memory consumption of KVM mmu in a similar way to
> how normal user page tables are accounted.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     | 16 ++++++++++++++--
>  arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++++++
>  2 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e418ef3ecfcb..4d38e4eba772 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1665,6 +1665,18 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
>  	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
>  }
>  
> +static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +	kvm_mod_used_mmu_pages(kvm, +1);
> +	kvm_account_pgtable_pages((void *)sp->spt, +1);
> +}
> +
> +static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +	kvm_mod_used_mmu_pages(kvm, -1);
> +	kvm_account_pgtable_pages((void *)sp->spt, -1);
> +}

Hrm, this is causing build on x86 issues for me.  AFAICT, modpost doesn't detect
that this creates a new module dependency on __mod_lruvec_page_state() and so doesn't
refresh vmlinux.symvers.

  ERROR: modpost: "__mod_lruvec_page_state" [arch/x86/kvm/kvm.ko] undefined!
  make[2]: *** [scripts/Makefile.modpost:128: modules-only.symvers] Error 1
  make[1]: *** [Makefile:1769: modules] Error 2
  make[1]: *** Waiting for unfinished jobs....
  Kernel: arch/x86/boot/bzImage is ready  (#128)
  make[1]: Leaving directory '/usr/local/google/home/seanjc/build/kernel/vm'
  make: *** [Makefile:222: __sub-make] Error 2

Both gcc and clang yield the same behavior, so I doubt it's the compiler doing
something odd.  Cleaning the build makes the problem go away, but that's a poor
band-aid.

If I squash this with the prior patch that adds kvm_account_pgtable_pages() to
kvm_host.h, modpost detects the need to refresh and all is well.

Given that ARM doesn't support building KVM as a module, i.e. can't run afoul
of whatever modpost weirdness I'm hitting, I'm inclined to squash this with the
previous patch and punt on the modpost issue so that we can get this merged.

Any objections?  Or thoughts on what's going wrong?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
