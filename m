Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3520FC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 09:04:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD28C49F20;
	Tue, 15 Mar 2022 05:04:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3N9nWPy6Y6mp; Tue, 15 Mar 2022 05:04:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65D6049F26;
	Tue, 15 Mar 2022 05:04:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1CFF49F1E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 05:04:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gKnbB-EBmFlh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 05:04:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EBB249F1D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 05:04:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647335042;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Q7JlUJr4Lo/7VJy1NmLVlU58GKSRSwFR5b1pvsat2Gg=;
 b=C0+0dg616+8ggYV76u2C70GzxrKx6fVAAhKMPP9ZNqPjlF5Ln1z1sEhJRgK7gc8aqtX96k
 JoWc7CrMscP03sd8IpHu0gWqOC9/U+aWC/qCQCy40EeTfF7BV0kmeC5JQlAHZVzX4ofpvp
 ypXERf0vkkbipgmOHeJ3g+apLviGlX0=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-aORE0-GoMDGsevymmQs7rw-1; Tue, 15 Mar 2022 05:04:00 -0400
X-MC-Unique: aORE0-GoMDGsevymmQs7rw-1
Received: by mail-pj1-f70.google.com with SMTP id
 c14-20020a17090a674e00b001bf1c750f9bso1583817pjm.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 02:04:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Q7JlUJr4Lo/7VJy1NmLVlU58GKSRSwFR5b1pvsat2Gg=;
 b=jvldL/GNxMPc6m/RCHA/vO29r+cuLZLrQsPqEJyk14auaX/n7mEDtN87b9241x71Ux
 GrE2gXAR4RrDkrgItSnSPgbCpTAioevmFjYPRrHUkFHWFQKlybMS8PoEk9496mAh39LP
 GdTGFFTfXYOFIZ8AgzC1FS/dxqRKzEZxnYz55LK/1wEQpQ88iT/4g0wbvWSgzGtwUZOr
 iGxtY3qV4KGC8pZKAkUk4uPG5QO7z387xvyyrvTBw3xnQrh/IXsmw0qn+e77VXpki6tG
 P3hSc0BZ51kweeEgG7cPsGhScNtkRHaeG7wSWkCakMF+MPB/BGacOyJFSauonzSwoZmT
 ez6Q==
X-Gm-Message-State: AOAM5311TO2xxtF2dqOideQgIeFxw2kIXhfPz3Nt/rVxQ7IaZ95g9Whs
 4MuNvupaVZB9flqYLiglZlSENyMX4W96OHm5Em0Gz516fqy7AA4LXQeIIw89e/muLG2FFDTUUkw
 d7BexSZvNjzppYGBOrz5lkNCR
X-Received: by 2002:a63:4543:0:b0:374:87b6:c9f5 with SMTP id
 u3-20020a634543000000b0037487b6c9f5mr23571607pgk.302.1647335039450; 
 Tue, 15 Mar 2022 02:03:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhjGuq26G+fQETXurSMRI3XZcImwtJrOW3Uh4ZD3nZ5YW2XWuRRTs+2GtkbHoiDVdGeTEnRw==
X-Received: by 2002:a63:4543:0:b0:374:87b6:c9f5 with SMTP id
 u3-20020a634543000000b0037487b6c9f5mr23571566pgk.302.1647335039059; 
 Tue, 15 Mar 2022 02:03:59 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43]) by smtp.gmail.com with ESMTPSA id
 e6-20020a056a001a8600b004f78e446ff5sm15441943pfv.15.2022.03.15.02.03.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 02:03:58 -0700 (PDT)
Date: Tue, 15 Mar 2022 17:03:50 +0800
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 06/26] KVM: x86/mmu: Pass memslot to
 kvm_mmu_new_shadow_page()
Message-ID: <YjBWdv3nEk3Cz40m@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-7-dmatlack@google.com>
MIME-Version: 1.0
In-Reply-To: <20220311002528.2230172-7-dmatlack@google.com>
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
 maciej.szmigiero@oracle.com,
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

On Fri, Mar 11, 2022 at 12:25:08AM +0000, David Matlack wrote:
> Passing the memslot to kvm_mmu_new_shadow_page() avoids the need for the
> vCPU pointer when write-protecting indirect 4k shadow pages. This moves
> us closer to being able to create new shadow pages during VM ioctls for
> eager page splitting, where there is not vCPU pointer.
> 
> This change does not negatively impact "Populate memory time" for ept=Y
> or ept=N configurations since kvm_vcpu_gfn_to_memslot() caches the last
> use slot. So even though we now look up the slot more often, it is a
> very cheap check.
> 
> Opportunistically move the code to write-protect GFNs shadowed by
> PG_LEVEL_4K shadow pages into account_shadowed() to reduce indentation
> and consolidate the code. This also eliminates a memslot lookup.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b6fb50e32291..519910938478 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -793,16 +793,14 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn)
>  	update_gfn_disallow_lpage_count(slot, gfn, -1);
>  }
>  
> -static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
> +static void account_shadowed(struct kvm *kvm,
> +			     struct kvm_memory_slot *slot,
> +			     struct kvm_mmu_page *sp)
>  {
> -	struct kvm_memslots *slots;
> -	struct kvm_memory_slot *slot;
>  	gfn_t gfn;
>  
>  	kvm->arch.indirect_shadow_pages++;
>  	gfn = sp->gfn;
> -	slots = kvm_memslots_for_spte_role(kvm, sp->role);
> -	slot = __gfn_to_memslot(slots, gfn);
>  
>  	/* the non-leaf shadow pages are keeping readonly. */
>  	if (sp->role.level > PG_LEVEL_4K)
> @@ -810,6 +808,9 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
>  						    KVM_PAGE_TRACK_WRITE);
>  
>  	kvm_mmu_gfn_disallow_lpage(slot, gfn);
> +
> +	if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
> +		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);

It's not immediately obvious in this diff, but when looking at the code
yeah it looks right to just drop the 4K check..

I also never understood why we only write-track the >1 levels but only
wr-protect the last level.  It'll be great if there's quick answer from
anyone.. even though it's probably unrelated to the patch.

The change looks all correct:

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
