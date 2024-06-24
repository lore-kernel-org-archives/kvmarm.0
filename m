Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FAE1BC20
	for <kvmarm@lists.linux.dev>; Mon, 24 Jun 2024 19:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719256380; cv=none; b=rrsxfi7awaWKbgDF+tO5qK0JJdNQTGQ9VHjaDorDDc5UgvZfk5UM/02Uk4Q4ckURDRVkFHvBuneUs7A1SnZ/RuJapSX28S1K2kaODn/wrnA9WrP0IhRxAIo4QluTB39VMvoWZ/iUOtowoaxR6Ssb6XKsTQQSc1B0Ot2aiss3BdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719256380; c=relaxed/simple;
	bh=gYXXWxrPvaYgP+1LwUNVnR33N+uHvFyzlTV8iyk8FyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kRrzPvP8Bq+XMz0wHlXy9okCbMop0kJ2K4t5fdfyhYdQ781HeIKQD74R8hglmGT9BonRMSSddK3P+V68cGx3KM88jPmUjUcFbLQJ6mRXWr9G57/m/diVIEhjkF36wyiPUUPJKwOKXyfx52aIYsAkdqR1rxznvsGGRijrqqCIRP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xi4wGQFR; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xi4wGQFR"
X-Envelope-To: jgg@ziepe.ca
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719256376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1lWRzQyS6SGE+ZNKc0Gm6FgpgNB7yNGcXEh7JqMG4qc=;
	b=xi4wGQFRBQouM0fIJVPZkD9y5l/1C3Zo2fbVLeW2oXwZ63YCx2q12HUisD9GalY3U3/r4k
	WaST3mGuP6Nf5Sm6shP7Mt/ba+Bfw8uR01SGpZJy/4aFnRROXLNsH0cbF4FrOTJqYDA6di
	QryorGYdWT42vyL3wQQfKvy81tMISak=
X-Envelope-To: seanjc@google.com
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
Date: Mon, 24 Jun 2024 12:12:48 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Sean Christopherson <seanjc@google.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com,
	kevin.tian@intel.com, alex.williamson@redhat.com, maz@kernel.org,
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org,
	jonathan.cameron@huawei.com
Subject: Re: [RFC PATCH v2 4/7] iommufd: Associate kvm pointer to iommufd ctx
Message-ID: <ZnnFML-P1dzHdraI@linux.dev>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-5-shameerali.kolothum.thodi@huawei.com>
 <20240208154210.GP31743@ziepe.ca>
 <ZnmkbOfWBJHrO2sx@google.com>
 <20240624170747.GA1515249@ziepe.ca>
 <Znmy3QPAUIX9SnGx@google.com>
 <20240624180148.GV791043@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624180148.GV791043@ziepe.ca>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 24, 2024 at 03:01:48PM -0300, Jason Gunthorpe wrote:
> On Mon, Jun 24, 2024 at 10:54:37AM -0700, Sean Christopherson wrote:
> > > > And assuming that pinnable VMIDs are a somewhat scarce resource, it wouldn't
> > > > suprise me if someone wanted to add cgroup integration, e.g. similar to the
> > > > misc cgroup that's used to manage SEV(-ES) ASIDs on KVM AMD (IIUC, an SEV ASID
> > > > is analagous to an ARM VMID).
> > > 
> > > Yeah, but if someone is using such a cgroup then I expect they will
> > > also have an up to date VMM that doesn't trigger this VMID allocation
> > > in the first place...
> > 
> > I suspect we're talking about two different things.  Either that, or I am really
> > lost.
> 
> I mean KVM will have already allocated and charged the cgroup for it's
> use of the VMID. The IOMMU side just has to match it, no second
> allocation of a VMID.
> 
> We wouldn't charge a cgroup for iommu and kvm sharing the same vmid.

I think the concern remains that an operator may want to limit the blast
radius of some runaway VMID allocation in a system. But you're right, a
well-intentioned VMM should wind up with a single charge for all the
stage-2's that used the VMID allocation.

> > > When a KVM is present then the iommu needs to adopt the VMID of KVM,
> > > and that should have a mechanism to ensure the VMID is valid so long
> > > as the IOMMU is using it (eg because the KVM FD is open)
> > 
> > Right, and that's what I'm referring to as "on-demand pinning".  For the IOMMU
> > to adopt a KVM VMID, the VMID needs to be pinned (or KVM would need to notify
> > the IOMMU every time the VMID changed), i.e. every KVM+IOMMU pair pins a VMID
> > that is managed by KVM.
> 
> Ok, right, yes, the expectation is that KVM allocates a VMID at some
> point and it stays fixed for the life of that kvm.
> 
> If KVM can change VMID on the fly then that is a further complication
> :\
> 
> > Hmm, kvm_arm_pinned_vmid_get() doesn't fail, it just falls back to VMID=0.  Which
> > seems odd.

This is bleeding a bit of implementation detail where VMID=0 is known to
be reserved (thus invalid), it'd probably be better if the
implementation actually just returned an error.

VMID=0 is associated with the host's MMU context, which is relevant when
running {n,h}VHE mode, as the VMID tags TLB entries even if stage-2
translation is disabled (HCR_EL2.VM = 0).

-- 
Thanks,
Oliver
