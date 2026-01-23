Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86634272E6D
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 20:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769201637; cv=none; b=SbKVBEZWAwTAYDn464+y7e+6K2ooiY9PxRJcLcQZ5LXstD1wmLQLtuQslvTEg378xrm5rflKg1erCaI4e0tpMZrQbytYmxXjSDEUOqMg2zCFrOfmK3Mh7BXfva0+DeZo4vEjUkp+XubwbpLOT+CcgThqi4bfqFhLMWOQ7G129LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769201637; c=relaxed/simple;
	bh=xe542YWkg5mBpfW3/hCNNf+MbznktYYFosacLIasAXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y6/cjeVyYc8Ri2++tENeZDDS2H0SHGqw+6XYZ0449Ru4yY1FBGBodhL1dC00BJReK45K689xokmLdhcVWVuAuRp6T5re0yS5MV7UkJk761nLuq6Skrw4sDnGcW0FmXX/BYX472mrQwWKv8iuV+Glyz5TeHrh47EeWh2xUAq1ppA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZnH0wKL7; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZnH0wKL7"
Date: Fri, 23 Jan 2026 14:53:48 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769201633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D57JNkS+49f708+rij13SXe+bfYTIefVNh6ybtQ6MpA=;
	b=ZnH0wKL7V4AzqdF2+UteZAwtP250tR69sZHujXIR1CJx3JU/fpLTmelFkvlMZVCtJbG4xy
	IobF1/JwBMPo54B+MzyPuFGgV2aNVsBoIDIvxPhm9uNXtxowaHViIFzCdj8CBor9zHvGqZ
	42QEKF5m6NyamKfn4xGhhunujnt06d0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, 
	eric.auger@redhat.com, maz@kernel.org, kvmarm@lists.linux.dev, 
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v6 00/14] arm64: EL2 support
Message-ID: <wjivmdycgamisp6zbplolorxvqcf4aui7khtezed7dusiweybe@chjqcekg5q5g>
References: <20260123165053.2250754-1-joey.gouly@arm.com>
 <ixq5fcyiey4prwl5luzlemznvjd6hk2pqj73rmlinnl233gfdy@b6mns7sf3dv5>
 <20260123193015.GA2258507@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123193015.GA2258507@e124191.cambridge.arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 23, 2026 at 07:30:15PM +0000, Joey Gouly wrote:
> On Fri, Jan 23, 2026 at 01:23:41PM -0600, Andrew Jones wrote:
> > On Fri, Jan 23, 2026 at 04:50:39PM +0000, Joey Gouly wrote:
> > > Hi all,
> > > 
> > > This series is for adding support to running the kvm-unit-tests at EL2.
> > > 
> > > Changes since v5[1]:
> > > 	- make debug bp/wp skip on EL2
> > > 	- fix microbench test
> > > 	- add to CI
> > > 	- applied the fixup's Drew talked about in v5
> > > 
> > > About this failure in micro-bench:
> > > 
> > > 	- micro-bench hits the assert in gicv3_lpi_alloc_tables()
> > > 		lib/arm/gic-v3.c:183: assert failed: gicv3_data.redist_base[cpu]: Redistributor for cpu0 not initialized. Did cpu0 enable the GIC?	
> > > 
> > > in micro-bench.c lpi_prep() looks like this:
> > > 
> > > 	static bool lpi_prep(void)
> > > 	{
> > > 	        struct its_collection *col1;
> > > 	        struct its_device *dev2;
> > > 	        if (!gicv3_its_base())
> > > 	                return false;
> > > 
> > > QEMU by default runs with gic-v2, so gicv3_its_base() should have returned
> > > false and the lpi tests skipped. However because of the overflow mentioned in
> > > the first commit (new to v6), the its_data.base was being overwritten to a
> > > non-zero value.  This meant the test tried to do gic-v3 things on a gic-v2.
> > 
> > Nice work on the micro-bench/gic issue. Unfortunately the timer test still
> > times out, and that breaks the new CI since that test is listed.
> 
> Can you drop the timer from the CI commit while I investigate? It passes here,
> but I can try look more into. If everything else is working will be nice to
> merge.
>

Done. Hopefully you'll find a way to reproduce the timer issue and get it
fixed soon.

Thanks,
drew
