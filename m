Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2991373;
	Mon,  7 Jul 2025 01:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751850064; cv=none; b=koC0cHov8LKPie1mKHBmWRsHIaAwid4QX6pmFjLy9vNt/ZLSlkZk2Kk4QNHqUJ5+9Q696+N74koyoS3BBmkR7JQ6w8rg5EOB+SBKyc5cNBF0GD+bOLuQf+4QHcKjerIKllOpEAd6uF20iG4wVYEvhYQjwuLFSBiQXulmdDMhHuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751850064; c=relaxed/simple;
	bh=DEZcIWx7yI20FcPfShFB4zBbYHGPNy6EVwaMnCfCSkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bg4+xDfGi8Yho8mUgOT5RymMwr7xhPH3w8+ODSl47Z1pYxRm1/AheeIEBbL5zUOSl02VBuqPv4sGMIpxcZ93BS5J9ig7ri/ITP4+LCMywQvFb4fTBbUDdWlHzgkO++D2TWw38nmDTiBPzvGeFZI0DaGfwiz8Nvj07OHGCJqN6cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C44C4CEED;
	Mon,  7 Jul 2025 01:00:28 +0000 (UTC)
Date: Sun, 6 Jul 2025 20:00:27 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	will@kernel.org, ryan.roberts@arm.com, shahuang@redhat.com,
	lpieralisi@kernel.org, david@redhat.com, ddutile@redhat.com,
	seanjc@google.com, aniketa@nvidia.com, cjia@nvidia.com,
	kwankhede@nvidia.com, kjaju@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, zhiw@nvidia.com,
	mochs@nvidia.com, udhoke@nvidia.com, dnigam@nvidia.com,
	alex.williamson@redhat.com, sebastianene@google.com,
	coltonlewis@google.com, kevin.tian@intel.com, yi.l.liu@intel.com,
	ardb@kernel.org, akpm@linux-foundation.org, gshan@redhat.com,
	linux-mm@kvack.org, tabba@google.com, qperret@google.com,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, maobibo@loongson.cn
Subject: Re: [PATCH v10 5/6] KVM: arm64: Allow cacheable stage 2 mapping
 using VMA flags
Message-ID: <aGsbnH4O7sy2WwfV@arm.com>
References: <20250705071717.5062-1-ankita@nvidia.com>
 <20250705071717.5062-6-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250705071717.5062-6-ankita@nvidia.com>

On Sat, Jul 05, 2025 at 07:17:16AM +0000, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Today KVM forces the memory to either NORMAL or DEVICE_nGnRE
> based on pfn_is_map_memory (which tracks whether the device memory
> is in the kernel map) and ignores the per-VMA flags that indicates the
> memory attributes. The KVM code is thus restrictive and allows only for
> the memory that is added to the kernel to be marked as cacheable.
> 
> The device memory such as on the Grace Hopper/Blackwell systems
> is interchangeable with DDR memory and retains properties such as
> cacheability, unaligned accesses, atomics and handling of executable
> faults. This requires the device memory to be mapped as NORMAL in
> stage-2.
> 
> Given that the GPU device memory is not added to the kernel (but is rather
> VMA mapped through remap_pfn_range() in nvgrace-gpu module which sets
> VM_PFNMAP), pfn_is_map_memory() is false and thus KVM prevents such memory
> to be mapped Normal cacheable. The patch aims to solve this use case.
> 
> Note when FWB is not enabled, the kernel expects to trivially do
> cache management by flushing the memory by linearly converting a
> kvm_pte to phys_addr to a KVA, see kvm_flush_dcache_to_poc(). The
> cache management thus relies on memory being mapped. Moreover
> ARM64_HAS_CACHE_DIC CPU cap allows KVM to avoid flushing the icache
> and turns icache_inval_pou() into a NOP. These two capabilities
> are thus a requirement of the cacheable PFNMAP feature. Make use of
> kvm_arch_supports_cacheable_pfnmap() to check them.
> 
> A cachebility check is made by consulting the VMA pgprot value.
> If the pgprot mapping type is cacheable, it is safe to be mapped S2
> cacheable as the KVM S2 will have the same Normal memory type as the
> VMA has in the S1 and KVM has no additional responsibility for safety.
> Checking pgprot as NORMAL is thus a KVM sanity check.
> 
> No additional checks for MTE are needed as kvm_arch_prepare_memory_region()
> already tests it at an early stage during memslot creation. There would
> not even be a fault if the memslot is not created.
> 
> CC: Oliver Upton <oliver.upton@linux.dev>
> CC: Sean Christopherson <seanjc@google.com>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Tested-by: Donald Dutile <ddutile@redhat.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
