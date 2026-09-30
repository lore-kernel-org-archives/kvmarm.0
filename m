Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0ABEED8;
	Wed, 30 Sep 2026 00:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790727907; cv=none; b=sanGU6i/avOizHKSix94dvzR5RVMBNv66tDgx4t/sQkmgw8BE2LKgbVbi6ZcTD+KZqpADUFFbPrdti6ipEv2cRWxHAlVYdZbD/BsE7PeMUExo40oHLv7HoIfkeuTazPP9g8+Yw2kagJLmaZSgdL2RAOYxbkopWuaT+erTL88oZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790727907; c=relaxed/simple;
	bh=I1qDs9BDbcfwaj01gAmb+tRsK8kiWxN+rVkQEeUsac4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NqdwwSZCtTw/ZctYAOP2Qo24vhQdlxQt1kFuTkFOcZwWdR9V4Eh2nPVi9rctkrlduefPI/b6edQnGVVOtXX60Cu9FqdsxKPEsYFaMR133a8HDlhTT3cJt1S4b+keg7pToAHRoDY5QRLHRSd3ELSNJEFl2JNqypncASyG9fg054s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NC3wN3NI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NC3wN3NI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811F51F00899;
	Wed, 30 Sep 2026 00:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790727905;
	bh=3qjgKogqDJ4nU3WCcsiVuj/fs6MGqUehEm1aDK84/10=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NC3wN3NI6FGYkISLfmTPBTbQQ/lHzXUmcmXJy+yeHqcy3I63kghmoSWxVnM8GqZ1F
	 QAEuW772CeWzvRKQhjdZLeVNj2WCkTUYSc+Hpf53kInALjM0XRCPzN0SlvVPHSyPdg
	 19F54EGZI+vUJB+7OLplFQJa5s5EaP22fv6wxSTWS7eK1eKLqH4UGOYT8o8BL5+Cra
	 CoELMHbRU6v3bl4oXYDPdSsSxw0KcP05Imr7fAdopv+pxcND2/a6JT4rGXxKDT7H/Y
	 E8+D825YrmbSNdKIq5se6Xu0H2n8GAPUbuTxmcICepRpHCPVIPqowOBLdwsJ3D9Wb9
	 Ry3E/HpEbNZrg==
Date: Tue, 29 Sep 2026 17:25:04 -0700
From: Oliver Upton <oupton@kernel.org>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	corbet@lwn.net, pbonzini@redhat.com, leo.bras@arm.com,
	yuzenghui@huawei.com, wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com, caijian11@h-partners.com,
	liuyonglong@huawei.com, tangchengchang@huawei.com,
	yezhenyu2@huawei.com, yubihong@huawei.com, linuxarm@huawei.com,
	joey.gouly@arm.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, fuad.tabba@linux.dev,
	mark.rutland@arm.com, seanjc@google.com, rdunlap@infradead.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v5 01/15] KVM: arm64: pgtables: Change write bit from
 S2AP_W to DBM
Message-ID: <arxW4PUY3qqRkogl@kernel.org>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-2-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929103655.85107-2-zhengtian10@huawei.com>

Hi Tian,

On Tue, Sep 29, 2026 at 06:36:41PM +0800, Tian Zheng wrote:
> From: Leonardo Bras <leo.bras@arm.com>
> 
> As a first step of changing the encoding for the Stage2 PTE descriptor,
> introduce the DBM bit, and adapt every usage of writable to use the DBM
> bit (51) instead of S2AP[1]/Dirty bit (7).
> 
> With DBM as the write permission bit and S2AP[1] as the dirty state,
> the encoding follows the FEAT_S2PIE principle of managing permissions
> and dirty state independently.
> 
> For this step, we convert usages of RW(Dirty) -> WD(DBM|Dirty): every
> writable mapping sets both bits, read-only mappings clear both, and no
> behaviour changes.
> 
> Link: https://lore.kernel.org/all/20260901171558.2674031-2-leo.bras@arm.com/
> Signed-off-by: Leonardo Bras <leo.bras@arm.com>
> [zhengtian: keep the nested walker reading writability from S2AP[1]
> alone, document why, and reword the commit message]
> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 3 +++
>  arch/arm64/kvm/hyp/pgtable.c         | 7 ++++---
>  arch/arm64/kvm/nested.c              | 5 +++++
>  arch/arm64/kvm/ptdump.c              | 4 ++--
>  4 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 41a8687938eb..37baa86d6fd8 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -93,10 +93,13 @@ typedef u64 kvm_pte_t;
> 
>  #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)
> 
> +#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
> +
>  #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
> 
>  #define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
>  					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
> +					 KVM_PTE_LEAF_ATTR_HI_S2_DBM | \
>  					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
> 
>  /* pKVM invalid pte encodings */
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b74dd5ce1efd..50f4d3a74f77 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -732,7 +732,7 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
>  		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> 
>  	if (prot & KVM_PGTABLE_PROT_W)
> -		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;

Hmm... I'd actually like to see this structured where the "write" bit
could either be S2AP_W or DBM depending on if the system supports
FEAT_HAFDBS. Look at how HVHE is handled for selecting the right AP
encoding for the hyp stage-1 page tables.

> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index 69899797dbad..b0cb8d84a9e9 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -40,8 +40,8 @@ static const struct ptdump_prot_bits stage2_pte_bits[] = {
>  		.clear	= " ",
>  	},
>  	{
> -		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
> -		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
> +		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_DBM,
> +		.val	= KVM_PTE_LEAF_ATTR_HI_S2_DBM,
>  		.set	= "W",
>  		.clear	= " ",
>  	},
> --
> 2.43.0
> 
