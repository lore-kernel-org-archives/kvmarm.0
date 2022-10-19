Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CADDDC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 19 Oct 2022 23:47:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5455A4B929;
	Wed, 19 Oct 2022 19:47:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i6hu2ZDr7qWQ; Wed, 19 Oct 2022 19:47:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0667A4B90B;
	Wed, 19 Oct 2022 19:47:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8FC54B900
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 19:47:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fFJpOavTTti0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Oct 2022 19:47:40 -0400 (EDT)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A90B4B8BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 19:47:40 -0400 (EDT)
Received: by mail-pf1-f170.google.com with SMTP id p14so18722213pfq.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 16:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=SMev/lW9fUqeyWhlXOgZuXyCWdyrzKCQD/McomQJ1RA=;
 b=MbpsrN3VudRVHu0Gcx/JefnYoDsxETXGIEIlP76Fk2/9MaHQ5VzkUu0KmaEAJaEOLn
 s1OZDBSarbltkUO3NufRfQQs7rv76vydj6cxIxCK2MV4RqaDr7tjEIfGbX0CqYuPkIxs
 qzkopkWXQYJ7+Cgh+46XvoGlunBB7B3NQEL9ymCbDbdKMbJwfllvxqGRmxkRC8+4SeSv
 HMgyrKynwN2JMyOLDqgh6dv8ZlI7E4gq0/9gJD2wW7dfmyQy57mngHv3/d2aQ7OWZSr9
 sMx8oKKfHtNft9k9ja9zO3bCxFQ1IWsTq1QHCrEN3D6WFfPSBPL7vvJ56Onulo/O+bBi
 u73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=SMev/lW9fUqeyWhlXOgZuXyCWdyrzKCQD/McomQJ1RA=;
 b=hTBzQJUlLn5mOSlH40MG9muo6aK4CLNoiMBBoQ7p9B4hn320VQuzW+ykYkF8gXRsqh
 6qTHb4xbvyo2NgSvYDERZOeKa2FiNIHCFQ3Ue7yTI4q971DqojyxlJJm24cES6uW7ZgY
 ncLpouNbZjrzm7zVYOQsl+TJld0OJKTVV5FF48uRRp4i1BXZ0q+ZSobc1rtgVemNa09c
 fldgaouDsWOihDeXVxCNILAPLLse4XR5iWGGkmD5i7CGi+8EG++Uzcf+w4m+SlnGFgE5
 7vFLjX4LyKMnQoDi5VgUlDdU9drANLRqpl+JTarLufCrhphjDmnm9VnM4CfEM56uwWn4
 Q+QQ==
X-Gm-Message-State: ACrzQf1l3UBqub2Ot+HRW7yhOcMBXvin3aXP0mrLvyOFg6ZP8NB4V5WG
 Qoyitrez8sMYnSCp83kHgMrFww==
X-Google-Smtp-Source: AMsMyM62+iL+OA9RwIZDPmQbjrTbDqZbvXHqo7Kkj0k3+p7svo0gNo/pc+9H6Mb/jHd7JFB7WnS0nQ==
X-Received: by 2002:a63:1e05:0:b0:451:31d0:8c0f with SMTP id
 e5-20020a631e05000000b0045131d08c0fmr9324222pge.227.1666223259315; 
 Wed, 19 Oct 2022 16:47:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 c28-20020aa7953c000000b0053725e331a1sm11889654pfp.82.2022.10.19.16.47.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 19 Oct 2022 16:47:38 -0700 (PDT)
Date: Wed, 19 Oct 2022 23:47:35 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v10 00/14] KVM: selftests: Add aarch64/page_fault_test
Message-ID: <Y1CMl3pkulxyjbfw@google.com>
References: <20221017195834.2295901-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu, dmatlack@google.com
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

On Mon, Oct 17, 2022, Ricardo Koller wrote:
> This series adds a new aarch64 selftest for testing stage 2 fault handling
> for various combinations of guest accesses (e.g., write, S1PTW), backing
> sources (e.g., anon), and types of faults (e.g., read on hugetlbfs with a
> hole, write on a readonly memslot). Each test tries a different combination
> and then checks that the access results in the right behavior (e.g., uffd
> faults with the right address and write/read flag). Some interesting
> combinations are:

...

> Ricardo Koller (14):
>   KVM: selftests: Add a userfaultfd library
>   KVM: selftests: aarch64: Add virt_get_pte_hva() library function
>   KVM: selftests: Add missing close and munmap in
>     __vm_mem_region_delete()
>   KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h
>     macros
>   tools: Copy bitfield.h from the kernel sources
>   KVM: selftests: Stash backing_src_type in struct userspace_mem_region
>   KVM: selftests: Add vm->memslots[] and enum kvm_mem_region_type
>   KVM: selftests: Fix alignment in virt_arch_pgd_alloc() and
>     vm_vaddr_alloc()
>   KVM: selftests: Use the right memslot for code, page-tables, and data
>     allocations
>   KVM: selftests: aarch64: Add aarch64/page_fault_test
>   KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
>   KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
>   KVM: selftests: aarch64: Add readonly memslot tests into
>     page_fault_test
>   KVM: selftests: aarch64: Add mix of tests into page_fault_test

One alignment nit in the first patch, but definitely not worthy of a v11.  If it
gets fixed up when applying, yay.  If not, no big deal.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
