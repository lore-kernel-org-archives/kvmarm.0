Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107C4295DBD;
	Tue, 29 Jul 2025 15:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753804163; cv=none; b=I/qd7aEVAor/unN1I/dkfHbH7ovXHJCQMhaHHDTcYjmFB0F3Fz5bS+SZ39Vt9KffOoAfRwRKPq3PUpLogzhkwKKBRMqKuEZy6FQawyRcEeJBAwr4qSHuHbqmJ25z0KT5beV2TAmuAmP6+9zcMpiIGl5VXHNOvmg74ljRxzF5BJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753804163; c=relaxed/simple;
	bh=zGmD3167+YxqSnrktPvUpd/I+LwF4Gpt9JasfT/czbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ozf0ycrQykltt60rVjW0eCBrg+BdJEIiDnS6aiDj+3nW/ATQ6XLrr63jKGw5XHWflgkQtC8SekqTMdTzqQ7wER4zdN7bvXMr9fiXJAe/TNTfYDyYOAlM0EgSXQeoOWgVtC1vUV8iU/t/FAO16OLCXZ4qnZqkB7hDiLa0GNjK8JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UeboxoC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UeboxoC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B592C4CEF7;
	Tue, 29 Jul 2025 15:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753804162;
	bh=zGmD3167+YxqSnrktPvUpd/I+LwF4Gpt9JasfT/czbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UeboxoC0XEFnibrKKHSRwegzcAX9Gg+RhiCj6Haa0TJjlD1BVMkwgmXfrJBtEBnxP
	 zDTnwzuZwLG67Fj/v5t8/XGCpeIf06lg2vk99rSoWwwpeX8S+r8HDkZZ3Rh4m/2s4w
	 vnr5MfuqN1p3Mim9m8fWyeSoioEDjSFx8rIe9TRitumdSkzjdSrxjys1arowqP8Pzg
	 igl4jAsxDXNrViv5axls2jFY+F2z9YU7DEsVUJaHSzRAqzR7Pyg8pWvz9WFyFPMZZ5
	 cr/07hivBzg8aIMLB0v8GMf77IgZNTMw0/5jcKYsW7/UVKOaynIDfBZhvrZ96j805G
	 nmrlQmXPYUZpA==
Date: Tue, 29 Jul 2025 16:49:16 +0100
From: Will Deacon <will@kernel.org>
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, ahomescu@google.com,
	armellel@google.com, arve@android.com, ayrton@google.com,
	qperret@google.com, sebastianene@google.com, qwandor@google.com
Subject: Re: [PATCH v8 6/7] KVM: arm64: Bump the supported version of FF-A to
 1.2
Message-ID: <aIjtfPY2db0LOwe4@willie-the-truck>
References: <20250719-virtio-msg-ffa-v8-0-03e8e8dbe856@google.com>
 <20250719-virtio-msg-ffa-v8-6-03e8e8dbe856@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250719-virtio-msg-ffa-v8-6-03e8e8dbe856@google.com>

On Sat, Jul 19, 2025 at 02:11:28AM +0000, Per Larsen via B4 Relay wrote:
> From: Per Larsen <perlarsen@google.com>
> 
> FF-A version 1.2 introduces the DIRECT_REQ2 ABI. Bump the FF-A version
> preferred by the hypervisor as a precursor to implementing the 1.2-only
> FFA_MSG_SEND_DIRECT_REQ2 and FFA_MSG_SEND_RESP2 messaging interfaces.
> 
> Co-developed-by: Ayrton Munoz <ayrton@google.com>
> Signed-off-by: Ayrton Munoz <ayrton@google.com>
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 2cbecc9af5d27a9e7c8497001cf9b0987c72bdb4..f6d964df53c3e21ba85984f35cc7b6859012d1b0 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -930,7 +930,7 @@ int hyp_ffa_init(void *pages)
>  
>  	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
>  		.a0 = FFA_VERSION,
> -		.a1 = FFA_VERSION_1_1,
> +		.a1 = FFA_VERSION_1_2,
>  	}, &res);
>  	if (res.a0 == FFA_RET_NOT_SUPPORTED)
>  		return 0;
> @@ -951,10 +951,10 @@ int hyp_ffa_init(void *pages)
>  	if (FFA_MAJOR_VERSION(res.a0) != 1)
>  		return -EOPNOTSUPP;
>  
> -	if (FFA_MINOR_VERSION(res.a0) < FFA_MINOR_VERSION(FFA_VERSION_1_1))
> +	if (FFA_MINOR_VERSION(res.a0) < FFA_MINOR_VERSION(FFA_VERSION_1_2))
>  		hyp_ffa_version = res.a0;
>  	else
> -		hyp_ffa_version = FFA_VERSION_1_1;
> +		hyp_ffa_version = FFA_VERSION_1_2;

Acked-by: Will Deacon <will@kernel.org>

Will
