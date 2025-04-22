Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2F318D63A;
	Tue, 22 Apr 2025 16:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745340643; cv=none; b=jwK5+PjwquL5KVg8QSwmqfJfwsr+Zm8MXlqHXsuwAlln6FPJmqltnmRnQtEElEFAeIrpOZWdKjJj/0GIQCCCqJ9wVvPyL13TBFLRM829OvNzQakuHA+6K7MS+hlTQCU7Cz2x8zlXzeCfnukTIo2tKY+5P7Q+EbRhjbbuqBjZFx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745340643; c=relaxed/simple;
	bh=p34W68vr33YVTNMyvW/ckCaII9Sr9kH22loqQhoIvVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cjFvRM0yheGtB1sR9QEtjoVfLc9AvK6YiYy5s8eKRtgBOujFmZL3Rjj4HqGpqt6i5mdPS6iCtWNAs+tt8KLuwcuGte0x3wlNAE4kaFHKwQcp9YCqUF/6MC8ItpkoF/znZa4aNhTjP8AAZASbnvKXz0GoSiZeDFHUsueNv8KCxUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325B1C4CEE9;
	Tue, 22 Apr 2025 16:50:35 +0000 (UTC)
Date: Tue, 22 Apr 2025 17:50:32 +0100
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
Message-ID: <aAfI2GR1__-1KQHn@arm.com>
References: <Z-QnBcE1TKPChQay@google.com>
 <86wmcbllg2.wl-maz@kernel.org>
 <Z-RGYO3QVj5JNjRB@google.com>
 <20250331145643.GF10839@nvidia.com>
 <Z_PtKWnMPzwPb4sp@google.com>
 <20250407161540.GG1557073@nvidia.com>
 <Z_QAxiEWEyMpfLgL@google.com>
 <SA1PR12MB719976799AD7F9FC4407A5A9B0BD2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aAdKCGCuwlUeUXKY@linux.dev>
 <20250422135452.GL823903@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422135452.GL823903@nvidia.com>

On Tue, Apr 22, 2025 at 10:54:52AM -0300, Jason Gunthorpe wrote:
> On Tue, Apr 22, 2025 at 12:49:28AM -0700, Oliver Upton wrote:
> >  - The memslot flag says userspace expects a particular GFN range to guarantee
> >    Write-Back semantics. This can be applied to 'normal', kernel-managed memory
> >    and PFNMAP thingies that have cacheable attributes at host stage-1.
> 
> Userspace doesn't actaully know if it has a cachable mapping from VFIO
> though :(

Yes, that's why I couldn't figure out how useful a memory slot flag
would be.

A CAP is definitely useful and some way of preventing migrating between
hosts with different capabilities for VM_PFNMAP is needed. However, I
think we only want to prevent migration _if_ there's a cacheable
VM_PFNMAP, otherwise KVM handles coherency via CMOs already.

So, for the above, the VMM needs to know that it somehow got into such
situation. If it knows the device (VFIO) capabilities and that the user
mapping is Cacheable, coupled with the new KVM CAP, it can infer that
Stage 2 will be S2FWB, no need for a memory slot flag. If it doesn't
have such information, maybe a new memory slot flag can be used to probe
what Stage 2 mapping is going to be: ask for KVM_MEM_PFNMAP_WB. If it
fails, Stage 2 is Device/NC and can attempt again with the WB flag.
It's a bit of a stretch for the KVM API but IIUC there's no option to
query the properties of a memory slot.

FWIW, I don't think we need a memory slot flag for host kernel managed
memory, its S2FWB already.

-- 
Catalin
