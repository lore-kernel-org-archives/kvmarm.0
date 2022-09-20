Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B650BECAAD8
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 13:20:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22D164A105;
	Tue, 20 Sep 2022 09:20:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Vutd8186tgJd; Tue, 20 Sep 2022 09:20:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBDDD4B092;
	Tue, 20 Sep 2022 09:20:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F9664B092
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 09:20:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nkxKTR09vsOe for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 09:20:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F01BE4A105
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 09:20:52 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF2FB1042;
 Tue, 20 Sep 2022 06:20:58 -0700 (PDT)
Received: from e121798.cambridge.arm.com (e121798.cambridge.arm.com
 [10.1.196.158])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E56B3F73D;
 Tue, 20 Sep 2022 06:20:51 -0700 (PDT)
Date: Tue, 20 Sep 2022 14:20:48 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [kvm-unit-tests RFC PATCH 05/19] lib/alloc_phys: Remove locking
Message-ID: <Yym+MOMK68K7abiQ@e121798.cambridge.arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-6-alexandru.elisei@arm.com>
 <20220920084553.734jvkqpognzgfpr@kamzik>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220920084553.734jvkqpognzgfpr@kamzik>
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

On Tue, Sep 20, 2022 at 10:45:53AM +0200, Andrew Jones wrote:
> On Tue, Aug 09, 2022 at 10:15:44AM +0100, Alexandru Elisei wrote:
> > With powerpc moving the page allocator, there are no architectures left
> > which use the physical allocator after the boot setup:  arm, arm64,
> > s390x and powerpc drain the physical allocator to initialize the page
> > allocator; and x86 calls setup_vm() to drain the allocator for each of
> > the tests that allocate memory.
> 
> Please put the motivation for this change in the commit message. I looked
> ahead at the next patch to find it, but I'm not sure I agree with it. We
> should be able to keep the locking even when used early, since we probably
> need our locking to be something we can use early elsewhere anyway.

You are correct, the commit message doesn't explain why locking is removed,
which makes the commit confusing. I will try to do a better job for the
next iteration (if we decide to keep this patch).

I removed locking because the physical allocator by the end of the series
will end up being used only by arm64 to create the idmap, which is done on
the boot CPU and with the MMU off. After that, the translation table
allocator functions will use the page allocator, which can be used
concurrently.

Looking at the spinlock implementation, spin_lock() doesn't protect from
the concurrent accesses when the MMU is disabled (lock->v is
unconditionally set to 1). Which means that spin_lock() does not work (in
the sense that it doesn't protect against concurrent accesses) on the boot
path, which doesn't need a spinlock anyway, because no secondaries are
online secondaries. It also means that spinlocks don't work when
AUXINFO_MMU_OFF is set. So for the purpose of simplicity I preferred to
drop it entirely.

Thanks,
Alex

> 
> Thanks,
> drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
