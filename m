Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E668BC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 20 Apr 2022 17:44:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 845424B0FB;
	Wed, 20 Apr 2022 13:44:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S585OZi7HR40; Wed, 20 Apr 2022 13:44:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77A094B17D;
	Wed, 20 Apr 2022 13:44:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B51E84B10C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 13:44:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yzOoEW4rgqgY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Apr 2022 13:44:08 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 77DA34B0FB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 13:44:08 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id CC6FAB81EB6;
 Wed, 20 Apr 2022 17:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797EBC385A0;
 Wed, 20 Apr 2022 17:44:03 +0000 (UTC)
Date: Wed, 20 Apr 2022 18:44:00 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 10/10] arm64: Use WFxT for __delay() when possible
Message-ID: <YmBGYLpaJJ3OZMQV@arm.com>
References: <20220419182755.601427-1-maz@kernel.org>
 <20220419182755.601427-11-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220419182755.601427-11-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Apr 19, 2022 at 07:27:55PM +0100, Marc Zyngier wrote:
> Marginally optimise __delay() by using a WFIT/WFET sequence.
> It probably is a win if no interrupt fires during the delay.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/lib/delay.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/lib/delay.c b/arch/arm64/lib/delay.c
> index 1688af0a4c97..5b7890139bc2 100644
> --- a/arch/arm64/lib/delay.c
> +++ b/arch/arm64/lib/delay.c
> @@ -27,7 +27,17 @@ void __delay(unsigned long cycles)
>  {
>  	cycles_t start = get_cycles();
>  
> -	if (arch_timer_evtstrm_available()) {
> +	if (cpus_have_const_cap(ARM64_HAS_WFXT)) {
> +		u64 end = start + cycles;
> +
> +		/*
> +		 * Start with WFIT. If an interrupt makes us resume
> +		 * early, use a WFET loop to complete the delay.
> +		 */
> +		wfit(end);
> +		while ((get_cycles() - start) < cycles)
> +			wfet(end);

Do you use WFET here as a pending interrupt would cause WFIT to complete
immediately?

> +	} else 	if (arch_timer_evtstrm_available()) {

Nit: two spaces between else and if ;).

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
