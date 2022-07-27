Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F546C19F29
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jul 2022 10:59:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED1EE4C3C9;
	Wed, 27 Jul 2022 06:59:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TociDX1Ha+oA; Wed, 27 Jul 2022 06:59:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3F424C345;
	Wed, 27 Jul 2022 06:59:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22CB64C344
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 06:59:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d8-4XfZw-5Xm for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jul 2022 06:59:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A75FE4C34C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 06:59:31 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B1757D6E;
 Wed, 27 Jul 2022 03:59:31 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 21C743F70D;
 Wed, 27 Jul 2022 03:59:30 -0700 (PDT)
Date: Wed, 27 Jul 2022 12:00:10 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead
 of pinning VM memory
Message-ID: <YuEauq4sevyQAYpF@monolith.localdoman>
References: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
 <20220419141012.GB6143@willie-the-truck>
 <Yt5nFAscgrRGNGoH@monolith.localdoman>
 <YuApmZFdZzTi5ROu@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YuApmZFdZzTi5ROu@google.com>
Cc: maz@kernel.org, Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Oliver,

On Tue, Jul 26, 2022 at 10:51:21AM -0700, Oliver Upton wrote:
> Hi Alex,
> 
> On Mon, Jul 25, 2022 at 11:06:24AM +0100, Alexandru Elisei wrote:
> 
> [...]
> 
> I'm also a bit confused on how we would manage to un-pin memory on the
> way out with this. The guest is free to muck with the stage 1 and could
> cause the SPU to spew a bunch of stage 2 aborts if it wanted to be
> annoying. One way to tackle it would be to only allow a single
> root-to-target walk to be pinned by a vCPU at a time. Any time a new
> stage 2 abort comes from the SPU, we un-pin the old walk and pin the new
> one instead.

On the topic of memory unpinning, for a well behaved guest I belive that should
be done the next time the buffer is pinned. The buffer can (and should!) be
drained when both the buffer and sampling is disabled; unpinning the buffer when
profiling becomes disabled would lead to unnecessary stage 2 faults when
draining it.

That approach also means that KVM wouldn't have to do anything special for SPE
stage 2 faults.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
