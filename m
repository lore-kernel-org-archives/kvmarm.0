Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECFAE4F5DFE;
	Thu,  1 Oct 2026 11:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790852772; cv=none; b=OBGjyICoJyzlRkmhqxAdSoVuw/uAy0dNeu7jiyIxNwiukOnNzcHC2DrfF83+bhdQ+Xf6z7uRxWBJL8Y0goAEy0cXHoWoTwyyBThes9dJkbnbAnE4Vze4ie4TeGoq96/eonaRTWLYrnqaZ4q10KmxjnH6MwJFGZMeoBnhqWv7iRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790852772; c=relaxed/simple;
	bh=+V5xRtwSpEjK63wJ+cyKK9U6lr5/HJMU+DNwniXIDPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kyy46k4S8G/IPiScCNjeJHMNuv6BPRY2Ii0pC5/8gjIgMLZZZKDRDUSNroetxCDJ7PtYY+/s+j79So+WaH7NQ2oWmZxjgith7R8PJbYf2HpjzGC7/Ow6JJ52pgR170tEjnbxDn5MWoSCIEGEbvIkzP/HjQ2RuQRlWXupMsclbCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QA4Dw1zg; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QA4Dw1zg"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D1A18497;
	Thu,  1 Oct 2026 04:06:05 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 629933F86F;
	Thu,  1 Oct 2026 04:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790852769; bh=+V5xRtwSpEjK63wJ+cyKK9U6lr5/HJMU+DNwniXIDPM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QA4Dw1zgbThIBjOabcmXcqRHYzROk+Gtzp31ZMqTM1Gizq4hBiCin0fp9CZK59U3Z
	 lnsZgFVLWM+YD5l+BCQwOtq4F4JiM/pb/+vop0z4oiTIc3E6LJHU7eaxU6vNx7EXKu
	 x7Lh+csDbTkySVd40j7jwq/nY4waPO8BTz6TOZ1s=
Date: Thu, 1 Oct 2026 12:05:54 +0100
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
	sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>, Pavel Machek <pavel@kernel.org>,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v21 7/9] arm64: Block hibernate and kexec while RMM is
 active
Message-ID: <ar4-kg8Jq9BTn7Sb@arm.com>
References: <20261001084555.1456543-1-suzuki.poulose@arm.com>
 <20261001084555.1456543-8-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001084555.1456543-8-suzuki.poulose@arm.com>

On Thu, Oct 01, 2026 at 09:45:53AM +0100, Suzuki K Poulose wrote:
> RMM can be deactivated only after all delegated granules have been
> reclaimed. If a new kernel is entered while any granules remain in the
> Realm PAS, accesses to that memory can raise a Granule Protection Fault
> and be fatal to the new kernel.
> 
> Crash kexec/kdump needs separate handling. It can be supported only once
> the crash kernel can tolerate delegated memory inherited from the primary
> kernel. i.e., be able to read the pages safely and fixup the GPF. Until
> then disable the kexec completely.
> 
> Hibernate has a similar problem. The image cannot be safely saved for
> delegated pages, as the RMM doesn't support exporting the pages.
> 
> Disable both kexec and hiberation while the RMM is active.

I would mention that this adds a new arch_hibernation_available() hook
called from hibernation_available(), otherwise the hibernation
maintainers may not realise why they've been cc'ed.

Alternatively, just introduce the hook as a separate patch without any
arch code.

> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Pavel Machek <pavel@kernel.org>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v20:
>  - Add arch_hibernation_available() hook for archs to have a say and drop the
>    other checks.
> Changes since v19:
>  - New patch to disable kexec and hibernation with RMM
> ---
>  arch/arm64/kernel/hibernate.c     | 14 ++++++++++++++
>  arch/arm64/kernel/machine_kexec.c | 11 +++++++++++
>  include/linux/suspend.h           |  1 +
>  kernel/power/hibernate.c          |  8 +++++++-
>  4 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
> index 7bf1174277772..08e03d24b93a8 100644
> --- a/arch/arm64/kernel/hibernate.c
> +++ b/arch/arm64/kernel/hibernate.c
> @@ -10,6 +10,8 @@
>   * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
>   */
>  #define pr_fmt(x) "hibernate: " x
> +
> +#include <linux/arm-rmi-cmds.h>
>  #include <linux/cpu.h>
>  #include <linux/kvm_host.h>
>  #include <linux/pm.h>
> @@ -105,6 +107,18 @@ void notrace restore_processor_state(void)
>  {
>  }
>  
> +bool arch_hibernation_available(void)
> +{
> +	/*
> +	 * If we have activated the RMM, there could be pages that are
> +	 * delegated to the RMM. Trying to save them to the image will be fatal.
> +	 * Also, we donate pages to the RMM at activation and restoring data
> +	 * to those pages are going to be fatal.
> +	 * Hence, disable the hibernation when the RMM is active
> +	 */
> +	return !cpus_are_stuck_in_kernel() && !is_rmm_active();
> +}

For now, I would keep is_rmm_active() only in here as not to change the
behaviour for pKVM. "disk" would disappear from /sys/power/state with
this patch. I think it's the correct thing to do for pKVM as well but we
can discuss this separately once this goes in (I also think pKVM using
cpus_are_stuck_in_kernel() is a bit of a bodge but it's a handy hook
called in the right places).

> +
>  int arch_hibernation_header_save(void *addr, unsigned int max_size)
>  {
>  	struct arch_hibernate_hdr *hdr = addr;
> diff --git a/arch/arm64/kernel/machine_kexec.c b/arch/arm64/kernel/machine_kexec.c
> index 8f9bc2327dc85..48f343704cb54 100644
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
> @@ -59,6 +60,16 @@ int machine_kexec_prepare(struct kimage *kimage)
>  		return -EBUSY;
>  	}
>  
> +	/*
> +	 * We will be able to allow kdump to proceed, once we have the support
> +	 * for handling GPF from vmcore accesses to delegated pages. Until then
> +	 * block kexec completely.
> +	 */
> +	if (is_rmm_active()) {
> +		pr_err("Can't kexec: RMM is active.\n");
> +		return -EBUSY;
> +	}
> +
>  	return 0;
>  }
>  
> diff --git a/include/linux/suspend.h b/include/linux/suspend.h
> index b02876f1ae38a..a3815027773c5 100644
> --- a/include/linux/suspend.h
> +++ b/include/linux/suspend.h
> @@ -401,6 +401,7 @@ int hibernate_quiet_exec(int (*func)(void *data), void *data);
>  int hibernate_resume_nonboot_cpu_disable(void);
>  int arch_hibernation_header_save(void *addr, unsigned int max_size);
>  int arch_hibernation_header_restore(void *addr);
> +bool arch_hibernation_available(void);
>  
>  #else /* CONFIG_HIBERNATION */
>  static inline void register_nosave_region(unsigned long b, unsigned long e) {}
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index d2479c69d71a4..9d9d53828542f 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -106,11 +106,17 @@ bool hibernation_in_progress(void)
>  	return !atomic_read(&hibernate_atomic);
>  }
>  
> +__weak bool arch_hibernation_available(void)
> +{
> +	return true;
> +}
> +
>  bool hibernation_available(void)
>  {
>  	return nohibernate == 0 &&
>  		!security_locked_down(LOCKDOWN_HIBERNATION) &&
> -		!secretmem_active() && !cxl_mem_active();
> +		!secretmem_active() && !cxl_mem_active() &&
> +		arch_hibernation_available();
>  }

With the comments above addressed:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
