Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF99258CD8
	for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 18:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527948; cv=none; b=NugrYrnXLUXErQ0qsvbVwaz5OQ3x4Xsn0AWTWB4ws+1bHp/DbQgsDOatBEGRZIFQkqlXRPkiOvhR0QbXilQqMRf63x3OYZh3YfSk+hX9RNPuS1J38l64H5a5/zWwIhrB3kPFXBb1GuER0MPwiFiJuxpe2EhIRIHonkUN+FWi8OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527948; c=relaxed/simple;
	bh=/jjEzAslG7A+4L4WRlZhezibz8rv5zV2Vl9ngC16MDY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qNWshGrrow/y/9lm+kXTdUnjHrMQufn9glihI2SpImj9v0B5VSy64+O/OwuUs5zrjMP7qqXrodKx6c1qiNHOvO29p8qAGKSm5dtQvClIo7oQFaOs466WuEr9jgzx7daY9Tk3Y+zB1HjHf1hdzACNe1RvS1eNh+/d07TDC2GVP9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uRkNlgny; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uRkNlgny"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757527944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w54ZtDZQFMeXX1y6MbPxImjLWdCu5YCdGDjYkTrfrTQ=;
	b=uRkNlgnyH74FlfN36uR5MSG4jl7fQuKCV/4JLms8QdqMkIwkyIUHFFcQJeUDPcFLHc1dJ4
	wORBNYYdXMJirzk4tNYjQl+EAaD74IF4bYucHnf76CahP+wLZVIWSACELaZQ+VB0bXgkfh
	qUn7rbO20s2smZh6BUL63JI3SHy3NnA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: (subset) [PATCH 0/2] KVM: arm64: Revert resched fixes for stage-2 destruction
Date: Wed, 10 Sep 2025 11:12:16 -0700
Message-Id: <175752793035.3680647.2017483654702951958.b4-ty@linux.dev>
In-Reply-To: <20250910180930.3679473-1-oliver.upton@linux.dev>
References: <20250910180930.3679473-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 10 Sep 2025 11:09:27 -0700, Oliver Upton wrote:
> We're getting pretty late in the cycle and things haven't settled down
> yet on the resched fixes. At this point a revert seems like the best
> idea so we can let an improved version bake a bit longer.
> 
> Oliver Upton (2):
>   Revert "KVM: arm64: Reschedule as needed when destroying the stage-2
>     page-tables"
>   Revert "KVM: arm64: Split kvm_pgtable_stage2_destroy()"
> 
> [...]

Applied to fixes, thanks!

[1/2] Revert "KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables"
      https://git.kernel.org/kvmarm/kvmarm/c/fc670ad5966f
[2/2] Revert "KVM: arm64: Split kvm_pgtable_stage2_destroy()"
      https://git.kernel.org/kvmarm/kvmarm/c/e6157256ee1a

--
Best,
Oliver
