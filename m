Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3704D530;
	Wed,  5 Mar 2025 00:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741135178; cv=none; b=ieHg2ISPXO8oCh0YxkWFbG7Xy55vGCxIk4uwEYHCSdqge66VyQ1Y9kMLamdZShkbtD4lyg0dN8BW5tEzLUWNXoeMNdzvcWZt/HwM7GIXk/pqibFBbQGMQnLuNBhqrNkBwCzuQsxYlyrpd2nT1do7hZ6as2PcEoOUz9hbxiVlJ0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741135178; c=relaxed/simple;
	bh=YGhbZ2YK+fELRvv5nvPexW30rexltktFwBDOg+g4tAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m+T6hgtosrFEhMv5a0f82i1b4odme7Ti5tbgn4Dm+s4c4ibPSXa1NLYc2KUvn4qflsu5S4tcrtdNDcdca1q0g0+KL+LDUrigSvHztmhROcfXzaKPRhQEMEgIvv4MwUoW+LVq34GPPsvEB72Tc/+XIOnVo2827ejzgCgrBzv4yxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LCKltC8n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LCKltC8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5692C4CEE5;
	Wed,  5 Mar 2025 00:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741135177;
	bh=YGhbZ2YK+fELRvv5nvPexW30rexltktFwBDOg+g4tAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LCKltC8nO1n/x9FzpGkuzK7IPNaPvku4mXheM33+ixq1UepD9sU9j8/FQwlvEIeBk
	 TyWlme3bMxIVPoC5Ki0YD8raoOermliT3Da7XazHIVrf5oRr1gxF5s8Q491zKsYc3E
	 n8qR9kr1f9cjiskUqmrh72064ga2fICFtUIv/9E7rM/X55zuNLwEuEczjY0WrtBKOk
	 biOUboK8Ze8Kghd1vnzlbnxMPOxZQERJ2iGeXAV1BFQY36zA7/jr+xU1mgNgYNPEwc
	 Zt4H3g7eNxPz/h2biOlltuzp8lUQw2Kdd3Tflhj+pLQ5Ip5SIQEgaXIZJKdgNgOl6R
	 HCzm52ElFXvnw==
Date: Wed, 5 Mar 2025 00:39:31 +0000
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, snehalreddy@google.com,
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v2 1/4] KVM: arm64: Use the static initializer for the
 vesion lock
Message-ID: <20250305003931.GB31667@willie-the-truck>
References: <20250227181750.3606372-1-sebastianene@google.com>
 <20250227181750.3606372-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227181750.3606372-2-sebastianene@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Feb 27, 2025 at 06:17:46PM +0000, Sebastian Ene wrote:
> Replace the definition of the hypervisor version lock
> with a static initializer.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index e433dfab882a..6df6131f1107 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -69,7 +69,7 @@ static struct kvm_ffa_buffers hyp_buffers;
>  static struct kvm_ffa_buffers host_buffers;
>  static u32 hyp_ffa_version;
>  static bool has_version_negotiated;
> -static hyp_spinlock_t version_lock;
> +static DEFINE_HYP_SPINLOCK(version_lock);
>  
>  static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
>  {
> @@ -911,6 +911,5 @@ int hyp_ffa_init(void *pages)
>  		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
>  	};
>  
> -	version_lock = __HYP_SPIN_LOCK_UNLOCKED;
>  	return 0;

nit: typo in the subject (s/vesion/version/).

With that fixed:

Acked-by: Will Deacon <will@kernel.org>

Will
