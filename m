Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACAA6AA2
	for <kvmarm@lists.linux.dev>; Wed, 30 Aug 2023 18:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=tjJFXRrC0i86SOlwgDvPcsbn6f+wSEMk3Zmh190DkJ8=; b=xHP24Y/i/tnQDk79l2uTYI3JHj
	lP0dtLRHCqayWm9bwkWjvNBtOs2R78CGLNGRim6gTaqJdL9BQbQbPYRb8WzQfWr/W1m+DqFTYAxnd
	UgYr/Ps3inemlF6uvLKaDCx6hdvKtYA+rS+1e+8yq0sDlf272aPTceyNM6nFrDtIBAXi1lmKmdLGC
	OVTtKny5z2AlHOVKvX8jRMy9wls2UDe9xMULQPdWgcRKBOF0EQ7r0K++CljbtmGhf33Q/DwK57Dwz
	hhPbnLA8vITgdB8scOlAI9dQksSfLKbM1f3OwNJopUziqpurdNxtdUZeLhCfGFBXrpkZLtwlK0vTR
	Ps3dkCoQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52236)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qbPyO-0001ww-2C;
	Wed, 30 Aug 2023 19:31:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qbPyJ-0005vm-NG; Wed, 30 Aug 2023 19:31:19 +0100
Date: Wed, 30 Aug 2023 19:31:19 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: James Morse <james.morse@arm.com>
Cc: linux-pm@vger.kernel.org, loongarch@lists.linux.dev,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Borislav Petkov <bp@alien8.de>,
	H Peter Anvin <hpa@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>, Len Brown <lenb@kernel.org>,
	Rafael Wysocki <rafael@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	Salil Mehta <salil.mehta@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [RFC PATCH 02/32] ACPI: Move ACPI_HOTPLUG_CPU to be enabled per
 architecture
Message-ID: <ZO+K9+C+RgNeZ7Nq@shell.armlinux.org.uk>
References: <20230203135043.409192-1-james.morse@arm.com>
 <20230203135043.409192-3-james.morse@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203135043.409192-3-james.morse@arm.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Fri, Feb 03, 2023 at 01:50:13PM +0000, James Morse wrote:
> --- a/arch/ia64/Kconfig
> +++ b/arch/ia64/Kconfig
> @@ -15,6 +15,7 @@ config IA64
>  	select ARCH_MIGHT_HAVE_PC_PARPORT
>  	select ARCH_MIGHT_HAVE_PC_SERIO
>  	select ACPI
> +	select ACPI_HOTPLUG_CPU if ACPI
> --- a/arch/loongarch/Kconfig
> +++ b/arch/loongarch/Kconfig
> @@ -5,6 +5,7 @@ config LOONGARCH
>  	select ACPI
>  	select ACPI_GENERIC_GSI if ACPI
>  	select ACPI_MCFG if ACPI
> +	select ACPI_HOTPLUG_CPU if ACPI
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -59,6 +59,7 @@ config X86
>  	#
>  	select ACPI_LEGACY_TABLES_LOOKUP	if ACPI
>  	select ACPI_SYSTEM_POWER_STATES_SUPPORT	if ACPI
> +	select ACPI_HOTPLUG_CPU			if ACPI
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -309,7 +309,6 @@ config ACPI_HOTPLUG_CPU
>  	bool
>  	depends on ACPI_PROCESSOR && HOTPLUG_CPU
>  	select ACPI_CONTAINER
> -	default y

When selecting the symbol, it's a good idea to ensure that its
dependencies are satisfied. So here, ACPI_HOTPLUG_CPU depends on
ACPI_PROCESSOR and HOTPLUG_CPU.

For x86, you're selecting ACPI_HOTPLUG_CPU if ACPI is enabled,
and ACPI can be freely enabled. HOTPLUG_CPU depends on SMP,
which is also a freely selectable option. Lastly,
ACPI_PROCESSOR depends on X86 || IA64 || ARM64 || LOONGARCH,
and is a user selectable, defaulting-y option if ACPI is
enabled.

So, shouldn't the x86 select be:

	select ACPI_HOTPLUG_CPU if ACPI_PROCESSOR && HOTPLUG_CPU

?

I suspect similar issues exist for the other architecture Kconfig files
modified above.

This seems to also be in the latest rfc too, which is why I'm bringing
it up.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
