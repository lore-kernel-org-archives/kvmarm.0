Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8149F4315C
	for <kvmarm@lists.linux.dev>; Fri, 17 Nov 2023 18:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kLn0ST84"
Date: Fri, 17 Nov 2023 10:01:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700244085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ICjWCkk6lvP27jrLDi6UVGxrv85afq+rAYkTgatLaWo=;
	b=kLn0ST84m3e0KoWu8RHdsgq3GbiNjOKFrd/vLsPfa/91BEEAfSl7JmzIQ+VBS1mQMg6eX4
	T5aXSbgNXy9GLiEVJ2P+3ySarLoV9YZzGL4AZjTiVHCeDi9G6TWg6LRX5Yuz00VPhIupRY
	kHJEa5FGqugyKgzD4lOoUX2lLapk2JI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 07/12] arm64: Treat HCR_EL2.E2H as RES1 when
 ID_AA64MMFR4_EL1.E2H0 is non-zero
Message-ID: <ZVeqcPAW7qGj0RJ8@thinky-boi>
References: <20231113174244.3026520-1-maz@kernel.org>
 <20231113174244.3026520-8-maz@kernel.org>
 <ZVaycYt51sUWS0h+@thinky-boi>
 <86wmugzi96.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86wmugzi96.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 17, 2023 at 12:17:25PM +0000, Marc Zyngier wrote:
> On Fri, 17 Nov 2023 00:23:13 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:
> > Wouldn't it be more consistent with the architectural definition of
> > signed feature fields to just test the sign bit in this case?
> > 
> > Maybe like:
> > 
> > 	ubfx	x0, x0, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
> > 	tbnz	x0, #3, 1f
> > 
> > You'll also save 8 measly bytes of text while you're at it :)
> 
> At this stage, why not try this:
> 
> tbnz x0, #(ID_AA64MMFR4_EL1_E2H0_SHIFT + ID_AA64MMFR4_EL1_E2H0_WIDTH - 1), 1f
> 
> and we save a total of 12 bytes!

Ship it :)

-- 
Thanks,
Oliver
