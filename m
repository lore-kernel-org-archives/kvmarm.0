Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A122613A
	for <kvmarm@lists.linux.dev>; Fri, 13 Oct 2023 09:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QaoND89a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E27C433C7;
	Fri, 13 Oct 2023 09:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1697189381;
	bh=2Rtv1hzWn9/y5luZPHjn/Ic4VtigUzkY4Y2DYOUlc8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QaoND89a9vi3ZXr6GSrmL8UktsMjOiSrY0ZwSAOnirchlhVifYz9y9EGAj4vFUt8h
	 WeAMvzDB1iv7KJQq0vSvyFfXupghD1FVRTOhUSoLgNR9tPX2jGw+fT4kGHRjFvRufi
	 PQXMYXA2UCk6PXyaigXfP9TNjz4sQjwHjU3Uf94QfUa/kaYMkcSPf4Fenr0mUiHE4c
	 lrUGr2bUcGKkejYqt9LrTvQ1MwQuDuEaA+CCkHg263bVGKA2eynMYMWK1TdEMdk8XX
	 KM7637wC5U2JqHdcz8pDhIGnYwnzH9f2elCzpCktDdfAn0snExum2Z2A1ZQTntPxP5
	 dknYMH/Mxq7gA==
Date: Fri, 13 Oct 2023 10:29:35 +0100
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>, ankita@nvidia.com, maz@kernel.org,
	oliver.upton@linux.dev, aniketa@nvidia.com, cjia@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
	acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
	danw@nvidia.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <20231013092934.GA13524@willie-the-truck>
References: <ZP9MQdRYmlawNsbC@nvidia.com>
 <ZQHUifAfJ+lZikAn@lpieralisi>
 <ZQIFfqgR5zcidRR3@nvidia.com>
 <ZRKW6uDR/+eXYMzl@lpieralisi>
 <ZRLiDf204zCpO6Mv@arm.com>
 <ZR6IZwcFNw55asW0@lpieralisi>
 <20231012123541.GB11824@willie-the-truck>
 <ZSf6Ue09IO6QMBs1@arm.com>
 <20231012144807.GA12374@willie-the-truck>
 <ZSgsKSCv-zWgtWkm@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSgsKSCv-zWgtWkm@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Oct 12, 2023 at 06:26:01PM +0100, Catalin Marinas wrote:
> On Thu, Oct 12, 2023 at 03:48:08PM +0100, Will Deacon wrote:
> > Claiming back the device also seems strange if the guest has been using
> > non-cacheable accesses since I think you could get write merging and
> > reordering with subsequent device accesses trying to reset the device.
> 
> True. Not sure we have a good story here (maybe reinvent the DWB barrier ;)).

We do have a good story for this part: use Device-nGnRE!

> > > So, for now I'd only relax this if we know there's RAM(-like) on the
> > > other side and won't trigger some potentially uncontainable errors as a
> > > result.
> > 
> > I guess my wider point is that I'm not convinced that non-cacheable is
> > actually much better and I think we're going way off the deep end looking
> > at what particular implementations do and trying to justify to ourselves
> > that non-cacheable is safe, even though it's still a normal memory type
> > at the end of the day.
> 
> Is this about Device vs NC or Device/NC vs Normal Cacheable? The
> justification for the former has been summarised in Lorenzo's write-up.
> How the hardware behaves, it depends a lot on the RAS implementation.
> The BSA has some statements but not sure it covers everything.

I don't know how to be more clear, but I'm asking why Normal-NC is the right
memory type to use. Jason's explanation on the other thread about how it's
basically the only option with FWB (with some hand-waving about why
Normal-cacheable isn't safe) will have to do, but it needs to be in the
commit message.

The host maps MMIO with Device-nGnRE. Allowing a guest to map it as Normal
surely means the host is going to need additional logic to deal with that?
We briefly discussed claiming back a device above and I'm not convinced
that the code we have for doing that today will work correctly if the
guest has issued a bunch of Normal-NC stores prior to the device being
unmapped.

Could we change these patches so that the memory type of the stage-1 VMA
in the VMM is reflected in the stage-2? In other words, continue to use
Device mappings at stage-2 for I/O but relax to Normal-NC if that's
how the VMM has it mapped?

> Things can go wrong but that's not because Device does anything better.
> Given the RAS implementation, external aborts caused on Device memory
> (e.g. wrong size access) is uncontainable. For Normal NC it can be
> contained (I can dig out the reasoning behind this if you want, IIUC
> something to do with not being able to cancel an already issued Device
> access since such accesses don't allow speculation due to side-effects;
> for Normal NC, it's just about the software not getting the data).

I really think these details belong in the commit message.

> > Obviously, it's up to Marc and Oliver if they want to do this, but I'm
> > wary without an official statement from Arm to say that Normal-NC is
> > correct. There's mention of such a statement in the cover letter:
> > 
> >   > We hope ARM will publish information helping platform designers
> >   > follow these guidelines.
> > 
> > but imo we shouldn't merge this without either:
> > 
> >   (a) _Architectural_ guidance (as opposed to some random whitepaper or
> >       half-baked certification scheme).
> 
> Well, you know the story, the architects will probably make it a SoC or
> integration issue, PCIe etc., not something that can live in the Arm
> ARM. The best we could get is more recommendations in the RAS spec
> around containment but not for things that might happen outside the CPU,
> e.g. PCIe root complex.

The Arm ARM _does_ mention PCI config space when talking about early write
acknowledgement, so there's some precedence for providing guidance around
which memory types to use.

> > - or -
> > 
> >   (b) A concrete justification based on the current architecture as to
> >       why Normal-NC is the right thing to do for KVM.
> 
> To put it differently, we don't have any strong arguments why Device is
> the right thing to do. We chose Device based on some understanding
> software people had about how the hardware behaves, which apparently
> wasn't entirely correct (and summarised by Lorenzo).

I think we use Device because that's what the host uses in its stage-1
and mismatched aliases are bad.

Will
