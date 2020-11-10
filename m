Return-Path: <SRS0=+U1N=EQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66277C55ABD
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 14:43:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A17FC20678
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 14:43:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="SCPl37DM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A17FC20678
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E85274B8EF;
	Tue, 10 Nov 2020 09:43:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 32FNyMkTO9VZ; Tue, 10 Nov 2020 09:43:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A68684B903;
	Tue, 10 Nov 2020 09:43:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B714D4B8EF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 09:43:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bzQQ7WBCPbF9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Nov 2020 09:43:05 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8626D4B8DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 09:43:05 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1149320678;
 Tue, 10 Nov 2020 14:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605019384;
 bh=xRxv/AUxy4vi7s0st2HDTl3DqkNZPZIv8nBqNrHDOhQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=SCPl37DM9sd5XiKV8yicyvZuiaMVl2SaLBgBrewwLevvpurSVI2lwFyDBnprrk/k4
 ASh85QC3keK9wqhH8bTbXss2eRHeFtiuKpu5lM0LYY/d9mnP213EO6M+NAgFC98Zdu
 vBBvpW9UGfMrU/MCTZdaTlajV3A8/v2Fskckw4Ck=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcUrN-009Ta1-P7; Tue, 10 Nov 2020 14:43:02 +0000
MIME-Version: 1.0
Date: Tue, 10 Nov 2020 14:43:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v1 01/24] psci: Accessor for configured PSCI version
In-Reply-To: <20201109113233.9012-2-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201109113233.9012-2-dbrazdil@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <ba9c8ccf25ff82b834ab78930570b993@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, dennis@kernel.org, tj@kernel.org,
 cl@linux.com, mark.rutland@arm.com, lorenzo.pieralisi@arm.com,
 qperret@google.com, ascull@google.com, qwandor@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On 2020-11-09 11:32, David Brazdil wrote:
> The version of PSCI that the kernel should use to communicate with
> firmware is typically obtained from probing PSCI_VERSION. However, that
> doesn't work for PSCI v0.1 where the host gets the information from
> DT/ACPI, or if PSCI is not supported / was disabled.
> 
> KVM's host PSCI proxy needs to be configured with the same version
> used by the host driver. Expose the PSCI version used by the host
> with a read-only accessor.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  drivers/firmware/psci/psci.c | 11 +++++++++++
>  include/linux/psci.h         |  8 ++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/drivers/firmware/psci/psci.c 
> b/drivers/firmware/psci/psci.c
> index 00af99b6f97c..bc1b2d60fdbf 100644
> --- a/drivers/firmware/psci/psci.c
> +++ b/drivers/firmware/psci/psci.c
> @@ -49,6 +49,13 @@ static int resident_cpu = -1;
>  struct psci_operations psci_ops;
>  static enum arm_smccc_conduit psci_conduit = SMCCC_CONDUIT_NONE;
> 
> +static int driver_version = PSCI_VERSION(0, 0);
> +
> +int psci_driver_version(void)
> +{
> +	return driver_version;
> +}
> +
>  bool psci_tos_resident_on(int cpu)
>  {
>  	return cpu == resident_cpu;
> @@ -461,6 +468,8 @@ static int __init psci_probe(void)
>  		return -EINVAL;
>  	}
> 
> +	driver_version = ver;
> +
>  	psci_0_2_set_functions();
> 
>  	psci_init_migrate();
> @@ -514,6 +523,8 @@ static int __init psci_0_1_init(struct device_node 
> *np)
> 
>  	pr_info("Using PSCI v0.1 Function IDs from DT\n");
> 
> +	driver_version = PSCI_VERSION(0, 1);
> +
>  	if (!of_property_read_u32(np, "cpu_suspend", &id)) {
>  		psci_function_id[PSCI_FN_CPU_SUSPEND] = id;
>  		psci_ops.cpu_suspend = psci_cpu_suspend;
> diff --git a/include/linux/psci.h b/include/linux/psci.h
> index 2a1bfb890e58..5b5dcf176aa6 100644
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
> +int psci_driver_version(void);
> +
>  struct psci_operations {
>  	u32 (*get_version)(void);
>  	int (*cpu_suspend)(u32 state, unsigned long entry_point);

I still maintain that populating .get_version in all cases instead of
duplicating an existing functionality is a better outcome. PSCI not
supported would be implied by .get_version being NULL.

What breaks?

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
