Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DDF022097
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 15:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783609725; cv=none; b=WHOy1d/YqvY+ej+vzoR44/U0C8uUH1HsI1GtPWh7ew/wjkDXarz2iPCjCeTSqTdtQ1L20M3iVDvfk00f5MVkUj1bgtpuGgzSJ84J3WIA6VaGFTFXeh9c/IsB/o0ATRCpRaqY/JxFdhQJoQ2zH8TRIvF/mOEUl9kz3CtjsjFNmmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783609725; c=relaxed/simple;
	bh=CwFS2WJlCFio/mpGaO/vq3m3jKq4Qc+Ry2rokgUyHTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pU9K3NbaDxa3vSM0+spwlykaY0a2f03z2b7pI5ufu1gCsjQFoRT1W2Gr1g7gHBTv26oFLjtrNYYMfsgWNetVHTW2ztPQniBS87wMVUICgFjfKIVVFCr05S1us7ZzR8c2N2p/U+pAjgPsBM0diH8DwebHqQ731pkcc7c1CtUNO/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=a4XqcMvB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="a4XqcMvB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 607371595;
	Thu,  9 Jul 2026 08:08:38 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3FE773F85F;
	Thu,  9 Jul 2026 08:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783609722; bh=CwFS2WJlCFio/mpGaO/vq3m3jKq4Qc+Ry2rokgUyHTM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a4XqcMvBLz1GPPKAxACip7/c1Oi2a0hKQyx87OicbZU6kL+onYLkxRXSBQUYcjwPm
	 a+u7UPZJS8NEA+Tb19RrI+QZ0fmuvdzjWYwxdxisTMBSaV9Mv09ZUdAF1PZb9URL9l
	 I/Evs4jQ0iv84H4pDDrrEna4N+eK4hVoEq1L87d4=
Date: Thu, 9 Jul 2026 16:08:38 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH kvmtool v2 4/4] arm64: Add --guest-memfd option to back
 guest RAM with guest_memfd
Message-ID: <ak-5dlgHGe0Ru0OU@raptor>
References: <20260708182510.2181857-1-fuad.tabba@linux.dev>
 <20260708182510.2181857-5-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708182510.2181857-5-fuad.tabba@linux.dev>

Hi Fuad,

On Wed, Jul 08, 2026 at 07:25:10PM +0100, Fuad Tabba wrote:
> Back guest RAM with a guest_memfd created with GUEST_MEMFD_FLAG_MMAP
> and GUEST_MEMFD_FLAG_INIT_SHARED, mmapped MAP_SHARED to provide the
> userspace mapping. The guest_memfd file descriptor is closed at
> teardown, after the mapping is removed.
> 
> Protected VMs need in-place shared/private conversion of guest_memfd,
> which the kernel does not support yet, so reject the combination of
> --protected and --guest-memfd.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arm64/include/kvm/kvm-config-arch.h |  5 +++-
>  arm64/kvm.c                         | 43 +++++++++++++++++++++++------
>  include/kvm/kvm.h                   |  1 +
>  include/kvm/util.h                  |  1 +
>  kvm.c                               |  1 +
>  util/util.c                         | 37 +++++++++++++++++++++++++
>  6 files changed, 79 insertions(+), 9 deletions(-)
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
> index fb0b98d..bf4e34e 100644
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

Would you mind not splitting the line after the equal sign? It makes
parsing the code really hard (at least for me).

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
> @@ -84,6 +97,11 @@ void kvm__init_ram(struct kvm *kvm)
>  void kvm__arch_delete_ram(struct kvm *kvm)
>  {
>  	munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
> +
> +	if (kvm->ram_guest_memfd >= 0) {
> +		close(kvm->ram_guest_memfd);
> +		kvm->ram_guest_memfd = -1;
> +	}
>  }
>  
>  void kvm__arch_read_term(struct kvm *kvm)
> @@ -468,6 +486,15 @@ void kvm__arch_validate_cfg(struct kvm *kvm)
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

I think MTE is incompatible with guest_memfd, KVM certainly returns an
error from kvm_arch_prepare_memory_region() when both are set. Since MTE is
enabled by default, it might be useful to let the user know that MTE has
been disabled because of guest_memfd.

Otherwise, everything looks good.

Thanks,
Alex

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
> index 947721b..96583f9 100644
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
> index 05d49c4..51a4591 100644
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
> @@ -169,3 +171,38 @@ void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 si
>  		return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
>  	}
>  }
> +
> +/*
> + * Map guest RAM backed by a guest_memfd. The file descriptor is kept open
> + * until teardown (kvm__arch_delete_ram), after the mapping is removed.
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
> +	if (!kvm__supports_extension(kvm, KVM_CAP_GUEST_MEMFD))
> +		die("kernel does not support guest_memfd");
> +
> +	ret = ioctl(kvm->vm_fd, KVM_CHECK_EXTENSION, KVM_CAP_GUEST_MEMFD_FLAGS);
> +	if (ret < 0 || ((u64)ret & flags) != flags)
> +		die("VM type does not support guest_memfd with mmap");
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
