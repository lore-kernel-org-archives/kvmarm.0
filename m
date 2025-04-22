Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A89A38382
	for <kvmarm@lists.linux.dev>; Tue, 22 Apr 2025 21:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745357360; cv=none; b=iPItKOXYA3oAwrsXZS8vZyvq+0JPKZnBRYFZLMB0Uqu31wmGsZvba6bfKI4nCSNZBfX4ezwS4fI8in988oDcGp/D3BN/W+fJuq/Ra2m79bfx+nYeZt0McKKx8Kv0zuXT39oYPuzE4xzH4jwq3FPQf8ESdsruVjMnnW/8InmC6xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745357360; c=relaxed/simple;
	bh=MKbUvh/RyU2Ya4ObtWJFDMOgYe7VZeRqrszwjJFa2cM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=heCSJQ5i3DChf+5v8WwFLaK1t4Urn8KcgVuy6ZKHbGrxAFfiBAG/Fm62c6lMvJxfUDAkvhUx09OjZEW3jQ5ZRYdolhsYNtbfdM/amlKha2xkEUqsSTKiGHxt+slwvjvPl8srbr3XBZLwEKEqqNNGrbSrZW38B8oBXXnn5uTVlFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gBem73Ec; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gBem73Ec"
Date: Tue, 22 Apr 2025 14:28:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745357355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mja1AZU1OxXrkjHbCIJIDiF0DQ5jyuf/4e39r203PXU=;
	b=gBem73Ecuh0/unsaz3dOF7qOKgwwRL9mqWfxjWOT8enzBQcaVl3uy7KuCfLk8qeDISNsQc
	aB0qRfO5QrDh+lJOy5fJlyiHF0EOzQLfbR/mdfZDcmXE2xnqtYJgQSuaXnGzBgyGBT5w1h
	aTV0gtet7CvHeY6tzi2n7dH5Tc54Y/Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Ankit Agrawal <ankita@nvidia.com>,
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
Message-ID: <aAgJ8g8Gbb06quSM@linux.dev>
References: <Z-RGYO3QVj5JNjRB@google.com>
 <20250331145643.GF10839@nvidia.com>
 <Z_PtKWnMPzwPb4sp@google.com>
 <20250407161540.GG1557073@nvidia.com>
 <Z_QAxiEWEyMpfLgL@google.com>
 <SA1PR12MB719976799AD7F9FC4407A5A9B0BD2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aAdKCGCuwlUeUXKY@linux.dev>
 <20250422135452.GL823903@nvidia.com>
 <aAfI2GR1__-1KQHn@arm.com>
 <20250422170324.GB1645809@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422170324.GB1645809@nvidia.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 22, 2025 at 10:54:52AM -0300, Jason Gunthorpe wrote:
> On Tue, Apr 22, 2025 at 12:49:28AM -0700, Oliver Upton wrote:
> > The reality is that userspace is an equal participant in remaining coherent with
> > the guest. Whether or not FWB is employed for a particular region of IPA
> > space is useful information for userspace deciding what it needs to do to access guest
> > memory. Ignoring the Nvidia widget for a second, userspace also needs to know this for
> > 'normal', kernel-managed memory so it understands what CMOs may be necessary when (for
> > example) doing live migration of the VM.
> 
> Really? How does it work today then? Is this another existing problem?
> Userspace is doing CMOs during live migration that are not necessary?

Yes, this is a pre-existing problem. I'm not aware of a live migration
implementation that handles !S2FWB correctly, and assumes all guest
accesses are done through a cacheable alias.

So, if a VMM wants to do migration of VMs on !S2FWB correctly, it'd
probably want to know it can elide CMOs on something that actually bears
the feature.

> >  - The memslot flag says userspace expects a particular GFN range to guarantee
> >    Write-Back semantics. This can be applied to 'normal', kernel-managed memory
> >    and PFNMAP thingies that have cacheable attributes at host stage-1.
> 
> Userspace doesn't actaully know if it has a cachable mapping from VFIO
> though :(

That seems like a shortcoming on the VFIO side, not a KVM issue. What if
userspace wants to do atomics on some VFIO mapping, doesn't it need to
know that it has something with WB?

> I don't really see a point in this. If the KVM has the cap then
> userspace should assume the S2FWB behavior for all cachable memslots.

Wait, so userspace simultaneously doesn't know the cacheability at host
stage-1 but *does* for stage-2? This is why I contend that userspace
needs a mechanism to discover the memory attributes on a given memslot.
Without it there's no way of knowing what's a cacheable memslot.

Along those lines, how is the VMM going to describe that cacheable
PFNMAP region to the guest?

> What should happen if you have S2FWB but don't pass the flag? For
> normal kernel memory it should still use S2FWB. Thus for cachable
> PFNMAP it makes sense that it should also still use S2FWB without the
> flag?

For kernel-managed memory, I agree. Accepting the flag for a memslot
containing such memory would solely be for discoverability.

OTOH, cacheable PFNMAP is a new feature and I see no issue compelling
the use of a new bit with it.

On Tue, Apr 22, 2025 at 02:03:24PM -0300, Jason Gunthorpe wrote:
> On Tue, Apr 22, 2025 at 05:50:32PM +0100, Catalin Marinas wrote:
> 
> > So, for the above, the VMM needs to know that it somehow got into such
> > situation. If it knows the device (VFIO) capabilities and that the user
> > mapping is Cacheable, coupled with the new KVM CAP, it can infer that
> > Stage 2 will be S2FWB, no need for a memory slot flag.
> 
> So long as the memslot creation fails for cachable PFNMAP without
> S2FWB the VMM is fine. qemu will begin its first steps to startup the
> migration destination and immediately fail. The migration will be
> aborted before it even gets started on the source side.
> 
> As I said before, the present situation requires the site's
> orchestration to manage compatibility for live migration of VFIO
> devices. We only expect that the migration will abort early if the
> site has made a configuration error.
> 
> > have such information, maybe a new memory slot flag can be used to probe
> > what Stage 2 mapping is going to be: ask for KVM_MEM_PFNMAP_WB. If it
> > fails, Stage 2 is Device/NC and can attempt again with the WB flag.
> > It's a bit of a stretch for the KVM API but IIUC there's no option to
> > query the properties of a memory slot.
> 
> I don't know of any use case for something like this. If VFIO gives
> the VMM a cachable mapping there is no fallback to WB.
> 
> The operator could use a different VFIO device, one that doesn't need
> cachable, but the VMM can't flip the VFIO device between modes on the
> fly.

I agree with you that in the context of a VFIO device userspace doesn't
have any direct influence on the resulting memory attributes.

The entire reason I'm dragging my feet about this is I'm concerned we've
papered over the complexity of memory attributes (regardless of
provenance) for way too long. KVM's done enough to make this dance 'work'
in the context of kernel-managed memory, but adding more implicit KVM
behavior for cacheable thingies makes the KVM UAPI even more
unintelligible (as if it weren't already).

So this flag isn't about giving userspace any degree of control over
memory attributes. Just a way to know for things it _expects_ to be
treated as cacheable can be guaranteed to use cacheable attributes in
the VM.

Thanks,
Oliver
