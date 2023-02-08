Received: from out-160.mta1.migadu.com (out-160.mta1.migadu.com [95.215.58.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E906AAD
	for <kvmarm@lists.linux.dev>; Wed,  8 Feb 2023 17:30:55 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1675877446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Cj7BKcv54dh/vmCgjO7Sf+01g0pnTrEOauoKRLwAlk=;
	b=aGCtUZXdysDHLdzR46H44TfF3VRWisstqqfKIuQYkHN1ufL9mEdYmGEHs7cNk6CRPZK19q
	nBPsOcdY+SK9pcFm9lOVsjG0vMsMiRZ1KzDtRHLKULAL+kGkmybi1PDvUSa8VmrKnOepPx
	89bXFxUEsQO03lxThXN0dD/dn4rrPFU=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Cc: Akihiko Odaki <akihiko.odaki@daynix.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvmarm@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Mark some VM-scoped allocations as __GFP_ACCOUNT
Date: Wed,  8 Feb 2023 17:30:21 +0000
Message-Id: <167587739433.1104197.9512200664368218727.b4-ty@linux.dev>
In-Reply-To: <20230206235229.4174711-1-oliver.upton@linux.dev>
References: <20230206235229.4174711-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Feb 2023 23:52:29 +0000, Oliver Upton wrote:
> Generally speaking, any memory allocations that can be associated with a
> particular VM should be charged to the cgroup of its process.
> Nonetheless, there are a couple spots in KVM/arm64 that aren't currently
> accounted:
> 
>  - the ccsidr array containing the virtualized cache hierarchy
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Mark some VM-scoped allocations as __GFP_ACCOUNT
      https://git.kernel.org/kvmarm/kvmarm/c/5f623a598d12

--
Best,
Oliver
