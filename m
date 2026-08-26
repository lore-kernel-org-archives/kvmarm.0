Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0EFF361DA7
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 11:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787742406; cv=none; b=CdYbnQkTgrS0YUTXuJTE4wcihHeFsFw/M08xTpUc5NkskLFHB4j4nQ30GwsoWJb+9DuR8W2WclEzGcDpYLOEWRb7wOGpmFj4emVg1yHE5rtzbVA1Rxq4gh5y0JOtU6wkKfCsRIw3hfbw9JD74GmMptEl3GW0swT183OL4MOeafU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787742406; c=relaxed/simple;
	bh=rqhiwOhjqHsJII2jfGpA8O9vesBfzfteSUcW8kNSejQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LCAuIR8Xc5iH7MLHfMWqMKuuXFDLxr6UCCqQVW6shNLOfwkK9ptvXv+XgOlMsOo6/Em06KUrJ775jhYpMgBrgMnmEbdN+95bGSIVRvcmfAaG+qPzHwA+ieFfixQ+3pdBU4Fg7MhBzIo/JXCGGYSoGWirF3Uxqwy/hNUfx4KGoXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lYTgWaAu; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lYTgWaAu"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 177281713;
	Wed, 26 Aug 2026 04:06:31 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A5803F66F;
	Wed, 26 Aug 2026 04:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787742394; bh=rqhiwOhjqHsJII2jfGpA8O9vesBfzfteSUcW8kNSejQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lYTgWaAukS40EsG28i19V4Mr8mkXPq1ub6mJ7ZeXr9d/byyH7IhKk/sqxMicqKGJ3
	 dlUSDaa9qONKGJiG61htps7UUt8O3F0vBHH5r0QZBJTo8qL8OpssYjEsZHyvNYLHi3
	 OZMCg8Hj++jEluBxHl62WBVm4+Z56dgoylrO9/54=
Date: Wed, 26 Aug 2026 12:06:26 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] arm64: Don't read GMID_EL1 when MTE is disabled
Message-ID: <ao7Isu9sxUEeECOZ@arm.com>
References: <20260824184155.2644646-1-fuad.tabba@linux.dev>
 <aoypji6EJ8zToWvh@arm.com>
 <CA+EHjTwueqEAVq-7_ioRN+1h3LNPAqHX3rTqbXODViJJM-D_pQ@mail.gmail.com>
 <ao2jNDv8tOjnimEH@willie-the-truck>
 <CA+EHjTx93ERXZV1visdfBOGtH7wHff6TAoeJe+pNtikPrRp8Qw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTx93ERXZV1visdfBOGtH7wHff6TAoeJe+pNtikPrRp8Qw@mail.gmail.com>

On Tue, Aug 25, 2026 at 03:46:15PM +0100, Fuad Tabba wrote:
> On Tue, 25 Aug 2026 at 15:14, Will Deacon <will@kernel.org> wrote:
> ...
> > > > If you are worried about additional trapping of the MRS, we should go
> > > > for Will's improvement to always read the cached values in
> > > > __read_sysreg_by_encoding().
> > >
> > > Not worried :) __cpuinfo_store_cpu() has already read ID_AA64PFR1_EL1
> > > a few lines up.
> >
> > But if you go with __read_sysreg_by_encoding() then you'd still be
> > reading it (and trapping) twice, no?
> 
> It would, and I'm fine with that on a CPU bring-up path.

For backports, yes. Going forward, I like Will's idea of reading the
cached value in __read_sysreg_by_encoding().

-- 
Catalin
