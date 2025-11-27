Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B9FA23EAB6
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 19:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764270983; cv=none; b=XjUfXt1opH/rlWFxePeoHyYF83ruJU1m88wNsnp8/JU9YpjRIoCAslJaPAaMHH4zeatknyg0PsFh1c6A4IWcQymutrM3UziuW2awaZqM+zV+OSfYVSYAtIbBcJ6B117S6UIG6ffJXZEw8APxbxwV6MCX8N5fuXfMBUUUiKRbQTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764270983; c=relaxed/simple;
	bh=k7VXPzSZVf1M/FYNsbVM5voQcU2yMODHM0qz1I4OCSI=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ibIdmF7N8I1pooXT3KQ6vjgU773G780q4uJhoFQj71lQ6joQ1XTRZgPsEOiblJ6eyZEZcBEMoRLqfRGsRPASI7QU5cJGuc3Vf+GzVzttCZgstEEXak5+eRucnq8eIC+oJfT+WW/ObFR3uFvaJSqk3jVq6m0ibFP5X9H8FnLNc5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 153E2176A;
	Thu, 27 Nov 2025 11:16:14 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F12D3F66E;
	Thu, 27 Nov 2025 11:16:20 -0800 (PST)
Date: Thu, 27 Nov 2025 19:16:17 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: will@kernel.org, maz@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	shuah@kernel.org, Oliver Upton <oupton@kernel.org>,
	Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v2 0/2] set_id_regs cleanup
Message-ID: <176427094645.1018621.6342347190473898593.b4-ty@arm.com>
References: <20251125101207.1492580-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125101207.1492580-1-ben.horgan@arm.com>

On Tue, 25 Nov 2025 10:12:05 +0000, Ben Horgan wrote:
> For this v2 I've dropped the ksft_test accounting fix. Mark Brown has
> more extensive changes [1] and looks to be a user of the set_id_regs
> test rather than someone just doing some cleanup. The other change in
> this series is to remove ARM64_FEATURE_FIELD_BITS from the tools
> sysreg.h header rather than the kernel version. I'll send a separate
> patch to remove the kernel version.
> 
> [...]

Applied to arm64 (for-next/sysreg), thanks!

[1/2] KVM: arm64: selftests: Remove ARM64_FEATURE_FIELD_BITS and its last user
      https://git.kernel.org/arm64/c/bf09ee918053
[2/2] KVM: arm64: selftests: Consider all 7 possible levels of cache
      https://git.kernel.org/arm64/c/4138cc63d3ef

-- 
Catalin
