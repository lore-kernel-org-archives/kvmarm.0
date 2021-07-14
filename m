Return-Path: <SRS0=5+eb=MG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 529BCC07E9A
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 18:20:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C7AA0613C3
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 18:20:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7AA0613C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57F424A418;
	Wed, 14 Jul 2021 14:20:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8lD+xkHx+gyd; Wed, 14 Jul 2021 14:20:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 346BC4A4A0;
	Wed, 14 Jul 2021 14:20:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A0BD4A49C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 14:20:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DtnUyQmFXhrW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Jul 2021 14:20:43 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79EBC4A1A7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 14:20:43 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94F83613AF;
 Wed, 14 Jul 2021 18:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1626286841;
 bh=nO/96s5p8Ztw4znRhmgtBctfCupCbOzQEE2OvyClE7A=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=qRt9zSFbQ9msTRfWN/317jpXkUd4FLrwobn5NvdShUVqy5kFRVcgcez9oFddxu/Gn
 SxYxYKuYWf3MQrxMbnoU1u65GUKsfSqIcoFJ+GtBgDufu09NsepkvMKXTtESiXNenf
 QSRTYfB8OctrHKoAphvSiVX/5Z0iVhPTNrTZptkLLSrY3ed7vI8QR4MVm+OXFSE4bq
 75W0T35Fl1jV6LkoiCGLCD0JWw6/ZaCppqI6dEitU3AXOxcTuYB5zPiP/dV1fW2778
 tbWhCtOjc9d7DsimSuPe7ehMa+6hEf9Nt4anKRYZxeuUWkwnT203Wa7ypoafz99pLJ
 MKEzp0dg5CYag==
Date: Wed, 14 Jul 2021 19:20:37 +0100
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 5/5] KVM: arm64: nVHE: Remove unneeded isb() when
 modifying PMSCR_EL1
Message-ID: <20210714182036.GA32475@willie-the-truck>
References: <20210714095601.184854-1-alexandru.elisei@arm.com>
 <20210714095601.184854-6-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210714095601.184854-6-alexandru.elisei@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Wed, Jul 14, 2021 at 10:56:01AM +0100, Alexandru Elisei wrote:
> According to ARM DDI 0487G.a, page D9-2930, profiling is disabled when
> the PE is executing at a higher exception level than the profiling
> buffer owning exception level. This is also confirmed by the pseudocode
> for the StatisticalProfilingEnabled() function.
> 
> During the world switch and before activating guest traps, KVM executes
> at EL2 with the buffer owning exception level being EL1 (MDCR_EL2.E2PB =
> 0b11). As a result, profiling is already disabled when draining the
> buffer, making the isb() after the write to PMSCR_EL1 unnecessary.
> 
> CC: Will Deacon <will@kernel.org>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/debug-sr.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> index 7d3f25868cae..fdf0e0ba17e9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> @@ -33,7 +33,6 @@ static void __debug_save_spe(u64 *pmscr_el1)
>  	/* Yes; save the control register and disable data generation */
>  	*pmscr_el1 = read_sysreg_s(SYS_PMSCR_EL1);
>  	write_sysreg_s(0, SYS_PMSCR_EL1);
> -	isb();

Hmm, but we still need an ISB somewhere between clearing pmscr_el1 and
mdcr_el2.e2pb, right? Where does that occur?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
