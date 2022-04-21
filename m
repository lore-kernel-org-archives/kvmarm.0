Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA3CC35274
	for <kvmarm@archiver.kernel.org>; Thu, 21 Apr 2022 16:46:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B2CA49EE3;
	Thu, 21 Apr 2022 12:46:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y3N4z90FM3FU; Thu, 21 Apr 2022 12:46:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BAED4B268;
	Thu, 21 Apr 2022 12:46:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DA9149EE3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:46:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AvahFHSdNLL9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2022 12:46:39 -0400 (EDT)
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com
 [209.85.166.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B99549F22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:46:39 -0400 (EDT)
Received: by mail-il1-f180.google.com with SMTP id r17so3415721iln.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 09:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ckFrAKsgzMvhyYwd1DVzzN/3nS9H6cXtvsMtyZqX9aM=;
 b=GGnQsYCBc7m0sb4hHXxmKxyVDlaKtiaUHTSkrcsRbKdnF/OLl9BH9pkaG8KmPePwAH
 GFnZvAnXZTNxNDVxKvJkJmlFGbDhiP+zy8Z3LECciut3GiViyDXLAAuyDjhcvgvCHd95
 9RZno8WXANvk1HA27qMQsBhii5EMRryAqFjMHiA6jQZ89AnnpaarP0duHppYZ+nG5SZv
 c66Bk7ryt53J/3iOloBULhibsniEkSISPrkGaQYvqiUq2fcHGaw89VI+6Wveqzv+9dxy
 ZR/Jw0K3SrcDXPSnc73yUsx4FXiPdd6DMCbMoeCWI5y1g2cc4geCxc1qUCY15L7+5TuW
 3xfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ckFrAKsgzMvhyYwd1DVzzN/3nS9H6cXtvsMtyZqX9aM=;
 b=xxdXICmdgO+IkvHlMGedTcZC1nITFOy9Wjcxg2GCB174L56wE4ERe2bJmh+KYZHWQF
 RqqoL+NML+eGK4+vig/MDT72GWdS8PwYDYMlJi2adz7KZSRzSRwub0ATtnRt6ifYuZ3g
 m/z9uy3w9dtbPozOwAwPZxPu/flRl3INT8PVZ2P79dV2tjCN1o/rcsHjMuSZw5OQMbxQ
 LT++g2tmSvkb4cM9FVFWP/UsDsr+Duf0CRxWt4ii/76jEAPEpGSMee6jnVR0VU/N8NFO
 ZSJ6OsEd1m7AE1KB0PpAr3t/kRiyOKs10MBg7d++u9zs6tPw547IGWXIbXdcx3qXwbT/
 Anug==
X-Gm-Message-State: AOAM531mC+3daKaYGCkdHOM0cFmP529IRssG3uEId0Kh92R/CKVBK2im
 QJdaAE69AlVuYt75yWZLkwQsNw==
X-Google-Smtp-Source: ABdhPJxWbQuijQVv7g9clCzQllXZaGyUynAlG+W8mud7Ir6TVd5bJHybLM8Rf2hpLE1AQFIvqx0Uow==
X-Received: by 2002:a05:6e02:1d83:b0:2cc:1dbc:7c34 with SMTP id
 h3-20020a056e021d8300b002cc1dbc7c34mr285019ila.315.1650559598456; 
 Thu, 21 Apr 2022 09:46:38 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 p6-20020a0566022b0600b0064c59797e67sm15044931iov.46.2022.04.21.09.46.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 21 Apr 2022 09:46:37 -0700 (PDT)
Date: Thu, 21 Apr 2022 16:46:34 +0000
From: Oliver Upton <oupton@google.com>
To: Ben Gardon <bgardon@google.com>
Subject: Re: [RFC PATCH 16/17] KVM: arm64: Enable parallel stage 2 MMU faults
Message-ID: <YmGKaoStt9Lf9xOP@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-17-oupton@google.com>
 <CANgfPd9bb213hsdKTMW9K0EsVLuKEKCF8V0pb6xM1qfnRj1qfw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANgfPd9bb213hsdKTMW9K0EsVLuKEKCF8V0pb6xM1qfnRj1qfw@mail.gmail.com>
Cc: kvm <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel@lists.infradead.org
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

On Thu, Apr 21, 2022 at 09:35:27AM -0700, Ben Gardon wrote:
> On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
> >
> > Voila! Since the map walkers are able to work in parallel there is no
> > need to take the write lock on a stage 2 memory abort. Relax locking
> > on map operations and cross fingers we got it right.
> 
> Might be worth a healthy sprinkle of lockdep on the functions taking
> "shared" as an argument, just to make sure the wrong value isn't going
> down a callstack you didn't expect.

If we're going to go this route we might need to just punch a pointer
to the vCPU through to the stage 2 table walker. All of this plumbing is
built around the idea that there are multiple tables to manage and
needn't be in the context of a vCPU/VM, which is why I went the WARN()
route instead of better lockdep assertions.

> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 21 +++------------------
> >  1 file changed, 3 insertions(+), 18 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 63cf18cdb978..2881051c3743 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1127,7 +1127,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >         gfn_t gfn;
> >         kvm_pfn_t pfn;
> >         bool logging_active = memslot_is_logging(memslot);
> > -       bool use_read_lock = false;
> >         unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
> >         unsigned long vma_pagesize, fault_granule;
> >         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > @@ -1162,8 +1161,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >         if (logging_active) {
> >                 force_pte = true;
> >                 vma_shift = PAGE_SHIFT;
> > -               use_read_lock = (fault_status == FSC_PERM && write_fault &&
> > -                                fault_granule == PAGE_SIZE);
> >         } else {
> >                 vma_shift = get_vma_page_shift(vma, hva);
> >         }
> > @@ -1267,15 +1264,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >         if (exec_fault && device)
> >                 return -ENOEXEC;
> >
> > -       /*
> > -        * To reduce MMU contentions and enhance concurrency during dirty
> > -        * logging dirty logging, only acquire read lock for permission
> > -        * relaxation.
> > -        */
> > -       if (use_read_lock)
> > -               read_lock(&kvm->mmu_lock);
> > -       else
> > -               write_lock(&kvm->mmu_lock);
> > +       read_lock(&kvm->mmu_lock);
> > +
> 
> Ugh, I which we could get rid of the analogous ugly block on x86.

Maybe we could fold it in to a MMU macro in the arch-generic scope?
Conditional locking is smelly, I was very pleased to delete these lines :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
