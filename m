Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8323C433E6
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 16:36:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2AFCF64F26
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 16:36:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AFCF64F26
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B795F4B679;
	Mon, 15 Mar 2021 12:36:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id piDTOUGMwtCe; Mon, 15 Mar 2021 12:36:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A6044B65D;
	Mon, 15 Mar 2021 12:36:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FF584B659
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 12:36:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7VHpYEaykZtT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 12:36:27 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 21DF94B3EB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 12:36:27 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68FD764F2A;
 Mon, 15 Mar 2021 16:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615826185;
 bh=1Xwscs3ewFC/ckcZe2Mub61AbvcLlOZQm3jYjGo/Hps=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ftzkhVltLnJUDH+nslYFoDibNxchiIwqSBYAUyqmUoyhKSpgMDUw7gZ00SxPD/pRz
 x7rQjqklacB+cNMb53guaeOxIX44Mk1oKTS7FxAZwIP6PEopHnHSelS3tVWvAj80yD
 i3foenEICDDkEXvU7xs31FDEjJExZV2+Ojfj7SptG84iWLgbQw2JHYdIkeWHz7WO+c
 jzP7oxaRVCISCyU3EwXoJy/XIhxPto+N+dEKrZXXa2DSJNOaokpeZBGFnhcMNVMaDk
 /uwayLS3iXaCPBamwUps2QVNsoF7dTEMN4APU3MuBHJsj6KhonXZNTlS01h0Z2GgMx
 3VSgaaJf9KEmg==
Date: Mon, 15 Mar 2021 16:36:19 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v5 29/36] KVM: arm64: Use page-table to track page
 ownership
Message-ID: <20210315163618.GF3430@willie-the-truck>
References: <20210315143536.214621-1-qperret@google.com>
 <20210315143536.214621-30-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210315143536.214621-30-qperret@google.com>
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

On Mon, Mar 15, 2021 at 02:35:29PM +0000, Quentin Perret wrote:
> As the host stage 2 will be identity mapped, all the .hyp memory regions
> and/or memory pages donated to protected guestis will have to marked
> invalid in the host stage 2 page-table. At the same time, the hypervisor
> will need a way to track the ownership of each physical page to ensure
> memory sharing or donation between entities (host, guests, hypervisor) is
> legal.
> 
> In order to enable this tracking at EL2, let's use the host stage 2
> page-table itself. The idea is to use the top bits of invalid mappings
> to store the unique identifier of the page owner. The page-table owner
> (the host) gets identifier 0 such that, at boot time, it owns the entire
> IPA space as the pgd starts zeroed.
> 
> Provide kvm_pgtable_stage2_set_owner() which allows to modify the
> ownership of pages in the host stage 2. It re-uses most of the map()
> logic, but ends up creating invalid mappings instead. This impacts
> how we do refcount as we now need to count invalid mappings when they
> are used for ownership tracking.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  21 +++++
>  arch/arm64/kvm/hyp/pgtable.c         | 127 ++++++++++++++++++++++-----
>  2 files changed, 124 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 4ae19247837b..683e96abdc24 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -238,6 +238,27 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  			   u64 phys, enum kvm_pgtable_prot prot,
>  			   void *mc);
>  
> +/**
> + * kvm_pgtable_stage2_set_owner() - Annotate invalid mappings with metadata
> + *				    encoding the ownership of a page in the
> + *				    IPA space.

The function does more than this, though, as it will also go ahead and unmap
existing valid mappings which I think should be mentioned here, no?

> +int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
> +				 void *mc, u8 owner_id)
> +{
> +	int ret;
> +	struct stage2_map_data map_data = {
> +		.phys		= KVM_PHYS_INVALID,
> +		.mmu		= pgt->mmu,
> +		.memcache	= mc,
> +		.mm_ops		= pgt->mm_ops,
> +		.owner_id	= owner_id,
> +	};
> +	struct kvm_pgtable_walker walker = {
> +		.cb		= stage2_map_walker,
> +		.flags		= KVM_PGTABLE_WALK_TABLE_PRE |
> +				  KVM_PGTABLE_WALK_LEAF |
> +				  KVM_PGTABLE_WALK_TABLE_POST,
> +		.arg		= &map_data,
> +	};
> +
> +	if (owner_id > KVM_MAX_OWNER_ID)
> +		return -EINVAL;
> +
> +	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
> +	dsb(ishst);

Why is the DSB needed here? afaict, we only ever unmap a valid entry (which
will have a DSB as part of the TLBI sequence) or we update the owner for an
existing invalid entry, in which case the walker doesn't care.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
