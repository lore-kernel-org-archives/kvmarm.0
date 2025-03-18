Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C881AC892;
	Tue, 18 Mar 2025 19:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742326057; cv=none; b=OgCv/fzTiHEl4VOj0dKvfbI5IR/TjooUgy2GIqrDrm6EV71E8NqvpTSYAe/6+ccahY5ENnGWVaISCw8o/zp5kEbd6QZWY9SR0WWNknA2NGk9WTzPibBk8kcDMLJXEnmMx90pgps7nOa9ygU3MSpZ+z70Q3k6CxqHsl3Pp5x/02o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742326057; c=relaxed/simple;
	bh=RGtNuqVmMKoyKd4JA6dWAay60qdpiyiwM7/ip1A2oEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TtrI7D+wFMs0yO+g2JKCcZ7h9PbD7PXV3mDqohI1plMIXkPTXnUD9VviYCVqFG0Mb+AU7Sr+ZcS5J6Kk+Q5IbCYBQi4TWxO6f6VzqrEHalC5c7w/u7ZWZ/9WawPRjG5bCNFWBwWlnNUz46T3Run4iCSfVdP45Au88E1w0ffJcdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8352C4CEEE;
	Tue, 18 Mar 2025 19:27:29 +0000 (UTC)
Date: Tue, 18 Mar 2025 19:27:27 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Marc Zyngier <maz@kernel.org>, Ankit Agrawal <ankita@nvidia.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
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
Message-ID: <Z9nJH38Em9XEx3U7@arm.com>
References: <861pv5p0c3.wl-maz@kernel.org>
 <SA1PR12MB7199DD985C45943A663E7003B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
 <86r033olwv.wl-maz@kernel.org>
 <SA1PR12MB7199500A3683B15A64B663D6B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
 <87tt7y7j6r.wl-maz@kernel.org>
 <SA1PR12MB7199B320DAE42A8D7038A78EB0D32@SA1PR12MB7199.namprd12.prod.outlook.com>
 <8634fcnh0n.wl-maz@kernel.org>
 <Z9h98RhunemcFhhz@arm.com>
 <86wmcmn0dp.wl-maz@kernel.org>
 <20250318125527.GP9311@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318125527.GP9311@nvidia.com>

On Tue, Mar 18, 2025 at 09:55:27AM -0300, Jason Gunthorpe wrote:
> On Tue, Mar 18, 2025 at 09:39:30AM +0000, Marc Zyngier wrote:
> > The memslot must also be created with a new flag ((2c) in the taxonomy
> > above) that carries the "Please map VM_PFNMAP VMAs as cacheable". This
> > flag is only allowed if (1) is valid.
> > 
> > This results in the following behaviours:
> > 
> > - If the VMM creates the memslot with the cacheable attribute without
> >   (1) being advertised, we fail.
> > 
> > - If the VMM creates the memslot without the cacheable attribute, we
> >   map as NC, as it is today.
> 
> Is that OK though?
> 
> Now we have the MM page tables mapping this memory as cachable but KVM
> and the guest is accessing it as non-cached.

I don't think we should allow this.

> I thought ARM tried hard to avoid creating such mismatches? This is
> why the pgprot flags were used to drive this, not an opt-in flag. To
> prevent userspace from forcing a mismatch.

We have the vma->vm_page_prot when the memslot is added, so we could use
this instead of additional KVM flags. If it's Normal Cacheable and the
platform does not support FWB, reject it. If the prot bits say
cacheable, it means that the driver was ok with such mapping. Some extra
checks for !MTE or MTE_PERM.

As additional safety, we could check this again in user_mem_abort() in
case the driver played with the vm_page_prot field in the meantime (e.g.
in the .fault() callback).

I'm not particularly keen on using the vm_page_prot but we probably need
to do this anyway to avoid aliases as we can't fully trust the VMM. The
alternative is a VM_* flag that says "cacheable everywhere" and we avoid
the low-level attributes checking.

> > What this doesn't do is *automatically* decide for the VMM what
> > attributes to use. The VMM must know what it is doing, and only
> > provide the memslot flag when appropriate. Doing otherwise may eat
> > your data and/or take the machine down (cacheable mapping on a device
> > can be great fun).
> 
> Again, this is why we followed the VMA flags. The thing creating the
> VMA already made this safety determination when it set pgprot
> cachable. We should not allow KVM to randomly make any PGPROT
> cachable!

Can this be moved to kvm_arch_prepare_memory_region() and maybe an
additional check in user_mem_abort()?

Thinking some more about a KVM capability that the VMM can check, I'm
not sure what it can do with this. The VMM simply maps something from a
device and cannot probe the cacheability - that's a property of the
device that's not usually exposed to user by the driver. The VMM just
passes this vma to KVM. As with the Normal NC, we tried to avoid
building device knowledge into the VMM (and ended up with
VM_ALLOW_ANY_UNCACHED since the VFIO driver did not allow such user
mapping and probably wasn't entirely safe either).

I assume with the cacheable pfn mapping, the whole range covered by the
vma is entirely safe to be mapped as such in user space.

-- 
Catalin
