Return-Path: <SRS0=87+N=UX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84491C43613
	for <kvmarm@archiver.kernel.org>; Mon, 24 Jun 2019 10:19:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1433A208E3
	for <kvmarm@archiver.kernel.org>; Mon, 24 Jun 2019 10:19:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1433A208E3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DAC24A501;
	Mon, 24 Jun 2019 06:19:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O4Twadp-f28R; Mon, 24 Jun 2019 06:19:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1036C4A4E5;
	Mon, 24 Jun 2019 06:19:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 081EF4A4E1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jun 2019 06:19:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R8x3aEIZF7IH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jun 2019 06:19:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8BE64A418
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jun 2019 06:19:08 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E7952B;
 Mon, 24 Jun 2019 03:19:08 -0700 (PDT)
Received: from [10.1.196.93] (en101.cambridge.arm.com [10.1.196.93])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 023573F718;
 Mon, 24 Jun 2019 03:19:06 -0700 (PDT)
Subject: Re: [PATCH 05/59] KVM: arm64: nv: Reset VCPU to EL2 registers if VCPU
 nested virt is set
To: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-6-marc.zyngier@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <8f545b5a-ceb6-a5c9-ad21-485f0e63f6e5@arm.com>
Date: Mon, 24 Jun 2019 11:19:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-6-marc.zyngier@arm.com>
Content-Language: en-US
Cc: andre.przywara@arm.com, dave.martin@arm.com
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



On 21/06/2019 10:37, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> Reset the VCPU with PSTATE.M = EL2h when the nested virtualization
> feature is enabled on the VCPU.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>   arch/arm64/kvm/reset.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 1140b4485575..675ca07dbb05 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -52,6 +52,11 @@ static const struct kvm_regs default_regs_reset = {
>   			PSR_F_BIT | PSR_D_BIT),
>   };
>   
> +static const struct kvm_regs default_regs_reset_el2 = {
> +	.regs.pstate = (PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT |
> +			PSR_F_BIT | PSR_D_BIT),
> +};
> +
>   static const struct kvm_regs default_regs_reset32 = {
>   	.regs.pstate = (PSR_AA32_MODE_SVC | PSR_AA32_A_BIT |
>   			PSR_AA32_I_BIT | PSR_AA32_F_BIT),
> @@ -302,6 +307,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>   			if (!cpu_has_32bit_el1())
>   				goto out;
>   			cpu_reset = &default_regs_reset32;
> +		} else if (test_bit(KVM_ARM_VCPU_NESTED_VIRT, vcpu->arch.features)) {

minor nit: "else if nested_virt_in_use(vcpu)" ?

Either ways:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
