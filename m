Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C52CA21765B
	for <kvmarm@lists.linux.dev>; Mon, 18 Aug 2025 09:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755508647; cv=none; b=TIA26BwdW+lPapk7JAujAgiUBo5dHf3iwqkYR3OM2g2ClgiDFNrrr//3kBzPY35OmTgkaBmeT/pG1RYSRrU45w/V3v3OvLcR/7KXHB7kPgXBbljy7xtMJZAhkHj3NiSXY70vGFwDcV+m18i3MCpedHkShzLxlkRBbmPG8Cw6Hvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755508647; c=relaxed/simple;
	bh=PmpVfxf9inMP37NkMBjiCc3EF2wQn7mnDy/mD1xkvGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iw8UGvG1xTPl3HQ2PiOZAJXvSt6zYiFmhphuG/lKgsHtLSKkcJDTrfjEU19Qqoo/35rKvYHB5NhCOGbx7FFs4t6HTPsPLSIxidAZ7evI9H4GMES3PbJzdNINyuphIZRUobPs5RYvR0O7gahqoTtCfzlNLVMNALJ9LqaVE1eqnbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0BA63150C;
	Mon, 18 Aug 2025 02:17:17 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 42C723F58B;
	Mon, 18 Aug 2025 02:17:20 -0700 (PDT)
Date: Mon, 18 Aug 2025 10:17:15 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] arm64/sysreg: Add TCR_EL2 register
Message-ID: <aKLvm2_bNtxcs8Dz@J2N7QTR9R3>
References: <20250818045759.672408-1-anshuman.khandual@arm.com>
 <20250818045759.672408-4-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818045759.672408-4-anshuman.khandual@arm.com>

On Mon, Aug 18, 2025 at 10:27:58AM +0530, Anshuman Khandual wrote:
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 4bdae8bb11dc..d2b40105eb41 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -4812,6 +4812,50 @@ Sysreg	TCR_EL12        3	5	2	0	2
>  Mapping	TCR_EL1
>  EndSysreg
>  
> +Sysreg	TCR_EL2        3	4	2	0	2
> +Res0	63:34
> +Field	33	MTX
> +Field	32	DS
> +Res1	31
> +Field	30	TCMA
> +Field	29	TBID
> +Field	28	HWU62
> +Field	27	HWU61
> +Field	26	HWU60
> +Field	25	HWU59
> +Field	24	HPD
> +Res1	23
> +Field	22	HD
> +Field	21	HA
> +Field	20	TBI
> +Res0	19
> +Field   18:16	PS
> +UnsignedEnum	15:14	TG0
> +	0b00	4K
> +	0b01	64K
> +	0b10	16K
> +EndEnum

Same comment as for patch 1: this is not ordered, use Enum rather than
UnsignedEnum. Likewise for the other cases below.

Mark.

> +UnsignedEnum	13:12	SH0
> +	0b00	NONE
> +	0b10	OUTER
> +	0b11	INNER
> +EndEnum
> +UnsignedEnum	11:10	ORGN0
> +	0b00	NC
> +	0b01	WBWA
> +	0b10	WT
> +	0b11	WBnWA
> +EndEnum
> +UnsignedEnum	9:8	IRGN0
> +	0b00	NC
> +	0b01	WBWA
> +	0b10	WT
> +	0b11	WBnWA
> +EndEnum
> +Res0    7:6
> +Field   5:0	T0SZ
> +EndSysreg
> +
>  Sysreg	TCRALIAS_EL1    3	0	2	7	6
>  Mapping	TCR_EL1
>  EndSysreg
> -- 
> 2.25.1
> 
> 
