Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 899AB7D08B
	for <kvmarm@lists.linux.dev>; Tue, 12 Mar 2024 15:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710259069; cv=none; b=S4DHWBmo0gRVconXtXVCEz2OJ7pn5swEUp2hS8ocBRMU/mDQAkNDXVGzaKw7XeWjy4uIIt+on1v6l7QmiuK7LyGHDf9PFhyLAYwKN7pSr8J3FejPTe1IV+zSSpw3YQLpTHCRu/KJpJ/uBlNi8ZdTR7KRpqIyZQoILMJCpFQAu+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710259069; c=relaxed/simple;
	bh=qHTdrZJMFBSmWNwbyHjOmWb7ZpYhhu2kMlfqSqKfUEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T60ptQ5AlPwixgxCqgc87LZlNn8aAmQS5ePaKEX0/UdrxteChvVczmTwcuexPt28oZauW9ryS2/7GSUn4fHr2h6iK0nfTDYlgGMky+LP1xUABWNjm1lf6yVZwwDwpqPZMpBjUEBWydOxc12rvRxiodpuUYJ1G6yUA0pwD5ftjqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DE2391007;
	Tue, 12 Mar 2024 08:58:22 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 558A63F73F;
	Tue, 12 Mar 2024 08:57:42 -0700 (PDT)
Date: Tue, 12 Mar 2024 15:57:39 +0000
From: Sudeep Holla <sudeep.holla@arm.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Mostafa Saleh <smostafa@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] arm64: Use SYSTEM_OFF2 PSCI call to power off
 for hibernate
Message-ID: <ZfB7c9ifUiZR6gy1@bogus>
References: <20240312135958.727765-1-dwmw2@infradead.org>
 <20240312135958.727765-3-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240312135958.727765-3-dwmw2@infradead.org>

On Tue, Mar 12, 2024 at 01:51:29PM +0000, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The PSCI v1.3 specification (alpha) adds support for a SYSTEM_OFF2
> function which is analogous to ACPI S4 state. This will allow hosting
> environments to determine that a guest is hibernated rather than just
> powered off, and handle that state appropriately on subsequent launches.
> 
> Since commit 60c0d45a7f7a ("efi/arm64: use UEFI for system reset and
> poweroff") the EFI shutdown method is deliberately preferred over PSCI
> or other methods. So register a SYS_OFF_MODE_POWER_OFF handler which
> *only* handles the hibernation, leaving the original PSCI SYSTEM_OFF as
> a last resort via the legacy pm_power_off function pointer.
> 
> The hibernation code already exports a system_entering_hibernation()
> function which is be used by the higher-priority handler to check for
> hibernation. That existing function just returns the value of a static
> boolean variable from hibernate.c, which was previously only set in the
> hibernation_platform_enter() code path. Set the same flag in the simpler
> code path around the call to kernel_power_off() too.
> 
> An alternative way to hook SYSTEM_OFF2 into the hibernation code would
> be to register a platform_hibernation_ops structure with an ->enter()
> method which makes the new SYSTEM_OFF2 call. But that would have the
> unwanted side-effect of making hibernation take a completely different
> code path in hibernation_platform_enter(), invoking a lot of special dpm
> callbacks.
> 
> Another option might be to add a new SYS_OFF_MODE_HIBERNATE mode, with
> fallback to SYS_OFF_MODE_POWER_OFF. Or to use the sys_off_data to
> indicate whether the power off is for hibernation.
> 
> But this version works and is relatively simple.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  drivers/firmware/psci/psci.c | 35 +++++++++++++++++++++++++++++++++++
>  kernel/power/hibernate.c     |  5 ++++-
>  2 files changed, 39 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
> index d9629ff87861..69d2f6969438 100644
> --- a/drivers/firmware/psci/psci.c
> +++ b/drivers/firmware/psci/psci.c
> @@ -78,6 +78,7 @@ struct psci_0_1_function_ids get_psci_0_1_function_ids(void)
>  
>  static u32 psci_cpu_suspend_feature;
>  static bool psci_system_reset2_supported;
> +static bool psci_system_off2_supported;
>  
>  static inline bool psci_has_ext_power_state(void)
>  {
> @@ -333,6 +334,28 @@ static void psci_sys_poweroff(void)
>  	invoke_psci_fn(PSCI_0_2_FN_SYSTEM_OFF, 0, 0, 0);
>  }
>  
> +#ifdef CONFIG_HIBERNATION
> +static int psci_sys_hibernate(struct sys_off_data *data)
> +{
> +	if (system_entering_hibernation())
> +		invoke_psci_fn(PSCI_FN_NATIVE(1_3, SYSTEM_OFF2),
> +			       PSCI_1_3_HIBERNATE_TYPE_OFF, 0, 0);
> +	return NOTIFY_DONE;
> +}
> +
> +static int __init psci_hibernate_init(void)
> +{
> +	if (psci_system_off2_supported) {
> +		/* Higher priority than EFI shutdown, but only for hibernate */
> +		register_sys_off_handler(SYS_OFF_MODE_POWER_OFF,
> +					 SYS_OFF_PRIO_FIRMWARE + 2,
> +					 psci_sys_hibernate, NULL);
> +	}
> +	return 0;
> +}
> +subsys_initcall(psci_hibernate_init);

Looked briefly at register_sys_off_handler and it should be OK to call
it from psci_init_system_off2() below. Any particular reason for having
separate initcall to do this ? We can even eliminate the need for
psci_init_system_off2 if it can be called from there. What am I missing ?

--
Regards,
Sudeep
