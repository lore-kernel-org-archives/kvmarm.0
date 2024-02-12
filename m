Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1087A182A3
	for <kvmarm@lists.linux.dev>; Mon, 12 Feb 2024 20:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707771367; cv=none; b=LSAYfhTFOlXGnopGb2Z/4WmcD3EFtvPupDR+e5pNCj1koh+JYobKBbRpQ6XDeZJT21KsaZI+vvO0uRtLGA7tNYjgTx22l/WcIIo8KbtPTH5cxX4M98nrXEX4uCTUYYqFyDbNFi2FJKN9dW0dZ8ZEs4gH6cKRQjZKVgVHv6/Mpio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707771367; c=relaxed/simple;
	bh=rrI3tNQhqVCwYpzLyaH5oXLekYU4Nm/fMs3wZNmmYHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OK8O7uGbAd6rlCXQrP4GbAV/4W5Jpx/GnNh50uR8R2BRKZwxLOIh3vGvmbhcPZZXXfa+7xWeLza+DhzfbL8gm7Bm8B5PR2SDxYNl8qvNPX79x9tjp+U5nfuwZTH1bf+1Y07WjxBn9BVhlvWluqXUbj8yphLnBXroL1wW91gyT38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lPFkuA4K; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lPFkuA4K"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707771361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zI/RAs/UVKnQtZjWOycJH2sTMN5CSEsWUH4v6/bCEvQ=;
	b=lPFkuA4KiZL3qHa13F8/spz7WBj99LmrU5jwBD8k+uPkD9XOxgz2C22d/shSrsjq/tWmcY
	Z1RBbRHYGcVJoN+8MCqGIgLRydGlTxJumnVXiysrxNzT40XtxJEhgEH29xmI63GZrH9Hga
	PkEopmI0Udg95kECfrTlnVKs0VU8g+o=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	maz@kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>
Subject: Re: [PATCH v1 0/2] small kern_hyp_va() cleanups
Date: Mon, 12 Feb 2024 20:55:38 +0000
Message-ID: <170777114722.3090079.17787047168330760031.b4-ty@linux.dev>
In-Reply-To: <20240208105422.3444159-1-joey.gouly@arm.com>
References: <20240208105422.3444159-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 8 Feb 2024 10:54:20 +0000, Joey Gouly wrote:
> I wanted to add some comments to __kern_hyp_va(), since I was recently trying
> to understand it, and I think it could be helpful for someone looking at it in
> the future.
> 
> The second patch removes the assembly macro version, since it is unused. Maybe
> (out-of-tree) pkvm uses it or it's just worth keeping around in case someone
> needs it in the future. So if that patch isn't applied it's not too important.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/2] KVM: arm64: add comments to __kern_hyp_va
      https://git.kernel.org/kvmarm/kvmarm/c/d198e2668e24
[2/2] KVM: arm64: removed unused kern_hyp_va asm macro
      https://git.kernel.org/kvmarm/kvmarm/c/a02395d0f3bf

--
Best,
Oliver
