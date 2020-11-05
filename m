Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7FCEC4742C
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 22:50:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 22EFB206CA
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 22:50:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="2Ebvug8O"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22EFB206CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 793974B2CC;
	Thu,  5 Nov 2020 17:50:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KQf2Aa8LwYXt; Thu,  5 Nov 2020 17:50:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 746CC4B5C9;
	Thu,  5 Nov 2020 17:50:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A4914B5C9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 17:50:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pnm3YPIR7fMl for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 17:50:27 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E1754B5C7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 17:50:27 -0500 (EST)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7CCA5206CA;
 Thu,  5 Nov 2020 22:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604616626;
 bh=o7PrUBztNEfDJjUh55lvvosuP3j1T4tJ1RkSbtVr/fc=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=2Ebvug8OoOsCvSF4mWsVAwx1gVvC2DchFtyqQXV0yvyWmLXzN3mN7OHzas9Nk9GVe
 ltPMNCbR7Ehzw1IT5weWvnmtPO3dEG/LRvgPyoXM/UEKjznZ5JC1FQGwi9wNThFM7x
 JfFX9t6TBOXZwIIsqj+pjtQToFPIkW2d/O6jprg8=
Date: Thu, 5 Nov 2020 22:50:21 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/3] KVM: arm64: Rename access_amu() to undef_access()
Message-ID: <20201105225020.GE8842@willie-the-truck>
References: <20201103171445.271195-1-maz@kernel.org>
 <20201103171445.271195-3-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201103171445.271195-3-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Tue, Nov 03, 2020 at 05:14:44PM +0000, Marc Zyngier wrote:
> The only thing that access_amu() does is to inject an UNDEF exception,
> so let's rename it to the clearer undef_access(). We'll reuse that
> for some other system registers.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 61789027b92b..fafaa81bf1f6 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1038,8 +1038,8 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	{ SYS_DESC(SYS_PMEVTYPERn_EL0(n)),					\
>  	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
>  
> -static bool access_amu(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> -			     const struct sys_reg_desc *r)
> +static bool undef_access(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			 const struct sys_reg_desc *r)
>  {
>  	kvm_inject_undefined(vcpu);

This seems to be identical to trap_ptrauth(). Shall we give it the same
treatment?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
