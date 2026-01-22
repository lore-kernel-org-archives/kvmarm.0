Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F203A3CBD
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 17:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769101212; cv=none; b=DMgVeT6fVc8IS7f7dI2IP/2ewLCKpebmXkuSv5mLDtFjqU1stwGjvMWWpZ20Uj8H7ngso+cZRAcjFIVXu14U3a2q4KWrdG8RhWBuDbxXZICacd8JC48AMYdtmhFD//vt/I/ZvguumpLE6wW22QmzE1GXO8g/DTzRVcy4srY1Z3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769101212; c=relaxed/simple;
	bh=V4PTp6AWZI5MWQxX8DtA8YX5B5nuTx9/oXx6sLHPHns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LOkJFHIMR4BGIRukFnQo1I3YCr121FfkFSZkyyTksIhLOv7uK7AwB+nFfUNJ4K6x7eanRVX5zJntbiLK6qT+p8hrlG9wb9xIsy6uETecjtqSv3yFqp+rVLYSu3UYpmcaFHXxQayDHLXDDpVoFPKH0UMAk9pTrPdSkOz7g0UnLz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sll4VSfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sll4VSfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C151C116C6;
	Thu, 22 Jan 2026 17:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769101211;
	bh=V4PTp6AWZI5MWQxX8DtA8YX5B5nuTx9/oXx6sLHPHns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sll4VSfPLggvYsQbc3VOhucDxRupzWN1AuuHZ54KrRTjWY9lINoovHVXg7KRwOqCk
	 r6WlpQn5X1ma2kC4jq5sqLD3uD7Rj4Ri7VrdV2k24Un8X/XFxzblxPIWlHEmFpq8Zv
	 hu6pu2xR7q1aP7xVNQuLYSEQVVTZg5jdd+bIHSaj5Tw0YHuxCZScdzUDn9gKrU4nxj
	 UiGiDk4X5WV3yCNam86OrMAsRIMZegnv3MLJJ7ZonSSZkHpIZgqjR9gqwLKMV0ByzO
	 zU9P7UIm7SslBOKhALIOCekPuVHiT7xn6rPnAxGQf0l30MJzM8KN8HT4OqpWpkKtm0
	 7zDhOUAE+cguQ==
From: Will Deacon <will@kernel.org>
To: catalin.marinas@arm.com,
	maz@kernel.org,
	arnd@arndb.de,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	Oliver Upton <oupton@kernel.org>,
	Zhou Wang <wangzhou1@hisilicon.com>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	yangyccccc@gmail.com,
	prime.zeng@hisilicon.com,
	xuwei5@huawei.com
Subject: Re: [PATCH v8 RESEND 0/7] Add support for FEAT_{LS64, LS64_V} and related tests
Date: Thu, 22 Jan 2026 16:59:45 +0000
Message-ID: <176908829115.2153926.13840796658975178943.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119022928.149358-1-wangzhou1@hisilicon.com>
References: <20260119022928.149358-1-wangzhou1@hisilicon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 19 Jan 2026 10:29:21 +0800, Zhou Wang wrote:
> Armv8.7 introduces single-copy atomic 64-byte loads and stores
> instructions and its variants named under FEAT_{LS64, LS64_V}.
> Add support for Armv8.7 FEAT_{LS64, LS64_V}:
> - Add identifying and enabling in the cpufeature list
> - Expose the support of FEAT_LS64 to userspace through HWCAP3 and cpuinfo
> - Add related hwcap test
> - Handle the trap of unsupported memory (normal/uncacheable) access in a VM
> 
> [...]

Applied first six to arm64 (for-next/cpufeature), thanks!

[1/7] KVM: arm64: Add exit to userspace on {LD,ST}64B* outside of memslots
      https://git.kernel.org/arm64/c/f174a9ffcd48
[2/7] KVM: arm64: Add documentation for KVM_EXIT_ARM_LDST64B
      https://git.kernel.org/arm64/c/902eebac8fa3
[3/7] KVM: arm64: Handle DABT caused by LS64* instructions on unsupported memory
      https://git.kernel.org/arm64/c/2937aeec9dc5
[4/7] arm64: Provide basic EL2 setup for FEAT_{LS64, LS64_V} usage at EL0/1
      https://git.kernel.org/arm64/c/dea58da4b6fe
[5/7] KVM: arm64: Enable FEAT_{LS64, LS64_V} in the supported guest
      https://git.kernel.org/arm64/c/151b92c92a45
[6/7] arm64: Add support for FEAT_{LS64, LS64_V}
      https://git.kernel.org/arm64/c/58ce78667a64

and the selftest to (for-next/selftests):

[7/7] kselftest/arm64: Add HWCAP test for FEAT_LS64
      https://git.kernel.org/arm64/c/57a96356bb69

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
