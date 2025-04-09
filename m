Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136E91E7C20
	for <kvmarm@lists.linux.dev>; Wed,  9 Apr 2025 20:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744230707; cv=none; b=K8enM+XgQFkMRl65ZOz26I+TlSAkEb4SVCTmiaQ5fSWFEOwMncJnmWYHYONvtWH5ZMprnsLe0oyByuJFWT7zO6rCAzxaP9bbQBWovildYG0ATbduVWdr+OjaMWXS9sZyhBCHOwBx7JRe59qbZMETWdwfjo7v1lwoxhr5yIIzAVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744230707; c=relaxed/simple;
	bh=/Vul5m4Y17mhjN3thkG863AtX9rqqik8TH/QNObL0f4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Krq9E/4hSTqLRKORBxzmxiNwnihgTGiqFtDifLLPNyCA8ZwDnuu2TcIL7OA6UWMWsDFYuOIolOlwBKIGjcH37W8jCD0lrpWDGAdgIvMTPp9vS00KHzuBE2ArcESDLnyVJZBwgv5sss33PsdnJGuarabNRv/ClOBijYdYR6pzosI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uEUF9c5z; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uEUF9c5z"
Date: Wed, 9 Apr 2025 13:31:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744230704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rhw9TvczlbAheyT06wRwF+HH2SWlYEwVk/yXlXJVQrg=;
	b=uEUF9c5zkX+7RdtwK/w0O4sdsZGGNmkkqqFNHLWnNPdBGMKRyxkobxWJN3Ov84aamXiiub
	f/UoLB780UMgm5YhkKcdHuhhstUPowErJDYoRvEiQeBwccAhfmDdLE7HowIbB5ltmspM5g
	U34Igxld3DjndeF0Q7H5Yo93j+CjBcA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 0/6] KVM: arm64: EL2 PMU handling fixes
Message-ID: <Z_bZI5GQh91Vm-6G@linux.dev>
References: <20250409160106.6445-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409160106.6445-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 09, 2025 at 05:01:00PM +0100, Marc Zyngier wrote:
> Joey reports that some of his PMU tests do not behave quite as
> expected:
> 
> - MDCR_EL2.HPMN is set to 0 out of reset
> 
> - PMCR_EL0.P should reset all the counters when written from EL2
> 
> Oliver points out that setting PMCR_EL0.N from userspace by writing to
> the register is silly with NV, and that we need a new PMU attribute
> instead.
> 
> On top of that, I figured out that we had a number of little gotchas:
> 
> - It is possible for a guest to write an HPMN value that is out of
>   bound, and it seems valuable to limit it
> 
> - PMCR_EL0.N should be the maximum number of counters when read from
>   EL2, and MDCR_EL2.HPMN when read from EL0/EL1
> 
> - Prevent userspace from updating PMCR_EL0.N when EL2 is available
> 
> I haven't added any Cc stable, as NV is not functional upstream yet.

Similarly, I don't see a compelling reason for this to go in as a fix
for 6.15, especially since you're adding new UAPI. Do you mind grabbing
it for the next merge window?

With the comments addressed:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver
