Return-Path: <SRS0=phmX=MT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD415C4338F
	for <kvmarm@archiver.kernel.org>; Tue, 27 Jul 2021 18:10:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D1F66056B
	for <kvmarm@archiver.kernel.org>; Tue, 27 Jul 2021 18:10:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5D1F66056B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10C794B086;
	Tue, 27 Jul 2021 14:10:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GImN1VIga9-2; Tue, 27 Jul 2021 14:10:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 089734A531;
	Tue, 27 Jul 2021 14:10:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47F884A500
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Jul 2021 14:10:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6+HfSg4h8Y-F for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Jul 2021 14:10:51 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C3494A19A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Jul 2021 14:10:51 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6349760F4F;
 Tue, 27 Jul 2021 18:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1627409450;
 bh=1idsSsOLd6j5B3mlucoHIl85eXG29dW6Ac2vbhUO3Bs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=EoFDUbpRaPCpop/dEtf4WAzlFiaUP3CjPo5T53gFnwUy4wbJ3B+0hT3gzFVMjsnrB
 gLndl4KBOIAQZyvL0c0pZSAOT1BEAhGFCmvzU3sAIoChqIerKeR98fF/2S2rQCDG5k
 phec+IZQs88i19ZKdLrLG/MT0rWFQp6Gr6SN/pSGHk77wCP1zP2QUcyqX54Z5C8OfW
 7/tAQFHm9Px4MW92GtYwlqwqMSfND8kFmfuzSsZaLwaZe6xug/nkg39LP9h2p2l4sP
 4rLd4bMxC2v7t5Scn4P2rhF4xDAP0+ukEt9wsgzbZmQbttMuWmezJZhFtCFQUOrOxx
 UFuCQq1bIr3ww==
Date: Tue, 27 Jul 2021 19:10:45 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 02/16] KVM: arm64: Don't issue CMOs when the physical
 address is invalid
Message-ID: <20210727181044.GB19173@willie-the-truck>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-3-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210715163159.1480168-3-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Shanker R Donthineni <sdonthineni@nvidia.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Jul 15, 2021 at 05:31:45PM +0100, Marc Zyngier wrote:
> Make sure we don't issue CMOs when mapping something that
> is not a memory address in the S2 page tables.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 05321f4165e3..a5874ebd0354 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -619,12 +619,16 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>  	}
>  
>  	/* Perform CMOs before installation of the guest stage-2 PTE */
> -	if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
> -		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new, mm_ops),
> -						granule);
> -
> -	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
> -		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
> +	if (kvm_phys_is_valid(phys)) {
> +		if (mm_ops->dcache_clean_inval_poc &&
> +		    stage2_pte_cacheable(pgt, new))
> +			mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new,
> +								      mm_ops),
> +						       granule);
> +		if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
> +			mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops),
> +						 granule);
> +	}

Given that this check corresponds to checking the validity of 'new', I
wonder whether we'd be better off pushing the validity checks down into
stage2_pte_{cacheable,executable}()?

I.e. have stage2_pte_cacheable() return false if !kvm_pte_valid()

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
