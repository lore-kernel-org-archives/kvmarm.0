Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A503346A0
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 17:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773769477; cv=none; b=KYM13qWsxjVObrxJmSaPq/ZHrHO4qwnhOrYGXIfEhi6+h9ooECzxYM2bNoz+lZD324fY/KRn8XTbHQcwMQsxBw9+2VblQObamF5MwLw5oLJsud2G4B1Bs7X43SqXZz/2CKiyRXMyEJ5MOA/VJdoEDneA40yJRtn7OPMw2Bf5Flw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773769477; c=relaxed/simple;
	bh=aRXwsuxYFDtjwyajBwNEVNNvTawkga2M1j8033n4bnY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VGLDi2fI2XXK/bkxZrPwuaHCfiNpAxx6nbQ6XK09bIYoN7h+gx8uqR1j9e+otzp1yG6QGTkA0pDYHaBGCJ4yZ/6LwQl0/alDd8poDsXvzMD6ZdTOKih62di9uT2LqaXayMpfGv2ucFxQz+xGEhUc9tCUOe5H3y4It3zKTT1Aba4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fZzpJ5xtRzJ46C6;
	Wed, 18 Mar 2026 01:43:36 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 42B8C4056A;
	Wed, 18 Mar 2026 01:44:33 +0800 (CST)
Received: from localhost (10.48.149.62) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 17 Mar
 2026 17:44:31 +0000
Date: Tue, 17 Mar 2026 17:44:30 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Fuad Tabba <tabba@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, "Joey
 Gouly" <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, "KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64"
	<linux-arm-kernel@lists.infradead.org>, KERNEL VIRTUAL MACHINE FOR ARM64
 KVM/arm64 <kvmarm@lists.linux.dev>, "open list"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] KVM: arm64: Use guard(hyp_spinlock) in mm.c
Message-ID: <20260317174430.00001742@huawei.com>
In-Reply-To: <20260316-tabba-el2_guard-v1-4-456875a2c6db@google.com>
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
	<20260316-tabba-el2_guard-v1-4-456875a2c6db@google.com>
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

On Mon, 16 Mar 2026 17:35:25 +0000
Fuad Tabba <tabba@google.com> wrote:

> Migrate manual hyp_spin_lock() and hyp_spin_unlock() calls managing
> pkvm_pgd_lock to use the guard(hyp_spinlock) macro.
> 
> This eliminates manual unlock calls on return paths and simplifies
> error handling by replacing goto labels with direct returns.
> Note: hyp_fixblock_lock spans across hyp_fixblock_map/unmap functions,
> so it retains explicit lock/unlock semantics to avoid RAII violations.
> 
> Change-Id: I6bb3f4105e95480269e5bf8289d084c8f9981730
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/mm.c | 37 ++++++++++---------------------------
>  1 file changed, 10 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index 218976287d3f..7a15c9fc15e5 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> @@ -35,13 +35,8 @@ static DEFINE_PER_CPU(struct hyp_fixmap_slot, fixmap_slots);

>  
>  static int __pkvm_alloc_private_va_range(unsigned long start, size_t size)
> @@ -80,10 +75,9 @@ int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr)
>  	unsigned long addr;
>  	int ret;
>  
> -	hyp_spin_lock(&pkvm_pgd_lock);
> +	guard(hyp_spinlock)(&pkvm_pgd_lock);
>  	addr = __io_map_base;
>  	ret = __pkvm_alloc_private_va_range(addr, size);
> -	hyp_spin_unlock(&pkvm_pgd_lock);
>  
>  	*haddr = addr;
Maybe it looses meaning but given this sets *haddr on error or not
can reorder and save a few lines.

	addr = __iomap_base;
	*haddr = addr;
	return __pkvm_alloc_private_va_range(addr, size);

	

