Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3BF2D94A7
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 17:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498821; cv=none; b=kOMa5UEufjAeuAsbfrNHo+08pGqfEZw16EsKAAgfCZb6iCpMSUavR2+9P30R8WO1neZyfE4bb8AejmSoWz6n49H+G93lY72dzRwdOjJLJEsm2zsxUCIVjH+bl2PRjDHonZ/FP6uDmt8JaF55RpIq3U3vPssFyIViMZeibxsJ5nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498821; c=relaxed/simple;
	bh=XqkFm5uiM1Ti24lOLekRP8MWbCHchWC6iZKtwdpght8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jvceo+jAcxj+8KBP1rH3JiA0AQXhvAvrMXXFrytx4i2ud2kbVE9SNgpMUExeilt9Xc2Qu+6FzGsn1g2y7J352ctfQ06BFvd/daXHEhnXi9iw+mdgjvOlhiXap0cNXeZcHQdhhazuQ3aQKstL2DW44lpxJkHZiXtL+nJaEofHGng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I0Lr87k4; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I0Lr87k4"
Date: Thu, 15 Jan 2026 11:40:12 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768498817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a160fs7ZxOedpgEA6c8XFJoOklvKGzFCclb8ImPuokY=;
	b=I0Lr87k4KDkPW9XaYXTMHykAL1S6iwdeOP54KJQCvE/adHMi2Ep+F827WbwEkBunQp/oO/
	OeNkHf5PSDA8KAsrT5DGTPBkuV6zOSC3BEXmB/4fOJuh2btFR6zQy23FokcQwKY8QOSFKx
	QyvZPv2zgN3UKWbfKik5cKQXWvdlkM8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	maz@kernel.org, kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v5 00/11] arm64: EL2 support
Message-ID: <csscff65cagzfgyvsseufdqupde64z5x73llmzgzci7u43pzbs@fv7pfn4jxrdv>
References: <20260114115703.926685-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114115703.926685-1-joey.gouly@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 14, 2026 at 11:56:52AM +0000, Joey Gouly wrote:
> Hi all,
> 
> This series is for adding support to running the kvm-unit-tests at EL2.
> 
> Changes since v4[1]:
> 	- changed env var to support EL2=1,y,Y
> 	- replaced ifdef in selftest with test_exception_prep()
> 
> Thanks,
> Joey
> 
> [1] https://lore.kernel.org/kvmarm/20251204142338.132483-1-joey.gouly@arm.com/
>

Hi Joey,

So this series doesn't appear to regress current tests, but it also
doesn't seem to completely work. I noticed these issues when running
with EL2=1 (there could be more):

 - timer test times out
 - all debug-bp fail
 - all watchpoint received tests fail for debug-wp
 - micro-bench hits the assert in gicv3_lpi_alloc_tables()
   lib/arm/gic-v3.c:183: assert failed: gicv3_data.redist_base[cpu]: Redistributor for cpu0 not initialized. Did cpu0 enable the GIC?

Thanks,
drew
