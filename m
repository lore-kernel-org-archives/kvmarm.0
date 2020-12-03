Return-Path: <SRS0=mzwA=FH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB11BC64E8A
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 10:43:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 03920208FE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 10:43:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03920208FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E9954B191;
	Thu,  3 Dec 2020 05:43:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6WFQkozWfAuC; Thu,  3 Dec 2020 05:43:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A2354B1CC;
	Thu,  3 Dec 2020 05:43:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D20A24B1C0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 05:43:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wEOvROmZVU0q for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2020 05:43:38 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A45464B175
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 05:43:38 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A77211D4;
 Thu,  3 Dec 2020 02:43:38 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.0.87])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6200F3F575;
 Thu,  3 Dec 2020 02:43:34 -0800 (PST)
Date: Thu, 3 Dec 2020 10:43:31 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v4 05/26] psci: Replace psci_function_id array with a
 struct
Message-ID: <20201203104331.GB96754@C02TD0UTHF1T.local>
References: <20201202184122.26046-1-dbrazdil@google.com>
 <20201202184122.26046-6-dbrazdil@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201202184122.26046-6-dbrazdil@google.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On Wed, Dec 02, 2020 at 06:41:01PM +0000, David Brazdil wrote:
> Small refactor that replaces array of v0.1 function IDs indexed by an
> enum of function-name constants with a struct of function IDs "indexed"
> by field names. This is done in preparation for exposing the IDs to
> other parts of the kernel. Exposing a struct avoids the need for
> bounds checking.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  drivers/firmware/psci/psci.c | 29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
> index 13b9ed71b446..593fdd0e09a2 100644
> --- a/drivers/firmware/psci/psci.c
> +++ b/drivers/firmware/psci/psci.c
> @@ -58,15 +58,14 @@ typedef unsigned long (psci_fn)(unsigned long, unsigned long,
>  				unsigned long, unsigned long);
>  static psci_fn *invoke_psci_fn;
>  
> -enum psci_function {
> -	PSCI_FN_CPU_SUSPEND,
> -	PSCI_FN_CPU_ON,
> -	PSCI_FN_CPU_OFF,
> -	PSCI_FN_MIGRATE,
> -	PSCI_FN_MAX,
> +struct psci_0_1_function_ids {
> +	u32 cpu_suspend;
> +	u32 cpu_on;
> +	u32 cpu_off;
> +	u32 migrate;
>  };
>  
> -static u32 psci_function_id[PSCI_FN_MAX];
> +static struct psci_0_1_function_ids psci_0_1_function_ids;
>  
>  #define PSCI_0_2_POWER_STATE_MASK		\
>  				(PSCI_0_2_POWER_STATE_ID_MASK | \
> @@ -178,7 +177,7 @@ static int __psci_cpu_suspend(u32 fn, u32 state, unsigned long entry_point)
>  
>  static int psci_0_1_cpu_suspend(u32 state, unsigned long entry_point)
>  {
> -	return __psci_cpu_suspend(psci_function_id[PSCI_FN_CPU_SUSPEND],
> +	return __psci_cpu_suspend(psci_0_1_function_ids.cpu_suspend,
>  				  state, entry_point);
>  }
>  
> @@ -198,7 +197,7 @@ static int __psci_cpu_off(u32 fn, u32 state)
>  
>  static int psci_0_1_cpu_off(u32 state)
>  {
> -	return __psci_cpu_off(psci_function_id[PSCI_FN_CPU_OFF], state);
> +	return __psci_cpu_off(psci_0_1_function_ids.cpu_off, state);
>  }
>  
>  static int psci_0_2_cpu_off(u32 state)
> @@ -216,7 +215,7 @@ static int __psci_cpu_on(u32 fn, unsigned long cpuid, unsigned long entry_point)
>  
>  static int psci_0_1_cpu_on(unsigned long cpuid, unsigned long entry_point)
>  {
> -	return __psci_cpu_on(psci_function_id[PSCI_FN_CPU_ON], cpuid, entry_point);
> +	return __psci_cpu_on(psci_0_1_function_ids.cpu_on, cpuid, entry_point);
>  }
>  
>  static int psci_0_2_cpu_on(unsigned long cpuid, unsigned long entry_point)
> @@ -234,7 +233,7 @@ static int __psci_migrate(u32 fn, unsigned long cpuid)
>  
>  static int psci_0_1_migrate(unsigned long cpuid)
>  {
> -	return __psci_migrate(psci_function_id[PSCI_FN_MIGRATE], cpuid);
> +	return __psci_migrate(psci_0_1_function_ids.migrate, cpuid);
>  }
>  
>  static int psci_0_2_migrate(unsigned long cpuid)
> @@ -548,22 +547,22 @@ static int __init psci_0_1_init(struct device_node *np)
>  	psci_ops.get_version = psci_0_1_get_version;
>  
>  	if (!of_property_read_u32(np, "cpu_suspend", &id)) {
> -		psci_function_id[PSCI_FN_CPU_SUSPEND] = id;
> +		psci_0_1_function_ids.cpu_suspend = id;
>  		psci_ops.cpu_suspend = psci_0_1_cpu_suspend;
>  	}
>  
>  	if (!of_property_read_u32(np, "cpu_off", &id)) {
> -		psci_function_id[PSCI_FN_CPU_OFF] = id;
> +		psci_0_1_function_ids.cpu_off = id;
>  		psci_ops.cpu_off = psci_0_1_cpu_off;
>  	}
>  
>  	if (!of_property_read_u32(np, "cpu_on", &id)) {
> -		psci_function_id[PSCI_FN_CPU_ON] = id;
> +		psci_0_1_function_ids.cpu_on = id;
>  		psci_ops.cpu_on = psci_0_1_cpu_on;
>  	}
>  
>  	if (!of_property_read_u32(np, "migrate", &id)) {
> -		psci_function_id[PSCI_FN_MIGRATE] = id;
> +		psci_0_1_function_ids.migrate = id;
>  		psci_ops.migrate = psci_0_1_migrate;
>  	}
>  
> -- 
> 2.29.2.454.gaff20da3a2-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
