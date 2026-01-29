Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A072D63E8
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 17:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769706176; cv=none; b=Q3H7pvYJafwHa/ONCbNzJgbsddLZfIXjJ5VIJ6bHeuiZqugRPKSdK/STv+58tpuBE0HAkvo+0T5VKPRt8+pPEkPEGLcbLKfApP6f1vWMmxZpOPdNv2FtXG7j4n6tE8XXZzoKCFxPGORBOuYr9b6+Xipgt9kz2LBVlkCyPt9+1tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769706176; c=relaxed/simple;
	bh=q1gQCviJCAe+AZSj756VfNj4A1hZWH1AR6+aLsFTsRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=mvbQNVoULdJXjGlFr1XBKRKSUcOUjlnvvB5/i39szzoMoQkS7/Mu3dr84aQhoKEJsYDREHkwi/w/Zx93/a5u9sAwy5WoG2YuG4lFCBvDwejwLZeAQPN4kPL/uNugE94cSqT+uEM/8ce/gksj7ZXJBOKX1obVzphJaJsuieqW2ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E7529153B;
	Thu, 29 Jan 2026 09:02:46 -0800 (PST)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 070FB3F73F;
	Thu, 29 Jan 2026 09:02:50 -0800 (PST)
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oliver.upton@linux.dev,
	catalin.marinas@arm.com,
	corbet@lwn.net,
	pbonzini@redhat.com,
	will@kernel.org,
	linux-kernel@vger.kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yezhenyu2@huawei.com,
	xiexiangyou@huawei.com,
	zhengchuan@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v2 2/5] KVM: arm64: Support set the DBM attr during memory abort
Date: Thu, 29 Jan 2026 17:02:41 +0000
Message-ID: <aXuSsVKtXBcffzo2@devkitleo>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121092342.3393318-3-zhengtian10@huawei.com>
References: <20251121092342.3393318-1-zhengtian10@huawei.com> <20251121092342.3393318-3-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Nov 21, 2025 at 05:23:39PM +0800, Tian Zheng wrote:
> From: eillon <yezhenyu2@huawei.com>
> 
> Add DBM support to automatically promote write-clean pages to
> write-dirty, preventing users from being trapped in EL2 due to
> missing write permissions.
> 
> Since the DBM attribute was introduced in ARMv8.1 and remains
> optional in later architecture revisions, including ARMv9.5.
> 
> Support set the DBM attr during user_mem_abort().
> 
> Signed-off-by: eillon <yezhenyu2@huawei.com>
> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 4 ++++
>  arch/arm64/kvm/hyp/pgtable.c         | 6 ++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 2888b5d03757..2fa24953d1a6 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -91,6 +91,8 @@ typedef u64 kvm_pte_t;
> 
>  #define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
> 
> +#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
> +
>  #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
> 
>  #define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
> @@ -245,6 +247,7 @@ enum kvm_pgtable_stage2_flags {
>   * @KVM_PGTABLE_PROT_R:		Read permission.
>   * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
>   * @KVM_PGTABLE_PROT_NORMAL_NC:	Normal noncacheable attributes.
> + * @KVM_PGTABLE_PROT_DBM:	Dirty bit management attribute.
>   * @KVM_PGTABLE_PROT_SW0:	Software bit 0.
>   * @KVM_PGTABLE_PROT_SW1:	Software bit 1.
>   * @KVM_PGTABLE_PROT_SW2:	Software bit 2.
> @@ -257,6 +260,7 @@ enum kvm_pgtable_prot {
> 
>  	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
>  	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(4),
> +	KVM_PGTABLE_PROT_DBM			= BIT(5),
> 
>  	KVM_PGTABLE_PROT_SW0			= BIT(55),
>  	KVM_PGTABLE_PROT_SW1			= BIT(56),
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index c351b4abd5db..ce41c6924ebe 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -694,6 +694,9 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
>  	if (prot & KVM_PGTABLE_PROT_W)
>  		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> 
> +	if (prot & KVM_PGTABLE_PROT_DBM)
> +		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> +
>  	if (!kvm_lpa2_is_enabled())
>  		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
> 
> @@ -1303,6 +1306,9 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>  	if (prot & KVM_PGTABLE_PROT_W)
>  		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> 
> +	if (prot & KVM_PGTABLE_PROT_DBM)
> +		set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> +
>  	if (prot & KVM_PGTABLE_PROT_X)
>  		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
> 


Hi Tian,

I was re-reading this series while planning the other feature I am working 
on top of this one.

This patch, IMHO, is unrelated to the HDBSS feature.
I get that HDBSS feature needs this bit being set in the page descriptor
but it was not introduced in this feature.

It was actually introduced in HAFDBS.

So maybe it's worth to split this series in:
- Enable HAFDBS for KVM, and
- Enable HDBSS

I have something here that could serve as a base for that, will clean that 
up and send as an example.

Thanks!
Leo
