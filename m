Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A3CC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 17:46:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9DE24B1BC;
	Wed,  8 Dec 2021 12:46:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AaUy+n5rpYni; Wed,  8 Dec 2021 12:46:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FC964B133;
	Wed,  8 Dec 2021 12:46:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E6204B12C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 12:46:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dC-LaI4bBgwg for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 12:46:01 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 40DF74B11F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 12:46:01 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id A62BEB82213;
 Wed,  8 Dec 2021 17:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9759FC341C8;
 Wed,  8 Dec 2021 17:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638985558;
 bh=Jx3EOS//BNcop0ND7pQzMMlMr2gVDNuw8TQ5ywrclRc=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=kmNzrKQ3OnYmFnZ2a4Jomabp/a9q/yYrr0HjxsL29TK/HKq9JbbwZ3ySIjYUnI/Rf
 9O1tlLVZmTmyMHxOO88CIxcuz8XvMCTo0yCShgw/35w7i7O3ws/48jZJefRhAgwz1d
 2ZQUnXOH0H+xQstckdT5qaf83wv9Yg8QFtNbdzYH3jalwUGAn/tS+eLDhVSgG/lv3j
 JeAlClg3O55KUtlt74R5f607wI7FCCW02YiBl3GRebbX9Hvdd+zodgSzOV26+fDADx
 1jPUJ2W4SSRHLld+gDMtUlGqszKEh/60YvQ+/SDYjprSMVmzV2bcXHjgH44C9sZ/sR
 rRB2DSjDB6ggg==
Date: Wed, 8 Dec 2021 17:45:53 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH 4/6] KVM: arm64: Make __io_map_base static
Message-ID: <20211208174552.GD820@willie-the-truck>
References: <20211208152300.2478542-1-qperret@google.com>
 <20211208152300.2478542-5-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211208152300.2478542-5-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, Dec 08, 2021 at 03:22:57PM +0000, Quentin Perret wrote:
> The __io_map_base variable is used at EL2 to track the end of the
> hypervisor's "private" VA range in nVHE protected mode. However it
> doesn't need to be used outside of mm.c, so let's make it static to keep
> all the hyp VA allocation logic in one place.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/mm.h | 1 -
>  arch/arm64/kvm/hyp/nvhe/mm.c         | 3 ++-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> index 3f60d6cc5368..2d08510c6cc1 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> @@ -12,7 +12,6 @@
>  
>  extern struct kvm_pgtable pkvm_pgtable;
>  extern hyp_spinlock_t pkvm_pgd_lock;
> -extern u64 __io_map_base;
>  
>  int hyp_create_idmap(u32 hyp_va_bits);
>  int hyp_map_vectors(void);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index 9e0ff5a700dd..526a7d6fa86f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> @@ -19,11 +19,12 @@
>  
>  struct kvm_pgtable pkvm_pgtable;
>  hyp_spinlock_t pkvm_pgd_lock;
> -u64 __io_map_base;
>  
>  struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
>  unsigned int hyp_memblock_nr;
>  
> +static u64 __io_map_base;
> +
>  static int __pkvm_create_mappings(unsigned long start, unsigned long size,
>  				  unsigned long phys, enum kvm_pgtable_prot prot)

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
