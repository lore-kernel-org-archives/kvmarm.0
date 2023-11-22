Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA1E21CA9A
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 09:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD2361595;
	Wed, 22 Nov 2023 01:16:46 -0800 (PST)
Received: from [10.57.42.32] (unknown [10.57.42.32])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A2F3F3F73F;
	Wed, 22 Nov 2023 01:15:58 -0800 (PST)
Message-ID: <9abe4191-dc58-4e8a-9242-ac8520febbe8@arm.com>
Date: Wed, 22 Nov 2023 09:15:57 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/13] arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231120123721.851738-1-maz@kernel.org>
 <20231120123721.851738-5-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20231120123721.851738-5-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/11/2023 12:37, Marc Zyngier wrote:
> ARMv9.5 has infroduced ID_AA64MMFR4_EL1 with a bunch of new features.
> Add the corresponding layout.
> 
> This is extracted from the public ARM SysReg_xml_A_profile-2023-09
> delivery, timestamped d55f5af8e09052abe92a02adf820deea2eaed717.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Matches the definitions.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

> ---
>   arch/arm64/tools/sysreg | 37 +++++++++++++++++++++++++++++++++++++
>   1 file changed, 37 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 96cbeeab4eec..7fb3a4928256 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -1675,6 +1675,43 @@ UnsignedEnum	3:0	TCRX
>   EndEnum
>   EndSysreg
>   
> +Sysreg	ID_AA64MMFR4_EL1	3	0	0	7	4
> +Res0	63:40
> +UnsignedEnum	39:36	E3DSE
> +	0b0000	NI
> +	0b0001	IMP
> +EndEnum
> +Res0	35:28
> +SignedEnum	27:24	E2H0
> +	0b0000	IMP
> +	0b1110	NI_NV1
> +	0b1111	NI
> +EndEnum
> +UnsignedEnum	23:20	NV_frac
> +	0b0000	NV_NV2
> +	0b0001	NV2_ONLY
> +EndEnum
> +UnsignedEnum	19:16	FGWTE3
> +	0b0000	NI
> +	0b0001	IMP
> +EndEnum
> +UnsignedEnum	15:12	HACDBS
> +	0b0000	NI
> +	0b0001	IMP
> +EndEnum
> +UnsignedEnum	11:8	ASID2
> +	0b0000	NI
> +	0b0001	IMP
> +EndEnum
> +SignedEnum	7:4	EIESB
> +	0b0000	NI
> +	0b0001	ToEL3
> +	0b0010	ToELx
> +	0b1111	ANY
> +EndEnum
> +Res0	3:0
> +EndSysreg
> +
>   Sysreg	SCTLR_EL1	3	0	1	0	0
>   Field	63	TIDCP
>   Field	62	SPINTMASK

