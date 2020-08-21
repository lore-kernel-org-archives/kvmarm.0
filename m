Return-Path: <SRS0=jF9t=B7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22915C433DF
	for <kvmarm@archiver.kernel.org>; Fri, 21 Aug 2020 12:45:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9638C207DA
	for <kvmarm@archiver.kernel.org>; Fri, 21 Aug 2020 12:45:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="GC8Bv/ve"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9638C207DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 375204C4CB;
	Fri, 21 Aug 2020 08:45:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2ZDD4L+c6NoS; Fri, 21 Aug 2020 08:45:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 191E14C4D4;
	Fri, 21 Aug 2020 08:45:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BC024C4D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Aug 2020 08:45:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1JlnbQiVs9Dd for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Aug 2020 08:45:43 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1EBB14C4CB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Aug 2020 08:45:43 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0395E2078D;
 Fri, 21 Aug 2020 12:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1598013942;
 bh=+m+pk9tP+dvLl4RuuawbUoq3y+/lwD8wVqsM+12XCr4=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=GC8Bv/vejINTmgHLUFOM8Bkp9Jav2vH3AmH9bKQT04LL9m7OmOIbLTak4z3W2TFWw
 QA8DVtuA0HFxkVVFeJlVMk4RHQsyJBLECoqMHKEcN+o98LOZqE/W7J+khC+BWFWsbN
 U8Rqq5dIEy9XqTjUl+g8pZeXZ5xVk/geuBY+eGo4=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k96QO-004rdb-Ey; Fri, 21 Aug 2020 13:45:40 +0100
MIME-Version: 1.0
Date: Fri, 21 Aug 2020 13:45:40 +0100
From: Marc Zyngier <maz@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 3/3] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
In-Reply-To: <20200821122633.GC6823@gaia>
References: <20200803193127.3012242-1-robh@kernel.org>
 <20200803193127.3012242-4-robh@kernel.org> <20200821120659.GB6823@gaia>
 <20200821121209.GB20833@willie-the-truck> <20200821122633.GC6823@gaia>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <8c641833ff20d5a35981c456d4fe1d5a@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, will@kernel.org, robh@kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, ascull@google.com, julien.thierry.kdev@gmail.com,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Rob Herring <robh@kernel.org>, Will Deacon <will@kernel.org>,
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

On 2020-08-21 13:26, Catalin Marinas wrote:
> On Fri, Aug 21, 2020 at 01:12:10PM +0100, Will Deacon wrote:
>> On Fri, Aug 21, 2020 at 01:07:00PM +0100, Catalin Marinas wrote:
>> > On Mon, Aug 03, 2020 at 01:31:27PM -0600, Rob Herring wrote:
>> > > @@ -979,6 +980,14 @@
>> > >  		write_sysreg(__scs_new, sysreg);			\
>> > >  } while (0)
>> > >
>> > > +#define read_sysreg_par() ({						\
>> > > +	u64 par;							\
>> > > +	asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));	\
>> > > +	par = read_sysreg(par_el1);					\
>> > > +	asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));	\
>> > > +	par;								\
>> > > +})
>> >
>> > I was about to queue this up but one more point to clarify: can we get
>> > an interrupt at either side of the PAR_EL1 read and the handler do a
>> > device read, triggering the erratum? Do we need a DMB at exception
>> > entry/return?
>> 
>> Disabling irqs around the PAR access would be simpler, I think 
>> (assuming
>> this is needed).
> 
> This wouldn't work if it interrupts a guest.

If we take an interrupt either side of the PAR_EL1 read and that we
fully exit, the saving of PAR_EL1 on the way out solves the problem.

If we don't fully exit, but instead reenter the guest immediately
(fixup_guest_exit() returns true), we'd need a DMB at that point,
at least because of the GICv2 proxying code which performs device
accesses on the guest's behalf.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
