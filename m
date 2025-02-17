Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6633F15F306
	for <kvmarm@lists.linux.dev>; Mon, 17 Feb 2025 05:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739770983; cv=none; b=aucqgOmA/Rgi+2J638okFkCvhl+N3iDrLCk96Yqe3WZh49wApBu/7+3IH3WJTTmhFBGAzTReGineAQmaWgbwYvm1AzzYaaQvHGhksG1NjNZEUzqODv/Chkhum4QIfgfPnjZFoIXLEhmFK6OpODMQMkCS1oSnuEoDTWYyKe/R7Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739770983; c=relaxed/simple;
	bh=4V6bQvdIaaUAok6mIVbDTxN7w+jyF/McsOuvycXNvVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SXJPhuQjbzjkmb+SQZiOQScJ4CSum/Q1Z5lllbfqDRL8LbHlxZwbRrH1rqdxthNbHZLoG6IiE/SPOU8txEcb8LSrrUIOjl5nfnlRdYihSICma8bXxtZn86QcNfaP+rWLQBfbHa0dQTywxwV+D4nM2Cet1XkFTclL/VZ0FWQEv8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF10E1063;
	Sun, 16 Feb 2025 21:43:18 -0800 (PST)
Received: from [10.162.16.135] (unknown [10.162.16.135])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC8D23F6A8;
	Sun, 16 Feb 2025 21:42:55 -0800 (PST)
Message-ID: <7176be0c-030d-4c2c-9a9d-7b69c2eabe40@arm.com>
Date: Mon, 17 Feb 2025 11:12:53 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/7] arm64/boot: Enable EL2 requirements for
 FEAT_PMUv3p9
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Mark Brown <robh@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Jonathan Corbet <corbet@lwn.net>,
 Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Rob Herring <robh@kernel.org>
References: <20250203050828.1049370-1-anshuman.khandual@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250203050828.1049370-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/3/25 10:38, Anshuman Khandual wrote:
> This series adds fine grained trap control in EL2 required for FEAT_PMUv3p9
> registers like PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1 which are already
> being used in the kernel. This is required to prevent their EL1 access trap
> into EL2.
> 
> PMZR_EL0 register trap control i.e HDFGWTR2_EL2.nPMZR_EL0 remains unchanged
> for now as it does not get accessed in the kernel, and there is no plan for
> its access from user space.
> 
> I have taken the liberty to pick up all the review tags for patches related
> to tools sysreg update from the KVM FGT2 V2 patch series posted earlier.
> 
> https://lore.kernel.org/all/20241210055311.780688-1-anshuman.khandual@arm.com/
> 
> Rob had earler mentioned about FEAT_FGT2 based trap control requirement for
> FEAT_PMUv3p9 registers that are currently being used in kernel. The context
> can be found here.
> 
> https://lore.kernel.org/all/20241216234251.GA629562-robh@kernel.org/
> 
> This series is based on v6.14-rc1
> 
> Changes in V2:
> 
> - Rebased on v6.14-rc1
> - Updated tools sysreg patches with latest DDI0601 2024-12 definitions
> - Updated document version as DDI0601 2024-12 in all commit messages
> - Added latest tags from Rob Herring for the last patch
> 

Hello Catalin/Will/Rob,

I hope this series looks okay. Please do let me know in case anything
needs changing. Thank you.

- Anshuman

> Changes in V1:
> 
> https://lore.kernel.org/all/20241220072240.1003352-1-anshuman.khandual@arm.com/
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Mark Brown <robh@kernel.org>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: kvmarm@lists.linux.dev
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> 
> Anshuman Khandual (7):
>   arm64/sysreg: Update register fields for ID_AA64MMFR0_EL1
>   arm64/sysreg: Add register fields for HDFGRTR2_EL2
>   arm64/sysreg: Add register fields for HDFGWTR2_EL2
>   arm64/sysreg: Add register fields for HFGITR2_EL2
>   arm64/sysreg: Add register fields for HFGRTR2_EL2
>   arm64/sysreg: Add register fields for HFGWTR2_EL2
>   arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
> 
>  Documentation/arch/arm64/booting.rst |  18 +++++
>  arch/arm64/include/asm/el2_setup.h   |  25 +++++++
>  arch/arm64/tools/sysreg              | 103 +++++++++++++++++++++++++++
>  3 files changed, 146 insertions(+)
> 
