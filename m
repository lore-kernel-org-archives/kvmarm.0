Return-Path: <SRS0=CHPd=HD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA77AC433E6
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 17:41:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7EBB364E92
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 17:41:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7EBB364E92
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A9BF4B334;
	Mon,  1 Feb 2021 12:41:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sojPjVOPYJh1; Mon,  1 Feb 2021 12:41:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DF384B36D;
	Mon,  1 Feb 2021 12:41:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C3064B334
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 12:41:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y+RJm5g-8skn for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2021 12:41:50 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D79F4B2B1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 12:41:50 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F5E564E9C;
 Mon,  1 Feb 2021 17:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612201309;
 bh=Coy8GnAXaLr1Ite2Qp1Zmud9F/Xbq++8nLGERyWz1zs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Pya8jRrCvkpzbzb7LfN8NfCpsjbcALtAvceTk+7uAToBACDZndGBfLqO0TvnRs4QD
 vJt3n3sYn90rFk6cR3ObT0dGnrXLHiHnbGUWRrnA4+sssDkD83ArGPBV8XlQ8+N95j
 sBDnYQKZQx63cDdgE3rBsE6ck17Mgtp3krhlE6j7VO+NZcoFY1537qQZ1ZpO6OeGif
 HtFGRpj6wB5J0oYBEf6AGjSOoOhtkpeYK0TEJNYx9zOn4eNiMWXpD1a920S2bMogcL
 2MjQN0N5j5kJ+fm20uyeCk7W8G9Sa0NgxmKTm7oc445f0HL/SgjiAKCk3gK3mo7LRe
 zwKfv6/SlM7XQ==
Date: Mon, 1 Feb 2021 17:41:43 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH v2 04/26] KVM: arm64: Initialize kvm_nvhe_init_params
 early
Message-ID: <20210201174143.GB15632@willie-the-truck>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-5-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210108121524.656872-5-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On Fri, Jan 08, 2021 at 12:15:02PM +0000, Quentin Perret wrote:
> Move the initialization of kvm_nvhe_init_params in a dedicated function
> that is run early, and only once during KVM init, rather than every time
> the KVM vectors are set and reset.
> 
> This also opens the opportunity for the hypervisor to change the init
> structs during boot, hence simplifying the replacement of host-provided
> page-tables and stacks by the ones the hypervisor will create for
> itself.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/arm.c | 28 ++++++++++++++++++++--------
>  1 file changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 04c44853b103..3ac0f3425833 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c

[...]

> @@ -1807,6 +1813,12 @@ static int init_hyp_mode(void)
>  			goto out_err;
>  	}
>  
> +	/*
> +	 * Prepare the CPU initialization parameters
> +	 */
> +	for_each_possible_cpu(cpu)
> +		cpu_prepare_hyp_mode(cpu);
> +

This is the fifth for_each_possible_cpu() loop in this function; can any of
them be merged together?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
