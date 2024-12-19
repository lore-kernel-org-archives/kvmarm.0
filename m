Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BBA1A2554
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 19:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637655; cv=none; b=IRLn4WVcUvWoyK6kRxqI842KblNcyCc8Zdl/Rf7UmWDhwEegY7XcEhonGdcz1uqJOiD1kn8qNB4tCEqQHi/MK1dr/08dOgj/sbF6s3sUUrNJLJsPBm8A+Q5E878c/KDp9iNygpUIuQGCeX58Esn6/KuoQqLJX90YNxjxK/ujfNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637655; c=relaxed/simple;
	bh=QbIWuvJkAjzgbFMcr9LS5gY4MBhrgadLFDQpbMSDlJA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RfJiVgpxZzjDZuTv11uEyrxADNi8ZlqHaL9fV0Acg7Dt/JbUvAzQng/U/bLLsvcBgJsq8ATXJVbX4pt/5s+W/pZWE1QO4LKz7ep2Lb1vFjzrFBAq2+AqMx2EfzI+owgUY6sEqIpSERI2x7Gi8+HwA9qStNI5zPIJtZvW8sM0pz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kMh46afr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kMh46afr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1147BC4CEDE;
	Thu, 19 Dec 2024 19:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637653;
	bh=QbIWuvJkAjzgbFMcr9LS5gY4MBhrgadLFDQpbMSDlJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMh46afrmOIPlqKaPuxWgIuJLr/KMyVYbEyEk22rtJUd6L7bNOw2tZ3KGkv6fHRcJ
	 z9JR7DoL8DkTpJycGiiuzZ01MJIrnVj62TojqwQye3pvbMN1rzh6UkjmcUiPjvs0Bs
	 30E3ZW9zCz2oBw6SQSNTv7S6XbAQvAM8tUp8mompxDKvDSQRALM5O+dCCi25BLUIno
	 B4++JibIJ+s0srbfC9et6zIyckzONouw/pYLevA7AkUeIHjrCxrX2wfowmib90NMyU
	 YBhrNKccQbL6XvKaZkqe1TzIhcltHNDPAW3fxxE+SeuWDMTb+5lRe2UJe+TbYfrCiA
	 H3Ps8h92FBW4A==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 0/4] arm64/sysreg: Get rid of *_ELx as fields for EL12 accessors
Date: Thu, 19 Dec 2024 19:47:10 +0000
Message-Id: <173463125944.3934348.13870436616394837034.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20241219173351.1123087-1-maz@kernel.org>
References: <20241219173351.1123087-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 19 Dec 2024 17:33:46 +0000, Marc Zyngier wrote:
> We keep adding *_ELx definition to the sysreg as an abstraction for
> the mapping between an EL1 register and its EL12 counterpart.
> 
> But nothing in the architecture has these ELx suffixes to describe
> such abstraction. When they are mentioned, it always is as a shortcut
> for EL1, EL2 or EL3, and never for EL12. That's because *_EL12 are
> *not* registers. They are accessors, nothing else. So what we
> currently have is not only bizarre, it is actively wrong.
> 
> [...]

Applied to arm64 (for-next/cpufeature), thanks!

[1/4] arm64/sysreg: Allow a 'Mapping' descriptor for system registers
      https://git.kernel.org/arm64/c/078bc96539c3
[2/4] arm64/sysreg: Get rid of the TCR2_EL1x SysregFields
      https://git.kernel.org/arm64/c/7052e808c446
[3/4] arm64/sysreg: Convert *_EL12 accessors to Mapping
      https://git.kernel.org/arm64/c/233fc36bb5a2
[4/4] arm64/sysreg: Get rid of CPACR_ELx SysregFields
      https://git.kernel.org/arm64/c/e5ecedcd7cc2

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
