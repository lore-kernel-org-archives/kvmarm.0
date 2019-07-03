Return-Path: <SRS0=95sP=VA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C36C4646D
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 09:16:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2A1AA218A3
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 09:16:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A1AA218A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A74F4A3BF;
	Wed,  3 Jul 2019 05:16:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ku8LSrYcO57m; Wed,  3 Jul 2019 05:16:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C2FC4A418;
	Wed,  3 Jul 2019 05:16:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA75B4A417
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jul 2019 05:16:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dfrTWEmwW2ty for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Jul 2019 05:16:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D3E740A52
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jul 2019 05:16:46 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E1A4344;
 Wed,  3 Jul 2019 02:16:46 -0700 (PDT)
Received: from [10.1.31.185] (unknown [10.1.31.185])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B377F3F246;
 Wed,  3 Jul 2019 02:16:44 -0700 (PDT)
Subject: Re: [PATCH 29/59] KVM: arm64: nv: Emulate EL12 register accesses from
 the virtual EL2
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-30-marc.zyngier@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <5785f00f-889f-cc35-f84c-58ed98d1cee2@arm.com>
Date: Wed, 3 Jul 2019 10:16:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-30-marc.zyngier@arm.com>
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


On 6/21/19 10:38 AM, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
>
> With HCR_EL2.NV bit set, accesses to EL12 registers in the virtual EL2
> trap to EL2. Handle those traps just like we do for EL1 registers.
>
> One exception is CNTKCTL_EL12. We don't trap on CNTKCTL_EL1 for non-VHE
> virtual EL2 because we don't have to. However, accessing CNTKCTL_EL12
> will trap since it's one of the EL12 registers controlled by HCR_EL2.NV
> bit.  Therefore, add a handler for it and don't treat it as a
> non-trap-registers when preparing a shadow context.
>
> Move EL12 system register macros to a common place to reuse them.

I see no change related to moving macros, is this a left over from a rebase?

>
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index beadebcfc888..34f1b79f7856 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2039,6 +2039,23 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_CNTVOFF_EL2), access_rw, reset_val, CNTVOFF_EL2, 0 },
>  	{ SYS_DESC(SYS_CNTHCTL_EL2), access_rw, reset_val, CNTHCTL_EL2, 0 },
>  
> +	{ SYS_DESC(SYS_SCTLR_EL12), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
> +	{ SYS_DESC(SYS_CPACR_EL12), access_rw, reset_val, CPACR_EL1, 0 },
> +	{ SYS_DESC(SYS_TTBR0_EL12), access_vm_reg, reset_unknown, TTBR0_EL1 },
> +	{ SYS_DESC(SYS_TTBR1_EL12), access_vm_reg, reset_unknown, TTBR1_EL1 },
> +	{ SYS_DESC(SYS_TCR_EL12), access_vm_reg, reset_val, TCR_EL1, 0 },
> +	{ SYS_DESC(SYS_SPSR_EL12), access_spsr},
> +	{ SYS_DESC(SYS_ELR_EL12), access_elr},
> +	{ SYS_DESC(SYS_AFSR0_EL12), access_vm_reg, reset_unknown, AFSR0_EL1 },
> +	{ SYS_DESC(SYS_AFSR1_EL12), access_vm_reg, reset_unknown, AFSR1_EL1 },
> +	{ SYS_DESC(SYS_ESR_EL12), access_vm_reg, reset_unknown, ESR_EL1 },
> +	{ SYS_DESC(SYS_FAR_EL12), access_vm_reg, reset_unknown, FAR_EL1 },
> +	{ SYS_DESC(SYS_MAIR_EL12), access_vm_reg, reset_unknown, MAIR_EL1 },
> +	{ SYS_DESC(SYS_AMAIR_EL12), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
> +	{ SYS_DESC(SYS_VBAR_EL12), access_rw, reset_val, VBAR_EL1, 0 },
> +	{ SYS_DESC(SYS_CONTEXTIDR_EL12), access_vm_reg, reset_val, CONTEXTIDR_EL1, 0 },
> +	{ SYS_DESC(SYS_CNTKCTL_EL12), access_rw, reset_val, CNTKCTL_EL1, 0 },
> +
>  	{ SYS_DESC(SYS_SP_EL2), NULL, reset_unknown, SP_EL2 },
>  };
>  
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
