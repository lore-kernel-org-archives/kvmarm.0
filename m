Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792674767;
	b=O0tQo6klHyt9pVB/ZN7gTIpd2B75VI8wTrML8aebbSapTU7WBGJ9qqAcclv7fXARg1va
	 CFR8sZp5IEmzpMXjy39u8vV9sWbFq331rJAakf3HxmeqSZGCIdHZl9TE6wzP3JfOCByuq
	 e1KLlMpDD87QUdp3kTwGeirIfgmvuVQ/0+9ul7wJCvKCTnw7EBSEkHZApDW4IhClWwxvQ
	 hjdlF2oZFGMct+Bvzb0BjeP9Tm44SPoeUup22gIUFF+79PbL2pURjt3++V2H9ZER8Td4c
	 1H7v5+2SfvQfabXBaOZG7QoXDefud1lnRO3VNKjI6MBgsO81kT29DB4H5EsZ6OoMDIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792674767;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=bWeRZDGg5wgEIXQ2Q3Dog5Qq8cFNbVZQXYdNdnbIBxo=;
	b=NdBmlW8Ak7aG5B/Am0iPITtEY5ZGNtnWLmawQMyL8rWCQ2A8eK/e3G7gMJMocuaS+G2v
	 cCQPtkYr0sIZfbJwN+xHIdAE0bGYJkkn5Q1JREudzts6hmIhPjeA+xgMLEpgOtxzPiH0O
	 c+JCMKsQcf6/pQ2PKrXJiMRDC1USOOxP8f/otSuVdKiZpv04+FQh5sLqNuvkN+r0fnJel
	 t4WlF/BrJi7s/IVj8jEqNJP2Z6W0s+vQmPBfKQCJ4vIp6uMAi1GNAYYvl+qhrZhhvmT5y
	 99beJh0iOco9r7lBKUdj8/JjaNqh3BhbYMNbgUzLiMskZ+4Atg9raq4kJnyDB+6OoJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=YJ2pynxc;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E14C2606A31A
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 13:12:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E14C2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=YJ2pynxc
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1B622C34;
	Thu, 22 Oct 2026 06:12:42 -0700 (PDT)
Received: from [10.0.129.145] (Suzukis-MBP.cambridge.arm.com [10.0.129.145])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 041FF3F673;
	Thu, 22 Oct 2026 06:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792674766; bh=D+1s1qGz4upJyB30Lz7rpPwzUA1TglIBkh6n3/mG9JE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YJ2pynxcE4vfMZ7QttDPP2sI6JxzDHVm9lVgFn+frTUeMehwdXSm7LUIPYh2pCght
	 VexFKqRbbXZx6Nr2WT7apXYQ1MW/rme9O4ZqnwBWnNTX1K6tYuOhC2deGdz5kdLAdT
	 Eji8POU3FseNWV3rSXDBS4I2vRpLVVcaFFFQHjOQ=
Message-ID: <a25c3ec1-ef58-4d70-b7c9-c1e213680541@arm.com>
Date: Thu, 22 Oct 2026 14:12:42 +0100
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Return on kvm_gmem_get_pfn() failure in
 gmem_abort()
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Vincent Donnefort <vdonnefort@google.com>,
 Wei-Lin Chang <weilin.chang@arm.com>, Fuad Tabba <tabba@google.com>
References: <20261022123054.31729-1-fuad.tabba@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261022123054.31729-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/10/2026 13:30, Fuad Tabba wrote:
> The kvm-arm64/mmu-fixes-7.4 merge dropped the return from the
> kvm_gmem_get_pfn() error path in gmem_abort(). Both parents of the
> merge keep that return. On a failed kvm_gmem_get_pfn(), gmem_abort()
> then carries on with a zero pfn, and on a nested stage-2 it uses the
> mapping it has just freed.
> 
> Restore the return.
> 
> Fixes: 65f95b2874a15 ("Merge branch kvm-arm64/mmu-fixes-7.4 into kvmarm-master/next")
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
> 
> Notes:
>      I went through the rest of the merge's conflict resolution with
>      git show --remerge-diff, and this is the only line it dropped.
> 
>   arch/arm64/kvm/mmu.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index a48f3f531e827..ba4fe58222ad5 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1802,6 +1802,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
>   						      s2vi.vma_pagesize, write_fault, exec_fault,
>   						      false);
>   		kfree(mapping);
> +		return ret;
>   	}
>   
>   	if (!(s2fd->memslot->flags & KVM_MEM_READONLY))

Thanks for fixing this ! Looks correct to me.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

