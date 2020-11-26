Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 279BFC56202
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 17:21:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 75BBA206CA
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 17:21:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75BBA206CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A14744C029;
	Thu, 26 Nov 2020 12:21:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G7p83KrQUKdb; Thu, 26 Nov 2020 12:21:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C8B64C03A;
	Thu, 26 Nov 2020 12:21:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0ED04C02C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 12:21:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w+EDAGWYP7TL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 12:21:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCFAB4C029
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 12:21:28 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4DACB31B;
 Thu, 26 Nov 2020 09:21:28 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.30.234])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 353A53F23F;
 Thu, 26 Nov 2020 09:21:24 -0800 (PST)
Date: Thu, 26 Nov 2020 17:21:21 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v3 01/23] psci: Support psci_ops.get_version for v0.1
Message-ID: <20201126172121.GB38486@C02TD0UTHF1T.local>
References: <20201126155421.14901-1-dbrazdil@google.com>
 <20201126155421.14901-2-dbrazdil@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201126155421.14901-2-dbrazdil@google.com>
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

On Thu, Nov 26, 2020 at 03:53:59PM +0000, David Brazdil wrote:
> KVM's host PSCI SMC filter needs to be aware of the PSCI version of the
> system but currently it is impossible to distinguish between v0.1 and
> PSCI disabled because both have get_version == NULL.
> 
> Populate get_version for v0.1 with a function that returns a constant.
> 
> psci_opt.get_version is currently unused so this has no effect on
> existing functionality.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  drivers/firmware/psci/psci.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
> index 00af99b6f97c..213c68418a65 100644
> --- a/drivers/firmware/psci/psci.c
> +++ b/drivers/firmware/psci/psci.c
> @@ -146,6 +146,11 @@ static int psci_to_linux_errno(int errno)
>  	return -EINVAL;
>  }
>  
> +static u32 psci_get_version_0_1(void)
> +{
> +	return PSCI_VERSION(0, 1);
> +}

Elsewhere in this file we've used a psci_${MAJOR}_${MINOR}_* naming
scheme.

To match that, I'd prefer we call this psci_0_1_get_version(), and
rename psci_get_version() to psci_0_2_get_version().

With that:
	
Acked-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.

> +
>  static u32 psci_get_version(void)
>  {
>  	return invoke_psci_fn(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
> @@ -514,6 +519,8 @@ static int __init psci_0_1_init(struct device_node *np)
>  
>  	pr_info("Using PSCI v0.1 Function IDs from DT\n");
>  
> +	psci_ops.get_version = psci_get_version_0_1;
> +
>  	if (!of_property_read_u32(np, "cpu_suspend", &id)) {
>  		psci_function_id[PSCI_FN_CPU_SUSPEND] = id;
>  		psci_ops.cpu_suspend = psci_cpu_suspend;
> -- 
> 2.29.2.454.gaff20da3a2-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
