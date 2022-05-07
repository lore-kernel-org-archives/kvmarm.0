Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797E8C433F5
	for <kvmarm@archiver.kernel.org>; Sat,  7 May 2022 09:15:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BF494B2BA;
	Sat,  7 May 2022 05:15:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ioIZFTUIiPsI; Sat,  7 May 2022 05:14:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D0B94B2F9;
	Sat,  7 May 2022 05:14:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D42D4B299
 for <kvmarm@lists.cs.columbia.edu>; Sat,  7 May 2022 04:28:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id juVfUcMScMyP for <kvmarm@lists.cs.columbia.edu>;
 Sat,  7 May 2022 04:28:26 -0400 (EDT)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
 [209.85.214.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D77094B21F
 for <kvmarm@lists.cs.columbia.edu>; Sat,  7 May 2022 04:28:25 -0400 (EDT)
Received: by mail-pl1-f175.google.com with SMTP id p6so8989478plr.12
 for <kvmarm@lists.cs.columbia.edu>; Sat, 07 May 2022 01:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=message-id:date:mime-version:user-agent:subject:content-language:to
 :cc:references:from:in-reply-to:content-transfer-encoding;
 bh=51U05xLln8jvwaVJ/GYDAlmADJa8Oq6KTjcweXEcEBo=;
 b=GIlwH1ChEbKDsON6fEw5IVOwvQd/3nzoIK2CtkBY0x9YbjIp2cZBYow+6FrCdsqUiK
 7DjS0eVf9lKselmLUFfsYW95b52EK/1SNXwsTqB3oIIsIF2b5YUj2eeBF/oPuifmEBxP
 PUgMdp8yngcglmME3sSSqd6LWmPMv6AYhjFWZh6LDwgM6+9clTKTD8VkzNNIfE/Q47xc
 dg/wUbwXVr9kyDvK6ic+iz17M7RtDHvXwp4eQvsEzP+gmMq5AT/kh+6+JPeagYfuKsJm
 JtIh2jyE2H/4XWYTz/S654wMM5RNSP4y2oFYK5dVsj6Gj36fXQsTV5XBf8j8gh7aP1Yk
 mmwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=51U05xLln8jvwaVJ/GYDAlmADJa8Oq6KTjcweXEcEBo=;
 b=7Z1HCTrJpVgewtLhFtpcX80DZzDGGIVogD1CKQehR39t8osy1cg6B794O0Ih0UcXQM
 zfV8DRzGoPgp2vjYJBmkdWl61qMrIlWPx1F8xyu638JN81bTJ6YQN6DBVwPOCT9vhRZA
 ktA8MGIsbUpvb4ggVtvmVdfePaHqiDMqDI1zdTBUKfl4GhikDmMZe8llLsGDcrZdF+M7
 7JMcarXMVN2JYLffEtsFZ+3mv+80U2HfT9PvpHO/O2Z73IB7a53LJ7kZFbOzJZU8ZxDb
 VyVkkKzP7p7lg9zoLO7koX55GlwDZDaRB9sT4PNeg1OTu9epqguJu9j7cpUdheD33VZf
 hk3A==
X-Gm-Message-State: AOAM531jgqLpTpBJMGOtq/r7C4hNBYJ0LDK9N8tAKyh0+Xe+Dn+bKHji
 JsZIB9lXAZIzYxs49/SfB3E=
X-Google-Smtp-Source: ABdhPJx2/OhxgtiOkQ2IirqlGpQJjQhIEeY+OQTjTbzoh41w/HqiZMgrT5Bro1mPW9UgNqdTp1g8Bg==
X-Received: by 2002:a17:903:32c6:b0:15e:c1cc:2405 with SMTP id
 i6-20020a17090332c600b0015ec1cc2405mr7763243plr.117.1651912104711; 
 Sat, 07 May 2022 01:28:24 -0700 (PDT)
Received: from [30.22.112.212] ([205.204.117.91])
 by smtp.gmail.com with ESMTPSA id
 kx7-20020a17090b228700b001dce819d6f6sm1600678pjb.13.2022.05.07.01.28.20
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 07 May 2022 01:28:24 -0700 (PDT)
Message-ID: <75fbbcb6-d9bb-3d30-0bf4-fbf925517d09@gmail.com>
Date: Sat, 7 May 2022 16:28:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v4 03/20] KVM: x86/mmu: Derive shadow MMU page role from
 parent
Content-Language: en-US
To: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-4-dmatlack@google.com>
From: Lai Jiangshan <jiangshanlai@gmail.com>
In-Reply-To: <20220422210546.458943-4-dmatlack@google.com>
X-Mailman-Approved-At: Sat, 07 May 2022 05:14:38 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 2022/4/23 05:05, David Matlack wrote:
> Instead of computing the shadow page role from scratch for every new
> page, derive most of the information from the parent shadow page.  This
> avoids redundant calculations and reduces the number of parameters to
> kvm_mmu_get_page().
> 
> Preemptively split out the role calculation to a separate function for
> use in a following commit.
> 
> No functional change intended.
> 
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c         | 96 +++++++++++++++++++++++-----------
>   arch/x86/kvm/mmu/paging_tmpl.h |  9 ++--
>   2 files changed, 71 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index dc20eccd6a77..4249a771818b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2021,31 +2021,15 @@ static void clear_sp_write_flooding_count(u64 *spte)
>   	__clear_sp_write_flooding_count(sptep_to_sp(spte));
>   }
>   
> -static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> -					     gfn_t gfn,
> -					     gva_t gaddr,
> -					     unsigned level,
> -					     bool direct,
> -					     unsigned int access)
> +static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> +					     union kvm_mmu_page_role role)
>   {
> -	union kvm_mmu_page_role role;
>   	struct hlist_head *sp_list;
> -	unsigned quadrant;
>   	struct kvm_mmu_page *sp;
>   	int ret;
>   	int collisions = 0;
>   	LIST_HEAD(invalid_list);
>   
> -	role = vcpu->arch.mmu->root_role;
> -	role.level = level;
> -	role.direct = direct;
> -	role.access = access;
> -	if (role.has_4_byte_gpte) {
> -		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
> -		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
> -		role.quadrant = quadrant;
> -	}


I don't think replacing it with kvm_mmu_child_role() can reduce any calculations.

role.level, role.direct, role.access and role.quadrant still need to be
calculated.  And the old code is still in mmu_alloc_root().

I think kvm_mmu_get_shadow_page() can keep the those parameters and
kvm_mmu_child_role() is only introduced for nested_mmu_get_sp_for_split().

Both kvm_mmu_get_shadow_page() and nested_mmu_get_sp_for_split() call
__kvm_mmu_get_shadow_page() which uses role as a parameter.



> -
>   	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
>   	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
>   		if (sp->gfn != gfn) {
> @@ -2063,7 +2047,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>   			 * Unsync pages must not be left as is, because the new
>   			 * upper-level page will be write-protected.
>   			 */
> -			if (level > PG_LEVEL_4K && sp->unsync)
> +			if (role.level > PG_LEVEL_4K && sp->unsync)
>   				kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
>   							 &invalid_list);
>   			continue;
> @@ -2104,14 +2088,14 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>   
>   	++vcpu->kvm->stat.mmu_cache_miss;
>   
> -	sp = kvm_mmu_alloc_page(vcpu, direct);
> +	sp = kvm_mmu_alloc_page(vcpu, role.direct);
>   
>   	sp->gfn = gfn;
>   	sp->role = role;
>   	hlist_add_head(&sp->hash_link, sp_list);
> -	if (!direct) {
> +	if (!role.direct) {
>   		account_shadowed(vcpu->kvm, sp);
> -		if (level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
> +		if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
>   			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
>   	}
>   	trace_kvm_mmu_get_page(sp, true);
> @@ -2123,6 +2107,51 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>   	return sp;
>   }
>   
> +static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
> +{
> +	struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
> +	union kvm_mmu_page_role role;
> +
> +	role = parent_sp->role;
> +	role.level--;
> +	role.access = access;
> +	role.direct = direct;
> +
> +	/*
> +	 * If the guest has 4-byte PTEs then that means it's using 32-bit,
> +	 * 2-level, non-PAE paging. KVM shadows such guests using 4 PAE page
> +	 * directories, each mapping 1/4 of the guest's linear address space
> +	 * (1GiB). The shadow pages for those 4 page directories are
> +	 * pre-allocated and assigned a separate quadrant in their role.


It is not going to be true in patchset:
[PATCH V2 0/7] KVM: X86/MMU: Use one-off special shadow page for special roots

https://lore.kernel.org/lkml/20220503150735.32723-1-jiangshanlai@gmail.com/

The shadow pages for those 4 page directories are also allocated on demand.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
