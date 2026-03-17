Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D0D337B81
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 17:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773769661; cv=none; b=QMrtQhnZl46J42poakLJKm5rJsFy8FWXPr5wNeOhji6vyHYAYY2g7MZnBP1p7mwxeTdjSnVw/0Fqlw9IDYR+SBh15vHHsOLNi9/Rpiy3+6SHiTg/N/jhxdeaVhfJHCI5hms+hv5PgHteP3X+Q5qIoj8sL+NncvDQmpNEr268frI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773769661; c=relaxed/simple;
	bh=ugKpVJO0iMLBix0FH9mFV11olOWDOwDvDjskB4KzK5o=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J7drW2Tw7bDWP3eRx5soSgy+xblZ2ytvYjcvgyxtEGom8edrNq+CnXnpAntST8dFh8zvSmX/03zZ668F+mvgrLfVttKYxGtfzyfsZf4WLidLGdooyk3JdVQj5YNZU6H6uM/4FO+7rXwuE+hop9Q5UEvuYa7qz3zvSUtVaef8QSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fZzss6hM9zJ4692;
	Wed, 18 Mar 2026 01:46:41 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 5A76340572;
	Wed, 18 Mar 2026 01:47:38 +0800 (CST)
Received: from localhost (10.48.149.62) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 17 Mar
 2026 17:47:37 +0000
Date: Tue, 17 Mar 2026 17:47:36 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Fuad Tabba <tabba@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, "Joey
 Gouly" <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, "KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64"
	<linux-arm-kernel@lists.infradead.org>, KERNEL VIRTUAL MACHINE FOR ARM64
 KVM/arm64 <kvmarm@lists.linux.dev>, "open list"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/10] KVM: arm64: Use guard(hyp_spinlock) in pkvm.c
Message-ID: <20260317174736.00004b1a@huawei.com>
In-Reply-To: <20260316-tabba-el2_guard-v1-5-456875a2c6db@google.com>
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
	<20260316-tabba-el2_guard-v1-5-456875a2c6db@google.com>
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

On Mon, 16 Mar 2026 17:35:26 +0000
Fuad Tabba <tabba@google.com> wrote:

> Migrate manual hyp_spin_lock() and hyp_spin_unlock() calls managing
> the global vm_table_lock to use the guard(hyp_spinlock) macro.
> 
> This significantly cleans up validation and error paths during VM
> creation and manipulation by eliminating the need for goto labels
> and manual unlock procedures on early returns.
> 
> Change-Id: I894df69b3cfe053a77dd660dfb70c95640c6d70c
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---

>  
>  struct pkvm_hyp_vm *get_np_pkvm_hyp_vm(pkvm_handle_t handle)
> @@ -613,9 +605,8 @@ static int insert_vm_table_entry(pkvm_handle_t handle,
>  {
>  	int ret;
>  
> -	hyp_spin_lock(&vm_table_lock);
> +	guard(hyp_spinlock)(&vm_table_lock);
>  	ret = __insert_vm_table_entry(handle, hyp_vm);
> -	hyp_spin_unlock(&vm_table_lock);
>  
>  	return ret;

	return __insert_vm_table_entry();

>  }

> @@ -815,35 +804,35 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
>  	if (!hyp_vcpu)
>  		return -ENOMEM;
>  
> -	hyp_spin_lock(&vm_table_lock);
> +	scoped_guard(hyp_spinlock, &vm_table_lock) {
> +		hyp_vm = get_vm_by_handle(handle);
> +		if (!hyp_vm) {
> +			ret = -ENOENT;
> +			goto err_unmap;

As in earlier patch.  I'd not mix gotos and guard()s.

> +		}
>  
> -	hyp_vm = get_vm_by_handle(handle);
> -	if (!hyp_vm) {
> -		ret = -ENOENT;
> -		goto unlock;
> +		ret = init_pkvm_hyp_vcpu(hyp_vcpu, hyp_vm, host_vcpu);
> +		if (ret)
> +			goto err_unmap;
> +
> +		idx = hyp_vcpu->vcpu.vcpu_idx;
> +		if (idx >= hyp_vm->kvm.created_vcpus) {
> +			ret = -EINVAL;
> +			goto err_unmap;
> +		}
> +
> +		if (hyp_vm->vcpus[idx]) {
> +			ret = -EINVAL;
> +			goto err_unmap;
> +		}
> +
> +		hyp_vm->vcpus[idx] = hyp_vcpu;
> +
> +		return 0;
>  	}
>  
> -	ret = init_pkvm_hyp_vcpu(hyp_vcpu, hyp_vm, host_vcpu);
> -	if (ret)
> -		goto unlock;
> -
> -	idx = hyp_vcpu->vcpu.vcpu_idx;
> -	if (idx >= hyp_vm->kvm.created_vcpus) {
> -		ret = -EINVAL;
> -		goto unlock;
> -	}
> -
> -	if (hyp_vm->vcpus[idx]) {
> -		ret = -EINVAL;
> -		goto unlock;
> -	}
> -
> -	hyp_vm->vcpus[idx] = hyp_vcpu;
> -unlock:
> -	hyp_spin_unlock(&vm_table_lock);
> -
> -	if (ret)
> -		unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
> +err_unmap:
> +	unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
>  	return ret;
>  }
>  
>

