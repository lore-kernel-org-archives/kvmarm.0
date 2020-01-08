Return-Path: <SRS0=HiVh=25=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26DBC33C9E
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jan 2020 11:37:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4DAF5206DA
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jan 2020 11:37:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DAF5206DA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EC954B03D;
	Wed,  8 Jan 2020 06:37:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V-aBMhQoD+eo; Wed,  8 Jan 2020 06:37:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 666FE4B006;
	Wed,  8 Jan 2020 06:37:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6E534B006
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jan 2020 06:37:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 63L-hBm81zUB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jan 2020 06:37:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4F024AFEF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jan 2020 06:37:22 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4765D31B;
 Wed,  8 Jan 2020 03:37:22 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D005F3F703;
 Wed,  8 Jan 2020 03:37:20 -0800 (PST)
Date: Wed, 8 Jan 2020 11:37:18 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 2/3] KVM: arm/arm64: correct CPSR on exception entry
Message-ID: <20200108113718.GC49203@lakrids.cambridge.arm.com>
References: <20191220150549.31948-1-mark.rutland@arm.com>
 <20191220150549.31948-3-mark.rutland@arm.com>
 <775a6053-ad90-bf2f-43f0-11f71d34f4a1@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <775a6053-ad90-bf2f-43f0-11f71d34f4a1@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: maz@kernel.org, stable@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Dec 27, 2019 at 03:42:34PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On 12/20/19 3:05 PM, Mark Rutland wrote:
> > When KVM injects an exception into a guest, it generates the CPSR value
> > from scratch, configuring CPSR.{M,A,I,T,E}, and setting all other
> > bits to zero.
> >
> > This isn't correct, as the architecture specifies that some CPSR bits
> > are (conditionally) cleared or set upon an exception, and others are
> > unchanged from the original context.
> >
> > This patch adds logic to match the architectural behaviour. To make this
> > simple to follow/audit/extend, documentation references are provided,
> > and bits are configured in order of their layout in SPSR_EL2. This
> 
> This patch applies equally well to 32bit KVM, where we have a SPSR register.

Indeed. The above wasn't intended to imply otherwise, but I'll add the
following to make that clear:

| Note that this code is used by both arm and arm64, and is intended to
| fuction with the SPSR_EL2 and SPSR_hyp layouts.

[...]

> >  /* arm64 compatibility macros */
> > +#define PSR_AA32_MODE_FIQ	FIQ_MODE
> > +#define PSR_AA32_MODE_SVC	SVC_MODE
> >  #define PSR_AA32_MODE_ABT	ABT_MODE
> >  #define PSR_AA32_MODE_UND	UND_MODE
> >  #define PSR_AA32_T_BIT		PSR_T_BIT
> > +#define PSR_AA32_F_BIT		PSR_F_BIT
> >  #define PSR_AA32_I_BIT		PSR_I_BIT
> >  #define PSR_AA32_A_BIT		PSR_A_BIT
> >  #define PSR_AA32_E_BIT		PSR_E_BIT
> >  #define PSR_AA32_IT_MASK	PSR_IT_MASK
> > +#define PSR_AA32_GE_MASK	0x000f0000
> > +#define PSR_AA32_PAN_BIT	0x00400000
> > +#define PSR_AA32_SSBS_BIT	0x00800000
> > +#define PSR_AA32_DIT_BIT	0x01000000
> 
> This is actually PSR_J_BIT on arm. Maybe it's worth defining it like that to
> make the overlap obvious.

Another bug! These are intended to match the SPSR_hyp view, where DIT is
bit 21, and so this should be:

#define PSR_AA32_DIT_BIT	0x0x00200000

... placed immediately before the PAN bit.

We don't need a macro for the J bit as it was obsoleted and made RES0 by
the ARMv7 virtualization extensions.

[...]

> > +	// CPSR.PAN is unchanged unless overridden by SCTLR.SPAN
> > +	// See ARM DDI 0487E.a, page G8-6246
> > +	new |= (old & PSR_AA32_PAN_BIT);
> > +	if (sctlr & BIT(23))
> > +		new |= PSR_AA32_PAN_BIT;
> 
> PSTATE.PAN is unconditionally set when SCTLR.SPAN is clear.

Indeed, and this time the reference is explicit about that. :/

I've updated this to:

|	// CPSR.PAN is unchanged unless SCTLR.SPAN == 0b0
|	// SCTLR.SPAN is RES1 when ARMv8.1-PAN is not implemented
|	// See ARM DDI 0487E.a, page G8-6246
|	new |= (old & PSR_AA32_PAN_BIT);
|	if (!(sctlr & BIT(23)))
|		new |= PSR_AA32_PAN_BIT;

[...]

> I've also checked that the ARM documentation references match the code.

Thanks, your review is much appreciated!

Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
