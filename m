Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C998D26AE4
	for <kvmarm@lists.linux.dev>; Fri,  8 Aug 2025 11:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754652794; cv=none; b=YWFIQAPt8JXiOJ2z7kcm0lWrA5gla8hx4e61/wrUIv2zKch/iK4Vk03UvlFvgEhSf40ZWRqAYZF897SR5BEAWRJqvPiFFE3AkdTGLUc0CTk5RhBIVg3I3Jt9HqcSJO5cUlbWObSSsXSn9OqEa9y7p+Wb7NLOOY0PcFjDsMzdWlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754652794; c=relaxed/simple;
	bh=g9uNRp8fmKZF9ZWb5BlkCw/50T+dr1q/Ys9LCxuDbpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SOkKCsW2NUwQqbrB8TSaShmXUdfS+Ba3bNyMwOzxxanIAiLCB04ydS7lzxGp6QFd4wGciGbxBL5cv/iwFkuhtjS4NMN2LrqYuX0h5XysZ1to7DX0G3B8vSRaHGTr/QkFbpzDFUMKTQMwIOK7ebHrEf9kLGAjjpt01gclTqrwQa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AXMjcCvx; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AXMjcCvx"
Message-ID: <3c52f485-cde4-44ef-8ffd-a61a671359db@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754652788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=abYPtt9gp7dt5yQH3k623AWoEHl0Hr24WYJOo0TOVqs=;
	b=AXMjcCvxLwSFAD/YRaO8PD0GKrgmIk2ml8mkVGam9Wpw+pdwiNWB7g9mSzWcYDD78BAnhb
	xJAEMRuY7gcOBFzy0sZZGnIQtr7Gi6Ui/Muf7vFoYS0KWhwvCXh3nwU/0p1q113F5funUo
	Fk3qVMMCxaWr5FIkILLswNSejIidwlo=
Date: Fri, 8 Aug 2025 19:32:54 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH v1 1/8] KVM: arm64: Rename pkvm.enabled to
 pkvm.is_protected
Content-Language: en-US
To: Fuad Tabba <tabba@google.com>, kvmarm <kvmarm@lists.linux.dev>,
 arm-kernel <linux-arm-kernel@lists.infradead.org>
References: <20250729120014.2799359-1-tabba@google.com>
 <20250729120014.2799359-2-tabba@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kunwu Chan <kunwu.chan@linux.dev>
In-Reply-To: <20250729120014.2799359-2-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2025/7/29 20:00, Fuad Tabba wrote:
> The 'pkvm.enabled' field in struct kvm_protected_vm is confusingly named.
> Its purpose is to indicate whether a VM is a pKVM protected VM, not
> whether the VM itself is enabled or running.
> 
> For a non-protected VM, the VM can be fully active, yet this field would
> be false. This ambiguity can lead to incorrect assumptions about the VM's
> operational state and makes the code harder to reason about.
> 
> Rename the field to 'is_protected' to make it unambiguous that the flag
> tracks the protected status of the VM.
> 
> No functional change intended.
> 
lgtm

> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 4 ++--
>   arch/arm64/kvm/hyp/nvhe/pkvm.c    | 2 +-
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 3e41a880b062..55dc7cd83e40 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -252,7 +252,7 @@ struct kvm_protected_vm {
>   	pkvm_handle_t handle;
>   	struct kvm_hyp_memcache teardown_mc;
>   	struct kvm_hyp_memcache stage2_teardown_mc;
> -	bool enabled;
> +	bool is_protected;
>   };
>   
>   struct kvm_mpidr_data {
> @@ -1522,7 +1522,7 @@ struct kvm *kvm_arch_alloc_vm(void);
>   
>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
>   
> -#define kvm_vm_is_protected(kvm)	(is_protected_kvm_enabled() && (kvm)->arch.pkvm.enabled)
> +#define kvm_vm_is_protected(kvm)	(is_protected_kvm_enabled() && (kvm)->arch.pkvm.is_protected)
>   
>   #define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
>   
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 338505cb0171..6198c1d27b5b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -406,7 +406,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
>   	hyp_vm->host_kvm = host_kvm;
>   	hyp_vm->kvm.created_vcpus = nr_vcpus;
>   	hyp_vm->kvm.arch.mmu.vtcr = host_mmu.arch.mmu.vtcr;
> -	hyp_vm->kvm.arch.pkvm.enabled = READ_ONCE(host_kvm->arch.pkvm.enabled);
> +	hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
>   	hyp_vm->kvm.arch.flags = 0;
>   	pkvm_init_features_from_host(hyp_vm, host_kvm);
>   }

Reviewed-by: Kunwu Chan <chentao@kylinos.cn>

-- 
Thanks,
        Kunwu Chan.

