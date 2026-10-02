Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E3EE35B634;
	Fri,  2 Oct 2026 15:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790954115; cv=none; b=jZtToHQb4dRHn7d+IpYu/xOYWX00IqdRCLOCbCpXypz77bGciVAM34Aqoe0izG3+RJOrHoOPRUnsdjdQEDSnys9gLBoxdFcf4Gr66HXxw0IznnVc4OJtP5+dDXEhdFXeYeOxXt/ZX7EpD4wD6genImgF/gTXM/MI7A3MSclDJtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790954115; c=relaxed/simple;
	bh=ELvA9eECm9X8xz8cLNWJerW7Zrs56j8/gPBHi6bQfAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GWUcbwuJkqAournHujBy+X82Zo7gJidT+oH4p4cW7SX/8Ur1Vsd7IVvHGiD1Nu+yWvVCfzJS10UoPRKEQ7WKnqaqnGqBrBQ6ODqJ2/Pr18QlBZKayUHofxL7u5NR0mlkOlZkIAhhoyyCFGtrMxIuAHYHyklEMKTBORBcPXs9I7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=e/z+/n06; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="e/z+/n06"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95834143D;
	Fri,  2 Oct 2026 08:15:09 -0700 (PDT)
Received: from [10.57.8.170] (unknown [10.57.8.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8291F3F85F;
	Fri,  2 Oct 2026 08:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790954113; bh=ELvA9eECm9X8xz8cLNWJerW7Zrs56j8/gPBHi6bQfAQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e/z+/n06DSw8s8JlOWXlAtjzjYm25fc9jLHgrTo3RhyWsmmAIyy3j08qP4TzIdjSS
	 i1XDER7EGZI78JBxCEhHmrhsg6HJecq/80SfKLh1Si6/jmxdcksfoV7sMgyWi7U8LA
	 kq+LppQbltELEHrEHjQrIFbsWBlmpXgBCDEFpcrQ=
Message-ID: <10563362-5964-4ef7-b5d7-fe1d67ce4adb@arm.com>
Date: Fri, 2 Oct 2026 16:15:07 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 05/23] KVM: arm64: Track the type of VM in kvm_arch
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, will@kernel.org,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com,
 jonathan.cameron@oss.qualcomm.com
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
 <20261001210703.1597150-6-suzuki.poulose@arm.com>
 <CA+EHjTxtatPyGcyvEyR129cqUiAYcO_cxRVtwZO0ckZsOnD7TA@mail.gmail.com>
 <86se2o2rbs.wl-maz@kernel.org>
 <CA+EHjTwHuJ0u_TTP46zNFKFmBP124XHHLUVhkAUSyfhe92=41w@mail.gmail.com>
 <86pkxs2npx.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86pkxs2npx.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/10/2026 15:15, Marc Zyngier wrote:
> On Fri, 02 Oct 2026 14:05:17 +0100,
> Fuad Tabba <tabba@google.com> wrote:
>>
>> Hi Marc,
>>
>> On Fri, 02 Oct 2026 13:57:11 +0100, Marc Zyngier <maz@kernel.org> wrote:
>> [...]
>>> Just to make sure. Is that what you had in mind?
>>
>> A diff is worth a thousand words :) Yes, that's it. With that, every
>> remaining hyp user of vcpu_is_protected() only runs with pKVM, so the
>> kern_hyp_va() case in the macro can go too.
> 
> Actually, scratch all of that. The whole thing is written upside down,
> and makes little sense. I wish I had looked at it more closely...
> 
> The *_protected__pkvm() shouldn't exist at all, because nVHE is the
> only context where it matters, and therefore we can specialise the
> *normal* accessors for the nVHE context (see below). No *_pkvm(), no
> kern_hyp_va(), nothing at all.
> 
> I'm also dead against the unprotected_pkvm() stuff, as it looks
> pointlessly specialised. Specifically, this nugget is making my head
> spin:
> 
> +       if (!kvm_vm_is_unprotected_pkvm(vcpu->kvm))
>                  return;
> 
> Honestly, we introduce the flavor stuff to make it easy to match
> things on a particular VM type in a readable way. So why isn't this
> reading:
> 
> 	if (vcpu->kvm->arch.vm_flavor != VM_PROTECTED_PKVM)
> 		return;
> 
> which makes it pretty explicit. You can gate it with a
> is_protected_kvm_enabled() if you want, as it was before.
> 
> 	M.
> 
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 9e1fa00d96f7c..6b64f9610f3a3 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1519,41 +1519,22 @@ struct kvm *kvm_arch_alloc_vm(void);
>   
>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
>   
> -#define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor >= __VM_PROTECTED)
> -/*
> - * Accessing vcpu->kvm from nVHE hyp stub is tricky, as we need to convert the
> - * pointer to the hyp VA. With pKVM, the nVHE code runs with the hyp_vcpu,
> - * which is populated correctly.
> - */
> -#define vcpu_is_protected(vcpu)						\
> -	({								\
> -		struct kvm *__kvm = READ_ONCE((vcpu)->kvm);		\
> -		bool __protected = false;				\
> -									\
> -		if (__kvm) {						\
> -			if (is_nvhe_hyp_code() &&			\
> -			    !is_protected_kvm_enabled()) 		\
> -				__kvm = kern_hyp_va(__kvm); 		\
> -									\
> -			__protected = kvm_vm_is_protected(__kvm);	\
> -		}							\
> -		__protected;						\
> -	})
> -
> -#define kvm_vm_is_protected_pkvm(kvm)					\
> +#ifdef __KVM_NVHE_HYPERVISOR__
> +#define kvm_vm_is_protected(kvm)					\
>   	(is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
> -
>   /*
>    * Rely on is_protected_kvm_enabled() check in kvm_vm_is_protected_pkvm() to
>    * make sure the vcpu->kvm is always valid VA in the context
>    */
> -#define vcpu_is_protected_pkvm(vcpu)					\
> +#define vcpu_is_protected(vcpu)						\
>   	({								\
>   		struct kvm *__kvm = READ_ONCE((vcpu)->kvm);		\
> -									\
> -		(__kvm && kvm_vm_is_protected_pkvm(__kvm));		\
> +		(__kvm && kvm_vm_is_protected(__kvm));			\
>   	})
> -
> +#else
> +#define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor >= __VM_PROTECTED)
> +#define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
> +#endif
>   
>   #define kvm_vm_is_unprotected_pkvm(kvm)		\
>   	(is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PKVM))
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 0f4e8b71fa85d..9ba86450fe4af 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2624,7 +2624,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>   	hva_t hva, reg_end;
>   	int ret = 0;
>   
> -	if (kvm_vm_is_protected_pkvm(kvm)) {
> +	if (kvm_vm_is_protected(kvm)) {

We have slightly different handling for Realms. The final code for this
looks like :

	if (kvm_vm_is_protected(kvm)) {
		if (new &&
		    new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)) {
			return -EPERM;
		}
	}

	if (kvm_vm_is_protected_pkvm(kvm)) {
		/* Cannot modify memslots once a pVM has run. */
		if (pkvm_hyp_vm_is_created(kvm) &&
		    (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
			return -EPERM;
		}
	} else if (kvm_realm_is_created(kvm)) {
		/*
		 * Once the Realm is created, we cannot modify any slots that
		 * could be providing private memory. i.e., guest_memfd backed
		 * slots.
		 * TODO: Handle trusted device private memory slots
		 */
		if (kvm_slot_has_gmem(old) || kvm_slot_has_gmem(new))
			return -EPERM;
	}


Of course we could invert the checks to detect vm_is_protected_pkvm()

Suzuki

>   		/* Cannot modify memslots once a pVM has run. */
>   		if (pkvm_hyp_vm_is_created(kvm) &&
>   		    (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
> 

