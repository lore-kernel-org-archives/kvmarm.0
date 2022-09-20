Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA35C54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 07:50:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36CBE4B64A;
	Tue, 20 Sep 2022 03:50:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dummBotR9o6B; Tue, 20 Sep 2022 03:50:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1002E4B632;
	Tue, 20 Sep 2022 03:50:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1442B4B5F6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 03:50:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RKwcL0Sb24jM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 03:50:24 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D61444B4D7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 03:50:24 -0400 (EDT)
Date: Tue, 20 Sep 2022 09:50:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663660223;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=eyekJFWfNIBvBg+mrV6tG+YS/YFf06nK3qzW8KeFdXI=;
 b=lOr0A2/i2dYj8lPydFJEwzKN4fPQpYAywx/Az35MPE7I3Tl0LwAdIdn/clZvjgqtFTr2qZ
 QI4Gbb7R+wMladb51rJDBp5Sf4hQoafJnaMl+K7j8USDO16cfyF1yJaO55yuy30xOSELAL
 PeQofwnivPkm+hg1c/DMX26apTWcdyc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v7 07/13] KVM: selftests: Add vm->memslots[] and enum
 kvm_mem_region_type
Message-ID: <20220920075021.rbzo2wkypbj2gjie@kamzik>
References: <20220920042551.3154283-1-ricarkol@google.com>
 <20220920042551.3154283-8-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220920042551.3154283-8-ricarkol@google.com>
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

On Tue, Sep 20, 2022 at 04:25:45AM +0000, Ricardo Koller wrote:
> The vm_create() helpers are hardcoded to place most page types (code,
> page-tables, stacks, etc) in the same memslot #0, and always backed with
> anonymous 4K.  There are a couple of issues with that.  First, tests willing to
> differ a bit, like placing page-tables in a different backing source type must
> replicate much of what's already done by the vm_create() functions.  Second,
> the hardcoded assumption of memslot #0 holding most things is spreaded
> everywhere; this makes it very hard to change.
> 
> Fix the above issues by having selftests specify how they want memory to be
> laid out. Start by changing ____vm_create() to not create memslot #0; a future
> commit will add test that specifies all memslots used by the VM.  Then, add the
> vm->memslots[] array to specify the right memslot for different memory
> allocators, e.g.,: lib/elf should use the vm->[MEM_REGION_CODE] memslot.  This
> will be used as a way to specify the page-tables memslots (to be backed by huge
> pages for example).
> 
> There is no functional change intended. The current commit lays out memory
> exactly as before. The next commit will change the allocators to get the region
> they should be using, e.g.,: like the page table allocators using the pt
> memslot.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     | 25 +++++++++++++++++--
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 18 +++++++------
>  2 files changed, 33 insertions(+), 10 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
