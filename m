Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D421A2475E3;
	Mon, 14 Jul 2025 13:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752499966; cv=none; b=br146vWfPxtf1ch9Tvj2EoMwQBcmVc2G+OqANluPvyRKtwxousE6qFtMp/G/nuAz5559efePyycwLU6R12hL8YKn5+pl6G++ckYNUqAdaFvEtwOTZK4YcvqiEpTFinKf03tUdOxY6eWzNm7JXLUX5g2sb2NZ+uR53uJffvmy6Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752499966; c=relaxed/simple;
	bh=zYLFg0UGybuPu0kCXHDSNl+grvOFE2zIo70Nf4XZjj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CoPoKukXtVnkoZnsdtaDkCdn6ZGAcNcdGzdzcAZRgbc7u0X5EXGyAkwSfM16kIQ9VyVUw7g1UIB36bwpjQ4tDPcV4M4kGDXp+ZQvlAhf3foN9Eaq4O2HGYFNZauZEbZbzr00QOAiV93yjEX76//RhW4/EFevX9HzleZCsVYmgBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=touKXH+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="touKXH+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCD2C4CEF6;
	Mon, 14 Jul 2025 13:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752499965;
	bh=zYLFg0UGybuPu0kCXHDSNl+grvOFE2zIo70Nf4XZjj4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=touKXH+Qb7rjyg66pw1fVCbvQAzWsmxh7egKqLtOjYEBZTBcu2FM0jsxz01I+6I+W
	 qpx2dBxkQUHNwnTr8g1wySB0VzzJkWQ1HkEjzP4H8qQMlmS3GYAOFlQtFBEfgwfD7f
	 h9qKA82Xbb2GMrrQe4yEps7c9OUXrT0CB4zDSq9VuSMxBa2jpXnFQy32+n0EtlT9Rx
	 vR8aRyRhZVeIpSYKNV9CsRLZMcKy721QXGwV6BIr/1tB5qXF4dJDGrsZ3FEHOGaUbF
	 51B6L3i/YubBnIfdXnO/Z1yeEBc84d8Fn4m5sKHweSjgXUhqzUH/jqTes+x+lxunU9
	 cvDEhaNXyyZyA==
Date: Mon, 14 Jul 2025 14:32:37 +0100
From: Will Deacon <will@kernel.org>
To: James Clark <james.clark@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>, leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 01/10] arm64: sysreg: Add new PMSFCR_EL1 fields and
 PMSDSFR_EL1 register
Message-ID: <aHUG9bVy9pdwfumh@willie-the-truck>
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
 <20250605-james-perf-feat_spe_eft-v3-1-71b0c9f98093@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605-james-perf-feat_spe_eft-v3-1-71b0c9f98093@linaro.org>

On Thu, Jun 05, 2025 at 11:48:59AM +0100, James Clark wrote:
> Add new fields and register that are introduced for the features
> FEAT_SPE_EFT (extended filtering) and FEAT_SPE_FDS (data source
> filtering).
> 
> Tested-by: Leo Yan <leo.yan@arm.com>
> Signed-off-by: James Clark <james.clark@linaro.org>
> ---
>  arch/arm64/tools/sysreg | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
