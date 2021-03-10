Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E7DC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 15:46:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 215B364FBF
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 15:46:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 215B364FBF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA9564B53D;
	Wed, 10 Mar 2021 10:46:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3dOEs+9X3slV; Wed, 10 Mar 2021 10:46:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA61D4B53C;
	Wed, 10 Mar 2021 10:46:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A8FA4B53A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 10:46:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p5jMvKIeX192 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 10:46:32 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 27B164B539
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 10:46:32 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A17C64F9B;
 Wed, 10 Mar 2021 15:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615391191;
 bh=8vc+t9597Gj+0rwLWp8DvyB0wv6J+I8bsOUKobbB8m0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Fe7vgIGRTKIo0wCFNOTGlUdE0URCo/cefTHyf+UByBTUerKvcPL66vWDOFqSrEBFs
 B6rF6h+yif7c1epUqr0ASg2bn8rlwiRkG4EK1xJ1DGKzlrAGH1U16ALssFLf0AZF+U
 HL0QqepNP9ivPjAG7kqjL0lZTR72cybWEgO7yhfM6MdcK04TfXbNULOdPEaib5Suk/
 3XqUx4WNeIEjW9PDo4prB7PyUVK2W7xJ5OXhNKbI0ZBbIxbFo7rbmhp0lKmOni/xMY
 Ml7gmR6FD/wWK6B1tNXN1mWT08GE97Udmf1HM6H4srA/r1U3K5Fd7QHLSawQodst4p
 Q9TGH5JjnCotQ==
Date: Wed, 10 Mar 2021 15:46:26 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 3/4] KVM: arm64: Rename SCTLR_ELx_FLAGS to SCTLR_EL2_FLAGS
Message-ID: <20210310154625.GA29738@willie-the-truck>
References: <20210310152656.3821253-1-maz@kernel.org>
 <20210310152656.3821253-4-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210310152656.3821253-4-maz@kernel.org>
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

On Wed, Mar 10, 2021 at 03:26:55PM +0000, Marc Zyngier wrote:
> Only the nVHE EL2 code is using this define, so let's make it
> plain that it is EL2 only.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h    | 2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index dfd4edbfe360..9d1aef631646 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -579,7 +579,7 @@
>  #define SCTLR_ELx_A	(BIT(1))
>  #define SCTLR_ELx_M	(BIT(0))
>  
> -#define SCTLR_ELx_FLAGS	(SCTLR_ELx_M  | SCTLR_ELx_A | SCTLR_ELx_C | \
> +#define SCTLR_EL2_FLAGS	(SCTLR_ELx_M  | SCTLR_ELx_A | SCTLR_ELx_C | \
>  			 SCTLR_ELx_SA | SCTLR_ELx_I | SCTLR_ELx_IESB)
>  
>  /* SCTLR_EL2 specific flags. */
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> index 4eb584ae13d9..7423f4d961a4 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> @@ -122,7 +122,7 @@ alternative_else_nop_endif
>  	 * as well as the EE bit on BE. Drop the A flag since the compiler
>  	 * is allowed to generate unaligned accesses.
>  	 */
> -	mov_q	x0, (SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
> +	mov_q	x0, (SCTLR_EL2_RES1 | (SCTLR_EL2_FLAGS & ~SCTLR_ELx_A))

Can we just drop SCTLR_ELx_A from SCTLR_EL2_FLAGS instead of clearing it
here?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
