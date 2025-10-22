Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4C822D78A
	for <kvmarm@lists.linux.dev>; Wed, 22 Oct 2025 07:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761116462; cv=none; b=oXT2KUQXtE6LeriT8gajgP3J4C/CHXvJ2vRbLmJ/MncBEH/axzPz5Ici9TgcwTcR3PCzSWnUMKRe1cA1DPd+NZ5X7iES7OL9MKS2nFGXFrvd3PTSpZDmeD+1uGFxLeT3wAjNEvy7RWE91VckSzV4dnxjOXwTTAXVXlSyeA2dsCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761116462; c=relaxed/simple;
	bh=9KEBoR2NF5SFNxXTP9ERe3gk24NqRNbTEKVIDs5duuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FF1VSbLeIcvY3geUiGM/UusrjPS4Ry7T1B29XpqFdjblsdfl9ebm/F6EGYHVcZsPQgD20tQZjrhxd/C6rpwl3m2Yxa17UCqS8AG4rQlc3P1iABJpwTq5OwjDQm3z/bXHZT+OR+hghiYbpvvZA9Zc5c6Q5HkUPJH9/mmZUy7vqtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kFP9CdYp; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kFP9CdYp"
Date: Wed, 22 Oct 2025 00:00:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761116457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9KEBoR2NF5SFNxXTP9ERe3gk24NqRNbTEKVIDs5duuM=;
	b=kFP9CdYpXFhlbYcBxvLZpwKZovKdHaNAHaCCudWiy6suLIs0ODT5J9cVI2s04HjjfNbudz
	taiovlVK8FDkQ/YF3Dg6TrgQvASB2YIzETsutcZ331Oxg/BRyCyEec0l/wfjYuHU49Nrpj
	lI7AtI8dGYdJoVHpT7Gj8RouzUqRxzg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Maydell <peter.maydell@linaro.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: arm64: Make ID_PFR1_EL1.GIC writable
Message-ID: <aPiBH1_WZicoE7Od@linux.dev>
References: <20251013083207.518998-1-maz@kernel.org>
 <20251013083207.518998-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013083207.518998-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Mon, Oct 13, 2025 at 09:32:05AM +0100, Marc Zyngier wrote:
> Similarly to ID_AA64PFR0_EL1.GIC, relax ID_PFR1_EL1.GIC to be writable.

This looks fine to me, although I do wonder if we should just allow
userspace to write whatever value it wants to the 32-bit ID registers
and be done with it.

Nowhere do we use a 32-bit ID register value as a condition for trap
configuration / emulation, so even if the VMM lies to the guest it
shouldn't trip up KVM.

Thanks,
Oliver
