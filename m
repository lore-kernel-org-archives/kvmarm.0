Return-Path: <SRS0=HiVh=25=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F37BDC33C9E
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jan 2020 11:16:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6520220673
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jan 2020 11:16:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6520220673
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DD674B02D;
	Wed,  8 Jan 2020 06:16:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4+atRymbSmR8; Wed,  8 Jan 2020 06:16:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9D234B044;
	Wed,  8 Jan 2020 06:16:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 669144AF7A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jan 2020 06:16:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AO-eGDz7ymed for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jan 2020 06:15:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 934534AF6F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jan 2020 06:15:41 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D05D30E;
 Wed,  8 Jan 2020 03:15:41 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5EDA3F703;
 Wed,  8 Jan 2020 03:15:39 -0800 (PST)
Date: Wed, 8 Jan 2020 11:15:37 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/3] KVM: arm64: correct PSTATE on exception entry
Message-ID: <20200108111537.GB49203@lakrids.cambridge.arm.com>
References: <20191220150549.31948-1-mark.rutland@arm.com>
 <20191220150549.31948-2-mark.rutland@arm.com>
 <bace4197-a723-5312-3990-84232aab30d9@arm.com>
 <86zhfbgnzf.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86zhfbgnzf.wl-maz@kernel.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: Will Deacon <will@kernel.org>, stable@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On Sun, Dec 29, 2019 at 03:17:40PM +0000, Marc Zyngier wrote:
> On Fri, 27 Dec 2019 13:01:57 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > On 12/20/19 3:05 PM, Mark Rutland wrote:
> > > +	// PSTATE.PAN is unchanged unless overridden by SCTLR_ELx.SPAN
> > > +	// See ARM DDI 0487E.a, page D5-2578.
> > > +	new |= (old & PSR_PAN_BIT);
> > > +	if (sctlr & SCTLR_EL1_SPAN)
> > > +		new |= PSR_PAN_BIT;
> > 
> > On page D13-3264, it is stated that the PAN bit is set unconditionally if
> > SCTLR_EL1.SPAN is clear, not set.
> 
> Indeed. Given that when ARMv8.1-PAN is not implemented, SCTLR_EL1[23]
> is RES1, it seems surprising to force PAN based on this bit being set.
> 
> I've now dropped this series from my tree until Mark has a chance to
> clarify this.

Sorry for the mess; I'm fixing up the patches now and looking out for
any similar mistakes.

I'll try to have a v2 out by the end of today.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
