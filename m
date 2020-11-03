Return-Path: <SRS0=Iiz7=EJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35396C2D0A3
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 18:29:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8F3AD20757
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 18:29:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F3AD20757
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36AEC4B5F7;
	Tue,  3 Nov 2020 13:29:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id krwXMIbuYu1b; Tue,  3 Nov 2020 13:29:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10D0E4B4DB;
	Tue,  3 Nov 2020 13:29:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A36D74B31F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 13:29:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hN4NUfgho9Vz for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2020 13:29:42 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B16B4B31D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 13:29:42 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4BA21474;
 Tue,  3 Nov 2020 10:29:41 -0800 (PST)
Received: from [172.16.1.113] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C66983F718;
 Tue,  3 Nov 2020 10:29:40 -0800 (PST)
Subject: Re: [PATCH 4/8] KVM: arm64: Map AArch32 cp14 register to AArch64
 sysregs
To: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
References: <20201102191609.265711-1-maz@kernel.org>
 <20201102191609.265711-5-maz@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <1830d62e-ac47-9b84-6375-baed62f8486e@arm.com>
Date: Tue, 3 Nov 2020 18:29:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201102191609.265711-5-maz@kernel.org>
Content-Language: en-GB
Cc: kernel-team@android.com
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

Hi Marc,

On 02/11/2020 19:16, Marc Zyngier wrote:
> Similarly to what has been done on the cp15 front, repaint the
> debug registers to use their AArch64 counterparts. This results
> in some simplification as we can remove the 32bit-specific
> accessors.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 137818793a4a..c41e7ca60c8c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -361,26 +361,30 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
> -#define DBGBXVR(n)							\
> -	{ Op1( 0), CRn( 1), CRm((n)), Op2( 1), trap_xvr, NULL, n }
> +#define DBG_BCR_BVR_WCR_WVR(n)						      \
> +	/* DBGBVRn */							      \
> +	{ AA32(LO), Op1( 0), CRn( 0), CRm((n)), Op2( 4), trap_bvr, NULL, n }, \

Just to check I understand what is going on here: This BVR AA32(LO) is needed because the
dbg_bvr array is shared with the DBGBXVR registers...


> +	/* DBGBCRn */							      \
> +	{ AA32(LO), Op1( 0), CRn( 0), CRm((n)), Op2( 5), trap_bcr, NULL, n }, \
> +	/* DBGWVRn */							      \
> +	{ AA32(LO), Op1( 0), CRn( 0), CRm((n)), Op2( 6), trap_wvr, NULL, n }, \
> +	/* DBGWCRn */							      \
> +	{ AA32(LO), Op1( 0), CRn( 0), CRm((n)), Op2( 7), trap_wcr, NULL, n }

... these don't have an alias, but its harmless.

[...]

> @@ -1931,7 +1896,9 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	/* DFSR */
>  	{ Op1( 0), CRn( 5), CRm( 0), Op2( 0), access_vm_reg, NULL, ESR_EL1 },
>  	{ Op1( 0), CRn( 5), CRm( 0), Op2( 1), access_vm_reg, NULL, IFSR32_EL2 },
> +	/* ADFSR */
>  	{ Op1( 0), CRn( 5), CRm( 1), Op2( 0), access_vm_reg, NULL, AFSR0_EL1 },
> +	/* AIFSR */
>  	{ Op1( 0), CRn( 5), CRm( 1), Op2( 1), access_vm_reg, NULL, AFSR1_EL1 },
>  	/* DFAR */
>  	{ AA32(LO), Op1( 0), CRn( 6), CRm( 0), Op2( 0), access_vm_reg, NULL, FAR_EL1 },

I guess these were meant for the previous patch.


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
