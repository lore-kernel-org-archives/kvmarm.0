Return-Path: <SRS0=zNRV=2K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48791C2D0D2
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 15:44:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F3BFF2467F
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 15:44:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3BFF2467F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7028B4AC6C;
	Fri, 20 Dec 2019 10:44:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L1qfLJGlO0kL; Fri, 20 Dec 2019 10:44:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64CCD4A586;
	Fri, 20 Dec 2019 10:44:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 946684A523
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 10:44:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H+KBRXXfSV69 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Dec 2019 10:44:39 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C8424A51C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 10:44:39 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1306F30E;
 Fri, 20 Dec 2019 07:44:39 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B9943F6CF;
 Fri, 20 Dec 2019 07:44:37 -0800 (PST)
Date: Fri, 20 Dec 2019 15:44:35 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 3/3] KVM: arm/arm64: correct AArch32 SPSR on exception
 entry
Message-ID: <20191220154434.GB25258@lakrids.cambridge.arm.com>
References: <20191220150549.31948-1-mark.rutland@arm.com>
 <20191220150549.31948-4-mark.rutland@arm.com>
 <8e3719bf81f135508eac2378bfee60f2@www.loen.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8e3719bf81f135508eac2378bfee60f2@www.loen.fr>
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

On Fri, Dec 20, 2019 at 03:36:47PM +0000, Marc Zyngier wrote:
> On 2019-12-20 15:05, Mark Rutland wrote:
> > +static inline unsigned long host_spsr_to_spsr32(unsigned long spsr)
> > +{
> > +	const unsigned long overlap = BIT(24) | BIT(21);
> > +	unsigned long dit = !!(spsr & PSR_AA32_DIT_BIT);
> > +
> > +	spsr &= overlap;
> 
> Are you sure this is what you want to do? This doesn't leave
> that many bits set in SPSR... :-/

Oh, whoops. :(

> Apart from what I believe is a missing ~ above, this looks good.

I've added the missing '~' and pushed out the updated branch.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
