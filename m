Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C489626A095;
	Wed, 23 Apr 2025 10:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745405114; cv=none; b=ai2U2JkjCqtBhzM+u00c3loBkQ91k/kldeQgl/7byO/vEvO2BxJxFFcKq36meeubbWDJxmDzO/iXsH6biLHSAMn+S/VKan2Z/craMmL8p6l52oxImHC1ehRKk2JD6ApHUr6mQtu3YG7T1C9sfIjR1bp0aaVdu9Bqd/uDEdM9Ej0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745405114; c=relaxed/simple;
	bh=F1LgVcI4tPTqHrsMjsMExMH+iK+v1VCmjkBqoe8UBSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GxZUWWKeeYmuM1jcwsHoLhkyGrzt9FSqwMM68FMytznq9mul5dnnsAOnT3ISiu7LOC4qMWMMfEvsYOXBduN7BCkvbdzMOShrx2NMlwSrmUj4NAAnmgVGj9xPBDpN2BEdZTsbmSymaX/riu/hUa/Tix4Q0SffyNA5hf07FtcB5nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2A3C4CEE2;
	Wed, 23 Apr 2025 10:45:06 +0000 (UTC)
Date: Wed, 23 Apr 2025 11:45:04 +0100
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
Message-ID: <aAjEsIwhYQpkphrW@arm.com>
References: <Z_PtKWnMPzwPb4sp@google.com>
 <20250407161540.GG1557073@nvidia.com>
 <Z_QAxiEWEyMpfLgL@google.com>
 <SA1PR12MB719976799AD7F9FC4407A5A9B0BD2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aAdKCGCuwlUeUXKY@linux.dev>
 <20250422135452.GL823903@nvidia.com>
 <aAfI2GR1__-1KQHn@arm.com>
 <20250422170324.GB1645809@nvidia.com>
 <aAgJ8g8Gbb06quSM@linux.dev>
 <20250422233556.GB1648741@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422233556.GB1648741@nvidia.com>

On Tue, Apr 22, 2025 at 08:35:56PM -0300, Jason Gunthorpe wrote:
> On Tue, Apr 22, 2025 at 02:28:18PM -0700, Oliver Upton wrote:
> > Wait, so userspace simultaneously doesn't know the cacheability at host
> > stage-1 but *does* for stage-2? 
> 
> No, it doesn't know either. The point is the VMM doesn't care about
> any of this. It just wants to connect KVM to VFIO and have the kernel
> internally negotiate the details of how that works.
> 
> There is zero value in the VMM being aware that KVM/VFIO is using
> cachable or non-cachable mappings because it will never touch this
> memory anyhow, and arguably it would be happier if it wasn't even in a
> VMA in the first place.

I think this was discussed at some point in the past - what about
ignoring the VMA altogether and using an fd-based approach? Keep the
current VFIO+vma ABI non-cacheable and introduce a new one for cacheable
I/O mappings, e.g. KVM_MEM_IOFD. Is there a way for VFIO to communicate
the attributes to KVM on the type of mapping in the absence of a VMA
(e.g. via the inode)? If not:

Stage 2 could default to non-cacheable and we can add a
KVM_MEMORY_ATTRIBUTE_IO_WB as an option to
ioctl(KVM_SET_MEMORY_ATTRIBUTES) (setup requiring two ioctls). The
latter could fail if S2FWB is not available. But I agree, it does mean
building knowledge of the device in the VMM (it might not be that bad).

-- 
Catalin
