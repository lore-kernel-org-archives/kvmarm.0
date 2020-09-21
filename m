Return-Path: <SRS0=bMLL=C6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35822C43465
	for <kvmarm@archiver.kernel.org>; Mon, 21 Sep 2020 13:43:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7FA8E2084C
	for <kvmarm@archiver.kernel.org>; Mon, 21 Sep 2020 13:43:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="WxRp7fNz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FA8E2084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC3CE4B46C;
	Mon, 21 Sep 2020 09:43:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i2c7dXm3qCmO; Mon, 21 Sep 2020 09:43:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1A224B514;
	Mon, 21 Sep 2020 09:43:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 063644B46C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2020 09:43:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AjzwI+S2zhUt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Sep 2020 09:43:10 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE5004B38B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2020 09:43:09 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 335472084C;
 Mon, 21 Sep 2020 13:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600695788;
 bh=ppWgQwIPJFgXvpl5SyaBDqV8l2T0GGovdfeRTgIHCFU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=WxRp7fNzBJpKQt2ftVmrIe0M00opXLZn+F2d5mDdpSKGn8lUe/l/M4uRs6n6sREdy
 bW0hA+DLr0AjQqCJBgrHPFgxzbq84ceM4vkef6/Rx84et6Iin19dgiliB/AzP8PonQ
 4ut8OFK2UunvFo4cAYtKyJOqaJGFdcG9RYMVTRe0=
Date: Mon, 21 Sep 2020 14:43:02 +0100
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v6 5/7] KVM: arm64: pmu: Make overflow handler NMI safe
Message-ID: <20200921134301.GJ2139@willie-the-truck>
References: <20200819133419.526889-1-alexandru.elisei@arm.com>
 <20200819133419.526889-6-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200819133419.526889-6-alexandru.elisei@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: sumit.garg@linaro.org, kvm@vger.kernel.org,
 Marc Zyngier <marc.zyngier@arm.com>, maz@kernel.org,
 Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
 swboyd@chromium.org, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu,
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

On Wed, Aug 19, 2020 at 02:34:17PM +0100, Alexandru Elisei wrote:
> From: Julien Thierry <julien.thierry@arm.com>
> 
> kvm_vcpu_kick() is not NMI safe. When the overflow handler is called from
> NMI context, defer waking the vcpu to an irq_work queue.
> 
> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Suzuki K Pouloze <suzuki.poulose@arm.com>
> Cc: kvm@vger.kernel.org
> Cc: kvmarm@lists.cs.columbia.edu
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/kvm/pmu-emul.c | 25 ++++++++++++++++++++++++-
>  include/kvm/arm_pmu.h     |  1 +
>  2 files changed, 25 insertions(+), 1 deletion(-)

I'd like an Ack from the KVM side on this one, but some minor comments
inline.

> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index f0d0312c0a55..30268397ed06 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -433,6 +433,22 @@ void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
>  	kvm_pmu_update_state(vcpu);
>  }
>  
> +/**
> + * When perf interrupt is an NMI, we cannot safely notify the vcpu corresponding
> + * to the event.
> + * This is why we need a callback to do it once outside of the NMI context.
> + */
> +static void kvm_pmu_perf_overflow_notify_vcpu(struct irq_work *work)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_pmu *pmu;
> +
> +	pmu = container_of(work, struct kvm_pmu, overflow_work);
> +	vcpu = kvm_pmc_to_vcpu(&pmu->pmc[0]);

Can you spell this kvm_pmc_to_vcpu(pmu->pmc); ?

> +
> +	kvm_vcpu_kick(vcpu);

How do we guarantee that the vCPU is still around by the time this runs?
Sorry to ask such a horrible question, but I don't see anything associating
the workqueue with the lifetime of the vCPU.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
