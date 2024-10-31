Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80251C32FD
	for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 18:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730400145; cv=none; b=XXVVotOHjvgAX1ZIvT5d9v/qanlJD8HBN1dbehCInNoJ5gZnaUlvSlJOeQZPEFbq2fHhKNv5I9rA0FobXfh6OqCnJZ8sLvMPonNuNnTy3MDQDn8ZR7Re1N6Ostdlfy5wFurtrNWr8/8oK6Abgn1Of2cpdGH0syteZBxZjxInn7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730400145; c=relaxed/simple;
	bh=CuCOeh9arMu9ScfPuwzCEzsBGcFXMocySpFaAS0ZaYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=akTVuMzzqBn2BQucUfr3E5PmV/4OdNJk5LQzQLIitixBeS5glcvZaRGZCEjw244CKr47Q7qzXyZrFG1/C+9ADHKQ1SJKxeTwt0Dg+ydFy8zsW5xLcbDmlek2SKKbZ7hsx1/QIZoTkbU6syLLDK56mrVbQDgNVjnb2UIPtsm+5qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mPYHUB4Q; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mPYHUB4Q"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730400140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o8oZOz6bx3rY3c9b+cY/Dimo4K6xxWzeL+kimqHVrYs=;
	b=mPYHUB4QG89z5DwHS8z8x4qAbIbEIuMfDaU5MtyVYBfjI5VbB5Kqyz858XZGHqDxCr4rFp
	asiGVPDAJutg9hBBd7X0WuXgx8zyy29y94qwjwOdUyM32ZSfxkCurDc6uO1uop9Ic/205N
	wt7R/3PETCOhsSe4IrSUk/0hmcMLVn4=
From: Oliver Upton <oliver.upton@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	james.morse@arm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Jing Zhang <jingzhangos@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	shameerali.kolothum.thodi@huawei.com,
	gshan@redhat.com,
	anshuman.khandual@arm.com
Subject: Re: [PATCH v6 0/7] KVM: arm64: Hide unsupported MPAM from the guest
Date: Thu, 31 Oct 2024 18:42:09 +0000
Message-ID: <173040012144.3070763.12098907901821115896.b4-ty@linux.dev>
In-Reply-To: <20241030160317.2528209-1-joey.gouly@arm.com>
References: <20241030160317.2528209-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 30 Oct 2024 16:03:10 +0000, Joey Gouly wrote:
> changes since v5 [1]:
> 	- Removed Kconfig option, the KVM traps shouldn't rely on host kernel support
> 	- Renamed cpus_support_* to system_supports_* since that matches other functions
> 	- Replace static branch arm64_mpam_has_hcr with a normal cpufeature capability
> 	- Add MPAM*_EL2 regs to KVM (undef_access)
> 	- Use constants in the test, instead of hardcoded values
> 	- Added R-b and T-b tags
> 	- Rebased on v6.12-rc5
> 
> [...]

Applied to kvmarm/next, thanks!

[1/7] arm64/sysreg: Convert existing MPAM sysregs and add the remaining entries
      https://git.kernel.org/kvmarm/kvmarm/c/83732ce6a056
[2/7] arm64: head.S: Initialise MPAM EL2 registers and disable traps
      https://git.kernel.org/kvmarm/kvmarm/c/23b33d1e168c
[3/7] arm64: cpufeature: discover CPU support for MPAM
      https://git.kernel.org/kvmarm/kvmarm/c/09e6b306f3ba
[4/7] KVM: arm64: Fix missing traps of guest accesses to the MPAM registers
      https://git.kernel.org/kvmarm/kvmarm/c/31ff96c38ea3
[5/7] KVM: arm64: Add a macro for creating filtered sys_reg_descs entries
      https://git.kernel.org/kvmarm/kvmarm/c/7da540e29dea
[6/7] KVM: arm64: Disable MPAM visibility by default and ignore VMM writes
      https://git.kernel.org/kvmarm/kvmarm/c/6685f5d572c2
[7/7] KVM: arm64: selftests: Test ID_AA64PFR0.MPAM isn't completely ignored
      https://git.kernel.org/kvmarm/kvmarm/c/75cd027cbcb1

--
Best,
Oliver
