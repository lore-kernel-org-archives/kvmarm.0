Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F2EF9CF
	for <kvmarm@lists.linux.dev>; Sat, 26 Oct 2024 21:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729978671; cv=none; b=hXbR7DoM9maOmDWHjdO9meiK2VXhj1XDRSLtES422A7jMOVMGNLZ87GVCzlk1bZLyDYtWLiSFVodfYK6kxgLLenvv3xpovHUC1Al6Qc5okGmV+T3EHIsVq9Ow5OQKg6el/tpBe8KpRVxOL9rhzxOC00eRB8Iu6tOg7pYA88UX64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729978671; c=relaxed/simple;
	bh=b7VMtLK5eGU7Ghv1CxreTd4ZnXARI07YyDiFkBYT92g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mQ4KiVlE6j88xksjY5NFAIiMsoozCB/nX6UolnmhmkevOPQL62XswRiym1SG9WV+RrOWdRKApOapfxGk2z61L81YEry1URAlQkmusp68gE7gsCixLo0EOEE0Og6KJQFSX6J0BUjSz/SJoH7T/Px7MTo13m22NNjOKF9QUs8ic18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OqRPrRR5; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OqRPrRR5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729978665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vSdjs3cy3XZFXznTm6G5FHJZRTxkxB+FvsmS8vmxRyE=;
	b=OqRPrRR58CIikyJ2dt07UVTpByHDSaNI944Y9zef6Jt/e5jE/kziYdgvcmu3RPycAvuA8w
	/VxsUESVdIs6RIPDSAQI9bqc3tihrPC2vhxj3GBw/7ZgOE+bZJGJEXKyADl46WnDMLKGUk
	rxiIsw3ebHclRh4wWvBz2Gt+g9O7RSE=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: Fix splat/misbehavior for MMIO SEA injection
Date: Sat, 26 Oct 2024 21:37:28 +0000
Message-ID: <172997861843.352914.8282320466312561253.b4-ty@linux.dev>
In-Reply-To: <20241025203106.3529261-1-oliver.upton@linux.dev>
References: <20241025203106.3529261-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 25 Oct 2024 20:31:02 +0000, Oliver Upton wrote:
> v1 -> v2:
>  - Make it clear that the series is referring to synchronous external
>    aborts (i.e. SEAs)
>  - Move helper out of header
>  - Pull esr + friends into tools, for use in KVM selftests
> 
> v2: https://lore.kernel.org/kvmarm/20241018194757.3685856-1-oliver.upton@linux.dev/
> 
> [...]

Applied to kvmarm/next, thanks!

[1/4] KVM: arm64: Don't retire aborted MMIO instruction
      https://git.kernel.org/kvmarm/kvmarm/c/e735a5da6442
[2/4] tools: arm64: Grab a copy of esr.h from kernel
      https://git.kernel.org/kvmarm/kvmarm/c/9fb8e9178b25
[3/4] KVM: arm64: selftests: Convert to kernel's ESR terminology
      https://git.kernel.org/kvmarm/kvmarm/c/c660d334b3a5
[4/4] KVM: arm64: selftests: Add tests for MMIO external abort injection
      https://git.kernel.org/kvmarm/kvmarm/c/3eb09a3e028e

--
Best,
Oliver
