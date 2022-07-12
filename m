Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A01C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jul 2022 10:09:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 494DE4BE70;
	Tue, 12 Jul 2022 06:09:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sLyUh94bEQCv; Tue, 12 Jul 2022 06:09:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95BA74BE81;
	Tue, 12 Jul 2022 06:08:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B30804BDFA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 05:35:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OgZP1qrBEaus for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jul 2022 05:35:57 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8281A4BDF5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 05:35:57 -0400 (EDT)
Date: Tue, 12 Jul 2022 11:35:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1657618556;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=fuNSeUYQvm97MKJ0O5peT+0cMDlnixxKy1eEGKJ1U+k=;
 b=b1L3sA6GRS2Ys4OzVNSkYJgfFnfQyrBIk7qpVjh4osS8sVUvGLYOoaSG/aHKHlSXupMqFw
 tGGR6xx6s5nZ3N+XwJXP4D2ZkbSgfsNHn5kebH68twTwrooZrk6zBBqW4o+t4A6Q0CCFu5
 iC3OdfyjmqLwa0tzVpaXzGLVPzefedM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v4 05/13] KVM: selftests: Add missing close and munmap in
 __vm_mem_region_delete
Message-ID: <20220712093555.o4y2nyog4a3gs7tn@kamzik>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-6-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220624213257.1504783-6-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Mailman-Approved-At: Tue, 12 Jul 2022 06:08:56 -0400
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

On Fri, Jun 24, 2022 at 02:32:49PM -0700, Ricardo Koller wrote:
> Deleting a memslot (when freeing a VM) is not closing the backing fd,
> nor it's unmapping the alias mapping. Fix by adding the missing close
> and munmap.
> 
> Reviewed-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 5ee20d4da222..3e45e3776bdf 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -531,6 +531,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
>  	sparsebit_free(&region->unused_phy_pages);
>  	ret = munmap(region->mmap_start, region->mmap_size);
>  	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
> +	if (region->fd >= 0) {
> +		/* There's an extra map when using shared memory. */
> +		ret = munmap(region->mmap_alias, region->mmap_size);
> +		TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
> +		close(region->fd);
> +	}
>  
>  	free(region);
>  }
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
