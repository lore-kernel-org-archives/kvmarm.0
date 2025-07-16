Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DF82F4A1E
	for <kvmarm@lists.linux.dev>; Wed, 16 Jul 2025 16:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752684500; cv=none; b=VaW3L8igsRCjcWGDpkqqKE43yWaUB2KezcM0vWdXVHrY2F0pOFEI1SIC4PqLPIT/RlGS1oKcNn7GlBUvmCNETJtpbCBaE9okWY/gNNwlAlp/vUJnO2aZ+O2UNNbwgA9vh1qodpnEkx30oviEKK/nwSfPiNDVJKomiEWHsSqdmJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752684500; c=relaxed/simple;
	bh=XCVfG6ZkyVEDKGlKSVWf2BHFHJKjwS7JtldMWSV4aFE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aMJd80RDKpwEgwP1uGlPkZjBCDz+o48O6w0IG8T5oXp+JG4caQ5EuYYKNSWAOTk6pk0cAQwGJDlWzW3BMDuS0qNuxADQZ1LamtQ2VQd43BRR1JvCn1/YFspbS23PA/Us74dcmMg6cBiaKvSD5DsgxkOImqBNRp+V2AfPc8WTHBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XdKcKA4x; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XdKcKA4x"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752684491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PwYPcyN5ffSu6lALOEsqaBZ3FmFPW1VuXsd8RNbGzSg=;
	b=XdKcKA4xgGAt3A6fo5ngf0BR2gFrXXau0lYlMPXtXv9fYNMeizRPx3BtirSZpS3Fzgynj7
	94v5kU/L4aZtL1RqBkHuVCRMQfi+xtp5en5lP2iI/fY8rneDjz1X5UlO8r7p6GHre0GYWb
	eXt/1pnHJ1oMb5UESn8dFTRn4WUa3So=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 00/11] KVM: arm64: nv: Userspace register visibility fixes
Date: Wed, 16 Jul 2025 09:47:53 -0700
Message-Id: <175268446557.2457435.15867128559478190522.b4-ty@linux.dev>
In-Reply-To: <20250714122634.3334816-1-maz@kernel.org>
References: <20250714122634.3334816-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 14 Jul 2025 13:26:23 +0100, Marc Zyngier wrote:
> Peter recently pointed out that we don't expose the EL2 GICv3
> registers in a consistent manner, as they are presented through the
> ONE_REG interface instead of KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS, despite
> the latter already exposing the EL1 GICv3 regs.
> 
> While I was looking at this, I ended up finding a small number of
> equally small problems:
> 
> [...]

Applied to next, thanks!

[01/11] KVM: arm64: Make RVBAR_EL2 accesses UNDEF
        https://git.kernel.org/kvmarm/kvmarm/c/1095b32665cf
[02/11] KVM: arm64: Don't advertise ICH_*_EL2 registers through GET_ONE_REG
        https://git.kernel.org/kvmarm/kvmarm/c/c70a4027f5f3
[03/11] KVM: arm64: Define constant value for ICC_SRE_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/c6ef46861080
[04/11] KVM: arm64: Define helper for ICH_VTR_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/ce7a1cff2e4c
[05/11] KVM: arm64: Let GICv3 save/restore honor visibility attribute
        https://git.kernel.org/kvmarm/kvmarm/c/1d14c9714562
[06/11] KVM: arm64: Expose GICv3 EL2 registers via KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS
        https://git.kernel.org/kvmarm/kvmarm/c/9fe9663e47e2
[07/11] KVM: arm64: Condition FGT registers on feature availability
        https://git.kernel.org/kvmarm/kvmarm/c/72c62700b279
[08/11] KVM: arm64: Advertise FGT2 registers to userspace
        https://git.kernel.org/kvmarm/kvmarm/c/a0aae0a9a70e
[09/11] KVM: arm64: selftests: get-reg-list: Simplify feature dependency
        https://git.kernel.org/kvmarm/kvmarm/c/9a4071807909
[10/11] KVM: arm64: selftests: get-reg-list: Add base EL2 registers
        https://git.kernel.org/kvmarm/kvmarm/c/3a90b6f27964
[11/11] KVM: arm64: Document registers exposed via KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS
        https://git.kernel.org/kvmarm/kvmarm/c/f68df3aee7d1

--
Best,
Oliver
