Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B551C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 13:32:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D3F5164F04
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 13:32:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3F5164F04
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E9A04B748;
	Thu, 18 Mar 2021 09:32:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EUO-jY-TxvVr; Thu, 18 Mar 2021 09:32:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 799CD4B747;
	Thu, 18 Mar 2021 09:32:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7B314B743
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 09:32:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZNXBGdQm0Kg3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 09:32:26 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7FE2B4B731
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 09:32:26 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 366D064F10;
 Thu, 18 Mar 2021 13:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1616074345;
 bh=k/oQ8zP5s60bX2Q7fVafPs3TLGk3bNIqQryqUT2a1LM=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=fWBNJXdZdvEZpAGhCuiqIokjkwW7pCbd5R0/BOmSfXIIjt221+LzmJBc32/Fz3/NE
 R5Y3R24wGtMdb2duE8a8UqFBzZyWRDOtXmbeG0VflSDjWKZpF6MJguDMb7eEyA2G+F
 fBNTraqlKk37t/cUTiJH2ObT1pbm4tXusmorZM0YtcsMpqTJr34gZ4JhD8MH9DLmEP
 UGYO8UOs3figMLsbVLgmtBa2rci20YgwZA3ILsZtWm5okif+axoM6g1far9GkbCmj8
 wCMy2jYfaVp5JSxPtEloWaHZlh/2KUo1R4lFwvJt5VaQAudsz+iaVI33II/mRgodmS
 3XPYoH9sJtK4w==
Date: Thu, 18 Mar 2021 13:32:19 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 05/11] arm64: sve: Provide a conditional update
 accessor for ZCR_ELx
Message-ID: <20210318133219.GB7055@willie-the-truck>
References: <20210318122532.505263-1-maz@kernel.org>
 <20210318122532.505263-6-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210318122532.505263-6-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, broonie@kernel.org, kernel-team@android.com,
 dave.martin@arm.com, linux-arm-kernel@lists.infradead.org, daniel.kiss@arm.com
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

On Thu, Mar 18, 2021 at 12:25:26PM +0000, Marc Zyngier wrote:
> A common pattern is to conditionally update ZCR_ELx in order
> to avoid the "self-synchronizing" effect that writing to this
> register has.
> 
> Let's provide an accessor that does exactly this.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimd.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index bec5f14b622a..05c9c55768b8 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -130,6 +130,15 @@ static inline void sve_user_enable(void)
>  	sysreg_clear_set(cpacr_el1, 0, CPACR_EL1_ZEN_EL0EN);
>  }
>  
> +#define sve_cond_update_zcr_vq(val, reg)		\
> +	do {						\
> +		u64 __zcr = read_sysreg_s((reg));	\
> +		u64 __new = __zcr & ~ZCR_ELx_LEN_MASK;	\
> +		__new |= (val) & ZCR_ELx_LEN_MASK;	\
> +		if (__zcr != __new)			\
> +			write_sysreg_s(__new, (reg));	\
> +	} while (0)

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
