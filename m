Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98E601474DA
	for <kvmarm@lists.linux.dev>; Mon, 17 Mar 2025 11:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742211490; cv=none; b=Kif/doW7SZfTw5ISId5qs/nEWzTaDJDXhcdd4+UmCeVpW/7sLY9bYxJPy9+WiP5SC9ui6qvgH7pPSrmZHzsSwWZyjfD9O99qujWviOYQo3CWMSxmvZsjrZ27BYAh3/cc8LKzGzZWkQqDM1ptttanpqcHDXOlXDZw3jVTGPYdefQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742211490; c=relaxed/simple;
	bh=EqvvYmOyfgYejPEXBf8UIa6m1QV3pZwmCtppfI9ul+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hkRGqv/HR+35yGOivrrwTak8qbN0n8PgGOWLWkk9gdgSIeb6Qc/It5KBbEknDe4/JKzVjcjez5b2049xvh2vijLup2ZmyziuYlFWn2sBKMdDTWneZjLBlq5o9y6BJtnSwuSiIyBApMp6DHhwc6MG8wxJReN6eXDpAdNadZIyzaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DB3413D5;
	Mon, 17 Mar 2025 04:38:16 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4BECB3F694;
	Mon, 17 Mar 2025 04:38:00 -0700 (PDT)
Date: Mon, 17 Mar 2025 11:37:57 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Roman Kisel <romank@linux.microsoft.com>
Cc: arnd@arndb.de, bhelgaas@google.com, bp@alien8.de,
	catalin.marinas@arm.com, conor+dt@kernel.org,
	dan.carpenter@linaro.org, dave.hansen@linux.intel.com,
	decui@microsoft.com, haiyangz@microsoft.com, hpa@zytor.com,
	joey.gouly@arm.com, krzk+dt@kernel.org, kw@linux.com,
	kys@microsoft.com, lenb@kernel.org, lpieralisi@kernel.org,
	manivannan.sadhasivam@linaro.org, maz@kernel.org, mingo@redhat.com,
	oliver.upton@linux.dev, rafael@kernel.org, robh@kernel.org,
	ssengar@linux.microsoft.com, sudeep.holla@arm.com,
	suzuki.poulose@arm.com, tglx@linutronix.de, wei.liu@kernel.org,
	will@kernel.org, yuzenghui@huawei.com, devicetree@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-acpi@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, x86@kernel.org, apais@microsoft.com,
	benhill@microsoft.com, bperkins@microsoft.com,
	sunilmut@microsoft.com
Subject: Re: [PATCH hyperv-next v6 02/11] arm64: hyperv: Use SMCCC to detect
 hypervisor presence
Message-ID: <Z9gJlQgV3hm1kxY0@J2N7QTR9R3.cambridge.arm.com>
References: <20250315001931.631210-1-romank@linux.microsoft.com>
 <20250315001931.631210-3-romank@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250315001931.631210-3-romank@linux.microsoft.com>

On Fri, Mar 14, 2025 at 05:19:22PM -0700, Roman Kisel wrote:
> The arm64 Hyper-V startup path relies on ACPI to detect
> running under a Hyper-V compatible hypervisor. That
> doesn't work on non-ACPI systems.
> 
> Hoist the ACPI detection logic into a separate function. Then
> use the vendor-specific hypervisor service call (implemented
> recently in Hyper-V) via SMCCC in the non-ACPI case.
> 
> Signed-off-by: Roman Kisel <romank@linux.microsoft.com>
> Reviewed-by: Michael Kelley <mhklinux@outlook.com>
> ---
>  arch/arm64/hyperv/mshyperv.c | 43 +++++++++++++++++++++++++++++++-----
>  1 file changed, 38 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/hyperv/mshyperv.c b/arch/arm64/hyperv/mshyperv.c
> index 2265ea5ce5ad..c5b03d3af7c5 100644
> --- a/arch/arm64/hyperv/mshyperv.c
> +++ b/arch/arm64/hyperv/mshyperv.c
> @@ -27,6 +27,41 @@ int hv_get_hypervisor_version(union hv_hypervisor_version_info *info)
>  	return 0;
>  }
>  
> +static bool __init hyperv_detect_via_acpi(void)
> +{
> +	if (acpi_disabled)
> +		return false;
> +#if IS_ENABLED(CONFIG_ACPI)
> +	/*
> +	 * Hypervisor ID is only available in ACPI v6+, and the
> +	 * structure layout was extended in v6 to accommodate that
> +	 * new field.
> +	 *
> +	 * At the very minimum, this check makes sure not to read
> +	 * past the FADT structure.
> +	 *
> +	 * It is also needed to catch running in some unknown
> +	 * non-Hyper-V environment that has ACPI 5.x or less.
> +	 * In such a case, it can't be Hyper-V.
> +	 */
> +	if (acpi_gbl_FADT.header.revision < 6)
> +		return false;
> +	return strncmp((char *)&acpi_gbl_FADT.hypervisor_id, "MsHyperV", 8) == 0;
> +#else
> +	return false;
> +#endif
> +}
> +

The 'acpi_disabled' variable doesn't exist for !CONFIG_ACPI, so its use
prior to the ifdeffery looks misplaced.

Usual codestyle is to avoid ifdeffery if possible, using IS_ENABLED().
Otherwise, use a stub, e.g.

| #ifdef CONFIG_ACPI
| static bool __init hyperv_detect_via_acpi(void)
| {
| 	if (acpi_disabled)
| 		return false;
| 	
| 	if (acpi_gbl_FADT.header.revision < 6)
| 		return false;
| 	
| 	return strncmp((char *)&acpi_gbl_FADT.hypervisor_id, "MsHyperV", 8) == 0;
| }
| #else
| static inline bool hyperv_detect_via_acpi(void) { return false; }
| #endif

Mark.

> +static bool __init hyperv_detect_via_smccc(void)
> +{
> +	uuid_t hyperv_uuid = UUID_INIT(
> +		0x4d32ba58, 0x4764, 0xcd24,
> +		0x75, 0x6c, 0xef, 0x8e,
> +		0x24, 0x70, 0x59, 0x16);
> +
> +	return arm_smccc_hyp_present(&hyperv_uuid);
> +}
> +
>  static int __init hyperv_init(void)
>  {
>  	struct hv_get_vp_registers_output	result;
> @@ -35,13 +70,11 @@ static int __init hyperv_init(void)
>  
>  	/*
>  	 * Allow for a kernel built with CONFIG_HYPERV to be running in
> -	 * a non-Hyper-V environment, including on DT instead of ACPI.
> +	 * a non-Hyper-V environment.
> +	 *
>  	 * In such cases, do nothing and return success.
>  	 */
> -	if (acpi_disabled)
> -		return 0;
> -
> -	if (strncmp((char *)&acpi_gbl_FADT.hypervisor_id, "MsHyperV", 8))
> +	if (!hyperv_detect_via_acpi() && !hyperv_detect_via_smccc())
>  		return 0;
>  
>  	/* Setup the guest ID */
> -- 
> 2.43.0
> 
