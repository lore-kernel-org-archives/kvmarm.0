Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2868A2F85B
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 14:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767711566; cv=none; b=erWGUn/qujnN0dUaYEtrQdnggfJ/1SIS+0tk2utlwrhk0L81B7NRDJ77xyVPZSy7MC3OqM+US3NC50mtBATSfw28FSlatiFIGQVa6YVpkkhCrSbChmFlUrtgH2n7VRwnprPXVJgxJVdlFUIvBhsgMQ54SZazsgFCM/+vDsJyVHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767711566; c=relaxed/simple;
	bh=90w2GHe+GZWWUiPWactjjNGp5jzhk7ZCAq0+zqOGemk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JozCf8i1ROy19hjCB9w6XqG8k3Cab+wv1ZtdB7jligopvHEVfdA+NdfGOflAm7tyr5LsOUaB3SIJmtsJIQUtq9l1yDAMBq/FiEBidcb7KCIxoZ53tMck0Kuq7Cwpj63tvxLw/3MPwE6IWIy4898YFtgeajIHTh4Zj9fY+/hy57A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zkr8M2on; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zkr8M2on"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-598f81d090cso1113100e87.2
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 06:59:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767711563; x=1768316363; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PG2N5It+TmGVOOXoBLd3eGZR3+xZRApjmmcqpt/ZQJU=;
        b=Zkr8M2onFPhBBEaMVDhyv+SP1ulxxqUlFJhAVY3KYiuwEJxFFZzVYJi7wLpQ3+ssBk
         L6HkKaXuEnhVF0PpaKRdTWNZaKJ7a6ybACkqaTl6ZQXEHRjlXt1A/zBfXDt693znL31h
         WtNCI9S0bDOtgH1OZ4vlvGRPNHTRlL+rmqKNzQrnuBVe3ZO/RXBzmJHKouL4VJLLZRRj
         oc2La4dN7qd2PfnvR+JBcVW1nanwPc6ORvmcxEk75Hw2YIyGvyB9Hg6/jTQciRs1yfzk
         5hj3luIgDOtIzzNLxZCudD50R4EOh/cuVyLb2SiZBi9C4vOBUYSXdJch/bBn7sIQDHLz
         bAZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767711563; x=1768316363;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PG2N5It+TmGVOOXoBLd3eGZR3+xZRApjmmcqpt/ZQJU=;
        b=TtsCJ4haILB1vWjO/89wlZWhdu/IBnvLtsr9HDYRMqnuw7WGbO0+3noBwT/2WSrnU7
         Yqh9tamRtnjPG9f3KpZwgCdXVX4fxk+dEIvLx+wl0f15gfQ4BOsfnlnyDxr5CNCGwXkR
         q7nKfx7Ates86UF00QaeNKT7Pd2gM9aTUj8a0cI6u8R2HX1Yy+ANUNgnWt/jCYa6B9Uo
         reilrOJaefJkbYH8O9YmADg7g6Jak2q2VTP1gBKOEH4VggorSvYGSDdOISBHX3bMOg8/
         1+fnvJ9qCp0VATzWqfWtAm7RYi5thQTndoGfvjyxjIA/LTPm+XUWqO6SHv9gGoEJF6wD
         udHA==
X-Gm-Message-State: AOJu0YyP6xiyc1tMTJ5drT4id+WWkrp8EViLFGFpvKWdaHooQIbHAq9d
	v07brLJ7lXFD/VPV6O0JC12FW5JAe425dXLN//uI4Chaz0wIS+Hd2Ln+Pv+H9Hty7Q==
X-Gm-Gg: AY/fxX5A19C7i8hIzbjXzPLmPNRl6FRsbOlpv3+iEKKZUdkcPsRCprhIKMp7okTONo7
	XapI6jwADx8Sc0vgZeIHOksiZQs/XPn9eDTtIKsQi8xZL9y9ZrKeKj8JReHWa0flbVK2h5XUOwO
	beqwsVopgo/HOz1WmntVPgGnwCJV1s95k7cQqBSzLqiz+mynHN3bGTb7xomXSdHlahuXyspazQ5
	eiSqbVl0DZpPBlRr4l/NqttBlIp7m22//w1tDjzPTAbnaEz3027Iae/UC2e8b4iR2IzWtHPfBBk
	xufDEUcAN4sp9zFwSt+ootEtIgC6ay9t/8G0iGQe5rkIeuGeg6vZdTG2FkhqhHKy6Je0m70QPVL
	sKxQl9Ek7ZPR7QRQ86dfDc7tMkYv51gmPEO/4SU4iWqdCJ57xMoq6bePMZXRNKjhB7iEdrPDhIy
	7hUHREq5TTuMtxF9DtvoSOX/vkeMEVRnqvgJaap6lzbyHdmMwe
X-Google-Smtp-Source: AGHT+IFAKUDmgnFB7fgseWxDswTHxVbr9Bi36lxtzMdQtE6ZLibvtwZpajKpR/HB7iE//12LWrQYYQ==
X-Received: by 2002:a05:6512:3d11:b0:59a:181b:d6ab with SMTP id 2adb3069b0e04-59b6525fad7mr1059016e87.41.1767711562819;
        Tue, 06 Jan 2026 06:59:22 -0800 (PST)
Received: from google.com (228.231.88.34.bc.googleusercontent.com. [34.88.231.228])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b65d7615dsm632723e87.92.2026.01.06.06.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 06:59:22 -0800 (PST)
Date: Tue, 6 Jan 2026 14:59:19 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 14/30] KVM: arm64: Hook up reclaim hypercall to
 pkvm_pgtable_stage2_destroy()
Message-ID: <bc246bvbf3cg7scut2dcey7tynxqzclyceqv4hhooqacsdzti7@hcaqfbnvebt2>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-15-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105154939.11041-15-will@kernel.org>

On Monday 05 Jan 2026 at 15:49:22 (+0000), Will Deacon wrote:
> During teardown of a protected guest, its memory pages must be reclaimed
> from the hypervisor by issuing the '__pkvm_reclaim_dying_guest_page'
> hypercall.
> 
> Add a new helper, __pkvm_pgtable_stage2_reclaim(), which is called
> during the VM teardown operation to reclaim pages from the hypervisor
> and drop the GUP pin on the host.
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/pkvm.c | 31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 1814e17d600e..8be91051699e 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -322,6 +322,32 @@ int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>  	return 0;
>  }
>  
> +static int __pkvm_pgtable_stage2_reclaim(struct kvm_pgtable *pgt, u64 start, u64 end)
> +{
> +	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> +	pkvm_handle_t handle = kvm->arch.pkvm.handle;
> +	struct pkvm_mapping *mapping;
> +	int ret;
> +
> +	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
> +		struct page *page;
> +
> +		ret = kvm_call_hyp_nvhe(__pkvm_reclaim_dying_guest_page,
> +					handle, mapping->gfn);
> +		if (WARN_ON(ret))
> +			return ret;
> +
> +		page = pfn_to_page(mapping->pfn);
> +		WARN_ON_ONCE(mapping->nr_pages != 1);
> +		unpin_user_pages_dirty_lock(&page, 1, true);
> +		account_locked_vm(current->mm, 1, false);
> +		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
> +		kfree(mapping);

Nit: this might take a while, worth adding a cond_resched() in here?

> +	}
> +
> +	return 0;
> +}
> +
>  static int __pkvm_pgtable_stage2_unshare(struct kvm_pgtable *pgt, u64 start, u64 end)
>  {
>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> @@ -355,7 +381,10 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
>  		kvm->arch.pkvm.is_dying = true;
>  	}
>  
> -	__pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
> +	if (kvm_vm_is_protected(kvm))
> +		__pkvm_pgtable_stage2_reclaim(pgt, addr, addr + size);
> +	else
> +		__pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
>  }
>  
>  void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 
