Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3841CAA79
	for <kvmarm@lists.linux.dev>; Tue, 22 Apr 2025 07:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745308189; cv=none; b=Hpiqfjq1kTgFkebuTf6cqZwv/rlL0osHa8/yBYU6LWOhu2dLMotCmlGL4CXJKCzWbd8i0ruwgaW5xgp8ctpOt1d25SEGiqH0Q3AOMd1diwVzXYB4fMJOkGWrSg781GTztMhKzPipYSxXN38PNDlNHZxdR7ZnPlT4qG6TUJDt43I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745308189; c=relaxed/simple;
	bh=e4SraDC+na1W/l4sWWobEMTl08KwQBoAMpJbyh1Y+SI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ez4kPsY+YK1dmpwd3pQ54Q2ByPlbajc6f8n5Xe+1KErmPQPf4gdSfRdpJeAxHvUVFErTfZfSgU4zzKwDF8q7NFhAuqMtCWy112mkG2pjAia9zfy15KGaKBEMeTo6sS29b6un3GZlauo0yjgtNACMdCczhVbgLp5RMAJa1p6wFf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a/Zh9RU1; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a/Zh9RU1"
Date: Tue, 22 Apr 2025 00:49:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745308183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hJqa98pwIripZZNEFlA5eT+l3rfPGm52BpjeBkKSrDI=;
	b=a/Zh9RU1U1TvV5VT3C4UdR1t+5WBAKj7kULzD9FlHh34TtMOJ29+lki5buWuabfemAfdZT
	0Aqyu9o7n8jvU5L2pKrHgz9R73Pa6B0nWFUEpPveQucLewVFUkGDG+JnCs4RBYQ9UuwHFC
	2AGzWW6ytzMX+MOSe7QooIzwHm2bqm4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
Message-ID: <aAdKCGCuwlUeUXKY@linux.dev>
References: <Z-QU7qJOf8sEA5R8@google.com>
 <86y0wrlrxt.wl-maz@kernel.org>
 <Z-QnBcE1TKPChQay@google.com>
 <86wmcbllg2.wl-maz@kernel.org>
 <Z-RGYO3QVj5JNjRB@google.com>
 <20250331145643.GF10839@nvidia.com>
 <Z_PtKWnMPzwPb4sp@google.com>
 <20250407161540.GG1557073@nvidia.com>
 <Z_QAxiEWEyMpfLgL@google.com>
 <SA1PR12MB719976799AD7F9FC4407A5A9B0BD2@SA1PR12MB7199.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR12MB719976799AD7F9FC4407A5A9B0BD2@SA1PR12MB7199.namprd12.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

Hi,

On Wed, Apr 16, 2025 at 08:51:05AM +0000, Ankit Agrawal wrote:
> Hi, summarizing the discussion so far and outlining the next steps. The key points
> are as follows:
> 1. KVM cap to expose whether the kernel supports mapping cacheable PFNMAP:
> If the host doesn't have FWB, then the capability doesn't exist. Jason, Oliver, Caitlin
> and Sean points that this may not be required as userspace do not have
> much choice anyways. KVM has to follow the PTEs and userspace cannot ask
> for something different. However, Marc points that enumerating FWB support
> would allow userspace to discover the support and prevent live-migration
> across FWB and non-FWB hosts. Jason suggested that this may still be fine as
> we have already built in VFIO side protection where a live migration can be
> attempted and then fail because of late-detected HW incompatibilities.
> 
> 2. New memslot flag that VMM passes at memslot registration:
> Discussion point that this is not necessary and KVM should just follow the
> VMA pgprot.
> 
> 3. Fallback path handling for PFNMAP when the FWB is not set:
> Discussion points that there shouldn't be any fallback path and the memslot
> should just fail. i.e. KVM should not allow degrading cachable to non-cachable
> when it can't do flushing. This is to prevent the potential security issue
> pointed by Jason (S1 cacheable, S2 noncacheable).
> 
> 
> So AIU, the next step is to send out the updated series with the following patches:
> 1. Block cacheable PFN map in memslot creation (kvm_arch_prepare_memory_region)
> and during fault handling (user_mem_abort()).

Yes, we need to prevent the creation of stage-2 mappings to PFNMAP memory
that uses cacheable attributes in the host stage-1. I believe we have alignment
that this is a bugfix.

> 2. Enable support for cacheable PFN maps if S2FWB is enabled by following
> the vma pgprot (this patch).
> 
> 3. Add and expose the new KVM cap to expose cacheable PFNMAP (set to false
> for !FWB), pending maintainers' feedback on the necessity of this capability.

Regarding UAPI: I'm still convinced that we need the VMM to buy in to this
behavior. And no, it doesn't matter if this is some VFIO-based mapping
or kernel-managed memory.

The reality is that userspace is an equal participant in remaining coherent with
the guest. Whether or not FWB is employed for a particular region of IPA
space is useful information for userspace deciding what it needs to do to access guest
memory. Ignoring the Nvidia widget for a second, userspace also needs to know this for
'normal', kernel-managed memory so it understands what CMOs may be necessary when (for
example) doing live migration of the VM.

So this KVM CAP needs to be paired with a memslot flag.

 - The capability says KVM is able to enforce Write-Back at stage-2

 - The memslot flag says userspace expects a particular GFN range to guarantee
   Write-Back semantics. This can be applied to 'normal', kernel-managed memory
   and PFNMAP thingies that have cacheable attributes at host stage-1.

 - Under no situation do we allow userspace to create non-cacheable mapping at
   stage-2 for something PFNMAP cacheable at stage-1.

No matter what, my understanding is that we all agree the driver which provided the
host stage-1 mapping is the authoritative source for memory attributes compatible
with a given device. The accompanying UAPI is necessary for the VMM to understand how
to handle arbitrary cacheable mappings provided to the VM.

Thanks,
Oliver
