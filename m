Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB89544C6A
	for <kvmarm@lists.linux.dev>; Sun, 17 Dec 2023 13:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XahMe1+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D777C433C8;
	Sun, 17 Dec 2023 13:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702820481;
	bh=0lfQ3EiUeF6DD3d5AbtOSGJqbB3vB3wWpoUTvknzNLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XahMe1+kjkFBeDhI5MBUrgJsncCvLX64JH4tABrA3okfF7Bff2KMzxbB8usmGpjNj
	 ezlwVjJYnJRAK9UaW+eWuMPHqbD1GrSoqpZ0AxWaKXFkyEX4sqgtdjE3YwWiO9+zXV
	 8kxCI7FIhHKQi/biuIKZbct3bu+afw7tm1hLLtvWQH7knGQr3bZjd16GSdoGQMA0CX
	 pHChcHIQ5PxeRdTVIqkZoVZ3xEe2ZYdGDtpy7JMeKSMlZMr3kLHHOGPYu3QG8NSQSu
	 pD7XrS+InS0JZF/QAntqofSa/Niu8rPcbg8u3p1GLJIigaO7GNU5ASMcxDok4Rutiu
	 +O7Lkc54s0iAw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev,
	Fuad Tabba <tabba@google.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	james.morse@arm.com,
	yuzenghui@huawei.com,
	eric.auger@redhat.com,
	linux-arm-kernel@lists.infradead.org,
	joey.gouly@arm.com,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	jingzhangos@google.com,
	maz@kernel.org
Subject: Re: [PATCH v3 00/17] KVM: arm64: Fixes to fine grain traps and pKVM traps
Date: Sun, 17 Dec 2023 13:41:07 +0000
Message-Id: <170281508473.360576.14128850250144458309.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
References: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 14 Dec 2023 10:01:40 +0000, Fuad Tabba wrote:
> Changes from v2:
> - Rebased on arm64/for-next/sysregs, which includes new system
>   register definitions (Mark, Joey)
> - Explicitly trap unsupported HFGxTR_EL2 features rather than
>   relying on its nMASK (Joey)
> - Add new system registers to the auto-generated sysreg rather
>   than hardcoding them (Mark)
> - Drop patch that was meant as RFC
> - Added missing system registers, fields, and  system
>   instructions
> - Split patches that make system register changes
> - Fixes to patches defining allowed features for protected VMs
> - Other minor fixes and tidying up
> 
> [...]

Applied the first four sysreg patches to arm64 (for-next/sysregs), thanks!

[01/17] arm64/sysreg: Add missing Pauth_LR field definitions to ID_AA64ISAR1_EL1
        https://git.kernel.org/arm64/c/3b077ad8cb25
[02/17] arm64/sysreg: Add missing ExtTrcBuff field definition to ID_AA64DFR0_EL1
        https://git.kernel.org/arm64/c/4f101cdcb578
[03/17] arm64/sysreg: Add missing system register definitions for FGT
        https://git.kernel.org/arm64/c/885c6d8e2885
[04/17] arm64/sysreg: Add missing system instruction definitions for FGT
        https://git.kernel.org/arm64/c/4ebee8cebdf6

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
