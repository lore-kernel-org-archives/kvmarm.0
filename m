Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FECA2BB15
	for <kvmarm@lists.linux.dev>; Mon, 21 Oct 2024 04:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729483774; cv=none; b=Cbn7jgm2KY9x4lG23kGsOgUgAX78adt48WhnML89UMjsDoVVbyzFqS+s0NodPWZnahUgvbCS43Aa3le3jR3hNNLofJ5XHfeeQ2NdCIVY166tg5BqFFiETJ4ulER1MEWnKA5+l2WneRlU89jGfcHJRzLbJSPcH4qxmWFdFMIER7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729483774; c=relaxed/simple;
	bh=VXRz3P41kYuI7xSCGibxd7bMyoaHrq0zIRlGRVu8W6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q2x5AxMNLWmia8BB2TXmFvDrgR77V+l8lWpNOIS+oEZ319wMu0Lsf0fd6PPa9yMRDSvHTLs2u4+APgeYHTz1Sdq4dpkFseEWXLTfH2lxF19GEMlkZNKTiwwpwMZVx+NYEWtTrhtl2xRrH048XAX7/0jWed9k39faiz0Op4j/1us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25495DA7;
	Sun, 20 Oct 2024 21:10:01 -0700 (PDT)
Received: from [10.162.16.109] (a077893.blr.arm.com [10.162.16.109])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FAE13F73B;
	Sun, 20 Oct 2024 21:09:28 -0700 (PDT)
Message-ID: <3f1eb97e-0fa6-47d9-96d6-9fedabd969f7@arm.com>
Date: Mon, 21 Oct 2024 09:39:25 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] arm64/hw_breakpoint: Enable FEAT_Debugv8p9
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 kvmarm@lists.linux.dev
References: <20241001043602.1116991-1-anshuman.khandual@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20241001043602.1116991-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/1/24 10:05, Anshuman Khandual wrote:
> This series enables FEAT_Debugv8p9 thus extending breakpoint and watchpoint
> support upto 64. This series is based on v6.12-rc1 after applying the KVM
> FEAT_FGT2 FGU series.
> 
> https://lore.kernel.org/all/20241001024356.1096072-1-anshuman.khandual@arm.com/
> 
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: James Morse <james.morse@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.linux.dev
> Cc: linux-kernel@vger.kernel.org
> 
> Changes in V1:
> 
> - Changed FTR_STRICT to FTR_NONSTRICT for the following ID_AA64DFR1_EL1
>   register fields - ABL_CMPs, DPFZS, PMICNTR, CTX_CMPs, WRPs and BRPs
> 
> Changes in RFC V2:
> 
> https://lore.kernel.org/linux-arm-kernel/20240620092607.267132-1-anshuman.khandual@arm.com/
> 
> - This series has been split from RFC V1 dealing only with arm64 breakpoints
> - Restored back DBG_MDSCR_MASK definition (unrelated change)
> - Added preempt_disable()/enable() blocks between selecting banks and registers
> 
> Changes in RFC:
> 
> https://lore.kernel.org/all/20240405080008.1225223-1-anshuman.khandual@arm.com/
> 
> Anshuman Khandual (3):
>   arm64/cpufeature: Add field details for ID_AA64DFR1_EL1 register
>   arm64/boot: Enable EL2 requirements for FEAT_Debugv8p9
>   arm64/hw_breakpoint: Enable FEAT_Debugv8p9
> 
>  Documentation/arch/arm64/booting.rst    | 19 ++++++++++
>  arch/arm64/include/asm/debug-monitors.h |  1 +
>  arch/arm64/include/asm/el2_setup.h      | 27 +++++++++++++
>  arch/arm64/include/asm/hw_breakpoint.h  | 50 ++++++++++++++++++++-----
>  arch/arm64/include/asm/kvm_arm.h        |  1 +
>  arch/arm64/kernel/cpufeature.c          | 21 ++++++++---
>  arch/arm64/kernel/debug-monitors.c      | 16 ++++++--
>  arch/arm64/kernel/hw_breakpoint.c       | 33 ++++++++++++++++
>  8 files changed, 149 insertions(+), 19 deletions(-)
> 

Hello,

Gentle ping ! Any updates on this series ? Although I realize that this series is
dependent on the other FEAT_FGT2 series [1] for MDSELR_EL1 access handling in KVM
and sysreg definitions, but just wondering if proposed breakpoint and watchpoint
changes are okay or something needs to be changed. Thank you.

[1] https://lore.kernel.org/all/20241001024356.1096072-1-anshuman.khandual@arm.com/

- Anshuman
