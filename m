Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6753A38837F
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 11:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783941443; cv=none; b=Gux6iyaJcNOLljg3tIRzT27LEWau7U5LWUhuasJmC5xa8BAyKXB+b8dS3WPMNPYy9uaglzBsaGhGKWta9SrCuvZ9MG5JdCE3QkHZKiNbQPgZkYfVtbIDi819vfoqL2ggZb86sCiQKL+JxFepiTlb3/3IhNGNg3kxbUk0gdJpCfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783941443; c=relaxed/simple;
	bh=E779sGiLUlh/9E4uWGKqHbSascm4LusE0eTu206KYNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=HzuPYRFI5+Xc9+oLmcAC/u1VUtWi/0ihM63GWsZPgHTf4y2bxsBK6q7CkxFlI1VNp2pquo2X1v8UIlcvzb+jnWNzImW34yjE9xATBSkqPrnDa600S45c+Aj4ycfch/abvq2XF7xJT+eD9tNt8hLAv8zE9Z1Gw/GlYTmM5rIxqts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EYB2xZPX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EYB2xZPX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75C29153B;
	Mon, 13 Jul 2026 04:17:16 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D12173F7B4;
	Mon, 13 Jul 2026 04:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783941440; bh=E779sGiLUlh/9E4uWGKqHbSascm4LusE0eTu206KYNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYB2xZPX4tsfDATUmDOiua1ROO6SUYN8dm74aY14KKpS6jZMibNO3nmvuGMngYSuQ
	 uFNg1YLuOpUEKmc4XfBN31YpznfcBJk+MGQpMcxIKuEqO4nwqXyc1+QEnSoMTsXbSe
	 gpN7L2pvG3niRfkbfDCIB/mCW46xIGF4/I0GxQA0=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v4 3/6] KVM: arm64: Add auto DBM support for hardware dirty tracking
Date: Mon, 13 Jul 2026 12:17:15 +0100
Message-ID: <alTJOy8Sv4aAp_9y@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260709104026.2612599-4-zhengtian10@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com> <20260709104026.2612599-4-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Jul 09, 2026 at 06:40:23PM +0800, Tian Zheng wrote:
> The DBM (Dirty Bit Modifier) attribute, introduced in ARMv8.1, enables
> hardware to automatically promote write-clean pages to write-dirty. This
> prevents the guest from being trapped in EL2 due to missing write
> permissions.
> 
> In this design, DBM is controlled by the page-table level flag
> KVM_PGTABLE_S2_DBM rather than per-PTE software flags. DBM is
> automatically set for writable non-device pages when the page-table has
> KVM_PGTABLE_S2_DBM flag, which is determined at MMU init time based on
> hardware capability.
> 
> The DBM bit is set in stage2_set_prot_attr() for initial mappings and
> hugepage splitting, and directly manipulated in
> kvm_pgtable_stage2_relax_perms() when removing write-protection. On
> W->RO downgrade, DBM is cleared to prevent hardware from silently
> upgrading RO+DBM back to W+dirty, which would bypass KVM's write
> tracking.
> 
> kvm_pgtable_stage2_pte_prot() does not extract the DBM bit back into
> enum kvm_pgtable_prot because DBM is a page-table policy determined by
> pgt->flags, not a per-PTE property. Callers should check
> pgt->flags & KVM_PGTABLE_S2_DBM instead.
> 
> This ensures DBM is consistently applied across all PTEs, including
> during hugepage splitting where child PTEs inherit DBM from the parent
> block entry via the pgt->flags mechanism.
> 
> Safety: DBM bit is only interpreted by hardware when VTCR_EL2.HD=1.
> When HDBSS is not enabled (HD=0), ARM architecture guarantees hardware
> completely ignores DBM bit in PTEs.
> 
> Co-developed-by: Eillon <yezhenyu2@huawei.com>
> Signed-off-by: Eillon <yezhenyu2@huawei.com>
> Co-developed-by: Leonardo Bras <leo.bras@arm.com>
> Signed-off-by: Leonardo Bras <leo.bras@arm.com>

Hello Tian,

Have you added the above tags due to this patch being based on the below?
https://lore.kernel.org/all/20260629111820.1873540-2-leo.bras@arm.com/

Thanks!
Leo


> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  4 ++++
>  arch/arm64/kvm/hyp/pgtable.c         | 35 ++++++++++++++++++++++++++--
>  arch/arm64/kvm/mmu.c                 |  3 +++
>  3 files changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 41a8687938eb..5e0fac4bfa53 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -93,6 +93,8 @@ typedef u64 kvm_pte_t;
> 
>  #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)
> 
> +#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
> +
>  #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
> 
>  #define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
> @@ -249,10 +251,12 @@ struct kvm_pgtable_mm_ops {
>   * enum kvm_pgtable_stage2_flags - Stage-2 page-table flags.
>   * @KVM_PGTABLE_S2_IDMAP:	Only use identity mappings.
>   * @KVM_PGTABLE_S2_AS_S1:	Final memory attributes are that of Stage-1.
> + * @KVM_PGTABLE_S2_DBM:	Hardware-managed DBM for writable pages.
>   */
>  enum kvm_pgtable_stage2_flags {
>  	KVM_PGTABLE_S2_IDMAP			= BIT(0),
>  	KVM_PGTABLE_S2_AS_S1			= BIT(1),
> +	KVM_PGTABLE_S2_DBM			= BIT(2),
>  };
> 
>  /**
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 91a7dfad6686..21ec456ecc41 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -731,9 +731,23 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
>  	if (prot & KVM_PGTABLE_PROT_R)
>  		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> 
> -	if (prot & KVM_PGTABLE_PROT_W)
> +	if (prot & KVM_PGTABLE_PROT_W) {
>  		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> 
> +		/*
> +		 * Set DBM bit for writable non-device pages if the page-table
> +		 * has KVM_PGTABLE_S2_DBM flag (system supports HDBSS).
> +		 *
> +		 * For stage 2 translations using Indirect permissions, if the
> +		 * Effective value of VTCR_EL2.HD is 0, then dirty state is
> +		 * managed by software. Hardware only updates the dirty state
> +		 * when VTCR_EL2.HD=1 (HDBSS enabled).
> +		 */
> +		if ((pgt->flags & KVM_PGTABLE_S2_DBM) &&
> +		    !(prot & KVM_PGTABLE_PROT_DEVICE))
> +			attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> +	}
> +
>  	if (!kvm_lpa2_is_enabled())
>  		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
> 
> @@ -1367,9 +1381,26 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>  	if (prot & KVM_PGTABLE_PROT_R)
>  		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> 
> -	if (prot & KVM_PGTABLE_PROT_W)
> +	if (prot & KVM_PGTABLE_PROT_W) {
>  		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> 
> +		/*
> +		 * No DEVICE filter needed here: relax_perms is only called
> +		 * on FSC_PERM faults. Device pages always get full RW from
> +		 * initial mapping and are never write-protected during
> +		 * migration, so they never trigger a permission fault.
> +		 */
> +		if (pgt->flags & KVM_PGTABLE_S2_DBM)
> +			set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> +	} else {
> +		/*
> +		 * Clear DBM on W→RO downgrade to prevent hardware from
> +		 * silently upgrading RO+DBM back to W+dirty, which would
> +		 * bypass KVM's write tracking and cause data corruption.
> +		 */
> +		clr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> +	}
> +
>  	ret = stage2_set_xn_attr(prot, &xn);
>  	if (ret)
>  		return ret;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index e086c01a9325..346efed6e605 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1014,6 +1014,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>  	if (err)
>  		goto out_free_pgtable;
> 
> +	if (system_supports_hdbss())
> +		pgt->flags |= KVM_PGTABLE_S2_DBM;
> +
>  	mmu->pgt = pgt;
>  	if (is_protected_kvm_enabled())
>  		return 0;
> --
> 2.33.0
> 
