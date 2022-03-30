Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129D9C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 30 Mar 2022 14:25:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 788BC4B1FC;
	Wed, 30 Mar 2022 10:25:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YzI7nhuksjtL; Wed, 30 Mar 2022 10:25:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A1B14B14C;
	Wed, 30 Mar 2022 10:25:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D59CC4B0F7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2022 10:25:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K3KtpEkzNXsB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Mar 2022 10:25:54 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 857734B0EF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2022 10:25:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1648650354;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=zvLJ8hpn4uLcUl3yh6ObtYr+cK026HnJjPhO9peO7nY=;
 b=FvBufFmGwYrPHrWsfiSDhcVGYVUUJMRxKvu/gewthwFfrfNwqk4rkTMqkixfU+SaL7gyZe
 ZOcVRTzfpcgLnteUV2/f6Uo/g1A6oPWZQEq7IrUbmF6Kz9vgU6F1EDoEwCxXM6fTjtLdGv
 A3Wd/bHHDXgUp+CV+awx4fZORqBFIY0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-w6iACVSdO7GRwkfX_m2SOg-1; Wed, 30 Mar 2022 10:25:52 -0400
X-MC-Unique: w6iACVSdO7GRwkfX_m2SOg-1
Received: by mail-qt1-f198.google.com with SMTP id
 u8-20020ac858c8000000b002e1b3ceb167so17515723qta.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2022 07:25:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=zvLJ8hpn4uLcUl3yh6ObtYr+cK026HnJjPhO9peO7nY=;
 b=j5VRSwtVV7bYaMeVLI50IZUenQ6m2AE7tcbLPcVimgZhNSvkV3Mlz1YEUynDVeU3aV
 oTIsINWa4sUo+oL7GG+vOl27T8Ks01ZNvf8qOCZH7tpRF+dgP6aIiBdASQhfjGKHsajV
 BA2+2dUSdL6zUQTEfD55i+BrRiUgD8blqEzmhJRNhCUmoFBPstJW2Kh1XjIPrM/cssJq
 wvWopLjf46Q7ynYSWe38EEBnoP3d6pV1LEaxUvZXtr2GtgDej1JooTE7d6uJQCoAgWw0
 pyfV3tF3WC7CcZlEHnOuFZsx9BVsDZXGNoI/w5mY1X5E86jCbD/UddHvKI/vKKh7DyUQ
 o9DA==
X-Gm-Message-State: AOAM530kPV2MjnGVIAysOwt6nGz1EtcayYJYpD6o3x+t3bNGr6a7vBQI
 /TOxpoGR7WfaJSLb86D9twVAXpN75FQqMmG7+34zvH38sh8W/ID3wHX7OgA/YRlziZSsU5TNs+v
 JURa9/osksCcn3G4oypySUo2p
X-Received: by 2002:a05:620a:d8b:b0:67b:1371:1796 with SMTP id
 q11-20020a05620a0d8b00b0067b13711796mr23958849qkl.415.1648650351531; 
 Wed, 30 Mar 2022 07:25:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/r6U4mfqyrEs1oP/UnFbQv8EJ+XyurLMqYNaOVonYcHLEFbhhLYUdoEZC2YnVcD0Y5xCzUQ==
X-Received: by 2002:a05:620a:d8b:b0:67b:1371:1796 with SMTP id
 q11-20020a05620a0d8b00b0067b13711796mr23958817qkl.415.1648650351226; 
 Wed, 30 Mar 2022 07:25:51 -0700 (PDT)
Received: from xz-m1.local
 (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
 by smtp.gmail.com with ESMTPSA id
 f34-20020a05622a1a2200b002e1a35ed1desm18226730qtb.94.2022.03.30.07.25.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 30 Mar 2022 07:25:50 -0700 (PDT)
Date: Wed, 30 Mar 2022 10:25:49 -0400
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 03/26] KVM: x86/mmu: Derive shadow MMU page role from
 parent
Message-ID: <YkRobUbpk1bM2zBQ@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-4-dmatlack@google.com>
 <YjBLFZWtdfwhNosG@xz-m1.local>
 <CALzav=dAW999FKid08Ry0YxPA+3Dt8HERrbn6YMkAnk0h+4h_A@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALzav=dAW999FKid08Ry0YxPA+3Dt8HERrbn6YMkAnk0h+4h_A@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=peterx@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
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

On Tue, Mar 22, 2022 at 11:30:07AM -0700, David Matlack wrote:
> > > +static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
> > > +{
> > > +     struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
> > > +     union kvm_mmu_page_role role;
> > > +
> > > +     role = parent_sp->role;
> > > +     role.level--;
> > > +     role.access = access;
> > > +     role.direct = direct;
> > > +
> > > +     /*
> > > +      * If the guest has 4-byte PTEs then that means it's using 32-bit,
> > > +      * 2-level, non-PAE paging. KVM shadows such guests using 4 PAE page
> > > +      * directories, each mapping 1/4 of the guest's linear address space
> > > +      * (1GiB). The shadow pages for those 4 page directories are
> > > +      * pre-allocated and assigned a separate quadrant in their role.
> > > +      *
> > > +      * Since we are allocating a child shadow page and there are only 2
> > > +      * levels, this must be a PG_LEVEL_4K shadow page. Here the quadrant
> > > +      * will either be 0 or 1 because it maps 1/2 of the address space mapped
> > > +      * by the guest's PG_LEVEL_4K page table (or 4MiB huge page) that it
> > > +      * is shadowing. In this case, the quadrant can be derived by the index
> > > +      * of the SPTE that points to the new child shadow page in the page
> > > +      * directory (parent_sp). Specifically, every 2 SPTEs in parent_sp
> > > +      * shadow one half of a guest's page table (or 4MiB huge page) so the
> > > +      * quadrant is just the parity of the index of the SPTE.
> > > +      */
> > > +     if (role.has_4_byte_gpte) {
> > > +             BUG_ON(role.level != PG_LEVEL_4K);
> > > +             role.quadrant = (sptep - parent_sp->spt) % 2;
> > > +     }
> >
> > This made me wonder whether role.quadrant can be dropped, because it seems
> > it can be calculated out of the box with has_4_byte_gpte, level and spte
> > offset.  I could have missed something, though..
> 
> I think you're right that we could compute it on-the-fly. But it'd be
> non-trivial to remove since it's currently used to ensure the sp->role
> and sp->gfn uniquely identifies each shadow page (e.g. when checking
> for collisions in the mmu_page_hash).

Makes sense.

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
