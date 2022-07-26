Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EBA0C3F6B0
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 18:04:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD52D4C6DF;
	Tue, 26 Jul 2022 14:04:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E50na6rYbqz8; Tue, 26 Jul 2022 14:04:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC3744C71A;
	Tue, 26 Jul 2022 14:04:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1264B4C6DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 14:04:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aUcv2xXcuoNk for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 14:04:02 -0400 (EDT)
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com
 [209.85.210.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A830D4C6D1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 14:04:02 -0400 (EDT)
Received: by mail-pf1-f175.google.com with SMTP id 70so13934896pfx.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 11:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=jhdzRZUAOMTnCV/vW7pBqgsIJIfjNF/pYz/pr69nELI=;
 b=ptd/st7Qx1CEBd6nXVmofsETHlqEG5YHpXzAHoHWMHaxaLqLQRwhFD8DrqTGh313HP
 IhmbQkRu0orlHojxKg773kXGBU90oYKT/i2R8RIWnvFI/6XWjOJwk/NLwViv8Eohzc71
 0u1CxuXzpRO+SKGj4rghNIk24TUgiK6N5EMVsSWyZucFXHEwqrREOemBmRGcO21GlJv+
 BHPELPoCCxRkiXuj0q4tx3KOjfEFuVK8aaztJ92oE13l2AqbgmCf3A+ZhaLe8cNklHQ/
 gZtTgJkayqLParwE71HzxpR93H5vfYmTwDBbX/RNcN9pr066yekhsOaOlX87QwoQCIMQ
 U+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=jhdzRZUAOMTnCV/vW7pBqgsIJIfjNF/pYz/pr69nELI=;
 b=tAAo6fuh2XBZSCwnuN22olAMrbPPOo5Rp9sWgmUgFfHGzDRqDH2cr9NPXFFfyuAUOK
 DmwSKtKGWYI38SEtD5kcsHmnOUvka9/3tRopsHHOKnWFOtPaLFcdhetBFTKbMqGCfKoa
 TU2dEjJnkV0tqwV/oAkzQQRvJ/mk/cR9FGGfStQ3Oh9p3VLfmNxiNE3MWuk6JijlMJgA
 ORm1MW2JKcu03Y2GQB9OuAyBA5V10RZWn6fFooYbEnAW5xP8wSddlMkI7nIO4lH0mIof
 Vrg6gAP/GTV0kaBxVILVd3O8wSZf1IsQi62Txbbnp3o+xACmg9xQEC6++RarBwynMklc
 cfjQ==
X-Gm-Message-State: AJIora8kNDXQJ/PXpnx/XGaEdevqXvVyW/MIQrtQL937RFtEiInvQ/Ak
 +aFUITEQ/Vhm4tjPvSja62i7gw==
X-Google-Smtp-Source: AGRyM1uKR6/hOW723JGGrSJD19noCDp0+vmsYlXYClvLLQpEtHJHtnV8BUou5cQTx2omdbkUrVjS2Q==
X-Received: by 2002:a05:6a00:1c54:b0:52b:a70e:8207 with SMTP id
 s20-20020a056a001c5400b0052ba70e8207mr18313321pfw.48.1658858641379; 
 Tue, 26 Jul 2022 11:04:01 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 f4-20020a170902860400b0016be0d5483asm11848682plo.252.2022.07.26.11.04.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 26 Jul 2022 11:04:00 -0700 (PDT)
Date: Tue, 26 Jul 2022 18:03:57 +0000
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v4 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
Message-ID: <YuAsjZbnCN/PrNKw@google.com>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-4-yosryahmed@google.com>
 <YtsPk5+hZNMEwT0c@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YtsPk5+hZNMEwT0c@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Yosry Ahmed <yosryahmed@google.com>, linux-mm@kvack.org,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Fri, Jul 22, 2022, Mingwei Zhang wrote:
> On Fri, Apr 29, 2022, Yosry Ahmed wrote:
> > Count the pages used by KVM mmu on x86 for in secondary pagetable stats.
> > 
> > For the legacy mmu, accounting pagetable stats is combined KVM's
> > existing for mmu pages in newly introduced kvm_[un]account_mmu_page()
> > helpers.
> > 
> > For tdp mmu, introduce new tdp_[un]account_mmu_page() helpers. That
> > combines accounting pagetable stats with the tdp_mmu_pages counter
> > accounting.
> > 
> > tdp_mmu_pages counter introduced in this series [1]. This patch was
> > rebased on top of the first two patches in that series.
> > 
> > [1]https://lore.kernel.org/lkml/20220401063636.2414200-1-mizhang@google.com/
> > 
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> 
> It looks like there are two metrics for mmu in x86: one for shadow mmu
> and the other for TDP mmu. Is there any plan to merge them together?

There aren't two _separate_ metrics per se, rather that the TDP MMU (intentionally)
doesn't honor KVM_SET_NR_MMU_PAGES, nor does it play nice the the core mm shrinkers.
Thus, the TDP MMU doesn't udpate kvm_mod_used_mmu_pages(), which feeds into both of
those things.

Long term, I don't think the TDP MMU will ever honor KVM_SET_NR_MMU_PAGES.  That
particular knob predates proper integration with memcg and probably should be
deprecated.

As for supporting shrinkers in the TDP MMU, it's unclear whether or not that's truly
necessary.  And until mmu_shrink_scan() is made a _lot_ smarter, it's somewhat of a
moot point because KVM's shrinker implementation is just too naive for it to be a net
positive, e.g. it tends to zap upper level entries and wipe out large swaths of KVM's
page tables.  KVM_SET_NR_MMU_PAGES uses the same naive algorithm, so it's not any better.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
