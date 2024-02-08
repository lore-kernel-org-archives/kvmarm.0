Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EF41762EA
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 13:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707397269; cv=none; b=FYGTrOQt3tE7pq44eHMk9gQmtj6fXPkYgDHlGXDpFrx/skn36hhjrO+5aOS2PymskGZUKBvQpcByWeRglo2bXYMbnVELvzkYX4pT3ngpkkkGaugWzakqiUVanQHjN5tdvzpLaNxbpoBqhWv+8z/VrhoIRIMgnTTv0Dw2jwWF300=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707397269; c=relaxed/simple;
	bh=MBMsm5Hty7waMz69tLQDq3T7dLAK/n2/fSO/BF9P+Ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WjTDQ4q7cK8NUkcVdTEqVhNRQw0FoaJlWiKu9ojdf/AUJIjJAyUX6kPTLl9+FCjaBCAuXw/T8Uo/+Avyo7pb0r4V2Ao+fhRo+pYYKlL/uwnIcYa0DY+JL9lvofrZ1tIIjKY9ihVJ8q4fdlfkJhWG2b6JCmKJ2H5PcGqftf7+SEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4C6F1FB;
	Thu,  8 Feb 2024 05:01:48 -0800 (PST)
Received: from arm.com (RQ4T19M611.cambridge.arm.com [10.1.31.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF6FB3F5A1;
	Thu,  8 Feb 2024 05:01:01 -0800 (PST)
Date: Thu, 8 Feb 2024 13:00:59 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	reinette.chatre@intel.com, surenb@google.com, stefanha@redhat.com,
	brauner@kernel.org, will@kernel.org, mark.rutland@arm.com,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
	andreyknvl@gmail.com, wangjinchao@xfusion.com, gshan@redhat.com,
	ricarkol@google.com, linux-mm@kvack.org, lpieralisi@kernel.org,
	rananta@google.com, ryan.roberts@arm.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, kvmarm@lists.linux.dev,
	mochs@nvidia.com, zhiw@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 1/4] kvm: arm64: introduce new flag for non-cacheable
 IO memory
Message-ID: <ZcTQi0wWZgvl05LB@arm.com>
References: <20240207204652.22954-1-ankita@nvidia.com>
 <20240207204652.22954-2-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240207204652.22954-2-ankita@nvidia.com>

On Thu, Feb 08, 2024 at 02:16:49AM +0530, ankita@nvidia.com wrote:
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index c651df904fe3..2a893724ee9b 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -717,15 +717,28 @@ void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
>  static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot prot,
>  				kvm_pte_t *ptep)
>  {
> -	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
> -	kvm_pte_t attr = device ? KVM_S2_MEMATTR(pgt, DEVICE_nGnRE) :
> -			    KVM_S2_MEMATTR(pgt, NORMAL);
> +	kvm_pte_t attr;
>  	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
>  
> +	switch (prot & (KVM_PGTABLE_PROT_DEVICE |
> +			KVM_PGTABLE_PROT_NORMAL_NC)) {
> +	case 0:
> +		attr = KVM_S2_MEMATTR(pgt, NORMAL);
> +		break;
> +	case KVM_PGTABLE_PROT_DEVICE:
> +		if (prot & KVM_PGTABLE_PROT_X)
> +			return -EINVAL;
> +		attr = KVM_S2_MEMATTR(pgt, DEVICE_nGnRE);
> +		break;
> +	case KVM_PGTABLE_PROT_NORMAL_NC:
> +		attr = KVM_S2_MEMATTR(pgt, NORMAL_NC);
> +		break;

Does it make sense to allow executable here as well? I don't think it's
harmful but not sure there's a use-case for it either.

> +	default:
> +		WARN_ON_ONCE(1);

Return -EINVAL?

-- 
Catalin
