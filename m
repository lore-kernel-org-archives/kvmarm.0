Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C949F2EBBAF
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 06:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768459671; cv=none; b=YRmlRq9AS4ESo04UvtLl3WO/Ufbgg6OwCAXfpHc/snqEnB1bwek2j5zX9Vr3u8JoIhlDDyjjmxlb8aRxZCX5v5yZU9TUDOnMNgD0/TmSmP6FzHp2NSSOfGzTQ26h0E+PkfQORvP44uJAh/L4B5jirkGAdUTxvaxZRhU5f8JgYe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768459671; c=relaxed/simple;
	bh=bcMrJ7ipt8qpsl8cVKBp9DwvTdrRr5IWX8zl8lWLwkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jirlnhHWlo3QmoSBASJ5G2RiLZdLmIunZCqMbkQ4OMTIgUvDAJJRh+1zk8DzG7WkTzapEXrCJsvKxf6YjC5rks3cVg31mEtkYtO9LAh/PpO2USsuOjUaDVUIacAlj+lhPN3wNPIuCZ63cjqgFv8d4xJK6ZzKd6tYJfkUPy1IvR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eD2yeYp9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eD2yeYp9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768459666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DVGRYSJE6r9drCGU0tuZ5wClI+1Q/rZ9cJ9pzodJ08w=;
	b=eD2yeYp91zIRZbS+cGGavac4aR3+FzlCPjza07fB0MmSQkEyIkT5M835fkYHNGHMyd5p7t
	kNYvKbnrk/tPJWmhpFueV39VymldeYRETTjjCWEO9BPrDBsLUsp1OCN8E9x9xSAIfdHKnr
	WfyyflD51Szxu3H36XT+RuaFPtUkME4=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-Jpma6SLyO0qGqkCECk22lg-1; Thu, 15 Jan 2026 01:47:45 -0500
X-MC-Unique: Jpma6SLyO0qGqkCECk22lg-1
X-Mimecast-MFC-AGG-ID: Jpma6SLyO0qGqkCECk22lg_1768459664
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34c48a76e75so600389a91.1
        for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 22:47:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768459664; x=1769064464;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DVGRYSJE6r9drCGU0tuZ5wClI+1Q/rZ9cJ9pzodJ08w=;
        b=uyFKCtDEfxkKrPJJh7THPINFQlc8NHh768yF0h4qmIaDtLJDLPf0EuYHE6+kaFVAcZ
         CzmxdlVfu01rUuDtbgn5u7a6bIo3DTvdDGtH+MOthWLOnuDJBJnqEd2rNal8DmyzSREg
         giVYoli+v2fSpTuOtgapFxfvHZ42et8xJkh/bJVv/XqYLaJFa5eBmfLDiVQo9oUsYVG/
         kzpBoNbzy1+6IG1jKf/2qG8KxJnjwR7armVUyC2sK1TDOC5cSDIOPSU8MviptWLhQl9V
         HU2O17IvhszOnhFR+jPPi+B4AqfbyfQXZ0Nz1FuUHKGiJyXUsopO2dKmDUlT2v7Js5pJ
         iNgA==
X-Forwarded-Encrypted: i=1; AJvYcCWt3XccQSsQ2PTbTVyENpfPXBAAyPWOasOk0apYiaxOZ0hVJ6c0fBpZOrsvE+AyYcm+fNeKTkY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxS3Nx+Y9NTvM1uH7jjtHnE7+4FL6BWZ5rpAKwEhFLnQPwzENvT
	7h3YWhiwMUH+7FcwFYDhsMyWW3nk1Xun/duwSQqzQRg1RU3pjmzTUEqg+6dENtXDW3CjBBJu3St
	rhK1LvquAI2uET5TGMAoXp/IVEnFWma9iIewockdDg2kXP9VBuuyuG0v8AQ==
X-Gm-Gg: AY/fxX4D0AHgVeNjXA+tqr+LIxLTv65BkYG3Qoy19k5kO+2RU1MvxH4JlLMXD3B5DcM
	0QFgRC9r28WVylO8m39Q7sEl7p5g7DMUQRTnuNaHMbEc37D6+9pXlIUH7E7tE+7b5ksejXlJT0f
	wQpQ/F+x6ucm0nDjaF6+jwHEzl4bEK608aPV/Y0RUoNXDpkFrkfm4M0yEcBkHsAa2WKVuPDvrEr
	y6S3tPQJdG0imJS9I2EGWPW8ws5BE1YctQO2G2TWgBOVdHjAgYvso9eO3ZuZUMjOiEkGU1nk04s
	YOFKUWCxbRlR5KeWocLw2C980lVLBKssUAKtI8Wup0TMn1xBJ1oYukaiZPubNQLmJRfLDD7vRQM
	pBy/Kdxjgi5M=
X-Received: by 2002:a17:90a:dfce:b0:34a:47d0:9a82 with SMTP id 98e67ed59e1d1-3510b1267c2mr5053371a91.23.1768459664005;
        Wed, 14 Jan 2026 22:47:44 -0800 (PST)
X-Received: by 2002:a17:90a:dfce:b0:34a:47d0:9a82 with SMTP id 98e67ed59e1d1-3510b1267c2mr5053339a91.23.1768459663556;
        Wed, 14 Jan 2026 22:47:43 -0800 (PST)
Received: from [10.72.112.168] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-352678c6dbesm1149011a91.16.2026.01.14.22.47.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 22:47:42 -0800 (PST)
Message-ID: <12779ebc-1928-42db-8a44-ee97e2a58fd1@redhat.com>
Date: Thu, 15 Jan 2026 14:47:28 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/47] arm64: mpam: Context switch the MPAM registers
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-7-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260112165914.4086692-7-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YgqEOjKaNAfCVpUwt4oss36h_gE4rh06R1T8wW9OiAA_1768459664
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ben,

On 1/13/26 12:58 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> MPAM allows traffic in the SoC to be labeled by the OS, these labels are
> used to apply policy in caches and bandwidth regulators, and to monitor
> traffic in the SoC. The label is made up of a PARTID and PMG value. The x86
> equivalent calls these CLOSID and RMID, but they don't map precisely.
> 
> MPAM has two CPU system registers that is used to hold the PARTID and PMG
> values that traffic generated at each exception level will use. These can
> be set per-task by the resctrl file system. (resctrl is the defacto
> interface for controlling this stuff).
> 
> Add a helper to switch this.
> 
> struct task_struct's separate CLOSID and RMID fields are insufficient to
> implement resctrl using MPAM, as resctrl can change the PARTID (CLOSID) and
> PMG (sort of like the RMID) separately. On x86, the rmid is an independent
> number, so a race that writes a mismatched closid and rmid into hardware is
> benign. On arm64, the pmg bits extend the partid.
> (i.e. partid-5 has a pmg-0 that is not the same as partid-6's pmg-0).  In
> this case, mismatching the values will 'dirty' a pmg value that resctrl
> believes is clean, and is not tracking with its 'limbo' code.
> 
> To avoid this, the partid and pmg are always read and written as a
> pair. This requires a new u64 field. In struct task_struct there are two
> u32, rmid and closid for the x86 case, but as we can't use them here do
> something else. Add this new field, mpam_partid_pmg, to struct thread_info
> to avoid adding more architecture specific code to struct task_struct.
> Always use READ_ONCE()/WRITE_ONCE() when accessing this field.
> 
> Resctrl allows a per-cpu 'default' value to be set, this overrides the
> values when scheduling a task in the default control-group, which has
> PARTID 0. The way 'code data prioritisation' gets emulated means the
> register value for the default group needs to be a variable.
> 
> The current system register value is kept in a per-cpu variable to avoid
> writing to the system register if the value isn't going to change.  Writes
> to this register may reset the hardware state for regulating bandwidth.
> 
> Finally, there is no reason to context switch these registers unless there
> is a driver changing the values in struct task_struct. Hide the whole thing
> behind a static key. This also allows the driver to disable MPAM in
> response to errors reported by hardware. Move the existing static key to
> belong to the arch code, as in the future the MPAM driver may become a
> loadable module.
> 
> All this should depend on whether there is an MPAM driver, hide it behind
> CONFIG_ARM64_MPAM.
> 
> CC: Amit Singh Tomar <amitsinght@marvell.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> CONFIG_MPAM -> CONFIG_ARM64_MPAM in commit message
> Remove extra DECLARE_STATIC_KEY_FALSE
> Function name in comment, __mpam_sched_in() -> mpam_thread_switch()
> Remove unused headers
> Expand comment (Jonathan)
> 
> Changes since v2:
> Tidy up ifdefs
> ---
>   arch/arm64/Kconfig                   |  2 +
>   arch/arm64/include/asm/mpam.h        | 67 ++++++++++++++++++++++++++++
>   arch/arm64/include/asm/thread_info.h |  3 ++
>   arch/arm64/kernel/Makefile           |  1 +
>   arch/arm64/kernel/mpam.c             | 13 ++++++
>   arch/arm64/kernel/process.c          |  7 +++
>   drivers/resctrl/mpam_devices.c       |  2 -
>   drivers/resctrl/mpam_internal.h      |  4 +-
>   8 files changed, 95 insertions(+), 4 deletions(-)
>   create mode 100644 arch/arm64/include/asm/mpam.h
>   create mode 100644 arch/arm64/kernel/mpam.c
> 

With the following nitpick addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 93173f0a09c7..cdcc5b76a110 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -2049,6 +2049,8 @@ config ARM64_MPAM
>   
>   	  MPAM is exposed to user-space via the resctrl pseudo filesystem.
>   
> +	  This option enables the extra context switch code.
> +
>   endmenu # "ARMv8.4 architectural features"
>   
>   menu "ARMv8.5 architectural features"
> diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
> new file mode 100644
> index 000000000000..14011e5970ce
> --- /dev/null
> +++ b/arch/arm64/include/asm/mpam.h
> @@ -0,0 +1,67 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2025 Arm Ltd. */
> +
> +#ifndef __ASM__MPAM_H
> +#define __ASM__MPAM_H
> +
> +#include <linux/jump_label.h>
> +#include <linux/percpu.h>
> +#include <linux/sched.h>
> +
> +#include <asm/sysreg.h>
> +
> +DECLARE_STATIC_KEY_FALSE(mpam_enabled);
> +DECLARE_PER_CPU(u64, arm64_mpam_default);
> +DECLARE_PER_CPU(u64, arm64_mpam_current);
> +
> +/*
> + * The value of the MPAM0_EL1 sysreg when a task is in resctrl's default group.
> + * This is used by the context switch code to use the resctrl CPU property
> + * instead. The value is modified when CDP is enabled/disabled by mounting
> + * the resctrl filesystem.
> + */
> +extern u64 arm64_mpam_global_default;
> +
> +/*
> + * The resctrl filesystem writes to the partid/pmg values for threads and CPUs,
> + * which may race with reads in mpam_thread_switch(). Ensure only one of the old
> + * or new values are used. Particular care should be taken with the pmg field as
> + * mpam_thread_switch() may read a partid and pmg that don't match, causing this
> + * value to be stored with cache allocations, despite being considered 'free' by
> + * resctrl.
> + */
> +#ifdef CONFIG_ARM64_MPAM
> +static inline u64 mpam_get_regval(struct task_struct *tsk)
> +{
> +	return READ_ONCE(task_thread_info(tsk)->mpam_partid_pmg);
> +}
> +
> +static inline void mpam_thread_switch(struct task_struct *tsk)
> +{
> +	u64 oldregval;
> +	int cpu = smp_processor_id();
> +	u64 regval = mpam_get_regval(tsk);
> +
> +	if (!static_branch_likely(&mpam_enabled))
> +		return;
> +
> +	if (regval == READ_ONCE(arm64_mpam_global_default))
> +		regval = READ_ONCE(per_cpu(arm64_mpam_default, cpu));
> +
> +	oldregval = READ_ONCE(per_cpu(arm64_mpam_current, cpu));
> +	if (oldregval == regval)
> +		return;
> +
> +	write_sysreg_s(regval, SYS_MPAM1_EL1);
> +	isb();
> +
> +	/* Synchronising the EL0 write is left until the ERET to EL0 */
> +	write_sysreg_s(regval, SYS_MPAM0_EL1);
> +
> +	WRITE_ONCE(per_cpu(arm64_mpam_current, cpu), regval);
> +}
> +#else
> +static inline void mpam_thread_switch(struct task_struct *tsk) {}
> +#endif /* CONFIG_ARM64_MPAM */
> +
> +#endif /* __ASM__MPAM_H */
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index a803b887b0b4..fc801a26ff9e 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -41,6 +41,9 @@ struct thread_info {
>   #ifdef CONFIG_SHADOW_CALL_STACK
>   	void			*scs_base;
>   	void			*scs_sp;
> +#endif
> +#ifdef CONFIG_ARM64_MPAM
> +	u64			mpam_partid_pmg;
>   #endif
>   	u32			cpu;
>   };
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 76f32e424065..15979f366519 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -67,6 +67,7 @@ obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
>   obj-$(CONFIG_VMCORE_INFO)		+= vmcore_info.o
>   obj-$(CONFIG_ARM_SDE_INTERFACE)		+= sdei.o
>   obj-$(CONFIG_ARM64_PTR_AUTH)		+= pointer_auth.o
> +obj-$(CONFIG_ARM64_MPAM)		+= mpam.o
>   obj-$(CONFIG_ARM64_MTE)			+= mte.o
>   obj-y					+= vdso-wrap.o
>   obj-$(CONFIG_COMPAT_VDSO)		+= vdso32-wrap.o
> diff --git a/arch/arm64/kernel/mpam.c b/arch/arm64/kernel/mpam.c
> new file mode 100644
> index 000000000000..9866d2ca0faa
> --- /dev/null
> +++ b/arch/arm64/kernel/mpam.c
> @@ -0,0 +1,13 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2025 Arm Ltd. */
> +
> +#include <asm/mpam.h>
> +
> +#include <linux/jump_label.h>
> +#include <linux/percpu.h>
> +

Nitpick: Needn't include those two header files since they have been included
to <asm/mpam.h>
  
> +DEFINE_STATIC_KEY_FALSE(mpam_enabled);
> +DEFINE_PER_CPU(u64, arm64_mpam_default);
> +DEFINE_PER_CPU(u64, arm64_mpam_current);
> +
> +u64 arm64_mpam_global_default;
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 489554931231..47698955fa1e 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -51,6 +51,7 @@
>   #include <asm/fpsimd.h>
>   #include <asm/gcs.h>
>   #include <asm/mmu_context.h>
> +#include <asm/mpam.h>
>   #include <asm/mte.h>
>   #include <asm/processor.h>
>   #include <asm/pointer_auth.h>
> @@ -738,6 +739,12 @@ struct task_struct *__switch_to(struct task_struct *prev,
>   	if (prev->thread.sctlr_user != next->thread.sctlr_user)
>   		update_sctlr_el1(next->thread.sctlr_user);
>   
> +	/*
> +	 * MPAM thread switch happens after the DSB to ensure prev's accesses
> +	 * use prev's MPAM settings.
> +	 */
> +	mpam_thread_switch(next);
> +
>   	/* the actual thread switch */
>   	last = cpu_switch_to(prev, next);
>   
> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
> index b495d5291868..860181266b15 100644
> --- a/drivers/resctrl/mpam_devices.c
> +++ b/drivers/resctrl/mpam_devices.c
> @@ -29,8 +29,6 @@
>   
>   #include "mpam_internal.h"
>   
> -DEFINE_STATIC_KEY_FALSE(mpam_enabled); /* This moves to arch code */
> -
>   /*
>    * mpam_list_lock protects the SRCU lists when writing. Once the
>    * mpam_enabled key is enabled these lists are read-only,
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
> index e8971842b124..4632985bcca6 100644
> --- a/drivers/resctrl/mpam_internal.h
> +++ b/drivers/resctrl/mpam_internal.h
> @@ -16,12 +16,12 @@
>   #include <linux/srcu.h>
>   #include <linux/types.h>
>   
> +#include <asm/mpam.h>
> +
>   #define MPAM_MSC_MAX_NUM_RIS	16
>   
>   struct platform_device;
>   
> -DECLARE_STATIC_KEY_FALSE(mpam_enabled);
> -
>   #ifdef CONFIG_MPAM_KUNIT_TEST
>   #define PACKED_FOR_KUNIT __packed
>   #else

Thanks,
Gavin

