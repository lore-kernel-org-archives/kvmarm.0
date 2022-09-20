Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 890B1C54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 13:19:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 005334B637;
	Tue, 20 Sep 2022 09:19:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nXET1htVjFMi; Tue, 20 Sep 2022 09:19:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2EC94B0BA;
	Tue, 20 Sep 2022 09:19:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 560FB4B092
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 09:19:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fQgqBYgEdOND for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 09:19:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F47F4A105
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 09:19:31 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9B031042;
 Tue, 20 Sep 2022 06:19:37 -0700 (PDT)
Received: from e121798.cambridge.arm.com (e121798.cambridge.arm.com
 [10.1.196.158])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 88F0B3F73D;
 Tue, 20 Sep 2022 06:19:30 -0700 (PDT)
Date: Tue, 20 Sep 2022 14:19:28 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [kvm-unit-tests RFC PATCH 06/19] lib/alloc_phys: Remove
 allocation accounting
Message-ID: <Yym94MMavW1T33XM@e121798.cambridge.arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-7-alexandru.elisei@arm.com>
 <20220920084047.gblxkhedbugl7giz@kamzik>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220920084047.gblxkhedbugl7giz@kamzik>
Cc: nikos.nikoleris@arm.com, pbonzini@redhat.com, thuth@redhat.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

Hi,

On Tue, Sep 20, 2022 at 10:40:47AM +0200, Andrew Jones wrote:
> On Tue, Aug 09, 2022 at 10:15:45AM +0100, Alexandru Elisei wrote:
> > The page allocator has better allocation tracking and is used by all
> > architectures, while the physical allocator is now never used for
> > allocating memory.
> > 
> > Simplify the physical allocator by removing allocation accounting. This
> > accomplishes two things:
> > 
> > 1. It makes the allocator more useful, as the warning that was displayed
> > each allocation after the 256th is removed.
> > 
> > 2. Together with the lock removal, the physical allocator becomes more
> > appealing as a very early allocator, when using the page allocator might
> > not be desirable or feasible.
> 
> How does the locking cause problems when used in an early allocator?

By "early allocator" I mean here an allocator that can be used with the MMU
off.

The "desirable or feasible" part refers to the fact that the page allocator
cannot be used an early allocator (when the MMU is off) because 1. It
doesn't do the necessary cache maintenance operations and 2. It would be
hard to do add them, as the internal structures that the page allocator
maintains are significantly more complex than what the physical allocator
uses.

With this part: "together with the lock removal, the physical allocator
becomes more appealing as a very early allocator [..]" I was trying to say
that the physical allocator has now become as simple as it can possibly be
(well, align_min could also be removed and leave it up to the calling code
to request correctly aligned allocations but it's debatable if users of the
allocator should know about how it's implemented). I can reword or remove
this part if you feel it's confusing.

Thanks,
Alex

> 
> > 
> > Also, phys_alloc_show() has received a slight change in the way it displays
> > the use and free regions: the end of the region is now non-inclusive, to
> > allow phys_alloc_show() to express that no memory has been used, or no
> > memory is free, in which case the start and the end adresses are equal.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  lib/alloc_phys.c | 65 ++++++++++++++----------------------------------
> >  lib/alloc_phys.h |  5 ++--
> >  2 files changed, 21 insertions(+), 49 deletions(-)
> >
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
