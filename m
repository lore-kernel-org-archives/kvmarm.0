Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1145480027
	for <kvmarm@lists.linux.dev>; Mon, 26 Aug 2024 23:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724714928; cv=none; b=F/FJGV8kDHKJME3okXqzdLb3wMoIGPsa/k6LvEt+0j2DndRvee9BKC7icsnmMe6cdDpjjWurwZoNTZTJTMAV+GJUzq5N8EPfJTHcvhrRBeDdScbkiParSMs3hMapGL7v9AWSAK1unW9BcvOOnUBebhi+zT2IbzLoVafAe+aNUZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724714928; c=relaxed/simple;
	bh=ABXmAeS0StoUvHF+mi9Kxlkw2fL8XxenCrbajZhELxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m2CO4mkXZDfRlE3ky6O7ng4GqFfQdVKcRtsDG79Z2fHVpNEUZSR+IKBpkNyJFKPHgNsqvUxXiHM/5h+i36FonZ1v3beRJjnFpZUv3FKQ5KooK0/+hsyvnECmSoKDRr+FqTRvI7WMdwEMDBIoNbieMpIsneZTwP+o9UDhu9qPe5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KF71LULh; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KF71LULh"
Date: Mon, 26 Aug 2024 16:28:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724714923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kYoiM2+oKDznhGzZ2yDoe45LcbdzyY4rjG+L8U4M2t8=;
	b=KF71LULhcLYQTiE1bOPB2HEKHHYd2gUX8rB7gGh1j5gU86xW5IEJYgo9nj5H56uKiUeeKS
	s6xOglzusORskKbhcz2aMmT2FksFV/5uiEnDyV3nsWgyvaa9u3XESoxBSCN69BZ3jtbzKI
	EEdjpRO4foJUmLLwLtq5hi+Y38co2ng=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: D Scott Phillips <scott@os.amperecomputing.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Besar Wicaksono <bwicaksono@nvidia.com>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Rob Herring <robh@kernel.org>,
	Andre Przywara <andre.przywara@arm.com>,
	linux-kernel@vger.kernel.org, patches@amperecomputing.com,
	Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] arm64: errata: Enable the AC03_CPU_38 workaround for
 ampere1a
Message-ID: <Zs0Po659RFhbnRXI@linux.dev>
References: <20240826215933.1263453-1-scott@os.amperecomputing.com>
 <Zs0OelXKn_-6jtqN@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs0OelXKn_-6jtqN@linux.dev>
X-Migadu-Flow: FLOW_OUT

Also, +cc Marc + the rest of the KVM folks.

checkpatch doesn't help in this situation, but it'd be good to keep
everyone in the loop since this is an erratum that affects KVM.

On Mon, Aug 26, 2024 at 04:24:00PM -0700, Oliver Upton wrote:
> Hi D Scott,
> 
> On Mon, Aug 26, 2024 at 02:59:33PM -0700, D Scott Phillips wrote:
> > The ampere1a cpu is affected by erratum AC04_CPU_10 which is the same
> > bug as AC03_CPU38. Add ampere1a to the AC03_CPU_38 workaround midr list.
> > 
> > Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
> > ---
> >  Documentation/arch/arm64/silicon-errata.rst | 2 ++
> >  arch/arm64/Kconfig                          | 2 +-
> >  arch/arm64/include/asm/cputype.h            | 2 ++
> >  arch/arm64/kernel/cpu_errata.c              | 1 +
> >  4 files changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
> > index 50327c05be8d1..39c52385f11fb 100644
> > --- a/Documentation/arch/arm64/silicon-errata.rst
> > +++ b/Documentation/arch/arm64/silicon-errata.rst
> > @@ -55,6 +55,8 @@ stable kernels.
> >  +----------------+-----------------+-----------------+-----------------------------+
> >  | Ampere         | AmpereOne       | AC03_CPU_38     | AMPERE_ERRATUM_AC03_CPU_38  |
> >  +----------------+-----------------+-----------------+-----------------------------+
> > +| Ampere         | AmpereOne AC04  | AC04_CPU_10     | AMPERE_ERRATUM_AC03_CPU_38  |
> > ++----------------+-----------------+-----------------+-----------------------------+
> 
> We tend to stick the marketing term for a part in the second column so
> it is more recognizable for the user. Is this a placeholder for something
> different from "ampere1a"?
> 
> > diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> > index f6b6b45073571..748aa536446ae 100644
> > --- a/arch/arm64/kernel/cpu_errata.c
> > +++ b/arch/arm64/kernel/cpu_errata.c
> > @@ -773,6 +773,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
> >  		.desc = "AmpereOne erratum AC03_CPU_38",
> >  		.capability = ARM64_WORKAROUND_AMPERE_AC03_CPU_38,
> >  		ERRATA_MIDR_ALL_VERSIONS(MIDR_AMPERE1),
> > +		ERRATA_MIDR_ALL_VERSIONS(MIDR_AMPERE1A),
> 
> This will break the workaround on AC03, since the second macro reassigns
> ::midr_range.
> 
> You'll want to use ERRATA_MIDR_RANGE_LIST() instead w/ an array of
> affected MIDRs.
> 
> -- 
> Thanks,
> Oliver
