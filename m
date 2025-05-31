Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272B4182B7
	for <kvmarm@lists.linux.dev>; Sat, 31 May 2025 17:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748713937; cv=none; b=gVi+0baNXvmpUnNU/AKEgSthsi6ksV9ZohsaqNTiOrje1ZFhaUS2BlB7itZhPNBwrFV4x7sg0GRqWPQ81ih2mEVvF0pit5Fj9XNwDPFK2yg5X7298PRXPSbLPRFv61SEl0BJpz00Ugy9w47ThtV1H3oSoYWYhlszu9ajSnqRc/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748713937; c=relaxed/simple;
	bh=vQPOxLEjGOKxURuDGxJ6NtQJZh9zh77bs03hG94j3uI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rpl8xyRkuBUgaDhs8bmHuzaSLWB29Lw22/bqh37u9XNgu/qyICQvPLHASWg9hzEHpx22QvXwGcYYSVxrdbSVO7AWROmtIZ+r/f1AtMlkV31ZybiHBz8vKUdIKO9VmfWfSBkQP2EzAef/2jEBVC7Y51tCleS0vGMPcNd7wpEONyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lh73EyMa; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lh73EyMa"
Date: Sat, 31 May 2025 10:52:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748713932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mIKaGfWeay4gmgyitDh7ECLUFubr+Qk+a6BxZ38Xhw4=;
	b=lh73EyMa2Ds6x5eHvP1OegrOq1lLDkdWfC2sOEGDrwumkDIpZDjAuBHm8RAzrD9BN+KmG/
	g4reFmDMcopUnKU/rM05GHnDDq9LtbGeqWjm4nZtwhZKv2waw9UspWtYXz8kfadLHktq8/
	0gmalqL7gcf5GhEhj1vCWtRAk2cEJPU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Add helper to identify a nested context
Message-ID: <aDtBx7BXLeCzofPf@linux.dev>
References: <20250531164901.1166892-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250531164901.1166892-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, May 31, 2025 at 05:49:01PM +0100, Marc Zyngier wrote:
> A common idiom in the KVM code is to check if we are currently
> dealing with a "nested" context, defined as having NV enabled,
> but being in the EL1&0 translation regime.
> 
> This is usually expressed as:
> 
> 	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu) ... )
> 
> which is a mouthful and a bit hard to read, specially when followed
> by additional conditions.
> 
> Introduce a new helper that encapsulate these two terms, allowing
> the above to be written as
> 
> 	if (is_nested_context(vcpu) ... )
> 
> which is both shorter and easier to read, and makes more obvious
> the potential for simplification on some code paths.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Thanks! I'll probably pick this up as a prefix on my abort routing
series if that's OK with you.

Best,
Oliver
