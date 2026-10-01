Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB892D322E;
	Thu,  1 Oct 2026 12:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790859574; cv=none; b=WBqKCGziV7rUdpezJOrMmxCnfSBmI0XlPdfOyf4JqFH9IkJzIzkWtPd+82EWBJAQQ2NbsqpWAKuOh+2YPQ/c4QT1e5IFMracnN0HIKNA72PQlj6qRbUhGK9a+sAF6QQAjidjI3Isjc7OzZivb4WOrWDhVSls7jONRH3XpxsW5VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790859574; c=relaxed/simple;
	bh=ZxVtC/PKiyDn8e4BnlkdDd+kdXDfx5MN3algV82ScWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hHhFP764e/Y54yP8F6YJOIbqRa6lGeQTV2VI2JWEbY19pbQ1GpiBQQofMfigTQTDAImaHwfx1wlLarhJmZzinlG6kJkyW1KwOG92ffqtqEm4m7uSiozizHBn4gRYmCNOZ7mxj5M3ntvpwg4GF0zgZQnKto+WDZ5032jXXcLLNXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VPtdhrZL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VPtdhrZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E16D1F000FF;
	Thu,  1 Oct 2026 12:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790859573;
	bh=2+QYNntd07WS7zMODeQXAyVckwYY6XqiZdZf5eCLe8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VPtdhrZLZS6IvmpaxQATO4OuteyezqkuAoyWrhPye1VvQ14ST5gu9mgOvbSfuyjDB
	 UH5zO81vNqRp1IYbp/78IVOmIVhYhGjofsmECs5n3pQswCILJFth7eGwNr2SFudd5M
	 gjIMBBAVwxo2p/78Jx8e6Bc/NMHv1+T4HbnnepH/4JEYDkRt9zbbgHaX3BEjH9r6UZ
	 eWd9at+tcDUmTXy6Eab3A3eoxdNB1j8tsBDsDNVNV4bAFFr/NAvPoEKj2wn6e0xD6H
	 K7XhGzsB6JfvfamVI7Shh7EqDontlUArSPxlI9o7WYa4x+M74v8PZTTX+ASwIhEFty
	 t8/xTfDToBQ/w==
Date: Thu, 1 Oct 2026 13:59:27 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	steven.price@arm.com, vdonnefort@google.com, qperret@google.com,
	tabba@google.com
Subject: Re: [PATCH v3 10/18] KVM: arm64: Handle PSCI calls for protected VMs
 at EL2
Message-ID: <ar5ZLxL6-mz98tpN@willie-the-truck>
References: <20260914113338.159227-1-fuad.tabba@linux.dev>
 <20260914113338.159227-11-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914113338.159227-11-fuad.tabba@linux.dev>

On Mon, Sep 14, 2026 at 12:33:30PM +0100, Fuad Tabba wrote:
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 855cb77c8bba1..d970cba12ca47 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>  
> +/*
> + * Reset the vCPU to its power-on state and commit ON_PENDING -> ON, on the
> + * target's own CPU. Returns -ECANCELED, with no side effects, if a rollback
> + * raced the reset.
> + */
> +int pkvm_reset_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	struct vcpu_reset_state *reset_state = &hyp_vcpu->vcpu.arch.reset_state;
> +	int prev;
> +
> +	/*
> +	 * Pairs with smp_store_release(&reset_state->reset, true) in
> +	 * pvm_psci_vcpu_on(). The acquire must precede the cmpxchg: reversed, a
> +	 * winning cmpxchg with a false acquire would leave power_state == ON
> +	 * with the reset skipped.
> +	 */
> +	if (!smp_load_acquire(&reset_state->reset))
> +		return -ECANCELED;
> +
> +	prev = cmpxchg_relaxed(&hyp_vcpu->power_state,
> +			       PSCI_0_2_AFFINITY_LEVEL_ON_PENDING,
> +			       PSCI_0_2_AFFINITY_LEVEL_ON);
> +	if (prev != PSCI_0_2_AFFINITY_LEVEL_ON_PENDING) {
> +		/* The only other writer of ON_PENDING is the rollback. */
> +		WARN_ON(prev != PSCI_0_2_AFFINITY_LEVEL_OFF);

If you go with the idea we're discussing later in the thread, then I think
you need to drop this WARN_ON() and the comment that goes with it.

Will
