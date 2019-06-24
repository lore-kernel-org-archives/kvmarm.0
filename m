Return-Path: <SRS0=87+N=UX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 659DBC43613
	for <kvmarm@archiver.kernel.org>; Mon, 24 Jun 2019 13:08:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D3FF42133F
	for <kvmarm@archiver.kernel.org>; Mon, 24 Jun 2019 13:08:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3FF42133F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 581A84A4E6;
	Mon, 24 Jun 2019 09:08:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h4OxTcz06Wle; Mon, 24 Jun 2019 09:08:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D13F4A445;
	Mon, 24 Jun 2019 09:08:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11AF54A2E5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jun 2019 09:08:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k-ufNPVj4Wpf for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jun 2019 09:08:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A495B4A445
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jun 2019 09:08:11 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F0C4344;
 Mon, 24 Jun 2019 06:08:11 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC5173F71E;
 Mon, 24 Jun 2019 06:08:09 -0700 (PDT)
Date: Mon, 24 Jun 2019 14:08:07 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 09/59] KVM: arm64: nv: Add nested virt VCPU primitives
 for vEL2 VCPU state
Message-ID: <20190624130807.GS2790@e103592.cambridge.arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-10-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190621093843.220980-10-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
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

On Fri, Jun 21, 2019 at 10:37:53AM +0100, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> When running a nested hypervisor we commonly have to figure out if
> the VCPU mode is running in the context of a guest hypervisor or guest
> guest, or just a normal guest.
> 
> Add convenient primitives for this.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 55 ++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 39ffe41855bc..8f201ea56f6e 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -191,6 +191,61 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
>  		vcpu_gp_regs(vcpu)->regs.regs[reg_num] = val;
>  }
>  
> +static inline bool vcpu_mode_el2_ctxt(const struct kvm_cpu_context *ctxt)
> +{
> +	unsigned long cpsr = ctxt->gp_regs.regs.pstate;
> +	u32 mode;
> +
> +	if (cpsr & PSR_MODE32_BIT)
> +		return false;
> +
> +	mode = cpsr & PSR_MODE_MASK;
> +
> +	return mode == PSR_MODE_EL2h || mode == PSR_MODE_EL2t;

We could also treat PSR_MODE32_BIT and PSR_MODE_MASK as a single field,
similarly as in the next patch, say:

	switch (ctxt->gp_regs.regs.pstate & (PSR_MODE32_BIT | PSR_MODE_MASK)) {
	case PSR_MODE_EL2h:
	case PSR_MODE_EL2t:
		return true;
	}

	return false;

(This is blatant bikeshedding...)

[...]

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
