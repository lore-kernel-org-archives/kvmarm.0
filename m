Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5FE46B5;
	Mon,  7 Jul 2025 01:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751850194; cv=none; b=cpmCK5IcRoBRCu5Ie3oAskl71VVbK1DnU0fJvkdIrGXJBAFDNmi61S56KDJsdLXpB8cMNs/PHtmeqGhr4UOIlxIoII/hGh6cFb553PuFxIY1DqMSjZ295iv5M9u7nLP4nso7149uOAQuhCLd3dbjW0Mduk8kqsfsxCKcmmEq1pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751850194; c=relaxed/simple;
	bh=QVFqW/TfONCpjwIkUorfwVAtHHbqbJQu95j9iM0y1bA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CWpk3HVusrsT33SJHH7/9MguXlKcoT/pZ7ooPyzEKgdIf2isthB3a1AlxZrWwiCdpQ0QZP8Ra8R1H5D3veshfoSxXAGHUOrpnMh6dhKgRCobUE7Ag7gH7jG4O0w32IXTECi4mUS66LzEChhBlzEhusTmyoZOxSzS1t4+ADRkd6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DCEC4CEED;
	Mon,  7 Jul 2025 01:02:36 +0000 (UTC)
Date: Sun, 6 Jul 2025 20:02:35 -0500
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
Subject: Re: [PATCH v10 6/6] KVM: arm64: Expose new KVM cap for cacheable
 PFNMAP
Message-ID: <aGscq_R69UpMXpGX@arm.com>
References: <20250705071717.5062-1-ankita@nvidia.com>
 <20250705071717.5062-7-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250705071717.5062-7-ankita@nvidia.com>

On Sat, Jul 05, 2025 at 07:17:17AM +0000, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Introduce a new KVM capability to expose to the userspace whether
> cacheable mapping of PFNMAP is supported.
> 
> The ability to safely do the cacheable mapping of PFNMAP is contingent
> on S2FWB and ARM64_HAS_CACHE_DIC. S2FWB allows KVM to avoid flushing
> the D cache, ARM64_HAS_CACHE_DIC allows KVM to avoid flushing the icache
> and turns icache_inval_pou() into a NOP. The cap would be false if
> those requirements are missing and is checked by making use of
> kvm_arch_supports_cacheable_pfnmap.
> 
> This capability would allow userspace to discover the support.
> It could for instance be used by userspace to prevent live-migration
> across FWB and non-FWB hosts.
> 
> CC: Catalin Marinas <catalin.marinas@arm.com>
> CC: Jason Gunthorpe <jgg@nvidia.com>
> CC: Oliver Upton <oliver.upton@linux.dev>
> CC: David Hildenbrand <david@redhat.com>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Donald Dutile <ddutile@redhat.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
