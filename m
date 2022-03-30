Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 533DDC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 30 Mar 2022 18:34:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A813049DED;
	Wed, 30 Mar 2022 14:34:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HGOLrHw0pm+f; Wed, 30 Mar 2022 14:34:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A54D49EB1;
	Wed, 30 Mar 2022 14:34:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72BAB49E49
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2022 14:34:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TRaN3jCMNbOH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Mar 2022 14:34:26 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCDF049DED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2022 14:34:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1648665265;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=BO423QJpHjYuJkP0ZfVrkV5p4JcZ6+8e4Hhk2wmOLQ4=;
 b=irXBaQGlWjn8xxvUtHFR1Nx1ZqBp5AO3u9OgTUkkmW7UeQgaMNZvhYdHcAve+QWmVTpugk
 VLgpjhD1JgBNdSAK+Qc35RNbnZIVQaKO/CUa5P4MAKYXu2fZQvqA+qbr8fQfKE8yhyRW6j
 sk6YS/Yx0A7PNpOmsmU262X30YSsuuw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-nNP6-NhaMEGCD_3hUv8XVw-1; Wed, 30 Mar 2022 14:34:24 -0400
X-MC-Unique: nNP6-NhaMEGCD_3hUv8XVw-1
Received: by mail-qv1-f71.google.com with SMTP id
 kj4-20020a056214528400b0044399a9bb4cso111770qvb.15
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2022 11:34:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=BO423QJpHjYuJkP0ZfVrkV5p4JcZ6+8e4Hhk2wmOLQ4=;
 b=2U7ny4zCAWbbDx9HVg8of/fL6ZZmNwGwxu2Gmu50zwiKCCkVLWAYtkCRNcPCZBwOWY
 3sg3QOysm7NLBAc3r56Mvivl7B3a/RGZ4HhYmD+4xc4jJq80pjuJPqebivZxdBp3TI67
 p/NptY/SCm5GMIYMEaVYgj4TJq43ge8Tvvhn3NH8uoKYboQRC8d4eIbRUzSzrUKPP6Qh
 ZLqMIFOqnuEjH9WjT9iBKb+g+e3GUiDW7bSL0i+lm8MkgcCnFmc7xDtfvBqg6XwG/szW
 Dv9jVZ24wZXdPIkwGWS6t7sjQGD9eAz9PdSI8uSx0/LfrnUAW7nwC2wZ2474rnvxdXwB
 Jr1g==
X-Gm-Message-State: AOAM531CDAwXjUHNSEKEyc2aMy+bWLJoqeSxonxdJEdQBHbBWt1zkqRR
 OWfjlE5wPEsKMLeCs4B6Q/HCMLrHrAOBsZ2Izzi3Y2AhDe+ryH8UNPZUiFt6ve5G5XEdE9d5+VH
 Lu6zTLQJxU9xPARtawJ1Uy4JB
X-Received: by 2002:a05:6214:52:b0:440:f824:a7f3 with SMTP id
 c18-20020a056214005200b00440f824a7f3mr680775qvr.125.1648665263566; 
 Wed, 30 Mar 2022 11:34:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpEYagEUKrFreUNZJWPbgOd2iyA4mWjJAcuNj/S06/ZmWXmhH8bpHqRFw8Cg5TxB9Aa+BVhQ==
X-Received: by 2002:a05:6214:52:b0:440:f824:a7f3 with SMTP id
 c18-20020a056214005200b00440f824a7f3mr680755qvr.125.1648665263302; 
 Wed, 30 Mar 2022 11:34:23 -0700 (PDT)
Received: from xz-m1.local
 (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
 by smtp.gmail.com with ESMTPSA id
 m14-20020a05622a054e00b002e2072cffe6sm17042300qtx.5.2022.03.30.11.34.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 30 Mar 2022 11:34:23 -0700 (PDT)
Date: Wed, 30 Mar 2022 14:34:21 -0400
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 20/26] KVM: x86/mmu: Extend Eager Page Splitting to
 the shadow MMU
Message-ID: <YkSirYT6s8YtUr4w@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-21-dmatlack@google.com>
 <YjG7Zh4zwTDsO3L1@xz-m1.local>
 <CALzav=fRFzbGEVhdMSwhX1Gs1++DGW6MOWvKzeQ-RTtLsus=SQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALzav=fRFzbGEVhdMSwhX1Gs1++DGW6MOWvKzeQ-RTtLsus=SQ@mail.gmail.com>
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

On Tue, Mar 22, 2022 at 04:58:08PM -0700, David Matlack wrote:
> > > +static int prepare_to_split_huge_page(struct kvm *kvm,
> > > +                                   const struct kvm_memory_slot *slot,
> > > +                                   u64 *huge_sptep,
> > > +                                   struct kvm_mmu_page **spp,
> > > +                                   bool *flush,
> > > +                                   bool *dropped_lock)
> > > +{
> > > +     int r = 0;
> > > +
> > > +     *dropped_lock = false;
> > > +
> > > +     if (kvm_mmu_available_pages(kvm) <= KVM_MIN_FREE_MMU_PAGES)
> > > +             return -ENOSPC;
> > > +
> > > +     if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
> > > +             goto drop_lock;
> > > +
> >
> > Not immediately clear on whether there'll be case that *spp is set within
> > the current function.  Some sanity check might be nice?
> 
> Sorry I'm not sure what you mean here. What kind of sanity check did
> you have in mind?

Something like "WARN_ON_ONCE(*spp);"?

> 
> >
> > > +     *spp = kvm_mmu_alloc_direct_sp_for_split(true);
> > > +     if (r)
> > > +             goto drop_lock;
> > > +
> > > +     return 0;

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
