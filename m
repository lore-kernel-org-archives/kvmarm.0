Return-Path: <SRS0=jSi8=UD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57080C282CE
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 09:57:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DFE5324B36
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 09:57:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFE5324B36
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63E274A3A5;
	Tue,  4 Jun 2019 05:57:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VxQDxxbe3E-5; Tue,  4 Jun 2019 05:57:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11EE74A479;
	Tue,  4 Jun 2019 05:57:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB40A4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 05:57:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8akC9dKXpbsh for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jun 2019 05:57:18 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C8604A389
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 05:57:18 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EAB0B80D;
 Tue,  4 Jun 2019 02:57:17 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6EFFB3F246;
 Tue,  4 Jun 2019 02:57:16 -0700 (PDT)
Date: Tue, 4 Jun 2019 10:57:14 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] KVM: arm64: Drop 'const' from argument of vq_present()
Message-ID: <20190604095713.GV28398@e103592.cambridge.arm.com>
References: <699121e5c938c6f4b7b14a7e2648fa15af590a4a.1559623368.git.viresh.kumar@linaro.org>
 <20190604084349.prnnvjvjaeuhsmgs@mbp>
 <20190604085545.hsmxfqkpt2cbrhtw@vireshk-i7>
 <20190604092639.GS28398@e103592.cambridge.arm.com>
 <20190604093153.2pzv55knl6axugrv@vireshk-i7>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190604093153.2pzv55knl6axugrv@vireshk-i7>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
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

On Tue, Jun 04, 2019 at 03:01:53PM +0530, Viresh Kumar wrote:
> On 04-06-19, 10:26, Dave Martin wrote:
> > I'm in two minds about whether this is worth fixing, but if you want to
> > post a patch to remove the extra const (or convert vq_present() to a
> > macro), I'll take a look at it.
> 
> This patch already does what you are asking for (remove the extra
> const), isn't it ?

Yes, sorry -- I didn't scroll back far enough.

> I looked at my textbook (The C programming Language, By Brian W.
> Kernighan and Dennis M. Ritchie.) and it says:
> 
> "
> The const declaration can also be used with array arguments, to
> indicate that the function does not change that array:
> 
> int strlen(const char[]);
> "
> 
> and so this patch isn't necessary for sure.

This is an array to which a pointer argument points, not an array
argument.  I think that's how we hit the constified double-indirection
problem.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
