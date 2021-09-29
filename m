Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DCA3C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 10:35:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B3B1761216
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 10:35:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B3B1761216
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BE744B136;
	Wed, 29 Sep 2021 06:35:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TizqYyDTMTK0; Wed, 29 Sep 2021 06:35:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8D794B126;
	Wed, 29 Sep 2021 06:35:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31C7F4B0DE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 06:35:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JogI17ddlBOB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 06:35:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 653D64B0DB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 06:35:49 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0138ED6E;
 Wed, 29 Sep 2021 03:35:49 -0700 (PDT)
Received: from [10.57.95.68] (unknown [10.57.95.68])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 918033F70D;
 Wed, 29 Sep 2021 03:35:47 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: Allow KVM to be disabled from the command line
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210903091652.985836-1-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <5bc623f2-e4c1-cc9c-683c-2f95648f1a68@arm.com>
Date: Wed, 29 Sep 2021 11:35:46 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210903091652.985836-1-maz@kernel.org>
Content-Language: en-GB
Cc: kernel-team@android.com
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

On 03/09/2021 10:16, Marc Zyngier wrote:
> Although KVM can be compiled out of the kernel, it cannot be disabled
> at runtime. Allow this possibility by introducing a new mode that
> will prevent KVM from initialising.
> 
> This is useful in the (limited) circumstances where you don't want
> KVM to be available (what is wrong with you?), or when you want
> to install another hypervisor instead (good luck with that).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   Documentation/admin-guide/kernel-parameters.txt |  3 +++
>   arch/arm64/include/asm/kvm_host.h               |  1 +
>   arch/arm64/kernel/idreg-override.c              |  1 +
>   arch/arm64/kvm/arm.c                            | 14 +++++++++++++-
>   4 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 91ba391f9b32..cc5f68846434 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2365,6 +2365,9 @@
>   	kvm-arm.mode=
>   			[KVM,ARM] Select one of KVM/arm64's modes of operation.
>   
> +			none: Forcefully disable KVM and run in nVHE mode,
> +			      preventing KVM from ever initialising.
> +
>   			nvhe: Standard nVHE-based mode, without support for
>   			      protected guests.
>   
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f8be56d5342b..019490c67976 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -58,6 +58,7 @@
>   enum kvm_mode {
>   	KVM_MODE_DEFAULT,
>   	KVM_MODE_PROTECTED,
> +	KVM_MODE_NONE,
>   };
>   enum kvm_mode kvm_get_mode(void);
>   
> diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
> index d8e606fe3c21..57013c1b6552 100644
> --- a/arch/arm64/kernel/idreg-override.c
> +++ b/arch/arm64/kernel/idreg-override.c
> @@ -95,6 +95,7 @@ static const struct {
>   	char	alias[FTR_ALIAS_NAME_LEN];
>   	char	feature[FTR_ALIAS_OPTION_LEN];
>   } aliases[] __initconst = {
> +	{ "kvm-arm.mode=none",		"id_aa64mmfr1.vh=0" },
>   	{ "kvm-arm.mode=nvhe",		"id_aa64mmfr1.vh=0" },
>   	{ "kvm-arm.mode=protected",	"id_aa64mmfr1.vh=0" },
>   	{ "arm64.nobti",		"id_aa64pfr1.bt=0" },
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index fe102cd2e518..cdc70e238316 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2064,6 +2064,11 @@ int kvm_arch_init(void *opaque)
>   		return -ENODEV;
>   	}
>   
> +	if (kvm_get_mode() == KVM_MODE_NONE) {
> +		kvm_info("KVM disabled from command line\n");
> +		return -ENODEV;
> +	}
> +
>   	in_hyp_mode = is_kernel_in_hyp_mode();
>   
>   	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
> @@ -2137,8 +2142,15 @@ static int __init early_kvm_mode_cfg(char *arg)
>   		return 0;
>   	}
>   
> -	if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode()))
> +	if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode())) {
> +		kvm_mode = KVM_MODE_DEFAULT;
>   		return 0;
> +	}
> +
> +	if (strcmp(arg, "none") == 0 && !WARN_ON(is_kernel_in_hyp_mode())) {

nit: Does this really need to WARN here ? Unlike the "nvhe" case, if the
user wants to keep the KVM out of the picture for, say debugging
something, it is perfectly Ok to allow the kernel to be running at EL2
without having to change the Firmware to alter the landing EL for the
kernel ?

Otherwise,

Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
