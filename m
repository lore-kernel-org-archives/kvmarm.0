Return-Path: <SRS0=VJ1f=EF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51DDFC00A89
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 08:19:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B34C2223F
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 08:19:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ok+t6cFV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B34C2223F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C13E74B20D;
	Fri, 30 Oct 2020 04:19:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id It1oVBCO-ML6; Fri, 30 Oct 2020 04:18:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFADC4B32F;
	Fri, 30 Oct 2020 04:18:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 302B34B319
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 04:18:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6-XWfwrjGWjC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2020 04:18:55 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 715FF4B20D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 04:18:55 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E267022228;
 Fri, 30 Oct 2020 08:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604045934;
 bh=8rOcJqln/miOd3/MTJuG+pTgP9+bOBD+gWzstFD1mIM=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ok+t6cFVSMvk9yCZJUphhwuMgW5HqneTdZkqc8rrov4e+TPjUe+KKm/vcUm3yiNoz
 n2v2L0HScgM/Lsuc0pRl8LBkOzajKkNYM0jV+ZvlnCiRqpX3R7dB6PzHdVNuIm4bAt
 4HsJJaGhdJml2f8sOgLByYLUzmFq7z1S6ZylWjIU=
Date: Fri, 30 Oct 2020 08:18:49 +0000
From: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCHv2 2/3] arm64: cpufeature: reorder
 cpus_have_{const,final}_cap()
Message-ID: <20201030081848.GB32066@willie-the-truck>
References: <20201026134931.28246-1-mark.rutland@arm.com>
 <20201026134931.28246-3-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201026134931.28246-3-mark.rutland@arm.com>
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

On Mon, Oct 26, 2020 at 01:49:30PM +0000, Mark Rutland wrote:
> In a subsequent patch we'll modify cpus_have_const_cap() to call
> cpus_have_final_cap(), and hence we need to define cpus_have_final_cap()
> first.
> 
> To make subsequent changes easier to follow, this patch reorders the two
> without making any other changes.
> 
> There should be no functional change as a result of this patch.

You say this...

> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: David Brazdil <dbrazdil@google.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/cpufeature.h | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index f7e7144af174c..5d18c54507e6a 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -428,35 +428,35 @@ static __always_inline bool __cpus_have_const_cap(int num)
>  }
>  
>  /*
> - * Test for a capability, possibly with a runtime check.
> + * Test for a capability without a runtime check.
>   *
> - * Before capabilities are finalized, this behaves as cpus_have_cap().
> + * Before capabilities are finalized, this will BUG().
>   * After capabilities are finalized, this is patched to avoid a runtime check.
>   *
>   * @num must be a compile-time constant.
>   */
> -static __always_inline bool cpus_have_const_cap(int num)
> +static __always_inline bool cpus_have_final_cap(int num)
>  {
>  	if (system_capabilities_finalized())
>  		return __cpus_have_const_cap(num);
>  	else
> -		return cpus_have_cap(num);
> +		BUG();

... but isn't the failure case of calling cpus_have_final_cap() early now
different? What does BUG() do at EL2 w/ nVHE?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
