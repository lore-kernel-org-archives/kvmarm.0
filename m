Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792507394;
	b=atXwRPQmIp+zxxiay2MQFPTk/yDJvdv5zPde6QWWkeaGZ9IeK22VMxn6CiXyu3M7l0Bi
	 Zhzk5teRknenvN5t/FQ+pzYZNT6SssWsICOWkQ7T8GfOLWewPJOIIc/8zKdMTa8ifPbra
	 bPBRda+gkOGHqFvHKAKjCLSYcfm5i4XfzDIJ1srzKPe651IGY4dDZClvxH1JQjjWerqWF
	 9Ob6RmxT2BuZkQ4s1j8otesyBI9wv/6cRCkf6HXa4atvKwPX8n7HLboNIl2Ulc9kdFSub
	 paYsfmTgH2v/nTvsufONbY4G1ltYME7AYNFHJ/1zbbUtkaqwVUFhPl7asxacrdH1enw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792507394;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=jQyDvfX7kGhNcVt2WJOUsbR6Xr7YV1OMvJOHBnTjnZQ=;
	b=sGEr4VG6yGqdQXQXn7hJhWXljcjG14Jp7mCKeflhRnPfmi40oaBldMFKc8utorMW2FLY
	 +dcguLERg6GrOLJ57f1wvOccwIiZa2szfh6WKudUA5XdaqeaCXfmjlhY3EbAu9wqdNol7
	 2TRJGVwlm9hzFpVvoBlCcRyoi5p1vzz6kVi2t405VbgkzrYhC6PKZrmxENQ539Po7/Kg6
	 74wKo47UMkYc5bjuqNtC7NtoCx+lPLuWCDU16S/ORLZgcP6Ym1wT/IOeBikQ1uhqgbsAA
	 /TcAzkMPIclGNsprGzen3F2EyuI6pFnNbQJCGlOIbMQzBTgXclFozDp+ppFz+8H/xXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=hl0e9+IB;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EBF1606A31B
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 14:43:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EBF1606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=hl0e9+IB
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55CB716F8;
	Tue, 20 Oct 2026 07:43:08 -0700 (PDT)
Received: from [10.57.15.218] (unknown [10.57.15.218])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2899E3F7D8;
	Tue, 20 Oct 2026 07:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792507391; bh=W/Yikr956noee/xLRWy1f51hzGlzHc+4smIokQpB9Lg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hl0e9+IBBWp9E+x72oIanT99AIWv1ndjtvX6GN8kI19JG/d+AuHI3PqRQ6e/X8css
	 q2rfFAxHAiCe+WVgV0zQ7cavUxeKYacxdjD4wKMQCTYTDjc7z9R2PIBTMT/nPPcGNM
	 cjqHRZXreBywaD0rBmQJWQJQ4FvcTFVYuTnS+1mI=
Message-ID: <16679dd3-c168-4dee-bb9d-da9b0e3416cf@arm.com>
Date: Tue, 20 Oct 2026 15:43:08 +0100
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool] arm64: THPs for systems with pages bigger than 4K
To: Vincent Donnefort <vdonnefort@google.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 oliver.upton@linux.dev, alexandru.elisei@arm.com, andre.przywara@arm.com
References: <20261019145949.1922019-1-vdonnefort@google.com>
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261019145949.1922019-1-vdonnefort@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/10/2026 15:59, Vincent Donnefort wrote:
> The THP support imposes an alignment of the memslot userspace address to
> the size of a THP (PMD_SIZE). To do so, kvmtool overallocates the RAM
> size and aligns it. However it assumes PMD_SIZE is 2MiB, which is only
> true on 4KiB page systems.
> 
> Use a huge-page size, based on the system page size. This value can be
> massive for a 64KiB page system, so skip the alignment if we couldn't
> even install one THP.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/arm64/kvm.c b/arm64/kvm.c
> index 36b3284e4a92..2c01dc32fa9a 100644
> --- a/arm64/kvm.c
> +++ b/arm64/kvm.c
> @@ -18,6 +18,8 @@
>   
>   #include <asm/image.h>
>   
> +#define HUGEPAGE_SIZE (PAGE_SIZE * (PAGE_SIZE / 8UL))
> +
>   static struct arm64_image_header *kernel_header;
>   
>   struct kvm_ext kvm_req_ext[] = {
> @@ -35,20 +37,23 @@ bool kvm__arch_cpu_supports_vm(void)
>   
>   void kvm__init_ram(struct kvm *kvm)
>   {
> -	u64 phys_start, phys_size;
> +	u64 phys_start, phys_size, ram_alloc_align = SZ_64K;
>   	void *host_mem;
>   	int err;
>   
>   	/*
> -	 * Allocate guest memory. We must align our buffer to 64K to
> -	 * correlate with the maximum guest page size for virtio-mmio.
> -	 * If using THP, then our minimal alignment becomes 2M.
> -	 * 2M trumps 64K, so let's go with that.
> +	 * Allocate guest memory. We must align our buffer to 64K to correlate
> +	 * with the maximum guest page size for virtio-mmio. If using THP, then
> +	 * our minimal alignment trumps 64K, so let's go with that.
>   	 */
>   	kvm->ram_size = kvm->cfg.ram_size;
>   	kvm->arch.ram_alloc_size = kvm->ram_size;
> -	if (!kvm->cfg.hugetlbfs_path)
> -		kvm->arch.ram_alloc_size += SZ_2M;
> +	if (!kvm->cfg.hugetlbfs_path) {
> +		if (kvm->ram_size >= HUGEPAGE_SIZE)
> +			ram_alloc_align = HUGEPAGE_SIZE;

There is logic in builtin-run.c to detect the host_ram_size(), could we
use that instead to decide if we should apply this alignment ? Or retry
the RAM allocation without the alignment on failure ?

It doesn't look like a good idea to hard code this based just on the
requested RAM size.

Cheers
Suzuki



> +
> +		kvm->arch.ram_alloc_size += ram_alloc_align;
> +	}
>   
>   	if (kvm->cfg.arch.guest_memfd)
>   		kvm->arch.ram_alloc_start = mmap_guest_memfd(kvm,
> @@ -63,7 +68,7 @@ void kvm__init_ram(struct kvm *kvm)
>   		    kvm->arch.ram_alloc_size, errno);
>   
>   	kvm->ram_start = (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start,
> -					SZ_2M);
> +					ram_alloc_align);
>   
>   	if (!kvm->cfg.arch.guest_memfd) {
>   		madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> 
> base-commit: f67bc0bdae9433a9cfd05e65ea2c1bb6102566d9

