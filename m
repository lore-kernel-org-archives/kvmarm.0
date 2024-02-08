Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B3D76C75
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 15:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707405902; cv=none; b=t5gAiLYeoYoAdv5rpKob8GP+KrCRKLhKNuXs1qplROs15/LDWiLD8muHcGbQhot4MZHSdrJmB4yTHP3WdW5frMkM/zhu5kg8koRU1ValraY9HqIh8ZVyLoJVPR5BFH8qLK0H2pZyg3FxScCkTXbUdAhxELnmwEXvOcvZz7gHpEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707405902; c=relaxed/simple;
	bh=c274iW8icLFAu+iCWU65bgilSfjNx5ayoyET5kDuSUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sie4jgZPjuz7ebWX88mT3yWzDTD4+B5ZPLShfc3RtCmPYLy5TXpJ7lGFaP4YaRTOSW7TG188PonzRIqTGrQYxft6tHbSLdBS2vgNiiHT3fLFMN9hHSJmdrUKGnTxWcDXYIdtADUwXLXi0vYjk6vxKI6Fg4wZ6WU80Yl6+PAv91E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=siEs6vKM; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="siEs6vKM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707405898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cqf5ZFja+P1AeG4LwSN65C6FqWDEciQEuXWTei6rZeg=;
	b=siEs6vKMsLfPeHwh9OUTzaD9i+tdM+2Bsf01Vc713uCjyA11gBDI9joAD9PixKbNQGWZ+S
	RZcUDUOzVJK2KotfgJBuBvJrt00eX7ORJn6045KHWO0jD4IydCq3WdvkFotgQkZtSlPfYC
	raWMH23WMaW1fQDQFbSagh1YugWZZEU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Ard Biesheuvel <ardb@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v4 00/10] arm64: Add support for FEAT_E2H0, or lack thereof
Date: Thu,  8 Feb 2024 15:24:40 +0000
Message-ID: <170740573023.1221433.14646653483482850488.b4-ty@linux.dev>
In-Reply-To: <20240122181344.258974-1-maz@kernel.org>
References: <20240122181344.258974-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 22 Jan 2024 18:13:34 +0000, Marc Zyngier wrote:
> Since ARMv8.1, the architecture has grown the VHE feature, which makes
> EL2 a superset of EL1. With ARMv9.5 (and retroactively allowed from
> ARMv8.1), the architecture allows implementations to have VHE as the
> *only* implemented behaviour, meaning that HCR_EL2.E2H can be
> implemented as RES1. As a follow-up, HCR_EL2.NV1 can also be
> implemented as RES0, making the VHE-ness of the architecture
> recursive.
> 
> [...]

Thanks folks for having taken a look at the series. I've pushed it out
to kvmarm/next.

Catalin, as requested here is the shared branch:

  https://git.kernel.org/pub/scm/linux/kernel/git/oupton/linux.git/log/?h=kvm-arm64/feat_e2h0

[01/10] arm64: Add macro to compose a sysreg field value
        https://git.kernel.org/kvmarm/kvmarm/c/53eaeb7fbe27
[02/10] arm64: cpufeatures: Correctly handle signed values
        https://git.kernel.org/kvmarm/kvmarm/c/d9a065914dcc
[03/10] arm64: cpufeature: Correctly display signed override values
        https://git.kernel.org/kvmarm/kvmarm/c/d42bf63fd4db
[04/10] arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
        https://git.kernel.org/kvmarm/kvmarm/c/cfc680bb04c5
[05/10] arm64: cpufeature: Add ID_AA64MMFR4_EL1 handling
        https://git.kernel.org/kvmarm/kvmarm/c/805bb61f8279
[06/10] arm64: cpufeature: Detect HCR_EL2.NV1 being RES0
        https://git.kernel.org/kvmarm/kvmarm/c/da9af5071b25
[07/10] arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is negative
        https://git.kernel.org/kvmarm/kvmarm/c/3944382fa6f2
[08/10] KVM: arm64: Expose ID_AA64MMFR4_EL1 to guests
        https://git.kernel.org/kvmarm/kvmarm/c/c21df6e43f0e
[09/10] KVM: arm64: Force guest's HCR_EL2.E2H RES1 when NV1 is not implemented
        https://git.kernel.org/kvmarm/kvmarm/c/94f29ab2d801
[10/10] KVM: arm64: Handle Apple M2 as not having HCR_EL2.NV1 implemented
        https://git.kernel.org/kvmarm/kvmarm/c/aade38faca63

--
Best,
Oliver
