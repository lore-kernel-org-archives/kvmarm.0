Return-Path: <SRS0=4Xsg=BG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8892BC433E5
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 08:45:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 08A39206E7
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 08:45:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5qrqw4P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08A39206E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D5554B962;
	Mon, 27 Jul 2020 04:45:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lGTXv7v4WBGG; Mon, 27 Jul 2020 04:45:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 716BA4B965;
	Mon, 27 Jul 2020 04:45:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3C744B92A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 04:45:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PsM30BQhXTKs for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jul 2020 04:45:41 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAA614B928
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 04:45:41 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B5B53206E7;
 Mon, 27 Jul 2020 08:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595839540;
 bh=Nwy/9AceCVZccPtRek5FKyF9lezJHnD/c73mokFxDqw=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=k5qrqw4PCDRdsjvNeosfwztY9RFnQbcicgc9l37SrxNlHudSxa+cxX5ROyQ/Mouqc
 B4QCmc1zG9ofbGSxswKJSTRjT7Z+rvxSMTFwVzvrua1jmo8qPaCzVQivHVCMnBI63o
 6igIfKhlFL0Jru6AyyfRqAy+nkA+VIQiEr/oTjS4=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jzylP-00FEs4-7m; Mon, 27 Jul 2020 09:45:39 +0100
MIME-Version: 1.0
Date: Mon, 27 Jul 2020 09:45:39 +0100
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 0/3] KVM: arm64: Clean up memcache usage for page-table
 pages
In-Reply-To: <20200723110227.16001-1-will@kernel.org>
References: <20200723110227.16001-1-will@kernel.org>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <ae7caba0eb8ab45db3aa4ae7f97820a3@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, kvmarm@lists.cs.columbia.edu,
 qperret@google.com, linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

Hi Will,

On 2020-07-23 12:02, Will Deacon wrote:
> Hi all,
> 
> Here are some small cleanups I made to the memcache logic while hacking 
> on the
> page-table code. The ioremap() behaviour looks like a bug to me, 
> although it's
> just a performance thing so nothing urgent.
> 
> Cheers,
> 
> Will
> 
> --->8
> 
> Will Deacon (3):
>   KVM: arm64: Don't free memcache pages in kvm_phys_addr_ioremap()
>   KVM: arm64: Simplify mmu_topup_memory_cache()
>   KVM: arm64: Remove mmu_free_memory_cache()
> 
>  arch/arm64/kvm/mmu.c | 34 ++++++++++++++--------------------
>  1 file changed, 14 insertions(+), 20 deletions(-)

Although I'm OK with this series, it conflicts with the changes
Sean did on the MMU memory cache in the core code, which also
affects arm64.

I guess I'll queue patch 1 and 3 as fixes post -rc1. Patch 2 doesn't
seem to make sense anymore in that context.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
