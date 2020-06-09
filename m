Return-Path: <SRS0=btD/=7W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B17C433DF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Jun 2020 07:38:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EE3A52074B
	for <kvmarm@archiver.kernel.org>; Tue,  9 Jun 2020 07:38:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="FXRWngKX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE3A52074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BF244B35F;
	Tue,  9 Jun 2020 03:38:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1Geg6DxEcWT2; Tue,  9 Jun 2020 03:38:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 623FB4B30D;
	Tue,  9 Jun 2020 03:38:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A2014B2E4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2020 03:38:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DjovNdMELjQ7 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jun 2020 03:38:16 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2EE1C4B2E2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2020 03:38:16 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id F023F2074B;
 Tue,  9 Jun 2020 07:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1591688295;
 bh=XX5d5KaAtphU/kZf+qt3bMEwCoOYeQG5XQlitoBuT0Q=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=FXRWngKX4+Iu3JVdr/H3JTL7xz8zVI8QGaVBS/zbkHU+9Y4uLj8Gd51PkCr0Nlvyh
 /Ufzaws0PeRTThPPgPdtdgDZN+xT/YYUv9EBxKghVg+4KsIr9ZH1Q+zYUEXd+MWHa2
 xFskecywmzejx7r+8aPwA/faRCckoRf+kzZ0BqN8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jiYpp-001OCI-9n; Tue, 09 Jun 2020 08:38:13 +0100
MIME-Version: 1.0
Date: Tue, 09 Jun 2020 08:38:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Enforce PtrAuth being disabled if not
 advertized
In-Reply-To: <20200604153900.GE75320@C02TD0UTHF1T.local>
References: <20200604133354.1279412-1-maz@kernel.org>
 <20200604133354.1279412-4-maz@kernel.org>
 <20200604153900.GE75320@C02TD0UTHF1T.local>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <8c340ebe6be5d9c866c24ad55ed0a841@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: mark.rutland@arm.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 will@kernel.org, catalin.marinas@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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

Hi Mark,

On 2020-06-04 16:39, Mark Rutland wrote:
> Hi Marc,
> 
> On Thu, Jun 04, 2020 at 02:33:54PM +0100, Marc Zyngier wrote:
>> Even if we don't expose PtrAuth to a guest, the guest can still
>> write to its SCTIRLE_1 register and set the En{I,D}{A,B} bits
>> and execute PtrAuth instructions from the NOP space. This has
>> the effect of trapping to EL2, and we currently inject an UNDEF.
> 
> I think it's worth noting that this is an ill-behaved guest, as those
> bits are RES0 when pointer authentication isn't implemented.
> 
> The rationale for RES0/RES1 bits is that new HW can rely on old SW
> programming them with the 0/1 as appropriate, and that old SW that does
> not do so may encounter behaviour which from its PoV is UNPREDICTABLE.
> The SW side of the contract is that you must program them as 0/1 unless
> you know they're allocated with a specific meaning.
> 
> With that in mind I think the current behaviour is legitimate: from the
> guest's PoV it's the same as there being a distinct extension which it
> is not aware of where the En{I,D}{A,B} bits means "trap some HINTs to
> EL1".
> 
> I don't think that we should attempt to work around broken software 
> here
> unless we absolutely have to, as it only adds complexity for no real
> gain.

Fair enough. I was worried of the behaviour difference between HW 
without
PtrAuth and a guest with HW not advertised. Ideally, they should have
the same behaviour, but the architecture feels a bit brittle here.

Anyway, I'll drop this patch, and hopefully no guest will play this
game (they'll know pretty quickly about the issue anyway).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
