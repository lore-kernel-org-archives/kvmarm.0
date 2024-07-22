Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8613F166310
	for <kvmarm@lists.linux.dev>; Mon, 22 Jul 2024 08:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721637601; cv=none; b=G4H+cN/TsOqK778IYeUXhBWGKk3Q4BIoSdo7PnmmP3rP7mDYNSAXmLZy0iR5GQY41UTXq/PV5c3XvJoVN3d3dav4dTkBkCANsEMP9sDyuwPotuhpnq6MZQn5B/YwL3nz9NNcmvbKbHCo6sTlKbfcPGNtzzDZWWeRoYhkoKm+VX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721637601; c=relaxed/simple;
	bh=ncs6m08XL3Rtle4jkWhhGYwkPc99G2aXkxvhLe83aO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T8Htp2uTyvR9+GwUljozqLpPM75MMPy3Yx/bRHtkrTU/K8W5O72UOTQGjbkCiZwsQxZBHeRl+1EEE4sKxUA8+8Kaw8tfW9ioPPgSqrCdREo8kHsCOsYKhuIUvRhgjp75+AHijrj7FZOEHuIQT7F6xvEQG7dtHjTRFytLGPrYXnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 825DE367;
	Mon, 22 Jul 2024 01:40:24 -0700 (PDT)
Received: from [10.162.41.8] (a077893.blr.arm.com [10.162.41.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B6E4F3F73F;
	Mon, 22 Jul 2024 01:39:55 -0700 (PDT)
Message-ID: <c324b32d-a932-44c2-9d16-445b604d2eb5@arm.com>
Date: Mon, 22 Jul 2024 14:09:52 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64/sysreg: Correct the values for GICv4.1
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240718215532.616447-1-rananta@google.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20240718215532.616447-1-rananta@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/19/24 03:25, Raghavendra Rao Ananta wrote:
> Currently, sysreg has value as 0b0010 for the presence of GICv4.1 in
> ID_PFR1_EL1 and ID_AA64PFR0_EL1, instead of 0b0011 as per ARM ARM.
> Hence, correct them to reflect ARM ARM.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/tools/sysreg | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index a4c1dd4741a47..7ceaa1e0b4bc2 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -149,7 +149,7 @@ Res0	63:32
>  UnsignedEnum	31:28	GIC
>  	0b0000	NI
>  	0b0001	GICv3
> -	0b0010	GICv4p1
> +	0b0011	GICv4p1
>  EndEnum
>  UnsignedEnum	27:24	Virt_frac
>  	0b0000	NI
> @@ -903,7 +903,7 @@ EndEnum
>  UnsignedEnum	27:24	GIC
>  	0b0000	NI
>  	0b0001	IMP
> -	0b0010	V4P1
> +	0b0011	V4P1
>  EndEnum
>  SignedEnum	23:20	AdvSIMD
>  	0b0000	IMP
> 
> base-commit: 0c3836482481200ead7b416ca80c68a29cfdaabd

This checks against ARM DDI 0487K.a and ddi0601/2024-06 XML.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
