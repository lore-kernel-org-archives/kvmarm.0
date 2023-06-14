Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6627079E1
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 11:54:14 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B55031FB;
	Wed, 14 Jun 2023 04:54:57 -0700 (PDT)
Received: from [10.57.25.82] (unknown [10.57.25.82])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3300E3F71E;
	Wed, 14 Jun 2023 04:54:11 -0700 (PDT)
Message-ID: <2874efc6-a022-c97e-7e38-ccf8b4b5938d@arm.com>
Date: Wed, 14 Jun 2023 13:54:09 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.1
Subject: Re: [PATCH V3 00/14] arm64/sysreg: Convert TRBE registers to
 automatic generation
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, broonie@kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Rob Herring <robh@kernel.org>,
 James Morse <james.morse@arm.com>, kvmarm@lists.linux.dev,
 coresight@lists.linaro.org, linux-kernel@vger.kernel.org
References: <20230614065949.146187-1-anshuman.khandual@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20230614065949.146187-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/06/2023 07:59, Anshuman Khandual wrote:
> This series converts TRBE registers to automatic generation, after renaming
> their fields as per the auto-gen tools format. Although the following field
> still renames in arch/arm64/include/asm/sysreg.h, as it cannot be converted
> (shares bits with other fields) in the tools format.
> 
> #define TRBSR_EL1_BSC_MASK		GENMASK(5, 0)
> #define TRBSR_EL1_BSC_SHIFT		0
> 
> This series applies on v6.4-rc6.
> 
> Changes in V3:
> 
> - Defined enum for both PAS and SH fields in TRBMAR_EL1
> - Defined enum for EA field in TRBIDR_EL1
> 
> Changes in V2:
> 
> https://lore.kernel.org/all/20230602062552.565992-1-anshuman.khandual@arm.com/
> 
> - Renamed each individual TRBE register fields as per auto-gen tools
> - Converted each individual TRBE registers as per auto-gen tools
> - Added new register fields as per DDI0601 2023-03
> 
> Changes in V1:
> 
> https://lore.kernel.org/all/20230531055524.16562-1-anshuman.khandual@arm.com/
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: kvmarm@lists.linux.dev
> Cc: coresight@lists.linaro.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> 
> Anshuman Khandual (14):
>    arm64/sysreg: Rename TRBLIMITR_EL1 fields per auto-gen tools format
>    arm64/sysreg: Rename TRBPTR_EL1 fields per auto-gen tools format
>    arm64/sysreg: Rename TRBBASER_EL1 fields per auto-gen tools format
>    arm64/sysreg: Rename TRBSR_EL1 fields per auto-gen tools format
>    arm64/sysreg: Rename TRBMAR_EL1 fields per auto-gen tools format
>    arm64/sysreg: Rename TRBTRG_EL1 fields per auto-gen tools format
>    arm64/sysreg: Rename TRBIDR_EL1 fields per auto-gen tools format
>    arm64/sysreg: Convert TRBLIMITR_EL1 register to automatic generation
>    arm64/sysreg: Convert TRBPTR_EL1 register to automatic generation
>    arm64/sysreg: Convert TRBBASER_EL1 register to automatic generation
>    arm64/sysreg: Convert TRBSR_EL1 register to automatic generation
>    arm64/sysreg: Convert TRBMAR_EL1 register to automatic generation
>    arm64/sysreg: Convert TRBTRG_EL1 register to automatic generation
>    arm64/sysreg: Convert TRBIDR_EL1 register to automatic generation
> 
>   arch/arm64/include/asm/el2_setup.h           |  2 +-
>   arch/arm64/include/asm/sysreg.h              | 50 +------------
>   arch/arm64/kvm/debug.c                       |  2 +-
>   arch/arm64/kvm/hyp/nvhe/debug-sr.c           |  2 +-
>   arch/arm64/tools/sysreg                      | 77 ++++++++++++++++++++
>   drivers/hwtracing/coresight/coresight-trbe.c | 33 +++++----
>   drivers/hwtracing/coresight/coresight-trbe.h | 38 ++++------
>   7 files changed, 114 insertions(+), 90 deletions(-)
> 


For the coresight-trbe.* bits:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

