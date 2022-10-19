Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0FC5C87
	for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 23:47:39 +0000 (UTC)
Received: by mail-pg1-f172.google.com with SMTP id 128so17696479pga.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 16:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=yWwPx54+iJPCnEZdo5auu409iNDP67HEfjhuMr9CxYmwVLz308XCYbj779A59wH8FJ
         PfJIE1WYbzClK+HgXILD420rflwaGWe/EiLNIY0HkXxg944kw5lMatHqUkHlhAYvaUJT
         35kTj6uovyHNgras1n6/I2t5IA8mohK81iSMCjz15RkIKFLLs+TDC3d2zPRkf7O67aCJ
         4eN7CFYiuZKz1+At9wmt4pr60UeRLQjYOZ7Ln+OpEp9oHOWbLk97IOmuBtikwsxydCLI
         lRMKtAftDNQCu8s6t/8lXi7yVw6zi+ohEZwD2KK1QIAu6gr8EwJaMyFs+vj+T3VDngIS
         541w==
X-Gm-Message-State: ACrzQf3K8T8iTMihkh3IYk1f9eCQaVI3gkKN8jImjLuFxGWwuwk7G6b4
	tCK5FuMnWCh/ATtjY3nSPIJbTQ==
X-Google-Smtp-Source: AMsMyM62+iL+OA9RwIZDPmQbjrTbDqZbvXHqo7Kkj0k3+p7svo0gNo/pc+9H6Mb/jHd7JFB7WnS0nQ==
X-Received: by 2002:a63:1e05:0:b0:451:31d0:8c0f with SMTP id e5-20020a631e05000000b0045131d08c0fmr9324222pge.227.1666223259315;
        Wed, 19 Oct 2022 16:47:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c28-20020aa7953c000000b0053725e331a1sm11889654pfp.82.2022.10.19.16.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 16:47:38 -0700 (PDT)
Date: Wed, 19 Oct 2022 23:47:35 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
	pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
	eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
	rananta@google.com, bgardon@google.com, dmatlack@google.com,
	axelrasmussen@google.com
Subject: Re: [PATCH v10 00/14] KVM: selftests: Add aarch64/page_fault_test
Message-ID: <Y1CMl3pkulxyjbfw@google.com>
References: <20221017195834.2295901-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
Message-ID: <20221019234735.pw3CtxRS3Pf55yxBmx24LUYwMQdeVdnP00v9dY8a25Q@z>

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
