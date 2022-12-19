Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0416FB4
	for <kvmarm@lists.linux.dev>; Mon, 19 Dec 2022 19:45:56 +0000 (UTC)
Date: Mon, 19 Dec 2022 19:45:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1671479149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KILJmguHjqQ6SByYTuCuINiGP5uaLk6cxMS8sOPjn0c=;
	b=UfsgUfhaKwCbijceLCFVlsniHw9mVLe92O73X3euqvwK/tvJJ2CqD8V/7eFD4ARw29WQR1
	pTc5kpTexZK235ggECEhD+EDZob46yI6/gEiSer2XrUOMQdRojyFehkN6it7ws5H3BlvPc
	slZRldJaA9A8izfOqzfwYG+BqoQpzK8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v1 05/12] KVM: arm64: Maintain page-table format info in
 struct kvm_pgtable
Message-ID: <Y6C/aACDK8rrF6df@google.com>
References: <20221206135930.3277585-1-ryan.roberts@arm.com>
 <20221206135930.3277585-6-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206135930.3277585-6-ryan.roberts@arm.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221219194544.EHR3D_KYT9_oLT1sR0Z56gaytEIU8Cp8xmYhn9CBGIA@z>

Hi Ryan,

On Tue, Dec 06, 2022 at 01:59:23PM +0000, Ryan Roberts wrote:
> As the next step on the journey to supporting FEAT_LPA2 in KVM, add a
> flag to struct kvm_pgtable, which functions can then use to select the
> approprate behavior for either the `classic` or `lpa2` page-table
> formats. For now, all page-tables remain in the `classic` format.
> 
> No functional changes are intended.
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 2 ++
>  arch/arm64/kvm/hyp/pgtable.c         | 2 ++
>  arch/arm64/kvm/mmu.c                 | 1 +
>  3 files changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 2247ed74871a..744e224d964b 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -157,6 +157,7 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
>   * @start_level:	Level at which the page-table walk starts.
>   * @pgd:		Pointer to the first top-level entry of the page-table.
>   * @mm_ops:		Memory management callbacks.
> + * @lpa2_ena:		Format used for page-table; false->classic, true->lpa2.

I'd prefer that we describe the paging structure purely in terms of
input and output address. If you add the latter it should be possible to
decide if LPA2 is actually in use.

(i.e. PAGE_SIZE != SZ_64K && pgt->oa_bits > 48)

--
Thanks,
Oliver
