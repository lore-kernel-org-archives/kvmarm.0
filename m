Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A15337B81
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 17:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773769223; cv=none; b=LGnTZBFqi9NCan3/kGQnWVmg1qoo0Qt5srIYfGgmek0RD00rD/8h16AF58wq2LA5p8AUwM7FKyzVOrtcu8Ycrc4nzAXmU65V2LYeHSs0x2e3lIxmrRbWdbD/OCKN743WYcjni7hNbZU05zK1jOqbO5oKjsDL5QDh8e5JbPtt91c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773769223; c=relaxed/simple;
	bh=e117uoNAPO191GHaAwSFRIV+e/gTqqilfxHi0WDwBe0=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fEDmah+hLkZ/Uyup3V7KVPo7Glzf8UwR6EXz0naWEtLFIQeDQtHAacC2Lk8EO9nun7ItABm23OVxoSaew08bWxDS7NOZYdCEewRDf07SojMBVaJfsgde92N5Srm+z49xRzRCIw0HAacCgHr6XwCaa6yfKKsQa+Y8rzW5uOWYSZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fZzk534l5zHnGck;
	Wed, 18 Mar 2026 01:39:57 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 5F19B40572;
	Wed, 18 Mar 2026 01:40:17 +0800 (CST)
Received: from localhost (10.48.149.62) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 17 Mar
 2026 17:40:16 +0000
Date: Tue, 17 Mar 2026 17:40:13 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Fuad Tabba <tabba@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, "Joey
 Gouly" <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, "KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64"
	<linux-arm-kernel@lists.infradead.org>, KERNEL VIRTUAL MACHINE FOR ARM64
 KVM/arm64 <kvmarm@lists.linux.dev>, "open list"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] KVM: arm64: Use guard(hyp_spinlock) in ffa.c
Message-ID: <20260317174013.00007622@huawei.com>
In-Reply-To: <20260316-tabba-el2_guard-v1-3-456875a2c6db@google.com>
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
	<20260316-tabba-el2_guard-v1-3-456875a2c6db@google.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Mon, 16 Mar 2026 17:35:24 +0000
Fuad Tabba <tabba@google.com> wrote:

> Migrate manual hyp_spin_lock() and hyp_spin_unlock() calls managing
> host_buffers.lock and version_lock to use the guard(hyp_spinlock)
> macro.
> 
> This eliminates manual unlock calls on return paths and simplifies
> error handling by replacing goto labels with direct returns.
> 
> Change-Id: I52e31c0bed3d2772c800a535af8abdabd81a178b
> Signed-off-by: Fuad Tabba <tabba@google.com>

See below and read the cleanup.h guidance notes on usage at the top.
Specifically:

 * Lastly, given that the benefit of cleanup helpers is removal of
 * "goto", and that the "goto" statement can jump between scopes, the
 * expectation is that usage of "goto" and cleanup helpers is never
 * mixed in the same function. I.e. for a given routine, convert all
 * resources that need a "goto" cleanup to scope-based cleanup, or
 * convert none of them.

Doing otherwise might mean an encounter with a grumpy Linus :)
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 86 +++++++++++++++++++------------------------
>  1 file changed, 38 insertions(+), 48 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 94161ea1cd60..0c772501c3ba 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -239,6 +239,8 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
>  	int ret = 0;
>  	void *rx_virt, *tx_virt;
>  
> +	guard(hyp_spinlock)(&host_buffers.lock);
> +
>  	if (npages != (KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) / FFA_PAGE_SIZE) {
>  		ret = FFA_RET_INVALID_PARAMETERS;
>  		goto out;
> @@ -249,10 +251,9 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
>  		goto out;
>  	}
>  
> -	hyp_spin_lock(&host_buffers.lock);
>  	if (host_buffers.tx) {
>  		ret = FFA_RET_DENIED;
> -		goto out_unlock;
> +		goto out;
Whilst it isn't a bug as such because you increased the scope to avoid it,
there is some pretty strong guidance in cleanup.h about not using guard() or
any of the other magic if a function that also contains gotos.  That came from
some views Linus expressed pretty clearly about the dangers that brings (the
problem is a goto that crosses a guard() being defined and the risk of
refactors that happen to end up with that + general view that cleanup.h
stuff is about removing gotos, so if you still have them, why bother!

You can usually end up with the best of all worlds via some refactors
to pull out helper functions, but that's a lot of churn.

Jonathan


>  	}
>  
>  	/*
> @@ -261,7 +262,7 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
>  	 */
>  	ret = ffa_map_hyp_buffers(npages);
>  	if (ret)
> -		goto out_unlock;
> +		goto out;
>  
>  	ret = __pkvm_host_share_hyp(hyp_phys_to_pfn(tx));
>  	if (ret) {
> @@ -292,8 +293,6 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
>  	host_buffers.tx = tx_virt;
>  	host_buffers.rx = rx_virt;
>  
> -out_unlock:
> -	hyp_spin_unlock(&host_buffers.lock);
>  out:
>  	ffa_to_smccc_res(res, ret);
>  	return;
> @@ -306,7 +305,7 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
>  	__pkvm_host_unshare_hyp(hyp_phys_to_pfn(tx));
>  err_unmap:
>  	ffa_unmap_hyp_buffers();
> -	goto out_unlock;
> +	goto out;
>  }
>  

