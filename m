Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0471C54EE9
	for <kvmarm@archiver.kernel.org>; Mon, 19 Sep 2022 06:42:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CE6E4B7B0;
	Mon, 19 Sep 2022 02:42:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z6JhtUEPbHrV; Mon, 19 Sep 2022 02:42:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 29D9D4B754;
	Mon, 19 Sep 2022 02:42:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E79F4B6DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 02:42:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vu9yMewjew3o for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Sep 2022 02:42:44 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B5CF4B658
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 02:42:44 -0400 (EDT)
Date: Mon, 19 Sep 2022 08:42:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663569762;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=lF1pvNO15/LIryP56kUXyj5P8zfxBSIOSQeY6bCx/8A=;
 b=cDbTE0mG4zNxp9IENdmw1ylz9PDZOfeBPeJ+RGUu08nYhCWUyzcTq66pJextb8LHbiU9Dr
 9+cUPZ5wWn8FEMa1N+SQvVdVHEViCxuac9++JwgG1t2+AEB2p+ql2G47W5JfgwnqPsQCiW
 ujdcUGKnfBytBkY9yOkjJHLEXOYIwlI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v6 07/13] KVM: selftests: Change ____vm_create() to take
 struct kvm_vm_mem_params
Message-ID: <20220919064241.bflow5zvcsz5xaf6@kamzik>
References: <20220906180930.230218-1-ricarkol@google.com>
 <20220906180930.230218-8-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220906180930.230218-8-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 pbonzini@redhat.com, axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu,
 dmatlack@google.com
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

On Tue, Sep 06, 2022 at 06:09:24PM +0000, Ricardo Koller wrote:
> The vm_create() helpers are hardcoded to place most page types (code,
> page-tables, stacks, etc) in the same memslot #0, and always backed with
> anonymous 4K.  There are a couple of issues with that.  First, tests willing to
> differ a bit, like placing page-tables in a different backing source type must
> replicate much of what's already done by the vm_create() functions.  Second,
> the hardcoded assumption of memslot #0 holding most things is spreaded
> everywhere; this makes it very hard to change.
> 
> Fix the above issues by having selftests specify how they want memory to be
> laid out: define the memory regions to use for code, pt (page-tables), and
> data. Introduce a new structure, struct kvm_vm_mem_params, that defines: guest
> mode, a list of memory region descriptions, and some fields specifying what
> regions to use for code, pt, and data.
> 
> There is no functional change intended. The current commit adds a default
> struct kvm_vm_mem_params that lays out memory exactly as before. The next
> commit will change the allocators to get the region they should be using,
> e.g.,: like the page table allocators using the pt memslot.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     | 51 +++++++++++++++-
>  .../selftests/kvm/lib/aarch64/processor.c     |  3 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 58 ++++++++++++++++---
>  3 files changed, 102 insertions(+), 10 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
