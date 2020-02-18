Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B7F3C3403A
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 12:57:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B68BF2067D
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 12:56:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="O/IbGY37"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B68BF2067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AC554AF6E;
	Tue, 18 Feb 2020 07:56:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sDsI-0XxgIUZ; Tue, 18 Feb 2020 07:56:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30C554AF86;
	Tue, 18 Feb 2020 07:56:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E52AF4AF6E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 07:56:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YduftOcP8pdY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 07:56:56 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D15674AF50
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 07:56:55 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id AFD1B2067D;
 Tue, 18 Feb 2020 12:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1582030614;
 bh=iKFUgPb5d4wfMjQPUQ6PfD7r/Lrgwum7nR1aGEo56Sg=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=O/IbGY37uwPKrghGWSj5fYgIG+tVi4bnCrTe+t+GuZLs+/InwmUJWB4iaisXXpcJ1
 6Ul3ch+0anb02OOcsm3wJ7nZ6YM9RbBBvdiT+yLSqIDKTDeBwbIxafGXuXV7s6He47
 OujAkjTApyvVqDxpf2CmqfHjh5OF4+D2rf+b0PCQ=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j42Qm-006Dkm-TA; Tue, 18 Feb 2020 12:56:53 +0000
MIME-Version: 1.0
Date: Tue, 18 Feb 2020 12:56:52 +0000
From: Marc Zyngier <maz@kernel.org>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] arm64: kvm: Modernize annotation for __bp_harden_hyp_vecs
In-Reply-To: <20200218124456.10615-1-broonie@kernel.org>
References: <20200218124456.10615-1-broonie@kernel.org>
Message-ID: <49f7de5f1d86e7edcc34edb55d5011be@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: broonie@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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

Mark,

I'd really appreciate it if you could send these as a series, instead of
an isolated patch every other day.

On 2020-02-18 12:44, Mark Brown wrote:
> We have recently introduced new macros for annotating assembly symbols
> for things that aren't C functions, SYM_CODE_START() and 
> SYM_CODE_END(),
> in an effort to clarify and simplify our annotations of assembly files.
> 
> Using these for __bp_harden_hyp_vecs is more involved than for most 
> symbols
> as this symbol is annotated quite unusually as rather than just have 
> the
> explicit symbol we define _start and _end symbols which we then use to
> compute the length. This does not play at all nicely with the new style
> macros. Since the size of the vectors is a known constant which won't 
> vary
> the simplest thing to do is simply to drop the separate _start and _end
> symbols and just use a #define for the size.
> 
> Ideally we would have a build time assert to make sure we got this 
> right
> but we don't have such a thing for assembly code and given how unlikely
> the size is to change it seems disproportionately difficult to write 
> one
> just for this.

Actually, we do have a pretty easy way to ensure this, see below.

[...]

> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S 
> b/arch/arm64/kvm/hyp/hyp-entry.S
> index 0aea8f9ab23d..8976276685a1 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -312,11 +312,11 @@ alternative_cb_end
>  .endm
> 
>  	.align	11
> -ENTRY(__bp_harden_hyp_vecs_start)
> +SYM_CODE_START(__bp_harden_hyp_vecs)
>  	.rept BP_HARDEN_EL2_SLOTS
>  	generate_vectors
>  	.endr

1:      .org __bp_harden_hyp_vecs + __BP_HARDEN_HYP_VECS_SZ
         .org 1b

If you got it wrong one way or another, the assembler will scream
about the origin going backward. See eb7c11ee3c5 for details.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
