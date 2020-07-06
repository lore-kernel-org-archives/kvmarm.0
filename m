Return-Path: <SRS0=KDMR=AR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7964FC433E0
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 10:11:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E53FC20739
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 10:11:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="lKmXP9LG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E53FC20739
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A1DD4B408;
	Mon,  6 Jul 2020 06:11:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fx9emWKu58Ve; Mon,  6 Jul 2020 06:11:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C6334B3E7;
	Mon,  6 Jul 2020 06:11:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64A4D4B3D1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 06:11:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ocgXivRbF9Q3 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2020 06:11:18 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D0994B3C9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 06:11:18 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 34C9420739;
 Mon,  6 Jul 2020 10:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1594030277;
 bh=mPPsT1QIJ2Rp9EBVG+gL+haA6Wlv2nggAMWKvcF4MEk=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=lKmXP9LG0URaJmbrToTyGAAN/X/eL5vXkwCjN1tihkuIA+MedOEizTLcqAxvOtV+/
 V1yfW8sPlaBCCCrbzWyuK8wlZACeoLDO/UjTV7yqOBc5Lv31qLgzss0/wtNyrlzNeA
 Q/TSzT++Cw8HJAtcbQ1wBLjv+flOqNSWMO6rgC9A=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jsO5j-009Q3j-Fu; Mon, 06 Jul 2020 11:11:15 +0100
MIME-Version: 1.0
Date: Mon, 06 Jul 2020 11:11:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH] arm64: kvm: Stop clobbering x0 for HVC_SOFT_RESTART
In-Reply-To: <20200706095259.1338221-1-ascull@google.com>
References: <20200706095259.1338221-1-ascull@google.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <a765085746f61ed8deff396fae1d89a1@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ascull@google.com, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, suzuki.poulose@arm.com, julien.thierry.kdev@gmail.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On 2020-07-06 10:52, Andrew Scull wrote:
> HVC_SOFT_RESTART is given values for x0-2 that it should installed
> before exiting to the new address so should not set x0 to stub HVC
> success or failure code.
> 
> Signed-off-by: Andrew Scull <ascull@google.com>
> ---
>  arch/arm64/kvm/hyp-init.S | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
> index 6e6ed5581eed..e76c0e89d48e 100644
> --- a/arch/arm64/kvm/hyp-init.S
> +++ b/arch/arm64/kvm/hyp-init.S
> @@ -136,11 +136,15 @@ SYM_CODE_START(__kvm_handle_stub_hvc)
> 
>  1:	cmp	x0, #HVC_RESET_VECTORS
>  	b.ne	1f
> -reset:
> +
>  	/*
> -	 * Reset kvm back to the hyp stub. Do not clobber x0-x4 in
> -	 * case we coming via HVC_SOFT_RESTART.
> +	 * Set the HVC_RESET_VECTORS return code before entering the common
> +	 * path so that we do not clobber x0-x2 in case we are coming via
> +	 * HVC_SOFT_RESTART.
>  	 */
> +	mov	x0, xzr
> +reset:
> +	/* Reset kvm back to the hyp stub. */
>  	mrs	x5, sctlr_el2
>  	mov_q	x6, SCTLR_ELx_FLAGS
>  	bic	x5, x5, x6		// Clear SCTL_M and etc
> @@ -151,7 +155,6 @@ reset:
>  	/* Install stub vectors */
>  	adr_l	x5, __hyp_stub_vectors
>  	msr	vbar_el2, x5
> -	mov	x0, xzr
>  	eret
> 
>  1:	/* Bad stub call */

Huh, nice catch. I wonder what the fuss is about kexec, really,
given that it is *that* broken. This deserves:

Fixes: af42f20480bf1 ("arm64: hyp-stub: Zero x0 on successful stub 
handling")
Cc: stable@vger.kernel.org

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
