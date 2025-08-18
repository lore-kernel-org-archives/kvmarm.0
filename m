Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96854304BC7
	for <kvmarm@lists.linux.dev>; Mon, 18 Aug 2025 09:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755508961; cv=none; b=YMhGBWlkFIl4gha+vx6y9ZLBtoPZquOREHs0yXKvKksx7JttnYPyUf3V9SG9U4ZrGmjwXJ9DJMTxj1jPaGZQ/Er8Vgw5prpCvUccbETh6lSAK3RKW6z5je0sRyqmA99o/K06uY+WyV4F6Aepozi7YWTo9AEafcBRxA8W5XtRGBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755508961; c=relaxed/simple;
	bh=L84sV9sJv4P91toXAI+YVqEu5X7KKgWHJj/8Fmw+qV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DNxIa/qmjBjUBPWb3KDJsgJpKNIVpY3Zl8sgm+UFBXQpyRCUftjUu2lFW0gTomzZFfgaH/uhKecU7pM/6lOAnAbuORee7gI9g2IDuBG7CARHmQuGEe/Sh6zAokgTiMosB3fsEkLFcnQFahPWHQl2AdLo8J77BJXLtMbRnBorK+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6829150C;
	Mon, 18 Aug 2025 02:22:31 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 438963F58B;
	Mon, 18 Aug 2025 02:22:35 -0700 (PDT)
Date: Mon, 18 Aug 2025 10:22:30 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] arm64/sysreg: Add VTCR_EL2 register
Message-ID: <aKLw1jvwOo4wG64n@J2N7QTR9R3>
References: <20250818045759.672408-1-anshuman.khandual@arm.com>
 <20250818045759.672408-5-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818045759.672408-5-anshuman.khandual@arm.com>

On Mon, Aug 18, 2025 at 10:27:59AM +0530, Anshuman Khandual wrote:
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index d2b40105eb41..f5a0a304f844 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -4910,6 +4910,63 @@ Field	1	PIE
>  Field	0	PnCH
>  EndSysreg
>  
> +Sysreg	VTCR_EL2	3	4	2	1	2
> +Res0	63:46
> +Field	45	HDBSS
> +Field	44	HAFT
> +Res0	43:42
> +Field	41	TL0
> +Field	40	GCSH
> +Res0	39
> +Field	38	D128
> +Field	37	S2POE
> +Field	36	S2PIE
> +Field	35	TL1
> +Field	34	AssuredOnly
> +Field	33	SL2
> +Field	32	DS
> +Res1	31
> +Field	30	NSA
> +Field	29	NSW
> +Field	28	HWU62
> +Field	27	HWU61
> +Field	26	HWU60
> +Field	25	HWU59
> +Res0	24:23
> +Field	22	HD
> +Field	21	HA
> +Res0	20
> +UnsignedEnum	19	VS
> +	0b0	8BIT
> +	0b1	16BIT
> +EndEnum

You left TCR_EL1.AS as a single-bit 'Field', so please do the same here
for consistency. I don't think there's much gained by making this any
sort of enum.

> +Field	18:16	PS
> +UnsignedEnum	15:14	TG0
> +		0b00	4K
> +		0b01	64K
> +		0b10	16K
> +EndEnum

As with other patches, this is not ordered. Please use Enum.

Likewise for the other cases below.

Mark.

> +UnsignedEnum	13:12	SH0
> +		0b00	NONE
> +		0b10	OUTER
> +		0b11	INNER
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
> +Field	7:6	SL0
> +Field	5:0	T0SZ
> +EndSysreg
> +
>  SysregFields MAIR2_ELx
>  Field	63:56	Attr7
>  Field	55:48	Attr6
> -- 
> 2.25.1
> 
> 
