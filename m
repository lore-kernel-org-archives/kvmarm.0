Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB5A13EFF3;
	Fri,  4 Jul 2025 16:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751645068; cv=none; b=eegcQTeO/qaSlZU3pTAgqwzHQ7wZkCmQHDXQIE+6WrU0L6n0DkdHbsGMg9ZUIgO1zYDUDJuna7Lpmsmk+YhA6ZQxWw26LB5nol+VVPxdzUpDxp1qxKmThsxQDq5I/kVwyoJnBQ388/lQmhrJV7eOgvjVQ1BpL/9gwq5b7hE0bio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751645068; c=relaxed/simple;
	bh=M9n2Q9cXb3bGzai3G9o0+Afu6gYoxXbovRVunTPC6tQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GVhJDm2EGX7IhWLt912QI18BeL82rsfUJYTNBVw+Yv+WkFUDwursYD09M6BmJywDHY0D4exbFvaO6ZQEIdfnpyXuuJun/Oa+pklI+8ReU8ImyJlQXh2BJPF4ek6FiHIL27OENm7UmnOU5KfIEzxQcyrsjpUM9z9+LBBhlGspmYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tU7+z4FY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tU7+z4FY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEA0C4CEE3;
	Fri,  4 Jul 2025 16:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751645067;
	bh=M9n2Q9cXb3bGzai3G9o0+Afu6gYoxXbovRVunTPC6tQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tU7+z4FYuh0BVlLIvRisojhalfOl91C0FNBPhC7Xq/ur/19ujU8uZOP8Vfh8ft/IP
	 xpkCMrVGdW0UecnEOmcxvvOVaIaJcbjHzaXOk4kKRES5AWDiQlWSpwh+bzY8ekCaU1
	 SvjjRnmpl6Lg9d3THr39a6aVD1vWHi80o/RncyG8r4Sp8QDOpxwkTejBQZkgO14bRu
	 QeI+oVIOyPMxQgXaAnVDt5Imhl+RXCVBz2xEbZqVJ305jUvyoPMCdSjlFB0oSZf+Pd
	 nQ8HOlRj9225heyBvWv2GBkEhbb/lHmFZaFEDIctjblBDGohhg4Fk+3zdwuHCQstFe
	 0BmXU07FbmmFQ==
Date: Fri, 4 Jul 2025 17:04:17 +0100
From: Will Deacon <will@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"ddutile@redhat.com" <ddutile@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	Krishnakant Jaju <kjaju@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>,
	"coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"tabba@google.com" <tabba@google.com>,
	"qperret@google.com" <qperret@google.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v9 3/6] KVM: arm64: Block cacheable PFNMAP mapping
Message-ID: <aGf7gfMjLhrqU5Kv@willie-the-truck>
References: <20250621042111.3992-1-ankita@nvidia.com>
 <20250621042111.3992-4-ankita@nvidia.com>
 <aF6hamOI7YVDP1Cp@willie-the-truck>
 <SA1PR12MB7199144BBDA23C9A06DA12F9B046A@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250630122501.GQ167785@nvidia.com>
 <4b06b163-e1ce-4c20-b878-4593bc86bf53@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b06b163-e1ce-4c20-b878-4593bc86bf53@redhat.com>

On Fri, Jul 04, 2025 at 02:21:32PM +0200, David Hildenbrand wrote:
> On 30.06.25 14:25, Jason Gunthorpe wrote:
> > On Mon, Jun 30, 2025 at 01:56:43AM +0000, Ankit Agrawal wrote:
> > > > Sorry for the drive-by comment, but I was looking at this old series from
> > > > Paolo (look at the cover letter and patch 5):
> > > > 
> > > > https://lore.kernel.org/r/20250109133817.314401-1-pbonzini@redhat.com
> > > > 
> > > > in which he points out that the arm64 get_vma_page_shift() function
> > > > incorrectly assumes that a VM_PFNMAP VMA is physically contiguous, which
> > > > may not be the case if a driver calls remap_pfn_range() to mess around
> > > > with mappings within the VMA. I think that implies that the optimisation
> > > > in 2aa53d68cee6 ("KVM: arm64: Try stage2 block mapping for host device
> > > > MMIO") is unsound.
> > > 
> > > Hm yeah, that does seem problematic. Perhaps we need a new
> > > vma flag that could help the driver communicate to the KVM that the
> > > mapping is contiguous and it can go ahead with the optimization?
> > > E.g. something similar to VM_ALLOW_ANY_UNCACHED.
> > 
> > I think Paolo has the right direction - remove any attempts by KVM to
> > expand contiguity, it should only copy the primary's PTEs and rely on
> > the primary to discover contiguity. No new flags.
> 
> 100%

The part I don't understand, however, is that I can't see an MMU notifier
anywhere on the successful remap_pfn_range() path. So if a driver is
using that interface to change the mapping properties of a VM_PFNMAP VMA,
how do we ensure that the guest doesn't use whatever stale mappings it's
faulted in previously? Did I just miss something?

Will
