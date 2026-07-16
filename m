Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 469B940A92D;
	Thu, 16 Jul 2026 10:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784197187; cv=none; b=RsFXfAxgXKNYHBwGtQCe2G1Dy4xJ/Og2PyRARoqzHJvUoIBWfm+o8MPPA2+6liHNMaAECyA9jPTt2+hTXg29gEJJzjVP8kzWNZyV9H+6NJXQxnF5H7dbtng+3SwLhHY0csWXQV6CFhCUxfTuFoWIXAiGNPNUdEuOFocE73g9xxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784197187; c=relaxed/simple;
	bh=3WOmSOJUE6+XMbdwY5Q6POKB6yIL5s1FNm2WoXf4Wfg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gOofZieFQNNAjHfVFBp33UAo4svvLTkzosMIjAzYWb1iOm2Edgs+D/TQEfyfta3xsOlKUyGkkBrCNAajTw7lPQ/jghZytiY9lIVLS7IwmFfEABcIoXGScwjOHdgqC5H1jgcMotxPprMTsEYP8rZoq0YssBAmVhv82N3n1eh3du4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NFjy308A; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NFjy308A"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 40AF12F;
	Thu, 16 Jul 2026 03:19:40 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1E8113F7B4;
	Thu, 16 Jul 2026 03:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784197184; bh=3WOmSOJUE6+XMbdwY5Q6POKB6yIL5s1FNm2WoXf4Wfg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NFjy308AFS81BzQdrpSGjAeDy6Hf7XBhjRBE/6OcoG++oXkcBCD3OSw5h600E3GjH
	 swcDTklYpzr57MS9w5mD4mVaMFTx5pmujDBtvqTsjX3msSQKcHOg3UMlDpP8j+7+ZC
	 LCM09mvWgzo9NUJrHI2aV29iJK9cv0lkKVG7uWkQ=
Message-ID: <5c03fc19-43c1-4828-ab8d-4777ba5ff4f3@arm.com>
Date: Thu, 16 Jul 2026 11:19:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 27/37] KVM: arm64: CCA: Allow userspace to inject
 aborts
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-28-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260715142841.80544-28-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/07/2026 15:28, Steven Price wrote:
> From: Joey Gouly <joey.gouly@arm.com>
> 
> Extend KVM_SET_VCPU_EVENTS to support realms, where KVM cannot set the
> system registers, and the RMM must perform it on next REC entry.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> ---

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


>   Documentation/virt/kvm/api.rst |  2 ++
>   arch/arm64/kvm/guest.c         | 24 ++++++++++++++++++++++++
>   2 files changed, 26 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index e39d146b34a3..85bec9b4f021 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1314,6 +1314,8 @@ User space may need to inject several types of events to the guest.
>   Set the pending SError exception state for this VCPU. It is not possible to
>   'cancel' an Serror that has been made pending.
>   
> +User space cannot inject SErrors into Realms.
> +
>   If the guest performed an access to I/O memory which could not be handled by
>   userspace, for example because of missing instruction syndrome decode
>   information or because there is no device mapped at the accessed IPA, then
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 3e970c4f6214..5469c9a97fad 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -827,6 +827,30 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>   	u64 esr = events->exception.serror_esr;
>   	int ret = 0;
>   
> +	if (vcpu_is_rec(vcpu)) {
> +		/* Cannot inject SError into a Realm. */
> +		if (serror_pending)
> +			return -EINVAL;
> +
> +		/*
> +		 * If a data abort is pending, set the flag and let the RMM
> +		 * inject an SEA when the REC is scheduled to be run.
> +		 */
> +		if (ext_dabt_pending) {
> +			/*
> +			 * Can only inject SEA into a Realm if the previous exit
> +			 * was due to a data abort of an Unprotected IPA.
> +			 */
> +			if (!(vcpu->arch.rec.run->enter.flags & REC_ENTER_FLAG_EMULATED_MMIO))
> +				return -EINVAL;
> +
> +			vcpu->arch.rec.run->enter.flags &= ~REC_ENTER_FLAG_EMULATED_MMIO;
> +			vcpu->arch.rec.run->enter.flags |= REC_ENTER_FLAG_INJECT_SEA;
> +		}
> +
> +		return 0;
> +	}
> +
>   	/*
>   	 * Immediately commit the pending SEA to the vCPU's architectural
>   	 * state which is necessary since we do not return a pending SEA

