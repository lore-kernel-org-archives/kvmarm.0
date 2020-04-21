Return-Path: <SRS0=wisL=6F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3810C2BA19
	for <kvmarm@archiver.kernel.org>; Tue, 21 Apr 2020 09:41:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 53D9F206E9
	for <kvmarm@archiver.kernel.org>; Tue, 21 Apr 2020 09:41:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53D9F206E9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4E924B130;
	Tue, 21 Apr 2020 05:41:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KIWYlV1llALp; Tue, 21 Apr 2020 05:41:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71EC34B108;
	Tue, 21 Apr 2020 05:41:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 711904B105
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2020 05:41:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D0evXHFeUGD2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Apr 2020 05:41:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46EBF4B104
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2020 05:41:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D9B701FB;
 Tue, 21 Apr 2020 02:41:11 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9A3563F68F;
 Tue, 21 Apr 2020 02:41:07 -0700 (PDT)
Date: Tue, 21 Apr 2020 10:40:58 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jianyong Wu <jianyong.wu@arm.com>
Subject: Re: [RFC PATCH v11 1/9] psci: export psci conduit get helper.
Message-ID: <20200421094058.GA16306@C02TD0UTHF1T.local>
References: <20200421032304.26300-1-jianyong.wu@arm.com>
 <20200421032304.26300-2-jianyong.wu@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200421032304.26300-2-jianyong.wu@arm.com>
Cc: maz@kernel.org, justin.he@arm.com, kvm@vger.kernel.org,
 netdev@vger.kernel.org, richardcochran@gmail.com, linux-kernel@vger.kernel.org,
 sean.j.christopherson@intel.com, steven.price@arm.com, john.stultz@linaro.org,
 yangbo.lu@nxp.com, pbonzini@redhat.com, tglx@linutronix.de, nd@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Tue, Apr 21, 2020 at 11:22:56AM +0800, Jianyong Wu wrote:
> Export arm_smccc_1_1_get_conduit then modules can use smccc helper which
> adopts it.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>

Nit: please say 'smccc conduit' in the commit title.

Otherwise, I see not problem with this provided an in-tree module uses
this, so:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  drivers/firmware/psci/psci.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
> index 2937d44b5df4..fd3c88f21b6a 100644
> --- a/drivers/firmware/psci/psci.c
> +++ b/drivers/firmware/psci/psci.c
> @@ -64,6 +64,7 @@ enum arm_smccc_conduit arm_smccc_1_1_get_conduit(void)
>  
>  	return psci_ops.conduit;
>  }
> +EXPORT_SYMBOL(arm_smccc_1_1_get_conduit);
>  
>  typedef unsigned long (psci_fn)(unsigned long, unsigned long,
>  				unsigned long, unsigned long);
> -- 
> 2.17.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
