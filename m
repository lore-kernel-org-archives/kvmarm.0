Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6255EC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 09:13:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B614A49F49;
	Fri,  4 Nov 2022 05:13:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T3dHVZGvyhVI; Fri,  4 Nov 2022 05:13:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 388FC4B086;
	Fri,  4 Nov 2022 05:13:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E69E14A1B0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 05:13:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dAEAM4bmG0ak for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 05:13:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60F2F49F49
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 05:13:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D87C61FB;
 Fri,  4 Nov 2022 02:13:25 -0700 (PDT)
Received: from [10.1.27.15] (e122027.cambridge.arm.com [10.1.27.15])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0AAE83F703;
 Fri,  4 Nov 2022 02:13:16 -0700 (PDT)
Message-ID: <55b704b7-0a44-8f34-e22f-d60b58db610f@arm.com>
Date: Fri, 4 Nov 2022 09:13:14 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] arm64: paravirt: remove conduit check in
 has_pv_steal_clock
To: Usama Arif <usama.arif@bytedance.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux@armlinux.org.uk, yezengruan@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, maz@kernel.org, mark.rutland@arm.com
References: <20221104061659.4116508-1-usama.arif@bytedance.com>
Content-Language: en-GB
From: Steven Price <steven.price@arm.com>
In-Reply-To: <20221104061659.4116508-1-usama.arif@bytedance.com>
Cc: punit.agrawal@bytedance.com, fam.zheng@bytedance.com, liangma@liangbit.com
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

On 04/11/2022 06:16, Usama Arif wrote:
> arm_smccc_1_1_invoke() which is called later on in the function
> will return failure if there's no conduit (or pre-SMCCC 1.1),
> hence the check is unnecessary.
> 
> Suggested-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>  arch/arm64/kernel/paravirt.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
> index 57c7c211f8c7..aa718d6a9274 100644
> --- a/arch/arm64/kernel/paravirt.c
> +++ b/arch/arm64/kernel/paravirt.c
> @@ -141,10 +141,6 @@ static bool __init has_pv_steal_clock(void)
>  {
>  	struct arm_smccc_res res;
>  
> -	/* To detect the presence of PV time support we require SMCCC 1.1+ */
> -	if (arm_smccc_1_1_get_conduit() == SMCCC_CONDUIT_NONE)
> -		return false;
> -
>  	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
>  			     ARM_SMCCC_HV_PV_TIME_FEATURES, &res);
>  

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
