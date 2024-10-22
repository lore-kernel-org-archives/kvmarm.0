Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3572219B3EE
	for <kvmarm@lists.linux.dev>; Tue, 22 Oct 2024 13:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729602642; cv=none; b=NZaQfj1sznNi8oz+xGK1zHOCkLQ9c4ZRZv/2YqcsJ6P/FrFu9jQ16hSjBbyrgaUCHydtwtpMad6dcRZlJF/sUiB/sDUsz4OtEQvgRU1kI40lrDQrnzSyaxUa2QN/iuvOQiJ1KC/qJG+KLSH9SggBTzKpzta+xfZhCL6C91qPrEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729602642; c=relaxed/simple;
	bh=0Ma2PDD0lwXIcfNLvxy9IIu/pe4Bz/lSz8+5O8rOWuc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=takKm+2AOU8EUXFn0aNS30+iPC5kKg1hve9+ZIgmWc4NO9kgVcR1poLQyFX3x1k4V0HXHlA/CvobchpcXYABm66XwKjew+BqRwfIXe/wmzPXl20WXx/6Ob8GAiJMh495UMCtT0KO56BciwlF+GitL1FaFoUyQCG05ZHJKGt0+r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Oa3jcEpp; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Oa3jcEpp"
Date: Tue, 22 Oct 2024 15:10:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729602637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L819H4TgTpR7m/nNd75LAwuiLs++CdEcR+lmxCWgMZI=;
	b=Oa3jcEppLsYfNnHi1uKat6MfBfJXbqsxyXPAxQRICu+j36vjI5PNP8UF4XGv39oez+vJbE
	0I6kM/2WPBi0WvkoqIy4sruOybnk3TzEWGN1CUDrHGdQpys59oYTsryTC0AqwZkWrhDVgQ
	uoYlB81fDSXflTVwWCDRx/GEbDXzqic=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Subhasish Ghosh <subhasish.ghosh@arm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 0/3] Fix arm64 clang errors on fpu tests
Message-ID: <20241022-2c60a0bcbb908435aa91d1ff@orel>
References: <20241022004710.1888067-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022004710.1888067-1-rananta@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 22, 2024 at 12:47:07AM +0000, Raghavendra Rao Ananta wrote:
> When compiled with clang for arm64, some build errors were observed
> along the fpu code. Moreover, data aborts were seen while running
> the arm/fpu test due to misconfigured input/output args in the inline
> assembly.
> 
> The series tries to addresses these issues.
> 
> - Raghavendra
> 
> Raghavendra Rao Ananta (3):
>   arm: Fix clang error in sve_vl()
>   arm: fpu: Convert 'q' registers to 'v' to satisfy clang
>   arm: fpu: Fix the input/output args for inline asm in fpu.c
> 
>  arm/fpu.c                 | 46 +++++++++++++++++++--------------------
>  lib/arm64/asm/processor.h |  2 +-
>  2 files changed, 24 insertions(+), 24 deletions(-)
> 
> 
> base-commit: f246b16099478a916eab37b9bd1eb07c743a67d5
> -- 
> 2.47.0.105.g07ac214952-goog
>

Hi Raghavendra,

With clang 18.1.8 (Fedora 18.1.8-1.fc40) I get a bunch of errors like
these

    arm/fpu.c:281:3: error: instruction requires: fp-armv8

I used my cross-clang series[1] and configured with

    ./configure --arch=arm64 --cc=clang --cflags='--target=aarch64' --cross-prefix=aarch64-linux-gnu-

[1] https://lore.kernel.org/all/20240911091406.134240-7-andrew.jones@linux.dev/

Thanks,
drew
