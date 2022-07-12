Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F326FCCA483
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jul 2022 10:09:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9417A4BE7E;
	Tue, 12 Jul 2022 06:09:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SUJPlNabRhND; Tue, 12 Jul 2022 06:09:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA83E4BE83;
	Tue, 12 Jul 2022 06:08:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 372804BE55
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 05:40:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nhvn9TUth4ZC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jul 2022 05:40:07 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E817F4BE53
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 05:40:06 -0400 (EDT)
Date: Tue, 12 Jul 2022 11:40:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1657618805;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=J6I8XyEibxsxWt8qyNSqLmTosyFt4crDkICfPujymAM=;
 b=JkONTmRbHmjXwBsCxqYQq3aXd4kywPtIcgN8mX/KwsDbVVNEy3uybI14LwLSfDHK8Bp6N6
 Z0G7AEVhBban0Fqqp0MU6NDlSACnWfwIqrDfAtkHuLSFOa0yYVkh+WUooAdD6BOvnWy/s2
 K20GC4rGw2cG9uhC8lIRsCDEiD8fZVY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v4 06/13] KVM: selftests: Add vm_mem_region_get_src_fd
 library function
Message-ID: <20220712094004.7kuapr7m4u5xwd6h@kamzik>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-7-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220624213257.1504783-7-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Mailman-Approved-At: Tue, 12 Jul 2022 06:08:57 -0400
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 dmatlack@google.com, pbonzini@redhat.com, axelrasmussen@google.com,
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

On Fri, Jun 24, 2022 at 02:32:50PM -0700, Ricardo Koller wrote:
> Add a library function to get the backing source FD of a memslot.
> 
> Reviewed-by: Oliver Upton <oupton@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 54ede9fc923c..72c8881fe8fb 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -322,6 +322,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>  void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
>  void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
>  void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
> +int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot);
>  struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
>  vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
>  vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 3e45e3776bdf..7c81028f23d8 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -466,6 +466,29 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
>  	return &region->region;
>  }
>  
> +/*
> + * KVM Userspace Memory Get Backing Source FD
> + *
> + * Input Args:
> + *   vm - Virtual Machine
> + *   memslot - KVM memory slot ID
> + *
> + * Output Args: None
> + *
> + * Return:
> + *   Backing source file descriptor, -1 if the memslot is an anonymous region.
> + *
> + * Returns the backing source fd of a memslot, so tests can use it to punch
> + * holes, or to setup permissions.
> + */

nit: We're starting to slowly change these verbose function headers into
smaller headers, so this could be reduced.

> +int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot)
> +{
> +	struct userspace_mem_region *region;
> +
> +	region = memslot2region(vm, memslot);
> +	return region->fd;
> +}
> +
>  /*
>   * VM VCPU Remove
>   *
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
