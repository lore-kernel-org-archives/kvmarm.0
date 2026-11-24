Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795479631;
	b=49uAoYNDFljTMGzqB3Cta7Kd05CqJbYHA5PoNNdRNKCEkTxSfrPOHKhvJHS4cs2q7fJ6
	 +WztqzrtpU8bajwwu5yydZcRSTekpxdVn/dJO/2vnfSegyK3Z1rpoSAQW/s1CriL+FWzI
	 /mbqqJkaAwnLn9J8yAJAsjC1SsidYHcGRjb6THDuUp7AqwxvKzxCNgVzyDFxOFNhDEJCr
	 Z4FzlYEMHri5SKhNHTBO7OofoP+nSKBjZ/DUmhmW80Dk0bdSxnYP22yD5F+JFQpOlaZMU
	 NH62jm8R8EQrdKaketxQJzIfv2Tuykt0DhQddq9kEgPAbCPQKoGEIvWuzcWEF8AySNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795479631;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=2GtSg4vRHiDWPpeLY7sTd2iSc0/Gk0S5h4DsqQKBcWI=;
	b=MIG56kwqA0VOed9fvdMcMmIp+ryULp8gx+8IRc2lIjFJlBq/tr/X04yAvCKwh/eibcVc
	 uBvcnqgBLLOjNPHKX1GLgWf2FyBDu1/Fcxx5zVcTDfcup0P/ptbpwMkvZCIASDDxOsMFY
	 rb0sr3p3d0/cGq1SQChKkcOlkXlBlQLiq9JUj5ElUtPRCZnZWkVG04X3XMGd+EwiuwWor
	 UAqnN76VQNP03nfnRwNJazFuKIA/hlTWS8HcZAKCRIXsVy/U/JpAKPs/hGXOiXpzSIzXS
	 cY6AApLjI0trKYYWF/QQqeRBHPPESKx31LdvfDo/3VNfAJj7TuHvMtmItphnvsNfUcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="bwgES/Fb";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FCE6606A31E;
	Tue, 24 Nov 2026 00:20:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FCE6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bwgES/Fb
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70474339;
	Mon, 23 Nov 2026 16:20:27 -0800 (PST)
Received: from [10.57.72.180] (unknown [10.57.72.180])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 942DF3F632;
	Mon, 23 Nov 2026 16:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795479630; bh=tqsptYjpvS8j/Z7OXZo9J1OL0d10RZs2DNvWvQ1dcGI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bwgES/Fbu9srTMgZIypAdiwXKHbbWyT4u1hi0ZcDWhVWdcXS/eyp+SqG7KVRv165x
	 KwGO8/oG1MFxQICHD5w2y0S1mkkuGNxBytwOaXKxODhM7NQb/4GB5EVkkFxoizwd7f
	 k7lwAkGRVqO3qMubF5x2TR2YeKd/oBx7DZS2PE4g=
Message-ID: <bc90af1d-068e-4e79-8d5f-f8205beb0a69@arm.com>
Date: Tue, 24 Nov 2026 00:20:24 +0000
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
Subject: Re: [PATCH v4 07/11] KVM: arm64: CCA: Add Realm RTT mapping and
 invalidation helpers
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Kohei Enju <enju.kohei@fujitsu.com>
References: <20261123104233.95710-1-steven.price@arm.com>
 <20261123104233.95710-8-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261123104233.95710-8-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23/11/2026 10:42, Steven Price wrote:
> Add the RMI RTT creation and unmap helpers needed by CCA Realm stage-2
> memory operations. REC exit handling and guest requested RIPAS changes
> follow in the vCPU series.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> 
> ---
> Changes since v3:
> - Use the VTCR-derived Realm start level for RTT operations.
> 
> Changes since v2:
> - Use a local MMU cache during notifier invalidation, handle
>    failed RTT splits, and validate RMI levels and cache state.
> 
> Changes since v1:
> - Rework RTT creation and folding around missing or existing RTTs.
>    Use a shared RMI block-size helper and handle alignment, partial
>    progress and errors in range operations.
> ---
>   arch/arm64/include/asm/kvm_rmi.h |   8 +
>   arch/arm64/kvm/rmi.c             | 421 +++++++++++++++++++++++++++++++
>   drivers/firmware/arm_rmm/rmi.c   |  10 -
>   include/linux/arm-rmi-cmds.h     |   8 +
>   4 files changed, 437 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h

...

> +
> +static void realm_unmap_shared_range(struct kvm *kvm,
> +				     unsigned long start,
> +				     unsigned long end,
> +				     bool may_block,
> +				     struct kvm_mmu_memory_cache *mc)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	unsigned long rd = realm->rd_phys;
> +	unsigned long next_addr, addr;
> +	unsigned long shared_bit = BIT(realm->ia_bits - 1);
> +
> +	if (start >= end)
> +		return;
> +
> +	/*
> +	 * Callers may pass either an IPA range or its shared alias. Add the
> +	 * shared bit only for the former. Use addition so an exclusive end at
> +	 * shared_bit advances to the end of the IPA space.
> +	 */
> +	if (start < shared_bit) {
> +		start += shared_bit;
> +		end += shared_bit;
> +	}
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		long ret;
> +
> +		ret = rmi_rtt_unprot_unmap(rd, addr, end, RMI_ADDR_TYPE_NONE,

...

> +		}
> +
> +		if (may_block)
> +			cond_resched_rwlock_write(&kvm->mmu_lock);
> +	}
> +
> +	realm_fold_rtt_level(realm, realm->start_level + 1,
> +			     start, end);

See below.

> +}
> +
> +static void realm_unmap_private_range(struct kvm *kvm,
> +				      unsigned long start,
> +				      unsigned long end,
> +				      bool may_block,
> +				      struct kvm_mmu_memory_cache *mc)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	unsigned long rd = realm->rd_phys;
> +	unsigned long next_addr, addr;
> +	long ret;
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		unsigned long out_range;
> +		unsigned long flags = RMI_ADDR_TYPE_SINGLE;
> +		/* TODO: Optimise using RMI_ADDR_TYPE_LIST */
> +
> +		ret = rmi_rtt_data_unmap(rd, addr, end, flags, 0,

...

> +		}
> +
> +		if (may_block)
> +			cond_resched_rwlock_write(&kvm->mmu_lock);
> +	}
> +
> +	realm_fold_rtt_level(realm, realm->start_level + 1,
> +			     start, end);


If "may_block", we don't take that into account while folding the RTTs ?
On a bigger range, we might spend too much time, starving the other
threads.

Also, there is no point in folding the RTTs if the Realm is dying. So, I
would rather skip this if the Realm is not ACTIVE.

Suzuki
