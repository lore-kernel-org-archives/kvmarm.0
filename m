Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6DEC8DC;
	Wed, 23 Apr 2025 12:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745411221; cv=none; b=co/a4RSGCaR6JRnyF4Bdlg/o9Cgo3uf0yoGjZ8TDJ7Dm+tSsn2J8AF5MoUa7NELYwLSi8rMV0LteLYmDUqOSDIXCurh1qJsqoOuLSowUDa6B4oUGQoZ9WPXWCgxXky+jrUU8oiBa/q6f7Fx5ZIBgxcuGGB1535sq+VgeUpH4Ilo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745411221; c=relaxed/simple;
	bh=o5gghZ6saefddk+r/CgA9ob2obijxiQmK7wsIeeSeko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AKmSjuKKNMAZaHemGiwX76QmWhYG5fZl+MIjku0TCBO2n2/PTcJYwUSX6I18yS16v1FhJ6it4qOyosIKQbkNQNn06izWJsxobRTXS5q3A5zfqSuQjfcj/hwYWwQ+ZqsZ7DCbZ6NN5VyB/sj80k5VBJ7JSzppg+7aMZiD/31pux0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679B1C4CEE2;
	Wed, 23 Apr 2025 12:26:54 +0000 (UTC)
Date: Wed, 23 Apr 2025 13:26:51 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
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
Message-ID: <aAjci3rddHt_R_x3@arm.com>
References: <Z_QAxiEWEyMpfLgL@google.com>
 <SA1PR12MB719976799AD7F9FC4407A5A9B0BD2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aAdKCGCuwlUeUXKY@linux.dev>
 <20250422135452.GL823903@nvidia.com>
 <aAfI2GR1__-1KQHn@arm.com>
 <20250422170324.GB1645809@nvidia.com>
 <aAgJ8g8Gbb06quSM@linux.dev>
 <20250422233556.GB1648741@nvidia.com>
 <aAjEsIwhYQpkphrW@arm.com>
 <20250423120243.GD1648741@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423120243.GD1648741@nvidia.com>

On Wed, Apr 23, 2025 at 09:02:43AM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 23, 2025 at 11:45:04AM +0100, Catalin Marinas wrote:
> > On Tue, Apr 22, 2025 at 08:35:56PM -0300, Jason Gunthorpe wrote:
> > > On Tue, Apr 22, 2025 at 02:28:18PM -0700, Oliver Upton wrote:
> > > > Wait, so userspace simultaneously doesn't know the cacheability at host
> > > > stage-1 but *does* for stage-2? 
> > > 
> > > No, it doesn't know either. The point is the VMM doesn't care about
> > > any of this. It just wants to connect KVM to VFIO and have the kernel
> > > internally negotiate the details of how that works.
> > > 
> > > There is zero value in the VMM being aware that KVM/VFIO is using
> > > cachable or non-cachable mappings because it will never touch this
> > > memory anyhow, and arguably it would be happier if it wasn't even in a
> > > VMA in the first place.
> > 
> > I think this was discussed at some point in the past - what about
> > ignoring the VMA altogether and using an fd-based approach? Keep the
> > current VFIO+vma ABI non-cacheable and introduce a new one for cacheable
> > I/O mappings, e.g. KVM_MEM_IOFD. Is there a way for VFIO to communicate
> > the attributes to KVM on the type of mapping in the absence of a VMA
> > (e.g. via the inode)? If not:
> 
> I hope to see that someday. The CC people are working in that
> direction, but we are still far from getting enough agreement from all
> the stakeholders on how that will work.
> 
> > Stage 2 could default to non-cacheable and we can add a
> > KVM_MEMORY_ATTRIBUTE_IO_WB as an option to
> 
> I don't think we should ever allow KVM to create a non-cachable
> mapping of an otherwise cachable object??

Ah, good point. So we want a strict cacheable mapping even if there is
no user/VMM mapping alias. Is it because KVM cannot do cache maintenance
on the PFNMAP or because the device does not support other memory types?
Both valid reasons though.

In this case KVM still needs to know the properties of the device. Not
sure how it could best do this without a vma.

-- 
Catalin
