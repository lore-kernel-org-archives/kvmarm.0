Return-Path: <SRS0=VUvZ=62=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A86C54E8B
	for <kvmarm@archiver.kernel.org>; Tue, 12 May 2020 10:40:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC802206DD
	for <kvmarm@archiver.kernel.org>; Tue, 12 May 2020 10:40:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="DH7HX+hu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC802206DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39CFE4B132;
	Tue, 12 May 2020 06:40:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pEMIS-vU8bVy; Tue, 12 May 2020 06:40:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D6B94B133;
	Tue, 12 May 2020 06:40:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8975E4B120
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 May 2020 06:40:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zTQEDZOlsle8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 May 2020 06:40:00 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A19B34B0B8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 May 2020 06:40:00 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 704F5206DD;
 Tue, 12 May 2020 10:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1589279999;
 bh=4u2DdZnbBOfH5sHqCv28xYPkeReFp8gr/JDYY65Yi48=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=DH7HX+hu1vbOs62ildJh2vK9t5KtpaxktDPdEB2tlwDGMYkOHWB0chJU3wK/ybod+
 00KZ8Y8NlXgVSt7iCdPyn4FUppYC6i8BgaHGniYIk9O+v++8uFsAvJdnscAAUkxFIs
 wFKe1QtNCeHngIo2hJJCTyHLv3lcBRKywcaxXsFY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jYSKL-00BcWZ-MH; Tue, 12 May 2020 11:39:57 +0100
MIME-Version: 1.0
Date: Tue, 12 May 2020 11:39:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH] arm64/cpufeature: Add ID_AA64MMFR0_PARANGE_MASK
In-Reply-To: <1589249606-27177-1-git-send-email-anshuman.khandual@arm.com>
References: <1589249606-27177-1-git-send-email-anshuman.khandual@arm.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <b01bb1772b291e23ea82ff5855ee7e12@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: anshuman.khandual@arm.com,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, will@kernel.org,
 james.morse@arm.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Anshuman,

On 2020-05-12 03:13, Anshuman Khandual wrote:
> This replaces multiple open encoding (0x7) with 
> ID_AA64MMFR0_PARANGE_MASK
> thus cleaning the clutter. It modifies an existing ID_AA64MMFR0 helper 
> and
> introduces a new one i.e id_aa64mmfr0_iparange() and 
> id_aa64mmfr0_parange()
> respectively.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: James Morse <james.morse@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kvmarm@lists.cs.columbia.edu
> 
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> This applies after (https://patchwork.kernel.org/patch/11541893/).
> 
>  arch/arm64/include/asm/cpufeature.h | 11 ++++++++++-
>  arch/arm64/kernel/cpufeature.c      |  5 ++---
>  arch/arm64/kvm/reset.c              |  9 +++++----
>  3 files changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h
> b/arch/arm64/include/asm/cpufeature.h
> index 1291ad5a9ccb..320cfc5b6025 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -706,8 +706,17 @@ void arm64_set_ssbd_mitigation(bool state);
> 
>  extern int do_emulate_mrs(struct pt_regs *regs, u32 sys_reg, u32 rt);
> 
> -static inline u32 id_aa64mmfr0_parange_to_phys_shift(int parange)
> +#define ID_AA64MMFR0_PARANGE_MASK 0x7

I still disagree with this 7. Per the letter of the architecture, it
is wrong and should be 0xf, just like any other property described
in an ID register.

> +
> +static inline u32 id_aa64mmfr0_parange(u64 mmfr0)
>  {
> +	return mmfr0 & ID_AA64MMFR0_PARANGE_MASK;
> +}
> +
> +static inline u32 id_aa64mmfr0_iparange(u64 mmfr0)

There is also no such thing as an IPA range in the architecture.
Everything is PA. The only thing that actually describe an IPA
range is what KVM makes of it.

Overall, this patch confuses me more than anything else. I'd rather
you fix ID_AA64MMFR0_PARANGE_MASK to have the right value and be
done with it.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
