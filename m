Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C717630C102;
	Wed, 17 Sep 2025 15:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758122742; cv=none; b=Po76lpSNsEwMT5fI1+lkHuXwvg9LjBmUQs3vgKsosNda7OyMmL9nItPVsQ25q0WW8ugIVvy3t2NM0G/VNJe5dRbI10Poe4VD/uqPm3aUusyp5ANT6Seg3sAbuobhmwhY3V8QhkZE/s9FqA8hiE+4M1f3OiKAUofvqE80s2nQlzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758122742; c=relaxed/simple;
	bh=tI6Ac6w2oSwCuXBkCkMUNA45xDANBSg0NsMKs0L/pWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ee+8ZIYgrgS+o9C29u+8pgSsYFDzqC9is/89gs5KNxlWeq3dr+sQZ6ZG2XeEhUHpCIUTuT/qcEWTT9uiAHUDHI3JPrkRokoJoRqHTRcgPBVIuQns3wPJF0nZfe/xE1QQmAeax8M2ApQoV5U2zwUu1VpzJZY4CSeVwylQCOfYHWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K2QNT5yM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K2QNT5yM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AF3C4CEF7;
	Wed, 17 Sep 2025 15:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758122742;
	bh=tI6Ac6w2oSwCuXBkCkMUNA45xDANBSg0NsMKs0L/pWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K2QNT5yMEHai5Vv/X9Wu5SKbEUub0HuW9bSL7UR9OtNZ2wgtTRGVMqy+EeWLu6zCB
	 9HS05wzgxjSx4t8yvRyP1tYn37tOihaIeKFoa2duJhXOkZe33a7JQR2QKGK+m73OI1
	 8NwIn1eQRXwi9/1JIkEExLaRWwFqnddrYWy4Fs8FdQ4nkVA4HktT8+KExwWgLeLtEi
	 BnlbVPi/+zScjZk1SdmMRPOB2RNHTetUxhMCvBEbSWaEkKu2dDOvdlGuORECI+Ady9
	 7fEcN6N9jEZj5n/s4KHdLyWw5f9796kOJslzMbSki0HHfRWGrgWyYakx0/qhfOCq5+
	 BY2I3uw4moQjA==
Date: Wed, 17 Sep 2025 16:25:35 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Mostafa Saleh <smostafa@google.com>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 22/28] iommu/arm-smmu-v3-kvm: Emulate CMDQ for host
Message-ID: <aMrS71vQ_MaVonzi@willie-the-truck>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-23-smostafa@google.com>
 <aMQroI4NDu74PDGT@willie-the-truck>
 <20250915163858.GK882933@ziepe.ca>
 <aMl_5j8G3IGulAC6@google.com>
 <20250917123601.GA1326709@ziepe.ca>
 <aMrNTny9jgZJd_Ef@willie-the-truck>
 <20250917151612.GH1326709@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917151612.GH1326709@ziepe.ca>

On Wed, Sep 17, 2025 at 12:16:12PM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 17, 2025 at 04:01:34PM +0100, Will Deacon wrote:
> > On Wed, Sep 17, 2025 at 09:36:01AM -0300, Jason Gunthorpe wrote:
> > > On Tue, Sep 16, 2025 at 03:19:02PM +0000, Mostafa Saleh wrote:
> > > 
> > > > I think the fix for the problem Will mentioned is to just use CMOs
> > > > before accessing the host structures, so that should be simple.
> > > > If it turns to be more complicated, I am happy to drop the support
> > > > for non-coherent devices from this series and we can add it later.
> > > 
> > > I feel like it is easier/better to fix the driver to use cachable
> > > memory than to add CMOs to the pkvm side..
> > 
> > Hmm, but for non-coherent SMMU hardware (which sadly exists in
> > production), I don't think there's a way for firmware to tell the driver
> > that it needs to issue CMOs for the page-tables and the CDs but not the
> > other in-memory data structures (e.g. STEs). I suppose we could do it in
> > some pKVM-specific way, but then that's not really helping anybody else.
> 
> Not sure I understand?
> 
> I mean to issue CMOs in the smmu driver consistently for everthing,
> page table, CD entry, STE, etc. Today it only does it for page table.
> 
> Make the driver consistently use cachable memory for everything
> instead of having two different ways to deal with incoherent HW.

Ah right, so the driver would unnecessarily issue CMOs for the structures
that are just shared with the hypervisor. At least it's _functional_ that
way, but I'm sure people will complain!

Will
