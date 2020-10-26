Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA12C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 10:48:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E535620754
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 10:48:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E535620754
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1760D4B5E2;
	Mon, 26 Oct 2020 06:48:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ObTWOvKJC7dR; Mon, 26 Oct 2020 06:48:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B41494B538;
	Mon, 26 Oct 2020 06:48:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A65554B516
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 06:48:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yLld6e7QD9sm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 06:48:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2580B4B515
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 06:48:04 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70FFB101E;
 Mon, 26 Oct 2020 03:48:03 -0700 (PDT)
Received: from [10.57.20.91] (unknown [10.57.20.91])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7DC93F719;
 Mon, 26 Oct 2020 03:48:01 -0700 (PDT)
Subject: Re: [PATCH 3/8] KVM: arm64: Drop useless PAN setting on host EL1 to
 EL2 transition
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20201026095116.72051-1-maz@kernel.org>
 <20201026095116.72051-4-maz@kernel.org>
From: Vladimir Murzin <vladimir.murzin@arm.com>
Message-ID: <8d798f0d-6bf4-ed26-9d40-b9d09bf2954e@arm.com>
Date: Mon, 26 Oct 2020 10:48:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20201026095116.72051-4-maz@kernel.org>
Content-Language: en-US
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com
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

On 10/26/20 9:51 AM, Marc Zyngier wrote:
> Setting PSTATE.PAN when entering EL2 on nVHE doesn't make much
> sense as this bit only means something for translation regimes
> that include EL0. This obviously isn't the case in the nVHE case,
> so let's drop this setting.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/host.S | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> index ff9a0f547b9f..ed27f06a31ba 100644
> --- a/arch/arm64/kvm/hyp/nvhe/host.S
> +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> @@ -17,8 +17,6 @@ SYM_FUNC_START(__host_exit)
>  
>  	get_host_ctxt	x0, x1
>  
> -	ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
> -
>  	/* Store the host regs x2 and x3 */
>  	stp	x2, x3,   [x0, #CPU_XREG_OFFSET(2)]
>  
> 

It was originally introduced in cb96408da4e1 (arm64: KVM: VHE: reset PSTATE.PAN on entry to EL2)
and indeed only applies to VHE (I even remember some attempts to put in under CONFIG_ARM64_VHE).

So, if it helps:
 
    Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

Cheers
Vladimir
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
