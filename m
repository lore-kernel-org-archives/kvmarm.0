Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD67C33120A
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 21:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765834421; cv=none; b=Av2TyjmIQa4txjGIkDNbKHPtYP/SIs7VQERvtrjVOTHbil+V1e8wmSDBhBuWRooqRGIkmJ7S4nzkNHo6A+nrH2m1ENVDNc36xJpieAxoztLjhF8OblrVL1EXbjSg6F5Z+5G46GmgGmsNajzBiEgMZBMVpxtajG7l1mfJi0hlBIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765834421; c=relaxed/simple;
	bh=EPn2+/1wypQiZrCiuFAYVfQUf29/3KpltYTnL5QJ3ME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bGh6A37QoM0XZtkfY9RxbJlDe/Z3q0/U4r4nXVWprP8XGvzWah1BKx99tJpvg07KOppH8Xt7q+QcC+aL85FQ1aI/IZtzUQDGH7g4rY0R1P7r9R4Q6Gcqrg9s7G6yEYWx4/+fLIdjoA5fmYmlnSxpXnMT8uIVbgM9RtQglzJT4wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DE8CFEC;
	Mon, 15 Dec 2025 13:33:30 -0800 (PST)
Received: from [10.57.78.22] (unknown [10.57.78.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3AD753F73B;
	Mon, 15 Dec 2025 13:33:36 -0800 (PST)
Message-ID: <be79ca29-0233-4397-b3b0-38686512bc83@arm.com>
Date: Mon, 15 Dec 2025 21:33:34 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 02/35] arm64/sysreg: Define MDCR_EL2.E2PB values
Content-Language: en-GB
To: Alexandru Elisei <alexandru.elisei@arm.com>, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, yuzenghui@huawei.com,
 will@kernel.org, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: james.clark@linaro.org, mark.rutland@arm.com, james.morse@arm.com
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-3-alexandru.elisei@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20251114160717.163230-3-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/11/2025 16:06, Alexandru Elisei wrote:
> KVM will make use of the different values for MDCR_EL2.E2PB, document them.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   arch/arm64/tools/sysreg | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 1e7b69594f04..0de8af0e0778 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -3851,7 +3851,12 @@ Field	17	HPMD
>   Res0	16
>   Field	15	EnSPM
>   Field	14	TPMS
> -Field	13:12	E2PB
> +UnsignedEnum	13:12 E2PB
> +	0b00	EL2
> +	0b01	RESERVED
> +	0b10	EL1_TRAP
> +	0b11	EL1
> +EndEnum
>   Field	11	TDRA
>   Field	10	TDOSA
>   Field	9	TDA

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

