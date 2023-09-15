Received: from out-228.mta0.migadu.com (out-228.mta0.migadu.com [91.218.175.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E12518E1B
	for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 22:54:11 +0000 (UTC)
Date: Fri, 15 Sep 2023 22:54:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1694818449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KidOv9DSZAjEZIZG6nwJqS8LlzxpoGzMBkcO8YHnSf0=;
	b=WpMdNxCJephGV00l0B7yPCHwJbcig2u/mPAQIlQXMhAkBzaV71kc9ZStGjZVb0J8KxbB4H
	wmahZeT7OIkpM11aCJLlk6M1LnDM4sA59JYyM+fE7lzL1PjC8WYDJe3ZPwI4mdCC5r1tZi
	6uhV6toXbUvDDuFW9mRy1Yv/jLvKVlM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, zhukeqian1@huawei.com,
	jonathan.cameron@huawei.com, linuxarm@huawei.com
Subject: Re: [RFC PATCH v2 4/8] KVM: arm64: Set DBM for previously writeable
 pages
Message-ID: <ZQTgi/lsClyM6b1j@linux.dev>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-5-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230825093528.1637-5-shameerali.kolothum.thodi@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 25, 2023 at 10:35:24AM +0100, Shameer Kolothum wrote:
> We only set DBM if the page is writeable (S2AP[1] == 1). But once migration
> starts, CLEAR_LOG path will write protect the pages (S2AP[1] = 0) and there
> isn't an easy way to differentiate the writeable pages that gets write
> protected from read-only pages as we only have S2AP[1] bit to check.
> 
> Introduced a ctx->flag KVM_PGTABLE_WALK_WC_HINT to identify the dirty page
> tracking related write-protect page table walk and used one of the "Reserved
> for software use" bit in page descriptor to mark a page as "writeable-clean". 
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  5 +++++
>  arch/arm64/kvm/hyp/pgtable.c         | 25 ++++++++++++++++++++++---
>  2 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index a12add002b89..67bcbc5984f9 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -190,6 +190,8 @@ enum kvm_pgtable_prot {
>  #define KVM_PGTABLE_PROT_RW	(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
>  #define KVM_PGTABLE_PROT_RWX	(KVM_PGTABLE_PROT_RW | KVM_PGTABLE_PROT_X)
>  
> +#define KVM_PGTABLE_PROT_WC	KVM_PGTABLE_PROT_SW0  /*write-clean*/
> +
>  #define PKVM_HOST_MEM_PROT	KVM_PGTABLE_PROT_RWX
>  #define PKVM_HOST_MMIO_PROT	KVM_PGTABLE_PROT_RW
>  
> @@ -221,6 +223,8 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
>   *					operations required.
>   * @KVM_PGTABLE_WALK_HW_DBM:		Indicates that the attribute update is
>   *					HW DBM related.
> + * @KVM_PGTABLE_WALK_WC_HINT:		Update the page as writeable-clean(software attribute)
> + *					if we are write protecting a writeable page.

This really looks like a permission bit, not a walker flag. This should
be defined in kvm_pgtable_prot and converted to the hardware definition
in stage2_set_prot_attr(). Also, the first time I saw 'WC' I read it as
'write-combine', not writable-clean.

As I understand it, the only need for an additional software bit here is
to identify neighboring PTEs that can have DBM set while we're in the
middle of the walk right?

-- 
Thanks,
Oliver
