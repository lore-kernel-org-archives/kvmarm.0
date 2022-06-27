Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A7EC43334
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jun 2022 11:24:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BA5D4B3A6;
	Tue, 28 Jun 2022 07:24:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bBV13yjMY6Nr; Tue, 28 Jun 2022 07:24:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D0754B3A9;
	Tue, 28 Jun 2022 07:24:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B33FC4B17D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 12:24:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e-EzpdiSIySK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2022 12:24:32 -0400 (EDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 83D284B11E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 12:24:32 -0400 (EDT)
Received: by mail-wr1-f44.google.com with SMTP id v14so13816187wra.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 09:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=3xCqZKogDypv6eypnWAIX07mm+p6TcVFKXGmBz5uwGo=;
 b=EFJ93YBppveZN8tb8RoZSuAH5W5SG1LiH1nd2yGt5BUolxb7x2ATW1Kz7biQm14+S1
 UM+Fp8eufEM8rSzaN98Vxy+yjs/rNMirq3kcwGggDlKitVyql4aB21ps9KcBglapj9Ua
 1W4ZjfHFR1OX+l2hu2sbJa8kLFx8xcw+LngOMpTPoS5at+/yURveHnzp5IGPSJMu7ZvB
 x275CN6l1938KDghGgk+NqN925rKkvVMXE8N/H2EY4ZUpwt+isaWFqtc66lQKg5sW1P0
 qe563ZBGvDzi6k6E6WBMqiK4kFc+qfzpLTjoypM7LjJTmsiLm26bxb/pjD6ij7bCgcHB
 9Yqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=3xCqZKogDypv6eypnWAIX07mm+p6TcVFKXGmBz5uwGo=;
 b=p5s1Kn1t9XestZ11WbFEEt1HSvXEyTbByrh9TWefgi0l5stnsLQiHQZXSBI78hqw9U
 N94+6naBFdQKA8yZWtY5iHotwIbnI6ZnCrp0yikqWexQJkA4W7P3G6V+oODkMz1KEXHV
 sfE6sRjp5K8sF4ZZjNrIerNzQXIrMQGg25s8BOdd+6pxBvyCUG/2ig/nLjO+tg0YJoIL
 kyOw2avY7J72DHxOahpS3HlKtvj/jtUexiRPGaoqMsNkrqZNbKhC17LWb8iIxsT7HaxI
 zCPOojtXzNpyabW+Vf4AXV4XNEqIj+xKXFmKSWd1Z7/abiYYnSKcQ2IDlxLRvQPCGRTb
 5XUQ==
X-Gm-Message-State: AJIora9d4ETczOl0/5FHejt5ynpHZy9IgpvWpY8xvf+ycpZ23yMpsJxI
 5zXpRQ19tfJvXjLDwfi+bu5n1NIFEyWY3SyYPVxN7g==
X-Google-Smtp-Source: AGRyM1tEYhoQe960g1sn2OovJNLpmUQIbQxWnmCUUyO6DqjFG9AG5gJFJE0O7TF8AscROp1Q2QZs7ydLv2dJU1UWp8U=
X-Received: by 2002:a05:6000:a1e:b0:21b:8c8d:3cb5 with SMTP id
 co30-20020a0560000a1e00b0021b8c8d3cb5mr13353164wrb.372.1656347071360; Mon, 27
 Jun 2022 09:24:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220606222058.86688-1-yosryahmed@google.com>
 <20220606222058.86688-2-yosryahmed@google.com>
 <YrnVxM/5KjVhkOnn@google.com>
In-Reply-To: <YrnVxM/5KjVhkOnn@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 27 Jun 2022 09:23:55 -0700
Message-ID: <CAJD7tkaMYhG7_AQgn6fLGFVuSB4wDpY_GzcvSS99tSzTUKFkTw@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Tue, 28 Jun 2022 07:24:17 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Linux-MM <linux-mm@kvack.org>, Zefan Li <lizefan.x@bytedance.com>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>,
 Cgroups <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
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

On Mon, Jun 27, 2022 at 9:07 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jun 06, 2022, Yosry Ahmed wrote:
> > Add NR_SECONDARY_PAGETABLE stat to count secondary page table uses, e.g.
> > KVM mmu. This provides more insights on the kernel memory used
> > by a workload.
>
> Please provide more justification for NR_SECONDARY_PAGETABLE in the changelog.
> Specially, answer the questions that were asked in the previous version:
>
>   1. Why not piggyback NR_PAGETABLE?
>   2. Why a "generic" NR_SECONDARY_PAGETABLE instead of NR_VIRT_PAGETABLE?
>
> It doesn't have to be super long, but provide enough info so that reviewers and
> future readers don't need to go spelunking to understand the motivation for the
> new counter type.

I added such justification in the cover letter, is it better to
include it here alternatively?
or do you think the description in the cover letter is lacking?

>
> And it's probably worth an explicit Link to Marc's question that prompted the long
> discussion in the previous version, that way if someone does want the gory details
> they have a link readily available.
>
> Link: https://lore.kernel.org/all/87ilqoi77b.wl-maz@kernel.org

I will include the link in the next version.
Thanks!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
