Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F06036405A
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 18:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788805889; cv=none; b=G4WkgLqEBG9NPI8VAFCD+xdaRt8E01uLBIis3B8GUuj8hIHfn0Jql+83wZfvl4HxtvmsbA2HQUbeZOirb80cJi7tu5zK9Qf3Ocoa/yDIcceVLMk1l5V1tYQLniuDWj2oLLs95LTx2I48yfoApnBdE19KcJi4+y88dkTOdN/kGQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788805889; c=relaxed/simple;
	bh=SZUjhJyyh2zwnMxlfGcwmQhqJPQPy3XgjQ6vqEO15ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HxccShPymy/19YFS2dZSUUwxgJ+M9ahESp6IZcpO6G0IoD0Y/sM9VYyIzYKm9sylXogiLyNvkGq9SZB5Ep6l/2ebRNNSxB5pAV4WWRIWcqfgg62RmZxDcE5b0l0/UNuTMaw8spKZmTEosW694MCBXMsm6MlfyourcXz8Ohw7BZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Lmc45SDA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Lmc45SDA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E70B1476;
	Mon,  7 Sep 2026 11:31:22 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B3E53F528;
	Mon,  7 Sep 2026 11:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788805886; bh=SZUjhJyyh2zwnMxlfGcwmQhqJPQPy3XgjQ6vqEO15ds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lmc45SDAMBKe7AkSPW1lwmMvu5V2Pk09bHJtneTOm6g2ReQNVHeT/504qbpgSlOFd
	 TOVHrH1pMbTbzxelCNduAG1SUWkVIwzlZ5eMrFwGT+ZJfPBOm2NYe/ByDt4o6G8D/s
	 DLDS/o+hzEGDaQ6ORUIdTJoJK37bA3fGDJK/IS8Q=
Date: Mon, 7 Sep 2026 19:31:17 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org, 
	oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 20/20] KVM: arm64: Stage-2 huge mappings for protected VMs
Message-ID: <vid5oqqbit6vrszu65so62igdxybukfyaqjdg2ymtgufsl2sqk@wnqwnrbtsajs>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-21-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803100904.3563942-21-vdonnefort@google.com>

On Mon, Aug 03, 2026 at 11:09:04AM +0100, Vincent Donnefort wrote:

[...]

> @@ -1755,25 +1737,59 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>  		goto unpin;
>  	}
>  
> +	pfn = page_to_pfn(page);
> +	gfn = gpa_to_gfn(s2fd->fault_ipa);
> +
> +	page_size = transparent_hugepage_adjust(kvm, s2fd->memslot, s2fd->hva, &pfn, &gfn);
> +	if (page_size < 0) {
> +		ret = page_size;
> +		goto unpin;
> +	} else if (page_size == PMD_SIZE) {
> +		if (WARN_ON(!folio_test_large(page_folio(page)))) {

folio_size() >= PMD_SIZE seems more robust here.

> +			ret = -EINVAL;
> +			goto unpin;
> +		}
> +	}
> +
> +	ret = account_locked_vm(mm, page_size / PAGE_SIZE, true);

"page_size / PAGE_SIZE" :)
Maybe call this mapping_size?

Thanks,
Wei-Lin Chang

> +	if (ret)
> +		goto unpin;
> +
>  	write_lock(&kvm->mmu_lock);
> -	ret = pkvm_pgtable_stage2_map(pgt, s2fd->fault_ipa, PAGE_SIZE,
> -				      page_to_phys(page), KVM_PGTABLE_PROT_RWX,
> +	ret = pkvm_pgtable_stage2_map(pgt, gfn_to_gpa(gfn), page_size,
> +				      __pfn_to_phys(pfn), KVM_PGTABLE_PROT_RWX,
>  				      hyp_memcache, 0);
>  	write_unlock(&kvm->mmu_lock);
>  	if (ret) {
>  		if (ret == -EAGAIN)
>  			ret = 0;
> -		goto unpin;
> +		goto dec_account;
>  	}
>  
>  	return 0;
> +
> +dec_account:
> +	account_locked_vm(mm, page_size / PAGE_SIZE, false);
>  unpin:
>  	unpin_user_pages(&page, 1);
> -dec_account:
> -	account_locked_vm(mm, 1, false);
>  	return ret;
>  }
>  

[...]
