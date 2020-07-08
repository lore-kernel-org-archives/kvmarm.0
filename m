Return-Path: <SRS0=frvT=AT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB292C433E0
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jul 2020 16:59:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3735B206F6
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jul 2020 16:59:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="LPOU23/W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3735B206F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6EFB4B167;
	Wed,  8 Jul 2020 12:59:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w6gITSt6kyLt; Wed,  8 Jul 2020 12:59:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC9F54B1A4;
	Wed,  8 Jul 2020 12:59:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4803B4B1A6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2020 12:59:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id blH0qrNEn5AY for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2020 12:59:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50F7B4B1A4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2020 12:59:32 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EFD11206F6;
 Wed,  8 Jul 2020 16:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1594227571;
 bh=uh4+uFjSS8z4pzDfvQDdc+cDo68c1srgnsXeCX9tkrM=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=LPOU23/WvkxwZI/Js3Zh7GK/6l9f479mhy5NmU59FlaNEvxCW0kiCAXv03Cq25GdU
 0Q7cNxfNnZ5pAnPqAswpQedsrGbgbH250JStUEa1C+5lH13PgW38dBl/PbI4olK495
 wprTQbPlJqgZVFFbs3QBnEqdjTdZ60UZMHgeHm4A=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jtDPt-00A9GR-GX; Wed, 08 Jul 2020 17:59:29 +0100
MIME-Version: 1.0
Date: Wed, 08 Jul 2020 17:59:29 +0100
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix definition of PAGE_HYP_DEVICE
In-Reply-To: <20200708162546.26176-1-will@kernel.org>
References: <20200708162546.26176-1-will@kernel.org>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <aa1d1bc3bbef499a909ca6367d1bc77b@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kernel-team@android.com, catalin.marinas@arm.com,
 james.morse@arm.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, stable@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On 2020-07-08 17:25, Will Deacon wrote:
> PAGE_HYP_DEVICE is intended to encode attribute bits for an EL2 stage-1
> pte mapping a device. Unfortunately, it includes PROT_DEVICE_nGnRE 
> which
> encodes attributes for EL1 stage-1 mappings such as UXN and nG, which 
> are
> RES0 for EL2, and DBM which is meaningless as TCR_EL2.HD is not set.
> 
> Fix the definition of PAGE_HYP_DEVICE so that it doesn't set RES0 bits
> at EL2.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
> Marc -- I'm happy to take this as a fix via arm64 with your Ack.
> Please just let me know.
> 
>  arch/arm64/include/asm/pgtable-prot.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Marc Zyngier <maz@kernel.org>

Thanks for fixing this!

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
