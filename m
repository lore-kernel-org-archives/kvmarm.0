Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6A013D610
	for <kvmarm@lists.linux.dev>; Mon, 24 Jun 2024 19:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719258706; cv=none; b=VVSPkFh29mTGGWzSToqjxoIJDgGvWcgYDpEmg5/JLPWZrmmGSaVMFjoj51l3/cVFgcZPb60H51vkuug6kgsIuUttOBYP1GRQO1Ro31r26o7/DD3WuDMrePNGj9vme4nZgr77VjmtNADLirhmSaVEJgZORvaIvJtibOxaCDQ6MTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719258706; c=relaxed/simple;
	bh=q2WBJnhH06ouZm8Yf9leo2iRfs5owP0mh5zgEjl6mAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mMpY2KEhhu1znMw1NpDGImdlf7Mus3G5OczfO01oxMXjJlVA5aB7IrXe1uo/BSGy3XqY1exEAb4sGKKLAsAp/nPe7hUSm2s4mHdhNAGvs1GVxC0HaVo6JS6J3nODZ7mvy6YHStR4JzWRzZq+PZQld5PPZ09WzmDMmjZ9EmoMw0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qGYwucPW; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qGYwucPW"
X-Envelope-To: seanjc@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719258702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a/ily8zf1tNre6lVxEBeVHCfF/n+Ja8rvulfaJ3WRUQ=;
	b=qGYwucPWKDCqh/dFigzwobI4DeD5oo95P6PExM/FKc4f+duoEbiRNtqreNlECzap2I3xCQ
	v4hlHuuNz9//plF3i1SFKohXnx5n9xIscUujSCTA6QwZjdLjqMsspRotEF3v9geC6VSRHY
	T6fucsBfDelkh6doVRdWKflCAggG9nk=
X-Envelope-To: jgg@ziepe.ca
X-Envelope-To: shameerali.kolothum.thodi@huawei.com
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: iommu@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linuxarm@huawei.com
X-Envelope-To: kevin.tian@intel.com
X-Envelope-To: alex.williamson@redhat.com
X-Envelope-To: maz@kernel.org
X-Envelope-To: will@kernel.org
X-Envelope-To: robin.murphy@arm.com
X-Envelope-To: jean-philippe@linaro.org
X-Envelope-To: jonathan.cameron@huawei.com
Date: Mon, 24 Jun 2024 12:51:34 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com,
	kevin.tian@intel.com, alex.williamson@redhat.com, maz@kernel.org,
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org,
	jonathan.cameron@huawei.com
Subject: Re: [RFC PATCH v2 4/7] iommufd: Associate kvm pointer to iommufd ctx
Message-ID: <ZnnORmCHrEI0KkGz@linux.dev>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-5-shameerali.kolothum.thodi@huawei.com>
 <20240208154210.GP31743@ziepe.ca>
 <ZnmkbOfWBJHrO2sx@google.com>
 <20240624170747.GA1515249@ziepe.ca>
 <Znmy3QPAUIX9SnGx@google.com>
 <20240624180148.GV791043@ziepe.ca>
 <ZnnFML-P1dzHdraI@linux.dev>
 <ZnnJA3ueCXsDtyB7@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnnJA3ueCXsDtyB7@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 24, 2024 at 12:29:07PM -0700, Sean Christopherson wrote:
> On Mon, Jun 24, 2024, Oliver Upton wrote:
> > On Mon, Jun 24, 2024 at 03:01:48PM -0300, Jason Gunthorpe wrote:
> > > If KVM can change VMID on the fly then that is a further complication
> > > :\
> 
> Ya, as written today, KVM doesn't assign a VMID when the VM is created, and instead
> allocates VMIDs on-demand when a vCPU is run.
> 
> The KVM changes in this series allow "pinning" the currently assigned VMID, i.e.
> tries to address that further complication.  But because of the on-demand
> allocation, there might not be a currently assigned VMID for VM, or the VMID might
> be stale, i.e. re-assigned to a different VM.
> 
> Thus, kvm_arm_pinned_vmid_get() can effectively trigger VMID allocations, and
> thus cgroup charging and failure.
> 
> If I'm reading the ARM code correctly, the intent is to cycle through VMIDs as  
> necessary so that it's possible for every actively running VM to have a VMID.
> And maybe also to also minimize the number of TLB + I$ invalidations?

The commentary about TLBIs + I$ invalidations is in relation to how
rollover is handled. The kernel's ASID allocator does some deferred
invalidation, the VMID allocator does some eager invalidation at rollover
because it is believed to be a rarer occurrence.

But generally speaking, it's what you expect, we have some structures in
hardware that use VMID to form a tag, and we wnat to avoid blasting them
if at all possible.

> > > 
> > > > Hmm, kvm_arm_pinned_vmid_get() doesn't fail, it just falls back to VMID=0.  Which
> > > > seems odd.
> > 
> > This is bleeding a bit of implementation detail where VMID=0 is known to
> > be reserved (thus invalid), it'd probably be better if the
> > implementation actually just returned an error.
> 
> Oof, I assumed using VMID=0 just caused a loss of performance, but this makes
> it sound like the IOMMU mappings will fault?

Bit worse than that :)

Having the SMMU participate in broadcast TLB maintenance means TLBI
instructions on the CPU invalidate translations in the SMMU, which is
useful for SVA usecases. However, if the host is using different VMIDs
for the CPU and SMMU, then guest TLBIs no longer match the guest's SMMU
context...

Pinning / sharing the VMID between CPU and SMMU is a hard requirement if
you advertise BTM support to the guest.

-- 
Thanks,
Oliver
