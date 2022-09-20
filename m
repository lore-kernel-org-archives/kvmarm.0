Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E10ECAAD8
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 07:51:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4876D4B63F;
	Tue, 20 Sep 2022 03:51:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sAvll2FucOpH; Tue, 20 Sep 2022 03:51:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47DDF4B640;
	Tue, 20 Sep 2022 03:51:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B2084B632
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 03:51:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jk26KE5htlhU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 03:51:05 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12CC24B5F6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 03:51:05 -0400 (EDT)
Date: Tue, 20 Sep 2022 09:51:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663660264;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=adQjsppu4f1Y67G2a4MebDdYXgGJe2ubXNkO3qZkbwo=;
 b=xk1eBGaKG1NcZUEjlbXiaufZBSA5rBzaGdToMJpTFdtE6QoaX7b9OKy2t4MRc0qCHgflFL
 sPXSkp4aca37XBWhSwmRBA3DvYxIY6dOAj+R0Isg/8CojlQbdmveE/zizsDqAKoG/l3vCT
 ySiKgR08XMLNxy+GBzmmwkcT0LSULNQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v7 08/13] KVM: selftests: Use the right memslot for code, 
 page-tables, and data allocations
Message-ID: <20220920075103.34qzxqxhu3puq72r@kamzik>
References: <20220920042551.3154283-1-ricarkol@google.com>
 <20220920042551.3154283-9-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220920042551.3154283-9-ricarkol@google.com>
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

On Tue, Sep 20, 2022 at 04:25:46AM +0000, Ricardo Koller wrote:
> The previous commit added support for callers of ____vm_create() to specify
> what memslots to use for code, page-tables, and data allocations. Change
> them accordingly:
> 
> - stacks, code, and exception tables use the code memslot
> - page tables and the pgd use the pt memslot
> - data (anything allocated with vm_vaddr_alloc()) uses the data memslot
> 
> No functional change intended. All allocators keep using memslot #0.
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  3 +
>  .../selftests/kvm/lib/aarch64/processor.c     | 11 ++--
>  tools/testing/selftests/kvm/lib/elf.c         |  3 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 57 ++++++++++++-------
>  .../selftests/kvm/lib/riscv/processor.c       |  7 ++-
>  .../selftests/kvm/lib/s390x/processor.c       |  7 ++-
>  .../selftests/kvm/lib/x86_64/processor.c      | 13 +++--
>  7 files changed, 61 insertions(+), 40 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
