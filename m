Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B7C3C4742C
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 13:43:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D26920729
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 13:43:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D26920729
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9715D4B738;
	Thu,  5 Nov 2020 08:43:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EDm0PNaMIi+X; Thu,  5 Nov 2020 08:43:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 309E24B68E;
	Thu,  5 Nov 2020 08:43:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BB034B678
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 08:43:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ekj+6Foly6bP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 08:43:05 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F97D4B672
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 08:43:05 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B7A1142F;
 Thu,  5 Nov 2020 05:43:05 -0800 (PST)
Received: from [192.168.2.22] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 32CF63F719;
 Thu,  5 Nov 2020 05:43:04 -0800 (PST)
Subject: Re: [PATCH v2 5/5] KVM: arm64: implement the TRNG hypervisor call
From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
To: Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20201105125656.25259-1-andre.przywara@arm.com>
 <20201105125656.25259-6-andre.przywara@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <7ced3574-e428-009d-0197-3f9c942cb2a3@arm.com>
Date: Thu, 5 Nov 2020 13:41:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201105125656.25259-6-andre.przywara@arm.com>
Content-Language: en-GB
Cc: kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Marc, James, Julien, Suzuki,

argh, I am sorry, I forgot to CC: you guys on this patch. This is v2 of
Ard's original patch, fixing the endianess problem pointed out by Drew.

It's on the kvm-arm ML:
https://lists.cs.columbia.edu/pipermail/kvmarm/2020-November/043138.html
or here in my repo:
https://gitlab.arm.com/linux-arm/linux-ap/-/commits/smccc-trng/v2/

Apologies!

Cheers,
Andre

On 05/11/2020 12:56, Andre Przywara wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Provide a hypervisor implementation of the ARM architected TRNG firmware
> interface described in ARM spec DEN0098. All function IDs are implemented,
> including both 32-bit and 64-bit versions of the TRNG_RND service, which
> is the centerpiece of the API.
> 
> The API is backed by arch_get_unsigned_seed_long(), which is implemented
> in terms of RNDRRS currently, and will be alternatively backed by a SMC
> call to the secure firmware using same interface after a future patch.
> If neither are available, the kernel's entropy pool is used instead.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 +
>  arch/arm64/kvm/Makefile           |  2 +-
>  arch/arm64/kvm/hypercalls.c       |  6 ++
>  arch/arm64/kvm/trng.c             | 91 +++++++++++++++++++++++++++++++
>  4 files changed, 100 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/kvm/trng.c
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 781d029b8aa8..615932bacf76 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -652,4 +652,6 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>  #define kvm_arm_vcpu_sve_finalized(vcpu) \
>  	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
>  
> +int kvm_trng_call(struct kvm_vcpu *vcpu);
> +
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 1504c81fbf5d..a510037e3270 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -16,7 +16,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
>  	 inject_fault.o regmap.o va_layout.o handle_exit.o \
>  	 guest.o debug.o reset.o sys_regs.o \
>  	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
> -	 aarch32.o arch_timer.o \
> +	 aarch32.o arch_timer.o trng.o \
>  	 vgic/vgic.o vgic/vgic-init.o \
>  	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
>  	 vgic/vgic-v3.o vgic/vgic-v4.o \
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 25ea4ecb6449..ead21b98b620 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -71,6 +71,12 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  		if (gpa != GPA_INVALID)
>  			val = gpa;
>  		break;
> +	case ARM_SMCCC_TRNG_VERSION:
> +	case ARM_SMCCC_TRNG_FEATURES:
> +	case ARM_SMCCC_TRNG_GET_UUID:
> +	case ARM_SMCCC_TRNG_RND32:
> +	case ARM_SMCCC_TRNG_RND64:
> +		return kvm_trng_call(vcpu);
>  	default:
>  		return kvm_psci_call(vcpu);
>  	}
> diff --git a/arch/arm64/kvm/trng.c b/arch/arm64/kvm/trng.c
> new file mode 100644
> index 000000000000..5a27b2d99977
> --- /dev/null
> +++ b/arch/arm64/kvm/trng.c
> @@ -0,0 +1,91 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2020 Arm Ltd.
> +
> +#include <linux/arm-smccc.h>
> +#include <linux/kvm_host.h>
> +
> +#include <asm/kvm_emulate.h>
> +
> +#include <kvm/arm_hypercalls.h>
> +
> +#define ARM_SMCCC_TRNG_VERSION_1_0	0x10000UL
> +
> +#define TRNG_SUCCESS			0UL
> +#define TRNG_NOT_SUPPORTED		((unsigned long)-1)
> +#define TRNG_INVALID_PARAMETER		((unsigned long)-2)
> +#define TRNG_NO_ENTROPY			((unsigned long)-3)
> +
> +#define MAX_BITS32			96
> +#define MAX_BITS64			192
> +
> +static const uuid_t arm_smc_trng_uuid __aligned(4) = UUID_INIT(
> +	0x023534a2, 0xe0bc, 0x45ec, 0x95, 0xdd, 0x33, 0x34, 0xc1, 0xcc, 0x31, 0x89);
> +
> +static int kvm_trng_do_rnd(struct kvm_vcpu *vcpu, int size)
> +{
> +	u32 num_bits = smccc_get_arg1(vcpu);
> +	u64 bits[3];
> +	int i;
> +
> +	if (num_bits > 3 * size) {
> +		smccc_set_retval(vcpu, TRNG_INVALID_PARAMETER, 0, 0, 0);
> +		return 1;
> +	}
> +
> +	/* get as many bits as we need to fulfil the request */
> +	for (i = 0; i < DIV_ROUND_UP(num_bits, 64); i++)
> +		/* use the arm64 specific backend directly if one exists */
> +		if (!arch_get_random_seed_long((unsigned long *)&bits[i]))
> +			bits[i] = get_random_long();
> +
> +	if (num_bits % 64)
> +		bits[i - 1] &= U64_MAX >> (64 - (num_bits % 64));
> +
> +	while (i < ARRAY_SIZE(bits))
> +		bits[i++] = 0;
> +
> +	if (size == 32)
> +		smccc_set_retval(vcpu, TRNG_SUCCESS, lower_32_bits(bits[1]),
> +				 upper_32_bits(bits[0]), lower_32_bits(bits[0]));
> +	else
> +		smccc_set_retval(vcpu, TRNG_SUCCESS, bits[2], bits[1], bits[0]);
> +
> +	memzero_explicit(bits, sizeof(bits));
> +	return 1;
> +}
> +
> +int kvm_trng_call(struct kvm_vcpu *vcpu)
> +{
> +	const __le32 *u = (__le32 *)arm_smc_trng_uuid.b;
> +	u32 func_id = smccc_get_function(vcpu);
> +	unsigned long val = TRNG_NOT_SUPPORTED;
> +	int size = 64;
> +
> +	switch (func_id) {
> +	case ARM_SMCCC_TRNG_VERSION:
> +		val = ARM_SMCCC_TRNG_VERSION_1_0;
> +		break;
> +	case ARM_SMCCC_TRNG_FEATURES:
> +		switch (smccc_get_arg1(vcpu)) {
> +		case ARM_SMCCC_TRNG_VERSION:
> +		case ARM_SMCCC_TRNG_FEATURES:
> +		case ARM_SMCCC_TRNG_GET_UUID:
> +		case ARM_SMCCC_TRNG_RND32:
> +		case ARM_SMCCC_TRNG_RND64:
> +			val = TRNG_SUCCESS;
> +		}
> +		break;
> +	case ARM_SMCCC_TRNG_GET_UUID:
> +		smccc_set_retval(vcpu, le32_to_cpu(u[0]), le32_to_cpu(u[1]),
> +				 le32_to_cpu(u[2]), le32_to_cpu(u[3]));
> +		return 1;
> +	case ARM_SMCCC_TRNG_RND32:
> +		size = 32;
> +		fallthrough;
> +	case ARM_SMCCC_TRNG_RND64:
> +		return kvm_trng_do_rnd(vcpu, size);
> +	}
> +
> +	smccc_set_retval(vcpu, val, 0, 0, 0);
> +	return 1;
> +}
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
