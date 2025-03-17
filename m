Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D468F5E;
	Mon, 17 Mar 2025 19:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742241275; cv=none; b=i/GaIHTLrOm2rqa9eYUErb5Cr3i42aRJ2wpXZ288CHmOdQal2pvV9APgvaseHvLYPCdqhRM7lSXss1ZkLjg1oNdLSTqwL54c9UghZAE54CYnsQ1KHxBFmYfYk0GdvYi+0DJy8JXqHEVzcqIGXydiR/GnPvdN8R71Zdquxh9o+HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742241275; c=relaxed/simple;
	bh=kJb3VCqgO5tQHdb+F4NbmgnHCqO+Gd6jNHKUZWZpdzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Evbe7tVVFccKTzt4WKQ9scwIgJ1BGwA4CvAVkSOC48dL2qRJR1+E3dC4FlkZCMJSp9VTvRTRfKHHtHjLBT79OG1xXA6ic2yLXOk0eETekzppSsxEu8vaT35d0I/R2xjigXRDJ6bwOQRT/WAnXZ9Jq6GfliFICvwTMPnlcLc6004=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF56C4CEE3;
	Mon, 17 Mar 2025 19:54:27 +0000 (UTC)
Date: Mon, 17 Mar 2025 19:54:25 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
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
Message-ID: <Z9h98RhunemcFhhz@arm.com>
References: <20250310103008.3471-1-ankita@nvidia.com>
 <20250310103008.3471-2-ankita@nvidia.com>
 <861pv5p0c3.wl-maz@kernel.org>
 <SA1PR12MB7199DD985C45943A663E7003B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
 <86r033olwv.wl-maz@kernel.org>
 <SA1PR12MB7199500A3683B15A64B663D6B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
 <87tt7y7j6r.wl-maz@kernel.org>
 <SA1PR12MB7199B320DAE42A8D7038A78EB0D32@SA1PR12MB7199.namprd12.prod.outlook.com>
 <8634fcnh0n.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8634fcnh0n.wl-maz@kernel.org>

On Mon, Mar 17, 2025 at 09:27:52AM +0000, Marc Zyngier wrote:
> On Mon, 17 Mar 2025 05:55:55 +0000,
> Ankit Agrawal <ankita@nvidia.com> wrote:
> > 
> > >> For my education, what is an accepted way to communicate this? Please let
> > >> me know if there are any relevant examples that you may be aware of.
> > >
> > > A KVM capability is what is usually needed.
> > 
> > I see. If IIUC, this would involve a corresponding Qemu (usermode) change
> > to fetch the new KVM cap. Then it could fail in case the FWB is not
> > supported with some additional conditions (so that the currently supported
> > configs with !FWB won't break on usermode). 
> > 
> > The proposed code change is to map in S2 as NORMAL when vma flags
> > has VM_PFNMAP. However, Qemu cannot know that driver is mapping
> > with PFNMAP or not. So how may Qemu decide whether it is okay to
> > fail for !FWB or not?
> 
> This is not about FWB as far as userspace is concerned. This is about
> PFNMAP as non-device memory. If the host doesn't have FWB, then the
> "PFNMAP as non-device memory" capability doesn't exist, and userspace
> fails early.
> 
> Userspace must also have some knowledge of what device it obtains the
> mapping from, and whether that device requires some extra host
> capability to be assigned to the guest.
> 
> You can then check whether the VMA associated with the memslot is
> PFNMAP or not, if the memslot has been enabled for PFNMAP mappings
> (either globally or on a per-memslot basis, I don't really care).

Trying to page this back in, I think there are three stages:

1. A KVM cap that the VMM can use to check for non-device PFNMAP (or
   rather cacheable PFNMAP since we already support Normal NC).

2. Memslot registration - we need a way for the VMM to require such
   cacheable PFNMAP and for KVM to check. Current patch relies on (a)
   the stage 1 vma attributes which I'm not a fan of. An alternative I
   suggested was (b) a VM_FORCE_CACHEABLE vma flag, on the assumption
   that the vfio driver knows if it supports cacheable (it's a bit of a
   stretch trying to make this generic). Yet another option is (c) a
   KVM_MEM_CACHEABLE flag that the VMM passes at memslot registration.

3. user_mem_abort() - follows the above logic (whatever we decide),
   maybe with some extra check and WARN in case we got the logic wrong.

The problems in (2) are that we need to know that the device supports
cacheable mappings and we don't introduce additional issues or end up
with FWB on a PFNMAP that does not support cacheable. Without any vma
flag like the current VM_ALLOW_ANY_UNCACHED, the next best thing is
relying on the stage 1 attributes. But we don't know them at the memslot
registration, only later in step (3) after a GUP on the VMM address
space.

So in (2), when !FWB, we only want to reject VM_PFNMAP slots if we know
they are going to be mapped as cacheable. So we need this information
somehow, either from the vma->vm_flags or slot->flags.

-- 
Catalin
