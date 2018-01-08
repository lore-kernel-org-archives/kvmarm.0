From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [PATCH] arm64: Implement branch predictor hardening for Falkor
Date: Mon, 8 Jan 2018 11:22:53 -0600
Message-ID: <53924fb5-e5d6-69d7-0042-3a7eb8febc32@codeaurora.org>
References: <1515184139-23743-1-git-send-email-shankerd@codeaurora.org>
 <20180108092849.alfqtsmaf2dqakkr@kamzik.brq.redhat.com>
Reply-To: shankerd@codeaurora.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B45E549DD9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jan 2018 12:18:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RHxYJZuHnov6 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jan 2018 12:18:17 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C087B49DBD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jan 2018 12:18:17 -0500 (EST)
In-Reply-To: <20180108092849.alfqtsmaf2dqakkr@kamzik.brq.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Sean Campbell <scampbel@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andrew,

On 01/08/2018 03:28 AM, Andrew Jones wrote:
> Hi Shanker,
> 
> On Fri, Jan 05, 2018 at 02:28:59PM -0600, Shanker Donthineni wrote:
> ...
>> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
>> index cb0fb37..daf53a5 100644
>> --- a/arch/arm64/kernel/cpu_errata.c
>> +++ b/arch/arm64/kernel/cpu_errata.c
>> @@ -54,6 +54,8 @@ static int cpu_enable_trap_ctr_access(void *__unused)
>>  
>>  #ifdef CONFIG_KVM
>>  extern char __psci_hyp_bp_inval_start[], __psci_hyp_bp_inval_end[];
>> +extern char __qcom_hyp_sanitize_link_stack_start[];
>> +extern char __qcom_hyp_sanitize_link_stack_end[];
>>  
>>  static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
>>  				const char *hyp_vecs_end)
>> @@ -96,8 +98,10 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
>>  	spin_unlock(&bp_lock);
>>  }
>>  #else
>> -#define __psci_hyp_bp_inval_start	NULL
>> -#define __psci_hyp_bp_inval_end		NULL
>> +#define __psci_hyp_bp_inval_start	   	NULL
>> +#define __psci_hyp_bp_inval_end			NULL
>> +#define __qcom_hyp_sanitize_link_stack_start	NULL
>> +#define __qcom_hyp_sanitize_link_stack_start	NULL
>                                           ^^ copy+paste error here

Thanks for catching typo, I'll fix in v2 patch. 

> 
> Thanks,
> drew
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Shanker Donthineni
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
