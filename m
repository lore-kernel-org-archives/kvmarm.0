Return-Path: <SRS0=B0kT=CR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D6AAC433E2
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 10:33:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AE4AA215A4
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 10:33:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="R7v/c6AX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE4AA215A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F8B84B5AC;
	Tue,  8 Sep 2020 06:33:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R0ranfR1VHEX; Tue,  8 Sep 2020 06:33:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 243904B5A6;
	Tue,  8 Sep 2020 06:33:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 285894B2CC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 06:33:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CSXoAktGL4RJ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Sep 2020 06:33:38 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B8D84B20A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 06:33:38 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EF5CA206DB;
 Tue,  8 Sep 2020 10:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599561217;
 bh=PMfT0ScqlJVrW1ovi6ZQx1FR07TKRP2CB/NC9+r+dmM=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=R7v/c6AXSfaadD/CO+AbDfegeAM+y9tDoBvYp6KE7TlPmyJdOL4Ta3ObeRRqDiOSH
 o/MstQiA+hluNVnME3gbT9qtc/mcdW8HfkP/sveuhvBcCIZDJ3Uhhi/EsQ5Rj3mhb2
 T9d5TChhLpC/xDEg9swT4W2JS9mSNC+0CPYxWcxc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kFawR-00A20e-4o; Tue, 08 Sep 2020 11:33:35 +0100
MIME-Version: 1.0
Date: Tue, 08 Sep 2020 11:33:35 +0100
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 19/21] KVM: arm64: Remove unused page-table code
In-Reply-To: <20200907152344.12978-20-will@kernel.org>
References: <20200907152344.12978-1-will@kernel.org>
 <20200907152344.12978-20-will@kernel.org>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <6674b70b99e82fb8084f801bfca84f37@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, kvmarm@lists.cs.columbia.edu,
 kernel-team@android.com, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, kernel-team@android.com,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Will,

On 2020-09-07 16:23, Will Deacon wrote:
> Now that KVM is using the generic page-table code to manage the guest
> stage-2 page-tables, we can remove a bunch of unused macros, #defines
> and static inline functions from the old implementation.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_mmu.h        | 171 ------
>  arch/arm64/include/asm/pgtable-hwdef.h  |  17 -
>  arch/arm64/include/asm/pgtable-prot.h   |  13 -
>  arch/arm64/include/asm/stage2_pgtable.h | 215 -------
>  arch/arm64/kvm/mmu.c                    | 755 ------------------------
>  5 files changed, 1171 deletions(-)
> 

[...]

> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h
> b/arch/arm64/include/asm/pgtable-hwdef.h
> index 1a989353144e..bb97d464f42b 100644
> --- a/arch/arm64/include/asm/pgtable-hwdef.h
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> @@ -172,23 +172,6 @@
>  #define PTE_ATTRINDX(t)		(_AT(pteval_t, (t)) << 2)
>  #define PTE_ATTRINDX_MASK	(_AT(pteval_t, 7) << 2)
> 
> -/*
> - * 2nd stage PTE definitions
> - */
> -#define PTE_S2_RDONLY		(_AT(pteval_t, 1) << 6)   /* HAP[2:1] */
> -#define PTE_S2_RDWR		(_AT(pteval_t, 3) << 6)   /* HAP[2:1] */
> -#define PTE_S2_XN		(_AT(pteval_t, 2) << 53)  /* XN[1:0] */
> -#define PTE_S2_SW_RESVD		(_AT(pteval_t, 15) << 55) /* Reserved for SW 
> */
> -
> -#define PMD_S2_RDONLY		(_AT(pmdval_t, 1) << 6)   /* HAP[2:1] */
> -#define PMD_S2_RDWR		(_AT(pmdval_t, 3) << 6)   /* HAP[2:1] */
> -#define PMD_S2_XN		(_AT(pmdval_t, 2) << 53)  /* XN[1:0] */
> -#define PMD_S2_SW_RESVD		(_AT(pmdval_t, 15) << 55) /* Reserved for SW 
> */
> -
> -#define PUD_S2_RDONLY		(_AT(pudval_t, 1) << 6)   /* HAP[2:1] */
> -#define PUD_S2_RDWR		(_AT(pudval_t, 3) << 6)   /* HAP[2:1] */
> -#define PUD_S2_XN		(_AT(pudval_t, 2) << 53)  /* XN[1:0] */
> -
>  /*
>   * Memory Attribute override for Stage-2 (MemAttr[3:0])
>   */

This breaks the (still out of tree) NV patches, which use some of
these definitions as part of the architectural S2 PTW.

I can either keep a KVM-private copy, or revert this hunk. What do
you think?

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
