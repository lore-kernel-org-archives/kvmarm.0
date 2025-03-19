Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34AE1D5AB7;
	Wed, 19 Mar 2025 21:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742420921; cv=none; b=bcDVsC+e9QpKmAwbQOYC2ojfgPh90QIGdzVwgsn9ld2mdw03BQPAv5UKWv1HMQGK1bmED96VowxLQIP8LfMLYU0JBm/MBLjqeV20ppnOu5at002NL8bNtPvfCx++ONGmqE2gfpSxXYDtJztTXtMeiB9sKeKzg49AqXW7YJHbjn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742420921; c=relaxed/simple;
	bh=KJzdPTe9JTTjYI3qpmfeHHRWXeWPAi6InKIwh4dg89E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VJmdb4kTDrJplXjzebsGncxd5FZsRvYjnq5/L7NwK1tNyLXD1lVgil9QJEitbeKrM5w+LvwUhYPpXqYIB43MTnxCLTROXL2sg0HrtpEkD38WfEoi0ACgAXDG2ZRtn+c3+IgZNlvnU4eN5sEoI6HckHKbSV4uZyu3tFciTBCpr7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C465EC4CEE4;
	Wed, 19 Mar 2025 21:48:33 +0000 (UTC)
Date: Wed, 19 Mar 2025 21:48:31 +0000
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
Message-ID: <Z9s7r2JocpoM_t-m@arm.com>
References: <8634fcnh0n.wl-maz@kernel.org>
 <Z9h98RhunemcFhhz@arm.com>
 <86wmcmn0dp.wl-maz@kernel.org>
 <20250318125527.GP9311@nvidia.com>
 <Z9nJ42PllG8a7AY7@linux.dev>
 <20250318230909.GD9311@nvidia.com>
 <Z9pryQwy2iwa2bpJ@linux.dev>
 <20250319170429.GK9311@nvidia.com>
 <Z9sItt8BIgvbBY8M@arm.com>
 <20250319192246.GQ9311@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250319192246.GQ9311@nvidia.com>

On Wed, Mar 19, 2025 at 04:22:46PM -0300, Jason Gunthorpe wrote:
> On Wed, Mar 19, 2025 at 06:11:02PM +0000, Catalin Marinas wrote:
> > On Wed, Mar 19, 2025 at 02:04:29PM -0300, Jason Gunthorpe wrote:
> > > On Wed, Mar 19, 2025 at 12:01:29AM -0700, Oliver Upton wrote:
> > > > You have a very good point that KVM is broken for cacheable PFNMAP'd
> > > > crap since we demote to something non-cacheable, and maybe that
> > > > deserves fixing first. Hopefully nobody notices that we've taken away
> > > > the toys...
> > > 
> > > Fixing it is either faulting all access attempts or mapping it
> > > cachable to the S2 (as this series is trying to do)..
> > 
> > As I replied earlier, it might be worth doing both - fault on !FWB
> > hardware (or rather reject the memslot creation), cacheable S2
> > otherwise.
> 
> I have no objection, Ankit are you able to make a failure patch?

I'd wait until the KVM maintainers have their say.

-- 
Catalin
