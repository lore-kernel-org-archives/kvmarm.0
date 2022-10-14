Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513124680
	for <kvmarm@lists.linux.dev>; Fri, 14 Oct 2022 21:30:15 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id c24so5871149pls.9
        for <kvmarm@lists.linux.dev>; Fri, 14 Oct 2022 14:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UaGZO5Hv6UO255nOsoKhnllnauSBkcqiuPiJxTDzjd0=;
        b=eLxbHnR+/Z0k38LQnsiu5GDDZYfLK1u8OX6UY90/yfUgW+27vqBsqXb8bCgtxbI5fh
         lgsWlvg8UEl9D+vdBm8p0JHe8QTEZLpD9uidBNQHB1UJ6Iutl7Ei5BQN38KSXT3r0Hrc
         wdL4oJQTCUk8iJfzvh+hsIEWpknOq9iY0mc6ekYsF4KfWLdersIn4WMWo3/te0V0V464
         OYXHMKslBz0+Ic1+K+93oHYnvp4U1RoegOTolMGhZ7PHNn4VH93CoXE2fwEgmXh97yrG
         rCeuvLu6YqMN4iTW47LO4DgBthdQ6Idt0LUJyRn3L/0Kl5tglDnwJVMuQO9ngGn+Ae7H
         Ld0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UaGZO5Hv6UO255nOsoKhnllnauSBkcqiuPiJxTDzjd0=;
        b=oGqACIENJJ4LR0A/+5Em32lha5Bdeju0GNuVlmdB0P3qkHbV7ILaAwUd8sng6Y3J0p
         WamVMASeAQCBZavcfwdRjJc2v5Jcz6wpqmnaoj5ZEw/af3yNAO3TpxGzosr1bSBCy0xA
         hOmciGMm54fT1ry4q2J75JHpd3cggXm4TaAih7ZgxuCfVldOk07ZsYXOVrJuq78ZpIjJ
         4uhR2LetfK1qEkQgxkiBBvnbaZzV1eclKCh7pzuij9Va7bOwoV6csdmaz4ECty+Vd7s5
         1+4U8MS7BUwy2r+GodihGP78c5NjxGHvXvNlVZPwLegoRVgjJ3JDFzar2SnRlRDY2SI6
         Xw3Q==
X-Gm-Message-State: ACrzQf3y+0l6XgVeIH9w303667XGKbk/YeOluKgZhI7IWW5aVQYjeY1/
	JcV0WDYfhR9R61y7hgu4Bbd29A==
X-Google-Smtp-Source: AMsMyM5ZZxiVnrK/NpY/bh0FFNLfQybRi6b93cxVHKJ5G5do04wwSqHxuNRfRJ2HCeiRqZMhzu3VWg==
X-Received: by 2002:a17:902:8e84:b0:178:71f2:113c with SMTP id bg4-20020a1709028e8400b0017871f2113cmr6994097plb.79.1665783014700;
        Fri, 14 Oct 2022 14:30:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id r27-20020a63205b000000b00412a708f38asm1828522pgm.35.2022.10.14.14.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:30:14 -0700 (PDT)
Date: Fri, 14 Oct 2022 21:30:10 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
	pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
	eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
	rananta@google.com, bgardon@google.com, dmatlack@google.com,
	axelrasmussen@google.com
Subject: Re: [PATCH v9 00/14] KVM: selftests: Add aarch64/page_fault_test
Message-ID: <Y0nU4vIIyjfQuQGV@google.com>
References: <20221011010628.1734342-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-1-ricarkol@google.com>
Message-ID: <20221014213010.h4T4f-0NjZqwJU8HBtJY4xkzupS1jyv9nWfnye3L6oI@z>

On Tue, Oct 11, 2022, Ricardo Koller wrote:
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

A bunch of nits, mostly about alignment/indentation, but otherwise no more whining
on my end.  A v10 would probably be nice to avoid churn?  But I'm also ok if y'all
want to merge this asap and do the cleanup on top.
