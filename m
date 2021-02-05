Return-Path: <SRS0=/Ra0=HH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D44C433E6
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 09:26:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B524964FBE
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 09:26:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B524964FBE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37F8C4B3B9;
	Fri,  5 Feb 2021 04:26:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y7SA0J9T5klV; Fri,  5 Feb 2021 04:26:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E46294B38F;
	Fri,  5 Feb 2021 04:26:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9264F4B309
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 00:58:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0bMegk3tEyjZ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2021 00:58:50 -0500 (EST)
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com
 [209.85.222.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 58CE94B2C8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 00:58:50 -0500 (EST)
Received: by mail-qk1-f180.google.com with SMTP id u20so5886996qku.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Feb 2021 21:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=SZ0GQLJipF2hQIt0oYg/b3YND75QYohdSOPgCgGvmtI=;
 b=oPGsTQx7+FdG6LRGl1TD3o+RbriHfudMdPEUWdoVcGtiFVzJyADmDY4/qjjG1+UIcy
 wjKL99cqQfoIL+mWKhEojF7j3xy7b/FwNrgzFcnaC4VE2BI5tBDFbEYcfnximoQpd7Bo
 foetOy+pvkseCt44S1+fCOI+yg3iGoGzvmkUU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=SZ0GQLJipF2hQIt0oYg/b3YND75QYohdSOPgCgGvmtI=;
 b=QA0qJ3a9sOcjZLdDyhykimHdHLXeDastX7xU4T41GjjJNPniE9awu/33myfq3DKI+b
 PEyTsOlR+kRKDLbib/VWnsGZkBQpzll2KA/tr18P66W8ySyk6IrMrKmNx833EFYBi832
 tqQOW0K4kjMoV4BvK3oTpoZRQE39W7zK3UExuV1v0Nk2/hn0B3QNv9md8mbGEAZCHB43
 VdKK5mp+x+8lvnyLnEGm415OqwzbU0+XDLqhTCtEz+MF3UFR2tDhCsxjfuL8ldZzsyaA
 tkeKfFCmXi5uMB5xBd183tROyMLC1HnGJxsUp9iEmWQ7bs9t8rTDYY3R7D3B7ymZvqtu
 dNzQ==
X-Gm-Message-State: AOAM531vNKiAUe5+WUKK+Sc0CRkbAXpVSFTtuLV/NOlhjHK8obxInHGw
 IZRwe780VdxAF5n2P1hCkxuQdCdLL5x8iRP0EfZrHQ==
X-Google-Smtp-Source: ABdhPJwYA73lftjBriOP+37YGUdH+MFOawlYakwpkyiHcFfBQsl9Chfbewfaer8b9y41czh2lCGjkNZ6cshLgPPsL0I=
X-Received: by 2002:a37:73c3:: with SMTP id o186mr2728785qkc.194.1612504730031; 
 Thu, 04 Feb 2021 21:58:50 -0800 (PST)
MIME-Version: 1.0
References: <20210128060515.1732758-1-stevensd@google.com>
 <c01b01dc-c636-1d1b-fb42-df718e23d20a@redhat.com>
In-Reply-To: <c01b01dc-c636-1d1b-fb42-df718e23d20a@redhat.com>
From: David Stevens <stevensd@chromium.org>
Date: Fri, 5 Feb 2021 14:58:38 +0900
Message-ID: <CAD=HUj5sKKnckSqBjjR8paGegLfSujk03C5uDwzfh=PAaj5BZA@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] KVM: x86/mmu: Skip mmu_notifier changes when
 possible
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 05 Feb 2021 04:26:13 -0500
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, David Stevens <stevensd@google.com>,
 linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 open list <linux-kernel@vger.kernel.org>,
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

These patches might be responsible for some instability in one of our
stress tests. I'll send an update once I figure out what's going on.

Thanks,
David

On Thu, Jan 28, 2021 at 9:48 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 28/01/21 07:05, David Stevens wrote:
> > These patches reduce how often mmu_notifier updates block guest page
> > faults. The primary benefit of this is the reduction in the likelihood
> > of extreme latency when handling a page fault due to another thread
> > having been preempted while modifying host virtual addresses.
> >
> > v2 -> v3:
> >   - Added patch to skip check for MMIO page faults
> >   - Style changes
> >
> > David Stevens (1):
> >    KVM: x86/mmu: Consider the hva in mmu_notifier retry
> >
> > Sean Christopherson (1):
> >    KVM: x86/mmu: Skip mmu_notifier check when handling MMIO page fault
> >
> >   arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
> >   arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
> >   arch/x86/kvm/mmu/mmu.c                 | 16 ++++++++------
> >   arch/x86/kvm/mmu/paging_tmpl.h         |  7 ++++---
> >   include/linux/kvm_host.h               | 25 +++++++++++++++++++++-
> >   virt/kvm/kvm_main.c                    | 29 ++++++++++++++++++++++----
> >   6 files changed, 65 insertions(+), 16 deletions(-)
> >
>
> Queued, thanks.
>
> Paolo
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
