Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF1440096D;
	Thu, 16 Jul 2026 10:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784197536; cv=none; b=k1lfKvVt8sguLMiCEpnz9tjO2Ozrm2wIMwv1TaEE0fjWQd0rhejdmLXR7YkdaMRORIZRnmjs3KdYn8H16hQG05Yo1ThUbg09x5yzci3uGYmZWDEm9RVtaDUD38qKoq4wJQNlo09Gh7zkBisy4hIz4jJwQ2mvWdUOeAQc6J81t3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784197536; c=relaxed/simple;
	bh=x4kSnQlAgSYESyx9NTRUemd971Q4tXKjHfRBi5wLmcE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QoBN7ci4od4BdbQAhBtMwQULWivsFc9CUkKx1qDUPb9U2maMWgD5TuUEFa0uXcoZ2JNWx6Crqnq9wvqUkmZeTT0P+h/oAXV6/jUl//9NDR2pSzo4FpDMTRBXVNsy0755Ttj4kG9Rl1seAn8oCKKp6j7YgXE486lEzBTXnvjy4j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ugV6FvcE; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ugV6FvcE"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B4FF7339;
	Thu, 16 Jul 2026 03:25:29 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A19343F7B4;
	Thu, 16 Jul 2026 03:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784197533; bh=x4kSnQlAgSYESyx9NTRUemd971Q4tXKjHfRBi5wLmcE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ugV6FvcEc/FYjqbDOiHKc2tk7abFU+2mIHkHx0gYYvAepIRtjAagEhuhyjLz+/bKJ
	 dfjrntRzrd2GQXrp3HDJbFa9rFs20uE2B/NSCcuwVniqX7GO2XKkAHtUqAAJsgNDHm
	 Ua3jezZGuS6XODMsGSxX3ix3GrTohLCQF0kJbYUM=
Message-ID: <0a72c33d-0eb7-4cf2-b2c2-86e256740a63@arm.com>
Date: Thu, 16 Jul 2026 11:25:28 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 17/37] KVM: arm64: Expose support for private memory
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-18-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260715142841.80544-18-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/07/2026 15:28, Steven Price wrote:
> Select KVM_GENERIC_MEMORY_ATTRIBUTES and provide the necessary support
> functions.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---

minor nit:

Changes since v14:
   * Switch to guest_memfd in-place memory conversion and drop support
     for KVM_VM_MEMORY_ATTRIBUTES.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

> Changes since v13:
>   * Also update documentation to show that KVM_CAP_MEMORY_ATTRIBUTES is
>     used on arm64.
> Changes since v12:
>   * Only define kvm_arch_has_private_mem() when
>     CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES is set to avoid build issues
>     when KVM is disabled.
> Changes since v10:
>   * KVM_GENERIC_PRIVATE_MEM replacd with KVM_GENERIC_MEMORY_ATTRIBUTES.
> Changes since v9:
>   * Drop the #ifdef CONFIG_KVM_PRIVATE_MEM guard from the definition of
>     kvm_arch_has_private_mem()
> Changes since v2:
>   * Switch kvm_arch_has_private_mem() to a macro to avoid overhead of a
>     function call.
>   * Guard definitions of kvm_arch_{pre,post}_set_memory_attributes() with
>     #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES.
>   * Early out in kvm_arch_post_set_memory_attributes() if the WARN_ON
>     should trigger.
> ---
>   arch/arm64/include/asm/kvm_host.h | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 9b46b39ed11e..993ead6e6449 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1509,6 +1509,8 @@ struct kvm *kvm_arch_alloc_vm(void);
>   
>   #define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
>   
> +#define kvm_arch_has_private_mem(kvm) ((kvm)->arch.is_realm)
> +
>   int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
>   bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>   

