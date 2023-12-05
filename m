Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC6654689
	for <kvmarm@lists.linux.dev>; Tue,  5 Dec 2023 02:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 87EDA1474;
	Mon,  4 Dec 2023 18:05:22 -0800 (PST)
Received: from [10.163.35.139] (unknown [10.163.35.139])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 155843F5A1;
	Mon,  4 Dec 2023 18:04:31 -0800 (PST)
Message-ID: <2dfb07f4-39c3-4cfe-81ba-416c18f99b10@arm.com>
Date: Tue, 5 Dec 2023 07:34:28 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] arm64: Rename reserved values for CTR_EL0.L1Ip
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231204143606.1806432-1-maz@kernel.org>
 <20231204143606.1806432-4-maz@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20231204143606.1806432-4-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/4/23 20:06, Marc Zyngier wrote:
> We now have *two* values for CTR_EL0.L1Ip that are reserved.
> Which makes things a bit awkward. In order to lift the ambiguity,
> rename RESERVED (0b01) to RESERVED_AIVIVT, and VPIPT (0b00) to
> RESERVED_VPIPT.
> 
> This makes it clear which of these meant what, and I'm sure
> archeologists will find it useful...
> 
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/tools/sysreg | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 96cbeeab4eec..c5af75b23187 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2004,9 +2004,10 @@ Field	27:24	CWG
>  Field	23:20	ERG
>  Field	19:16	DminLine
>  Enum	15:14	L1Ip
> -	0b00	VPIPT
> +	# This was named as VPIPT in the ARM but now documented as reserved
> +	0b00	RESERVED_VPIPT
>  	# This is named as AIVIVT in the ARM but documented as reserved
> -	0b01	RESERVED
> +	0b01	RESERVED_AIVIVT
>  	0b10	VIPT
>  	0b11	PIPT
>  EndEnum
