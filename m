Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B7FFC43334
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jun 2022 17:59:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAAC84B21A;
	Tue, 21 Jun 2022 13:59:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I9xsjmb9T5yY; Tue, 21 Jun 2022 13:59:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B19234B297;
	Tue, 21 Jun 2022 13:59:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43F444B282
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 13:59:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j+JvsJSm26hT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jun 2022 13:59:12 -0400 (EDT)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
 [209.85.215.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 270584B21A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 13:59:12 -0400 (EDT)
Received: by mail-pg1-f173.google.com with SMTP id s185so8060580pgs.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 10:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=JbuWAytcUZALQjKHnKlHD39QZVXy3a1bRzVkWDq42KQ=;
 b=VErgQoB8GWymThL3YgzGl2WrL12ULYe/Cx/wyQRAW01d1/41ggxbQwxVOnzuwICFhG
 hlA/lrHAMM3uUbioCGYIMB10kT5kJRIxBeHBxMtKnqe8TOc1UA6q8/qtaiFqCan3/IJX
 zbld0o+9fIhscaxiitkhFrgx3xF2+mm+jDKQcXlVY6HSgbY1WNrPJinLucleTCE+gUAp
 ZzKcF99tELyFLUKjMPVKMvpACZbdJEki9ptdeMGLcmOKYAiaI8j87t1CGi/1EX4C73n/
 er1cQQAVMrZvwmWyBge9+Hybfl4bxzFWz1KNBdnXAQ8WoAaTDtPiczPKVjpEk59p0pZZ
 80Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=JbuWAytcUZALQjKHnKlHD39QZVXy3a1bRzVkWDq42KQ=;
 b=DuuQcrGYulYTC3UWQ+QtKe7jVSh+XP8eC4Y8irDtVTDlsOjRKh0cG6z4bBfKiUuUNh
 m4ERF8QgFvF+4iWcpVkGvuzNvMkdR4miNtYkovrUNo2a7wkVk1EJ5qaK555Ey6uh7R3j
 64ONvTKe3vzTlIPgs3YbG9BU9IZ9rpPxuC8tPup0MAaTxxbiXzdJQVm9kLoPTbpI+VD6
 80qKHibWIPVKHYGnbW1rtQviZt3QBv1reEu8iGei7nuLHqX5kYPJ2L7eZPNdlSs0Z3UT
 tK/hp9o0oq8Fw7huWzbL1TByDH1PO+2tcRLuqNCyMrlNAwxJd80FXMpsR1ldtgF0X5aR
 4aAA==
X-Gm-Message-State: AJIora/XyHjxwPsnqD4ANRxcgeh6XaXTiQeOIpw+IcbXs7WkupK6Yq17
 mwsnxBU3TEl822cgxK/UGe2z/w==
X-Google-Smtp-Source: AGRyM1tyKoScvgZ9jUTl9r400vYVAKVYV/qzOYeNUaiQG+sTZs1pyelcoub/qTYVZzhpTV2f2gXgXw==
X-Received: by 2002:a63:e705:0:b0:3fd:fb59:bd7f with SMTP id
 b5-20020a63e705000000b003fdfb59bd7fmr27065817pgi.505.1655834350902; 
 Tue, 21 Jun 2022 10:59:10 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 jj4-20020a170903048400b001678898ad06sm5027806plb.47.2022.06.21.10.59.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 21 Jun 2022 10:59:10 -0700 (PDT)
Date: Tue, 21 Jun 2022 17:59:07 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v6 19/22] KVM: x86/mmu: Zap collapsible SPTEs in shadow
 MMU at all possible levels
Message-ID: <YrIG6/dymlPQGwg1@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-20-dmatlack@google.com>
 <Yqyzavjp9eS9p4+m@google.com>
 <CALzav=dG9f2X8GBLjQgR-Lj4yPKX2Adg3C+9_9aC83A7mzmbtw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALzav=dG9f2X8GBLjQgR-Lj4yPKX2Adg3C+9_9aC83A7mzmbtw@mail.gmail.com>
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

On Tue, Jun 21, 2022, David Matlack wrote:
> On Fri, Jun 17, 2022 at 10:01 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, May 16, 2022, David Matlack wrote:
> > > +static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
> > > +                                        const struct kvm_memory_slot *slot)
> > > +{
> > > +     /*
> > > +      * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
> > > +      * pages that are already mapped at the maximum possible level.
> > > +      */
> > > +     if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
> > > +                           PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1,
> > > +                           true))
> >
> > No need to wrap, "true" fits easily on the previous line.  That said, I don't see
> > any point in adding a helper.  It's highly unlike there will be another caller,
> > and IMO it's not any more readable since I have to go look at another function
> > when reading kvm_mmu_zap_collapsible_sptes().
> 
> I could see an argument for readability either way. Putting it in a
> helper function abstracts away the details, which would aid
> readability if the reader does not care about the implementation
> details of the rmap case.

I'm ok either way, dealer's choice.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
