Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC3E6EB4F
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 11:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707391342; cv=none; b=JnFSuan6+lw097QpUZoBq4DFRH8soQTMxEW+n4KGrO89QtZBIrljYEVxA31pPTQmk3ZTzZOm6kamtcnP2ZuBBFQGodZO6xm/jVrv1JEYpvllPpHuRQAaEkm+LC/lJM1d2jY+CfbNm0COymW/G4DiOfgjFkHRN44Cr9LawzKYq0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707391342; c=relaxed/simple;
	bh=sB+SJlnfefaTrlvC8W8vQzEEKxoaEtBt5MLmugvsZco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ciig51YRppHo9NCcOEJ3euI3Ngs8Ct7jFHfM5es8KCz9N1YQR32/J712v+K0hawwXK1PuyrAxF8Tehg3X/UT2hsqMl32EMRUIW7apKbPSyYdaYyOBSL97qbgxTyMmaukdd3VcuvaSuz5QC/rxVmkKkSJ74SsSNG77w4IqgJRb74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IGzNTig5; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IGzNTig5"
Date: Thu, 8 Feb 2024 11:22:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707391332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+JLC0bJbodI8ZiE9KumZ6n3ksTg1WYrWoPpSkRILYLQ=;
	b=IGzNTig5GF8t6a3J0S1YdVllPWiEh/7KZrPf71DcSnhDhIThtk5lrzJW8l06r5mfmUbYGg
	BM6IiuXguDkYNGYk3PvyHZPZGX2Cd35bAQUcWDdc94wdAn6xwdsrYOLgZnxnR87IwmayYl
	zxpuX570/mSCjclRcGWULt7i9k0Chr0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v1 0/2] small kern_hyp_va() cleanups
Message-ID: <ZcS5W0xl92g-RVM6@linux.dev>
References: <20240208105422.3444159-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240208105422.3444159-1-joey.gouly@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Joey,

Thanks for having a look.

On Thu, Feb 08, 2024 at 10:54:20AM +0000, Joey Gouly wrote:
> I wanted to add some comments to __kern_hyp_va(), since I was recently trying
> to understand it, and I think it could be helpful for someone looking at it in
> the future.

That part is definitely a bit screwy :)

> The second patch removes the assembly macro version, since it is unused. Maybe
> (out-of-tree) pkvm uses it or it's just worth keeping around in case someone
> needs it in the future. So if that patch isn't applied it's not too important.

Keeping unused code hanging around is rarely useful. While it is nice to
give consideration to the pKVM folks (looks like they don't need it), it
is easy enough to re-introduce later on.

-- 
Thanks,
Oliver
