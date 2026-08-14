Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DD545DF41;
	Fri, 14 Aug 2026 09:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699212; cv=none; b=OPFD7gpmuSQcCFn5R1LWKI1FoW36qEYDG4d0sDrVs0n7sxW+Cvhhgkkqe2fwDwVTH9zdMN5GbDHWu+no311TAt6QydpJ0/auk1vWYUTudNY5je8qx7vEYYnA9wF7Ndq4s7U7kTFEYFhmXXvjQGszsOBM0ALwm8/w5a4P1CtCPzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699212; c=relaxed/simple;
	bh=8K2DsmYpFL6E7UnB1VIdyebQtsiMwVAEbtVkbC5YyNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=boFXGSWRLMK9gOWqpW4wGtu1/ylLkxEYyrpsDBIpy3B/4dKikxpYbq/coWG56H6tN48hf1bWLswxEHWcRlngHchegYsKVTBGelLLIilvCfjubtMuX6dKEQhtnYzrYBlSOor5jDU9js8ATYF+8p+r33UahRELJx5U8SGOiAM700c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TvQTrO+S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TvQTrO+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD271F000E9;
	Fri, 14 Aug 2026 09:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699211;
	bh=3GfUKH11AfQHejJ7o/IeV7XbwvaLVJlzCrEGN3jgUP0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TvQTrO+SmL7RinwxMpbttiEvOpXt9zDTZxkvtlUxOZjcLL4NHrneI0broiwqNDQrr
	 CaZU/68ULhUFz4/Bqgk1JM+ig4OtzIxV3PzNfK7YLbrbIfMNc1NipmQyawUCOuX2W/
	 twyLGbVHEACVjS4/9FgbH/AdQLNsVN/KzEPozqHBISqXYrIvOtA8KQ6U5BSQaBAJFv
	 tjLmCt/3AEzW98AzwTfb1aRi2fSGd5HdDqEFO9hQpcMvYsbKovMmmhCEGmdSI20/8y
	 fFCv4MYrJswLv8gpGIKfbOvu/SZmm357QvvWPoLXLYvwTWaSB1JxingLliz3KRf5K/
	 w41hkFHJ6PGiQ==
Date: Fri, 14 Aug 2026 10:20:02 +0100
From: Will Deacon <will@kernel.org>
To: Pavan Kondeti <pavan.kondeti@oss.qualcomm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v16 07/45] arm64: mm: Handle Granule Protection Faults
 (GPFs)
Message-ID: <an7dwu6L34wk-qQZ@willie-the-truck>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-8-steven.price@arm.com>
 <ans1ZSwMEKeT9Gfz@arm.com>
 <d4bdecca-517a-4b4b-bf67-cef6b09bc8c1@arm.com>
 <7d4e5920-aa20-40cd-954e-037631bd0d6c@quicinc.com>
 <anx6YbPMVz3OlpA5@arm.com>
 <an2YN7kxB7bjCd2s@willie-the-truck>
 <8db602b8-7fd3-4c11-8fbd-3b8251648eb8@quicinc.com>
 <an3ihGk3znnk8TWV@willie-the-truck>
 <5b557560-7664-4336-9e5f-86de8dcd6d90@quicinc.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b557560-7664-4336-9e5f-86de8dcd6d90@quicinc.com>

On Fri, Aug 14, 2026 at 02:15:39PM +0530, Pavan Kondeti wrote:
> On Thu, Aug 13, 2026 at 04:28:04PM +0100, Will Deacon wrote:
> > On Thu, Aug 13, 2026 at 07:40:41PM +0530, Pavan Kondeti wrote:
> > > On Thu, Aug 13, 2026 at 11:11:03AM +0100, Will Deacon wrote:
> > > > On Wed, Aug 12, 2026 at 02:51:29PM +0100, Catalin Marinas wrote:
> > > > > On Wed, Aug 12, 2026 at 06:12:09PM +0530, Pavan Kondeti wrote:
> > > > > > There is a valid case for fixup_exception() to be needed here in GPF
> > > > > > handling.
> > > > > > 
> > > > > > -000 |load_unaligned_zeropad(inline)
> > > > > > -000 |hash_name(inline)
> > > > > > -000 |link_path_walk()
> > > > > > -001 |path_lookupat()
> > > > > > -002 |filename_lookup()
> > > > > > -003 |vfs_statx()
> > > > > > -004 |vfs_fstatat()
> > > > > > 
> > > > > > We observed this in Android running Gunyah when the page is mapped in
> > > > > > EL1 but unmapped at EL2. path_lookupat() can actually handle this
> > > > > > via fixup_exeption() when a word load crosses the page boundary.
> > > > > > However, Gunyah injects a Synchronous External Abort and we have
> > > > > > a downstream patch [1] that adds fixup_exception() in do_sea(). pKVM
> > > > > > injects [2] such faults back to EL1 and fixup_exception() is taken care.
> > > > > 
> > > > > Ah, good point, completely forgot about load_unaligned_zeropad(). Since
> > > > > we don't unmap the linear map for delegated pages, we'll need the
> > > > > fixup_exception(). And I guess warning in this case is not desirable
> > > > > either. We could limit it to EX_TYPE_KACCESS_ERR_ZERO and
> > > > > EX_TYPE_LOAD_UNALIGNED_ZEROPAD, though not sure it's worth it.
> > > > 
> > > > Alternatively, I think the series to unmap guest memory from the linear
> > > > map would solve that for gmem:
> > > > 
> > > > https://lore.kernel.org/all/20260410151746.61150-1-kalyazin@amazon.com/
> > > > 
> > > 
> > > Thanks Will for sharing this information.
> > > 
> > > There are use cases outside gmem like FF-A lend to Secure Partition.
> > > we may not be enforcing all such memory to be unmapped at EL1, correct?
> > 
> > If you leave the cacheable linear alias of memory intact across an
> > NS -> S transition, then you're in for a bad time [1].
> > 
> > Will
> > 
> > [1] https://lore.kernel.org/all/20221114110329.68413-1-manivannan.sadhasivam@linaro.org/
> 
> Thanks for the reply. In the above case, XPU does not like the speculative fetches. I am
> not sure if there is a hard requirement for unmap of FF_A memory lent to secure
> partition managed under Root with GPT.

If it's not unmapped, then you can get speculative reads on the NS side
which will probably trigger aborts at the TZ memory firewall logic. I
agree that's different for the GPT, but gmem is growing that support for
other architectures and it would solve the load_unaligned_zeropad()
problem on arm64. Some folks also seem to want it for addressing the
possibility of CPU side-channels, but that's a bit more belt and braces
imo.

Vincent looped you in on the thread with Thierry where there is an ongoing
effort to address this for TZ.

Will
