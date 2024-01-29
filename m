Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64719524AC
	for <kvmarm@lists.linux.dev>; Mon, 29 Jan 2024 23:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706570235; cv=none; b=QA4ZLQEliJIxy6oUW4qPzVFr+o1Cpx4FhlijiwT60W8pC0hy9rQfts4ZVYcrIsClIrWlKwF9vezhrSyEZf7j4uowcuOXgqDaXE1ex3YSWF+kpKBltxZ65x0lK58MgPpeb4O3SGW69DLDW71kEmhUElYzHx0gyzXzrdm7wb7Mwvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706570235; c=relaxed/simple;
	bh=w/QfgsSmE5DAFlEeJou+7szSE6ht1mKclUNhYbABw6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IMceTkRIcIY2E1qxRlugKzmb2biMwi9tfL2ZWrJaegA+XfSz93XCJn3hkRo8K4G9IiJnW5pR+eaY3paQAxEF0ws8Zuuvo9xnUm+zsMMUVC9aQiPkGcpQbsQfrlHFh9IIrR+k/iamZ04VP5PstqDxfWa1HJlYHZBb0/vuQn0s6ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=admD522d; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="admD522d"
Date: Mon, 29 Jan 2024 23:17:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706570231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WLuRlRCwuI6asqqMQ9nqwhi3i/dMRQr3XJD+CfB0Xy4=;
	b=admD522d8Nl6IR0vun3fAoB/CzcnGnamlNUcMKTFhvtQQykH72MoRtbwWmbwRbNv//uele
	plUr+qqVTK36LEGYcFj9OCElFiDiG5pC6pTG/5pCGLPP790dCQqnv52d2zejGFImLx8lKv
	HfyseVmIXjQ+Y4HHjuc+7ZrcDXW1U24=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Add capability for unconditional WFx
 passthrough
Message-ID: <Zbgx8hZgWCmtzMjH@linux.dev>
References: <20240129213918.3124494-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240129213918.3124494-1-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Colton,

On Mon, Jan 29, 2024 at 09:39:17PM +0000, Colton Lewis wrote:
> Add KVM_CAP_ARM_WFX_PASSTHROUGH capability to always allow WFE/WFI
> instructions to run without trapping. Current behavior is to only
> allow this if the vcpu is the only task running. This commit keeps the
> old behavior when the capability is not set.
> 
> This allows userspace to set deterministic behavior and increase
> efficiency for platforms with direct interrupt injection support.

Marc and I actually had an offlist conversation (shame on us!) about
this very topic since there are users asking for the _opposite_ of this
patch (unconditionally trap) [*].

I had originally wanted something like this, but Marc made the very good
point that (1) the behavior of WFx traps is in no way user-visible and
(2) it is entirely an IMP DEF behavior. The architecture only requires
the traps be effective if the instruction does not complete in finite
time.

We need to think of an interface that doesn't depend on
implementation-specific behavior, such as a control based on runqueue
depth.

[*] https://lore.kernel.org/kvmarm/a481ef04-ddd2-dfc1-41b1-d2ec45c6a3b5@huawei.com/

-- 
Thanks,
Oliver
