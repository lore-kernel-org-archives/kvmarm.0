From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 2/8] acpi: apei: handle SEI notification type for ARMv8
Date: Fri, 31 Mar 2017 17:20:26 +0100
Message-ID: <58DE81CA.3020803@arm.com>
References: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com> <1490869877-118713-3-git-send-email-xiexiuqi@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1490869877-118713-3-git-send-email-xiexiuqi@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Xie XiuQi <xiexiuqi@huawei.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, fu.wei@linaro.org, rostedt@goodmis.org, hanjun.guo@linaro.org, shiju.jose@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, gengdongjiu@huawei.com, zhengqiang10@huawei.com, wuquanming@huawei.com, wangxiongfeng2@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Xie XiuQi,

On 30/03/17 11:31, Xie XiuQi wrote:
> ARM APEI extension proposal added SEI (asynchronous SError interrupt)
> notification type for ARMv8.
> 
> Add a new GHES error source handling function for SEI. In firmware
> first mode, if an error source's notification type is SEI. Then GHES
> could parse and report the detail error information.

The APEI additions are unsafe until patch 4 as SEA can interrupt SEI and
deadlock while trying to take the same set of locks. This patch needs to be
after that interaction is fixed/prevented, or we should prevent it by adding a
depends-on-not to the Kconfig to prevent SEI and SEA being registered at the
same time. (as a short term fix).

(more comments on this on that later patch)


> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index e52be6a..53710a2 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c

> @@ -625,6 +627,14 @@ asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr)

bad_mode() is called in other scenarios too, for example executing an undefined
instruction at EL1. You split the SError path out of the vectors in patch 7, I
think we should do that here.


>  		handler[reason], smp_processor_id(), esr,
>  		esr_get_class_string(esr));
>  
> +	/*
> +	 * In firmware first mode, we could assume firmware will only generate one
> +	 * of cper records at a time. There is no risk for one cpu to parse ghes table.
> +	 */

I don't follow this comment, is this saying SError can't interrupt SError? We
already get this guarantee as the CPU masks SError when it takes an exception.

Firmware can generate multiple CPER records for a single 'event'. The CPER
records are the 'Data' in ACPI:Table 18-343 Generic Error Data Entry, and there
are 'zero or more' of these with a 'Generic Error Status Block' header that
describes the overall event. (Table 18-342).

I don't think we need this comment.


> +	if (IS_ENABLED(CONFIG_ACPI_APEI_SEI) && ESR_ELx_EC(esr) == ESR_ELx_EC_SERROR) {
> +		ghes_notify_sei();
> +	}

>  	die("Oops - bad mode", regs, 0);
>  	local_irq_disable();
>  	panic("bad mode");

Thanks,

James

