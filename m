Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336395;
	b=kmDBMfiRswIUXuT9NSB7dkeeBwNlROEV59YO3nv83ESh9PAVFwgGlWMKSSyUAy2Y99b9
	 1On1X0UUZcPzJbqwc22izi3IDmU5YtWlOSsZUQc40aBycO9QKpr2KIspTyRL0MJfCWlfS
	 0Vmid6pVqpqlD+/hXvOWvjr3JHxW6wNICrU/ZuZG6ltyn4p5lXv67J52i0+L1qt5gSIAE
	 xTK4nDC7NF/9ZAjeCqPV7Tde9E4Y+39cTZWOUuyiJta0KWYmUIZfRcN191SVQ5GOaB5tJ
	 Luu1dcQMjsBW0wilOHste7EMfwq5Cl7WEVJx20UPJIrl7mwjNrXCmOj88gXb9Cpw/UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336395;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=XHtOnNb/QT0KYcuG2D6k7Sc+gTZ6iTr4Jo8NFEFUk6c=;
	b=IoWAnTG9AhUDAbPDJfJX5afSyDZ5gZuatyb8H9U5L83I5SAmdf9Jo+ZuJCC5u5oQ4zUF
	 pjt+JX7qh6NyOVNTuSwh110LM6dTGQ8WYWV5/9n0WmVCL69VQoaRG05E7rwtUihMfdmhB
	 8X8CAFvG3UxjeKce688ru0/xOV2ZnzycdciZIhl9p27SujNX+IqWwVbLReTru+YvneBll
	 565i9OLVW1ymHHJZXfn9pZ7YPJQZ32jbJZYP4nxJelSc++wdiTobRpUirEued6HDOSoIV
	 yt6XjNv2fK5pJASPJyrkWN7D4Ti2CXUwQ4QauQMf7OCx7XnnTs3C6hg2rZbGSnGn9/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=kfqKBl33;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FD11606A31A
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 04:59:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FD11606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=kfqKBl33
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 127671576;
	Thu, 29 Oct 2026 21:59:49 -0700 (PDT)
Received: from localhost (a079125.arm.com [10.164.21.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 746343F673;
	Thu, 29 Oct 2026 21:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793336392; bh=qCqzGHRAYqmG7w1mdu0JzAwGvdKPeHbAcgCcr7TK1pE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kfqKBl33CLhrnzoGB+6Iy03S+L8vPpDEwz6ocMm//mxaOyrP9GhpqNf/hh1XVwBIG
	 F/nI4qjS9fEJ/dofCdVjLv2KmQyoK7ov7wq48ZWfvIY+x2tj8NHXxrjFf9kSmUUcLz
	 44+EAy3HrVUb6U1Vf8i+RtQk34iRvhMM403lVbK8=
Date: Fri, 30 Oct 2026 10:29:48 +0530
From: Linu Cherian <linu.cherian@arm.com>
To: Kristina =?utf-8?Q?Mart=C5=A1enko?= <kristina.martsenko@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-efi@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, 
	Hanjun Guo <guohanjun@huawei.com>, Sudeep Holla <sudeep.holla@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [RFC 02/12] arm64: Detect FEAT_TLBID
Message-ID: <tzt7fqgh6ksbuo5pe7qeh6gofjsumwrw7w6pw5iwdu3b5nd5dm@zkzrelsc2upt>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
 <20261001110655.461473-3-kristina.martsenko@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261001110655.461473-3-kristina.martsenko@arm.com>

Hi,

On Thu, Oct 01, 2026 at 12:06:45PM +0100, Kristina Martšenko wrote:
> Detect if FEAT_TLBID is supported by the system. Detect TLBID
> configuration from TLBIDIDR_EL1. This information will be used in later
> patches.
> 
> Set HFGRTR2_EL2.nTLBIDIDR_EL1 so that the kernel can access TLBIDIDR_EL1
> at EL1 (in case of nVHE/hVHE).
> 
> Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
> ---
>  arch/arm64/include/asm/cpu.h        |  1 +
>  arch/arm64/include/asm/cpufeature.h |  7 +++++++
>  arch/arm64/include/asm/el2_setup.h  |  9 ++++++++-
>  arch/arm64/kernel/cpufeature.c      | 25 +++++++++++++++++++++++++
>  arch/arm64/kernel/cpuinfo.c         |  3 +++
>  arch/arm64/tools/cpucaps            |  1 +
>  6 files changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
> index 3c008821219c..967ccdedf526 100644
> --- a/arch/arm64/include/asm/cpu.h
> +++ b/arch/arm64/include/asm/cpu.h
> @@ -48,6 +48,7 @@ struct cpuinfo_arm64 {
>  	u64		reg_gmid;
>  	u64		reg_smidr;
>  	u64		reg_mpamidr;
> +	u64		reg_tlbididr;
>  
>  	u64		reg_id_aa64dfr0;
>  	u64		reg_id_aa64dfr1;
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 4f04ad82ea34..d4e7497143b2 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -627,6 +627,13 @@ static inline bool id_aa64pfr1_mpamfrac(u64 pfr1)
>  	return val > 0;
>  }
>  
> +static inline bool id_aa64mmfr4_tlbid(u64 mmfr4)
> +{
> +	u32 val = cpuid_feature_extract_unsigned_field(mmfr4, ID_AA64MMFR4_EL1_TLBID_SHIFT);
> +
> +	return val > 0;
> +}
> +
>  void __init setup_boot_cpu_features(void);
>  void __init setup_system_features(void);
>  void __init setup_user_features(void);
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index aa8ec9df8024..bd70a470596c 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -438,9 +438,16 @@
>  	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
>  
>  .Lskip_spefds_\@:
> +	mov	x1, xzr
> +	mrs_s	x2, SYS_ID_AA64MMFR4_EL1
> +	ubfx	x2, x2, #ID_AA64MMFR4_EL1_TLBID_SHIFT, #ID_AA64MMFR4_EL1_TLBID_WIDTH
> +	cbz	x2, .Lskip_tlbid_\@
> +	orr	x1, x1, #HFGRTR2_EL2_nTLBIDIDR_EL1
> +
> +.Lskip_tlbid_\@:
>  	msr_s   SYS_HDFGRTR2_EL2, x0
>  	msr_s   SYS_HDFGWTR2_EL2, x0
> -	msr_s   SYS_HFGRTR2_EL2, xzr
> +	msr_s   SYS_HFGRTR2_EL2, x1
>  	msr_s   SYS_HFGWTR2_EL2, xzr
>  	msr_s   SYS_HFGITR2_EL2, xzr
>  .Lskip_fgt2_\@:

IMO, would be good to move the above changes into a separate patch.

Thanks,
Linu Cherian.

 
