Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0163A945;
	Mon, 13 Feb 2023 17:44:28 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id h29so3667711ila.8;
        Mon, 13 Feb 2023 09:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676310268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WO1hACTWD9TkfT3XqpHu1+7pGePhroyoHGGrfkv/TRs=;
        b=juRJjlzGdYd+WtkMFpIChn0B2aMPgg5Ow4gNyNNMjrj0fgKR+evfY9H/VNuK/hRalt
         XkGE1pwDOMHBtwWRDaF6qwLochoxdxmUr4+9NTXFrnyWz4CEl25v7Pp8Jf2kMoZfWmMy
         KN5a0eQTFkWj8T1Ft03Knw3NSD/NeJUd/MgUwFWiTAgbTb7iT3SUSOjHliy+Ma6wO0aq
         Ji0il2q6SglWPCa4ZKB6k6DEPtWN26jwPTIZkbDHAgLdqxN3BVEJCAXyy1GaEhCgWB0u
         6tH4Gvz8Bo/d1EcmOwW6575/hQyn2POvRVSkuHNQ/4hODno9bRlYv+orc2+B78TGJrOq
         dPow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676310268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WO1hACTWD9TkfT3XqpHu1+7pGePhroyoHGGrfkv/TRs=;
        b=wM2xokLTpalMdWfUODJWMgO8qs50eRtWw8+WRjoSayOW5C9nlBNdXXsSuT/Bk5VW8U
         CFgSYz4oSjP9T7bLL0Kpk52DqOaQ5WJ45gWmn07bfdiye1qBZY6URUeQfHSr0Jx14D0l
         K9sYbYaHZH5TJp3H3fQa5i4h5/E6GzlgVDHLenJWRafGODGaehizZXFqJ+UAHrS0u+B+
         +eAqEy3enZxaEIMNs1VHk/Q0E8Lt7mf9ZKgywEEcJYmLgF5qfg+9yECna1BSHRfEwwlR
         Fd4nZl4iKGTrA/rGKl/Kr5SkFdol+V0kxDU0Ayv0ld4gL2qRyYY3JR1DqzApSDgWtcXN
         7sKA==
X-Gm-Message-State: AO0yUKWUv2AurL/v7xPfpWElez4ElmdtdzGQ7qpdoy3XxJAWYcLbd0Ut
	NfXo2WyMMsO+21xwdsCcSUI=
X-Google-Smtp-Source: AK7set/k4sh3/04FvwQWRHosk0TQoOS+cEMhUVusKNMzUv8iN+8kXC+AoLHmF47IvSh49GN6/DNBFQ==
X-Received: by 2002:a92:cd8d:0:b0:314:6968:ed8d with SMTP id r13-20020a92cd8d000000b003146968ed8dmr11081309ilb.3.1676310267984;
        Mon, 13 Feb 2023 09:44:27 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id e23-20020a02cab7000000b003af2cdde559sm4013564jap.35.2023.02.13.09.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 09:44:27 -0800 (PST)
Date: Mon, 13 Feb 2023 19:44:21 +0200
From: Zhi Wang <zhi.wang.linux@gmail.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Catalin Marinas
 <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon
 <will@kernel.org>, James Morse <james.morse@arm.com>, Oliver Upton
 <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, Alexandru
 Elisei <alexandru.elisei@arm.com>, Christoffer Dall
 <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH 09/28] arm64: RME: RTT handling
Message-ID: <20230213194421.00005f7b@gmail.com>
In-Reply-To: <20230127112932.38045-10-steven.price@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
	<20230127112932.38045-1-steven.price@arm.com>
	<20230127112932.38045-10-steven.price@arm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 27 Jan 2023 11:29:13 +0000
Steven Price <steven.price@arm.com> wrote:

> The RMM owns the stage 2 page tables for a realm, and KVM must request
> that the RMM creates/destroys entries as necessary. The physical pages
> to store the page tables are delegated to the realm as required, and can
> be undelegated when no longer used.
> 

This is only an introduction to RTT handling. While this patch is mostly like
RTT teardown, better add more introduction to this patch. Also maybe refine
the tittle to reflect what this patch is actually doing.

> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/kvm_rme.h |  19 +++++
>  arch/arm64/kvm/mmu.c             |   7 +-
>  arch/arm64/kvm/rme.c             | 139 +++++++++++++++++++++++++++++++
>  3 files changed, 162 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index a6318af3ed11..eea5118dfa8a 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -35,5 +35,24 @@ u32 kvm_realm_ipa_limit(void);
>  int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>  int kvm_init_realm_vm(struct kvm *kvm);
>  void kvm_destroy_realm(struct kvm *kvm);
> +void kvm_realm_destroy_rtts(struct realm *realm, u32 ia_bits, u32 start_level);
> +
> +#define RME_RTT_BLOCK_LEVEL	2
> +#define RME_RTT_MAX_LEVEL	3
> +
> +#define RME_PAGE_SHIFT		12
> +#define RME_PAGE_SIZE		BIT(RME_PAGE_SHIFT)
> +/* See ARM64_HW_PGTABLE_LEVEL_SHIFT() */
> +#define RME_RTT_LEVEL_SHIFT(l)	\
> +	((RME_PAGE_SHIFT - 3) * (4 - (l)) + 3)
> +#define RME_L2_BLOCK_SIZE	BIT(RME_RTT_LEVEL_SHIFT(2))
> +
> +static inline unsigned long rme_rtt_level_mapsize(int level)
> +{
> +	if (WARN_ON(level > RME_RTT_MAX_LEVEL))
> +		return RME_PAGE_SIZE;
> +
> +	return (1UL << RME_RTT_LEVEL_SHIFT(level));
> +}
>  
>  #endif
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 22c00274884a..f29558c5dcbc 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -834,16 +834,17 @@ void stage2_unmap_vm(struct kvm *kvm)
>  void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>  {
>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
> -	struct kvm_pgtable *pgt = NULL;
> +	struct kvm_pgtable *pgt;
>  
>  	write_lock(&kvm->mmu_lock);
> +	pgt = mmu->pgt;
>  	if (kvm_is_realm(kvm) &&
>  	    kvm_realm_state(kvm) != REALM_STATE_DYING) {
> -		/* TODO: teardown rtts */
>  		write_unlock(&kvm->mmu_lock);
> +		kvm_realm_destroy_rtts(&kvm->arch.realm, pgt->ia_bits,
> +				       pgt->start_level);
>  		return;
>  	}
> -	pgt = mmu->pgt;
>  	if (pgt) {
>  		mmu->pgd_phys = 0;
>  		mmu->pgt = NULL;
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 0c9d70e4d9e6..f7b0e5a779f8 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -73,6 +73,28 @@ static int rmi_check_version(void)
>  	return 0;
>  }
>  
> +static void realm_destroy_undelegate_range(struct realm *realm,
> +					   unsigned long ipa,
> +					   unsigned long addr,
> +					   ssize_t size)
> +{
> +	unsigned long rd = virt_to_phys(realm->rd);
> +	int ret;
> +
> +	while (size > 0) {
> +		ret = rmi_data_destroy(rd, ipa);
> +		WARN_ON(ret);
> +		ret = rmi_granule_undelegate(addr);
> +
As the return value is not documented, what will happen if a page undelegate
failed? Leaked? Some explanation is required here.
> +		if (ret)
> +			get_page(phys_to_page(addr));
> +
> +		addr += PAGE_SIZE;
> +		ipa += PAGE_SIZE;
> +		size -= PAGE_SIZE;
> +	}
> +}
> +
>  static unsigned long create_realm_feat_reg0(struct kvm *kvm)
>  {
>  	unsigned long ia_bits = VTCR_EL2_IPA(kvm->arch.vtcr);
> @@ -170,6 +192,123 @@ static int realm_create_rd(struct kvm *kvm)
>  	return r;
>  }
>  
> +static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
> +			     int level, phys_addr_t rtt_granule)
> +{
> +	addr = ALIGN_DOWN(addr, rme_rtt_level_mapsize(level - 1));
> +	return rmi_rtt_destroy(rtt_granule, virt_to_phys(realm->rd), addr,
> +			level);
> +}
> +
> +static int realm_destroy_free_rtt(struct realm *realm, unsigned long addr,
> +				  int level, phys_addr_t rtt_granule)
> +{
> +	if (realm_rtt_destroy(realm, addr, level, rtt_granule))
> +		return -ENXIO;
> +	if (!WARN_ON(rmi_granule_undelegate(rtt_granule)))
> +		put_page(phys_to_page(rtt_granule));
> +
> +	return 0;
> +}
> +
> +static int realm_rtt_create(struct realm *realm,
> +			    unsigned long addr,
> +			    int level,
> +			    phys_addr_t phys)
> +{
> +	addr = ALIGN_DOWN(addr, rme_rtt_level_mapsize(level - 1));
> +	return rmi_rtt_create(phys, virt_to_phys(realm->rd), addr, level);
> +}
> +
> +static int realm_tear_down_rtt_range(struct realm *realm, int level,
> +				     unsigned long start, unsigned long end)
> +{
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	ssize_t map_size = rme_rtt_level_mapsize(level);
> +	unsigned long addr, next_addr;
> +	bool failed = false;
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		phys_addr_t rtt_addr, tmp_rtt;
> +		struct rtt_entry rtt;
> +		unsigned long end_addr;
> +
> +		next_addr = ALIGN(addr + 1, map_size);
> +
> +		end_addr = min(next_addr, end);
> +
> +		if (rmi_rtt_read_entry(rd, ALIGN_DOWN(addr, map_size),
> +				       level, &rtt)) {
> +			failed = true;
> +			continue;
> +		}
> +
> +		rtt_addr = rmi_rtt_get_phys(&rtt);
> +		WARN_ON(level != rtt.walk_level);
> +
> +		switch (rtt.state) {
> +		case RMI_UNASSIGNED:
> +		case RMI_DESTROYED:
> +			break;
> +		case RMI_TABLE:
> +			if (realm_tear_down_rtt_range(realm, level + 1,
> +						      addr, end_addr)) {
> +				failed = true;
> +				break;
> +			}
> +			if (IS_ALIGNED(addr, map_size) &&
> +			    next_addr <= end &&
> +			    realm_destroy_free_rtt(realm, addr, level + 1,
> +						   rtt_addr))
> +				failed = true;
> +			break;
> +		case RMI_ASSIGNED:
> +			WARN_ON(!rtt_addr);
> +			/*
> +			 * If there is a block mapping, break it now, using the
> +			 * spare_page. We are sure to have a valid delegated
> +			 * page at spare_page before we enter here, otherwise
> +			 * WARN once, which will be followed by further
> +			 * warnings.
> +			 */
> +			tmp_rtt = realm->spare_page;
> +			if (level == 2 &&
> +			    !WARN_ON_ONCE(tmp_rtt == PHYS_ADDR_MAX) &&
> +			    realm_rtt_create(realm, addr,
> +					     RME_RTT_MAX_LEVEL, tmp_rtt)) {
> +				WARN_ON(1);
> +				failed = true;
> +				break;
> +			}
> +			realm_destroy_undelegate_range(realm, addr,
> +						       rtt_addr, map_size);
> +			/*
> +			 * Collapse the last level table and make the spare page
> +			 * reusable again.
> +			 */
> +			if (level == 2 &&
> +			    realm_rtt_destroy(realm, addr, RME_RTT_MAX_LEVEL,
> +					      tmp_rtt))
> +				failed = true;
> +			break;
> +		case RMI_VALID_NS:
> +			WARN_ON(rmi_rtt_unmap_unprotected(rd, addr, level));
> +			break;
> +		default:
> +			WARN_ON(1);
> +			failed = true;
> +			break;
> +		}
> +	}
> +
> +	return failed ? -EINVAL : 0;
> +}
> +
> +void kvm_realm_destroy_rtts(struct realm *realm, u32 ia_bits, u32 start_level)
> +{
> +	realm_tear_down_rtt_range(realm, start_level, 0, (1UL << ia_bits));
> +}
> +
>  /* Protects access to rme_vmid_bitmap */
>  static DEFINE_SPINLOCK(rme_vmid_lock);
>  static unsigned long *rme_vmid_bitmap;

