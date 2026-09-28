Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83AE638643B;
	Mon, 28 Sep 2026 18:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790618487; cv=none; b=i2LuM2dzCElQzjxMan/m2Hh8TRNMpol6qtBQjoBZ+9yGDI/131Wp2ldkduAUsszu24DPpOZ+J9xepKw4cKchcEt4SfhI3ltyi6S7Yh8hJ9ByCBDiLlEfHDPKWE6s9Lm6tfl23FVwhwoFuZMR3objjsHensTBFo+lwgaVUrBMXK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790618487; c=relaxed/simple;
	bh=2HPAqPhH9blRfCpQLNE+q8Xf2IKbzIj8ANRetpSYQZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T6udO0nxj7o3bin/ldwTv9zWwm7kvRQHP+/5rb+Q31l0Z8RT2QkSeMvoIwE1g1SlY4hyvNrswvZoEvWYnFYhGVhlHDaJrLaxQ6cniwxa+vOPXSYrpkgiDY7Q/esLzHd760NSVpKEYZbvY9CRP+VP4sPEspGxXywMViS2yhFPEbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bydlcNQt; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bydlcNQt"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E32F1655;
	Mon, 28 Sep 2026 11:01:21 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 17F093F763;
	Mon, 28 Sep 2026 11:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790618484; bh=2HPAqPhH9blRfCpQLNE+q8Xf2IKbzIj8ANRetpSYQZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bydlcNQtg7VFJiHIMPz0i9Ug2oSSFgsIjPWay630oscZP2tIekk7hRid4Z2KgnDd3
	 Y/EYVkfQxooz6H++qoGvFAv+PbVFmCqCOBgENpU640RH4JItp9ePCG1NWk6TPmsiLJ
	 FP+9yLwn9lku23GyxOnTzBEHBYOls89RIbmOAYZI=
Date: Mon, 28 Sep 2026 19:01:11 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
	sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
Subject: Re: [PATCH v19 5/7] firmware: arm_rmm: Activate the RMM
Message-ID: <arqrZ_Auk9BYOopa@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-6-suzuki.poulose@arm.com>
 <arZmXFw5Jw2IbAmA@arm.com>
 <a11aba04-eaaa-43fd-988b-a2581b1b2fdb@arm.com>
 <araketG70TIKeNuf@arm.com>
 <12e83d88-de4c-4230-aac2-1796123320ad@arm.com>
 <70d47475-e26e-40e1-b409-b0c16aecb8c0@arm.com>
 <195cdfe4-a55a-453f-9c34-620738eca244@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <195cdfe4-a55a-453f-9c34-620738eca244@arm.com>

On Mon, Sep 28, 2026 at 02:55:11PM +0100, Suzuki K Poulose wrote:
> firmware: rmm: Deactivate RMM at reboot
> 
> Deactivate the RMM at system shutdown. This would allow a normal kexec to
> cleanup the state and boot into a new kernel gracefully.
> 
> Kdump kernels need not worry about an active RMM, as long as it can
> handle the GPF on access to the Delegated granules.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/kernel/machine_kexec.c |  2 +
>  drivers/firmware/arm_rmm/rmi.c    | 63 ++++++++++++++++++++++++++++++-
>  include/linux/arm-rmi-cmds.h      | 10 +++++
>  3 files changed, 73 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/machine_kexec.c
> b/arch/arm64/kernel/machine_kexec.c
> index 8f9bc2327dc85..8f16f92a5d389 100644
> --- a/arch/arm64/kernel/machine_kexec.c
> +++ b/arch/arm64/kernel/machine_kexec.c
> @@ -6,6 +6,7 @@
>   * Copyright (C) Huawei Futurewei Technologies.
>   */
> 
> +#include <linux/arm-rmi-cmds.h>
>  #include <linux/interrupt.h>
>  #include <linux/irq.h>
>  #include <linux/kernel.h>
> @@ -171,6 +172,7 @@ void machine_kexec(struct kimage *kimage)
>  	BUG_ON(!in_kexec_crash && (stuck_cpus || (num_online_cpus() > 1)));
>  	WARN(in_kexec_crash && (stuck_cpus || smp_crash_stop_failed()),
>  		"Some CPUs may be stale, kdump will be unreliable.\n");
> +	WARN(!in_kexec_crash && is_rmm_active(), "RMM is active, kexec will be
> unreliable.\n");
> 
>  	pr_info("Bye!\n");
> 
> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> index 51343e9d5c2a9..5b695f3155b1c 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
> @@ -7,6 +7,7 @@
>  #include <linux/memblock.h>
>  #include <linux/memory.h>
>  #include <linux/arm-rmi-cmds.h>
> +#include <linux/reboot.h>
>  #include <linux/slab.h>
> 
>  #include <asm/memory.h>
> @@ -15,6 +16,13 @@
>  /* RMM v2.0 defines RmiFeatureRegister0 to RmiFeatureRegister4. */
>  static unsigned long rmi_feat_reg_cache[5] __ro_after_init;
>  static bool arm64_rmi_is_available;
> +static bool arm64_rmm_active;
> +
> +bool is_rmm_active(void)
> +{
> +	return arm64_rmm_active;
> +}
> +EXPORT_SYMBOL_GPL(is_rmm_active);
> 
>  /**
>   * rmi_granule_range_undelegate() - Undelegate a range of granules
> @@ -1017,6 +1025,53 @@ bool is_rmi_available(void)
>  }
>  EXPORT_SYMBOL_GPL(is_rmi_available);
> 
> +static int rmi_rmm_deactivate(struct rmi_sro_state *sro)
> +{
> +	int ret;
> +
> +	if (!READ_ONCE(arm64_rmm_active))
> +		return 0;
> +
> +	ret = WARN_ON(rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_DEACTIVATE));
> +	if (ret)
> +		return ret;
> +
> +	WRITE_ONCE(arm64_rmm_active, false);
> +	WRITE_ONCE(arm64_rmi_is_available, false);
> +
> +	return ret;
> +}
> +
> +static int rmi_reboot_notifier(struct notifier_block *nb,
> +			       unsigned long action, void *data)
> +{
> +	int ret;
> +
> +	switch (action) {
> +	case SYS_RESTART:
> +	case SYS_HALT:
> +	case SYS_POWER_OFF:
> +		break;
> +	default:
> +		return NOTIFY_DONE;
> +	}
> +
> +	struct rmi_sro_state *sro __free(kfree) = kmalloc_obj(*sro);
> +
> +	if (!sro)
> +		return -ENOMEM;

Nit: it needs a NOTIFY_* value.

> +
> +	ret = rmi_rmm_deactivate(sro);
> +	if (ret)
> +		pr_emerg("RMM Deactivation failed: %d\n", ret);
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block rmi_reboot_nb = {
> +	.notifier_call = rmi_reboot_notifier,
> +};

Thinking some more about this, it's a good aim but I think it only works
if we do a systemctl kexec that tears down the processes (including the
VMMs). For a direct kexec -e, we happily reboot with pages still
delegated. Now, such tear-down in the kernel is painful, I think a lot
more work to figure out the delegated pages.

Also we don't cancel the kexec here even if we return an error, just
warn and continue into the new kernel.

So maybe blocking the kexec (e.g. machine_kexec_prepare()) in the first
place would be a better option for the time being. But I'd like, if
possible, to defer the RMM activation until the first user (still do the
RMI probing as an initcall). If we run on RME-capable hardware and
firmware but don't care about realms or TSM, we still get the normal OS
functionality.

If this deferring works, I'd also make memory hotplug dependent on this
(RMM activated => no hotplug; hotplug before activation => don't
activate the RMM). Maybe later, if we have a request for hotplug in
ZONE_MOVABLE and we can guarantee guest_memfd doesn't allocate from
there, we can relax this requirement.

That said, we may have a problem with hibernation as well if it tries to
read the delegated pages. I don't know how it interacts with guest_memfd
and the non-gmem pages we delegate. Maybe cpus_are_stuck_in_kernel() is
the right place, it prevents hibernation as well.

-- 
Catalin
