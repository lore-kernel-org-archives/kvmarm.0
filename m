Return-Path: <SRS0=/Ra0=HH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2182C433E0
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 09:10:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DEC4564FC7
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 09:10:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEC4564FC7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40FFF4B398;
	Fri,  5 Feb 2021 04:10:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TisAbAxjE-gv; Fri,  5 Feb 2021 04:10:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C23ED4B36E;
	Fri,  5 Feb 2021 04:10:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDA5F4B35C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 04:10:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uZGFn5m+PvMV for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2021 04:10:53 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60B3A4B366
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 04:10:53 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8964731B;
 Fri,  5 Feb 2021 01:10:52 -0800 (PST)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC14D3F73B;
 Fri,  5 Feb 2021 01:10:48 -0800 (PST)
Subject: Re: [PATCH v17 1/7] arm/arm64: Probe for the presence of KVM
 hypervisor
To: Marc Zyngier <maz@kernel.org>, netdev@vger.kernel.org, yangbo.lu@nxp.com, 
 john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com,
 seanjc@google.com, richardcochran@gmail.com, Mark.Rutland@arm.com,
 will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com
References: <20210202141204.3134855-1-maz@kernel.org>
 <20210202141204.3134855-2-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <d5765ade-7199-2d1e-6d59-d3de6a52c6ce@arm.com>
Date: Fri, 5 Feb 2021 09:11:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210202141204.3134855-2-maz@kernel.org>
Content-Language: en-GB
Cc: justin.he@arm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 02/02/2021 14:11, Marc Zyngier wrote:
> From: Will Deacon <will@kernel.org>
> 
> Although the SMCCC specification provides some limited functionality for
> describing the presence of hypervisor and firmware services, this is
> generally applicable only to functions designated as "Arm Architecture
> Service Functions" and no portable discovery mechanism is provided for
> standard hypervisor services, despite having a designated range of
> function identifiers reserved by the specification.
> 
> In an attempt to avoid the need for additional firmware changes every
> time a new function is added, introduce a UID to identify the service
> provider as being compatible with KVM. Once this has been established,
> additional services can be discovered via a feature bitmap.
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> [maz: move code to its own file, plug it into PSCI]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20201209060932.212364-2-jianyong.wu@arm.com
> ---
>   arch/arm/include/asm/hypervisor.h   |  3 ++
>   arch/arm64/include/asm/hypervisor.h |  3 ++
>   drivers/firmware/psci/psci.c        |  2 ++
>   drivers/firmware/smccc/Makefile     |  2 +-
>   drivers/firmware/smccc/kvm_guest.c  | 51 +++++++++++++++++++++++++++++
>   drivers/firmware/smccc/smccc.c      |  1 +
>   include/linux/arm-smccc.h           | 25 ++++++++++++++
>   7 files changed, 86 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/firmware/smccc/kvm_guest.c
> 
> diff --git a/arch/arm/include/asm/hypervisor.h b/arch/arm/include/asm/hypervisor.h
> index df8524365637..bd61502b9715 100644
> --- a/arch/arm/include/asm/hypervisor.h
> +++ b/arch/arm/include/asm/hypervisor.h
> @@ -4,4 +4,7 @@
>   
>   #include <asm/xen/hypervisor.h>
>   
> +void kvm_init_hyp_services(void);
> +bool kvm_arm_hyp_service_available(u32 func_id);
> +
>   #endif
> diff --git a/arch/arm64/include/asm/hypervisor.h b/arch/arm64/include/asm/hypervisor.h
> index f9cc1d021791..0ae427f352c8 100644
> --- a/arch/arm64/include/asm/hypervisor.h
> +++ b/arch/arm64/include/asm/hypervisor.h
> @@ -4,4 +4,7 @@
>   
>   #include <asm/xen/hypervisor.h>
>   
> +void kvm_init_hyp_services(void);
> +bool kvm_arm_hyp_service_available(u32 func_id);
> +
>   #endif
> diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
> index f5fc429cae3f..69e296f02902 100644
> --- a/drivers/firmware/psci/psci.c
> +++ b/drivers/firmware/psci/psci.c
> @@ -23,6 +23,7 @@
>   
>   #include <asm/cpuidle.h>
>   #include <asm/cputype.h>
> +#include <asm/hypervisor.h>
>   #include <asm/system_misc.h>
>   #include <asm/smp_plat.h>
>   #include <asm/suspend.h>
> @@ -498,6 +499,7 @@ static int __init psci_probe(void)
>   		psci_init_cpu_suspend();
>   		psci_init_system_suspend();
>   		psci_init_system_reset2();
> +		kvm_init_hyp_services();
>   	}
>   
>   	return 0;
> diff --git a/drivers/firmware/smccc/Makefile b/drivers/firmware/smccc/Makefile
> index 72ab84042832..40d19144a860 100644
> --- a/drivers/firmware/smccc/Makefile
> +++ b/drivers/firmware/smccc/Makefile
> @@ -1,4 +1,4 @@
>   # SPDX-License-Identifier: GPL-2.0
>   #
> -obj-$(CONFIG_HAVE_ARM_SMCCC_DISCOVERY)	+= smccc.o
> +obj-$(CONFIG_HAVE_ARM_SMCCC_DISCOVERY)	+= smccc.o kvm_guest.o
>   obj-$(CONFIG_ARM_SMCCC_SOC_ID)	+= soc_id.o
> diff --git a/drivers/firmware/smccc/kvm_guest.c b/drivers/firmware/smccc/kvm_guest.c
> new file mode 100644
> index 000000000000..23ce1ded88b4
> --- /dev/null
> +++ b/drivers/firmware/smccc/kvm_guest.c
> @@ -0,0 +1,51 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#define pr_fmt(fmt) "smccc: KVM: " fmt
> +
> +#include <linux/init.h>
> +#include <linux/arm-smccc.h>
> +#include <linux/kernel.h>
> +#include <linux/string.h>
> +
> +static DECLARE_BITMAP(__kvm_arm_hyp_services, ARM_SMCCC_KVM_NUM_FUNCS) __ro_after_init = { };
> +
> +void __init kvm_init_hyp_services(void)
> +{
> +	int i;
> +	struct arm_smccc_res res;
> +
> +	if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_HVC)
> +		return;
> +
> +	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID, &res);
> +	if (res.a0 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0 ||
> +	    res.a1 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1 ||
> +	    res.a2 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2 ||
> +	    res.a3 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3)
> +		return;
> +
> +	memset(&res, 0, sizeof(res));
> +	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID, &res);
> +	for (i = 0; i < 32; ++i) {
> +		if (res.a0 & (i))
> +			set_bit(i + (32 * 0), __kvm_arm_hyp_services);
> +		if (res.a1 & (i))
> +			set_bit(i + (32 * 1), __kvm_arm_hyp_services);
> +		if (res.a2 & (i))
> +			set_bit(i + (32 * 2), __kvm_arm_hyp_services);
> +		if (res.a3 & (i))
> +			set_bit(i + (32 * 3), __kvm_arm_hyp_services);

The bit shifts are missing, the tests should be of the form:

	if (res.a0 & (1 << i))

Or indeed using a BIT() macro.

Steve

> +	}
> +
> +	pr_info("hypervisor services detected (0x%08lx 0x%08lx 0x%08lx 0x%08lx)\n",
> +		 res.a3, res.a2, res.a1, res.a0);
> +}
> +
> +bool kvm_arm_hyp_service_available(u32 func_id)
> +{
> +	if (func_id >= ARM_SMCCC_KVM_NUM_FUNCS)
> +		return -EINVAL;
> +
> +	return test_bit(func_id, __kvm_arm_hyp_services);
> +}
> +EXPORT_SYMBOL_GPL(kvm_arm_hyp_service_available);
> diff --git a/drivers/firmware/smccc/smccc.c b/drivers/firmware/smccc/smccc.c
> index 00c88b809c0c..94eca6ffda05 100644
> --- a/drivers/firmware/smccc/smccc.c
> +++ b/drivers/firmware/smccc/smccc.c
> @@ -7,6 +7,7 @@
>   
>   #include <linux/init.h>
>   #include <linux/arm-smccc.h>
> +#include <linux/kernel.h>
>   
>   static u32 smccc_version = ARM_SMCCC_VERSION_1_0;
>   static enum arm_smccc_conduit smccc_conduit = SMCCC_CONDUIT_NONE;
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index f860645f6512..74e90b65b489 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -55,6 +55,8 @@
>   #define ARM_SMCCC_OWNER_TRUSTED_OS	50
>   #define ARM_SMCCC_OWNER_TRUSTED_OS_END	63
>   
> +#define ARM_SMCCC_FUNC_QUERY_CALL_UID  0xff01
> +
>   #define ARM_SMCCC_QUIRK_NONE		0
>   #define ARM_SMCCC_QUIRK_QCOM_A6		1 /* Save/restore register a6 */
>   
> @@ -87,6 +89,29 @@
>   			   ARM_SMCCC_SMC_32,				\
>   			   0, 0x7fff)
>   
> +#define ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_32,				\
> +			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
> +			   ARM_SMCCC_FUNC_QUERY_CALL_UID)
> +
> +/* KVM UID value: 28b46fb6-2ec5-11e9-a9ca-4b564d003a74 */
> +#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0	0xb66fb428U
> +#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1	0xe911c52eU
> +#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2	0x564bcaa9U
> +#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3	0x743a004dU
> +
> +/* KVM "vendor specific" services */
> +#define ARM_SMCCC_KVM_FUNC_FEATURES		0
> +#define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
> +#define ARM_SMCCC_KVM_NUM_FUNCS			128
> +
> +#define ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID			\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_32,				\
> +			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
> +			   ARM_SMCCC_KVM_FUNC_FEATURES)
> +
>   #define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1
>   
>   /* Paravirtualised time calls (defined by ARM DEN0057A) */
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
