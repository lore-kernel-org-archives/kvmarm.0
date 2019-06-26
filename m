Return-Path: <SRS0=hM/U=UZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE785C4646B
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jun 2019 06:55:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5DB972086D
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jun 2019 06:55:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5DB972086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B09674A4C0;
	Wed, 26 Jun 2019 02:55:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QpwECezX2ftq; Wed, 26 Jun 2019 02:55:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E79D4A4CA;
	Wed, 26 Jun 2019 02:55:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A86C44A4C0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jun 2019 02:55:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GaJy3NqWz2j8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jun 2019 02:55:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7E484A4BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jun 2019 02:55:36 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB5DE2B;
 Tue, 25 Jun 2019 23:55:35 -0700 (PDT)
Received: from [10.37.8.13] (unknown [10.37.8.13])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 844713F246;
 Tue, 25 Jun 2019 23:57:23 -0700 (PDT)
Subject: Re: [PATCH 27/59] KVM: arm64: nv: Respect virtual HCR_EL2.TVM and
 TRVM settings
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-28-marc.zyngier@arm.com>
From: Julien Thierry <julien.thierry@arm.com>
Message-ID: <b34ac199-4d12-74b7-3f78-acd871707296@arm.com>
Date: Wed, 26 Jun 2019 07:55:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-28-marc.zyngier@arm.com>
Content-Language: en-US
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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



On 06/21/2019 10:38 AM, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> Forward the EL1 virtual memory register traps to the virtual EL2 if they
> are not coming from the virtual EL2 and the virtual HCR_EL2.TVM or TRVM
> bit is set.
> 
> This is for recursive nested virtualization.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 582d62aa48b7..0f74b9277a86 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -436,6 +436,27 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +/* This function is to support the recursive nested virtualization */
> +static bool forward_vm_traps(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
> +{
> +	u64 hcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
> +
> +	/* If a trap comes from the virtual EL2, the host hypervisor handles. */
> +	if (vcpu_mode_el2(vcpu))
> +		return false;
> +
> +	/*
> +	 * If the virtual HCR_EL2.TVM or TRVM bit is set, we need to foward
> +	 * this trap to the virtual EL2.
> +	 */
> +	if ((hcr_el2 & HCR_TVM) && p->is_write)
> +		return true;
> +	else if ((hcr_el2 & HCR_TRVM) && !p->is_write)
> +		return true;
> +
> +	return false;
> +}
> +
>  /*
>   * Generic accessor for VM registers. Only called as long as HCR_TVM
>   * is set. If the guest enables the MMU, we stop trapping the VM
> @@ -452,6 +473,9 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
>  	if (el12_reg(p) && forward_nv_traps(vcpu))
>  		return false;
>  
> +	if (!el12_reg(p) && forward_vm_traps(vcpu, p))
> +		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));

Since we already have forward_traps(), isn't this just:

	if (!el12_reg(p) && forward_traps(vcpu, p->is_write ? HCR_TVM : HCR_TRVM))
		return true;

We could maybe simplify forward_vm_traps() to just call forward_traps()
similar to forward_nv_traps().

Cheers,

Julien
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
