Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D013C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 14 Oct 2022 21:30:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E62F84B355;
	Fri, 14 Oct 2022 17:30:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dO-TkS62h9zM; Fri, 14 Oct 2022 17:30:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1E4D40762;
	Fri, 14 Oct 2022 17:30:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0C0740762
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 17:30:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AV+3n49EuGe8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Oct 2022 17:30:15 -0400 (EDT)
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com
 [209.85.214.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CBD1840755
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 17:30:15 -0400 (EDT)
Received: by mail-pl1-f177.google.com with SMTP id k9so5456829pll.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 14:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=QGi0Vwe4XVfCKnEn8Yp+c90DTAK2fTVYoQJ19tDWO8uSSQnKJQZ4aq34Vss7MNXlBc
 q8ur6pCNJaqdtHx7rKrI+yT5Qd3HdtEYM8faCMN2yONpCEkPvdewGsKeHAlQMiCrlQjz
 MP8FhuMcOf5h/a5ejMGSNrFgnO1aeDwsVp3KQoikPk6iEQoN5TNcLDQeDf+5Ho+bJfWw
 bSv63zWU9LsGy34Hw25ZB3/f2vHLXqMjfyROLX4huJnAdBuSfXB9K5WEwLcvV7f/b1w6
 Wqiy295UoqZxfGIa7KxhxpbFNrUwA2vGB4oJTD7W7h5T+PiUZxbqw5cvOJ7rFx2nwfr8
 LXHA==
X-Gm-Message-State: ACrzQf0hAMbDAPvP6+j2Z6bWVdr7HvLPRIAs2hs8gVXMiOLGQxjI/x2A
 ZqwGo86HZcY6bPA/1fMHW/Dbaw==
X-Google-Smtp-Source: AMsMyM5ZZxiVnrK/NpY/bh0FFNLfQybRi6b93cxVHKJ5G5do04wwSqHxuNRfRJ2HCeiRqZMhzu3VWg==
X-Received: by 2002:a17:902:8e84:b0:178:71f2:113c with SMTP id
 bg4-20020a1709028e8400b0017871f2113cmr6994097plb.79.1665783014700; 
 Fri, 14 Oct 2022 14:30:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 r27-20020a63205b000000b00412a708f38asm1828522pgm.35.2022.10.14.14.30.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 14 Oct 2022 14:30:14 -0700 (PDT)
Date: Fri, 14 Oct 2022 21:30:10 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v9 00/14] KVM: selftests: Add aarch64/page_fault_test
Message-ID: <Y0nU4vIIyjfQuQGV@google.com>
References: <20221011010628.1734342-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-1-ricarkol@google.com>
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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
