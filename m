Return-Path: <SRS0=fzUG=OL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5667EC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 07:55:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C97CC611ED
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 07:55:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C97CC611ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A95B4A3BF;
	Tue, 21 Sep 2021 03:55:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fbhYBFsV-GMu; Tue, 21 Sep 2021 03:55:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56DF94A524;
	Tue, 21 Sep 2021 03:55:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C03244079D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 02:27:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EtN0jx9nLaQM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 02:27:28 -0400 (EDT)
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com
 [209.85.222.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E7D6A4079A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 02:27:28 -0400 (EDT)
Received: by mail-qk1-f172.google.com with SMTP id f22so51226571qkm.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 23:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=bx2qLnibyjBQP3Cwq2rxTrw1KpHuF4QRllMp6t6UiFc=;
 b=a+vdvt88RTaFWVh/6GdGX0TUYAxYiZBTFwUXiduLzzBGBA58aeJyJ/WH5xNmFBtn/r
 xRrBAFTpOUiBaElOXIFY/I4e5GBgQG1E7dSqBD6oh6smn7vW7enSkUx1VLFh//geJ+8v
 J1VEIrYJ11fBZTo5/LP/PXnOJJLTqTREpTQLE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=bx2qLnibyjBQP3Cwq2rxTrw1KpHuF4QRllMp6t6UiFc=;
 b=qhMJCM/LARmoZJ7zuh7zkWU/hbzqnoZddhnaHygz6CqnP31w2Ki9RJzEitFcrYu2I7
 dEmRcnNECVeQx7B5TSVxJ7E8hsXjULSpjLCNmZ2KATeYOCttKTlh3dZ/JXLzfMjIF8Ba
 fV63nah+pIN4l5/gTVUgUCPLuI3stjP0je+A8HM33ktV4c8KGo708IaVtgyYMP6H/Jbe
 e32/rvNr8a8zU4Z0rfWv4FY4luvS/ImcaNHNsjvdVeaOxePMEvKCoh0uOcuyVvF8XkPq
 SlQzFO+PRdOkNcHyJv6UUvUmwNMwScCrBOiZpiKS6iku5g2VWuA9QS62/3BZaYQu0y+x
 ZrOg==
X-Gm-Message-State: AOAM5307lQls/fjLtBtjh2ic+Su5hDeWgBPIokMZo/0xR7WXZ4wxWmie
 tgWVMq6bNEu8mjLNukzyb96Xy9tMQNdqCgjolIR20A==
X-Google-Smtp-Source: ABdhPJwqv0yS1pJjqGFDkqVh9BDwoNusU5NQWtDRZgLijPyw8WvND8LS4z/Pgwym+MF/bGjXyf5kg/pSdTblO8nOE/I=
X-Received: by 2002:a05:6902:1547:: with SMTP id
 r7mr34266227ybu.72.1632205647689; 
 Mon, 20 Sep 2021 23:27:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210825025009.2081060-1-stevensd@google.com>
In-Reply-To: <20210825025009.2081060-1-stevensd@google.com>
From: David Stevens <stevensd@chromium.org>
Date: Tue, 21 Sep 2021 15:27:16 +0900
Message-ID: <CAD=HUj6_CFE0ZjexVMQMansmVcFRm3-udG=_12ROKfWDroNt-g@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] KVM: allow mapping non-refcounted pages
To: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Tue, 21 Sep 2021 03:55:36 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Joerg Roedel <joro@8bytes.org>, open list <linux-kernel@vger.kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

Is there any feedback on these patches? CVE-2021-22543 was fixed by
disallowing mapping of non-refcounted memory. These patches add proper
support for mapping that type of memory.

-David

On Wed, Aug 25, 2021 at 11:50 AM David Stevens <stevensd@chromium.org> wrote:
>
> From: David Stevens <stevensd@chromium.org>
>
> This patch series adds support for mapping non-refcount VM_IO and
> VM_PFNMAP memory into the guest.
>
> Currently, the gfn_to_pfn functions require being able to pin the target
> pfn, so they will fail if the pfn returned by follow_pte isn't a
> ref-counted page.  However, the KVM secondary MMUs do not require that
> the pfn be pinned, since they are integrated with the mmu notifier API.
> This series adds a new set of gfn_to_pfn_page functions which parallel
> the gfn_to_pfn functions but do not pin the pfn. The new functions
> return the page from gup if it was present, so callers can use it and
> call put_page when done.
>
> The gfn_to_pfn functions should be depreciated, since as they are unsafe
> due to relying on trying to obtain a struct page from a pfn returned by
> follow_pte. I added new functions instead of simply adding another
> optional parameter to the existing functions to make it easier to track
> down users of the deprecated functions.
>
> This series updates x86 and arm64 secondary MMUs to the new API.
>
> v2 -> v3:
>  - rebase on kvm next branch
> v1 -> v2:
>  - Introduce new gfn_to_pfn_page functions instead of modifying the
>    behavior of existing gfn_to_pfn functions, to make the change less
>    invasive.
>  - Drop changes to mmu_audit.c
>  - Include Nicholas Piggin's patch to avoid corrupting refcount in the
>    follow_pte case, and use it in depreciated gfn_to_pfn functions.
>  - Rebase on kvm/next
>
> David Stevens (4):
>   KVM: mmu: introduce new gfn_to_pfn_page functions
>   KVM: x86/mmu: use gfn_to_pfn_page
>   KVM: arm64/mmu: use gfn_to_pfn_page
>   KVM: mmu: remove over-aggressive warnings
>
>  arch/arm64/kvm/mmu.c            |  26 +++--
>  arch/x86/kvm/mmu/mmu.c          |  50 +++++----
>  arch/x86/kvm/mmu/mmu_internal.h |   3 +-
>  arch/x86/kvm/mmu/paging_tmpl.h  |  23 ++--
>  arch/x86/kvm/mmu/tdp_mmu.c      |   6 +-
>  arch/x86/kvm/mmu/tdp_mmu.h      |   4 +-
>  arch/x86/kvm/x86.c              |   6 +-
>  include/linux/kvm_host.h        |  17 +++
>  virt/kvm/kvm_main.c             | 188 +++++++++++++++++++++++---------
>  9 files changed, 220 insertions(+), 103 deletions(-)
>
> --
> 2.33.0.rc2.250.ged5fa647cd-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
