Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B04A2D0279;
	Tue, 29 Apr 2025 13:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745933232; cv=none; b=SNVzr6H3D6iWAu7mQXwa0CB2ITwP+HRE12YOrqnzs8vcAHsyhgPmUSJZHsxE+221YJomXHKifEKl5sga1n6N21irGyUnUHBsNlzTPgFlzvahTqPybycCBL2sTE1rzKTvKT8AazEbjeek/sgck7W1UN8rULG9sbIMam9+JmcQRTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745933232; c=relaxed/simple;
	bh=zFdCcMGdg0qxT6fwmNW0SaUSwBNyg3n/I8I3UvpWTtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lApdEJjESRjEoEUfnRxN4tJk0ewl/TX6PNPDKwCzcqJYFdur8Lll9kMZJm5L95Tyy0dh0SVVzZAiAyCZ9Ii2oRwwuS4JY+EJhc7KRdCFVv3YPFgMQKY5g035fuegToggps4lRVMAcEgG4iPqvIBoea7EI1i83U/wHjlBCq+BjTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6EFC4CEE3;
	Tue, 29 Apr 2025 13:27:04 +0000 (UTC)
Date: Tue, 29 Apr 2025 14:27:02 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"david@redhat.com" <david@redhat.com>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	Krishnakant Jaju <kjaju@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>,
	"coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"ddutile@redhat.com" <ddutile@redhat.com>,
	"tabba@google.com" <tabba@google.com>,
	"qperret@google.com" <qperret@google.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <aBDTpu_ACoXAPoE2@arm.com>
References: <20250422135452.GL823903@nvidia.com>
 <aAfI2GR1__-1KQHn@arm.com>
 <20250422170324.GB1645809@nvidia.com>
 <aAgJ8g8Gbb06quSM@linux.dev>
 <20250422233556.GB1648741@nvidia.com>
 <aAjEsIwhYQpkphrW@arm.com>
 <20250423120243.GD1648741@nvidia.com>
 <aAjci3rddHt_R_x3@arm.com>
 <20250423130323.GE1648741@nvidia.com>
 <SA1PR12MB71996988916E1FB15149DD13B0802@SA1PR12MB7199.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR12MB71996988916E1FB15149DD13B0802@SA1PR12MB7199.namprd12.prod.outlook.com>

On Tue, Apr 29, 2025 at 10:47:58AM +0000, Ankit Agrawal wrote:
> >> In this case KVM still needs to know the properties of the device. Not
> >> sure how it could best do this without a vma.
> >
> > Well, the idea I hope to succeed with would annotate this kind of
> > information inside the page list that would be exchanged through the
> > FD.
> >
> > There is an monstrous thread here about this topic:
> >
> >
> >
> > https://lore.kernel.org/all/20250107142719.179636-1-yilun.xu@linux.intel.com/
> >
> > I can't find it in the huge thread but I did explain some thoughts on
> > how it could work
> >
> > Jason
> 
> Hi,
> 
> Based on the recent discussions, I gather that having a KVM_CAP
> to expose the support for cacheable PFNMAP to the VMM would be
> useful from VM migration point of view.
> 
> However it appears that the memslot flag isn't a must-have. The memslot
> flag cannot influence the KVM code anyways. For FWB, the PFNMAP would
> be cacheable and userspace should just assume S2FWB behavior; it would
> be a security bug otherwise as Jason pointed earlier (S1 cacheable,
> S2 noncacheable). For !FWB, a cacheable PFNMAP could not be allowed
> and VMM shouldn't attempt to create memslot at all by referring the cap.
> 
> Also, can we take the fd based communication path between VFIO
> and KVM separately?
> 
> I am planning to send out the series with the following implementation.
> Please let me know if there are any disagreements or concerns.
> 
> 1. Block cacheable PFN map in memslot creation (kvm_arch_prepare_memory_region)
> and during fault handling (user_mem_abort()).

I forgot the details here. I think it makes sense in general but as the
first patch, we currently block cacheable PFNMAP anyway. Probably what
you meant already but - this patch should block the PFNMAP slot if
there's a cacheable S1 alias.

> 2. Enable support for cacheable PFN maps if S2FWB is enabled by following
> the vma pgprot (this patch).
> 3. Add and expose the new KVM cap to expose cacheable PFNMAP (set to false
> for !FWB).

I'll defer the memslot flag decision to the KVM maintainers. If we had
one, it will enforce (2) or reject it as per (1) depending on the S1
attributes.

Without the memslot flag, I assume at least the VMM will have to enable
KVM_CAP_ARM_WB_PFNMAP (or whatever it will be called) to get the new
behaviour.

BTW, we should reject exec mappings as well (they probably fail for S1
VFIO since set_pte_at() will try to do cache maintenance).

-- 
Catalin
