Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7321DF747;
	Wed, 19 Mar 2025 18:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742407871; cv=none; b=hmBzFo/HsqyeIsz3tOC+hI87SJfdHcALVDUBGz6qYBp/l/E8LsCoUKSe9+gXKCLnSBn2jKxiZlN5QaCU6NXdtr+lIEA1YNcVgAbgUt6jAv5vumW9aqzncTeK40uQdXMBm4Hgg/uv2D+/C/t0+cRMRzefffY+L9tU39b/yzAvFV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742407871; c=relaxed/simple;
	bh=EM+vNe873hc7WJcks8qH/tKBrTh+jdJpimnSyJPkSTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B7ynSoyXujo7G/6LAtBSbvxND2D+MgeDW5Bfzj3NSU72UJfEimEC2iC17j02Q2BzhX8NiJ2iakyMlY3+IRcaKdnTWP+A6l7CVNqKznF6TiY831rhthgJWuSZOHcMGHJAHCU1BTH8cn56Rl6mSh2X9bGU5zCevDdL61OHRZQ5PZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0305C4CEE4;
	Wed, 19 Mar 2025 18:11:04 +0000 (UTC)
Date: Wed, 19 Mar 2025 18:11:02 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
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
Message-ID: <Z9sItt8BIgvbBY8M@arm.com>
References: <87tt7y7j6r.wl-maz@kernel.org>
 <SA1PR12MB7199B320DAE42A8D7038A78EB0D32@SA1PR12MB7199.namprd12.prod.outlook.com>
 <8634fcnh0n.wl-maz@kernel.org>
 <Z9h98RhunemcFhhz@arm.com>
 <86wmcmn0dp.wl-maz@kernel.org>
 <20250318125527.GP9311@nvidia.com>
 <Z9nJ42PllG8a7AY7@linux.dev>
 <20250318230909.GD9311@nvidia.com>
 <Z9pryQwy2iwa2bpJ@linux.dev>
 <20250319170429.GK9311@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250319170429.GK9311@nvidia.com>

On Wed, Mar 19, 2025 at 02:04:29PM -0300, Jason Gunthorpe wrote:
> On Wed, Mar 19, 2025 at 12:01:29AM -0700, Oliver Upton wrote:
> > You have a very good point that KVM is broken for cacheable PFNMAP'd
> > crap since we demote to something non-cacheable, and maybe that
> > deserves fixing first. Hopefully nobody notices that we've taken away
> > the toys...
> 
> Fixing it is either faulting all access attempts or mapping it
> cachable to the S2 (as this series is trying to do)..

As I replied earlier, it might be worth doing both - fault on !FWB
hardware (or rather reject the memslot creation), cacheable S2
otherwise.

> > I'm less worried about recovery and more focused on userspace being
> > able to understand what happened. Otherwise we may get folks complaining
> > about the ioctl failing "randomly" on certain machines.
> 
> Even today something like qemu doesn't know that VFIO has created a
> cachable mmap, so it would need a bunch more work to feed everything
> through as proposed here.

I came to the same conclusion, qemu wouldn't be able to pass any
KVM_MEMORY_* flag to request cacheable since it doesn't know what
attributes it got from VFIO. You need a side-channel communication
between the host VFIO driver and KVM. With Ankit's proposal, that's the
Stage 1 MMU attributes for the qemu mapping.

-- 
Catalin
