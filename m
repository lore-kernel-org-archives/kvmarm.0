Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37A6489871;
	Thu, 13 Aug 2026 15:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786634894; cv=none; b=OCg06ONiUX3elIeOigtbiOEzPLBPQJhBf/lzNZS/syOWbKQJLMlJr+iQTFh3xZIPValvQiiMCbTtKFrfceRJqPANaI6E2AvIPYohcc93ZS3pn9jvScqb5XB3l6x+9X/NQbdob4b5SU48yCqvZxemy6RriYRTl6O0l9jCVW3acqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786634894; c=relaxed/simple;
	bh=j9eKaonxGNjSwpS7uKNe5pc+Hh14Qqgfc1SFvDoUHB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V2UVDLnLorOIrd2n7QEZYTf+p0WytVS48v1S8khkZYXtPah+du/yB+5kanHQKcWFxeCApWBO/iLOTPeti+4URMR1rErk71ZgiosV773S6LqaBPQ8Blo7ks1nShzI8GXgQrAW1IbPjhufzyUpRPIhgmnXxMHiGaXBO42g+IbIzAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yf0QU6fe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yf0QU6fe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3421F000E9;
	Thu, 13 Aug 2026 15:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786634892;
	bh=opwS4jjY/2m4RZ1yhCK834dI3mtLkmcqk7P5LYp9Hhc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Yf0QU6fe5CPzdz82xf5Sn0MXv1H917tAlGe/9eWgmjwlgSVDkMZ7B8bhSeavHSAVe
	 3ClI0cuG6ZRTaXeVrUHXTQn7vv8U3Gh+jXlLbSwNpvbXPnlUPJKl3nRWbHm6v2yXSE
	 AI+qrnrCx7IphD6+2ny8vgfLgUmokJY58vAJPkx81qBLUkppZhXlAqVsB+uCsG6B5a
	 Jes3XUgFH86rVrj5rQPPUfHxXuf7wgg8C7Tj5OjKSmDYYA2QttJh1uliF/jl8mU+zb
	 twuXDmtP4cHPgdXHTbJvH4T+F+fxJbbGfVfSL9dIScRhnyqr5vBe1fDzyh3DCZMpgJ
	 u78m48ygwuKWA==
Date: Thu, 13 Aug 2026 16:28:04 +0100
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
Message-ID: <an3ihGk3znnk8TWV@willie-the-truck>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-8-steven.price@arm.com>
 <ans1ZSwMEKeT9Gfz@arm.com>
 <d4bdecca-517a-4b4b-bf67-cef6b09bc8c1@arm.com>
 <7d4e5920-aa20-40cd-954e-037631bd0d6c@quicinc.com>
 <anx6YbPMVz3OlpA5@arm.com>
 <an2YN7kxB7bjCd2s@willie-the-truck>
 <8db602b8-7fd3-4c11-8fbd-3b8251648eb8@quicinc.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8db602b8-7fd3-4c11-8fbd-3b8251648eb8@quicinc.com>

On Thu, Aug 13, 2026 at 07:40:41PM +0530, Pavan Kondeti wrote:
> On Thu, Aug 13, 2026 at 11:11:03AM +0100, Will Deacon wrote:
> > On Wed, Aug 12, 2026 at 02:51:29PM +0100, Catalin Marinas wrote:
> > > On Wed, Aug 12, 2026 at 06:12:09PM +0530, Pavan Kondeti wrote:
> > > > There is a valid case for fixup_exception() to be needed here in GPF
> > > > handling.
> > > > 
> > > > -000 |load_unaligned_zeropad(inline)
> > > > -000 |hash_name(inline)
> > > > -000 |link_path_walk()
> > > > -001 |path_lookupat()
> > > > -002 |filename_lookup()
> > > > -003 |vfs_statx()
> > > > -004 |vfs_fstatat()
> > > > 
> > > > We observed this in Android running Gunyah when the page is mapped in
> > > > EL1 but unmapped at EL2. path_lookupat() can actually handle this
> > > > via fixup_exeption() when a word load crosses the page boundary.
> > > > However, Gunyah injects a Synchronous External Abort and we have
> > > > a downstream patch [1] that adds fixup_exception() in do_sea(). pKVM
> > > > injects [2] such faults back to EL1 and fixup_exception() is taken care.
> > > 
> > > Ah, good point, completely forgot about load_unaligned_zeropad(). Since
> > > we don't unmap the linear map for delegated pages, we'll need the
> > > fixup_exception(). And I guess warning in this case is not desirable
> > > either. We could limit it to EX_TYPE_KACCESS_ERR_ZERO and
> > > EX_TYPE_LOAD_UNALIGNED_ZEROPAD, though not sure it's worth it.
> > 
> > Alternatively, I think the series to unmap guest memory from the linear
> > map would solve that for gmem:
> > 
> > https://lore.kernel.org/all/20260410151746.61150-1-kalyazin@amazon.com/
> > 
> 
> Thanks Will for sharing this information.
> 
> There are use cases outside gmem like FF-A lend to Secure Partition.
> we may not be enforcing all such memory to be unmapped at EL1, correct?

If you leave the cacheable linear alias of memory intact across an
NS -> S transition, then you're in for a bad time [1].

Will

[1] https://lore.kernel.org/all/20221114110329.68413-1-manivannan.sadhasivam@linaro.org/
