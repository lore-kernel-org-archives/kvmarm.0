Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C3F320E030
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 04:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774931551; cv=none; b=pu4kXV8sMwD0dTW4CWD+xSr4uFnQIQdzCjkTJ2RRg9qoxXlfyDt0JzcS0fbTd9bF0QKySo+prqRzCdWkwzwyX+af4W4b664DVlnuJ1uhgkPn3hSsgqZwCzb9EhUWTOIvb1f7Nj5rssOOI3LeELbkEJzXLir6zGIrJ/sp0QX7uDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774931551; c=relaxed/simple;
	bh=iUSmJen7EHvJbWNsD+5iM8jJX4poJCJT5ye2J7z9dkI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uEb6/hz7c4UXJKknj01PutZqX+/JKLtbjQDZErCMeLPZJ3i4rWDvbimNd+DNFi+TRQY+UL4mEtF9ONUjiJvZDYkuF+is0M+F59bbB/dimN7GN9R93MIl57MeBOr57sQzJCxNAF6VnvJ+YS16Rtv91yxtAjLgjNI+Ln9Dgqm5YLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=d/Vl+mYC; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="d/Vl+mYC"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8F2E1F91;
	Mon, 30 Mar 2026 21:32:22 -0700 (PDT)
Received: from [10.57.18.211] (unknown [10.57.18.211])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 813BB3F7D8;
	Mon, 30 Mar 2026 21:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774931548; bh=iUSmJen7EHvJbWNsD+5iM8jJX4poJCJT5ye2J7z9dkI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d/Vl+mYCWsLfdTiQ5ngQ+k7Gurmy3gcTv3lv/p1eD2ft61bcNanUrqx+Yuw8yLenA
	 ZskW+RkhwJtS5+/Ocx6Czyxz+CeEmV9hK4NJoY4nuN2OQtmeLquf7ty6hbUNihEFak
	 IcFVBz8ylhZXE2uh0yYgVJtp9lA1HEqjqjOforVA=
Message-ID: <f606d3f7-0aef-47a4-ae2f-abc4f163d69f@arm.com>
Date: Tue, 31 Mar 2026 10:02:21 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/30] KVM: arm64: Simplify return logic in
 user_mem_abort()
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260327113618.4051534-1-maz@kernel.org>
 <20260327113618.4051534-10-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260327113618.4051534-10-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/03/26 5:05 PM, Marc Zyngier wrote:
> From: Fuad Tabba <tabba@google.com>
> 
> With the refactoring done, the final return block of user_mem_abort()
> can be tidied up a bit more.
> 
> Clean up the trailing edge by dropping the unnecessary assignment,
> collapsing the return evaluation for kvm_s2_fault_compute_prot(), and
> tail calling kvm_s2_fault_map() directly.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1b991300735be..e77b0b60697f6 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2005,22 +2005,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (ret != 1)
>  		return ret;
>  
> -	ret = 0;
> -
>  	ret = kvm_s2_fault_compute_prot(fault);
> -	if (ret == 1) {
> -		ret = 1; /* fault injected */
> -		goto out_put_page;
> +	if (ret) {
> +		kvm_release_page_unused(fault->page);
> +		return ret;
>  	}
> -	if (ret)
> -		goto out_put_page;
>  
> -	ret = kvm_s2_fault_map(fault, memcache);
> -	return ret;
> -
> -out_put_page:
> -	kvm_release_page_unused(fault->page);
> -	return ret;
> +	return kvm_s2_fault_map(fault, memcache);
>  }
>  
>  /* Resolve the access fault by making the page young again. */

