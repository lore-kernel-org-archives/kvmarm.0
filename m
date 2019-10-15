Return-Path: <SRS0=Qc2f=YI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A36D4ECE58F
	for <kvmarm@archiver.kernel.org>; Tue, 15 Oct 2019 17:25:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3558020650
	for <kvmarm@archiver.kernel.org>; Tue, 15 Oct 2019 17:25:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3558020650
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE1C74A9AA;
	Tue, 15 Oct 2019 13:25:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hxRvTYZO4gCd; Tue, 15 Oct 2019 13:25:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83B9A4A98E;
	Tue, 15 Oct 2019 13:25:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBED34A9A5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Oct 2019 13:24:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8g+2Yta7YSbC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Oct 2019 13:24:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A75594A98E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Oct 2019 13:24:58 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 53CC0337;
 Tue, 15 Oct 2019 10:24:58 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 000F23F68E;
 Tue, 15 Oct 2019 10:24:55 -0700 (PDT)
Date: Tue, 15 Oct 2019 18:24:53 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jianyong Wu <jianyong.wu@arm.com>
Subject: Re: [PATCH v5 1/6] psci: Export psci_ops.conduit symbol as modules
 will use it.
Message-ID: <20191015172453.GE24604@lakrids.cambridge.arm.com>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-2-jianyong.wu@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191015104822.13890-2-jianyong.wu@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: maz@kernel.org, justin.he@arm.com, kvm@vger.kernel.org,
 netdev@vger.kernel.org, richardcochran@gmail.com, linux-kernel@vger.kernel.org,
 sean.j.christopherson@intel.com, john.stultz@linaro.org, yangbo.lu@nxp.com,
 pbonzini@redhat.com, tglx@linutronix.de, nd@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Tue, Oct 15, 2019 at 06:48:17PM +0800, Jianyong Wu wrote:
> If arm_smccc_1_1_invoke used in modules, psci_ops.conduit should
> be export.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>

I have a patch queued [1] in the arm64 tree which adds
arm_smccc_1_1_get_conduit() for this purpose.

Please use that, adding an EXPORT_SYMBOL() if necessary.

Thanks,
Mark.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/commit/?h=for-next/smccc-conduit-cleanup&id=6b7fe77c334ae59fed9500140e08f4f896b36871

> ---
>  drivers/firmware/psci/psci.c | 6 ++++++
>  include/linux/arm-smccc.h    | 2 +-
>  include/linux/psci.h         | 1 +
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
> index f82ccd39a913..35c4eaab1451 100644
> --- a/drivers/firmware/psci/psci.c
> +++ b/drivers/firmware/psci/psci.c
> @@ -212,6 +212,12 @@ static unsigned long psci_migrate_info_up_cpu(void)
>  			      0, 0, 0);
>  }
>  
> +enum psci_conduit psci_get_conduit(void)
> +{
> +	return psci_ops.conduit;
> +}
> +EXPORT_SYMBOL(psci_get_conduit);
> +
>  static void set_conduit(enum psci_conduit conduit)
>  {
>  	switch (conduit) {
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index 552cbd49abe8..a6e4d3e3d10a 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -357,7 +357,7 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
>   * The return value also provides the conduit that was used.
>   */
>  #define arm_smccc_1_1_invoke(...) ({					\
> -		int method = psci_ops.conduit;				\
> +		int method = psci_get_conduit();			\
>  		switch (method) {					\
>  		case PSCI_CONDUIT_HVC:					\
>  			arm_smccc_1_1_hvc(__VA_ARGS__);			\
> diff --git a/include/linux/psci.h b/include/linux/psci.h
> index a8a15613c157..e5cedc986049 100644
> --- a/include/linux/psci.h
> +++ b/include/linux/psci.h
> @@ -42,6 +42,7 @@ struct psci_operations {
>  	enum smccc_version smccc_version;
>  };
>  
> +extern enum psci_conduit psci_get_conduit(void);
>  extern struct psci_operations psci_ops;
>  
>  #if defined(CONFIG_ARM_PSCI_FW)
> -- 
> 2.17.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
