Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7624DC4332F
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 08:24:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAC014B992;
	Fri,  9 Dec 2022 03:24:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V-mbsj944hK9; Fri,  9 Dec 2022 03:24:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34A324B9D9;
	Fri,  9 Dec 2022 03:24:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5FD84B9D1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 03:24:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9ly0BobNYdNu for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2022 03:24:29 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D0314B992
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 03:24:29 -0500 (EST)
Date: Fri, 9 Dec 2022 09:24:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1670574267;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=7Ujz0yDFlzjy73eRFThISN+4ybbqpoYq14hTZV0v3A8=;
 b=X1tn0ibWUZ9h8j6sycvZQrHaBQ/KIgXvJq3J+tF/hK7yE9U1924sn4kaJn5IdxS8U+CH+l
 erTziAmwd8ZLP3fbSUZwztsRMog4NkcuIVZXe4ICqNhgLLBqlAQtn9e7R1qii1iIV8nEVQ
 AhmX6RPI+5XaqXe6KdrIDjh2oMrc7V8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 0/7] KVM: selftests: Fixes for ucall pool +
 page_fault_test
Message-ID: <20221209082423.yideydkw6ig6x5zg@kamzik>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221209015307.1781352-1-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Fri, Dec 09, 2022 at 01:52:59AM +0000, Oliver Upton wrote:
> The combination of the pool-based ucall implementation + page_fault_test
> resulted in some 'fun' bugs. As has always been the case, KVM selftests
> is a house of cards.
> 
> Small series to fix up the issues on kvm/queue. Patches 1-2 can probably
> be squashed into Paolo's merge resolution, if desired.
> 
> Tested on Ampere Altra and a Skylake box, since there was a decent
> amount of munging in architecture-generic code.
> 
> v1 -> v2:
>  - Collect R-b from Sean (thanks!)
>  - Use a common routine for split and contiguous VA spaces, with
>    commentary on why arm64 is different since we all get to look at it
>    now. (Sean)
>  - Don't identity map the ucall MMIO hole
>  - Fix an off-by-one issue in the accounting of virtual memory,
>    discovered in fighting with #2
>  - Fix an infinite loop in ucall_alloc(), discovered fighting with the
>    ucall_init() v. kvm_vm_elf_load() ordering issue
> 
> Mark Brown (1):
>   KVM: selftests: Fix build due to ucall_uninit() removal
> 
> Oliver Upton (6):
>   KVM: selftests: Setup ucall after loading program into guest memory
>   KVM: selftests: Mark correct page as mapped in virt_map()
>   KVM: selftests: Correctly initialize the VA space for TTBR0_EL1
>   KVM: arm64: selftests: Don't identity map the ucall MMIO hole
>   KVM: selftests: Allocate ucall pool from MEM_REGION_DATA
>   KVM: selftests: Avoid infinite loop if ucall_alloc() fails
> 
>  .../selftests/kvm/aarch64/page_fault_test.c   |  9 +++-
>  .../selftests/kvm/include/kvm_util_base.h     |  1 +
>  .../testing/selftests/kvm/lib/aarch64/ucall.c |  6 ++-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 53 ++++++++++++++++---
>  .../testing/selftests/kvm/lib/ucall_common.c  | 14 +++--
>  5 files changed, 68 insertions(+), 15 deletions(-)
> 
> 
> base-commit: 89b2395859651113375101bb07cd6340b1ba3637

This commit doesn't seem to exist linux-next or kvm/queue, but the patch
context seems to match up with linux-next pretty well. Anyway,

For the series

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
