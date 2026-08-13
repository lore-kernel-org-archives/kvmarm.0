Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECC43B2D00;
	Thu, 13 Aug 2026 10:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786615873; cv=none; b=V14XGF6R5ZvqgYMKlsfJGBUO620Lzn6f12HIZ50QvpBup/WFzhClW9iBFNBwO3fujerwWz6uGqNZ8h9jZ8DcJjtCSv/oZ9N6DrQMaUHw/pCpJ2rr+S99/ZhXanDe3G4WDqWEdqVefJKkG1jOzgD0xuLzOBUB5v6abxA3B100/MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786615873; c=relaxed/simple;
	bh=S5lRUjdLp3oI5PZ7dawLDovgFfcY3oYgCUjnNo6ZAaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WbM/qD79l3Xj0rhwr72VJsKyM863MpFnLHaYAOJSU6m0JcaDyHQec9Pa2on2riz53S4EpMHIhOOvxtcopkRK6Uo9baTc7Lz7t9tBcLaiRB3THNIlGjw/123XNEzod1q5f2GXhXcggEcvoBHjSVqn+hTd4C6fWo9qz8FuKKkHuCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uh72INHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uh72INHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B2B1F000E9;
	Thu, 13 Aug 2026 10:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786615871;
	bh=1GUvy4NsSEhlxO1mGSlkQ8deO2KrloNrrXAd8AHoYE8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Uh72INHK/sIbkNYsIDOPjGO143EsGaQlP7xQY3AROGkJGS0/0IdBYQHDCvp1O5oM8
	 oaoI+ZDz/JHZS+7HYo6heMzXrWDq3R9JoHYsJ+6PH8z7UlLt+2dRJCIX8KLOxLsE0W
	 RPhMJleW/O0L2O3kGBOy6PqG73URg60mJM5eCvmmpoypJbq06/4eW3EI2a/z9Ibg1G
	 NgEF8AnsHzQ0yR4Ii3p1AGmKDV//SqJRsEYIo5folawdWjVa7go7BlIMYzhtzP3KtN
	 8LOjezI5ivbdQCFV5ug5X9NRpIeTcTNM/Ry1xf1ieV5i3viFeT1+G6zHTi0twu/0TX
	 kdMpVTQo5iiHQ==
Date: Thu, 13 Aug 2026 11:11:03 +0100
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pavan Kondeti <pavan.kondeti@oss.qualcomm.com>,
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
Message-ID: <an2YN7kxB7bjCd2s@willie-the-truck>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-8-steven.price@arm.com>
 <ans1ZSwMEKeT9Gfz@arm.com>
 <d4bdecca-517a-4b4b-bf67-cef6b09bc8c1@arm.com>
 <7d4e5920-aa20-40cd-954e-037631bd0d6c@quicinc.com>
 <anx6YbPMVz3OlpA5@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anx6YbPMVz3OlpA5@arm.com>

On Wed, Aug 12, 2026 at 02:51:29PM +0100, Catalin Marinas wrote:
> On Wed, Aug 12, 2026 at 06:12:09PM +0530, Pavan Kondeti wrote:
> > There is a valid case for fixup_exception() to be needed here in GPF
> > handling.
> > 
> > -000 |load_unaligned_zeropad(inline)
> > -000 |hash_name(inline)
> > -000 |link_path_walk()
> > -001 |path_lookupat()
> > -002 |filename_lookup()
> > -003 |vfs_statx()
> > -004 |vfs_fstatat()
> > 
> > We observed this in Android running Gunyah when the page is mapped in
> > EL1 but unmapped at EL2. path_lookupat() can actually handle this
> > via fixup_exeption() when a word load crosses the page boundary.
> > However, Gunyah injects a Synchronous External Abort and we have
> > a downstream patch [1] that adds fixup_exception() in do_sea(). pKVM
> > injects [2] such faults back to EL1 and fixup_exception() is taken care.
> 
> Ah, good point, completely forgot about load_unaligned_zeropad(). Since
> we don't unmap the linear map for delegated pages, we'll need the
> fixup_exception(). And I guess warning in this case is not desirable
> either. We could limit it to EX_TYPE_KACCESS_ERR_ZERO and
> EX_TYPE_LOAD_UNALIGNED_ZEROPAD, though not sure it's worth it.

Alternatively, I think the series to unmap guest memory from the linear
map would solve that for gmem:

https://lore.kernel.org/all/20260410151746.61150-1-kalyazin@amazon.com/

but I can't tell whether that's still being actively pursued.

Will
