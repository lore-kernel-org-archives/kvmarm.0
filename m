Return-Path: <SRS0=Tw+U=OS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED175C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 17:40:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 68B1C61352
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 17:40:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 68B1C61352
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD8794A534;
	Tue, 28 Sep 2021 13:40:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fxQN0FvWADQ7; Tue, 28 Sep 2021 13:40:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 623B34B0C3;
	Tue, 28 Sep 2021 13:40:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B11D4B0C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 13:40:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5NXc4IX89jRW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 13:40:37 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F32BA40C88
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 13:40:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632850836;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=i/mLExJpGEltWuxQX4FZe3M+4GoSDCEzgPhBEr5FMEA=;
 b=eDKUMRN6BkhN+Eve4uu+X6/Wjg2AAbS1BrpkZA2hqlmxdUHBKA09wDjy/TN7CZGQ3lp6bd
 UYhF0b9Rw79j+HKbs7T2Y84l+Q71TY3GB+ekNy9cwvFShgmTWzDUPJY9BuBeJEhdihmpvz
 M+ruup6NTszz9tcw9eU4tAZIyj4jI20=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-69AtRzdzMOSc_HG_XuOsKw-1; Tue, 28 Sep 2021 13:40:35 -0400
X-MC-Unique: 69AtRzdzMOSc_HG_XuOsKw-1
Received: by mail-ed1-f71.google.com with SMTP id
 o23-20020a509b17000000b003da756cac0eso7710863edi.22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 10:40:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=i/mLExJpGEltWuxQX4FZe3M+4GoSDCEzgPhBEr5FMEA=;
 b=Ra+dyFEL0PHaf6VQMZTWG5I6iJNXetiWx89P2IPfbOP6SGrPsksiS6wLmTVs8nSzTX
 CIcv5z8/e2wgKzow7bFnLIJtMgxntiPmh1W+CaPQP2w7jIX6d3on3449rcvCtXEUIzi7
 G1yVnnhQdbpR47O/tj46OY1eNsjWeEYLWiuhpO2yfnzBpGlWXvtCCMigdB60SiHfQ71N
 QopEqI9uO3OqE1IZSvERQzPAJGKUTME2UuS+DuPSkEgheGOj2vLk7B1yPmIBbjDHlX36
 kwLK6cIW9/4pSv7EAqiAxLOLlUXaUxA0UZepT9iXAw+pIH8faY8jdptRBugWVvTF1pPZ
 yepQ==
X-Gm-Message-State: AOAM530zRLzQH7xwgDANlWD5+dyp6rYs68YiERmpOEwFDOJQJW9yMw6m
 6TxU8hDQVjMEInEpv6HsXci+H8KXFN3aKh7LbfPsl4kp/I05o8Y8reVHKEuQOgl9ro1ctmjyDTb
 F4Rn7GwvPXdtcLRbz19RBCSp1
X-Received: by 2002:a05:6402:54d:: with SMTP id
 i13mr9049825edx.389.1632850833768; 
 Tue, 28 Sep 2021 10:40:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1uRsUYkFrmzr9SFSboTh9F3ISbwn7GohEYiy/YAAhZwF2yzR3R6MUzDSzYRWA2nhcLdM6ag==
X-Received: by 2002:a05:6402:54d:: with SMTP id
 i13mr9049801edx.389.1632850833583; 
 Tue, 28 Sep 2021 10:40:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id y3sm13952710eda.9.2021.09.28.10.40.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 28 Sep 2021 10:40:32 -0700 (PDT)
Message-ID: <c3db653e-4ea2-3e99-aed6-c6e8a76e2ece@redhat.com>
Date: Tue, 28 Sep 2021 19:40:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 0/4] KVM: allow mapping non-refcounted pages
To: David Stevens <stevensd@chromium.org>, Marc Zyngier <maz@kernel.org>
References: <20210825025009.2081060-1-stevensd@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210825025009.2081060-1-stevensd@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 25/08/21 04:50, David Stevens wrote:
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
>   - rebase on kvm next branch

Hi David,

this needs a rebase.  I have pushed my current queue, but note that 
parts of it are still untested.

A bigger question here is the gfn_to_pfn caches and how to properly 
invalidate them.  However your patch doesn't make things worse (only a 
bit inconsistent because pointing certain MSRs to a VM_PFNMAP|VM_IO page 
can fail).

Paolo

> v1 -> v2:
>   - Introduce new gfn_to_pfn_page functions instead of modifying the
>     behavior of existing gfn_to_pfn functions, to make the change less
>     invasive.
>   - Drop changes to mmu_audit.c
>   - Include Nicholas Piggin's patch to avoid corrupting refcount in the
>     follow_pte case, and use it in depreciated gfn_to_pfn functions.
>   - Rebase on kvm/next
> 
> David Stevens (4):
>    KVM: mmu: introduce new gfn_to_pfn_page functions
>    KVM: x86/mmu: use gfn_to_pfn_page
>    KVM: arm64/mmu: use gfn_to_pfn_page
>    KVM: mmu: remove over-aggressive warnings
> 
>   arch/arm64/kvm/mmu.c            |  26 +++--
>   arch/x86/kvm/mmu/mmu.c          |  50 +++++----
>   arch/x86/kvm/mmu/mmu_internal.h |   3 +-
>   arch/x86/kvm/mmu/paging_tmpl.h  |  23 ++--
>   arch/x86/kvm/mmu/tdp_mmu.c      |   6 +-
>   arch/x86/kvm/mmu/tdp_mmu.h      |   4 +-
>   arch/x86/kvm/x86.c              |   6 +-
>   include/linux/kvm_host.h        |  17 +++
>   virt/kvm/kvm_main.c             | 188 +++++++++++++++++++++++---------
>   9 files changed, 220 insertions(+), 103 deletions(-)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
