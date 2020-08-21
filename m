Return-Path: <SRS0=jF9t=B7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1DA1C433E1
	for <kvmarm@archiver.kernel.org>; Fri, 21 Aug 2020 12:26:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 610F220724
	for <kvmarm@archiver.kernel.org>; Fri, 21 Aug 2020 12:26:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 610F220724
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0558C4C4D0;
	Fri, 21 Aug 2020 08:26:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VPle+NwUZI57; Fri, 21 Aug 2020 08:26:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7F1B4C4D3;
	Fri, 21 Aug 2020 08:26:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 814994C4D1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Aug 2020 08:26:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DugFDnVDYDKt for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Aug 2020 08:26:38 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E6BD4C4D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Aug 2020 08:26:38 -0400 (EDT)
Received: from gaia (unknown [95.146.230.145])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E1F6E20724;
 Fri, 21 Aug 2020 12:26:35 +0000 (UTC)
Date: Fri, 21 Aug 2020 13:26:33 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 3/3] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
Message-ID: <20200821122633.GC6823@gaia>
References: <20200803193127.3012242-1-robh@kernel.org>
 <20200803193127.3012242-4-robh@kernel.org>
 <20200821120659.GB6823@gaia>
 <20200821121209.GB20833@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200821121209.GB20833@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Rob Herring <robh@kernel.org>, Marc Zyngier <maz@kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Aug 21, 2020 at 01:12:10PM +0100, Will Deacon wrote:
> On Fri, Aug 21, 2020 at 01:07:00PM +0100, Catalin Marinas wrote:
> > On Mon, Aug 03, 2020 at 01:31:27PM -0600, Rob Herring wrote:
> > > @@ -979,6 +980,14 @@
> > >  		write_sysreg(__scs_new, sysreg);			\
> > >  } while (0)
> > > 
> > > +#define read_sysreg_par() ({						\
> > > +	u64 par;							\
> > > +	asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));	\
> > > +	par = read_sysreg(par_el1);					\
> > > +	asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));	\
> > > +	par;								\
> > > +})
> > 
> > I was about to queue this up but one more point to clarify: can we get
> > an interrupt at either side of the PAR_EL1 read and the handler do a
> > device read, triggering the erratum? Do we need a DMB at exception
> > entry/return?
> 
> Disabling irqs around the PAR access would be simpler, I think (assuming
> this is needed).

This wouldn't work if it interrupts a guest.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
