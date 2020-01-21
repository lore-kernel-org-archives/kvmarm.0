Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5574DC2D0CE
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 13:45:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D9FE72070C
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 13:45:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/KKuy4J"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D9FE72070C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CCB14B015;
	Tue, 21 Jan 2020 08:45:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5dGXhJYfwxdb; Tue, 21 Jan 2020 08:45:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D43684AFDC;
	Tue, 21 Jan 2020 08:45:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8409A4AFC9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 08:45:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wud3j72OZ3+Y for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 08:45:37 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6AA3A4AFC7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 08:45:37 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4F2532070C;
 Tue, 21 Jan 2020 13:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579614336;
 bh=r6IjPIIvHPssKgptLF7z6q1SW5YE+6xDoibBsBjBfPc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=U/KKuy4JXYU6cI5FX+vmu3vGzvOv0KdTruNP/UNumozMQYSU7hGqPKWogveu5Takc
 fJIcEy+icTfQjHxatXOwmHmdN/xytLoKpqxxDIJ8i0/aU9beBmyBJ+FesFiOpd5iTC
 dQaEQ6ZV3ReKZ+n5PExfklo9FafPG5SXNxEOxAZI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1ittqY-000VmX-I2; Tue, 21 Jan 2020 13:45:34 +0000
MIME-Version: 1.0
Date: Tue, 21 Jan 2020 13:45:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 0/2] KVM: arm: fix KVM_CAP_ARM_INJECT_EXT_DABT for aarch32
 guests
In-Reply-To: <20200121123356.203000-1-james.morse@arm.com>
References: <20200121123356.203000-1-james.morse@arm.com>
Message-ID: <9e0b2d798e9d0e0bede372a3e3cf4fdb@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, kvmarm@lists.cs.columbia.edu,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 beata.michalska@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu
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

Hi James,

Thanks for this.

On 2020-01-21 12:33, James Morse wrote:
> Beata reports that KVM_CAP_ARM_INJECT_EXT_DABT doesn't do the expected
> thing for aarch32 guests. We get the wrong register layout, and weren't
> even trying to set a 'external abort' in the first place!
> 
> Both patches are intended as fixes, but patch 2 is somewhat in the eye
> of the beholder. I don't know why an imp-def exception was picked...

Because we had no idea what we were doing (this is all 2013 vintage).
This code comes from e82e030556e42e8 (the initial arm64 port), which
didn't do the same thing as 5b3e5e5bf230f56 (the 32bit version).

Both were wrong. BTW.

> 
> Thanks,
> 
> James Morse (2):
>   KVM: arm: fix DFSR setting for non-LPAE aarch32 guests
>   KVM: arm: Make inject_abt32() inject an external abort instead
> 
>  virt/kvm/arm/aarch32.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)

It all looks good to me. I'm minded to add a

Fixes: 74a64a981662a ("KVM: arm/arm64: Unify 32bit fault injection")

to the second patch as well, so that KVM_CAP_ARM_INJECT_EXT_DABT does
what it says on the tin.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
