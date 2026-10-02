Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538A02DC79A;
	Fri,  2 Oct 2026 11:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790940706; cv=none; b=YPQ/u2W3+DvBYd9sD6k2ZxftveGdzgZIxwqx6YIL+kU7znowuovDpemcjdRItEiJExXZBmt7jGEtgknws2GndQJKOagF0KSrn/HLuE1H9SsZyGYv7jWN3fCSHc0rt8ZYkVOZHaPGZeqkzWgigJ+mBvSdI+OOvPEe6LmemqQBxuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790940706; c=relaxed/simple;
	bh=GHBXG7XFUqdIALcsRjO0+gTxSTMwPXKBLZDDO5Ju6X4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e7OEjYIgXkzqgGcb7QgcEgjk0Fq344BUHEJnxDLUTP449cBTwbTg8xlJ7IrVgqXp1eczQbMDw79a3vGntCHr/WcxW3VWP4hDUyL5AFnEfKmVAmaRJ22+UwLXbL2/90AEeyitpsjvCqkZlcELkYKq8rJXPcv8oZ1SDxOEWiaweLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UxdCzIX2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UxdCzIX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE901F000FF;
	Fri,  2 Oct 2026 11:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790940704;
	bh=b4VkGgo7n4HBEs/biZdCD1XgB9q8yhaoXFYL/V/DAco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UxdCzIX2CLZmFKixnPhH65yspvPyLQ3+OjjciejtBxFsTdRXWJFKkJpOEJQ1BC6az
	 CSbLZuxNDj8RMKpd4CAVu4c8gxsTY2ESy5fmy0i4THj6sXxDzOzS+OGorQk21k7P1F
	 8YbpFnf7AoieMwzO+GlLzVQP0bggxMzTtCJtbyD2izLXBzxlNwh5GQOLMMAx/TxmbZ
	 uOFrTkXNaFy5tlphaaxvxHX+e+JsnOc+jk7Y/UxoYw7vXLyfKNKcrILk/yxY+6cPaQ
	 rM4HJxW48SjXtn4NtMN3OxhFBeXEkzlzfy0PiNzVk38NCOgEJ6L8OcOSdyi3QOsL0b
	 cbEMgQ5WgZ5iQ==
Date: Fri, 2 Oct 2026 12:31:38 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 14/15] tools: Synchronise the kernel esr.h
Message-ID: <ar-V6snJbqFEmHp-@gremlin>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-14-3556644cd927@kernel.org>
 <ar6NXWzQ1rMb1aId@gremlin>
 <680fe21e-beca-4056-84e3-f501fdfed902@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <680fe21e-beca-4056-84e3-f501fdfed902@sirena.org.uk>

On Thu, Oct 01, 2026 at 06:27:56PM +0100, Mark Brown wrote:
> On Thu, Oct 01, 2026 at 05:47:42PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Sep 30, 2026 at 10:48:24PM +0100, Mark Brown wrote:
> > > To pick up definitions for GCS.
> > >
> > > Reviewed-by: Leonardo Bras <leo.bras@arm.com>
> > > Signed-off-by: Mark Brown <broonie@kernel.org>
> >
> > This seems to be out of date, with your series applied to next:
>
> Yeah, though some of those are changes that are in -next only so
> possibly slightly premature.  I'll resync with mainline, really this
> shouldn't be a manual sync :/

Thanks! + Yeah agreed, it's definitely a pain.

--
Cheers, Lorenzo
