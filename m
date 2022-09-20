Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADAAEC54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 04:18:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 246A64B086;
	Tue, 20 Sep 2022 00:18:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6nBKuKc8MXhq; Tue, 20 Sep 2022 00:18:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1E8C4B62A;
	Tue, 20 Sep 2022 00:18:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C1B44B2A1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:18:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DpSMz14wBJyq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 00:18:38 -0400 (EDT)
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com
 [209.85.210.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A5C64B086
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:18:38 -0400 (EDT)
Received: by mail-pf1-f182.google.com with SMTP id a29so1591677pfk.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 21:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=sT85PPJDMIUQ7R7Q3NusZpxdWq+tkTiSajuOq6lWzrQ=;
 b=drfXNgOm5vJyFtMrwuUGv3mI5+wvhMaHzZTpadCRE7uBFMEgI6pWpJWsUahDX6ma6l
 oQeEZXvfEq8yRLzm7jGXaSUCdaZ74t0KBDukB81bHrzXwmnkFJefXfU/sSh+yKadNyjU
 KhAgetH0IA3paE/Tidn6Dqh9aFrGM7BQ0I96tDxuF8cAVqop6I8v95haTo3HaScdlQAm
 WU8fZoIcv3vf3RQsvIDKYUtO3LvR09MBzrbiFCtb6LmVaqCAlOpEoRd4YW6lg1V0mXwG
 eeA9jo1apw5umdBVVvgG7+jiOP+EPm8ftrVfNxqyyahjkBBabKT1vHUAKrKXdtQlfNNf
 t/4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=sT85PPJDMIUQ7R7Q3NusZpxdWq+tkTiSajuOq6lWzrQ=;
 b=FjL3gVCODPaJGRfKN56GPnXubjUK+h1FrMNaWRxpnwXif+2w2BQ87ceoWFMu6KGXRd
 FQn2aDfkCxYFszcgEtkDjxuYlMauSPCs0OclF3Tr5l5CHMQDssokZjLeewL1UE2tkCoQ
 kV4wYDtN3JlMwjkRv9j85+vol3PNK1CQCGvUlnM1ext6A5E058x7NlqweEgkkIWF2Aiw
 FOIiREzlp67KuYNOO3dLgz0JD8Y/yLr/YJshSAzujgOZ4zAeC0YG92yY1E5rmK4FyHC7
 sLf955EBW3Rfez9xWwy9gnbuldHa2XlwgdWQcUnwjPAKyROIxIqtcbw+6ZSdfcn1Luxn
 46xw==
X-Gm-Message-State: ACrzQf33hF8nyCV/cmEtibzPZry9YtYlBB6qhd4w3+6z/csG53C23zbm
 AoAs1CAf/u3y9GXEdgPnqyzRdA==
X-Google-Smtp-Source: AMsMyM4911c/ymRrYD6nzN0rUl26tXxXOt0Dg98Xf7Um5/AWf2Jgf2EqCjhnw7lh8+PE+DGOz14Hcw==
X-Received: by 2002:aa7:9851:0:b0:53e:87eb:1ffa with SMTP id
 n17-20020aa79851000000b0053e87eb1ffamr21978311pfq.35.1663647517057; 
 Mon, 19 Sep 2022 21:18:37 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 b124-20020a62cf82000000b0053e6bda08e0sm252170pfg.219.2022.09.19.21.18.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 19 Sep 2022 21:18:36 -0700 (PDT)
Date: Mon, 19 Sep 2022 21:18:32 -0700
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Subject: Re: [PATCH v6 00/13] KVM: selftests: Add aarch64/page_fault_test
Message-ID: <Yyk/GMtOpprLR/zo@google.com>
References: <20220920041509.3131141-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220920041509.3131141-1-ricarkol@google.com>
Cc: maz@kernel.org, bgardon@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com, dmatlack@google.com
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

On Tue, Sep 20, 2022 at 04:14:56AM +0000, Ricardo Koller wrote:
> This series adds a new aarch64 selftest for testing stage 2 fault handling for
> various combinations of guest accesses (e.g., write, S1PTW), backing sources
> (e.g., anon), and types of faults (e.g., read on hugetlbfs with a hole, write
> on a readonly memslot). Each test tries a different combination and then checks
> that the access results in the right behavior (e.g., uffd faults with the right
> address and write/read flag). Some interesting combinations are:
> 
> - loading an instruction leads to a stage 1 page-table-walk that misses on
>   stage 2 because the backing memslot for the page table it not in host memory
>   (a hole was punched right there) and the fault is handled using userfaultfd.
>   The expected behavior is that this leads to a userfaultfd fault marked as a
>   write. See commit c4ad98e4b72c ("KVM: arm64: Assume write fault on S1PTW
>   permission fault on instruction fetch") for why that's a write.
> - a cas (compare-and-swap) on a readonly memslot leads to a failed vcpu run.
> - write-faulting on a memslot that's marked for userfaultfd handling and dirty
>   logging should result in a uffd fault and having the respective bit set in
>   the dirty log.
> 
> The first 8 commits of this series add library support. The first one adds a
> new userfaultfd library. Commits 2-5 add some misc library changes that will be
> used by the new test, like a library function to get the GPA of a PTE. Commits
> 6-8 breaks the implicit assumption that code and page tables live in memslot
> memslots should allocators use. This is then used by the new test to place the
> page tables in a specific memslot.  The last 5 commits add the new selftest,
> one type of test at a time. It first adds core tests, then uffd, then dirty
> logging, then readonly memslots tests, and finally combinations of the previous
> ones (like uffd and dirty logging at the same time).
> 
> v6 -> v7: https://lore.kernel.org/kvmarm/Yyi03sX5hx36M%2FZr@google.com/
> - removed struct kvm_vm_mem_params. Changed page_fault_test.c accordingly. [Sean]
> - applied Oliver's patch to fix page_fault_test compilation warnings. [Oliver]
> - added R-b's from Oliver and Andrew. Didn't Andrew's R-b on 6/13 as the commit
>   changed afterwards.
> 
> v5 -> v6: https://lore.kernel.org/kvmarm/20220823234727.621535-1-ricarkol@google.com/
> - added "enum memslot_type" and all the related cleanups due to it [Andrew]
> - default kvm_vm_mem_default with size=0 [Andrew,Sean]
> - __vm_vaddr_alloc() taking "enum memslot_type" and all the related cleanups
>   due to this change [Andrew]
> 
> v4 -> v5: https://lore.kernel.org/kvmarm/20220624213257.1504783-1-ricarkol@google.com/
> - biggest change: followed suggestion from Sean and Andrew regarding a new
>   arg for vm_create() to specify the guest memory layout. That's taken care
>   of with these two new commits:
> 	KVM: selftests: Use the right memslot for code, page-tables, and data allocations
> 	KVM: selftests: Change ____vm_create() to take struct kvm_vm_mem_params
>   plus the respective changes in the page_fault_test itself (mostly code reduction).
> - dropped some commits that are not needed after the above change:
> 	KVM: selftests: aarch64: Export _virt_pg_map with a pt_memslot arg
> 	KVM: selftests: Add vm_alloc_page_table_in_memslot library function
> 	KVM: selftests: Add vm_mem_region_get_src_fd library function
> - addressed Oliver comments in commit "KVM: selftests: aarch64: Add
>   aarch64/page_fault_test"
> - collect r-b's from Andrew
> 
> Ricardo Koller (13):
>   KVM: selftests: Add a userfaultfd library
>   KVM: selftests: aarch64: Add virt_get_pte_hva() library function
>   KVM: selftests: Add missing close and munmap in
>     __vm_mem_region_delete()
>   KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h
>     macros
>   tools: Copy bitfield.h from the kernel sources
>   KVM: selftests: Stash backing_src_type in struct userspace_mem_region
>   KVM: selftests: Add vm->memslots[] and enum kvm_mem_region_type
>   KVM: selftests: Use the right memslot for code, page-tables, and data
>     allocations
>   KVM: selftests: aarch64: Add aarch64/page_fault_test
>   KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
>   KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
>   KVM: selftests: aarch64: Add readonly memslot tests into
>     page_fault_test
>   KVM: selftests: aarch64: Add mix of tests into page_fault_test
> 
>  tools/include/linux/bitfield.h                |  176 +++
>  tools/testing/selftests/kvm/.gitignore        |    1 +
>  tools/testing/selftests/kvm/Makefile          |    2 +
>  .../selftests/kvm/aarch64/page_fault_test.c   | 1116 +++++++++++++++++
>  .../selftests/kvm/demand_paging_test.c        |  228 +---
>  .../selftests/kvm/include/aarch64/processor.h |   35 +-
>  .../selftests/kvm/include/kvm_util_base.h     |   29 +-
>  .../selftests/kvm/include/userfaultfd_util.h  |   45 +
>  .../selftests/kvm/lib/aarch64/processor.c     |   26 +-
>  tools/testing/selftests/kvm/lib/elf.c         |    3 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    |   82 +-
>  .../selftests/kvm/lib/riscv/processor.c       |    7 +-
>  .../selftests/kvm/lib/s390x/processor.c       |    7 +-
>  .../selftests/kvm/lib/userfaultfd_util.c      |  186 +++
>  .../selftests/kvm/lib/x86_64/processor.c      |   13 +-
>  15 files changed, 1698 insertions(+), 258 deletions(-)
>  create mode 100644 tools/include/linux/bitfield.h
>  create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
>  create mode 100644 tools/testing/selftests/kvm/include/userfaultfd_util.h
>  create mode 100644 tools/testing/selftests/kvm/lib/userfaultfd_util.c
> 
> -- 
> 2.37.3.968.ga6b4b080e4-goog
> 

Please ignore this v6 series (It should have been v7). Sending the real
v7 in a bit. Thanks and sorry for the mess!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
