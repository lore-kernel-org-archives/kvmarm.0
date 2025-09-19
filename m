Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8A12D63E4
	for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 22:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321443; cv=none; b=bu+1Gcr4wIpktHyQ7uZiDkJgqRoQd6WC01M+JJmkqlVbbbEx3pYvcgkh6xTHY7Imo6LvQCrVpGtZ+C0jEx1+HhZL/Gd4BToFGNn7OGppMknYf2PxXycXjk6oA6y/ls+PQWXCUtla29XOUoYGlH2GXLtmFQimbxEdhkQXTRmGwMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321443; c=relaxed/simple;
	bh=Fb3bKpKqTYr2Snp+QfFKbrmolaxY+vy8qsPMy2pNG0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uv2h0DS97k7AErmqHgtle3pbWTfoOvUON4tyqVVwzFhXnJaRbpSj+AVu9jze1kGyuXWjRQBlnzBmmCjr8EWdXCmed6D+P/4HZzeHkOCXVAT47O5tmMKHbHy/LTmJsRSnRXtXUsFWlEdsWHuCDDXLRNqWIFI6fKfSgQSbkMvb/Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oMvitq2N; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oMvitq2N"
Date: Fri, 19 Sep 2025 15:37:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758321439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wejgJvJ+telvOoqvjuYRyYA1GW2xJkDX688ipOO2264=;
	b=oMvitq2NwZVYf/vbOtHD66sru9qX10p1arlJYfA6krLSsktY+DMPq0bgCVAqtbWbU3b22L
	RD+B1P5flLGIaVcxDs4RqkLOZG6lltaQB+wzcs3t0ZMCOQrEXoA1hpGN4r70pGrgpTakOd
	kktb0CDfhLL3fuMQX3zPYSCLDpND4yU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 00/16] KVM: arm64: TTW reporting on SEA and 52bit PA
 in S1 PTW
Message-ID: <aM3bG1fkB4cYslUJ@linux.dev>
References: <20250915114451.660351-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915114451.660351-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 15, 2025 at 12:44:35PM +0100, Marc Zyngier wrote:
> Yes, $SUBJECT rolls off the tongue.
> 
> This series was triggered by the realisation that when injecting an
> SEA while on a S1PTW fault, we don't report the level of the walk and
> instead give a bare SEA, which definitely violates the architecture.
> 
> This state of things dates back to the pre-NV days, when we didn't
> have a S1 page table walker, and really didn't want to implement one.
> I've since moved on and reluctantly implemented one, which means we
> now *could* provide the level if we really wanted to.
> 
> However, nothing is that simple. The current code in at.c is firmly
> 48bit, as our NV implementation doesn't yet support 52bit PA, while an
> EL1 VM can happily enjoy LPA and LPA2. As a result, it is necessary to
> expand the S1 PTW to support both LPA and LPA2. Joy.
> 
> Then, once the above is achieved, we need to hook into the PTW
> machinery to match the first level of the walk that results in
> accessing the faulty address. For this, we introduce a simple filter
> mechanism that could be expanded if we needed to (no, please no).
> 
> Finally, we can plug this into the fault injection path, and enjoy
> seeing the translation level being populated in the ESR_ELx register.
> 
> Patches on top of 6.16-rc4. I intend to take this into 6.18, so shout
> if you don't like the idea!

Just some minor gripes, otherwise this LGTM.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver
