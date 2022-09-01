Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EDF1ECAAD3
	for <kvmarm@archiver.kernel.org>; Thu,  1 Sep 2022 15:50:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03DAF4A104;
	Thu,  1 Sep 2022 11:50:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qWaJDqL2kK0t; Thu,  1 Sep 2022 11:50:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B73424A1B0;
	Thu,  1 Sep 2022 11:50:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50CCB4A104
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2022 11:50:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rPakmbuuuUIj for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Sep 2022 11:50:03 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C3E94A0FE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2022 11:50:02 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id D70C561F1A;
 Thu,  1 Sep 2022 15:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8EDC433D6;
 Thu,  1 Sep 2022 15:49:59 +0000 (UTC)
Date: Thu, 1 Sep 2022 16:49:56 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH v3 1/7] arm64: mte: Fix/clarify the PG_mte_tagged semantics
Message-ID: <YxDUpACQHmjbihnx@arm.com>
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-2-pcc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220810193033.1090251-2-pcc@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Cornelia Huck <cohuck@redhat.com>, Steven Price <steven.price@arm.com>,
 linux-arm-kernel@lists.infradead.org,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Evgenii Stepanov <eugenis@google.com>
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

On Wed, Aug 10, 2022 at 12:30:27PM -0700, Peter Collingbourne wrote:
> From: Catalin Marinas <catalin.marinas@arm.com>
> 
> Currently the PG_mte_tagged page flag mostly means the page contains
> valid tags and it should be set after the tags have been cleared or
> restored. However, in mte_sync_tags() it is set before setting the tags
> to avoid, in theory, a race with concurrent mprotect(PROT_MTE) for
> shared pages. However, a concurrent mprotect(PROT_MTE) with a copy on
> write in another thread can cause the new page to have stale tags.
> Similarly, tag reading via ptrace() can read stale tags of the
> PG_mte_tagged flag is set before actually clearing/restoring the tags.
> 
> Fix the PG_mte_tagged semantics so that it is only set after the tags
> have been cleared or restored. This is safe for swap restoring into a
> MAP_SHARED or CoW page since the core code takes the page lock. Add two
> functions to test and set the PG_mte_tagged flag with acquire and
> release semantics. The downside is that concurrent mprotect(PROT_MTE) on
> a MAP_SHARED page may cause tag loss. This is already the case for KVM
> guests if a VMM changes the page protection while the guest triggers a
> user_mem_abort().
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Peter Collingbourne <pcc@google.com>
> ---
> v3:
> - fix build with CONFIG_ARM64_MTE disabled

When you post someone else's patches (thanks for updating them BTW),
please add your Signed-off-by line. You should also add a note in the
SoB block about the changes you made, so something like:

[pcc@google.com: fix build with CONFIG_ARM64_MTE disabled]
Singed-off-by: your name/address

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
