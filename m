Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EB43D72
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 00:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I4o+wfYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FCBC433C7;
	Mon, 13 Nov 2023 00:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699836192;
	bh=qo73hMpbT5UB0fyH1NpcXGG0dpmwEMtmdXWgdp/vY8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I4o+wfYUYjOpLGSebbsZMJ0/0DLrfENueQdXl0m0SbRp8hElJyTaF7bkd/mzmy3JX
	 d1BdMxZvYnO7u3xUKbJjVWKZxWhmosAmtau7cn4H45FVS5nvhiDlhpj1RhJQ/xJtjW
	 HEOOcIcZT9O22E8Vfp42G3uBF/wvHKx8hmd4/OXLPyLrAY16AXQhncK8BSrohVHQ7i
	 bIgwxruX7vJLSi41Z7ekqS3nDmuokZ8Y2RS3/ODv3Rqj6S3jTlYt8Vj8EALz7vuUiH
	 Bg2fl7HWwtDMFvJoFMjWILWyjjShVRlAIHwbPkZFCLNFbvwV6iPCG2NU/Sdrcg0pm/
	 lzbwpoLJUpkOA==
Date: Mon, 13 Nov 2023 01:42:58 +0100
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, ankita@nvidia.com, maz@kernel.org,
	oliver.upton@linux.dev, aniketa@nvidia.com, cjia@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
	acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
	danw@nvidia.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <ZVFxElNLcK46Vk9x@lpieralisi>
References: <ZRLiDf204zCpO6Mv@arm.com>
 <ZR6IZwcFNw55asW0@lpieralisi>
 <20231012123541.GB11824@willie-the-truck>
 <ZSf6Ue09IO6QMBs1@arm.com>
 <20231012144807.GA12374@willie-the-truck>
 <ZSgsKSCv-zWgtWkm@arm.com>
 <20231013092934.GA13524@willie-the-truck>
 <ZSlBOiebenPKXBY4@arm.com>
 <ZUz78gFPgMupew+m@lpieralisi>
 <20231110142649.GO4488@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231110142649.GO4488@nvidia.com>

On Fri, Nov 10, 2023 at 10:26:49AM -0400, Jason Gunthorpe wrote:
> On Thu, Nov 09, 2023 at 04:34:10PM +0100, Lorenzo Pieralisi wrote:
> 
> > Relaxing S2 KVM device MMIO mappings to Normal-NC is not expected to
> > trigger any issue on guest device reclaim use cases either (ie device
> > MMIO unmap followed by a device reset) at least for PCIe devices, in that
> > in PCIe a device reset is architected and carried out through PCI config
> > space transactions that are naturally ordered wrt MMIO transactions
> > according to the PCI ordering rules.
> 
> This is not how I see that thread concluding..
> 
> The device reclaim problem belongs solely to VFIO, not KVM. VFIO must
> ensure global ordering of access before the VMA is unmaped and access
> after, that includes ordering whatever mechanism the VFIO driver uses
> for reset.
> 
> If there are quirky SOCs, or non-PCI devices that need something
> stronger than the TLBI/etc sequence it should be fixed in VFIO (or
> maybe even the arch code), not by blocking NORMAL_NC in the KVM. Such
> a quirky SOC would broadly have security issues beyond KVM.

https://lore.kernel.org/linux-arm-kernel/20231013092934.GA13524@willie-the-truck

I think that Will's point _was_ related to the change we are making for
KVM S2 mappings and related device transactions on device reclaim - ie
reset, that's what I tried to convey (I probably simplified too much)
that for PCI at least that should not trigger any regression/issue, in
that BAR MMIO and reset transactions are decoupled streams and must
follow the PCI ordering rules.

Yes, it is VFIO responsibility but changing the S2 KVM mappings
may have (for non-PCI devices) side effects compared to what
we have today, I am not saying this should be a blocker I just
summarized the thread above, the paragraph can be expanded.

Lorenzo

> 
> > It is worth noting that currently, to map devices MMIO space to user
> > space in a device pass-through use case the VFIO framework applies memory
> > attributes derived from pgprot_noncached() settings applied to VMAs, which
> 
> Sometimes. VFIO uses a mix of pgprot_noncached and pgprot_device. AFAIK
> we should change to to always use pgprot_device..
> 
> Thanks,
> Jason
