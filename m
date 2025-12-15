Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25FD5223336
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 21:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765834959; cv=none; b=B/PGqsa7EucVs7txZ3ETAK8Qqi90ePOYEqIe3rzr89t+pCLWCLozFhSuNtMO5NgNy0kTT6YP+kfE3WKtyCHI+1Em+wHwev8HZAgTx4R8QyeiMZrNzQ2f52czVyJAfrzVb6sTLj2aqCJSfh4e6j1uwlrzOb8jSRWItMFJXX2e0uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765834959; c=relaxed/simple;
	bh=y/8o7pjE+jv9Xhh+oyH0nf+UDZ7vRHXmjAwqd0BO/ZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hrrqgYRGVxKvd1l7Un/XJDJwxS8dyXYQ1wLf2aJX8jQWDirtHasy9k/eATB/z4uu0+nuJnl2d7i+YWU0gcEhVfVBgYr3RviMv1+0u/rY1sJDMOAtpY/Re64l+iiW9hdwRu/eTd8DlvrUXe/qqRZ7IZuzch5TrjC19LdODDSY4Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C55FFEC;
	Mon, 15 Dec 2025 13:42:29 -0800 (PST)
Received: from [10.57.78.22] (unknown [10.57.78.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 97E3D3F73B;
	Mon, 15 Dec 2025 13:42:34 -0800 (PST)
Message-ID: <f080bfaf-9946-42ee-98c4-b31badc65621@arm.com>
Date: Mon, 15 Dec 2025 21:42:33 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 01/35] arm64/sysreg: Add new SPE fields
Content-Language: en-GB
To: Alexandru Elisei <alexandru.elisei@arm.com>, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, yuzenghui@huawei.com,
 will@kernel.org, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: james.clark@linaro.org, mark.rutland@arm.com, james.morse@arm.com
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-2-alexandru.elisei@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20251114160717.163230-2-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/11/2025 16:06, Alexandru Elisei wrote:
> Add the PMBSR_EL1.MSS2, PMBISR_EL1.MaxBuffSize, PMBLIMITR_EL1.nVM and

minor nit:                ^PMBIDR_EL1

> PMBIDR_EL1.AddrMode fields, which will be used by KVM.
> 

The defintions look correct to me.

Suzuki


> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   arch/arm64/tools/sysreg | 18 ++++++++++++++----
>   1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 1c6cdf9d54bb..1e7b69594f04 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -3070,7 +3070,9 @@ EndSysreg
>   
>   Sysreg	PMBLIMITR_EL1	3	0	9	10	0
>   Field	63:12	LIMIT
> -Res0	11:6
> +Res0	11:8
> +Field	7	nVM
> +Res0	6
>   Field	5	PMFZ
>   Res0	4:3
>   Enum	2:1	FM
> @@ -3085,7 +3087,8 @@ Field	63:0	PTR
>   EndSysreg
>   
>   Sysreg	PMBSR_EL1	3	0	9	10	3
> -Res0	63:32
> +Res0	63:56
> +Field	55:32	MSS2
>   Enum	31:26	EC
>   	0b000000	BUF
>   	0b100100	FAULT_S1
> @@ -3112,13 +3115,20 @@ Field	7:0	Attr
>   EndSysreg
>   
>   Sysreg	PMBIDR_EL1	3	0	9	10	7
> -Res0	63:12
> +Res0	63:48
> +Field	47:32	MaxBuffSize
> +Res0	31:12
>   Enum	11:8	EA
>   	0b0000	NotDescribed
>   	0b0001	Ignored
>   	0b0010	SError
>   EndEnum
> -Res0	7:6
> +Enum	7:6	AddrMode
> +	0b00	VM_ONLY
> +	0b01	BOTH
> +	0b10	RESERVED
> +	0b11	nVM_ONLY
> +EndEnum
>   Field	5	F
>   Field	4	P
>   Field	3:0	ALIGN

