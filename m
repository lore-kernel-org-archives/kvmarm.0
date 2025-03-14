Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239D043169
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 18:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741977450; cv=none; b=eR2+hluvUmwJ+ER9YgOVbGDkasFfkQLGpJ+BU+lPT9GQPxbHWpmV3hr+WZ10+WPgMLs8ylwOAGk5NT00pCxaosRahadcxmijTLrdChOeaZeR24o8GcYlxJpenRyjz60YLeanuVMF8M+3nZ5g0eyDCvzyc9FhJKWuuy8jBrl1gMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741977450; c=relaxed/simple;
	bh=rIut1bfYIV/I3DTiehM56ffDv27y3gMLfYehAWOa+vM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QVpfzbeK2QUgB+LaZZkeIesFtnfnnKvHJ7DHZwoHDkPziuXZSyMTW9QAY/CkhOyYFt0TD91a6B5ZLOd7+2mPUl6KBOwl/AOFN1/9Ks7la7JtVrjX3cotUBsuEqBC7Nb+xTmT2bgMilwoT4VfE0nNmInzP8392wxqoEi8SFeSBsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD216C4CEE3;
	Fri, 14 Mar 2025 18:37:27 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	maz@kernel.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH 0/4] arm64: mitigate CVE-2024-7881 in the absence of firmware mitigation
Date: Fri, 14 Mar 2025 18:37:25 +0000
Message-Id: <174197730164.734861.6726211221092480832.b4-ty@arm.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250128155428.210645-1-mark.rutland@arm.com>
References: <20250128155428.210645-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 28 Jan 2025 15:54:24 +0000, Mark Rutland wrote:
> On some CPUs from Arm Ltd, it is possible for unprivileged code to cause
> a hardware prefetcher to form an address using the contents of a memory
> location which is accessible by privileged accesses in the active
> translation regime, potentially leaking the contents of this memory
> location via a side channel. This has been assigned CVE-2024-7881:
> 
>   https://developer.arm.com/Arm%20Security%20Center/Arm%20CPU%20Vulnerability%20CVE-2024-7881
> 
> [...]

Applied to arm64 (for-next/leaky-prefetcher), thanks!

There hasn't been much review (thanks Oliver for looking at the KVM
bits) and there's some implied work that can go on top of this series.
But the patches looked fine to me, so I queued them. Mark or others,
please shout if you'd like them dropped, they are on a branch.

[1/4] arm64: cpufeature: rename unmap_kernel_at_el0() -> needs_kpti()
      https://git.kernel.org/arm64/c/174ade921138
[2/4] arm64: cpufeature: factor out cpu_is_meltdown_safe()
      https://git.kernel.org/arm64/c/f4fe70cd8522
[3/4] arm64: cpufeature: mitigate CVE-2024-7881
      https://git.kernel.org/arm64/c/837dfd070e94
[4/4] KVM: arm64: expose SMCCC_ARCH_WORKAROUND_4 to guests
      https://git.kernel.org/arm64/c/d2c173acbf93

-- 
Catalin

