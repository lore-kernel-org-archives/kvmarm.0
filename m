Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BFF7C00140
	for <kvmarm@archiver.kernel.org>; Wed, 24 Aug 2022 15:00:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6B8F4D012;
	Wed, 24 Aug 2022 11:00:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pTpGSycw+Mjn; Wed, 24 Aug 2022 11:00:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 876214D169;
	Wed, 24 Aug 2022 11:00:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A1414D160
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 11:00:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JTosj2mZ8YbP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Aug 2022 11:00:30 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9788C4D15D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 11:00:30 -0400 (EDT)
Date: Wed, 24 Aug 2022 10:00:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1661353229;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=wpdpInv50s3/tIr2zAWlDOu11BVdoLVMcL8Ge4aE150=;
 b=vCNG6VW0yVkpK30QQEGBHc0IONpr09WwKoJRzM318XHzyPpdYjdo72Wro1vDzdAr0MYNLs
 EYH9TmimgWflNvzHC80WrzVMIezIPbQfNXq8NkEMiF6hjZuJQrG4iKwHF5FaWtL6Sovhst
 w05T8HvT2UqbKDR9ZLtxGz/iI8pVsbI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v4 5/6] KVM: selftests: Make arm64's MMIO ucall multi-VM
 friendly
Message-ID: <YwY9BYDUeiT87/Vs@google.com>
References: <20220824032115.3563686-1-seanjc@google.com>
 <20220824032115.3563686-6-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220824032115.3563686-6-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Tom Rix <trix@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 llvm@lists.linux.dev, Colton Lewis <coltonlewis@google.com>,
 linux-riscv@lists.infradead.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Peter Gonda <pgonda@google.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>,
 Atish Patra <atishp@atishpatra.org>, Andrew Jones <andrew.jones@linux.dev>,
 linux-arm-kernel@lists.infradead.org,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>
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

Hi Sean,

On Wed, Aug 24, 2022 at 03:21:14AM +0000, Sean Christopherson wrote:
> Fix a mostly-theoretical bug where ARM's ucall MMIO setup could result in
> different VMs stomping on each other by cloberring the global pointer.
> 
> Fix the most obvious issue by saving the MMIO gpa into the VM.
> 
> A more subtle bug is that creating VMs in parallel (on multiple tasks)
> could result in a VM using the wrong address.  Synchronizing a global to
> a guest effectively snapshots the value on a per-VM basis, i.e. the
> "global" is already prepped to work with multiple VMs, but setting the
> global in the host and copying it to the guest needs to happen atomically.
> To fix that bug, add atomic_sync_global_pointer_to_guest() to sync
> "global" pointers that hold per-VM values, i.e. technically need to be
> handled in a thread-safe manner.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     | 16 +++++++++++++++
>  .../testing/selftests/kvm/lib/aarch64/ucall.c | 20 ++++++++++++++-----
>  2 files changed, 31 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 24fde97f6121..9ec7fbe941aa 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -16,6 +16,7 @@
>  #include <linux/kvm.h>
>  #include "linux/rbtree.h"
>  
> +#include <asm/atomic.h>
>  
>  #include <sys/ioctl.h>
>  
> @@ -81,6 +82,7 @@ struct kvm_vm {
>  	struct sparsebit *vpages_mapped;
>  	bool has_irqchip;
>  	bool pgd_created;
> +	vm_paddr_t ucall_mmio_addr;
>  	vm_paddr_t pgd;
>  	vm_vaddr_t gdt;
>  	vm_vaddr_t tss;
> @@ -714,6 +716,20 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
>  	memcpy(&(g), _p, sizeof(g));				\
>  })
>  
> +/*
> + * Sync a global pointer to the guest that has a per-VM value, in which case
> + * writes to the host copy of the "global" must be serialized (in case a test
> + * is being truly crazy and spawning multiple VMs concurrently).
> + */

Do we even care about writes to the host's copy of the global pointer?
I don't see how the host pointer is used beyond serializing writes into
a guest.

IOW, it looks as though we could skip the whole global illusion
altogether and write straight into guest memory.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
