Return-Path: <SRS0=pwNx=IP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDFBC433E6
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 14:42:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 23EE364F50
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 14:42:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23EE364F50
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E5C94B5F2;
	Wed, 17 Mar 2021 10:42:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VMT23YJLo+Rd; Wed, 17 Mar 2021 10:42:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0D504B640;
	Wed, 17 Mar 2021 10:42:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 520654B5F2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 10:42:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7Z3alGtz77hK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Mar 2021 10:42:54 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 375E04B581
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 10:42:54 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id B973564F69;
 Wed, 17 Mar 2021 14:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615992173;
 bh=zYeJEe+1T7U7FbkjlOOSfPVIwk/cDkVQk58lJ9Xg7wI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=MYjxLi1MA2lcM3Z1mTuAs/Q/gY5RJnCGdsb4y1jndOdKfT00MFr2Z2oJxe1G7GKpI
 UaGC3RrUohWq62gZotVwrCFTAwNZ3wiRX6udcTSMsbgkHMpd3vv5xDMIwf4WdTMaTh
 uYWRDTNyahxFmxihcGt+axuLrRcn5exdIab09vzv7Q0b49axWZx6MNwUF8o+6F4FEn
 6CFM24Lssc+cBvrj9cXd10xscbTRBOTgPcWuoURSp0tAXl/sY/HP1tqx5eOb9e2WHZ
 aU7ZgKcSqsPvpv/ub50dTPXkyorxUF1Rf+tc2vlr2Lk1EAsbbsAVNvSbW/k3TWP+yC
 qYph4wtzdsAog==
Date: Wed, 17 Mar 2021 14:42:46 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Introduce KVM_PGTABLE_S2_NOFWB Stage-2
 flag
Message-ID: <20210317144246.GE5393@willie-the-truck>
References: <20210315143536.214621-34-qperret@google.com>
 <20210317141714.383046-1-qperret@google.com>
 <20210317141714.383046-2-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210317141714.383046-2-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Wed, Mar 17, 2021 at 02:17:13PM +0000, Quentin Perret wrote:
> In order to further configure stage-2 page-tables, pass flags to the
> init function using a new enum.
> 
> The first of these flags allows to disable FWB even if the hardware
> supports it as we will need to do so for the host stage-2.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> 
> ---
> 
> One question is, do we want to use stage2_has_fwb() everywhere, including
> guest-specific paths (e.g. kvm_arch_prepare_memory_region(), ...) ?
> 
> That'd make this patch more intrusive, but would make the whole codebase
> work with FWB enabled on a guest by guest basis. I don't see us use that
> anytime soon (other than maybe debug of some sort?) but it'd be good to
> have an agreement.

I don't see the value in spreading this everywhere for now.

>  arch/arm64/include/asm/kvm_pgtable.h  | 19 +++++++++--
>  arch/arm64/include/asm/pgtable-prot.h |  4 +--
>  arch/arm64/kvm/hyp/pgtable.c          | 49 +++++++++++++++++----------
>  3 files changed, 50 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index b93a2a3526ab..7382bdfb6284 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -56,6 +56,15 @@ struct kvm_pgtable_mm_ops {
>  	phys_addr_t	(*virt_to_phys)(void *addr);
>  };
>  
> +/**
> + * enum kvm_pgtable_stage2_flags - Stage-2 page-table flags.
> + * @KVM_PGTABLE_S2_NOFWB:	Don't enforce Normal-WB even if the CPUs have
> + *				ARM64_HAS_STAGE2_FWB.
> + */
> +enum kvm_pgtable_stage2_flags {
> +	KVM_PGTABLE_S2_NOFWB			= BIT(0),
> +};
> +
>  /**
>   * struct kvm_pgtable - KVM page-table.
>   * @ia_bits:		Maximum input address size, in bits.
> @@ -72,6 +81,7 @@ struct kvm_pgtable {
>  
>  	/* Stage-2 only */
>  	struct kvm_s2_mmu			*mmu;
> +	enum kvm_pgtable_stage2_flags		flags;
>  };
>  
>  /**
> @@ -201,11 +211,16 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
>   * @arch:	Arch-specific KVM structure representing the guest virtual
>   *		machine.
>   * @mm_ops:	Memory management callbacks.
> + * @flags:	Stage-2 configuration flags.
>   *
>   * Return: 0 on success, negative error code on failure.
>   */
> -int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_arch *arch,
> -			    struct kvm_pgtable_mm_ops *mm_ops);
> +int kvm_pgtable_stage2_init_flags(struct kvm_pgtable *pgt, struct kvm_arch *arch,
> +				  struct kvm_pgtable_mm_ops *mm_ops,
> +				  enum kvm_pgtable_stage2_flags flags);
> +
> +#define kvm_pgtable_stage2_init(pgt, arch, mm_ops) \
> +	kvm_pgtable_stage2_init_flags(pgt, arch, mm_ops, 0)

nit: I think some of the kerneldoc refers to "kvm_pgtable_stage_init()"
so that needs a trivial update to e.g. "kvm_pgtable_stage_init*()".

> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
> index 046be789fbb4..beeb722a82d3 100644
> --- a/arch/arm64/include/asm/pgtable-prot.h
> +++ b/arch/arm64/include/asm/pgtable-prot.h
> @@ -72,10 +72,10 @@ extern bool arm64_use_ng_mappings;
>  #define PAGE_KERNEL_EXEC	__pgprot(PROT_NORMAL & ~PTE_PXN)
>  #define PAGE_KERNEL_EXEC_CONT	__pgprot((PROT_NORMAL & ~PTE_PXN) | PTE_CONT)
>  
> -#define PAGE_S2_MEMATTR(attr)						\
> +#define PAGE_S2_MEMATTR(attr, has_fwb)					\
>  	({								\
>  		u64 __val;						\
> -		if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))		\
> +		if (has_fwb)						\
>  			__val = PTE_S2_MEMATTR(MT_S2_FWB_ ## attr);	\
>  		else							\
>  			__val = PTE_S2_MEMATTR(MT_S2_ ## attr);		\

Can you take the pgt structure instead of a bool here, or does it end up
being really ugly?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
