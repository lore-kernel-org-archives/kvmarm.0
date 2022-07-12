Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7B9C43334
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jul 2022 10:09:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E07F54BE6F;
	Tue, 12 Jul 2022 06:08:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T-uwrvibypUB; Tue, 12 Jul 2022 06:08:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63BE94BE68;
	Tue, 12 Jul 2022 06:08:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D98B4BD59
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 05:13:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 22i5u6HBlDf8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jul 2022 05:13:51 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE6614BCCA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 05:13:51 -0400 (EDT)
Date: Tue, 12 Jul 2022 11:13:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1657617230;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=3Zt0Xhd8ddIucQPrOJb3PEM9OfWFEuoA7oRWJOVyzHU=;
 b=Y3+CoTo+csjBr7N8wooQcAhjhzmL1GWrCYpUtpjRLRdD7JnZFZPSkuvf1cpISLlWIceEsu
 cyRltp8DlQo+sEYHHa2iHApdQAq2k8bx/7PNqZ7VQz81f5gc3Lcn6Mqf/IfIxnp1x3+LZ2
 vpRLVNQW0WGFFl+hpxhAUuel6MPfolc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v4 03/13] KVM: selftests: Add
 vm_alloc_page_table_in_memslot library function
Message-ID: <20220712091348.66x54s47ali4h2ki@kamzik>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-4-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220624213257.1504783-4-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Mailman-Approved-At: Tue, 12 Jul 2022 06:08:56 -0400
Cc: drjones@redhat.com, kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
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

On Fri, Jun 24, 2022 at 02:32:47PM -0700, Ricardo Koller wrote:
> Add a library function to allocate a page-table physical page in a
> particular memslot.  The default behavior is to create new page-table
> pages in memslot 0.
> 
> Reviewed-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c          | 8 +++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 7ebfc8c7de17..54ede9fc923c 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -579,6 +579,7 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
>  vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
>  			      vm_paddr_t paddr_min, uint32_t memslot);
>  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
> +vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot);
>  
>  /*
>   * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index f8c104dba258..5ee20d4da222 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1784,9 +1784,15 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
>  /* Arbitrary minimum physical address used for virtual translation tables. */
>  #define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
>  
> +vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot)
> +{
> +	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> +			pt_memslot);
> +}
> +
>  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
>  {
> -	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
> +	return vm_alloc_page_table_in_memslot(vm, 0);
>  }
>  
>  /*
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
