Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4738F6D
	for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 07:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742367718; cv=none; b=G8a0YwUKoB1eY81m74kh6Eruoe2LyZgHiZ4Pzk0b9smXQgPKNRM1fv8GDSh1h5wDyssjoVQc+jKB4WfZWK0ndm5F4neQuSps2AwoEnXVDeZfdBlweOFvUVWAuuptPGX/Y3O3L3Qctg4cwpBfOEJQXl04+pmu6i+SPpDRVYrhrjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742367718; c=relaxed/simple;
	bh=qPYSIU5vvI0BfbWH2DZWEusZccmrKGaY5g/XdjxCxbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dqEo0Fnl0sUSo1LqwWTIATSFtDWDo4cWpzVMGWiy/wywQ2biwoxWzVi7hest7C/gh/K1KVHJqc/mjnEM15++ahggCtbx8rPdWSyRm+0l8WOWIWZ2SWiMgzlQ3HkpI4Mlo9H39P2lgIRS566Iy8O9FZJjKRGLedv0oevEvOABBvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OcPcgCft; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OcPcgCft"
Date: Wed, 19 Mar 2025 00:01:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742367703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xpzhMPP4+wAcr/1ayDu21ECN7kPl3XYHDwtky8EYnxc=;
	b=OcPcgCftbfrf3MAtuJ9yqeGyaxJLEAaieLSg1kFV5cbjph59KwejwaNLXjnQ7JMjdl1Upk
	W5msd0+6R3mPihXlOvRQE/0Hj07vRrfghJnIm24YG6kPfyXuRd4/F3pw4YSw71A+qRF7Bf
	5b6kDJeHQJKBTUA/ZVfpSw7+iz7c9QY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ankit Agrawal <ankita@nvidia.com>,
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
	"seanjc@google.com" <seanjc@google.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <Z9pryQwy2iwa2bpJ@linux.dev>
References: <86r033olwv.wl-maz@kernel.org>
 <SA1PR12MB7199500A3683B15A64B663D6B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
 <87tt7y7j6r.wl-maz@kernel.org>
 <SA1PR12MB7199B320DAE42A8D7038A78EB0D32@SA1PR12MB7199.namprd12.prod.outlook.com>
 <8634fcnh0n.wl-maz@kernel.org>
 <Z9h98RhunemcFhhz@arm.com>
 <86wmcmn0dp.wl-maz@kernel.org>
 <20250318125527.GP9311@nvidia.com>
 <Z9nJ42PllG8a7AY7@linux.dev>
 <20250318230909.GD9311@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318230909.GD9311@nvidia.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 18, 2025 at 08:09:09PM -0300, Jason Gunthorpe wrote:
> > It's far more problematic the other way around, e.g. the host knows that
> > something needs a Device-* attribute and the VM has done something
> > cacheable. The endpoint for that PA could, for example, fall over when
> > lines pulled in by the guest are written back, which of course can't
> > always be traced back to the offending VM.
> > 
> > OTOH, if the host knows that a PA is cacheable and the guest does
> > something non-cacheable, you 'just' have to deal with the usual
> > mismatched attributes problem as laid out in the ARM ARM.
> 
> I think the issue is that KVM doesn't do that usual stuff (ie cache
> flushing) for memory that doesn't have a struct page backing.

Indeed, I clearly paged that out. What I said is how we arrived at the
Device-* v. Normal-NC distinction.

> So nothing in the hypervisor does any cache flushing and I belive you
> end up with a situation where the VMM could have zero'd this cachable
> memory using cachable stores to sanitize it across VMs and then KVM
> can put that memory into the VM as uncached and the VM could then
> access stale non-zeroed data from a prior VM. Yes? This is a security
> problem.

Pedantic, but KVM only cares about cache maintenance in response to the
primary MM, not the VMM. After a stage-2 mapping has been established
userspace cannot expect KVM to do cache maintenance on its behalf.

You have a very good point that KVM is broken for cacheable PFNMAP'd
crap since we demote to something non-cacheable, and maybe that
deserves fixing first. Hopefully nobody notices that we've taken away
the toys...

> So I think the logic we want here in the fault handler is to:
>   Get the mm's PTE
>   If it is cachable:
>     Check if it has a struct page:
>        Yes - KVM flushes it and can use a non-FWB path
>        No - KVM either fails to install it, or installs it using FWB
>            to force cachability. KVM never allows degrading cachable
> 	   to non-cachable when it can't do flushing.
>   Not cachable:
>     Install it with Normal-NC as was previously discussed and merged

We still need to test the VMA flag here to select Normal-NC v. Device.

> > Userspace should be stating intentions on the memslot with the sort of
> > mapping that it wants to create, and a memslot flag to say "I allow
> > cacheable mappings" seems to fit the bill.
> 
> I'm not sure about this, I don't see that the userspace has any
> choice. As above, KVM has to follow whatever is in the PTEs, the
> userspace can't ask for something different here. At best you could
> make non-struct page cachable memory always fail unless the flag is
> given - but why?
> 
> It seems sufficient for fast fail to check if the VMA has PFNMAP and
> pgprot cachable then !FEAT_FWB fails the memslot. There is no real
> recovery from this, the VMM is doing something that cannot be
> supported.

I'm less worried about recovery and more focused on userspace being
able to understand what happened. Otherwise we may get folks complaining
about the ioctl failing "randomly" on certain machines.

But we might need to just expose the FWB-ness of the MMU to userspace
since it can already encounter mismatched attributes when poking struct
page-backed guest memory.

Thanks,
Oliver
