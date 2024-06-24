Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA7B13D610
	for <kvmarm@lists.linux.dev>; Mon, 24 Jun 2024 19:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719258756; cv=none; b=dheDQ19MrDNIPfDTk2na5Aj8i0WlLn+QkKhlV6RM3YzLVxduWhiEOxVpFAldS7Yee9Mb8fj4lQUiDNKcNCoorZ35SvX22quuR1TCI314J1apuCvCyiGnqsthJAPFUg9WINjPMW6ZcHdFNmOTQKLzzO7q+eFfxXX1cCMvlTIuSxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719258756; c=relaxed/simple;
	bh=C1yDMOZ8QXAThkUrxm8gWfH0mZlNLXMcyFdQNMvQI7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O2g5P212XHqPMzhsZ/osIDfGPl8j3sAkLaoibFWbAoItkk+OxbrSYB07rrq9ZubRl5Jkuh22H7FF1zyu2trOW2J70R6FsI3Ml19RSTqd+1qxAvYUmJctu+8rnisjq4DrzkbhhCrOqbbIdGoAFOxWMoe0rLzRHt9T1LMOT1LJ66k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C7lDyln2; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C7lDyln2"
X-Envelope-To: shameerali.kolothum.thodi@huawei.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719258752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JZU8S04DmW37EgvwXoQWCiG/q1Cf8pwLsOrAbOmmLjs=;
	b=C7lDyln2xa5lWpdBfg8j566giFNeCe0vJGiqnCigrAWHSI8Ur5Uz+6t1ZEMjxIlUi9pQeW
	OFrzfv1VDagH0QLz6yeROMEqyPFBDxHcVxlog8Ezn2vPB0iDDe7mdyGTHJAW25ol8M2DfT
	najtYJsuz0Y9+HjheetgopFfOeWOpqc=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: iommu@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linuxarm@huawei.com
X-Envelope-To: kevin.tian@intel.com
X-Envelope-To: jgg@ziepe.ca
X-Envelope-To: alex.williamson@redhat.com
X-Envelope-To: maz@kernel.org
X-Envelope-To: will@kernel.org
X-Envelope-To: robin.murphy@arm.com
X-Envelope-To: jean-philippe@linaro.org
X-Envelope-To: jonathan.cameron@huawei.com
Date: Mon, 24 Jun 2024 12:52:27 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Linuxarm <linuxarm@huawei.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"jean-philippe@linaro.org" <jean-philippe@linaro.org>,
	Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [RFC PATCH v2 2/7] KVM: arm64: Introduce support to pin VMIDs
Message-ID: <ZnnOe7v5XQJkevNl@linux.dev>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-3-shameerali.kolothum.thodi@huawei.com>
 <ZnnHbM0p8amCqkeJ@linux.dev>
 <99b822b154504531b490055bc0f4006c@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99b822b154504531b490055bc0f4006c@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 24, 2024 at 07:34:42PM +0000, Shameerali Kolothum Thodi wrote:
> > > +	raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
> > > +
> > > +	vmid = atomic64_read(&kvm_vmid->id);
> > > +
> > > +	if (refcount_inc_not_zero(&kvm_vmid->pinned))
> > > +		goto out_unlock;
> > > +
> > > +	if (nr_pinned_vmids >= max_pinned_vmids) {
> > > +		vmid = 0;
> > > +		goto out_unlock;
> > > +	}
> > 
> > You need to decrement the refcount in this error path.
> 
> Hmm..do we? We are here means refcount is zero, right?

Durr, I need more caffeine. You're right.

-- 
Thanks,
Oliver
