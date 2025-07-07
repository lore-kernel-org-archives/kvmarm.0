Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656DE3234;
	Mon,  7 Jul 2025 00:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751849510; cv=none; b=FQCN9hKqc+HHrrV40ua0Ps6SxG76hmjWbyRy7BZdD3O6eNxiiOtD4S+34jQHG8f7cWnklFacQsijxxcPZAE0hJfkn8329BS0MmOKHtItALKyeqcnQosANy5rdZ40KD05c6qsPzqEPNoVv3iKqZP7LUgj6pmYwtjlUlIiXGN7/X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751849510; c=relaxed/simple;
	bh=jv3QWzqk9Kg7w0buyaPqmhl66AbIY/3Ak6kzrH8cUx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=habPWiLhXLoiYOQfGhDGWQKnndQTYvw/IydD4iAyXuMswoEXQGwPjNEkGOT82dqh2d9T1OwyTrR5ZhOhKJ28UFvobmSUB8ccvqpTpnysxIY/WJNdVWq8+p6qiz3RCloYfT0qoLstsFkt7xK1CjIL1GtNNCkAESTof90/hM8VxmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA322C4CEED;
	Mon,  7 Jul 2025 00:51:14 +0000 (UTC)
Date: Sun, 6 Jul 2025 19:51:13 -0500
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
Subject: Re: [PATCH v10 1/6] KVM: arm64: Rename the device variable to
 s2_force_noncacheable
Message-ID: <aGsaAXt1PhltCIXo@arm.com>
References: <20250705071717.5062-1-ankita@nvidia.com>
 <20250705071717.5062-2-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250705071717.5062-2-ankita@nvidia.com>

On Sat, Jul 05, 2025 at 07:17:12AM +0000, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> For cache maintenance on a region, ARM KVM relies on that
> region to be mapped to the Kernal virtual address as CMOs
> operate on VA.
> 
> Currently the device variable is effectively trying to setup
> the S2 mapping as non cacheable for memory regions that are
> not mapped in the Kernel VA. This could be either device or
> Normal_NC depending on the VM_ALLOW_ANY_UNCACHED flag in the
> VMA.
> 
> Thus "device" could be better renamed to s2_force_noncacheable
> which implies that it is ensuring that region be mapped as
> non-cacheable.
> 
> CC: Catalin Marinas <catalin.marinas@arm.com>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Tested-by: Donald Dutile <ddutile@redhat.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
