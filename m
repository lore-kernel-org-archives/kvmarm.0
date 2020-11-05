Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6211DC388F7
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 09:53:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8714E2151B
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 09:53:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="CrU9BPZM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8714E2151B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0339D4B618;
	Thu,  5 Nov 2020 04:53:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r15FI4jsa7EF; Thu,  5 Nov 2020 04:53:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5BF84B63C;
	Thu,  5 Nov 2020 04:53:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDC444B606
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 04:53:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0hLrkxQT-8o4 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 04:53:10 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ABC9B4B5E9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 04:53:10 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5CF892151B;
 Thu,  5 Nov 2020 09:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604569989;
 bh=05ML26Jp9zU6GACtn9aCiyu+oy90xRHx7TvqsEetQSw=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=CrU9BPZMhjG6XBnFZj7rwMjBVY+aLHNqx0Nlb1mA9Fiij/8DL/eyOM0r9e8D7jhlp
 SpmPMVZC5KABurCvlqM34aJ3EEWWHuslRh8ARBAAoztEjDKBnd09P29s5J8TcPG1i/
 lT5ExIn9lIegbNHrSwGiL+7NorLstJSACtsZuQGc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kabx5-007nE3-6I; Thu, 05 Nov 2020 09:53:07 +0000
MIME-Version: 1.0
Date: Thu, 05 Nov 2020 09:53:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [RFC PATCH 02/26] psci: Export configured PSCI function IDs
In-Reply-To: <20201104183630.27513-3-dbrazdil@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
 <20201104183630.27513-3-dbrazdil@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <61384a4031c6a3419c55a8cdb8f9f0ab@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, dennis@kernel.org, tj@kernel.org,
 cl@linux.com, mark.rutland@arm.com, lorenzo.pieralisi@arm.com,
 qperret@google.com, ascull@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Tejun Heo <tj@kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-11-04 18:36, David Brazdil wrote:
> Function IDs used by PSCI are configurable for v0.1 via DT/APCI. If the
> host is using PSCI v0.1, KVM's PSCI proxy needs to use the same IDs.
> Expose the array holding the information.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  drivers/firmware/psci/psci.c | 10 +---------
>  include/linux/psci.h         | 10 ++++++++++
>  2 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/firmware/psci/psci.c 
> b/drivers/firmware/psci/psci.c
> index ff523bdbfe3f..ffcb88f60e21 100644
> --- a/drivers/firmware/psci/psci.c
> +++ b/drivers/firmware/psci/psci.c
> @@ -60,15 +60,7 @@ typedef unsigned long (psci_fn)(unsigned long, 
> unsigned long,
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
> -static u32 psci_function_id[PSCI_FN_MAX];
> +u32 psci_function_id[PSCI_FN_MAX];
> 
>  #define PSCI_0_2_POWER_STATE_MASK		\
>  				(PSCI_0_2_POWER_STATE_ID_MASK | \
> diff --git a/include/linux/psci.h b/include/linux/psci.h
> index cb35b90d1746..877d844ee6d9 100644
> --- a/include/linux/psci.h
> +++ b/include/linux/psci.h
> @@ -29,6 +29,16 @@ bool psci_has_osi_support(void);
>   */
>  extern int psci_driver_version;
> 
> +enum psci_function {
> +	PSCI_FN_CPU_SUSPEND,
> +	PSCI_FN_CPU_ON,
> +	PSCI_FN_CPU_OFF,
> +	PSCI_FN_MIGRATE,
> +	PSCI_FN_MAX,
> +};
> +
> +extern u32 psci_function_id[PSCI_FN_MAX];

I am very reluctant to expose this array to the rest of the kernel.
The temptation becomes huge for people to start writing to it
from random drivers in order to route PSCI calls somewhere else.
Consider exporting an accessor instead.

Same thing for the following patch (there already are a couple of
accessors for psci_cpu_suspend_feature, which you could make visible).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
