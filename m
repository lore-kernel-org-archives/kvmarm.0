Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E2D2874F2
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 10:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749205053; cv=none; b=g4Kb30efWfvdHu+vfiHYOKXvZ68DKPhawHK+GVIKvU7ppmJZF9ciPTGaOf/63Av6wvCloEblowHsH8wIgbKTznY/od7dhd9vwRt+LzDWOr41FVpKT+wZHQTfr6KvTypMA8ngOCvDZtjGF3RiCN1i2JpIrS1qc7wOFMKdLLQ8SqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749205053; c=relaxed/simple;
	bh=HvZ3st1eSAe4qQ4PYDvR0i4s2aynIXGqIl9oaBmrwB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eww2oNMgStEED28DNcZLT4+Q1yFTnLoEtkMlLqtFVzD+r2vay+PZ3o4su4QaApDljL9jDrUj1UqGIHaU/G9FUjgucIfK6xbKgSnjRcqOlePOUVMrqy6Sp/3gCkwR/JtpSD1m4PAtI1JFR6AORrNlGjfWo4ZDCwxBZdg2UPc/iro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E978153B;
	Fri,  6 Jun 2025 03:17:12 -0700 (PDT)
Received: from [10.57.49.177] (unknown [10.57.49.177])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8A4E33F673;
	Fri,  6 Jun 2025 03:17:23 -0700 (PDT)
Message-ID: <4fb8327f-a3e7-4127-9fa7-754c4e6cbdcc@arm.com>
Date: Fri, 6 Jun 2025 11:17:22 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 2/9] arm64: efi: initialise SCTLR_ELx
 fully
Content-Language: en-GB
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250529135557.2439500-1-joey.gouly@arm.com>
 <20250529135557.2439500-3-joey.gouly@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250529135557.2439500-3-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/05/2025 14:55, Joey Gouly wrote:
> Don't rely on the value of SCTLR_ELx when booting via EFI.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>   lib/arm/setup.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 67b5db07..0a22dbab 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -349,6 +349,11 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>   {
>   	efi_status_t status;
>   
> +
> +	// EFI exits boot services with SCTLR_ELx.M=1, so keep
> +	// the MMU enabled.
> +	write_sysreg(INIT_SCTLR_EL1_MMU_OFF | SCTLR_EL1_M, sctlr_el1);

minor nit: Given this is in a common file for arm/arm64, may be worth 
adding a helper function that does this on arm64. I understand EFI
cannot enabled for arm32, still keeping this file generic would be
cleaner. e.g.,

mmu_on(); or even  setup_sctlr();

Suzuki

