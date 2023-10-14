Received: from out-203.mta0.migadu.com (out-203.mta0.migadu.com [91.218.175.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586491106
	for <kvmarm@lists.linux.dev>; Sat, 14 Oct 2023 03:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nkKrkV80"
Date: Sat, 14 Oct 2023 03:32:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697254370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oLvsxWswXaahyZapR9wNq3U+gs4SHEITbqa7yyhDkjg=;
	b=nkKrkV80GsiNRpb4OJXVy3FEoYr7FRCEh56ngj/t0VOHWIlBUNyjf+KC+oh/GDazxnItRs
	aLy0Q3D1vzQUsBe6IINymydIqWsBHLKFCXIz1hsZMfwdrzp6+AgjixR2MkZ5XCmL/2AwJt
	BpzgY+zRDfVlxKdVnghut/3kEuyoljk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Do not let a L1 hypervisor access the
 *32_EL2 sysregs
Message-ID: <ZSoL3vZDZk5RBhCS@linux.dev>
References: <20231013223311.3950585-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231013223311.3950585-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 13, 2023 at 11:33:11PM +0100, Marc Zyngier wrote:
> DBGVCR32_EL2, DACR32_EL2, IFSR32_EL2 and FPEXC32_EL2 are required to
> UNDEF when AArch32 isn't implemented, which is definitely the case when
> running NV.
> 
> Given that this is the only case where these registers can trap,
> unconditionally inject an UNDEF exception.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

If you intend to send this as a fix for 6.6:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Otherwise it is on the stack of patches I'll pick up for 6.7

-- 
Thanks,
Oliver
