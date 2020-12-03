Return-Path: <SRS0=mzwA=FH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E64C63777
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 10:47:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B7233208FE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 10:47:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7233208FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE4074B1F7;
	Thu,  3 Dec 2020 05:47:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mEtN+V1WJrsP; Thu,  3 Dec 2020 05:47:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A84D44B1A3;
	Thu,  3 Dec 2020 05:47:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4E794B1A3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 05:47:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uceDngQtNFet for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2020 05:47:20 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 807924B1A2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 05:47:20 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C078113E;
 Thu,  3 Dec 2020 02:47:20 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.0.87])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E02FB3F66B;
 Thu,  3 Dec 2020 02:47:15 -0800 (PST)
Date: Thu, 3 Dec 2020 10:47:12 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v4 06/26] psci: Add accessor for psci_0_1_function_ids
Message-ID: <20201203104712.GC96754@C02TD0UTHF1T.local>
References: <20201202184122.26046-1-dbrazdil@google.com>
 <20201202184122.26046-7-dbrazdil@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201202184122.26046-7-dbrazdil@google.com>
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

On Wed, Dec 02, 2020 at 06:41:02PM +0000, David Brazdil wrote:
> Make it possible to retrieve a copy of the psci_0_1_function_ids struct.
> This is useful for KVM if it is configured to intercept host's PSCI SMCs.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>

Acked-by: Mark Rutland <mark.rutland@arm.com>

... just to check, does KVM snapshot which function IDs are valid, or do
we want to add that state here too? That can be a follow-up if
necessary.

Thanks,
Mark.

> ---
>  drivers/firmware/psci/psci.c | 12 +++++-------
>  include/linux/psci.h         |  9 +++++++++
>  2 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
> index 593fdd0e09a2..f5fc429cae3f 100644
> --- a/drivers/firmware/psci/psci.c
> +++ b/drivers/firmware/psci/psci.c
> @@ -58,15 +58,13 @@ typedef unsigned long (psci_fn)(unsigned long, unsigned long,
>  				unsigned long, unsigned long);
>  static psci_fn *invoke_psci_fn;
>  
> -struct psci_0_1_function_ids {
> -	u32 cpu_suspend;
> -	u32 cpu_on;
> -	u32 cpu_off;
> -	u32 migrate;
> -};
> -
>  static struct psci_0_1_function_ids psci_0_1_function_ids;
>  
> +struct psci_0_1_function_ids get_psci_0_1_function_ids(void)
> +{
> +	return psci_0_1_function_ids;
> +}
> +
>  #define PSCI_0_2_POWER_STATE_MASK		\
>  				(PSCI_0_2_POWER_STATE_ID_MASK | \
>  				PSCI_0_2_POWER_STATE_TYPE_MASK | \
> diff --git a/include/linux/psci.h b/include/linux/psci.h
> index 2a1bfb890e58..4ca0060a3fc4 100644
> --- a/include/linux/psci.h
> +++ b/include/linux/psci.h
> @@ -34,6 +34,15 @@ struct psci_operations {
>  
>  extern struct psci_operations psci_ops;
>  
> +struct psci_0_1_function_ids {
> +	u32 cpu_suspend;
> +	u32 cpu_on;
> +	u32 cpu_off;
> +	u32 migrate;
> +};
> +
> +struct psci_0_1_function_ids get_psci_0_1_function_ids(void);
> +
>  #if defined(CONFIG_ARM_PSCI_FW)
>  int __init psci_dt_init(void);
>  #else
> -- 
> 2.29.2.454.gaff20da3a2-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
