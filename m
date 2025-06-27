Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D1A8460;
	Fri, 27 Jun 2025 13:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751032182; cv=none; b=W4DMe0w8FLzHh4/DvABW2DVeQ01KDWUSLdePGL40V/J6L5D5HNzBezBIDNpoSmr9x8Xq+B7sopchYr7YH24CNYqiANRoi7BbEZUhpWdnNtk9t01mQ6bf3V9Y5awsblsCYezCkbNwNZ6aIm/ySM1Mqc2gT8p1uhaxdtg5w/vUujk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751032182; c=relaxed/simple;
	bh=x75YqVVzzS7TCKzUXIRVofETxdXNt/UoDPIixGWr9DU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N5jRby6Fkt2YTgtG29lG2JfXtoMyFJGoh+kRIxY/r0Bt4pT9yBUog68kPSErq0DDOTd31Zx/s50/0d18+AFzq2F8VAGd1qhMqRr5MVwhcWQ7c90azcELKK7jX5oK53AcUNmfPqgj7SOBGZEcMAClykGqwGlHYuGG1PE0003A12E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tXym3Q84; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tXym3Q84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F9DC4CEE3;
	Fri, 27 Jun 2025 13:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751032181;
	bh=x75YqVVzzS7TCKzUXIRVofETxdXNt/UoDPIixGWr9DU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tXym3Q84Zf5oFf0O8EIrMHuqj8aZsOo5LS+tasIcYOyNV1khV4muUgzsIgJhypT36
	 LLxDOmfCdp6MIbkQDAnE1hcu7PbIR0VP7FdZsnBfmnQ4Xqo4NYv9iCMS08w1+bVDxr
	 yuNxbf2j+dHfJpPSA04KrChBV4Xn62IrSg945Ia0hLhO41fapaoHJmX0IRs+2u4NE3
	 cPAv+OaowQcbaQgJc6Phkf8ZvLtmgvSK8UUmB7GNUOFN5pzKsefuYrgYP6vpfXqV4m
	 OpPp7UlHxPHT7TfN1DGpsNUCACNbloluxbWOaIHkZNQ2pQWlTwp1s9gZXE54ndx3mT
	 v5m+3RqiBEbpA==
Date: Fri, 27 Jun 2025 14:49:30 +0100
From: Will Deacon <will@kernel.org>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, ryan.roberts@arm.com, shahuang@redhat.com,
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
	linux-arm-kernel@lists.infradead.org, maobibo@loongson.cn,
	pbonzini@redhat.com
Subject: Re: [PATCH v9 3/6] KVM: arm64: Block cacheable PFNMAP mapping
Message-ID: <aF6hamOI7YVDP1Cp@willie-the-truck>
References: <20250621042111.3992-1-ankita@nvidia.com>
 <20250621042111.3992-4-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250621042111.3992-4-ankita@nvidia.com>

On Sat, Jun 21, 2025 at 04:21:08AM +0000, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Fixes a security bug due to mismatched attributes between S1 and
> S2 mapping.
> 
> Currently, it is possible for a region to be cacheable in the userspace
> VMA, but mapped non cached in S2. This creates a potential issue where
> the VMM may sanitize cacheable memory across VMs using cacheable stores,
> ensuring it is zeroed. However, if KVM subsequently assigns this memory
> to a VM as uncached, the VM could end up accessing stale, non-zeroed data
> from a previous VM, leading to unintended data exposure. This is a security
> risk.
> 
> Block such mismatch attributes case by returning EINVAL when userspace
> try to map PFNMAP cacheable. Only allow NORMAL_NC and DEVICE_*.
> 
> CC: Oliver Upton <oliver.upton@linux.dev>
> CC: Catalin Marinas <catalin.marinas@arm.com>
> CC: Sean Christopherson <seanjc@google.com>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  arch/arm64/kvm/mmu.c | 34 +++++++++++++++++++++++++++++++++-
>  1 file changed, 33 insertions(+), 1 deletion(-)

Sorry for the drive-by comment, but I was looking at this old series from
Paolo (look at the cover letter and patch 5):

https://lore.kernel.org/r/20250109133817.314401-1-pbonzini@redhat.com

in which he points out that the arm64 get_vma_page_shift() function
incorrectly assumes that a VM_PFNMAP VMA is physically contiguous, which
may not be the case if a driver calls remap_pfn_range() to mess around
with mappings within the VMA. I think that implies that the optimisation
in 2aa53d68cee6 ("KVM: arm64: Try stage2 block mapping for host device
MMIO") is unsound.

But it got me thinking -- given that remap_pfn_range() also takes a 'prot'
argument, how do we ensure that this is reflected in the guest? It feels
a bit dodgy to rely on drivers always passing 'vma->vm_page_prot'.

Will
