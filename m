Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A526C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  9 Apr 2022 00:40:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B92164B1D0;
	Fri,  8 Apr 2022 20:40:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ap3DwQ4KnGoh; Fri,  8 Apr 2022 20:40:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81D7E4B1E0;
	Fri,  8 Apr 2022 20:40:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55D9E4B1A3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 20:40:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T38FZ4Oc1fDR for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 20:40:01 -0400 (EDT)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 465324B1A0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 20:40:01 -0400 (EDT)
Received: by mail-pf1-f171.google.com with SMTP id bo5so9832786pfb.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2022 17:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=VZz44nmQ769NskmU1+rSj1kgQ7eEgmL84RyrglKPKlU=;
 b=hDG6N87X2mOxxCOCXXKUWOcaI826FpS5EoPhQJZu2dORSprAcsRFAElLaAchgm9JOc
 6aWNWoTK0riqGAg5yhneIUYXDrCc+fGj3H7kK7mXEHIlpTFzEJW/uo/BmtZGNeswC4nd
 PbmESxnPTnEseYvaH22WEqAMzyjNqP7va9Cy/08YzQ+8Zp7oRhZV7H2uOAWtwOJwR64j
 C1XpU2RhBAmDNFKLPpLhftnPQdVrdTUUBk5NAt0Csjzufq0YZ246p/rCAHmwpT6hnZDF
 gCIIkrVBCCM0ekFXDZVmyYk5Ax0gSZAvTp7mqghQynS+ToMez9bXma7soou9cwqLW7g0
 3GkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=VZz44nmQ769NskmU1+rSj1kgQ7eEgmL84RyrglKPKlU=;
 b=a/Pq/ZgJEep0CRdoSoAI604+GUFDnxX0qAx6c9tF8GCNSLn8AxedId7jTGL+W3S03Q
 RzLtSv20RSFo62e2iZIzfbqKrD/lXU/Tq/lsEIj7B14yjV/9mqnq+yEbLW+KvBzJTkkl
 0LKAirIgWH4x5wKvLZU1y+d/ErhCjyvk873hJ/tbXwk02iq7j2a6ltCybcILOD22vYKg
 qVB1sgqjrBE1loQq2jkBOpSvwOIxc0ItSI+jUOnnJy1zvSrDLY7ppNuQVGN3yozSc7f3
 BGZJcxJByxAsK3okvDKpQLqayQJ31vQ025B0yA5bVNC5TrzWFnq2CxTMFbRaXrXWPllm
 lqtw==
X-Gm-Message-State: AOAM5329TB02yOtVlUudlQ2tvDo8d5gcbDIf/C6Kk88VwIfFdPSN/9e0
 sO4TchWV1+ukNK4WJlzYvKQmgA==
X-Google-Smtp-Source: ABdhPJy9qpY4+K63QvK5VhUfvYFRHJk9uYqLUbpgv47CS1Vcvf2kVPQru+XKAuYVywEBn/XAV7z39w==
X-Received: by 2002:a63:5520:0:b0:399:8cd:5f62 with SMTP id
 j32-20020a635520000000b0039908cd5f62mr17547409pgb.12.1649464800133; 
 Fri, 08 Apr 2022 17:40:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 m8-20020a056a00080800b004faa4e113bfsm28586836pfk.154.2022.04.08.17.39.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 08 Apr 2022 17:39:59 -0700 (PDT)
Date: Sat, 9 Apr 2022 00:39:55 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 22/23] KVM: x86/mmu: Support Eager Page Splitting in
 the shadow MMU
Message-ID: <YlDV27ediz+rBuLd@google.com>
References: <20220401175554.1931568-1-dmatlack@google.com>
 <20220401175554.1931568-23-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220401175554.1931568-23-dmatlack@google.com>
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

On Fri, Apr 01, 2022, David Matlack wrote:
> Add support for Eager Page Splitting pages that are mapped by the shadow
> MMU. Walk through the rmap first splitting all 1GiB pages to 2MiB pages,
> and then splitting all 2MiB pages to 4KiB pages.
> 
> Splitting huge pages mapped by the shadow MMU requries dealing with some
> extra complexity beyond that of the TDP MMU:
> 
> (1) The shadow MMU has a limit on the number of shadow pages that are
>     allowed to be allocated. So, as a policy, Eager Page Splitting
>     refuses to split if there are KVM_MIN_FREE_MMU_PAGES or fewer
>     pages available.
> 
> (2) Huge pages may be mapped by indirect shadow pages which have the
>     possibility of being unsync. As a policy we opt not to split such
>     pages as their translation may no longer be valid.

This shouldn't be possible, shadow pages whose role is > 4k are always write-protected
and not allowed to become unsync.

> 
> (3) Splitting a huge page may end up re-using an existing lower level
>     shadow page tables. This is unlike the TDP MMU which always allocates
>     new shadow page tables when splitting.

...

> +static void kvm_mmu_split_huge_page(struct kvm *kvm,
> +				    const struct kvm_memory_slot *slot,
> +				    u64 *huge_sptep, struct kvm_mmu_page **spp)
> +
> +{
> +	struct kvm_mmu_memory_cache *cache = &kvm->arch.huge_page_split_desc_cache;
> +	u64 huge_spte = READ_ONCE(*huge_sptep);
> +	struct kvm_mmu_page *sp;
> +	bool flush = false;
> +	u64 *sptep, spte;
> +	gfn_t gfn;
> +	int index;
> +
> +	sp = kvm_mmu_get_sp_for_split(kvm, slot, huge_sptep, spp);
> +
> +	for (index = 0; index < PT64_ENT_PER_PAGE; index++) {
> +		sptep = &sp->spt[index];
> +		gfn = kvm_mmu_page_get_gfn(sp, index);
> +
> +		/*
> +		 * sp may have populated page table entries, e.g. if this huge
> +		 * page is aliased by multiple sptes with the same access
> +		 * permissions. We know the sptes will be mapping the same
> +		 * gfn-to-pfn translation since sp is direct. However, a given
> +		 * spte may point to an even lower level page table. We don't
> +		 * know if that lower level page table is completely filled in,
> +		 * i.e. we may be effectively unmapping a region of memory, so
> +		 * we must flush the TLB.

Random side topic, please avoid "we" and other pronouns in comments and changelogs,
it gets real easy to lose track of what a pronoun is referring to, especially in
changelogs where "we" might be KVM, might be the kernel, might be the team that's
using the patch, might be an author that's prone to illeism, etc...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
