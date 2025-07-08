Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C6F2DC327;
	Tue,  8 Jul 2025 12:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751978871; cv=none; b=HAjDL30hBvyV3PdjSgO8B5HjSm7oa7lxNoMs9rzro2MC54Dcm3FGPGJj2oqk2gmARq6gnjqqINea/sP4RSSx0JVPxvEgBHtIL5cK4dq6Nrshuahwvk9vZXnRWvzkCIcMN8li7618Rmp+qoI03lv5pdSxUu2wUST5QGaykl/p0Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751978871; c=relaxed/simple;
	bh=osuOgrPS2qSqQveywb0omF1aib+vgM1aAsa1ykg2SH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tNQ35tXkdXvOd7PWZ+JMayYHEvbswfK4rI5FAiT/oz7INqZoT9xiCxIy0mUboQP65tSW1aTS7+JY6ydBVu/rvNTt/g8cwE6574v+Rr2GYuu1Ar+0R7p09f8lrBftSLdRV7yI4W33iWVr9bEiIt5Gkx2lUhqXJ+JfUfFrV5jUyH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IAMlhLI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IAMlhLI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA48C4CEED;
	Tue,  8 Jul 2025 12:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751978870;
	bh=osuOgrPS2qSqQveywb0omF1aib+vgM1aAsa1ykg2SH4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IAMlhLI7cory+R2Bv4G4I7BkDERGpi3VYc+VJGMY+ZmNiGrhtDEs5lgtn+8wiu4u6
	 EZFwzSY16+e5Ji4D7Z6CjUvZ/aXOfk0tPqg+X7zkamPyn+7COaeDs9tzZNxW6e1Bde
	 RDRJRPH4YlXqHDgCmiM5y9tWAtKbqTUdHFW/6cSunfJLTNzYsSBxUUuFjipdJmxqcw
	 K7hhKc+761noYebQwzzUpbXXXpHiwdELTf7fK7AeLVsfnlClHKizMH3s0RzYNTa7lh
	 cOMY4Vu2GYsVOri9ahMntePMKOUl0lTQF5na6epLFdZ7pqzS6A+Z0ZkjhA69R2BzK6
	 PfXrRaTRRXXBg==
Date: Tue, 8 Jul 2025 13:47:38 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, Ankit Agrawal <ankita@nvidia.com>,
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
Message-ID: <aG0TaqOgKInyopW0@willie-the-truck>
References: <20250621042111.3992-1-ankita@nvidia.com>
 <20250621042111.3992-4-ankita@nvidia.com>
 <aF6hamOI7YVDP1Cp@willie-the-truck>
 <SA1PR12MB7199144BBDA23C9A06DA12F9B046A@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250630122501.GQ167785@nvidia.com>
 <4b06b163-e1ce-4c20-b878-4593bc86bf53@redhat.com>
 <aGf7gfMjLhrqU5Kv@willie-the-truck>
 <20250704164750.GO1410929@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704164750.GO1410929@nvidia.com>

On Fri, Jul 04, 2025 at 01:47:50PM -0300, Jason Gunthorpe wrote:
> On Fri, Jul 04, 2025 at 05:04:17PM +0100, Will Deacon wrote:
> > On Fri, Jul 04, 2025 at 02:21:32PM +0200, David Hildenbrand wrote:
> > > On 30.06.25 14:25, Jason Gunthorpe wrote:
> > > > On Mon, Jun 30, 2025 at 01:56:43AM +0000, Ankit Agrawal wrote:
> > > > > > Sorry for the drive-by comment, but I was looking at this old series from
> > > > > > Paolo (look at the cover letter and patch 5):
> > > > > > 
> > > > > > https://lore.kernel.org/r/20250109133817.314401-1-pbonzini@redhat.com
> > > > > > 
> > > > > > in which he points out that the arm64 get_vma_page_shift() function
> > > > > > incorrectly assumes that a VM_PFNMAP VMA is physically contiguous, which
> > > > > > may not be the case if a driver calls remap_pfn_range() to mess around
> > > > > > with mappings within the VMA. I think that implies that the optimisation
> > > > > > in 2aa53d68cee6 ("KVM: arm64: Try stage2 block mapping for host device
> > > > > > MMIO") is unsound.
> > > > > 
> > > > > Hm yeah, that does seem problematic. Perhaps we need a new
> > > > > vma flag that could help the driver communicate to the KVM that the
> > > > > mapping is contiguous and it can go ahead with the optimization?
> > > > > E.g. something similar to VM_ALLOW_ANY_UNCACHED.
> > > > 
> > > > I think Paolo has the right direction - remove any attempts by KVM to
> > > > expand contiguity, it should only copy the primary's PTEs and rely on
> > > > the primary to discover contiguity. No new flags.
> > > 
> > > 100%
> > 
> > The part I don't understand, however, is that I can't see an MMU notifier
> > anywhere on the successful remap_pfn_range() path. So if a driver is
> > using that interface to change the mapping properties of a VM_PFNMAP VMA,
> > how do we ensure that the guest doesn't use whatever stale mappings it's
> > faulted in previously? Did I just miss something?
> 
> Generally mmu notifiers are for invalidation, not used when
> establishing new mappings.
> 
> It is not legal to use remap_pfn_range() to replace already mapped
> PTEs. It can only be used during a fop mmap callback to establish the
> first mapping during VMA creation. Thus there can be no present
> mapping cached in a secondary and no need to invalidate.

Aha, thanks, I had completely missed that. I thought remap_pfn_range()
was quietly unmapping any existing mapping it ran into, but that's not
the case at all.

Cheers,

Will
