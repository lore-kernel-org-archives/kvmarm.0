Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793984350;
	b=eLo9jHHhs8mZ5qKzoDxRRlA+Fg/SDHLyFQm64kXMV38Ij7xibMIyRL0dxXKJ6ins5/qW
	 x51dglXLm8RwDLg8vR1CUhyPYPHTdWMYCj7OQq4OhZ2af4iodX2jQ5gxVqp8RRP2GyMz4
	 2u0VqqTn34YdQGDHiVjSQk8nipTxV//jNZ976nDtVZRuZVy24nkVouGl8y4QDl3iNlzf9
	 /x/HYaWcnoDq6bE2+Hga6eonR/LjOtqqaQoVPYi4xOvdu7O0+LvLzHqlW4JfJoDaG08jC
	 r5OSFGpe0BMwH32bnkgzVhvay+RirIqF+kYAX5iWWvD3V5PAxUqc/a5eomazdwXtPrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793984350;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=ne13n2DB/jDf1VtY7sHJ82JPmofZWUZ317tjpSfR3Dw=;
	b=pA76KwSjBBymOfrattp+MOklidU8wY64efyW7M2wz5DYsVFrk4CqDm+5djtvuZrq0ivI
	 VYD0goCfpLz1wp61hbrxtp3q61X1G4GTJ4FbgN0MMdK+rov6/VadJwuEcSKGXZcj7Phd6
	 D00PwZNxr4dKuJYRYq6rbWYAz1gei0XdaUvMoBb2EoP5jmn3dZaMO1XBimoq+Ud42KfDm
	 6H+z9aiq/ASWeKwcu4RZhw9xYAOCrDDPGL2BYyLRdoJ80zm7Ns5h/ITBP4sXel2WyoE88
	 AtyuJr3eYFL83GZhQ3YB3lquG7QAcPICzIg8XL3dacFi7DaaQCj8OGne1rY9UoaxCBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=q4f+N3FU;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A80606A329
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 16:59:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51A80606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=q4f+N3FU
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3632C15A1;
	Fri,  6 Nov 2026 08:59:05 -0800 (PST)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9021D3F673;
	Fri,  6 Nov 2026 08:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793984348; bh=SwqfUHhYw1QVVQnkFBQI8TJ6m4IcNWWoizO5xgJB1Dg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q4f+N3FUhY2jtMruQLhFpwiEFK3SxbelCDNVN4G2YY/fb6ecXxSc6URM7pHHITiUD
	 vzDfxnl3mHUL2B1GI+RlxlC1GGJ+hkP8AG2V86+fFw+S4UmIwq0RrayGh92NCNyHWW
	 //hJqQ1UHYuWPd1hVksWZ4l/ZpM+PYIgyL5FGJ+o=
Message-ID: <1639d961-1092-4a47-8825-55c1647a115b@arm.com>
Date: Fri, 6 Nov 2026 16:59:05 +0000
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
Subject: Re: [PATCH RESEND v4 1/3] KVM: arm64: Avoid re-testing walk_continue
To: Leonardo Bras <leo.bras@arm.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Raghavendra Rao Ananta <rananta@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20261106161240.1345126-1-leo.bras@arm.com>
 <20261106161240.1345126-2-leo.bras@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261106161240.1345126-2-leo.bras@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/11/2026 16:12, Leonardo Bras wrote:
> __kvm_pgtable_visit() performs a bunch of calls to
> kvm_pgtable_walk_continue() to find out whether the walk can continue
> further, and if not, 'goto out', which retests the possibility of
> continuing the walk before exiting.
> 
> Given that it's testing the same ret variable again, there is no reason
> the result of kvm_pgtable_walk_continue() would have changed since the
> previous check. So turn this goto into an early return, simplifying the
> code and paving the way for further rework."

Looks sensible to me.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> 
> Signed-off-by: Leonardo Bras <leo.bras@arm.com>
> ---
>   arch/arm64/kvm/hyp/pgtable.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b74dd5ce1efd..7a51f78b6446 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -183,32 +183,32 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>   	 * Reload the page table after invoking the walker callback for leaf
>   	 * entries or after pre-order traversal, to allow the walker to descend
>   	 * into a newly installed or replaced table.
>   	 */
>   	if (reload) {
>   		ctx.old = READ_ONCE(*ptep);
>   		table = kvm_pte_table(ctx.old, level);
>   	}
>   
>   	if (!kvm_pgtable_walk_continue(data->walker, ret))
> -		goto out;
> +		return ret;
>   
>   	if (!table) {
>   		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
>   		data->addr += kvm_granule_size(level);
>   		goto out;
>   	}
>   
>   	childp = (kvm_pteref_t)kvm_pte_follow(ctx.old, mm_ops);
>   	ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
>   	if (!kvm_pgtable_walk_continue(data->walker, ret))
> -		goto out;
> +		return ret;
>   
>   	if (ctx.flags & KVM_PGTABLE_WALK_TABLE_POST)
>   		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_TABLE_POST);
>   
>   out:
>   	if (kvm_pgtable_walk_continue(data->walker, ret))
>   		return 0;
>   
>   	return ret;
>   }

