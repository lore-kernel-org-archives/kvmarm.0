Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E63AE1AA7A3
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 16:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733849980; cv=none; b=pgVkYU0YWqYqSJjm9z0GMB+dIhlurifrbtzWdFblqYu1N9zriIPZP+09WoOmkZ83rWEsj/GG/W5cE3OSLwSsHMG4efpA7YnWvTCeNJXlwQNDU0mOf9KymNpoGlWMK2OgQWuDWOKbbrNeDZNEWzlLr3ymVzpmfs/QulE6/wEIlH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733849980; c=relaxed/simple;
	bh=v8VFFauY4UUj8bMdnT6P92/QHjCCOWTTYyTqEY7zmFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jybalYn35bElb6dScBqQTko2j71gbpM0FVF7+OxLYB55SIHmCiFBz+UvXKXC7KRjYFE7qEHR05Aq8/uaiqUnv18quen8cPfb4AD6OiWGU7CZ64dAyBlCTNXZPN3zo5HSqz27j7xuxt+REEVAFMcLpuElVu6oBiZdKj+9JJOifBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C7281007;
	Tue, 10 Dec 2024 09:00:05 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E3E63F58B;
	Tue, 10 Dec 2024 08:59:35 -0800 (PST)
Date: Tue, 10 Dec 2024 16:59:32 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH V2 0/7] arm64/hw_breakpoint: Enable FEAT_Debugv8p9
Message-ID: <Z1hzdLQLlIPg7eV5@J2N7QTR9R3>
References: <20241028053426.2486633-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028053426.2486633-1-anshuman.khandual@arm.com>

On Mon, Oct 28, 2024 at 11:04:19AM +0530, Anshuman Khandual wrote:
> This series enables FEAT_Debugv8p9 thus extending breakpoint and watchpoint
> support upto 64. This series is based on v6.12-rc5 although this depends on
> FEAT_FGT2 FGU series posted earlier, for MDSELR_EL1 handling in various KVM
> guest configurations.
> 
> https://lore.kernel.org/all/20241001024356.1096072-1-anshuman.khandual@arm.com/

To avoid further confusion: since we discussed things further on the v1
thread after this v2 thread was posted, I'm waiting for a v3 to be
posted which addresses the comments there (e.g. ID reg field handling,
mutual exclusion for breakpoint manipulation).

Mark.

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
> Changes in V2:
> 
> Following changes have been made per review comments from Mark Rutland
> 
> - Orr MDCR_EL2_EBWE directly without an intermittent register
> - Alphabetically order header files in debug-monitors.c
> - Dropped embwe_ref_count mechanism
> - Dropped preempt_enable() from AARCH64_DBG_READ
> - Dropped preempt_disable() from AARCH64_DBG_WRITE
> - Dropped set_bank_index()
> - Renamed read/write_wb_reg() as __read/__write_wb_reg()
> - Modified read/write_wb_reg() to have MDSELR_E1 based banked read/write
> - Added required sysreg tools patches from KVM FEAT_FGT2 series for build
> 
> Changes in V1:
> 
> https://lore.kernel.org/all/20241001043602.1116991-1-anshuman.khandual@arm.com/
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
> Anshuman Khandual (7):
>   arm64/sysreg: Update register fields for ID_AA64MMFR0_EL1
>   arm64/sysreg: Add register fields for MDSELR_EL1
>   arm64/sysreg: Add register fields for HDFGRTR2_EL2
>   arm64/sysreg: Add register fields for HDFGWTR2_EL2
>   arm64/cpufeature: Add field details for ID_AA64DFR1_EL1 register
>   arm64/boot: Enable EL2 requirements for FEAT_Debugv8p9
>   arm64/hw_breakpoint: Enable FEAT_Debugv8p9
> 
>  Documentation/arch/arm64/booting.rst    | 19 +++++++
>  arch/arm64/include/asm/debug-monitors.h |  1 +
>  arch/arm64/include/asm/el2_setup.h      | 26 +++++++++
>  arch/arm64/include/asm/hw_breakpoint.h  | 46 ++++++++++++----
>  arch/arm64/include/asm/kvm_arm.h        |  1 +
>  arch/arm64/kernel/cpufeature.c          | 21 ++++++--
>  arch/arm64/kernel/debug-monitors.c      | 15 ++++--
>  arch/arm64/kernel/hw_breakpoint.c       | 38 +++++++++++++-
>  arch/arm64/tools/sysreg                 | 70 +++++++++++++++++++++++++
>  9 files changed, 216 insertions(+), 21 deletions(-)
> 
> -- 
> 2.25.1
> 
