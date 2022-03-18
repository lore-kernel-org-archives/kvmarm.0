Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B98FC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 18 Mar 2022 20:33:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A1BD49EE7;
	Fri, 18 Mar 2022 16:33:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d47UxeQSTqJD; Fri, 18 Mar 2022 16:33:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED58049E22;
	Fri, 18 Mar 2022 16:33:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43B5641021
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 16:33:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id orbhEcJ5v2R8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Mar 2022 16:33:16 -0400 (EDT)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
 [209.85.214.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1502040FD8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 16:33:16 -0400 (EDT)
Received: by mail-pl1-f175.google.com with SMTP id w4so7880331ply.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 13:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=zNTmz5JVOVEGqxQfmkKH5ofnXJ8F9rxSfSnMnrjnpm4=;
 b=sDKjHCF2YiI5RwzthUN4Q7iTrVDi6S27oXMB5v1GCnRgY4pF3/LESD7rdMsfp+HoMJ
 GcgJtKyNHn10/X0NoKBpytT+QFyjWhf+BayR5vL6RUrXog/5/yo3l4VkZcFzbyU32Guc
 i6BepxBRjypw0vzPAAGj/rzm7VBEYYKCRAyqPUNw9UsLK6pFvIp/AschAojYD7ZCeIon
 Tby9YcnCwg+B/BKGcTK2yT2aNqWkGJWSmDGzksKoTeDyk8CKEQFFvoIxpkQp6F5x+v7E
 2vWyg+PgbTQtHl2PLOl3rjXgJAxttPyoL6Ka5r17rOwTE7vqatCKXzidY9tM7PFNRHJU
 93/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=zNTmz5JVOVEGqxQfmkKH5ofnXJ8F9rxSfSnMnrjnpm4=;
 b=CEl3GhB5QBQPi3yROlAsaQ5wKJ4ReZw/1QNolmIQOJKz961XUQNtcWjH9c+NGaWyyj
 SEt/+sg15FcVLJQh//PQGL49zhb3SOWYgl3E6u3QQPMWId8sL/+jMrvEGaj0aKlbTqav
 79jxs+SnRZhetunrfCDffxAGA6RofD7dzrwTwTVXRCq1HUZajtWBN3kBmhInpDdwNmrU
 hQsC+hP4/cf99DhGztMocuNb1u/WXY7hyjCeXzaOL8QxyGiGUEBMp7MYs1gDohGk/pbr
 yVyoySNwebp79tbpLCPI2aU/XRTpXMdNE+kGw/TzkL3cN1YG2D5SmTr/MFoQbC2C7Xqv
 ToYA==
X-Gm-Message-State: AOAM530lYTR89XqgadHsy1f0ZR4d6vvt8tesncFr3py9ePWCmI0/jqFX
 Ly+gxUBtJ1z4CDxshIkztbYaxR+3mc6ZJg==
X-Google-Smtp-Source: ABdhPJxtJX0OLWnA5Jkz12Gg7fL+PabeAp7W7uiK4hS5tDluCNTLaEa1So9I9jDCC1UmOFv4zjOA5w==
X-Received: by 2002:a17:90a:19d5:b0:1bc:a5db:b655 with SMTP id
 21-20020a17090a19d500b001bca5dbb655mr23906080pjj.46.1647635594843; 
 Fri, 18 Mar 2022 13:33:14 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 d5-20020a17090acd0500b001b9c05b075dsm12829958pju.44.2022.03.18.13.33.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 18 Mar 2022 13:33:14 -0700 (PDT)
Date: Fri, 18 Mar 2022 13:33:10 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 04/11] KVM: selftests: Add vm_alloc_page_table_in_memslot
 library function
Message-ID: <YjTshgT6ByCPEubc@google.com>
References: <20220311060207.2438667-1-ricarkol@google.com>
 <20220311060207.2438667-5-ricarkol@google.com>
 <CANgfPd8u_K3cOpaUPY8+rU+4RFehj8J61gdzuDyOZv4dSDZ+xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANgfPd8u_K3cOpaUPY8+rU+4RFehj8J61gdzuDyOZv4dSDZ+xQ@mail.gmail.com>
Cc: kvm <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>,
 kvmarm@lists.cs.columbia.edu
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

On Wed, Mar 16, 2022 at 12:07:21PM -0600, Ben Gardon wrote:
> On Fri, Mar 11, 2022 at 12:02 AM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Add a library function to allocate a page-table physical page in a
> > particular memslot.  The default behavior is to create new page-table
> > pages in memslot 0.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> 
> This is very similar to one of the patches in the NX hugepages control
> series I sent out last week, I guess we both had similar needs at the
> same time.
> Your solution introduces way less churn though, so it's probably
> better. I might use this commit or wait for it to be merged before I
> send out v2 of my NX control series.

Both options sound good to me. I'm glad it helps.

> 
> In any case,
> Reviewed-by: Ben Gardon <bgardon@google.com>
> 
> > ---
> >  tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
> >  tools/testing/selftests/kvm/lib/kvm_util.c          | 8 +++++++-
> >  2 files changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index d6acec0858c0..c8dce12a9a52 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -307,6 +307,7 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
> >  vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> >                               vm_paddr_t paddr_min, uint32_t memslot);
> >  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
> > +vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot);
> >
> >  /*
> >   * Create a VM with reasonable defaults
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 64ef245b73de..ae21564241c8 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -2409,9 +2409,15 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
> >  /* Arbitrary minimum physical address used for virtual translation tables. */
> >  #define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
> >
> > +vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot)
> > +{
> > +       return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> > +                       pt_memslot);
> > +}
> > +
> >  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
> >  {
> > -       return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
> > +       return vm_alloc_page_table_in_memslot(vm, 0);
> >  }
> >
> >  /*
> > --
> > 2.35.1.723.g4982287a31-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
