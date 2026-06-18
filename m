Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55191298CB2
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 16:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781799407; cv=none; b=RVpJUWXm9+6zi5KI1C0NbqemeIMPUsS3o2kOE1DQj4DISRahx5exe4YASsw2llPHnFJDOLwxURBYTSrX/Xa/KMuYYRwfEfi3My2MBBUgJkmXsOdodjvDk3VjDXen4gAO6wE30naqO+ZOmoUi0VEwqfpzVlTa+rErCVprX0SUxT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781799407; c=relaxed/simple;
	bh=9wy/W2L+hLNuPXubuOiBB/zgEIFleeUzIlllml2G+Fw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WONvPJoi/3WQPXR1pVHNvdAk0xOgwaNOXTFL1l7xPD2wn03SW48U22g+CUC0Wy5GvMUbqIgRnnS0UrtVB/JFkbY+v7GC7c6KzyseIV1NSBqMB2AgVrKiiGhtFMKs1frJCth68fw0txaEi+EeHi4rBrskAmuipUkjJEvUPgqGbTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GdiKFpaX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GdiKFpaX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09C1C493F;
	Thu, 18 Jun 2026 09:16:41 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A7DE3F632;
	Thu, 18 Jun 2026 09:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781799405; bh=9wy/W2L+hLNuPXubuOiBB/zgEIFleeUzIlllml2G+Fw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GdiKFpaXB7XTGBc9c6Dlo6D+B+ug4JeO2OxoOpDnTeu3ypmU71pmoDhU05cruhoTo
	 g0G2o016LXafLLF8TS4WQYJuibzxkG3ko0jlL8pFXXNiyYogC6eqDDEqMQlUx17n5i
	 Edb5J7DrEh4kIQANMjznUuOrqUzQBKvArVKJus2o=
Date: Thu, 18 Jun 2026 17:16:41 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: Andrew Jones <andrew.jones@linux.dev>,
	Eric Auger <eric.auger@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH] arm: io: Set is_pl011_uart flag in ACPI
 initialization
Message-ID: <ajQZ6aKPnybVueJC@raptor>
References: <20260513211624.2416284-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513211624.2416284-1-coltonlewis@google.com>

Hi,

On Wed, May 13, 2026 at 09:16:24PM +0000, Colton Lewis wrote:
> When booting via ACPI on ARM64, the SPCR table is parsed to initialize
> the console UART. However, the code was neglecting to set the
> is_pl011_uart flag. This caused __getchar() to fall back to treating
> the UART as a 16550A device, which fails on systems with a PL011.
> 
> Tests that wait for serial input (like its-migration) would hang
> indefinitely because __getchar() would always return -1.
> 
> Update uart0_init_acpi() to inspect the SPCR interface_type and set
> is_pl011_uart accordingly. Also define macros for the first four SPCR
> interface types in lib/acpi.h based on the Microsoft specification.
> 
> Link: https://learn.microsoft.com/en-us/windows-hardware/drivers/bringup/acpi-debug-port-table#table-3-debug-port-types-and-subtypes
> Assisted-by: Gemini:gemini-3.1-pro
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  lib/acpi.h   | 6 ++++++
>  lib/arm/io.c | 3 +++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/lib/acpi.h b/lib/acpi.h
> index 66e3062d..29b3edd5 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -251,6 +251,12 @@ enum acpi_madt_type {
>  /* MADT Local APIC flags */
>  #define ACPI_MADT_ENABLED		(1)	/* 00: Processor is usable if set */
>  
> +/* Values for interface_type field in struct spcr_descriptor */
> +#define ACPI_SPCR_INTERFACE_TYPE_16550		0x0000
> +#define ACPI_SPCR_INTERFACE_TYPE_16450		0x0001
> +#define ACPI_SPCR_INTERFACE_TYPE_16550_32BIT	0x0002
> +#define ACPI_SPCR_INTERFACE_TYPE_ARM_PL011	0x0003

We could also use the defines from the Linux source tree, from
include/acpi/actbl1.h (look below struct acpi_dbg2_device).

I got a bit confused about the value 2 above, because in the Debug Port
Table 2 (DBG2) from the link, that value is for a 'MAX311xE SPI UART'. Not
saying that it's not the same thing as a 32 bit 16550 uart (or that it
is!), just saying that the names don't appear to be matching.

> +
>  struct spcr_descriptor {
>  	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
>  	u8 interface_type;	/* 0=full 16550, 1=subset of 16550 */
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index 836fa854..55102bd7 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -81,6 +81,9 @@ static void uart0_init_acpi(void)
>  
>  	assert_msg(spcr, "Unable to find ACPI SPCR");
>  	uart0_base = ioremap(spcr->serial_port.address, spcr->serial_port.bit_width);
> +
> +	if (spcr->interface_type == ACPI_SPCR_INTERFACE_TYPE_ARM_PL011)
> +		is_pl011_uart = true;

The patch makes sense to me. With or without the Linux define names:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
