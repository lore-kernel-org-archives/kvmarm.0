Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7ABC634
	for <kvmarm@lists.linux.dev>; Fri, 17 Nov 2023 00:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sWhfTjxe"
Date: Thu, 16 Nov 2023 16:48:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700182099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xRX1nhi/E+96mbeL5dEZigXMyjGgoJEcsJwbiU7pcWc=;
	b=sWhfTjxezw7GDdVXQ1ypikvahkezWFIjZRnuhsXQhukI+hVCOrDnO5pGkJQSZEL/DpiX5E
	pvd9mBBBmjTY2jyBE40NYZNnV9Abvt87/2kxjzDt0g6qKV2BnVUS5vUryOmSBQWuGh57ty
	2Y1nwS61veXEOlZ3VdXhOlowpTpkHYg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 04/12] arm64: cpufeature: Add ID_AA64MMFR4_EL1 handling
Message-ID: <ZVa4RHhgOnhR+nyZ@thinky-boi>
References: <20231113174244.3026520-1-maz@kernel.org>
 <20231113174244.3026520-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113174244.3026520-5-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 13, 2023 at 05:42:36PM +0000, Marc Zyngier wrote:
> Add ID_AA64MMFR4_EL1 to the list of idregs the kernel knows about,
> and describe the E2H0 field.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
