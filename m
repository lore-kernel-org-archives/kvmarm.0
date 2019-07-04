Return-Path: <SRS0=oQwk=VB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FF6C06513
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jul 2019 12:47:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0168321850
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jul 2019 12:47:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0168321850
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 711A44A4EE;
	Thu,  4 Jul 2019 08:47:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SAVtCgUD6YAs; Thu,  4 Jul 2019 08:47:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25A554A4CA;
	Thu,  4 Jul 2019 08:47:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C8E44A483
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jul 2019 08:47:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4b-GP7DDfgfn for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jul 2019 08:47:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEF6940217
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jul 2019 08:47:14 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5368928;
 Thu,  4 Jul 2019 05:47:14 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 820843F718;
 Thu,  4 Jul 2019 05:47:12 -0700 (PDT)
Date: Thu, 4 Jul 2019 13:47:10 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: arm64/sve: Fix vq_present() macro to yield a bool
Message-ID: <20190704124709.GB2790@e103592.cambridge.arm.com>
References: <1562175770-10952-1-git-send-email-Dave.Martin@arm.com>
 <86wogynrbt.wl-marc.zyngier@arm.com>
 <1f39cc48-12d5-2e56-c218-b6b0dd05d8ce@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1f39cc48-12d5-2e56-c218-b6b0dd05d8ce@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>,
 Christoffer Dall <cdall@kernel.org>, kvm <kvm@vger.kernel.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Julien Grall <julien.grall@arm.com>, Viresh Kumar <viresh.kumar@linaro.org>,
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

On Thu, Jul 04, 2019 at 02:24:42PM +0200, Paolo Bonzini wrote:
> On 04/07/19 10:20, Marc Zyngier wrote:
> > +KVM, Paolo and Radim,
> > 
> > Guys, do you mind picking this single patch and sending it to Linus?
> > That's the only fix left for 5.2. Alternatively, I can send you a pull
> > request, but it feels overkill.
> 
> Sure, will do.
> 
> Paolo

Thanks all for the quick turnaround!

[...]

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
