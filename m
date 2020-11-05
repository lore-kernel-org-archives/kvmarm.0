Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDEAC00A89
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 09:47:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EBC982080D
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 09:47:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="EFLzxc0G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBC982080D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 395064B73E;
	Thu,  5 Nov 2020 04:47:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4pBVoFMX4ZWa; Thu,  5 Nov 2020 04:47:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10C3F4B5D8;
	Thu,  5 Nov 2020 04:47:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7733F4B5D8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 04:47:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KnnrGkANA+t0 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 04:47:13 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E20F4B5D7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 04:47:13 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C8AAE2080D;
 Thu,  5 Nov 2020 09:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604569632;
 bh=HHlnMYvribr6tXTc4dWdBjcjHKLjb6dHLifRUqDqwQQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=EFLzxc0G4nItwOrjOMnnSewgHj9shosTzBoWlwDLKKI7KwDNQ7RaKW9TqsU/pIg+p
 uMsxcNdZQZJQo+Rj1yD1EmgjbipQWG6wClnZfll/W+huy0QRJr1y0deHb5k/8Mzl3/
 ECS9HsXAUOFDwEhdx2CSmDCDPi5yO0opgabFzzXQ=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kabrJ-007n9r-JG; Thu, 05 Nov 2020 09:47:09 +0000
MIME-Version: 1.0
Date: Thu, 05 Nov 2020 09:47:09 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [RFC PATCH 01/26] psci: Export configured PSCI version
In-Reply-To: <20201104183630.27513-2-dbrazdil@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
 <20201104183630.27513-2-dbrazdil@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <2265d2fed043ab79721c1014d6144558@kernel.org>
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
> The version of PSCI that the kernel should use to communicate with
> firmware is typically obtained from probing PSCI_VERSION. However, that
> doesn't work for PSCI v0.1 where the host gets the information from
> DT/ACPI, or if PSCI is not supported / was disabled.
> 
> KVM's PSCI proxy for the host needs to be configured with the same
> version used by the host driver. Expose the PSCI version used by the
> host.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  drivers/firmware/psci/psci.c | 6 ++++++
>  include/linux/psci.h         | 8 ++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/firmware/psci/psci.c 
> b/drivers/firmware/psci/psci.c
> index 00af99b6f97c..ff523bdbfe3f 100644
> --- a/drivers/firmware/psci/psci.c
> +++ b/drivers/firmware/psci/psci.c
> @@ -49,6 +49,8 @@ static int resident_cpu = -1;
>  struct psci_operations psci_ops;
>  static enum arm_smccc_conduit psci_conduit = SMCCC_CONDUIT_NONE;
> 
> +int psci_driver_version = PSCI_VERSION(0, 0);
> +
>  bool psci_tos_resident_on(int cpu)
>  {
>  	return cpu == resident_cpu;
> @@ -461,6 +463,8 @@ static int __init psci_probe(void)
>  		return -EINVAL;
>  	}
> 
> +	psci_driver_version = ver;
> +
>  	psci_0_2_set_functions();
> 
>  	psci_init_migrate();
> @@ -514,6 +518,8 @@ static int __init psci_0_1_init(struct device_node 
> *np)
> 
>  	pr_info("Using PSCI v0.1 Function IDs from DT\n");
> 
> +	psci_driver_version = PSCI_VERSION(0, 1);
> +
>  	if (!of_property_read_u32(np, "cpu_suspend", &id)) {
>  		psci_function_id[PSCI_FN_CPU_SUSPEND] = id;
>  		psci_ops.cpu_suspend = psci_cpu_suspend;
> diff --git a/include/linux/psci.h b/include/linux/psci.h
> index 2a1bfb890e58..cb35b90d1746 100644
> --- a/include/linux/psci.h
> +++ b/include/linux/psci.h
> @@ -21,6 +21,14 @@ bool psci_power_state_is_valid(u32 state);
>  int psci_set_osi_mode(bool enable);
>  bool psci_has_osi_support(void);
> 
> +/**
> + * The version of the PSCI specification followed by the driver.
> + * This is equivalent to calling PSCI_VERSION except:
> + *   (a) it also works for PSCI v0.1, which does not support 
> PSCI_VERSION, and
> + *   (b) it is set to v0.0 if the PSCI driver was not initialized.
> + */
> +extern int psci_driver_version;
> +
>  struct psci_operations {
>  	u32 (*get_version)(void);
>  	int (*cpu_suspend)(u32 state, unsigned long entry_point);

How about providing a get_version callback for pre-0.2 implementations
instead? This would avoid exposing more symbols (psci_ops is already
global).

Thanks,

         M.

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index 00af99b6f97c..b84454e12d92 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -500,6 +500,11 @@ static int __init psci_0_2_init(struct device_node 
*np)
  	return psci_probe();
  }

+static u32 psci_0_1_get_version(void)
+{
+	return PSCI_VERSION(0, 1);
+}
+
  /*
   * PSCI < v0.2 get PSCI Function IDs via DT.
   */
@@ -514,6 +519,8 @@ static int __init psci_0_1_init(struct device_node 
*np)

  	pr_info("Using PSCI v0.1 Function IDs from DT\n");

+	psci_ops.get_version = psci_0_1_get_version;
+
  	if (!of_property_read_u32(np, "cpu_suspend", &id)) {
  		psci_function_id[PSCI_FN_CPU_SUSPEND] = id;
  		psci_ops.cpu_suspend = psci_cpu_suspend;

-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
