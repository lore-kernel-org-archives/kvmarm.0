Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE98CCA479
	for <kvmarm@archiver.kernel.org>; Fri,  1 Jul 2022 14:25:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BDA44B5BD;
	Fri,  1 Jul 2022 10:25:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2wpn47ZO0ddv; Fri,  1 Jul 2022 10:25:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC6CC4B5CD;
	Fri,  1 Jul 2022 10:25:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DE974B4FD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 17:02:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 802UaHs6EAls for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2022 17:02:30 -0400 (EDT)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C57044B49D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 17:02:30 -0400 (EDT)
Received: by mail-wr1-f43.google.com with SMTP id cl1so341238wrb.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 14:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=VtUlpkuhliUwoUgmaGEH+kEoEeunaS6PJnDK/W1XYz4=;
 b=JfrrtzAQjyLxnw8RtQ5sQiSNUfohoaMNZW2kYvifXlmGWgHr7XJMl/LQ5yWh4ZDLRh
 EIUPHXZDb5Va4mirbCSRVDZCPMlakbWCUXbrVx3s9CYunFEZ1slL1J+n0+lLyBmkjvq6
 dywxS4/phRbyRQsua97BR94hWDn23Q49DbtcSC9+zkt3E5pfCOfz49pW3hhqdvrjGdv+
 pKKf1x3hKQqAQrlbcPos/8s8jUYluEAVcvGGsPGpoOXyv0wrj0LnCa606tZy9ddxQBAt
 cF8lFcME2E999BhE7foEKF9XdpoRPCaTJec6Ks6Sa9LMwb5hg+yO+AGHFhUc1+iXyNs+
 Ct9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=VtUlpkuhliUwoUgmaGEH+kEoEeunaS6PJnDK/W1XYz4=;
 b=e7qZzq0/XbWwL2KXn3MAay+YWtAy7TEi9rNw4FiEWvZThVU305nolalgVSZ2i0P8ns
 ffpe1SJbWtIn3y+Vfj3adVyulePjO0TL4BCgJ0ytCuTK68f+yRy2Ge/CHfuMR2g+EkRT
 vJDWcmD3grTJsxiKw5MNgUdvHeNN+mqB3Jb1UkeJZqovlFKePA18h5vyV9gcLgDFpDH8
 JsuVB6EKZCBkmlkQb1vc7VnaNc03+4tnv0sY+9ryl073Zkc/5ZMG6BUzB2ey8q7gUNlp
 4EaamLbzG8OymbdtjRNfKMe6WqUnL1mDq6G402IdoviTnDNy6BBU6/0Z6yZ6XptW42lV
 VaxQ==
X-Gm-Message-State: AJIora8t0vGcOEgqrYXQ1g/zbBVkRMtv0YiomGQiSDcrilEXfYaFH1HW
 5T4UiUIyHg1eBeE7x9oONxJ4rBm1eHzFURsRfjpliA==
X-Google-Smtp-Source: AGRyM1tplZDxrLp9WaTGqMe3midVuGQbVARcYH1sMixpR7FPn6Bu0DJJ+rFZvHMXvlCiQJACUGtNy4P+3OS3+ElQNfs=
X-Received: by 2002:a05:6000:a1e:b0:21b:8c8d:3cb5 with SMTP id
 co30-20020a0560000a1e00b0021b8c8d3cb5mr10358939wrb.372.1656622949489; Thu, 30
 Jun 2022 14:02:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220628220938.3657876-1-yosryahmed@google.com>
In-Reply-To: <20220628220938.3657876-1-yosryahmed@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Thu, 30 Jun 2022 14:01:52 -0700
Message-ID: <CAJD7tkb3bDwt0gzOhS+3sSiy20Qy=G_AD8jZeY5DYh4=NyX3Bg@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] KVM: mm: count KVM mmu usage in memory stats
To: Paolo Bonzini <pbonzini@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Fri, 01 Jul 2022 10:25:03 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Shaoqin <shaoqin.huang@intel.com>, Linux-MM <linux-mm@kvack.org>,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>,
 Cgroups <cgroups@vger.kernel.org>, Huang@google.com,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
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

If/when this patchset gets merged, would it be through the mm tree or
kvm tree? It is based on the kvm-queue branch so I am guessing it
could be easier to go through kvm but I am not sure what the policy is
here. Andrew or Paolo, do you mind clarifying the policy on such
patchsets? Thanks!

On Tue, Jun 28, 2022 at 3:09 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> Add NR_SECONDARY_PAGETABLE memory stat and use it to account KVM mmu
> usage as the first type of accounted secondary page tables. This stat
> can be later extended to account for other types of secondary pages
> tables (e.g. iommu page tables).
>
> Rationale behind why this is useful and link to extended discussion in
> the first patch.
>
> ---
>
> Changes in V6:
> - Rebased on top of kvm/queue and fixed conflicts.
> - Fixed docs spaces and tabs (Sean).
> - More narrative commit logs (Sean and Oliver).
> - Updated kvm_account_pgtable_pages() documentation to describe the
>   rules of using it more clearly (Sean).
> - Collected Acks and Reviewed-by's by Shakeel and Oliver (Thanks!)
>
> Changes in V5:
> - Updated cover letter to explain more the rationale behind the change
>   (Thanks to contributions by Sean Christopherson).
> - Removed extraneous + in arm64 patch (Oliver Upton, Marc Zyngier).
> - Shortened secondary_pagetables to sec_pagetables (Shakeel Butt).
> - Removed dependency on other patchsets (applies to queue branch).
>
> Changes in V4:
> - Changed accounting hooks in arm64 to only account s2 page tables and
>   refactored them to a much cleaner form, based on recommendations from
>   Oliver Upton and Marc Zyngier.
> - Dropped patches for mips and riscv. I am not interested in those archs
>   anyway and don't have the resources to test them. I posted them for
>   completeness but it doesn't seem like anyone was interested.
>
> Changes in V3:
> - Added NR_SECONDARY_PAGETABLE instead of piggybacking on NR_PAGETABLE
>   stats.
>
> Changes in V2:
> - Added accounting stats for other archs than x86.
> - Changed locations in the code where x86 KVM page table stats were
>   accounted based on suggestions from Sean Christopherson.
>
> ---
>
> Yosry Ahmed (4):
>   mm: add NR_SECONDARY_PAGETABLE to count secondary page table uses.
>   KVM: mmu: add a helper to account memory used by KVM MMU.
>   KVM: x86/mmu: count KVM mmu usage in secondary pagetable stats.
>   KVM: arm64/mmu: count KVM s2 mmu usage in secondary pagetable stats
>
>  Documentation/admin-guide/cgroup-v2.rst |  5 ++++
>  Documentation/filesystems/proc.rst      |  4 +++
>  arch/arm64/kvm/mmu.c                    | 36 ++++++++++++++++++++++---
>  arch/x86/kvm/mmu/mmu.c                  | 16 +++++++++--
>  arch/x86/kvm/mmu/tdp_mmu.c              | 12 +++++++++
>  drivers/base/node.c                     |  2 ++
>  fs/proc/meminfo.c                       |  2 ++
>  include/linux/kvm_host.h                | 10 +++++++
>  include/linux/mmzone.h                  |  1 +
>  mm/memcontrol.c                         |  1 +
>  mm/page_alloc.c                         |  6 ++++-
>  mm/vmstat.c                             |  1 +
>  12 files changed, 89 insertions(+), 7 deletions(-)
>
> --
> 2.37.0.rc0.161.g10f37bed90-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
