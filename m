Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4538128EC
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 18:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748024006; cv=none; b=TQ31LI4KoCeM9w5Vd6dyt+JouYbCsgkmlTcY0Flk0DMpR5ZcEN3Do9eLevuon5TqzxPZNi9VUPwyhGoyZ5N4QLwdYnDBZCE6D8EaxsJpkIpamxKcgaINn2CUmfy/rWSI/3wP3VJGS0zCX+Unes8+DswDS53lhlteX/shxXvKIZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748024006; c=relaxed/simple;
	bh=vBw3Z9SMtYaeAwAIUDBAMbn+taqiGKPZfRCToSFifFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SnhG6jJDOhaJLKNRALZ3+E6VVJqytQB7XFq//dS0hc1YhRj7kWQHpTR+oXNgUE/xtcVdzNqERfDPHJ0uIZcG2uZoK1P4aZBrheVJuFONo1AaWZp64Yw4SCzqUtvw26KhcKs3xccJ1tppT9rCptpXUIxI4LlQ66p6elN9DRNhOnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n6mn+5Hj; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n6mn+5Hj"
Date: Fri, 23 May 2025 11:12:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748024000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AYXcStxTya745/C3qWHhaMO1kEtnTappP3q6LyNH9C8=;
	b=n6mn+5Hj8g4GnsWRsrOGTewo/+asWXjkTgk7kMaDSYdj/Jt6z9Nxv65iMfgt/a/ZlomGKv
	n9mlwVz3zX7i6CRFoL5aIsstJfd7TQucOLwmZ1N4m4seQPNM31cc/I/mvcGsmm4ip7ePPa
	hKnqc9Bhv0SAk3xvOwp1/NQYr0yEh0E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH] arm64: sysreg: Drag linux/kconfig.h to work around vdso
 build issue
Message-ID: <aDC6l2MKYbncZKRt@linux.dev>
References: <20250523170208.530818-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250523170208.530818-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, May 23, 2025 at 06:02:08PM +0100, Marc Zyngier wrote:
> Broonie reports that fed55f49fad18 ("arm64: errata: Work around
> AmpereOne's erratum AC04_CPU_23") breaks one of the vdso selftests
> (vdso_test_chacha) as it indirectly drags asm/sysreg.h.
> 
> It is rather unfortunate (and worrying) that userspace gets built
> with non-UAPI headers. In any case, paper over the issue by dragging
> linux/kconfig.h in asm/sysreg.h. It is the right thing to do, at
> least from the kernel perspective.
> 
> Reported-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Fixes: fed55f49fad18 ("arm64: errata: Work around AmpereOne's erratum AC04_CPU_23")
> Link: https://lore.kernel.org/r/aDCDGZ-G-nCP3hJI@finisterre.sirena.org.uk
> Cc: D Scott Phillips <scott@os.amperecomputing.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Will Deacon <will@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
