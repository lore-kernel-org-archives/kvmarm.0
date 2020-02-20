Return-Path: <SRS0=1iKH=4I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7FAC11D04
	for <kvmarm@archiver.kernel.org>; Thu, 20 Feb 2020 11:01:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 027C0208C4
	for <kvmarm@archiver.kernel.org>; Thu, 20 Feb 2020 11:01:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="w5d0iEJz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 027C0208C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A32B4AF1D;
	Thu, 20 Feb 2020 06:01:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fAMMlvKCplAw; Thu, 20 Feb 2020 06:01:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 793D64AF7F;
	Thu, 20 Feb 2020 06:01:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E7F74AF73
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Feb 2020 06:01:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LdrhM-S0mDVL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Feb 2020 06:01:51 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 440334AF1D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Feb 2020 06:01:51 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 10B40208C4;
 Thu, 20 Feb 2020 11:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1582196510;
 bh=75+xq+IHwaECZYb5L8KpYt15Oi/0cJIf79a3hrpZIN8=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=w5d0iEJzl0jpxf97qkGXu/YehoA7Pybk3x+f8K45sCWbaTxVfd3oe12dwnZE8qiZi
 n8e9gykzGpCyv+O2oLVZWcmKHzjyTnCxuPzva+1TrudkCwvZbXXxlr/4FPQDlFrxAp
 5c7olFr7AlBeRQsjVGrouBbIORKa5yzmQYFLZUIY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j4jaW-006i86-95; Thu, 20 Feb 2020 11:01:48 +0000
MIME-Version: 1.0
Date: Thu, 20 Feb 2020 11:01:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: Stefan Agner <stefan@agner.ch>
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
In-Reply-To: <69845f739bbd91e73cd82e7c4683ab5a@agner.ch>
References: <20200210141324.21090-1-maz@kernel.org>
 <69845f739bbd91e73cd82e7c4683ab5a@agner.ch>
Message-ID: <cbad8640f275b9beab471ddd3136da72@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: stefan@agner.ch, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, vladimir.murzin@arm.com,
 linux@arm.linux.org.uk, arnd@arndb.de, suzuki.poulose@arm.com,
 qperret@google.com, Christoffer.Dall@arm.com, james.morse@arm.com,
 pbonzini@redhat.com, will@kernel.org, julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org,
 Arnd Bergmann <arnd@arndb.de>, Paolo Bonzini <pbonzini@redhat.com>,
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

On 2020-02-19 13:53, Stefan Agner wrote:
> On 2020-02-10 15:13, Marc Zyngier wrote:
>> KVM/arm was merged just over 7 years ago, and has lived a very quiet
>> life so far. It mostly works if you're prepared to deal with its
>> limitations, it has been a good prototype for the arm64 version,
>> but it suffers a few problems:
>> 
>> - It is incomplete (no debug support, no PMU)
>> - It hasn't followed any of the architectural evolutions
>> - It has zero users (I don't count myself here)
>> - It is more and more getting in the way of new arm64 developments
>> 
>> So here it is: unless someone screams and shows that they rely on
>> KVM/arm to be maintained upsteam, I'll remove 32bit host support
>> form the tree. One of the reasons that makes me confident nobody is
>> using it is that I never receive *any* bug report. Yes, it is perfect.
> 
> Not entirely true:
> https://lore.kernel.org/m/e2f7196ca6c70c55463a45b490f6731a@agner.ch

And I thank you for that. This bug was actually hitting both arm and
arm64, and triggered by a bogus DT (that KVM should have handled in a
nicer way). What I was trying to say is that nobody reports bugs that
are specific to 32bit KVM/arm.

> But, after that was fixed, it actually was perfect :-D
> https://blog.printk.io/2016/09/kvm-with-kvmtool-on-armv7/

Hey, neat! not sure how useful, but neat nonetheless... ;-)

> That said, I never used it in a real-world application, so from my side
> removing it is fine.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
