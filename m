Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0EC8C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 22:42:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1FC0260231
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 22:42:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1FC0260231
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FBBC4B103;
	Thu,  4 Nov 2021 18:42:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wT7G5ImS34jQ; Thu,  4 Nov 2021 18:42:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D48E64B0BA;
	Thu,  4 Nov 2021 18:42:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A1EF4B0AC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 18:42:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ze5MeSK-AOOe for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Nov 2021 18:41:59 -0400 (EDT)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
 [209.85.215.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20C694A7FD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 18:41:59 -0400 (EDT)
Received: by mail-pg1-f169.google.com with SMTP id b4so6668212pgh.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Nov 2021 15:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=2cM+pc7RJOlLXf/kESM57DsH9Y+7ss4v2ISlVrw0au4=;
 b=ooE6FbC1dphlseVcXYf6E54FhDQXALDT9cp9rkFbPJ4y3391PeZbY42Xq5zYAiM2X0
 NdOPtJ6lkjBowxQXuPPYzsk/ImWUzRx84xa98kqJsQVBicjU2eDc5DVULiWpqnCKqxed
 Ey2Ctp6iCrEN8zCtRphZ24isIw03JAvk0SfSWM0DA/73Pbf0h/QRbrwYHZfhgAzS25J9
 xoJiSowrT7yhbflDyi/bGTCX/rlcA7okzQ8gpsTNHWowkIpirAi9P+owp8DITCHO+0RI
 qztHqyk6DNOgAHnulQogAsMkvqtleYWLZNf20k/P+g9/YJ3n7yTI2IPueMQnaW5/KaTr
 oILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=2cM+pc7RJOlLXf/kESM57DsH9Y+7ss4v2ISlVrw0au4=;
 b=Efr/mwBae+lJt2HZbO0x9JFtcf9uQ2cJpGsZXPv44yhO9uT5viYmlcZaHWoAV0pfzU
 R3Vpg75kEZdNjDpXTBLMayMCFxEEpV4qEG5oQhBVg3a/PAo5zcs/zQIV118VHhJySrNa
 5DpMlajhyHOMOdxMVpCwk11wThqKeUMY8dMW1HWoH/9B1IDqdbBAf+5cO+EOJv+mVefS
 pe4tMHUQO7HBgYlmbzGNhTm69DXVHcCjduhXh6vB9H+b/R9HpBChHsi9fZJ0jYKcY/ry
 ldovVejUp1Ty8PzDnHzMta5WKis9XbAalwwgJOgifP8T5WTdlOBQ6u9Y3nvf7Y+vm/2Z
 k+hg==
X-Gm-Message-State: AOAM533h6+ZOGQk8/jPFgcf17cbzqfEZ8SYB/6AmpbRctLlXUgXYwcKB
 xbPDI2mvnDOA7RmuWf16WHhEhA==
X-Google-Smtp-Source: ABdhPJxxNMKGv/NhLtIdMl/BRJOCT+zMUUqyt4AWTJHdlm9O9AHyBiNnpE4YQWobAiLulE4sZ0UvKQ==
X-Received: by 2002:a05:6a00:21c2:b0:44c:fa0b:f72 with SMTP id
 t2-20020a056a0021c200b0044cfa0b0f72mr54948884pfj.13.1636065717795; 
 Thu, 04 Nov 2021 15:41:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id h2sm4707798pjk.44.2021.11.04.15.41.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Nov 2021 15:41:57 -0700 (PDT)
Date: Thu, 4 Nov 2021 22:41:53 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v5.5 01/30] KVM: Ensure local memslot copies operate on
 up-to-date arch-specific data
Message-ID: <YYRhsclZpZwilkE5@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-2-seanjc@google.com>
 <CANgfPd-uuPFjAHk5kVNom2Qs=UU_GX6CQ0xDLg1h_iL8t8S2aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANgfPd-uuPFjAHk5kVNom2Qs=UU_GX6CQ0xDLg1h_iL8t8S2aQ@mail.gmail.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Anup Patel <anup.patel@wdc.com>,
 linux-mips@vger.kernel.org, Palmer Dabbelt <palmer@dabbelt.com>,
 kvm-riscv@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
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

On Thu, Nov 04, 2021, Ben Gardon wrote:
> > @@ -1597,6 +1596,26 @@ static int kvm_set_memslot(struct kvm *kvm,
> >                 kvm_copy_memslots(slots, __kvm_memslots(kvm, as_id));
> >         }
> >
> > +       /*
> > +        * Make a full copy of the old memslot, the pointer will become stale
> > +        * when the memslots are re-sorted by update_memslots(), and the old
> > +        * memslot needs to be referenced after calling update_memslots(), e.g.
> > +        * to free its resources and for arch specific behavior.  This needs to
> > +        * happen *after* (re)acquiring slots_arch_lock.
> > +        */
> > +       slot = id_to_memslot(slots, new->id);
> > +       if (slot) {
> > +               old = *slot;
> > +       } else {
> > +               WARN_ON_ONCE(change != KVM_MR_CREATE);
> > +               memset(&old, 0, sizeof(old));
> > +               old.id = new->id;
> > +               old.as_id = as_id;
> > +       }
> > +
> > +       /* Copy the arch-specific data, again after (re)acquiring slots_arch_lock. */
> > +       memcpy(&new->arch, &old.arch, sizeof(old.arch));
> > +
> 
> Is new->arch not initialized before this function is called? Does this
> need to be here, or could it be moved above into the first branch of
> the if statement?
> Oh I see you removed the memset below and replaced it with this. I
> think this is fine, but it might be easier to reason about if we left
> the memset and moved the memcopy into the if.
> No point in doing a memcpy of zeros here.

Hmm, good point.  I wrote it like this so that the "arch" part is more identifiable
since that's what needs to be protected by the lock, but I completely agree that
it's odd when viewed without that lens.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
