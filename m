Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1190C56202
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 16:23:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BBA06207BC
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 16:23:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K5NPkzil"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBA06207BC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32BC34C0F8;
	Thu, 26 Nov 2020 11:23:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ir1K8ZAju4zM; Thu, 26 Nov 2020 11:23:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CF244C0DA;
	Thu, 26 Nov 2020 11:23:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6D8A4C0B2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 11:23:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7B5J4YciX07R for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 11:23:43 -0500 (EST)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F3F1B4C06F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 11:23:42 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=J/yD0KFriqWMZtNa1/eriAjfaLbTwrShtSXGHA91Qqg=; b=K5NPkzils6igylPVgbl+1esF0f
 xEzI5QMLfMEX0KgTXqboE+X4bWmnUW/Z5SekuMxAJZq+QYCwLAOHi85g4/x8hK92dQo6z0uuzcIYI
 +YUWiX9k0nw6q+Q3B20Oi0l7wp/0CCpUmjiU4EZ7NE4KRt7RGmJTuus3kubc0TygiTjwTm8irUWXG
 gRz/HaZGA19gBb4X4o5azgcd55gSeyCKO8NiElpskZsl7C/ft1Rd+MjrZ+aUgEJrPbRLZl7ujCadT
 psBDmdMn+xz5XFyWb3zYx9TSbT6GAcvM3VZi6h/MD/NtmJ4Ob4qrpJPnzVP+5C8cn9nn0PGlgDn5j
 zBeC1vBA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red
 Hat Linux)) id 1kiK3X-0000x3-2G; Thu, 26 Nov 2020 16:23:39 +0000
Date: Thu, 26 Nov 2020 16:23:38 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 00/23] Opt-in always-on nVHE hypervisor
Message-ID: <20201126162338.GV4327@casper.infradead.org>
References: <20201126155421.14901-1-dbrazdil@google.com>
 <20201126155746.GU4327@casper.infradead.org>
 <6a2a14af06232cdf2f5146cd8ec6fc35@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6a2a14af06232cdf2f5146cd8ec6fc35@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Sudeep Holla <sudeep.holla@arm.com>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
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

On Thu, Nov 26, 2020 at 04:19:55PM +0000, Marc Zyngier wrote:
> On 2020-11-26 15:57, Matthew Wilcox wrote:
> > On Thu, Nov 26, 2020 at 03:53:58PM +0000, David Brazdil wrote:
> > > The hypervisor starts trapping host SMCs and intercepting host's PSCI
> > > CPU_ON/SUSPEND calls. It replaces the host's entry point with its own,
> > > initializes the EL2 state of the new CPU and installs the nVHE hyp
> > > vector
> > > before ERETing to the host's entry point.
> > 
> > I hate CPU people.  This is complete gibberish to anyone who doesn't
> > already have their head deep in ... whatever you're talking about.
> 
> What I hate the most is people having a go at other people because they
> don't understand what is being discussed. Who is at fault there?

The person who wrote an explanation that doesn't actually explain
anything?  If you're sending mail to a bunch of mailing lists which
aren't already familiar with what you're trying to do, the onus is on
you to do more explanation.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
