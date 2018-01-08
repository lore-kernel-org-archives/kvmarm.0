From: Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v6 14/16] firmware: arm_sdei: Discover SDEI support via
 ACPI
Date: Mon, 8 Jan 2018 17:56:01 +0000
Message-ID: <20180108175601.GD2530@red-moon>
References: <20180108153818.22743-1-james.morse@arm.com>
 <20180108153818.22743-15-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180108153818.22743-15-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, Heyi Guo <guoheyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 08, 2018 at 03:38:16PM +0000, James Morse wrote:
> SDEI defines a new ACPI table to indicate the presence of the interface.
> The conduit is discovered in the same way as PSCI.
> 
> For ACPI we need to create the platform device ourselves as SDEI doesn't
> have an entry in the DSDT.
> 
> The SDEI platform device should be created after ACPI has been initialised
> so that we can parse the table, but before GHES devices are created, which
> may register SDE events if they use SDEI as their notification type.
> 
> Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
> Acked-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> ---
>  drivers/firmware/arm_sdei.c | 41 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 40 insertions(+), 1 deletion(-)

Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>

> diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
> index 10a8bfa7339a..fb7caa3628b9 100644
> --- a/drivers/firmware/arm_sdei.c
> +++ b/drivers/firmware/arm_sdei.c
> @@ -907,6 +907,14 @@ static int sdei_get_conduit(struct platform_device *pdev)
>  		}
>  
>  		pr_warn("invalid \"method\" property: %s\n", method);
> +	} else if (IS_ENABLED(CONFIG_ACPI) && !acpi_disabled) {
> +		if (acpi_psci_use_hvc()) {
> +			sdei_firmware_call = &sdei_smccc_hvc;
> +			return CONDUIT_HVC;
> +		} else {
> +			sdei_firmware_call = &sdei_smccc_smc;
> +			return CONDUIT_SMC;
> +		}
>  	}
>  
>  	return CONDUIT_INVALID;
> @@ -1020,14 +1028,45 @@ static bool __init sdei_present_dt(void)
>  	return true;
>  }
>  
> +static bool __init sdei_present_acpi(void)
> +{
> +	acpi_status status;
> +	struct platform_device *pdev;
> +	struct acpi_table_header *sdei_table_header;
> +
> +	if (acpi_disabled)
> +		return false;
> +
> +	status = acpi_get_table(ACPI_SIG_SDEI, 0, &sdei_table_header);
> +	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
> +		const char *msg = acpi_format_exception(status);
> +
> +		pr_info("Failed to get ACPI:SDEI table, %s\n", msg);
> +	}
> +	if (ACPI_FAILURE(status))
> +		return false;
> +
> +	pdev = platform_device_register_simple(sdei_driver.driver.name, 0, NULL,
> +					       0);
> +	if (IS_ERR(pdev))
> +		return false;
> +
> +	return true;
> +}
> +
>  static int __init sdei_init(void)
>  {
> -	if (sdei_present_dt())
> +	if (sdei_present_dt() || sdei_present_acpi())
>  		platform_driver_register(&sdei_driver);
>  
>  	return 0;
>  }
>  
> +/*
> + * On an ACPI system SDEI needs to be ready before HEST:GHES tries to register
> + * its events. ACPI is initialised from a subsys_initcall(), GHES is initialised
> + * by device_initcall(). We want to be called in the middle.
> + */
>  subsys_initcall_sync(sdei_init);
>  
>  int sdei_event_handler(struct pt_regs *regs,
> -- 
> 2.15.0
> 
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
