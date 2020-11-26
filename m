Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC65C63697
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 17:25:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E665721D46
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 17:25:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E665721D46
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4569F4C063;
	Thu, 26 Nov 2020 12:25:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wyHJmPFGv+OH; Thu, 26 Nov 2020 12:24:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FFCD4C066;
	Thu, 26 Nov 2020 12:24:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 307A94C05D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 12:24:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b03TX671uw6s for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 12:24:57 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1035E4C03E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 12:24:57 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF47031B;
 Thu, 26 Nov 2020 09:24:56 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.30.234])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 350C13F23F;
 Thu, 26 Nov 2020 09:24:53 -0800 (PST)
Date: Thu, 26 Nov 2020 17:24:50 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v3 02/23] psci: Accessor for configured PSCI function IDs
Message-ID: <20201126172450.GC38486@C02TD0UTHF1T.local>
References: <20201126155421.14901-1-dbrazdil@google.com>
 <20201126155421.14901-3-dbrazdil@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201126155421.14901-3-dbrazdil@google.com>
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

On Thu, Nov 26, 2020 at 03:54:00PM +0000, David Brazdil wrote:
> Function IDs used by PSCI are configurable for v0.1 via DT/APCI. If the
> host is using PSCI v0.1, KVM's host PSCI proxy needs to use the same IDs.
> Expose the array holding the information with a read-only accessor.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  drivers/firmware/psci/psci.c | 16 ++++++++--------
>  include/linux/psci.h         | 10 ++++++++++
>  2 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
> index 213c68418a65..40609564595e 100644
> --- a/drivers/firmware/psci/psci.c
> +++ b/drivers/firmware/psci/psci.c
> @@ -58,16 +58,16 @@ typedef unsigned long (psci_fn)(unsigned long, unsigned long,
>  				unsigned long, unsigned long);
>  static psci_fn *invoke_psci_fn;
>  
> -enum psci_function {
> -	PSCI_FN_CPU_SUSPEND,
> -	PSCI_FN_CPU_ON,
> -	PSCI_FN_CPU_OFF,
> -	PSCI_FN_MIGRATE,
> -	PSCI_FN_MAX,
> -};
> -
>  static u32 psci_function_id[PSCI_FN_MAX];
>  
> +u32 psci_get_function_id(enum psci_function fn)
> +{
> +	if (WARN_ON_ONCE(fn < 0 || fn >= PSCI_FN_MAX))
> +		return 0;
> +
> +	return psci_function_id[fn];
> +}

I'd really like if we could namespace this with a psci_0_1_* prefix
before we expose it outside of the PSCI code. I appreciate that's a
larger change, but I reckon we only need a couple of new patches:

1) Split the ops which consume the FN ids into separate psci_0_1_*() and
   psci_0_2_*() variants, with a common __psci_*() helper that takes the
   function ID as an argument. The 0_1 variants would read the function
   ID from a variable, and the 0_2 variants would hard-code the id.

2) Replace the psci_function_id array with:

   struct psci_0_1_function_ids {
   	u32 suspend;
   	u32 cpu_on;
   	u32 cpu_off;
   	u32 migrate;
   };

   ... and remove enum psci_function entirely.

3) Add a helper which returns the entire psci_0_1_function_ids struct in
   one go. No warnings necessary.

Does that sound OK to you?

Thanks,
Mark.

> +
>  #define PSCI_0_2_POWER_STATE_MASK		\
>  				(PSCI_0_2_POWER_STATE_ID_MASK | \
>  				PSCI_0_2_POWER_STATE_TYPE_MASK | \
> diff --git a/include/linux/psci.h b/include/linux/psci.h
> index 2a1bfb890e58..5b49a5c82d6f 100644
> --- a/include/linux/psci.h
> +++ b/include/linux/psci.h
> @@ -21,6 +21,16 @@ bool psci_power_state_is_valid(u32 state);
>  int psci_set_osi_mode(bool enable);
>  bool psci_has_osi_support(void);
>  
> +enum psci_function {
> +	PSCI_FN_CPU_SUSPEND,
> +	PSCI_FN_CPU_ON,
> +	PSCI_FN_CPU_OFF,
> +	PSCI_FN_MIGRATE,
> +	PSCI_FN_MAX,
> +};
> +
> +u32 psci_get_function_id(enum psci_function fn);
> +
>  struct psci_operations {
>  	u32 (*get_version)(void);
>  	int (*cpu_suspend)(u32 state, unsigned long entry_point);
> -- 
> 2.29.2.454.gaff20da3a2-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
