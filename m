Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8661C43334
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jun 2022 13:59:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D59E49ED8;
	Wed, 22 Jun 2022 09:59:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JSqf6Y271bqW; Wed, 22 Jun 2022 09:59:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 342504B4E1;
	Wed, 22 Jun 2022 09:59:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BA7F4B278
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 13:07:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wST7XaIZUWcQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jun 2022 13:07:19 -0400 (EDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com
 [209.85.208.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF9CA4B25D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 13:07:18 -0400 (EDT)
Received: by mail-lj1-f170.google.com with SMTP id o23so9075839ljg.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 10:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=FnOmw3gVk8tU+AE3cNeQjrjRVGb6taWwsuCOIfWCWxA=;
 b=YXKgy8GzJNpXWgsQ+ad6BrqIukKRln0aMHUpAz3ufqwzfs7i7BGubSSuGze4kyE/wN
 0vyoLZwVca0S2XXVcnvAoER6/ZyF44XgJGUi2tzkE2Xe6npHx30ng7Nr5M7fVo16rgk6
 gjIk5DT1zN/pCNT4kwvyq45YRaR5nZ4/Z59ys9rxb1ZKpiyk06/x/sR1xuyYtFmWpk9V
 Ln78wPfGHhHjaW3LDgPfga0c9htn6Ss8nTnj4aodGmeaoQlI3MWpLz42Y4dpS1D9jwQa
 8oKLu/8Fbg6PRfmjj8qzJUo/xsWDGvV5XIV+kyqzRt7lTYz85g2gYnvH4P5+ecQiZWN2
 H39Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=FnOmw3gVk8tU+AE3cNeQjrjRVGb6taWwsuCOIfWCWxA=;
 b=aFoyioxclnzy+xcookyLQFXIgGl1cjnxCA6eDmLaG6XYIMGzqU7P5UypqWTp1DTDKl
 PAF0K1D9YQv3pOT9ewcXT5wr/s5uJ2EpRjbIebrCsG0Mi9o6OVvkfYEMFUdqVFYOghGp
 gTV1niJW2zaivWrCUgx9MFG5H0dbm512QjLjq+qG6ml70QapWSZO14LsQlI6/3SEyAEd
 un5sM2v+OwwoZd3IF1wa1lGURJpRns7m4xGAmvjdmjwSkWkGm7dx04wQxpPUy0GgU5oJ
 UGN2FJi8WMB70qczzYOC8gXNCT5kSqC2oN1Jytn1eRGcmGHPa4enCb2O4cXp5zqG2Sf9
 681w==
X-Gm-Message-State: AJIora8M8pk1lKV/xIu66I1+esJx1n6rGP4h+0Rg3YrlIwHY0jzdB6MH
 ye3G18ECBAP54+jBA1JiHOieecOLhIPoc1LAbVntgQ==
X-Google-Smtp-Source: AGRyM1vsnNiJzYI8a4JothArzJ6EPJeG8wTiRAa2dkNSnIZYaQB/MuJ0ERB2pxoUlEJx6kKfxtszHOI0qWmk6ygmp0w=
X-Received: by 2002:a05:651c:886:b0:258:df66:5040 with SMTP id
 d6-20020a05651c088600b00258df665040mr15428117ljq.16.1655831237279; Tue, 21
 Jun 2022 10:07:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-11-dmatlack@google.com>
 <YqyXYJsoZGgp7l62@google.com>
In-Reply-To: <YqyXYJsoZGgp7l62@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 21 Jun 2022 10:06:50 -0700
Message-ID: <CALzav=fVzX+GXCdKRwRGofAgKatX206_kBKagT7R-eYO9RnYkA@mail.gmail.com>
Subject: Re: [PATCH v6 10/22] KVM: x86/mmu: Pass memory caches to allocate SPs
 separately
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Wed, 22 Jun 2022 09:59:03 -0400
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Fri, Jun 17, 2022 at 8:02 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, May 16, 2022, David Matlack wrote:
> > Refactor kvm_mmu_alloc_shadow_page() to receive the caches from which it
> > will allocate the various pieces of memory for shadow pages as a
> > parameter, rather than deriving them from the vcpu pointer. This will be
> > useful in a future commit where shadow pages are allocated during VM
> > ioctls for eager page splitting, and thus will use a different set of
> > caches.
> >
> > Preemptively pull the caches out all the way to
> > kvm_mmu_get_shadow_page() since eager page splitting will not be calling
>
> Uber nit, "eager hugepage splitting" to provide a mental cue/reminder for why
> those pages are direct.

I think it may be too late to move away from the term "eager page
splitting" (it is already in commit messages and the module param is
called "eager_page_split"). Using a slightly different name here might
produce more confusion, or at least cause readers to do a double-take.

But naming aside, I don't follow what you mean here. i.e. What does
the fact that page splitting uses direct shadow pages have to do with
this patch?


>
> > kvm_mmu_alloc_shadow_page() directly.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
