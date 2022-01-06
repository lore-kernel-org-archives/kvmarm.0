Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13816C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 09:20:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B02F24B1AF;
	Thu,  6 Jan 2022 04:19:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WYsz+nEi1rGE; Thu,  6 Jan 2022 04:19:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 859734B1D2;
	Thu,  6 Jan 2022 04:19:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8C5C408D5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 21:42:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5GF2Q9LfOWa5 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 21:42:51 -0500 (EST)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com
 [209.85.219.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B8E1F408C1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 21:42:51 -0500 (EST)
Received: by mail-yb1-f180.google.com with SMTP id p15so3336622ybk.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 18:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=VUrh3Npgeap/8EiEtwRjncA+1oSJVR1QQxVGHBNvM04=;
 b=f6EQYO79bUXprc7mhn+5kkGk7QaNhdm6TSnLti6itS7mqSCQT6sQjiGOBku7WoX188
 vPdqu9VcHqayR/unWn8Q1ICELVnmKRotk6JQfhShEKTlwYXcQmP7i4wWQTx3chDRDI7A
 4kBgcl+GK+bigbshUapujhp4+UlbLV1/GOkiY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=VUrh3Npgeap/8EiEtwRjncA+1oSJVR1QQxVGHBNvM04=;
 b=6+qFiE6BeaaierM2+e95sRCWEbgSzDP5yR4jSpHy6G2PIlKTPgrTw+NzZo/2k+1dhJ
 ToNCWuH0WUiRfbuuOS5/qC6rnVmCK0VQAQHhuOnqkKBdr97eRyA2axblzwc6EFjvDNx0
 Ir/GoZrZ6Rox9fQGjzBH37n0N+XUM4vn6Trv4vLQmjuT/e+cnlWPLsenmlPeeVLNfbNg
 nrf3FYUkWqHd5lC81Yy1eEIVsHmJ0avF3RDhrro8S8vxEIhIkflXrg/0XKnahRy9BEl/
 3EzmQt2MYvm0YSEkQoNISxEk4W0KDOw3Iqyw+hEfnAmG0TnUiavsqnfB+wGr4Y+ESZax
 GlVw==
X-Gm-Message-State: AOAM530uMy0FeDjLCtw+AJSpVmS2COZgxnVoxP1q8Q6yPx0Pfu1qa/Io
 fQM0Pto5nxYhOoZJP1GPVwBC+ScwIspquFu8GEgGvg==
X-Google-Smtp-Source: ABdhPJySN8UQBiLK5ZELedz9aMDOihftjIfvLaugncGmaT2wHj67/GId/mm7KBCgharYeRmCbxfpR9IivB+Tgad8EI0=
X-Received: by 2002:a25:5ca:: with SMTP id 193mr64959101ybf.406.1641436971074; 
 Wed, 05 Jan 2022 18:42:51 -0800 (PST)
MIME-Version: 1.0
References: <20211129034317.2964790-1-stevensd@google.com>
 <20211129034317.2964790-5-stevensd@google.com>
 <Yc4G23rrSxS59br5@google.com>
 <CAD=HUj5Q6rW8UyxAXUa3o93T0LBqGQb7ScPj07kvuM3txHMMrQ@mail.gmail.com>
 <YdXrURHO/R82puD4@google.com> <YdXvUaBUvaRPsv6m@google.com>
In-Reply-To: <YdXvUaBUvaRPsv6m@google.com>
From: David Stevens <stevensd@chromium.org>
Date: Thu, 6 Jan 2022 11:42:39 +0900
Message-ID: <CAD=HUj736L5oxkzeL2JoPV8g1S6Rugy_TquW=PRt73YmFzP6Jw@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] KVM: mmu: remove over-aggressive warnings
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Thu, 06 Jan 2022 04:19:54 -0500
Cc: Chia-I Wu <olv@chromium.org>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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

On Thu, Jan 6, 2022 at 4:19 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Jan 05, 2022, Sean Christopherson wrote:
> > Ah, I got royally confused by ensure_pfn_ref()'s comment
> >
> >   * Certain IO or PFNMAP mappings can be backed with valid
> >   * struct pages, but be allocated without refcounting e.g.,
> >   * tail pages of non-compound higher order allocations, which
> >   * would then underflow the refcount when the caller does the
> >   * required put_page. Don't allow those pages here.
> >                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > that doesn't apply here because kvm_faultin_pfn() uses the low level
> > __gfn_to_pfn_page_memslot().
>
> On fifth thought, I think this is wrong and doomed to fail.  By mapping these pages
> into the guest, KVM is effectively saying it supports these pages.  But if the guest
> uses the corresponding gfns for an action that requires KVM to access the page,
> e.g. via kvm_vcpu_map(), ensure_pfn_ref() will reject the access and all sorts of
> bad things will happen to the guest.
>
> So, why not fully reject these types of pages?  If someone is relying on KVM to
> support these types of pages, then we'll fail fast and get a bug report letting us
> know we need to properly support these types of pages.  And if not, then we reduce
> KVM's complexity and I get to keep my precious WARN :-)

Our current use case here is virtio-gpu blob resources [1]. Blob
resources are useful because they avoid a guest shadow buffer and the
associated memcpys, and as I understand it they are also required for
virtualized vulkan.

One type of blob resources requires mapping dma-bufs allocated by the
host directly into the guest. This works on Intel platforms and the
ARM platforms I've tested. However, the amdgpu driver sometimes
allocates higher order, non-compound pages via ttm_pool_alloc_page.
These are the type of pages which KVM is currently rejecting. Is this
something that KVM can support?

+olv, who has done some of the blob resource work.

[1] https://patchwork.kernel.org/project/dri-devel/cover/20200814024000.2485-1-gurchetansingh@chromium.org/

-David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
