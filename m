Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC60C433ED
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 16:19:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A468F61165
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 16:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A468F61165
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1F344B415;
	Mon, 10 May 2021 12:19:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RWsCjc6IwFoQ; Mon, 10 May 2021 12:19:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E2164B41A;
	Mon, 10 May 2021 12:19:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F16954B413
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 12:19:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M+HRiD8uxSKn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 May 2021 12:19:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A2DB4B410
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 12:19:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6F31168F;
 Mon, 10 May 2021 09:19:11 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.4.9])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 063FE3F73B;
 Mon, 10 May 2021 09:19:09 -0700 (PDT)
Date: Mon, 10 May 2021 17:19:07 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 3/9] KVM: arm64: vgic: Be tolerant to the lack of
 maintenance interrupt
Message-ID: <20210510161907.GD92897@C02TD0UTHF1T.local>
References: <20210510134824.1910399-1-maz@kernel.org>
 <20210510134824.1910399-4-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210510134824.1910399-4-maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Hector Martin <marcan@marcan.st>, kvmarm@lists.cs.columbia.edu,
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

On Mon, May 10, 2021 at 02:48:18PM +0100, Marc Zyngier wrote:
> As it turns out, not all the interrupt controllers are able to
> expose a vGIC maintenance interrupt as a distrete signal.
> And to be fair, it doesn't really matter as all we require is
> for *something* to kick us out of guest mode out way or another.
> 
> On systems that do not expose a maintenance interrupt as such,
> there are two outcomes:
> 
> - either the virtual CPUIF does generate an interrupt, and
>   by the time we are back to the host the interrupt will have long
>   been disabled (as we set ICH_HCR_EL2.EN to 0 on exit). In this case,
>   interrupt latency is as good as it gets.
> 
> - or some other event (physical timer) will take us out of the guest
>   anyway, and the only drawback is a bad interrupt latency.

IIRC we won't have a a guaranteed schedular tick for NO_HZ_FULL, so in
that case we'll either need to set a period software maintenance
interrupt, or reject this combination at runtime (either when trying to
isolate the dynticks CPUs, or when trying to create a VM).

Otherwise, it's very likely that something will take us out of the guest
from time to time, but we won't have a strict guarantee (e.g. if all
guest memory is pinned).

Thanks,
Mark.

> 
> So let's be tolerant to the lack of maintenance interrupt, and just let
> the user know that their mileage may vary...
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 2fdb65529594..9fd23f32aa54 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -524,11 +524,6 @@ int kvm_vgic_hyp_init(void)
>  	if (!gic_kvm_info)
>  		return -ENODEV;
>  
> -	if (!gic_kvm_info->maint_irq) {
> -		kvm_err("No vgic maintenance irq\n");
> -		return -ENXIO;
> -	}
> -
>  	switch (gic_kvm_info->type) {
>  	case GIC_V2:
>  		ret = vgic_v2_probe(gic_kvm_info);
> @@ -552,6 +547,11 @@ int kvm_vgic_hyp_init(void)
>  	if (ret)
>  		return ret;
>  
> +	if (!kvm_vgic_global_state.maint_irq) {
> +		kvm_err("No maintenance interrupt available, fingers crossed...\n");
> +		return 0;
> +	}
> +
>  	ret = request_percpu_irq(kvm_vgic_global_state.maint_irq,
>  				 vgic_maintenance_handler,
>  				 "vgic", kvm_get_running_vcpus());
> -- 
> 2.29.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
