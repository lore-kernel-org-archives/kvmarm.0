Return-Path: <SRS0=H6Wl=T4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A3B7C04AB6
	for <kvmarm@archiver.kernel.org>; Tue, 28 May 2019 13:38:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 925892054F
	for <kvmarm@archiver.kernel.org>; Tue, 28 May 2019 13:38:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 925892054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F02B04A4AA;
	Tue, 28 May 2019 09:38:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0g1flVXg8-FE; Tue, 28 May 2019 09:38:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8F564A4C3;
	Tue, 28 May 2019 09:38:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FC014A4C2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 May 2019 09:38:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bJQL4Ox3pz3d for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 May 2019 09:38:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 022444A4AA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 May 2019 09:38:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51FF380D;
 Tue, 28 May 2019 06:38:38 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D3263F5AF;
 Tue, 28 May 2019 06:38:36 -0700 (PDT)
Date: Tue, 28 May 2019 14:38:34 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [kvmtool PATCH v10 5/5] KVM: arm/arm64: Add a vcpu feature for
 pointer authentication
Message-ID: <20190528133833.GC28398@e103592.cambridge.arm.com>
References: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
 <1555994558-26349-6-git-send-email-amit.kachhap@arm.com>
 <20190423154625.GP3567@e103592.cambridge.arm.com>
 <3b7bafc9-5d6a-7845-ef1f-577ea59000e2@arm.com>
 <20190424134120.GW3567@e103592.cambridge.arm.com>
 <20190528101128.GB28398@e103592.cambridge.arm.com>
 <53ecc253-e9e0-a6ca-2540-fa85bd26bfc1@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53ecc253-e9e0-a6ca-2540-fa85bd26bfc1@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>,
 Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>,
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

On Tue, May 28, 2019 at 06:18:16PM +0530, Amit Daniel Kachhap wrote:
> Hi Dave,

[...]

> >Were you planning to repost this?
> >
> >Alternatively, I can fix up the diagnostic messages discussed here and
> >post it together with the SVE support.  I'll do that locally for now,
> >but let me know what you plan to do.  I'd like to get the SVE support
> >posted soon so that people can test it.
> 
> I will clean up the print messages as you suggested and repost it shortly.

OK, thanks.

In the meantime I'll rework the SVE config option stuff on what we
discussed.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
