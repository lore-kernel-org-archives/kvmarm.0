Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8735C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 16 Mar 2022 08:32:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 075A949F0B;
	Wed, 16 Mar 2022 04:32:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ybcRaqgGo-Rq; Wed, 16 Mar 2022 04:32:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DE4249ED8;
	Wed, 16 Mar 2022 04:32:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE3F840C0A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 04:32:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B60TjU0Yws9S for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 04:32:25 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EDBF40BE7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 04:32:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647419545;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=jjZm70XMrj/Rp5s34/zzGgqrERGbjp7SPfa5KT7Pao4=;
 b=d6xOSwli4y3pUyO8mbRPaunACYwSqTaGTqxgzhP+tPcVUSKa4Qw1T9iYOauOCy77uBiSUe
 QqbNXzEZkwZ6gMN6tRCN+yqgnRoEpJg8sX6wGz7Fd3buMcy6ut0lzhHOehRd0TaKq6G8id
 aiR1epNEy2g/fdJfnybh/I3Syfsz0Y0=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-5tg0TftKPFOZOTBreyedpw-1; Wed, 16 Mar 2022 04:32:23 -0400
X-MC-Unique: 5tg0TftKPFOZOTBreyedpw-1
Received: by mail-pl1-f200.google.com with SMTP id
 y3-20020a1709029b8300b0014c8bcb70a1so974813plp.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 01:32:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=jjZm70XMrj/Rp5s34/zzGgqrERGbjp7SPfa5KT7Pao4=;
 b=Gxh8Bq9Cmn1xfJMWCE3xE14z7TiUqeyS/5QpGJjaFf6LpO78EkuMtuawsfDubzJFVA
 Nyb+q3HpTcYSjUAtPIeE1Vrha6qc8ajFGkaaTWRqKb98f90yFrgb38oGpGJOFwRGzmz8
 lMNu0j6ak0N2LI83kiM3yd6t4f1fZX6czi1Lr2e1iPOE8xBJNhcQvqvsXEEATykcAVge
 xndTPCFdXX+sHbTwmWcUhsiqvoNKbtBAXnjd1iJUDCqj31M6NDDC0JeTd+H1kG1K+AM3
 1UgYdHeNH+9CZ2Pa3jc5ZUWeiiFxFnNIkj5qMBlvAQFbY1QmEJyk/U4QcCxaMhJudCQg
 Ky0g==
X-Gm-Message-State: AOAM532VAdVcBmV62CXWmGXcXS4r5KwZglyWJGFD7cxwZMRXiYDv2TOX
 FLni8zRBwRiYENKNE2jYfIU7iYh7f99EK953yqlJd0F+yxCDMf4GN/Ds3T5N1R7wsH1ZtQzLdxm
 kEeyEjKkoI00fHmtQFZPQoQff
X-Received: by 2002:a63:4e14:0:b0:374:4a37:4966 with SMTP id
 c20-20020a634e14000000b003744a374966mr26992347pgb.118.1647419542793; 
 Wed, 16 Mar 2022 01:32:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNPcz5i9opLI37VCXelA4fPh3aZshlOtJoDylYilxYNapzjAAQzajYYuBDJJrlk3n3Pyh3Pw==
X-Received: by 2002:a63:4e14:0:b0:374:4a37:4966 with SMTP id
 c20-20020a634e14000000b003744a374966mr26992316pgb.118.1647419542495; 
 Wed, 16 Mar 2022 01:32:22 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.128])
 by smtp.gmail.com with ESMTPSA id
 a5-20020a621a05000000b004f79f8f795fsm2072222pfa.0.2022.03.16.01.32.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Mar 2022 01:32:22 -0700 (PDT)
Date: Wed, 16 Mar 2022 16:32:13 +0800
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 16/26] KVM: x86/mmu: Cache the access bits of shadowed
 translations
Message-ID: <YjGgjTnP/9sG8L+2@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-17-dmatlack@google.com>
MIME-Version: 1.0
In-Reply-To: <20220311002528.2230172-17-dmatlack@google.com>
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

On Fri, Mar 11, 2022 at 12:25:18AM +0000, David Matlack wrote:
> In order to split a huge page we need to know what access bits to assign
> to the role of the new child page table. This can't be easily derived
> from the huge page SPTE itself since KVM applies its own access policies
> on top, such as for HugePage NX.
> 
> We could walk the guest page tables to determine the correct access
> bits, but that is difficult to plumb outside of a vCPU fault context.
> Instead, we can store the original access bits for each leaf SPTE
> alongside the GFN in the gfns array. The access bits only take up 3
> bits, which leaves 61 bits left over for gfns, which is more than
> enough. So this change does not require any additional memory.

I have a pure question on why eager page split needs to worry on hugepage
nx..

IIUC that was about forbidden huge page being mapped as executable.  So
afaiu the only missing bit that could happen if we copy over the huge page
ptes is the executable bit.

But then?  I think we could get a page fault on fault->exec==true on the
split small page (because when we copy over it's cleared, even though the
page can actually be executable), but it should be well resolved right
after that small page fault.

The thing is IIUC this is a very rare case, IOW, it should mostly not
happen in 99% of the use case?  And there's a slight penalty when it
happens, but only perf-wise.

As I'm not really fluent with the code base, perhaps I missed something?

> 
> In order to keep the access bit cache in sync with the guest, we have to
> extend FNAME(sync_page) to also update the access bits.

Besides sync_page(), I also see that in mmu_set_spte() there's a path that
we will skip the rmap_add() if existed:

	if (!was_rmapped) {
		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
		kvm_update_page_stats(vcpu->kvm, level, 1);
		rmap_add(vcpu, slot, sptep, gfn);
	}

I didn't check, but it's not obvious whether the sync_page() change here
will cover all of the cases, hence raise this up too.

> 
> Now that the gfns array caches more information than just GFNs, rename
> it to shadowed_translation.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/mmu/mmu.c          | 32 +++++++++++++++++++-------------
>  arch/x86/kvm/mmu/mmu_internal.h | 15 +++++++++++++--
>  arch/x86/kvm/mmu/paging_tmpl.h  |  7 +++++--
>  4 files changed, 38 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f72e80178ffc..0f5a36772bdc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -694,7 +694,7 @@ struct kvm_vcpu_arch {
>  
>  	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
>  	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
> -	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
> +	struct kvm_mmu_memory_cache mmu_shadowed_translation_cache;

I'd called it with a shorter name.. :) maybe mmu_shadowed_info_cache?  No
strong opinion.

>  	struct kvm_mmu_memory_cache mmu_page_header_cache;
>  
>  	/*

[...]

> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index b6e22ba9c654..c5b8ee625df7 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -32,6 +32,11 @@ extern bool dbg;
>  
>  typedef u64 __rcu *tdp_ptep_t;
>  
> +struct shadowed_translation_entry {
> +	u64 access:3;
> +	u64 gfn:56;

Why 56?

> +};

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
