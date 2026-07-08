Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E70223ABA7
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 13:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783515770; cv=none; b=FC8bnScPk73iaDxjvNXr/SGl9ShPRQ2qNVbW3mxUePIEwqSwwWYxl9RsmNuaZR/0T1rqhQzn63DCGqvS/Teor5vy9/47FMNkhL3FlvZsWlG/kCPo93xK2qlmTJyJcyms78qNxogo9leIw/p4SCcWhuz0k2uGkPHwKHwGfmUm1ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783515770; c=relaxed/simple;
	bh=NH7+DYgR3YinjwdNb6tMxuFmdTwr8E7NWqfgY4uP7es=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r38eKRrVIxJedp1o6Eq+JcmJwVxZi5l8iJwgTJGOtVb0HMy9MFhwioCYc4N4+bsemx+RPUqH3QrMZDOTqbBuhX/yTnwib9C9rY5/ieEixrIPC3yFdM3s9TnJ4l3gcpf4u3BlW4caR507Gic2zFk2fa5xwAP5rjaHUEwEOXEmkT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FilZL5LC; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FilZL5LC"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 399BE16A3;
	Wed,  8 Jul 2026 06:02:42 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A6AD3F7B4;
	Wed,  8 Jul 2026 06:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783515766; bh=NH7+DYgR3YinjwdNb6tMxuFmdTwr8E7NWqfgY4uP7es=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FilZL5LCkk8tRzeI6IrRGRPuQ3dSiq5o3+P5hkbDjVXSBEwJR4Z/1XbQEK/E09L8x
	 uVFs7pRUu+tZNXEHrgzH0BBzFRPAG+1YN75AXFhK6hErA00lYcEtQrqt8IWk9M67xf
	 JVip09wIkOLFhkefFUT6DOBnBKUNuYvhMN/VzKVc=
Date: Wed, 8 Jul 2026 14:02:42 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH kvmtool v1 5/5] arm64: Add --guest-memfd option to back
 guest RAM with guest_memfd
Message-ID: <ak5KcuSzEo7s9P1s@raptor>
References: <20260706083555.302972-1-fuad.tabba@linux.dev>
 <20260706083555.302972-6-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706083555.302972-6-fuad.tabba@linux.dev>

Hi Fuad,

Looks good me, two small things: it might be useful for debugging to first
check that KVM supports KVM_CAP_GUEST_MEMFD before checking
KVM_CAP_GUEST_MEMFD_FLAGS, and the file descriptor could be closed after it
is unmapped.

Thanks,
Alex

On Mon, Jul 06, 2026 at 09:35:55AM +0100, Fuad Tabba wrote:
> Back guest RAM with a guest_memfd created with GUEST_MEMFD_FLAG_MMAP
> and GUEST_MEMFD_FLAG_INIT_SHARED, mmapped MAP_SHARED to provide the
> userspace mapping.
> 
> Protected VMs need in-place shared/private conversion of guest_memfd,
> which the kernel does not support yet, so reject the combination of
> --protected and --guest-memfd.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arm64/include/kvm/kvm-config-arch.h |  5 +++-
>  arm64/kvm.c                         | 38 +++++++++++++++++++++++------
>  include/kvm/kvm.h                   |  1 +
>  include/kvm/util.h                  |  1 +
>  kvm.c                               |  1 +
>  util/util.c                         | 34 ++++++++++++++++++++++++++
>  6 files changed, 71 insertions(+), 9 deletions(-)
> 
> diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
> index c2702d5..d8a8ef7 100644
> --- a/arm64/include/kvm/kvm-config-arch.h
> +++ b/arm64/include/kvm/kvm-config-arch.h
> @@ -20,6 +20,7 @@ struct kvm_config_arch {
>  	bool		no_pvtime;
>  	bool		psci;
>  	bool		protected;
> +	bool		guest_memfd;
>  };
>  
>  int irqchip_parser(const struct option *opt, const char *arg, int unset);
> @@ -73,6 +74,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
>  	OPT_BOOLEAN('\0', "e2h0", &(cfg)->e2h0,					\
>  		    "Create guest without VHE support"),			\
>  	OPT_BOOLEAN('\0', "protected", &(cfg)->protected,			\
> -			"Create a protected VM when pKVM is enabled"),
> +			"Create a protected VM when pKVM is enabled"),		\
> +	OPT_BOOLEAN('\0', "guest-memfd", &(cfg)->guest_memfd,			\
> +			"Use guest_memfd to back guest RAM"),
>  
>  #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
> diff --git a/arm64/kvm.c b/arm64/kvm.c
> index fb0b98d..b594578 100644
> --- a/arm64/kvm.c
> +++ b/arm64/kvm.c
> @@ -49,9 +49,14 @@ void kvm__init_ram(struct kvm *kvm)
>  	kvm->arch.ram_alloc_size = kvm->ram_size;
>  	if (!kvm->cfg.hugetlbfs_path)
>  		kvm->arch.ram_alloc_size += SZ_2M;
> -	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm,
> -						kvm->cfg.hugetlbfs_path,
> -						kvm->arch.ram_alloc_size);
> +
> +	if (kvm->cfg.arch.guest_memfd)
> +		kvm->arch.ram_alloc_start =
> +			mmap_guest_memfd(kvm, kvm->arch.ram_alloc_size);
> +	else
> +		kvm->arch.ram_alloc_start =
> +			mmap_anon_or_hugetlbfs(kvm, kvm->cfg.hugetlbfs_path,
> +					       kvm->arch.ram_alloc_size);
>  
>  	if (kvm->arch.ram_alloc_start == MAP_FAILED)
>  		die("Failed to map %lld bytes for guest memory (%d)",
> @@ -60,17 +65,25 @@ void kvm__init_ram(struct kvm *kvm)
>  	kvm->ram_start = (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start,
>  					SZ_2M);
>  
> -	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> -		MADV_MERGEABLE);
> +	if (!kvm->cfg.arch.guest_memfd) {
> +		madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> +			MADV_MERGEABLE);
>  
> -	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> -		MADV_HUGEPAGE);
> +		madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> +			MADV_HUGEPAGE);
> +	}
>  
>  	phys_start	= kvm->cfg.ram_addr;
>  	phys_size	= kvm->ram_size;
>  	host_mem	= kvm->ram_start;
>  
> -	err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
> +	if (kvm->cfg.arch.guest_memfd)
> +		err = kvm__register_ram_guest_memfd(kvm, phys_start,
> +						    phys_size, host_mem,
> +						    kvm->ram_guest_memfd,
> +						    host_mem - kvm->arch.ram_alloc_start);
> +	else
> +		err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
>  	if (err)
>  		die("Failed to register %lld bytes of memory at physical "
>  		    "address 0x%llx [err %d]", phys_size, phys_start, err);
> @@ -468,6 +481,15 @@ void kvm__arch_validate_cfg(struct kvm *kvm)
>  	if (kvm->cfg.arch.e2h0 && !kvm->cfg.arch.nested_virt)
>  		pr_warning("--e2h0 requires --nested, ignoring");
>  
> +	if (kvm->cfg.arch.guest_memfd) {
> +		/* Requires in-place shared/private conversion of guest_memfd. */
> +		if (kvm->cfg.arch.protected)
> +			die("Protected VMs do not yet support guest_memfd");
> +
> +		if (kvm->cfg.hugetlbfs_path)
> +			die("guest_memfd cannot be backed by hugetlbfs");
> +	}
> +
>  	if (kvm->cfg.arch.protected) {
>  		if (kvm->cfg.ram_size &&
>  		    kvm->cfg.ram_size < DMA_MEM_REGION_SIZE) {
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index 5e7b5eb..95dc52f 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -90,6 +90,7 @@ struct kvm {
>  	u64			ram_size;	/* Guest memory size, in bytes */
>  	void			*ram_start;
>  	u64			ram_pagesize;
> +	int			ram_guest_memfd; /* guest_memfd backing RAM, -1 if none */
>  	struct mutex		mem_banks_lock;
>  	struct list_head	mem_banks;
>  
> diff --git a/include/kvm/util.h b/include/kvm/util.h
> index a6dba11..9e23431 100644
> --- a/include/kvm/util.h
> +++ b/include/kvm/util.h
> @@ -148,5 +148,6 @@ static inline int pow2_size(unsigned long x)
>  struct kvm;
>  void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
>  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
> +void *mmap_guest_memfd(struct kvm *kvm, u64 size);
>  
>  #endif /* KVM__UTIL_H */
> diff --git a/kvm.c b/kvm.c
> index 3d05756..a400dd2 100644
> --- a/kvm.c
> +++ b/kvm.c
> @@ -162,6 +162,7 @@ struct kvm *kvm__new(void)
>  	mutex_init(&kvm->mem_banks_lock);
>  	kvm->sys_fd = -1;
>  	kvm->vm_fd = -1;
> +	kvm->ram_guest_memfd = -1;
>  
>  #ifdef KVM_BRLOCK_DEBUG
>  	kvm->brlock_sem = (pthread_rwlock_t) PTHREAD_RWLOCK_INITIALIZER;
> diff --git a/util/util.c b/util/util.c
> index 05d49c4..c60fe02 100644
> --- a/util/util.c
> +++ b/util/util.c
> @@ -6,7 +6,9 @@
>  #include "kvm/util.h"
>  
>  #include <kvm/kvm.h>
> +#include <linux/kvm.h>
>  #include <linux/magic.h>	/* For HUGETLBFS_MAGIC */
> +#include <sys/ioctl.h>
>  #include <sys/mman.h>
>  #include <sys/stat.h>
>  #include <sys/statfs.h>
> @@ -169,3 +171,35 @@ void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 si
>  		return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
>  	}
>  }
> +
> +/*
> + * Map guest RAM backed by a guest_memfd. The file descriptor must stay open
> + * for the lifetime of the VM: closing it invalidates the memslot bindings.
> + */
> +void *mmap_guest_memfd(struct kvm *kvm, u64 size)
> +{
> +	u64 flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
> +	struct kvm_create_guest_memfd gmem = {
> +		.size	= size,
> +		.flags	= flags,
> +	};
> +	void *addr;
> +	int ret;
> +
> +	ret = ioctl(kvm->vm_fd, KVM_CHECK_EXTENSION, KVM_CAP_GUEST_MEMFD_FLAGS);
> +	if (ret < 0 || ((u64)ret & flags) != flags)
> +		die("kernel does not support guest_memfd with mmap");
> +
> +	ret = ioctl(kvm->vm_fd, KVM_CREATE_GUEST_MEMFD, &gmem);
> +	if (ret < 0)
> +		die_perror("KVM_CREATE_GUEST_MEMFD");
> +
> +	addr = mmap(NULL, size, PROT_RW, MAP_SHARED, ret, 0);
> +	if (addr == MAP_FAILED)
> +		die_perror("guest_memfd mmap");
> +
> +	kvm->ram_guest_memfd = ret;
> +	kvm->ram_pagesize = getpagesize();
> +
> +	return addr;
> +}
> -- 
> 2.39.5
> 
