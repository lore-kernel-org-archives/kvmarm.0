Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90775332916
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 15:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783609670; cv=none; b=gqFqsX4U5bJmx2XbsxRZ1k6FmFHCG+4r4MdeS1+pQSCpS5dzWryf7UjXHZ5tsGjaISCWLDXbsrM8AaOTwG0U60LVB1WrQVaYdaNIt2xNuQObvKunWfYi7j/Hatfbc3duBPK+d7sWNASoAmbKtvP0uNl/xn7ViUK1/xND0pV1YsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783609670; c=relaxed/simple;
	bh=C3gpjr/ChKhj7UsyNFMgvrn9ykoP//PrM412d9uwPDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A01Qj8fWg04ouiovsz7H5MAiJ5G47jowNX0biN+vovB/uY6J9KWSBdrwKaqWFb73SIKWuJqX7aNphAU/F85/zjqP40DywPLc1qDnGChWtsgfJRUKdjk558QrHgGpmWOUuW7EnitNe819qTvcsBx56Jt5Ru8TgujAv9VuWR6gdQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KGPqvOeo; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KGPqvOeo"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E3A13592;
	Thu,  9 Jul 2026 08:07:43 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 758773F85F;
	Thu,  9 Jul 2026 08:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783609667; bh=C3gpjr/ChKhj7UsyNFMgvrn9ykoP//PrM412d9uwPDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KGPqvOeonO6YUXZhO8LbUsPX1XFgnhM/vx5xENxPF5S9t6I2hUCB9hnO3i9cEdGt8
	 9dD4d/oEFOySlVQVc+VIf6ifEDKgd+YCrMiPoC/SCEi/wDlt6l6mj2MTvkbdUJlXv0
	 M6kh41Vb8ffnGqCUMLKm3Eu3TShGjxSWxnlAMIOY=
Date: Thu, 9 Jul 2026 16:07:43 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH kvmtool v2 3/4] Add support for registering
 guest_memfd-backed memory regions
Message-ID: <ak-5P-bZkbO4UCce@raptor>
References: <20260708182510.2181857-1-fuad.tabba@linux.dev>
 <20260708182510.2181857-4-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708182510.2181857-4-fuad.tabba@linux.dev>

Hi Fuad,

On Wed, Jul 08, 2026 at 07:25:09PM +0100, Fuad Tabba wrote:
> Extend kvm__register_mem() with a guest_memfd file descriptor and
> offset. A bank with a guest_memfd is registered with
> KVM_SET_USER_MEMORY_REGION2 and KVM_MEM_GUEST_MEMFD, binding the
> memslot to the file. This prepares for backing guest RAM with
> guest_memfd on arm64.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  hw/cfi_flash.c    |  2 +-
>  include/kvm/kvm.h | 15 +++++++++++++--
>  kvm.c             | 36 ++++++++++++++++++++++++++----------
>  3 files changed, 40 insertions(+), 13 deletions(-)
> 
> diff --git a/hw/cfi_flash.c b/hw/cfi_flash.c
> index b68d9e0..4413955 100644
> --- a/hw/cfi_flash.c
> +++ b/hw/cfi_flash.c
> @@ -451,7 +451,7 @@ static int map_flash_memory(struct kvm *kvm, struct cfi_flash_device *sfdev)
>  	int ret;
>  
>  	ret = kvm__register_mem(kvm, sfdev->base_addr, sfdev->size,
> -				sfdev->flash_memory,
> +				sfdev->flash_memory, -1, 0,
>  				KVM_MEM_TYPE_RAM | KVM_MEM_TYPE_READONLY);
>  	if (!ret)
>  		sfdev->is_mapped = true;
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index eb23e2f..5e7b5eb 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -128,11 +128,22 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
>  bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u8 is_write);
>  int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr);
>  int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr,
> +		      int guest_memfd, u64 guest_memfd_offset,
>  		      enum kvm_mem_type type);
>  static inline int kvm__register_ram(struct kvm *kvm, u64 guest_phys, u64 size,
>  				    void *userspace_addr)
>  {
>  	return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
> +				 -1, 0, KVM_MEM_TYPE_RAM);
> +}
> +
> +static inline int kvm__register_ram_guest_memfd(struct kvm *kvm, u64 guest_phys,
> +						u64 size, void *userspace_addr,
> +						int guest_memfd,
> +						u64 guest_memfd_offset)
> +{
> +	return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
> +				 guest_memfd, guest_memfd_offset,
>  				 KVM_MEM_TYPE_RAM);

One small nitpick here, KVM_CREATE_GUEST_MEMFD returns -1 on error. If
callers forget to check the result of KVM_CREATE_GUEST_MEMFD and pass the
result to kvm__register_ram_guest_memfd(), the error won't be detected and
kvmtool will end up creating a non-guest_memfd backed memslot. Definitely
unexpected. It might be useful to someone, someday, to add a check here for
guest_memfd >= 0, but it's not terribly important.

Regardless:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

>  }
>  
> @@ -140,13 +151,13 @@ static inline int kvm__register_dev_mem(struct kvm *kvm, u64 guest_phys,
>  					u64 size, void *userspace_addr)
>  {
>  	return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
> -				 KVM_MEM_TYPE_DEVICE);
> +				 -1, 0, KVM_MEM_TYPE_DEVICE);
>  }
>  
>  static inline int kvm__reserve_mem(struct kvm *kvm, u64 guest_phys, u64 size)
>  {
>  	return kvm__register_mem(kvm, guest_phys, size, NULL,
> -				 KVM_MEM_TYPE_RESERVED);
> +				 -1, 0, KVM_MEM_TYPE_RESERVED);
>  }
>  
>  int __must_check kvm__register_iotrap(struct kvm *kvm, u64 phys_addr, u64 len,
> diff --git a/kvm.c b/kvm.c
> index 95ccfcb..947721b 100644
> --- a/kvm.c
> +++ b/kvm.c
> @@ -237,9 +237,9 @@ out:
>  }
>  
>  int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
> -		      void *userspace_addr, enum kvm_mem_type type)
> +		      void *userspace_addr, int guest_memfd,
> +		      u64 guest_memfd_offset, enum kvm_mem_type type)
>  {
> -	struct kvm_userspace_memory_region mem;
>  	struct kvm_mem_bank *merged = NULL;
>  	struct kvm_mem_bank *bank;
>  	struct list_head *prev_entry;
> @@ -320,15 +320,31 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
>  		flags |= KVM_MEM_READONLY;
>  
>  	if (type != KVM_MEM_TYPE_RESERVED) {
> -		mem = (struct kvm_userspace_memory_region) {
> -			.slot			= slot,
> -			.flags			= flags,
> -			.guest_phys_addr	= guest_phys,
> -			.memory_size		= size,
> -			.userspace_addr		= (unsigned long)userspace_addr,
> -		};
> +		if (guest_memfd >= 0) {
> +			struct kvm_userspace_memory_region2 mem2 = {
> +				.slot			= slot,
> +				.flags			= flags | KVM_MEM_GUEST_MEMFD,
> +				.guest_phys_addr	= guest_phys,
> +				.memory_size		= size,
> +				.userspace_addr		= (unsigned long)userspace_addr,
> +				.guest_memfd		= guest_memfd,
> +				.guest_memfd_offset	= guest_memfd_offset,
> +			};
>  
> -		ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
> +			ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2,
> +				    &mem2);
> +		} else {
> +			struct kvm_userspace_memory_region mem = {
> +				.slot			= slot,
> +				.flags			= flags,
> +				.guest_phys_addr	= guest_phys,
> +				.memory_size		= size,
> +				.userspace_addr		= (unsigned long)userspace_addr,
> +			};
> +
> +			ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION,
> +				    &mem);
> +		}
>  		if (ret < 0) {
>  			ret = -errno;
>  			goto out;
> -- 
> 2.39.5
> 
