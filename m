Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC473C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 29 Apr 2022 15:38:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AF904B186;
	Fri, 29 Apr 2022 11:38:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9PaLaJHEWI9h; Fri, 29 Apr 2022 11:38:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 375EA4B116;
	Fri, 29 Apr 2022 11:38:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F0C9412FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 19:49:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WWwT6GbkQ5U9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2022 19:49:46 -0400 (EDT)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
 [209.85.128.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 828DA4120D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 19:49:46 -0400 (EDT)
Received: by mail-wm1-f44.google.com with SMTP id
 n126-20020a1c2784000000b0038e8af3e788so3850895wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 16:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=focMG0Yvzu8kTNlJIkjfWrJiugje96+mCpIttRqo5P4=;
 b=GOeTnHyfLUj1kYuuIm0Y/SV6rdbaURUuZyug5U8+bM9txNVDB4zqvMsTo6LgWxqqJ+
 EJzVOKlCGbXzZnVXdg3zImUfxT1mhWA8cbxLRGVt1mE5eBxCAY3hnU4fMZFKFe1/ysTG
 cyomFq/31PJ7L9dLLImNGTzmHFLpGkzqWJGCsZd6ESc2YMwmrym/vaV+ntsJIKN6uPzN
 GHJN6ZJmWTueQxTkthcuYUVcXcDsF4uUX/S+zj4KBcwgIjmuet5DXc3NMlNVPJ+MF4Jl
 g76wI45mkRhG8Ow9F+ienA/5IabcbdIA62pAqypAHshKR/CNShI7i+XFMGHcSQdqfi8n
 ZW7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=focMG0Yvzu8kTNlJIkjfWrJiugje96+mCpIttRqo5P4=;
 b=P6KmN5eHNVAIZA2qAr0GHqkValbw2vOB71Js94bNL6+RgChwv5L8YCXnlSzePbueaZ
 xzkD/JaVO7WO0kNcGkExX31+DZ13Z7Deq7QbY2TIUrDn+GrWpPgqzqJGrS/cWSBvc6kq
 WLsFmdmaQRiW9hss1h+EAi8i6y6opOZVnyHWCrtqL3xHz4yv/WUMWANB3QWJMzYTX/lO
 Gol9Vb4WQsv1rXGgHqM/2dpFCJSc/5qXbiRBSMoUjQ1g2JRx1UpC7IwNpO7zqgOJ1fOu
 bMtpUEo7XycOcRLAHhVzuGfujq4rYbMFWnsYQzOr7W4cvBzudB6eGrKc054YlRzDT1OE
 vYlw==
X-Gm-Message-State: AOAM532/yO/u8JGHS/ONGT1o3xaDOGMGO4NkmUhb3bvXpFnHEyPqh9gJ
 S1zEG9SwCHvzVEIYsjVhp1d+fdUlADLkTycfly0Yuw==
X-Google-Smtp-Source: ABdhPJya8b5HEmPINhPN/otjpFgAZMsVFO+BsikAPMu9LghWg6ZEVzzp+YtbjdBMxFE0lABxkDoCV9sNN45FlpkElhQ=
X-Received: by 2002:a05:600c:1c88:b0:394:dfa:917f with SMTP id
 k8-20020a05600c1c8800b003940dfa917fmr536458wms.27.1651189785285; Thu, 28 Apr
 2022 16:49:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220426053904.3684293-1-yosryahmed@google.com>
 <20220426053904.3684293-5-yosryahmed@google.com> <YmegoB/fBkfwaE5z@google.com>
 <CAJD7tkY-WZKcyer=TbWF0dVfOhvZO7hqPN=AYCDZe1f+2HA-QQ@mail.gmail.com>
 <YmrSywSU1ezREvT6@google.com>
In-Reply-To: <YmrSywSU1ezREvT6@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Thu, 28 Apr 2022 16:49:09 -0700
Message-ID: <CAJD7tkY1sdjXFAhftWG+ZV1B4z_HR9mf4QZGA-EJWeKaRQGs4Q@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] KVM: arm64/mmu: count KVM page table pages in
 pagetable stats
To: Oliver Upton <oupton@google.com>
X-Mailman-Approved-At: Fri, 29 Apr 2022 11:38:29 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Linux-MM <linux-mm@kvack.org>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>,
 Atish Patra <atishp@atishpatra.org>, cgroups@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, linux-mips@vger.kernel.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 kvm-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
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

On Thu, Apr 28, 2022 at 10:45 AM Oliver Upton <oupton@google.com> wrote:
>
> On Tue, Apr 26, 2022 at 12:27:57PM -0700, Yosry Ahmed wrote:
> > > What page tables do we want to account? KVM on ARM manages several page
> > > tables.
> > >
> > > For regular KVM, the host kernel manages allocations for the hyp stage 1
> > > tables in addition to the stage 2 tables used for a particular VM. The
> > > former is system overhead whereas the latter could be attributed to a
> > > guest VM.
> >
> > Honestly I would love to get your input on this. The main motivation
> > here is to give users insights on the kernel memory usage on their
> > system (or in a cgroup). We currently have NR_PAGETABLE stats for
> > normal kernel page tables (allocated using
> > __pte_alloc_one()/pte_free()), this shows up in /proc/meminfo,
> > /path/to/cgroup/memory.stat, and node stats. The idea is to add
> > NR_SECONDARY_PAGETABLE that should include the memory used for kvm
> > pagetables, which should be a separate category (no overlap). What
> > gets included or not depends on the semantics of KVM and what exactly
> > falls under the category of secondary pagetables from the user's pov.
> >
> > Currently it looks like s2 page table allocations get accounted to
> > kmem of memory control groups (GFP_KERNEL_ACCOUNT), while hyp page
> > table allocations do not (GFP_KERNEL). So we could either follow this
> > and only account s2 page table allocations in the stats, or make hyp
> > allocations use GFP_KERNEL_ACCOUNT as well and add them to the stats.
> > Let me know what you think.
>
> I think it is reasonable to just focus on stage 2 table allocations and
> ignore all else. As Marc pointed out it isn't workable in other
> contexts anyway (pKVM), and keeps the patch tidy too.
>
> GFP_KERNEL_ACCOUNT for hyp allocations wouldn't make sense, as it is
> done at init to build out the system page tables for EL2.

Thanks so much for the insights, will send out v4 according to our discussion.

>
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
