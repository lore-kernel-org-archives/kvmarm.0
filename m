Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50C0191F62
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 17:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738951151; cv=none; b=LjfqQyzQAnXSI9WGelqVFGLtj8kDVjgkGXZuY4GmxMjrpqboYfH6RTPNncYGK1yqZI9UamUFuElw6Zx8SFG39HKZ92QKdVyjB/W3hFHqU4iDsqTi7E+xwXVx2J0edwVWRZsIkrhn0WXoyI7Z4itY3X20QzsmdoAwGvChRnSNg0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738951151; c=relaxed/simple;
	bh=gsugIwHDEbRnM9UEhKnpw95u8gLMSq/fysiSUrT+CAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=apwjtAiWJJRHKqXEqFrx921DjFCcxjK00Bd+ASLANXUIyIIZj7rsndSD8IVNcmaxHaKN9iSGHxm06/Lmg9xNrQabE3TW818yUCpHUQ2h6lzGtYUdDCKJGn4nxf/AIS5jQFt8jeH9teNpfFZWKl4JWVwTX9ZL+/xLV2uFpJ1BCcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q07uWhaW; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q07uWhaW"
Date: Fri, 7 Feb 2025 09:58:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738951141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vYSRH4jES0cuKpYx7kPs80Ku9bgyQ0A7OnKQUis7Fqg=;
	b=Q07uWhaW/+M7sBMweEZugC689oW9CW0FZWeX3WQp2lIxURoz8o7sCaK7GD1JusohZA32Dl
	GbrXiPpNLn2hdB1+onXaXzZ3CwtWz0fpiCsPm9v5gjKvQTyoT0OSe9Bf4WYMjmUKE5xEAv
	BdlFObSAWrDbQkNu/vNhiTHnebdw/68=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Fixes for pKVM NP-guest support
Message-ID: <Z6ZJ4LDSOG6Lr2Ba@linux.dev>
References: <20250207145438.1333475-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207145438.1333475-1-qperret@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 07, 2025 at 02:54:36PM +0000, Quentin Perret wrote:
> Hi all,
> 
> Here are two patches to deal with a race between the handling of
> permission faults and MMU notifiers with pKVM that I found by
> inspection. Specifically, pKVM gets thoroughly confused when it doesn't
> find a page mapped in its relax_perm path, while standard KVM deals
> with that trivially thanks to the -EAGAIN special case in
> user_mem_abort(). The second patch addresses the problem by simplifying
> the implementation of multiple pKVM hypercalls, which also has the nice
> side effect of improving locking by not taking the global host stage-2
> lock as much.
> 
> Patches based on 6.14-rc1, tested in qemu on on Google Pixel 6.

Looks reasonable to me, the locking improvements are certainly an added
bonus.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
