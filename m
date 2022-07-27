Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57AD9C04A68
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jul 2022 10:29:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C55D54C234;
	Wed, 27 Jul 2022 06:29:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id peqPwBaXTRnq; Wed, 27 Jul 2022 06:29:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8E994C23D;
	Wed, 27 Jul 2022 06:29:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07CB84C16A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 06:29:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YNXBL+UevAC9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jul 2022 06:29:07 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F35624C134
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 06:29:06 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 021BD61890;
 Wed, 27 Jul 2022 10:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5EFC433C1;
 Wed, 27 Jul 2022 10:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658917745;
 bh=k7tkDxaVldkgNY6v5HDU0WVJ3P6FzrFX1cTrwhCaA0c=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=C3IUlHDrNiHD/YTAP3Lbvcl8S+yH10qcS34z2WTpVdZBpvKBsAShSb5yvCg/usTJc
 BiRfZeUwcBI0PD6RwR7e1KmkHSl6rqrCUvwcNFHnNDDbGEMmNRp8nwES4MOOOOfwhL
 uU7u1vbnPeVPKWSYNVmqNUmi9UInJGl0E8xFliU/x/1hs48/Vi1tb+t0BGGl/Srh0x
 IP3MsLHgFHGSKeT0WxQSciM15ePW2oJZtDRE2fHlfscgUfz1PB0iRF2tGf1l6DQ3Wi
 ZncXUN9xH5vrGIKfiLm5UuZSYt+ceke6ucYfSyhe9FLh3Fra7PFhE0gFBLeXaY7kkw
 IEyESZJwB55FA==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oGeHn-00AN7S-6E;
 Wed, 27 Jul 2022 11:29:03 +0100
MIME-Version: 1.0
Date: Wed, 27 Jul 2022 11:29:03 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead of
 pinning VM memory
In-Reply-To: <YuERKEjJh1qsZf8x@monolith.localdoman>
References: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
 <20220419141012.GB6143@willie-the-truck>
 <Yt5nFAscgrRGNGoH@monolith.localdoman> <YuApmZFdZzTi5ROu@google.com>
 <YuERKEjJh1qsZf8x@monolith.localdoman>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <04dea801e298374fb783bf0760b15241@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, oliver.upton@linux.dev,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On 2022-07-27 11:19, Alexandru Elisei wrote:
> Hi Oliver,
> 
> Thank you for the help, replies below.
> 
> On Tue, Jul 26, 2022 at 10:51:21AM -0700, Oliver Upton wrote:
>> Hi Alex,
>> 
>> On Mon, Jul 25, 2022 at 11:06:24AM +0100, Alexandru Elisei wrote:
>> 
>> [...]
>> 
>> > > A funkier approach might be to defer pinning of the buffer until the SPE is
>> > > enabled and avoid pinning all of VM memory that way, although I can't
>> > > immediately tell how flexible the architecture is in allowing you to cache
>> > > the base/limit values.
>> >
>> > I was investigating this approach, and Mark raised a concern that I think
>> > might be a showstopper.
>> >
>> > Let's consider this scenario:
>> >
>> > Initial conditions: guest at EL1, profiling disabled (PMBLIMITR_EL1.E = 0,
>> > PMBSR_EL1.S = 0, PMSCR_EL1.{E0SPE,E1SPE} = {0,0}).
>> >
>> > 1. Guest programs the buffer and enables it (PMBLIMITR_EL1.E = 1).
>> > 2. Guest programs SPE to enable profiling at **EL0**
>> > (PMSCR_EL1.{E0SPE,E1SPE} = {1,0}).
>> > 3. Guest changes the translation table entries for the buffer. The
>> > architecture allows this.
>> > 4. Guest does an ERET to EL0, thus enabling profiling.
>> >
>> > Since KVM cannot trap the ERET to EL0, it will be impossible for KVM to pin
>> > the buffer at stage 2 when profiling gets enabled at EL0.
>> 
>> Not saying we necessarily should, but this is possible with FGT no?
> 
> It doesn't look to me like FEAT_FGT offers any knobs to trap ERET from 
> EL1.

See HFGITR.ERET.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
