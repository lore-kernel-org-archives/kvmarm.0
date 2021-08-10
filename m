Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F35AC4338F
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 13:21:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B327361008
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 13:21:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B327361008
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 370CC4A483;
	Tue, 10 Aug 2021 09:21:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ONY8D4ker6EW; Tue, 10 Aug 2021 09:21:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCFB54A3A3;
	Tue, 10 Aug 2021 09:21:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03D474A3A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 09:21:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h6vIpnCpy0Ot for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Aug 2021 09:21:31 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2002C4A19F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 09:21:31 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57CE260F38;
 Tue, 10 Aug 2021 13:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628601690;
 bh=jqyHZ175J/Gvvs023uqRUmo52RsbbfMGvn++lpbF66s=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=I+a4GHR4h1dHtT1sJaTfvsu8J2/xAVbb8xQvxOWtAZkgpn26IlUZ/GFV/gaQYEbGV
 lPxKHhT2GkVeHO6Xwvno6jh1lBza6SRE8pvMIqH/Rh3wl/+LCzNUK1nQLQxcfO7Bba
 OId6prpx1+pskLJVHqM3W0VaZjMdN8WDujnwOd3kKK1QTuEpqYAuV6pbX9s1+MQicX
 6re4qQcHFaRDpWO4wq6WRcP7bMmn/hi7L5k3sc+yZ107nm1nFUWIC4C12AEM3i4um6
 q3JD/05M7BgrMyMwt5l72dUcXFqH1rrruzEzn0A08IFety7rDlp8ODT2jTXG7z6MLr
 PoAnqpxa3E6pw==
Date: Tue, 10 Aug 2021 14:21:24 +0100
From: Will Deacon <will@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH 2/5] KVM: arm64: Drop init_common_resources()
Message-ID: <20210810132123.GB2946@willie-the-truck>
References: <1628578961-29097-1-git-send-email-anshuman.khandual@arm.com>
 <1628578961-29097-3-git-send-email-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1628578961-29097-3-git-send-email-anshuman.khandual@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
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

On Tue, Aug 10, 2021 at 12:32:38PM +0530, Anshuman Khandual wrote:
> Could do without this additional indirection via init_common_resources() by
> just calling kvm_set_ipa_limit() directly instead. This change saves memory
> and cycles.

Does it? Really?

Will

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e9a2b8f27792..19560e457c11 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1696,11 +1696,6 @@ static bool init_psci_relay(void)
>  	return true;
>  }
>  
> -static int init_common_resources(void)
> -{
> -	return kvm_set_ipa_limit();
> -}
> -
>  static int init_subsystems(void)
>  {
>  	int err = 0;
> @@ -2102,7 +2097,7 @@ int kvm_arch_init(void *opaque)
>  		}
>  	}
>  
> -	err = init_common_resources();
> +	err = kvm_set_ipa_limit();
>  	if (err)
>  		return err;
>  
> -- 
> 2.20.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
