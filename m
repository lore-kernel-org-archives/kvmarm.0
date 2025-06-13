Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E993FE7
	for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 19:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749843517; cv=none; b=OluXUvD73FUmLGLMQoS5x+QHB/CH9O49yNeO2QHi3FQTErNhJkfElCt2fv21n5sThWQIUpQS0ri5962ULQQhuO8uyXf5PqDj+xZg4jrEA+LZvmfes2ic/ZpXfeNXuX40B+6rhDZFPi83X2CaUnXyl5heXIAnbXz783JY99TJ+Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749843517; c=relaxed/simple;
	bh=eberJJVri/JbW+ewBsWi96de30fvoFdHHT2AU4+7Ce0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m9GB+ZgDuyScIk3gbDVW5Q6v1p0yq1yVqZStKSLOQE6Tc321zoN8ChJKo7QY4JfwJCyF01oGyMfekoo5/XWgBRi9IuxV+0Nq2v0CcGXChxvfLVP7OmiIwHkTMWiHJ5xEoRv8206O2IcuIUox+1PS1nfdfyB14ZVZUJ2dYmKC4gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nHVMfSp1; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nHVMfSp1"
Date: Fri, 13 Jun 2025 12:38:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749843512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=05h3cJJBxazbpz5FiVZjgC7ryx5+viWkk/L4vbZmO2k=;
	b=nHVMfSp17TO+6pXWRN4z4CUhv9KXUKZYW16bR+BF10UJ7m/uUOfxNwfBQwC4twFlBHRKSw
	Pf4lttmhhbapozJhj8WeTWmvaEhliYPwyic1QqNvnmgCUFm2IwxzdvvDpp7lJZ6EY7EXPe
	YehBIglTD6fsw9/Y9qBBC2aqrl5gBus=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"david@redhat.com" <david@redhat.com>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	Krishnakant Jaju <kjaju@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
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
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>
Subject: Re: [PATCH v6 3/5] kvm: arm64: New memslot flag to indicate
 cacheable mapping
Message-ID: <aEx-JlaYJsLAQx3J@linux.dev>
References: <20250524013943.2832-1-ankita@nvidia.com>
 <20250524013943.2832-4-ankita@nvidia.com>
 <20250527002652.GM61950@nvidia.com>
 <SA1PR12MB71990A84FDB4350DC02CEC6EB064A@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aEMsDsi3DSm1up0G@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEMsDsi3DSm1up0G@google.com>
X-Migadu-Flow: FLOW_OUT

Hey,

Sorry for going AWOL on this for so long, buried under work for a while.

On Fri, Jun 06, 2025 at 10:57:34AM -0700, Sean Christopherson wrote:
> I would much prefer we have a way userspace query the effective memtype for a
> range of memory, either for a VMA or for a KVM mapping, and let _userspace_ do
> whatever sanity checks it wants.  That seems like it would be more generally
> useful, and would be feasible to support on multiple architectures.  Though I'd
> probably prefer to avoid even that, e.g. in favor of providing enough information
> in other ways so that userspace can (somewhat easily) deduce how KVM will behave
> for a giving mapping.

Agreed, and really userspace needs to know what it has in its own
stage-1 for that to make sense. The idea with a memslot flag is that
you'd get a 'handshake' with KVM, although that only works for a single
memory type.

What's really needed is a fine-grained enumeration as the architecture
allows an implementation to break uniprocessor semantics + coherency for _any_
deviation in memory attributes (e.g. Device-nGnRE v. Device-nGnRnE).
Although in practice it's usually a Normal-* v. Device-* mismatch that
we actually expose to the VMM.

So, in the absence of a complete solution, I guess we can forgo the
memslot flag. OTOH, the KVM cap is still useful since even now we do the
wrong thing with cacheable PFNMAP so KVM_SET_USER_MEMORY_REGION
accepting a VMA doesn't mean much.

Burden is on the VMM to decide what that means in the context of $THING
it wants to install into a memslot.

> > > There is no easy way for VFIO to know to set it, and the kernel will
> > > not allow switching a cachable VMA to non-cachable anyhow.
> > 
> > > So all it does is make it harder to create a memslot.
> > 
> > Oliver had mentioned earlier that he would still prefer a memslot flag as
> > VMM should convey its intent through that flag:
> >
> > https://lore.kernel.org/all/aAdKCGCuwlUeUXKY@linux.dev/
> > Oliver, could you please confirm if you are convinced with not having this
> > flag? Can we rely on MT_NORMAL in vma mapping to convey this?

Yes, following the VMAs memory attributes is the right thing to do. To
be clear, this is something I'd really like to have settled for 6.17.

> Is MT_NORMAL visable and/or controllable by userspace?

Generally speaking, no.

Thanks,
Oliver
