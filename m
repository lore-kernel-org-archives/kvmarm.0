Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D1B13A865
	for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 18:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730400806; cv=none; b=GOTcaRRpb+e4o5YrU+pq3Da9ZntYmbT/XJnABh0rdM0w7Fi55L+E3ofFdJF49NnvTEgP+dDCCRYC73xiBopCVE6svM05HZfRh5Bj6SFzxo5ZeQ9VcxwLn44snEiNbTWGssxNJTtCASvaW2ZYVm7itGMl2ATRvJJiis074d0OAsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730400806; c=relaxed/simple;
	bh=biEynVmphYhoTrB27hClRk4jpvdh3IiZIIdwoP+0NJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G19E5BunNE6HRA3EOrPzFcOrzwWYEngcA5ASt+IYlnO22mdw+FABmvCWOGPLw4V6oAWydh5dK3XG9Ew3fxmTHtHsPs+mb4hjfsTtrgEDyMJNyUS0VkRt3zANA7IIuWXFgaaZ9ukWCgyjey4m3hNH97eoGpeucwC+m1cSBeHw7NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T1XnpDPW; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T1XnpDPW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730400799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tK7WwkdMueQwOc7swpJKOs3ICGLkBuJ4lMhvJB1bz4Y=;
	b=T1XnpDPWLm/xgIlVYAbP20dsT256mN48Wbigm18FvkZ57zI5hLN6ygsmKW0iBz+oHxZ2G5
	jz5Bd9SRNdpVQAUVnmiVhzn+TuSz4vvwwnfw4pAvYKTNq7QCFCYv/nva8BAViVT9ENAlxi
	NwW5dbn7ZDpq5GdoYo8RWWKjl2xF7cc=
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev
Cc: Oliver Upton <oliver.upton@linux.dev>,
	joey.gouly@arm.com,
	maz@kernel.org,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org
Subject: Re: [PATCH v2 0/4] KVM: arm64: Fix initialization of trap register values in pKVM
Date: Thu, 31 Oct 2024 18:53:06 +0000
Message-ID: <173040077833.3165327.8956831992268078648.b4-ty@linux.dev>
In-Reply-To: <20241018074833.2563674-1-tabba@google.com>
References: <20241018074833.2563674-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 18 Oct 2024 08:48:28 +0100, Fuad Tabba wrote:
> The patch that dropped PAuth instruction/key traps [1] did not
> apply to non-protected VMs in protected mode, since as noted [2],
> the hypervisor is supposed to handle trap register values in
> pKVM. However, in pKVM upstream code the hypervisor does not set
> all necessary trap register values in protected mode, and running
> non-protected VMs with PAuth enabled in pKVM has been broken
> since then [1].
> 
> [...]

Applied to kvmarm/next, thanks!

[1/4] KVM: arm64: Move pkvm_vcpu_init_traps() to init_pkvm_hyp_vcpu()
      https://git.kernel.org/kvmarm/kvmarm/c/0546d4a925a6
[2/4] KVM: arm64: Refactor kvm_vcpu_enable_ptrauth() for hyp use
      https://git.kernel.org/kvmarm/kvmarm/c/3663b258f723
[3/4] KVM: arm64: Initialize the hypervisor's VM state at EL2
      https://git.kernel.org/kvmarm/kvmarm/c/cb0c272acebd
[4/4] KVM: arm64: Initialize trap register values in hyp in pKVM
      https://git.kernel.org/kvmarm/kvmarm/c/b56680de9c64

--
Best,
Oliver
