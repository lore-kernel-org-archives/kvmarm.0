Received: from out-43.mta1.migadu.com (out-43.mta1.migadu.com [95.215.58.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5DE18051
	for <kvmarm@lists.linux.dev>; Wed, 26 Jul 2023 19:54:28 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1690401266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/jhrKYUy1PfMWu4oT4Kh1JD7ESwn35To/xsfOCSeebM=;
	b=SA6WgvnVcxstPyWogXVO++URu6Fh3qbTuxYcKcSVfKZuMo/6fOrFya0kTPuhcvMmZkp/+f
	mXLYXNBMHlOcFRDA5SrALDdNhfPAPV2T5kQia16HPFVeaeZ8XMkhzok0YLd8bY/W9ggtHr
	R39cnXkNs+cQDX0pqmtHmtwE7XT07z8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Fuad Tabba <tabba@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	james.morse@arm.com,
	catalin.marinas@arm.com,
	suzuki.poulose@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	maz@kernel.org
Subject: Re: (subset) [PATCH v3 0/7] Fix setting SVE and SME traps in (h)VHE
Date: Wed, 26 Jul 2023 19:54:07 +0000
Message-ID: <169040115362.2565311.6190140024156359049.b4-ty@linux.dev>
In-Reply-To: <20230724123829.2929609-1-tabba@google.com>
References: <20230724123829.2929609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 24 Jul 2023 13:38:21 +0100, Fuad Tabba wrote:
> Changes from V2:
> - Rebased onto Linux 6.5-rc3
> - s/__check_e2h/__check_hvhe/g (Oliver)
> - Fixed bug in calculating CPACR_EL1 reset value for hVHE in
> trapping SVE
> 
> Changes from V1:
> - Expanded the cover letter to clarify the reasoning behind being
> consistent in writing to the architectural trap register based on
> the KVM mode (Marc)
> - Factored out the code for checking E2H into a macro (Oliver)
> - Factored out the code that selects which register to write to
> into a function (Oliver)
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/7] KVM: arm64: Factor out code for checking (h)VHE mode into a macro
      https://git.kernel.org/kvmarm/kvmarm/c/ce92232614a5
[2/7] KVM: arm64: Use the appropriate feature trap register for SVE at EL2 setup
      https://git.kernel.org/kvmarm/kvmarm/c/45a3681a10ff
[3/7] KVM: arm64: Disable SME traps for (h)VHE at setup
      https://git.kernel.org/kvmarm/kvmarm/c/380624d4358b
[4/7] KVM: arm64: Helper to write to appropriate feature trap register based on mode
      https://git.kernel.org/kvmarm/kvmarm/c/90ae31c65d5a
[5/7] KVM: arm64: Use the appropriate feature trap register when activating traps
      https://git.kernel.org/kvmarm/kvmarm/c/a9626099a51f
[6/7] KVM: arm64: Fix resetting SVE trap values on reset for hVHE
      https://git.kernel.org/kvmarm/kvmarm/c/7af0d5e50006
[7/7] KVM: arm64: Fix resetting SME trap values on reset for (h)VHE
      https://git.kernel.org/kvmarm/kvmarm/c/375110ab51de

--
Best,
Oliver
